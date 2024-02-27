<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Konwersacja extends Model
{
    use HasFactory;

    protected $table = 'konwersacja';

    protected $fillable = ['typ', 'grupa_treningowa_id'];
    public $timestamps = false;

    public function wiadomosci()
    {
        return $this->hasMany(Wiadomosc::class);
    }

    public function grupaTreningowa()
    {
        return $this->belongsTo(GrupaTreningowa::class, 'grupa_treningowa_id');
    }

    public function uczestnicy()
    {
        return $this->belongsToMany(User::class, 'uzytkownik_konwersacja', 'konwersacja_id', 'uzytkownik_id');
    }
}
