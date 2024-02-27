<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Wiadomosc;
use App\Http\Resources\WiadomoscResource;

class WiadomoscController extends Controller
{
    public function index($konwersacjaId)
{
    $wiadomosci = Wiadomosc::where('konwersacja_id', $konwersacjaId)->get();
    return response()->json($wiadomosci);
}

    public function store(Request $request)
    {
        $validated = $request->validate([
            'tresc' => 'required|string',
            'dataWyslania' => 'required|date',
            'konwersacja_id' => 'required|exists:konwersacja,id',
            'uzytkownik_id' => 'required|exists:uzytkownik,id'
        ]);

        $wiadomosc = Wiadomosc::create($validated);
        return response()->json($wiadomosc);
    }

    public function show($id)
    {
        $wiadomosc = Wiadomosc::findOrFail($id);
        return response()->json($wiadomosc);
    }

    public function update(Request $request, $id)
    {
        $wiadomosc = Wiadomosc::findOrFail($id);
        $validated = $request->validate([
            'tresc' => 'required|string',
            'dataWyslania' => 'required|date',
            'konwersacja_id' => 'required|exists:konwersacja,id',
            'uzytkownik_id' => 'required|exists:uzytkownik,id'
        ]);

        $wiadomosc->update($validated);
        return response()->json($wiadomosc);
    }

    public function destroy($id)
    {
        $wiadomosc = Wiadomosc::findOrFail($id);
        $wiadomosc->delete();
        return response()->json(['message' => 'Wiadomość została usunięta']);
    }
}
