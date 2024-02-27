<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Trening extends Model
{
    use HasFactory;

    protected $table = 'trening';

    protected $fillable = ['nazwa', 'data', 'godzina', 'grupa_treningowa_id', 'uzytkownik_id'];

    public $timestamps = false;

    public function grupaTreningowa()
    {
        return $this->belongsTo(GrupaTreningowa::class);
    }

    public function cwiczenia()
    {
        return $this->belongsToMany(Cwiczenie::class, 'trening_cwiczenie');
    }
}
