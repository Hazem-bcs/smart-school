<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\Student;
class AuthController extends Controller
{
    use ApiResponseTrait;
    public function login(Request $request)
{
    $request->validate([
        'email' => 'required|email',
        'password' => 'required',
        'role' => 'required', // 1=Admin, 2=Student, 3=Teacher, 4=Parent
    ]);

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
            $model = \App\Models\My_Parent::class; // عدّل الاسم حسب الموديل عندك
            break;
        default:
    return $this->apiResponse(null,'نوع المستخدم غير صالح',400);    }
    

    $user = $model::where('email', $request->email)->first();

    if (!$user || !Hash::check($request->password, $user->password)) {
        return $this->apiResponse(null,'بيانات الدخول غير صحيحة',401); 
    }

    // إنشاء التوكن
    // $token = $user->createToken('login_token')->plainTextToken;

    // return response()->json([
    //     'user' => $user,
    // ]);
  $model::where('email', $request->email)->update(['is_logged'=>true]);
    return $this->apiResponse($user,'تم تسجيل الدخول بنجاح',200);
}

public function logout(Request $request)
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
            $model = \App\Models\My_Parent::class; // عدّل الاسم حسب الموديل عندك
            break;
        default:
        return $this->apiResponse(null,'نوع المستخدم غير صالح',400);
    }
    

        $user = $model::where('id',$request->id)->first();
        if ($user) {
            if($user->is_logged == 1){
           $model::where('id', $request->id)->update(['is_logged'=>false]);
            // $user->is_logged = false;
            }else {
                return $this->apiResponse(null,'مسجل خروج بالفعل',401);
            }
        }else {
            return $this->apiResponse(null,'هذا المستخدم غير موجود',401);
        }

        return $this->apiResponse(null,'تم تسجيل الخروج بنجاح',200);

}


}
