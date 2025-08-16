<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
class Teacher extends Model
{
    use HasApiTokens, HasFactory, Notifiable;
     protected $guard = 'teacher';
    public $translatable = ['Name'];
    protected $guarded = [];

    public function specializations()
    {
        return $this->belongsTo('App\Models\Specialization', 'Specialization_id');
    }

    // علاقة بين المعلمين والانواع لجلب جنس المعلم
    public function genders()
    {
        return $this->belongsTo('App\Models\Gender', 'Gender_id');
    }
    
    public function Sections()
    {
        return $this->belongsToMany('App\Models\Section','teacher_section');
    }
    public function section()
    {
        return $this->belongsToMany(Section::class, 'section_teacher', 'teacher_id', 'section_id');
    }

}
