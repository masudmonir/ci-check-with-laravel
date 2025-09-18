<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Faker\Factory as Faker;

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

    Route::get('/fake-users', function () {
        $faker = Faker::create();

        $users = [];

        for ($i = 0; $i < 12; $i++) {
            $users[] = [
                'id' => $i + 1,
                'name' => $faker->name,
                'email' => $faker->unique()->safeEmail,
                'phone' => $faker->phoneNumber,
                'address' => $faker->address,
            ];
        }

        return response()->json([
            'status' => 'success',
            'data' => $users
        ]);
    });

    Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
        return $request->user();
    });
    Route::get('/users', [App\Http\Controllers\UserController::class, 'index']);
    Route::post('/users', [App\Http\Controllers\UserController::class, 'store']);
