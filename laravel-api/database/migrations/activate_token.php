<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddActivationTokenToUzytkownikTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('uzytkownik', function (Blueprint $table) {
            $table->string('activation_token', 255)->nullable()->after('updated_at');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('uzytkownik', function (Blueprint $table) {
            $table->dropColumn('activation_token');
        });
    }
}
