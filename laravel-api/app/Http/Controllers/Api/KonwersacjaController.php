<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Konwersacja;
use App\Models\User;
use App\Models\GrupaTreningowa;
use Illuminate\Support\Facades\DB; 


class KonwersacjaController extends Controller
{


public function index()
{
    $userId = auth()->id(); // Pobieranie ID zalogowanego użytkownika.

    $konwersacje = Konwersacja::whereHas('uczestnicy', function ($query) use ($userId) {
        $query->where('uzytkownik_id', $userId);
    })
    ->with(['uczestnicy' => function($query) {
        // Upewnij się, że ładujesz również avatarUrl dla każdego uczestnika
        $query->addSelect(['id', 'imie', 'nazwisko', 'avatarUrl']);
    }, 'wiadomosci' => function($query) {
        $query->orderBy('dataWyslania', 'desc');
    }])
    ->get()
    ->map(function ($konwersacja) use ($userId) {
        // Znajdź pierwszego uczestnika, który nie jest zalogowanym użytkownikiem
        $otherParticipant = $konwersacja->uczestnicy->first(function($participant) use ($userId) {
            return $participant->id !== $userId;
        });

        $nazwa = $otherParticipant ? "{$otherParticipant->imie} {$otherParticipant->nazwisko}" : 'Konwersacja grupowa';
        $ostatniaWiadomosc = $konwersacja->wiadomosci->first();

        return [
            'id' => $konwersacja->id,
            'nazwa' => $nazwa,
            'uczestnicy' => $konwersacja->uczestnicy->map(function ($uczestnik) {
                return ['id' => $uczestnik->id, 
                'imie' => $uczestnik->imie, 
                'nazwisko' => $uczestnik->nazwisko,
                'avatarUrl' => $uczestnik->avatarUrl ? asset( $uczestnik->avatarUrl) : null,
            ];
            })->toArray(),
            'ostatniaWiadomosc' => $ostatniaWiadomosc ? $ostatniaWiadomosc->tresc : null,
            'dataOstatniejWiadomosci' => $ostatniaWiadomosc ? $ostatniaWiadomosc->dataWyslania->toDateTimeString() : null,
        ];
    });

    return response()->json($konwersacje);
}


public function store(Request $request)
{
    $currentUserId = auth()->id();
    $selectedUserId = $request->uzytkownik_id;

    // Sprawdzenie, czy konwersacja między użytkownikami już istnieje
    $existingConversation = Konwersacja::whereHas('uczestnicy', function ($query) use ($currentUserId, $selectedUserId) {
        $query->where('uzytkownik_id', $currentUserId);
    })->whereHas('uczestnicy', function ($query) use ($selectedUserId) {
        $query->where('uzytkownik_id', $selectedUserId);
    })->first();

    if ($existingConversation) {
        return response()->json(['message' => 'Konwersacja już istnieje', 'konwersacja' => $existingConversation], 409);
    }

    // Kontynuacja tworzenia nowej konwersacji, jeśli nie istnieje
    $konwersacja = Konwersacja::create([
        'typ' => $request->typ,
        'grupa_treningowa_id' => $request->grupa_treningowa_id
    ]);

    DB::table('uzytkownik_konwersacja')->insert([
        ['uzytkownik_id' => $currentUserId, 'konwersacja_id' => $konwersacja->id],
        ['uzytkownik_id' => $selectedUserId, 'konwersacja_id' => $konwersacja->id],
    ]);

    return response()->json($konwersacja);
}

    public function show($id)
    {
        $konwersacja = Konwersacja::with(['wiadomosci', 'uczestnicy'])->findOrFail($id);
        return response()->json($konwersacja);
    }

    public function update(Request $request, $id)
    {
        $konwersacja = Konwersacja::findOrFail($id);
        $validated = $request->validate([
            'typ' => 'required|in:prywatna,grupowa',
            'grupa_treningowa_id' => 'nullable|exists:grupa_treningowa,id'
        ]);

        $konwersacja->update($validated);
        return response()->json($konwersacje);
    }

    public function destroy($id)
    {
        $konwersacja = Konwersacja::findOrFail($id);
        $konwersacja->delete();
        return response()->json(['message' => 'Konwersacja została usunięta']);
    }


    public function getUsersForConversation(Request $request, $userId) {
        $userRole = $request->user()->rola; // Pobranie roli zalogowanego użytkownika
        $users = collect();
    
        switch ($userRole) {
            case 'Trener':
                // Pobieranie wszystkich użytkowników (dzieci) przypisanych do grup treningowych prowadzonych przez trenera
                $grupyIds = GrupaTreningowa::where('uzytkownik_id', $userId)->pluck('id');
                $uczestnicy = DB::table('grupa_treningowa_uzytkownik')
                                ->whereIn('grupa_treningowa_id', $grupyIds)
                                ->join('uzytkownik', 'grupa_treningowa_uzytkownik.uzytkownik_id', '=', 'uzytkownik.id')
                                ->select('uzytkownik.id', 'uzytkownik.imie', 'uzytkownik.nazwisko', 'uzytkownik.rola', 'grupa_treningowa_uzytkownik.grupa_treningowa_id')
                                ->get();
    
                foreach ($uczestnicy as $uczestnik) {
                    $grupa = GrupaTreningowa::find($uczestnik->grupa_treningowa_id);
                    $roleSuffix = ($uczestnik->rola === 'rodzic') ? " (R)" : "";
                    $groupName = " (" . $grupa->nazwa . ")";
                    $users->push([
                        'id' => $uczestnik->id,
                        'name' => $uczestnik->imie . ' ' . $uczestnik->nazwisko . $groupName . $roleSuffix,
                    ]);
                }
    
                // Dodanie rodziców dzieci do listy użytkowników, jeżeli nie zostali dodani w poprzednim kroku
                $rodzicIds = DB::table('rodzic_dziecko')->pluck('rodzic_id')->unique();
            foreach ($rodzicIds as $rodzicId) {
                $dzieciIds = DB::table('rodzic_dziecko')->where('rodzic_id', $rodzicId)->pluck('dziecko_id');
                $grupyDzieci = DB::table('grupa_treningowa_uzytkownik')->whereIn('uzytkownik_id', $dzieciIds)->pluck('grupa_treningowa_id')->unique();
                foreach ($grupyDzieci as $grupaId) {
                    $grupa = GrupaTreningowa::find($grupaId);
                    $rodzic = User::find($rodzicId);
                    if ($rodzic && !isset($users[$rodzic->id])) { // Sprawdź, czy rodzic nie został już dodany
                        $users->push([
                            'id' => $rodzic->id,
                            'name' => $rodzic->imie . ' ' . $rodzic->nazwisko . " (" . $grupa->nazwa . ") (R)",
                        ]);
                    }
                }
            }
            break;
    
            case 'dziecko':
                $userGrupaIds = DB::table('grupa_treningowa_uzytkownik')
                                  ->where('uzytkownik_id', $userId)
                                  ->pluck('grupa_treningowa_id');
    

                       // Dodajemy trenera z grupy treningowej
    $trenerzyIds = GrupaTreningowa::whereIn('id', $userGrupaIds)->pluck('uzytkownik_id');
    $trenerzy = User::whereIn('id', $trenerzyIds)->get();

    foreach ($trenerzy as $trener) {
        if ($trener->id != $userId) { // Wykluczając samego siebie, jeśli dziecko jest również oznaczone jako trener (teoretyczna sytuacja)
            $users->push([
                'id' => $trener->id,
                'name' => $trener->imie . ' ' . $trener->nazwisko,
            ]);
        }
    }
          
                

                // Pobieranie trenera i innych dzieci z grupy
                $uczestnicyGrupy = DB::table('grupa_treningowa_uzytkownik')
                                     ->whereIn('grupa_treningowa_id', $userGrupaIds)
                                     ->join('uzytkownik', 'grupa_treningowa_uzytkownik.uzytkownik_id', '=', 'uzytkownik.id')
                                     ->select('uzytkownik.id', 'uzytkownik.imie', 'uzytkownik.nazwisko', 'uzytkownik.rola')
                                     ->where('uzytkownik.id', '<>', $userId) // Wykluczenie samego siebie
                                     ->get();
    
                foreach ($uczestnicyGrupy as $uczestnik) {
                    $users->push([
                        'id' => $uczestnik->id,
                        'name' => $uczestnik->imie . ' ' . $uczestnik->nazwisko,
                    ]);
                }
                break;
    
            case 'rodzic':
                // Pobieranie trenerów grup, do których należą dzieci
                $dzieciIds = DB::table('rodzic_dziecko')->where('rodzic_id', $userId)->pluck('dziecko_id');
                $grupyIds = DB::table('grupa_treningowa_uzytkownik')->whereIn('uzytkownik_id', $dzieciIds)->pluck('grupa_treningowa_id');
                $trenerzyIds = GrupaTreningowa::whereIn('id', $grupyIds)->pluck('uzytkownik_id');
    
                $trenerzy = User::whereIn('id', $trenerzyIds)->get();
                foreach ($trenerzy as $trener) {
                    $users->push([
                        'id' => $trener->id,
                        'name' => $trener->imie . ' ' . $trener->nazwisko . ' (' . 'Trener' . ')',
                    ]);
                }
                $dzieci = User::whereIn('id', $dzieciIds)->get();
    foreach ($dzieci as $dziecko) {
        $users->push([
            'id' => $dziecko->id,
            'name' => $dziecko->imie . ' ' . $dziecko->nazwisko . ' (' . 'Dziecko' . ')',
        ]);
    }

    break;
        }
    
        return response()->json($users->unique('id')->values());
    }
    

}
