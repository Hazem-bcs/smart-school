<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('my__parents', function (Blueprint $table) {
            $table->id();
            $table->string('Email')->unique();
            $table->string('Password');

            //Fatherinformation
            $table->string('Name_Father');
            $table->string('National_ID_Father')->nullable();
            $table->string('Passport_ID_Father')->nullable();
            $table->string('Phone_Father')->nullable();
            $table->string('Job_Father')->nullable();
            $table->bigInteger('Nationality_Father_id')->unsigned()->nullable();
            $table->bigInteger('Blood_Type_Father_id')->unsigned()->nullable();
            $table->bigInteger('Religion_Father_id')->unsigned()->nullable();
            $table->string('Address_Father')->nullable();

            //Mother information
            $table->string('Name_Mother');
            $table->string('National_ID_Mother')->nullable();
            $table->string('Passport_ID_Mother')->nullable();
            $table->string('Phone_Mother')->nullable();
            $table->string('Job_Mother')->nullable();
            $table->bigInteger('Nationality_Mother_id')->unsigned()->nullable();
            $table->bigInteger('Blood_Type_Mother_id')->unsigned()->nullable();
            $table->bigInteger('Religion_Mother_id')->unsigned()->nullable();
            $table->string('Address_Mother')->nullable();

            $table->foreign('Nationality_Father_id')->references('id')->on('nationalities');
            $table->foreign('Blood_Type_Father_id')->references('id')->on('type__bloods');
            $table->foreign('Religion_Father_id')->references('id')->on('religions');
            $table->foreign('Nationality_Mother_id')->references('id')->on('nationalities');
            $table->foreign('Blood_Type_Mother_id')->references('id')->on('type__bloods');
            $table->foreign('Religion_Mother_id')->references('id')->on('religions');
            
            $table->boolean('is_logged')->default(false);

            $table->timestamps();

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('my__parents');
    }
};
