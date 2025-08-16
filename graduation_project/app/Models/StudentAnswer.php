<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StudentAnswer extends Model
{
    use HasFactory;
    protected $fillable = ['student_id','quizz_id','question_id','selected_answer'];

    public function student()
    {
        return $this->belongsTo('App\Models\Student', 'student_id');
    }
    public function quizz()
    {
        return $this->belongsTo('App\Models\Quizze', 'quizz_id');
    }
    public function question()
    {
        return $this->belongsTo('App\Models\Question', 'question_id');
    }

}
