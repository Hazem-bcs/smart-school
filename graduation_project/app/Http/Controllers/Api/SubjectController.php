<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Resource;
use App\Models\Student;
use App\Models\Subject;
use Illuminate\Http\Request;

class SubjectController extends Controller
{
    use ApiResponseTrait;
    public function showSubjects(Request $request)
    {
        $student = Student::where('id',$request->id)->first();
        if (!$student) {
            return $this->apiResponse(null,'هذا المستخدم غير موجود',401);
        }
        $class_id = $student->Classroom_id;
        $subjects = Subject::where('classroom_id',$class_id)->get();
        return $this->apiResponse($subjects, 'Ok', 200);
    }

    public function showOneSubject(Request $request)
    {
        $subject = Subject::with('teacher')->find($request->subject_id);

        if (!$subject) {
            return $this->apiResponse(null,'هذه المادة غير موجود',401);
        }
        $data = [
            'subject_name' => $subject->name,
            'teacher_name' => $subject->teacher->name ?? 'بدون استاذ'
        ];
        return $this->apiResponse($data, 'تم بنجاح', 200); 
    }

    public function showResources(Request $request)
    {
        try {
            $subject_id = $request->id;
            $resource = Resource::with('teacher','subject')->where('subject_id',$subject_id)->get();
            $formatted = $resource->map(function ($resource){
                return [
                    'id' => $resource->id,
                    'name' => $resource->name,
                    'description' => $resource->description,
                    'url' => $resource->url,
                    'teacher_name' => $resource->teacher->name ?? 'غير محدد',
                    'subject_name' => $resource->subject->name ?? 'غير محدد',
                ];

            });
            return $this->apiResponse($formatted, 'تم بنجاح', 200); 

        } catch (\Exception $e) {
            return $this->apiResponse(null,$e->getMessage(),400);
        }
    }
}
