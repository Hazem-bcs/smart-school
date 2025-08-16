<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Section extends Model
{
    use HasFactory;

        protected $fillable = [
        'Name_Section',
        'Status',
        'Grade_id',
        'Class_id',
    ];
    public $timestamps = true;

    public function Grades()
    {
        return $this->belongsTo(Grade::class, 'Grade_id');
    }

    public function My_classs()
    {
        return $this->belongsTo(Classroom::class, 'Class_id');
    }

    public function teachers()
    {
        return $this->belongsToMany('App\Models\Teacher','teacher_section');
    }
    public function teacher()
{
    return $this->belongsToMany(Teacher::class, 'section_teacher', 'section_id', 'teacher_id');
}

}
