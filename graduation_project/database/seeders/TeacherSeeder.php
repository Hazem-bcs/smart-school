<?php

namespace Database\Seeders;

use App\Models\Gender;
use App\Models\Specialization;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class TeacherSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('teachers')->insert([
            'Name' => 'osama mohammad',
            'Email' => 'osama@gmail.com',
            'Password' => Hash::make('123456789'),
            'Specialization_id' => Specialization::all()->unique()->random()->id,
            'Gender_id' => Gender::all()->unique()->random()->id,
            'Joining_Date' => '2025-06-03',
            'Address' => 'Aleppo-Syria',
        ]);
    }
}
