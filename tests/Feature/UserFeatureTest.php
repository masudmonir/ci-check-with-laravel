<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;
use App\Models\User;

class UserFeatureTest extends TestCase
{
    use RefreshDatabase; // প্রতিবার টেস্টের সময় ডাটাবেস রিফ্রেশ হবে
    use WithFaker; // ফেক ডেটা জেনারেট করার জন্য

    public function testUserListApiReturnsData()
    {
        // Arrange: কিছু ইউজার তৈরি করি
        User::factory()->count(3)->create();

        // Act: /api/users এ GET রিকোয়েস্ট পাঠাই
        $response = $this->getJson('/api/users');

        // Assert: রেসপন্স ঠিক আছে কিনা যাচাই
        $response->assertStatus(200)
                 ->assertJsonCount(3); // ৩ জন ইউজার আসছে কিনা
    }

    public function testUserCanBeCreated()
    {
        // Arrange: ইউজারের ডেটা তৈরি করি
        $userData = [
            'name' => 'Masud',
            'email' => 'masud@example.com',
            'password' => 'secret123'
        ];

        // Act: POST রিকোয়েস্ট পাঠাই
        $response = $this->postJson('/api/users', $userData);

        // Assert: সফলভাবে তৈরি হলো কিনা চেক করি
        $response->assertStatus(201)
                 ->assertJsonFragment([
                     'email' => 'masud@example.com'
                 ]);

        $this->assertDatabaseHas('users', [
            'email' => 'masud@example.com'
        ]);
    }
}