<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class LoginController extends Controller
{

    // Obsłuż logowanie
    public function login(Request $request)
    {
        $request->validate([
            'login' => 'required',
            'haslo' => 'required',
        ]);

        if (!Auth::attempt(['login' => $request->login, 'password' => $request->haslo])) {
            throw ValidationException::withMessages([
                'login' => ['Podane dane są nieprawidłowe.'],
            ]);
        }

        $user = Auth::user();
        $token = $user->createToken('authToken')->plainTextToken;

        return response()->json([
            'message' => 'Logowanie powiodło się',
             'user' => $user, 'token' => $token,
              'role' => $user->rola]);
    }

     // Obsłuż wylogowanie
     public function logout(Request $request)
     {
         $request->user()->tokens()->delete();
 
         return response()->json(['message' => 'Wylogowano pomyślnie.']);
     }
}
