<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\StudentAnswer;
use Illuminate\Http\Request;

class StudentAnswerController extends Controller
{
    use ApiResponseTrait;
    public function storeBulkAnswers(Request $request)
    {
        try {
            

             $request->validate([
                'student_id' => 'required|exists:students,id',
                'quizz_id' => 'required|exists:quizzes,id',
                'answers' => 'required|array|min:1',
                'answers.*.question_id' => 'required|exists:questions,id',
                'answers.*.selected_answer' => 'required|string|in:answer1,answer2,answer3',
            ]);

        foreach ($request->answers as $answer) {
            StudentAnswer::create([
                'student_id' => $request->student_id,
                'quizz_id' => $request->quizz_id,
                'question_id' => $answer['question_id'],
                'selected_answer' => $answer['selected_answer'],
            ]);
        }


            return $this->apiResponse(null,'تم حفظ جميع الإجابات بنجاح',201);
        } catch (\Exception $e) {
            return $this->apiResponse(null,$e->getMessage(),400);
            }
    }
}