<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Classroom extends Model
{
    use HasFactory;

    use HasFactory;

    public $translatable = ['Name_Class'];
    protected $table = 'Classrooms';
    protected $fillable = ['Name_Class','Grade_id'];
    public $timestamps = true;

    public function Grades()
    {
        return $this->belongsTo(Grade::class, 'Grade_id');
    }
    public function Sections()
    {
        return $this->hasMany(Section::class, 'Class_id');
    }
}
