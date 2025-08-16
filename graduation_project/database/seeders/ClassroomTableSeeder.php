<?php

namespace Database\Seeders;

use App\Models\Classroom;
use App\Models\Grade;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ClassroomTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('classrooms')->delete();
        $First_classrooms = [
            'First Class',
            'Second Class',
            'Third Class',
            'Fifth Class',
            'Fourth Class',
            'Sixth Class',
        ];
        $First_Grade = Grade::where('id',1)->first();
        $id = explode(',',$First_Grade->id);

        foreach ($First_classrooms as $First_classroom) {
            Classroom::create([
            'Name_Class' => $First_classroom,
            'Grade_id' => $First_Grade->id
            ]);
        }

        $Second_classrooms = [
            'Seventh Class',
            'Eighth Class',
            'Ninth Class',
        ];
        $Second_Grade = Grade::where('id',2)->first();

        foreach ($Second_classrooms as $Second_classroom) {
            Classroom::create([
            'Name_Class' => $Second_classroom,
            'Grade_id' => $Second_Grade->id
            ]);
        }

        $Third_classrooms = [
            'Tenth Class',
            'Eleventh Class',
            'Twelfth Class',
        ];
        $Third_Grade = Grade::where('id',3)->first();

        foreach ($Third_classrooms as $Third_classroom) {
            Classroom::create([
            'Name_Class' => $Third_classroom,
            'Grade_id' => $Third_Grade->id
            ]);
        }
    }
}
