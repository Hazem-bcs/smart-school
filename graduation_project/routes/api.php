<?php

use App\Http\Controllers\Api\QuizzController;
use App\Http\Controllers\Api\StudentAnswerController;
use App\Http\Controllers\Api\StudentController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\FinancialController;
use App\Http\Controllers\Api\SubjectController;
use App\Http\Controllers\Api\TeacherController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout']);
Route::post('/show_student_profile', [StudentController::class, 'showProfile']);
Route::post('/validator_student', [StudentController::class, 'validator']);
Route::post('/show_teacher', [TeacherController::class, 'showOneTeacher']);
Route::post('/show_teacher_section', [TeacherController::class, 'getTeachersByStudentId']);
Route::post('/showquizz', [QuizzController::class, 'showQuizzQuestion']);
Route::post('/show_quizz_section', [QuizzController::class, 'showQuizzSection']);
Route::post('/save_answer', [StudentAnswerController::class, 'storeBulkAnswers']);
Route::post('/show_subjects', [SubjectController::class, 'showSubjects']);
Route::post('/show_one_subject', [SubjectController::class, 'showOneSubject']);
Route::post('/showresource', [SubjectController::class, 'showResources']);
Route::post('/showinvoices', [FinancialController::class, 'showInvoices']);
Route::post('/studentaccount', [FinancialController::class, 'studentAccount']);

