<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class KonwersacjaResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'typ' => $this->typ,
            'grupa_treningowa_id' => $this->grupa_treningowa_id,
            // Jeśli chcesz dodać więcej danych, np. powiązane wiadomości czy uczestników:
            'wiadomosci' => WiadomoscResource::collection($this->whenLoaded('wiadomosci')),
            'uczestnicy' => UzytkownikResource::collection($this->whenLoaded('uczestnicy')),
        ];
    }
}
