<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Wiadomosc extends Model
{
    use HasFactory;

    protected $table = 'wiadomosc'; 


    protected $fillable = ['tresc', 'dataWyslania', 'konwersacja_id', 'uzytkownik_id'];
    public $timestamps = false;

    public function konwersacja()
    {
        return $this->belongsTo(Konwersacja::class);
    }

    public function uzytkownik()
    {
        return $this->belongsTo(User::class);
    }

    protected $casts = [
        'dataWyslania' => 'datetime',
    ];
    

}

