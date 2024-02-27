<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class GotowyPlan extends Model   
{

    use HasFactory;

    protected $table = 'gotowy_plan';

    protected $fillable = ['nazwa'];

    public $timestamps = false;

    public function cwiczenia()
    {
        return $this->belongsToMany(Cwiczenie::class, 'gotowy_plan_cwiczenie');
    }
}
