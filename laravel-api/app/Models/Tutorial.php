<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tutorial extends Model
{
    use HasFactory;

    protected $table = 'tutorial';

    protected $fillable = ['sciezka_zdjecie', 'sciezka_film',  'cwiczenie_id'];

    public $timestamps = false;

    public function cwiczenie()
    {
        return $this->belongsTo(Cwiczenie::class);
    }
}
