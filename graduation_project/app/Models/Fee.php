<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Fee extends Model
{
    use HasFactory;

     protected $guarded = [];


    public function grade()
    {
        return $this->belongsTo(Grade::class,'Grade_id');
    }
    public function classroom()
    {
        return $this->belongsTo(Classroom::class,'Classroom_id');
    }
}
