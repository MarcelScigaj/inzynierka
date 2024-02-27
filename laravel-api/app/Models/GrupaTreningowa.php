<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class GrupaTreningowa extends Model
{
    protected $table = 'grupa_treningowa'; // Nazwa tabeli w bazie danych

    // Dodaj inne potrzebne właściwości i metody

    public function uczestnicy()
    {
        return $this->belongsToMany(User::class, 'grupa_treningowa_uzytkownik', 'grupa_treningowa_id', 'uzytkownik_id');
    }

}
