<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Cwiczenie extends Model
{
    use HasFactory;

    protected $table = 'cwiczenie';

    protected $fillable = ['nazwa', 'opis', 'rodzaj'];

    public $timestamps = false;

    public function tutorials()
    {
        return $this->hasMany(Tutorial::class);
    }
}
