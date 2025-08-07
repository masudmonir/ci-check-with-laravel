<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::get('/home', function () {
    return 'this is home page';
});
Route::get('/services', function () {
    return 'this is services page';
});
Route::get('/products', function () {
    return 'this is products page';
});
Route::get('/blog', function () {
    return 'this is blog page';
});
Route::get('/about', function () {
                return 'this is about page';
});