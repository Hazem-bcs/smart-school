<?php

namespace Database\Seeders;

use App\Models\Classroom;
use App\Models\Grade;
use App\Models\Section;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class SectionsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('sections')->delete();

        $Sections = [
            'a',
            'b',
            'c',
        ];

        
            $Grade = Grade::where('id',1)->first();
            for ($class_id=1; $class_id <= 6; $class_id++) { 
                $class = Classroom::where('id', $class_id)->first();
                foreach ($Sections as $section) {
                    Section::create([
                        'Name_Section' => $section,
                        'Status' => 1,
                        'Grade_id' => $Grade->id,
                        'Class_id' => $class->id ,
                    ]);
                }
            }
            $Grade = Grade::where('id',2)->first();
            for ($class_id=7; $class_id <= 9; $class_id++) { 
                $class = Classroom::where('id', $class_id)->first();
                foreach ($Sections as $section) {
                    Section::create([
                        'Name_Section' => $section,
                        'Status' => 1,
                        'Grade_id' => $Grade->id,
                        'Class_id' => $class->id ,
                    ]);
                }
            }
            $Grade = Grade::where('id',3)->first();
            for ($class_id=10; $class_id <= 12; $class_id++) { 
                $class = Classroom::where('id', $class_id)->first();
                foreach ($Sections as $section) {
                    Section::create([
                        'Name_Section' => $section,
                        'Status' => 1,
                        'Grade_id' => $Grade->id,
                        'Class_id' => $class->id ,
                    ]);
                }
            }
        
        
        

    }
}
