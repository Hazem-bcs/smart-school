<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Fee_invoice;
use App\Models\Student;
use App\Models\StudentAccount;
use Illuminate\Http\Request;

class FinancialController extends Controller
{
    use ApiResponseTrait;

    public function showInvoices(Request $request)
    {
        try {
            $validate = $request->validate([
                'id' => 'exists:students,id',
            ]);
            
        $invoice = Fee_invoice::where('student_id',$request->id)->get();
         $formatted = $invoice->map(function ($invoice){
                return [
                    'id' => $invoice->id,
                    'name' => $invoice->invoice_date,
                    'description' => $invoice->description,
                    'student_name' => $invoice->student->name ?? 'غير محدد',
                    'grade_name' => $invoice->grade->Name ?? 'غير محدد',
                    'classroom_name' => $invoice->classroom->Name_Class ?? 'غير محدد',
                    'amount' => $invoice->amount,
                ];

            });
            return $this->apiResponse($formatted,'success',200);

        } catch (\Exception $e) {
            return $this->apiResponse(null,$e->getMessage(),400);
        }
    }

    public function studentAccount(Request $request)
    {
        try {
            $validate = $request->validate([
                'id' => 'exists:students,id',
            ]);
            $student = Student::where('id', $request->id)->first();
            $accounts = StudentAccount::where('student_id',$request->id)->get();
            $sum = 0;
            $newSum = 0;
            foreach ($accounts as $account) {
                $sum = $account->Debit - $account->credit;
                $newSum = $newSum + $sum;
            }
            $data = [
                'student_name' => $student->name,
                'final_account' => $newSum
            ];
                        return $this->apiResponse($data,'success',200);

        } catch (\Exception $e) {
            return $this->apiResponse(null,$e->getMessage(),400);
        }
    }
}
