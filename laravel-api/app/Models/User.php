<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */

    protected $table = 'uzytkownik';

    protected $fillable = [
        'login', 'haslo', 'imie', 'nazwisko', 'email', 'telefon', 'rola', 'avatarUrl'
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'hasło',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    public function getAuthPassword()
    {
        return $this->haslo;
    }

    public function konwersacje()
    {
        return $this->belongsToMany(Konwersacja::class, 'uzytkownik_konwersacja', 'uzytkownik_id', 'konwersacja_id');
    }

    public function wiadomosci()
    {
        return $this->hasMany(Wiadomosc::class);
    }

}
