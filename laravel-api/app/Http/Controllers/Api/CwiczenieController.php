<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Cwiczenie;
use App\Models\Tutorial;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;
use Symfony\Component\HttpFoundation\Response;


use Illuminate\Support\Facades\Log;


class CwiczenieController extends Controller
{


// Wyświetlanie wszystkich ćwiczeń
public function index()
{
$cwiczenia = Cwiczenie::with('tutorials')->get();
return response()->json($cwiczenia);
}



//Zapisywanie nowgo cwiczenia
public function store(Request $request)
{
// Podstawowa walidacja
$validatedData = $request->validate([
'nazwa' => 'required|string|max:255',
'opis' => 'nullable|string',
'rodzaj' => 'required|array|max:255',
]);


// Przekształcenie tablicy 'rodzaj' na string
$rodzajString = implode(',', $request->rodzaj);

// Warunkowa walidacja dla plików
if ($request->hasFile('zdjecie')) {
$request->validate([
'zdjecie' => 'file|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
]);
}

if ($request->hasFile('film')) {
$request->validate([
'film' => 'file|mimes:mp4,avi,wmv|max:20480', // 20 MB jako maksymalny rozmiar pliku
]);
}

$cwiczenie = new Cwiczenie([
    'nazwa' => $validatedData['nazwa'],
    'opis' => $validatedData['opis'],
    'rodzaj' => $rodzajString, 
]);
$cwiczenie->save();

$sciezkaZdjecie = $request->hasFile('zdjecie') ? $request->file('zdjecie')->store("public/cwiczenia/{$cwiczenie->id}") : null;
$sciezkaFilm = $request->hasFile('film') ? $request->file('film')->store("public/cwiczenia/{$cwiczenie->id}") : null;

// Zapisywanie ścieżek w bazie danych (jako nowy rekord w tabeli tutorial)
if ($sciezkaZdjecie || $sciezkaFilm) {
$cwiczenie->tutorials()->create([
'sciezka_zdjecie' => str_replace('public/', 'storage/', $sciezkaZdjecie),
'sciezka_film' => str_replace('public/', 'storage/', $sciezkaFilm),

]);
}

return response()->json(['message' => 'Ćwiczenie stworzone pomyślnie', 'cwiczenie' => $cwiczenie], 201);


}


// Wyświetlanie szczegółów ćwiczenia
public function show($id)
{
$cwiczenie = Cwiczenie::with('tutorials')->findOrFail($id);
return response()->json($cwiczenie);
}


// Aktualizacja ćwiczenia
public function update(Request $request, $id)
{
$cwiczenie = Cwiczenie::findOrFail($id);

$validated = $request->validate([
'nazwa' => 'string|max:255',
'opis' => 'nullable|string',
'rodzaj' => 'array|max:3',
// Dodatkowe walidacje dla 'zdjecie' i 'film' jeśli wymagane
]);

$cwiczenie->update($validated);

// Logika aktualizacji zdjęcia i filmu analogicznie do metody store

return response()->json(['message' => 'Ćwiczenie zaktualizowane pomyślnie', 'cwiczenie' => $cwiczenie]);
}

// Usuwanie ćwiczenia
public function destroy($id)
{
$cwiczenie = Cwiczenie::findOrFail($id);
$cwiczenie->delete();

return response()->json(['message' => 'Ćwiczenie usunięte pomyślnie']);
}


public function streamVideo($path)
{
    // Dekodowanie ścieżki i przygotowanie pełnej ścieżki dostępu do pliku
    $decodedPath = urldecode($path);
    // Uwaga: Upewnij się, że ścieżka jest poprawna i dostosowana do struktury Twojego projektu
    $fullPath = storage_path("app/public/{$decodedPath}");


    // Sprawdzenie, czy plik istnieje
    if (!file_exists($fullPath)) {
        return response()->json(['message' => 'Plik wideo nie został znaleziony.'], 404);
    }

    $size = filesize($fullPath);
    $time = date('r', filemtime($fullPath));

    $range = request()->header('Range');
    if ($range) {
        list($start, $end) = explode('-', substr($range, 6), 2) + [0];
        $end = ($end === '') ? $size - 1 : min(abs(intval($end)), $size - 1);
        $start = ($start === '') ? 0 : max(abs(intval($start)), 0);

        if ($start > $end) {
            return response(null, 416)->header('Content-Range', "bytes */$size");
        }

        $length = $end - $start + 1;
        $file = fopen($fullPath, 'rb');
        fseek($file, $start);
        $data = fread($file, $length);
        fclose($file);

        return response($data)
            ->header('Content-Type', 'video/mp4')
            ->header('Content-Range', "bytes $start-$end/$size")
            ->header('Accept-Ranges', 'bytes')
            ->header('Content-Length', $length)
            
            ->header('Cache-Control', 'no-cache')
            ->header('Content-Disposition', 'inline; filename="' . basename($fullPath) . '"')
            ->header('Last-Modified', $time)
            ->status(206);
    } else {
        return response()->file($fullPath, [
            'Content-Type' => 'video/mp4',
            'Accept-Ranges' => 'bytes',
            'Last-Modified' => $time,
        ]);
    }
}




}

