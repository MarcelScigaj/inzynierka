<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Trening;
use Illuminate\Http\Request;
use Carbon\Carbon;
use App\Models\GrupaTreningowa;

class TreningController extends Controller
{
    public function store(Request $request)
    {

                \Log::info($request->all());

                $validated = $request->validate([
                    'nazwa' => 'required|string|max:255',
                    'data' => 'required|date',
                    'godzina' => 'required',
                    'grupa_treningowa_id' => 'required|integer',
                    'cwiczenia' => 'required|array'
                ]);


                $dataGodzinaTreninguStart = Carbon::createFromFormat('Y-m-d H:i', $validated['data'] . ' ' . $validated['godzina']);
                $dataGodzinaTreninguKoniec = (clone $dataGodzinaTreninguStart)->addHour();

                // Sprawdzenie, czy grupa treningowa ma już zaplanowany trening tego samego dnia
                $istniejeTreningGrupyTegoDnia = Trening::where('grupa_treningowa_id', $validated['grupa_treningowa_id'])
                    ->whereDate('data', $validated['data'])
                    ->exists();

                if ($istniejeTreningGrupyTegoDnia) {
                    return response()->json(['error' => 'Ta grupa ma już zaplanowany trening na ten dzień.'], 409);
                }

                // Pobranie trenera na podstawie grupy treningowej
                $grupaTreningowa = GrupaTreningowa::findOrFail($validated['grupa_treningowa_id']);
                $trenerId = $grupaTreningowa->uzytkownik_id;

                // Sprawdzenie, czy termin nie koliduje z innymi treningami trenera
                $konfliktTerminu = Trening::where('uzytkownik_id', $trenerId)
                    ->where(function ($query) use ($dataGodzinaTreninguStart, $dataGodzinaTreninguKoniec) {
                        $query->whereBetween('godzina', [$dataGodzinaTreninguStart->format('H:i:s'), $dataGodzinaTreninguKoniec->format('H:i:s')])
                            ->orWhereBetween('godzina', [$dataGodzinaTreninguStart->subHour()->format('H:i:s'), $dataGodzinaTreninguKoniec->addHour()->format('H:i:s')]);
                    })
                    ->whereDate('data', $validated['data'])
                    ->exists();

                if ($konfliktTerminu) {
                    return response()->json(['error' => 'Konflikt terminów. Trener ma już zaplanowany trening w wybranym terminie.'], 409);
                }


                try {
                    $trening = new Trening($request->all());
                // Przypisz zalogowanego użytkownika (trenera) do treningu
                    $trening->uzytkownik_id = auth()->id();
                    $trening->save();
                    $trening->cwiczenia()->attach($request->cwiczenia);
            
                    return response()->json(['message' => 'Trening został pomyślnie utworzony.', 'data' => $trening], 201);
                // return response()->json($trening, 201);
                } catch (\Exception $e) {
                    \Log::error("Błąd przy tworzeniu treningu: " . $e->getMessage()); // Log błędu
                    return response()->json(['error' => 'Wystąpił błąd podczas tworzenia treningu.'], 500);
                }
            }

            public function index(Request $request)
            {
                $query = Trening::with(['grupaTreningowa', 'cwiczenia']);
            
                if ($request->has(['startDate', 'endDate'])) {
                    $startDate = $request->startDate;
                    $endDate = $request->endDate;
                    $query->whereDate('data', '>=', $startDate)
                          ->whereDate('data', '<=', $endDate);
                }
            

                $treningi = $query->orderBy('data', 'desc')
                ->orderBy('godzina', 'desc')
                ->get(); 
                
                return response()->json($treningi);
            }
            

    

    public function update(Request $request, $id)
{
    $trening = Trening::findOrFail($id);

    if (auth()->id() !== $trening->uzytkownik_id && !auth()->user()->isAdmin()) {
        return response()->json(['error' => 'Nie masz uprawnień do edycji tego treningu.'], 403);
    }

    $validated = $request->validate([
        'nazwa' => 'required|string|max:255',
        'data' => 'required|date',
        'godzina' => 'required',
        'grupa_treningowa_id' => 'required|integer',
        'cwiczenia' => 'sometimes|array'
    ]);

    // Formatowanie daty i godziny w sposób konsystentny z metodą store
    $dataGodzina = Carbon::createFromFormat('Y-m-d H:i', $validated['data'] . ' ' . $validated['godzina']);

    if (Carbon::now()->isAfter($dataGodzina)) {
        return response()->json(['error' => 'Nie można ustawić treningu na datę i godzinę w przeszłości.'], 400);
    }

    $validated['data'] = $dataGodzina->format('Y-m-d');
    $validated['godzina'] = $dataGodzina->format('H:i:s');

    // Sprawdzenie, czy grupa treningowa ma już zaplanowany trening na ten dzień, z wyjątkiem aktualizowanego treningu
    $istniejeTreningGrupyTegoDnia = Trening::where('grupa_treningowa_id', $validated['grupa_treningowa_id'])
        ->whereDate('data', $validated['data'])
        ->where('id', '!=', $id)
        ->exists();

    if ($istniejeTreningGrupyTegoDnia) {
        return response()->json(['error' => 'Ta grupa ma już zaplanowany trening na ten dzień.'], 409);
    }

    $grupaTreningowa = GrupaTreningowa::findOrFail($validated['grupa_treningowa_id']);
    $trenerId = $grupaTreningowa->uzytkownik_id;

    $konfliktTerminu = Trening::where('uzytkownik_id', $trenerId)
        ->where('id', '!=', $id)
        ->where(function ($query) use ($dataGodzina) {
            $query->whereBetween('godzina', [$dataGodzina->format('H:i:s'), $dataGodzina->addHour()->format('H:i:s')])
                  ->orWhereBetween('godzina', [$dataGodzina->subHour()->format('H:i:s'), $dataGodzina->format('H:i:s')]);
        })
        ->whereDate('data', $validated['data'])
        ->exists();

    if ($konfliktTerminu) {
        return response()->json(['error' => 'Konflikt terminów. Trener ma już zaplanowany trening w wybranym terminie.'], 409);
    }

    try {
        $trening->update($validated);
        if (isset($validated['cwiczenia'])) {
            $trening->cwiczenia()->sync($validated['cwiczenia']);
        }
        return response()->json(['success' => 'Trening został pomyślnie zaktualizowany.', 'data' => $trening], 200);
    } catch (\Exception $e) {
        \Log::error("Błąd przy aktualizacji treningu: " . $e->getMessage());
        return response()->json(['error' => 'Wystąpił błąd podczas aktualizacji treningu.'], 500);
    }
}



public function destroy($id)
    {
        $trening = Trening::findOrFail($id);

        // Upewnij się, że użytkownik jest właścicielem treningu lub adminem
        if (auth()->id() !== $trening->uzytkownik_id && !auth()->user()->isAdmin()) {
            return response()->json(['error' => 'Nie masz uprawnień do usunięcia tego treningu.'], 403);
        }

        $trening->delete();

        return response()->json(['message' => 'Trening usunięty pomyślnie']);
    }



}
