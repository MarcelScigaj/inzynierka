<?php   
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\GotowyPlan;
use App\Models\Cwiczenie;

class GotowyPlanController extends Controller
{
    // Metoda do wczytywania wszystkich ćwiczeń
   
    public function index()
{
    $plany = GotowyPlan::with('cwiczenia')->get(); // Zakładam relację 'cwiczenia' w modelu GotowyPlan
    return response()->json($plany);
}

    // Metoda do zapisywania nowego planu z wybranymi ćwiczeniami
    public function store(Request $request)
    {

        \Log::info($request->all());

        $validatedData = $request->validate([
            'nazwa' => 'required|string|max:255',
            'cwiczenia' => 'required|array',
            'cwiczenia.*' => 'exists:cwiczenie,id'
        ]);

        $plan = GotowyPlan::create(['nazwa' => $validatedData['nazwa']]);
        $plan->cwiczenia()->attach($validatedData['cwiczenia']);

        return response()->json(['message' => 'Plan stworzony pomyślnie', 'plan' => $plan]);
    }
}
