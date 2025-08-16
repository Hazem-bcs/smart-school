<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Question;
use App\Models\Quizze;
use App\Models\Student;
use App\Models\Subject;
use Illuminate\Http\Request;
use PHPUnit\Framework\Constraint\IsEmpty;

use function PHPUnit\Framework\isEmpty;

class QuizzController extends Controller
{
    use ApiResponseTrait;
    public function showQuizzSection(Request $request)
    {
        $student = Student::where('id',$request->id)->first();
        if (!$student) {
            return $this->apiResponse(null,'هذا المستخدم غير موجود',401);
        }
        $quizzes = Quizze::where('section_id', $student->section_id)->get();

        if ($quizzes->isEmpty()) {
            return $this->apiResponse(null, 'لا يوجد وظائف لعرضها', 401);
        }
        return $this->apiResponse($quizzes, 'Ok', 200);
    }

    
    public function showQuizzQuestion(Request $request)
    {
        $quizz = Quizze::where('id',$request->id)->first();
        if (!$quizz) {
            return $this->apiResponse(null,'هذا الامتحان غير موجود',401);
        }
        $id = $request->id;
        $questions = Question::where('quizze_id',$id)->get();
        return $this->apiResponse($questions, 'Ok', 200);

    }
}
