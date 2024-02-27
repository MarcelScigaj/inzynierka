<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\UserController;
use App\Http\Controllers\Api\CwiczenieController;
use App\Http\Controllers\Api\GotowyPlanController;
use App\Http\Controllers\Api\TreningController;
use App\Http\Controllers\Api\KonwersacjaController;
use App\Http\Controllers\Api\WiadomoscController;



// ...




//JWT DECODE oggarac do vue
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/


// Ogólnodostępne
    // Logowanie
    Route::post('/login', [LoginController::class, 'login']);
    // Streaming wideo
    Route::get('/stream-video/{path}', [CwiczenieController::class, 'streamVideo'])->where('path', '.*');
    Route::get('/cwiczenia', [CwiczenieController::class, 'index']); 
    Route::post('/cwiczenia', [CwiczenieController::class, 'store']);

// Dla zalogowanych użytkowników
    Route::middleware('auth:sanctum')->group(function () {  
        //Wylogowanie
        Route::post('/logout', [LoginController::class, 'logout']);
        //Informacje o zalogowanym użytkowniku
        Route::get('/user', function (Request $request) {
            return $request->user();
        });
        Route::get('/grupy-treningowe', [UserController::class, 'getGrupyTreningowe']);
        // Aktualizacja profilu użytkownika 
        Route::put('/update-profile', [UserController::class, 'update']);
        //Pobieranie cwiczen
        
        // Pobieranie treningów
        Route::get('/treningi', [TreningController::class, 'index']);
        //Kalendarz
        Route::get('/uzytkownik-grupy/{userId}', [UserController::class, 'getUserGroups']);
        Route::get('/rodzic-grupy/{userId}', [UserController::class, 'getUserGroupsForParent']);
        //Konwersacje + wiadomosci
        Route::get('konwersacje', [KonwersacjaController::class, 'index']);
        Route::post('/konwersacje', [KonwersacjaController::class, 'store']);
        Route::get('wiadomosci/{konwersacja}', [WiadomoscController::class, 'index']);
        Route::post('wiadomosci/{konwersacja}', [WiadomoscController::class, 'store']);
        Route::get('/users-for-conversation/{userId}', [KonwersacjaController::class, 'getUsersForConversation']);
    }); 

// Trener
    Route::middleware(['auth:sanctum', 'checkRole:Trener'])->group(function () {
        // Rejestracja (dziecko + rodzic)
        Route::post('/create-user', [UserController::class, 'create']);
        // Dodawanie nowego ćwiczenia
        
        //Usuwanie cwiczenia -> System zakłada że nie można usuwać ćwiczeń, dzięki czemu biblioteka ćwiczeń 
        //może rozrastać się oferując szeroką gamę coraz to nowszych rozwiązań i wariacji gotowych planów
        //Gotowe Plany
        Route::get('/gotowy-plan', [GotowyPlanController::class, 'index']);
        Route::post('/gotowy-plan', [GotowyPlanController::class, 'store']);
        // Tworzenie treningu
        Route::post('/trening', [TreningController::class, 'store']);
        //Zwracanie grup treningowych przypisanych do zalogowanego trenera 
        Route::get('/trener-grupy', [UserController::class, 'getTrenerGrupyTreningowe']); 
        //Modyfikacja treningu
        Route::put('/trening/{trening}', [TreningController::class, 'update']);
        //Usuwanie Treningu
        Route::delete('/trening/{id}', [TreningController::class, 'destroy']);
    });
// Administrator
    Route::middleware(['auth:sanctum', 'checkRole:Admin'])->group(function () {
        //Tworzenie konta dla Trenera
        Route::post('/create-trainer', [UserController::class, 'createTrainer']);
    });
