<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckRole
{
    public function handle(Request $request, Closure $next, ...$roles)
    {
        if (!$request->user()) {
            return response('Unauthorized.', 401);
        }

        $userRoles = explode(',', $request->user()->rola); // Rozdzielenie ról użytkownika
        $userRoles = array_map('trim', $userRoles); // Usunięcie białych znaków

        $match = false;
        foreach ($userRoles as $userRole) {
            if (in_array(strtolower($userRole), array_map('strtolower', $roles))) {
                $match = true;
                break;
            }
        }

        if (!$match) {
            return response()->json(['message' => 'Access Denied'], 403);
        }

        return $next($request);
    }
}
