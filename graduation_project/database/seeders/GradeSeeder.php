<?php

namespace Database\Seeders;

use App\Models\Grade;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class GradeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('grades')->delete();
        $grades = [
            'Primary stage',
            'middle School',
            'High school',
        ];

        foreach ($grades as $grade) {
            Grade::create(['Name' => $grade]);
        }

    }
}
