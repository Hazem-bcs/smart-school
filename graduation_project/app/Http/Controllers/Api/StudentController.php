<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Student;
use Illuminate\Http\Request;

class StudentController extends Controller
{
    use ApiResponseTrait;
    public function showProfile(Request $request)
    {
        try {
              $user = Student::with('gender','Nationality','grade','classroom','section','myparent')->where('id',$request->id)->get();
         if ($user) {
             $formatted = $user->map(function ($user){
                return [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'password' => $user->password,
                    'gender' => $user->gender->Name ?? 'غير محدد',
                    'nationality' => $user->Nationality->Name ?? 'غير محدد',
                    'date_birth' => $user->Date_Birth,
                    'grade' => $user->grade->Name ?? 'غير محدد',
                    'classroom' => $user->classroom->Name_Class ?? 'غير محدد',
                    'section' => $user->section->Name_Section ?? 'غير محدد',
                    'father_name' => $user->myparent->Name_Father ?? 'غير محدد',
                    'mother_name' => $user->myparent->Name_Mother ?? 'غير محدد',
                    'address' => $user->address,
                    'phone' => $user->phone,
                ];

            });
            return $this->apiResponse($formatted,'Ok',200);
            }else {
            return $this->apiResponse(null,'هذا المستخدم غير موجود',401);
        }
        } catch (\Exception $e) {
                return $this->apiResponse(null,$e->getMessage(),401);

        }
      
        
        
    }

    public function validator(Request $request)
    {
        switch ($request->role) {
        case 1:
            $model = \App\Models\User::class;
            break;
        case 2:
            $model = \App\Models\Student::class;
            break;
        case 3:
            $model = \App\Models\Teacher::class;
            break;
        case 4:
            $model = \App\Models\My_Parent::class; 
            break;
        default:
        return $this->apiResponse(null,'نوع المستخدم غير صالح',400);
        }

        $user = $model::where('id',$request->id)->first();
        if ($user->is_logged == 1) {
            return $this->apiResponse(null, true, 200);
        }else {
            return $this->apiResponse(null, false, 400);
            
        }
    }
}
