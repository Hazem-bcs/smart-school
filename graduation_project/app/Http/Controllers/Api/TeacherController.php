<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Section;
use App\Models\Student;
use App\Models\Teacher;
use App\Models\TeacherSection;
use Illuminate\Http\Request;

class TeacherController extends Controller
{
    use ApiResponseTrait;
    public function showOneTeacher(Request $request)
    {
         $user = Teacher::where('id',$request->id)->first();
         if ($user) {
            return $this->apiResponse($user,'Ok',200);
        }else {
            return $this->apiResponse(null,'هذا المستخدم غير موجود',401);
        }
    }

    
    public function getTeachersByStudentId(Request $request)
    {
    // جلب الطالب المطلوب
    $student = Student::where('id',$request->id)->first();

    if ($student) {
        // جلب الأساتذة المرتبطين بالشعبة التي ينتمي إليها الطالب
        $teachers = Teacher::whereHas('sections', function ($query) use ($student) {
        $query->where('sections.id', $student->section_id);})->get();
        return $this->apiResponse($teachers,'Ok',200);
    }else{
        return $this->apiResponse(null,'هذا المستخدم غير موجود',401);
    }
    // return response()->json([
    //     'section_id' => $student->section_id,
    //     'teachers' => $teachers,
    // ]);
    }

}