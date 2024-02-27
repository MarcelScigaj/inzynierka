<?php 

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\Pivot;


class GotowyPlanCwiczenie extends Pivot
{
    protected $table = 'gotowy_plan_cwiczenie';

    // Jeśli używasz dodatkowych pól w tej tabeli pośredniej, zdefiniuj je tutaj
}
