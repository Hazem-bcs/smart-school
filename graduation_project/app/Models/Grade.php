<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Grade extends Model
{
    use HasFactory;

     public $translatable = ['Name'];
    protected $fillable = ['Name','Notes'];
    protected $table = 'Grades';
    public $timestamps = true;

    public function Sections()
    {
        return $this->hasMany(Section::class, 'Grade_id');
    }
}
