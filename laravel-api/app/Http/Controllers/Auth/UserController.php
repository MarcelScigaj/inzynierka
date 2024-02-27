<?php
namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use App\Mail\UserCreated;
use App\Mail\TrainerCreated;
use App\Models\GrupaTreningowa;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function create(Request $request)
    {
        $validatedData = $request->validate([
            'imie' => 'required|max:50',
            'nazwisko' => 'required|max:100',
            'email' => 'required|email',
            'grupa' => 'required',
        ]);

        // Logika tworzenia konta dziecka i rodzica
        $childLogin = Str::random(10);
        $childPassword = Str::random(10);
        $parentLogin = Str::random(10);
        $parentPassword = Str::random(10);

        $grupa = GrupaTreningowa::where('nazwa', $validatedData['grupa'])->firstOrFail();

        

        $childAccount = User::create([
            'imie' => $validatedData['imie'],
            'nazwisko' => $validatedData['nazwisko'],
            'login' => $childLogin,
            'haslo' => Hash::make($childPassword),
            'grupa_id' => $grupa->id,
            'rola' => 'dziecko',
            
        ]);


        $existingParentAccount = User::where('email', $validatedData['email'])
                              ->where('rola', 'rodzic')
                              ->first();



       if (!$existingParentAccount) {
            $parentAccount = User::create([
                'email' => $validatedData['email'],
                'login' => $parentLogin,
                'haslo' => Hash::make($parentPassword),
                'rola' => 'rodzic',
                
            ]);

            // Wysyłanie emaila z danymi obu kont (rodzica i dziecka)
            Mail::to($validatedData['email'])->send(new UserCreated($childAccount, $childLogin, $childPassword, $parentAccount, $parentLogin, $parentPassword));

        } else {
            $parentAccount = $existingParentAccount;

            // Wysyłanie emaila tylko z danymi konta dziecka
             Mail::to($validatedData['email'])->send(new UserCreated($childAccount, $childLogin, $childPassword));


        }

        DB::table('rodzic_dziecko')->insert([
            'rodzic_id' => $parentAccount->id,
            'dziecko_id' => $childAccount->id,
        ]);


        DB::table('grupa_treningowa_uzytkownik')->insert([
    'grupa_treningowa_id' => $grupa->id,
    'uzytkownik_id' => $childAccount->id,
]);



       
        return response()->json(['message' => 'Rejestracja powiodła się', 'child_user' => $childAccount, 'parent_user' => $parentAccount]);
    }

   

    public function createTrainer(Request $request)
{
    $validatedData = $request->validate([
        'imie' => 'required|max:50',
        'nazwisko' => 'required|max:100',
        'email' => 'required|email|unique:uzytkownik,email',
    ]);

    $login = Str::random(10);
    $password = Str::random(10);

    $trainer = User::create([
        'imie' => $validatedData['imie'],
        'nazwisko' => $validatedData['nazwisko'],
        'email' => $validatedData['email'],
        'login' => $login,
        'haslo' => Hash::make($password),
        'rola' => 'trener',
        'aktywowane' => false,
    ]);

    Mail::to($validatedData['email'])->send(new TrainerCreated($validatedData['imie'], $validatedData['nazwisko'], $login, $password));



    return response()->json(['message' => 'Konto trenera utworzone pomyślnie', 'user' => $trainer]);
}






    public function getGrupyTreningowe()
{
    $grupy = GrupaTreningowa::all();
    return response()->json(['grupy' => $grupy]);
}











public function update(Request $request)
{
    // Pobierz zalogowanego użytkownika
    $user = $request->user();

    // Definiowanie reguł walidacji
    $rules = [
        'login' => 'required|unique:uzytkownik,login,' . $user->id,
        'email' => 'required|email|unique:uzytkownik,email,' . $user->id,
        'haslo' => ['sometimes',
                    'nullable',
                    'min:8', 
                    'max:32',
                    'regex:/[a-z]/', 
                    'regex:/[A-Z]/', 
                    'regex:/[0-9]/' 
         ],
        'nazwisko' => 'sometimes|nullable',
        'telefon' => 'sometimes|nullable',
    ];

    $messages = [
        'haslo.min' => 'Hasło musi zawierać przynajmniej 8 znaków.',
        'haslo.regex' => 'Hasło musi zawierać przynajmniej jedną małą literę, jedną dużą literę i jedną cyfrę.',
    ];

    // Walidacja danych
    $validator = Validator::make($request->all(), $rules, $messages);

    // Sprawdzenie, czy walidacja się powiodła
    if ($validator->fails()) {
        return response()->json(['errors' => $validator->errors()], 422);
    }

    // Obsługa przesyłania awatara
    
    if ($request->hasFile('avatar')) {
        $validator = Validator::make($request->all(), [
            'avatar' => 'image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        if ($validator->fails()) {
            \Log::error('Błąd przesyłania awatara', $validator->errors()->all());
            return response()->json(['errors' => $validator->errors()], 422);
        }

        
        // Usuń stary awatar, jeśli istnieje
    $oldAvatarPath = str_replace('/storage/', '', $user->avatarUrl);
    if ($user->avatarUrl && Storage::disk('public')->exists($oldAvatarPath)) {
        Storage::disk('public')->delete($oldAvatarPath);
    }


        $avatar = $request->file('avatar');
        $filename = time() . '.' . $avatar->getClientOriginalExtension();
        $path = $avatar->storeAs('avatars', $filename, 'public');
        $user->avatarUrl = '/storage/' . $path;
    }

    // Aktualizacja danych użytkownika
    $user->login = $request->input('login');
    $user->email = $request->input('email');
    if ($request->filled('haslo')) {
        $user->haslo = Hash::make($request->input('haslo'));
    }
    $user->imie = $request->input('imie', $user->imie);
    $user->nazwisko = $request->input('nazwisko', $user->nazwisko);
    $user->telefon = $request->input('telefon', $user->telefon);

    // Zapisz zmiany
    $user->save();


    \Log::info('Avatar przesłany: ' . $request->hasFile('avatar'));

    // Zwróć zaktualizowane dane użytkownika
    return response()->json(['message' => 'Dane użytkownika zaktualizowane', 'user' => $user]);
}


    

    public function getTrenerGrupyTreningowe() {
        $trenerId = auth()->id(); // Pobranie ID zalogowanego użytkownika
        $grupy = GrupaTreningowa::where('uzytkownik_id', $trenerId)->get();
        return response()->json($grupy);
    }






public function getUserGroups($userId)
{
    $userGroups = DB::table('grupa_treningowa_uzytkownik')
                    ->join('grupa_treningowa', 'grupa_treningowa_uzytkownik.grupa_treningowa_id', '=', 'grupa_treningowa.id')
                    ->where('grupa_treningowa_uzytkownik.uzytkownik_id', $userId)
                    ->select('grupa_treningowa.*')
                    ->get();

    return response()->json(['grupy' => $userGroups]);
}

public function getUserGroupsForParent($userId) {
    $childIds = DB::table('rodzic_dziecko')->where('rodzic_id', $userId)->pluck('dziecko_id');

    $userGroups = DB::table('grupa_treningowa_uzytkownik')
                    ->join('grupa_treningowa', 'grupa_treningowa_uzytkownik.grupa_treningowa_id', '=', 'grupa_treningowa.id')
                    ->whereIn('grupa_treningowa_uzytkownik.uzytkownik_id', $childIds)
                    ->select('grupa_treningowa.id')
                    ->distinct()
                    ->get()
                    ->toArray(); 

    // Zwracanie danych w oczekiwanym formacie
    return response()->json(['grupy' => $userGroups]);
}



}