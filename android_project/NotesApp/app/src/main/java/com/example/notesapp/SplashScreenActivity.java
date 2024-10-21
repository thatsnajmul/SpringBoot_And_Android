package com.example.notesapp;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;


import com.google.firebase.auth.FirebaseAuth;

import pl.droidsonroids.gif.GifImageView;

public class SplashScreenActivity extends AppCompatActivity {

    private static final int SPLASH_SCREEN_DURATION = 3000; // Duration of the splash screen

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash_screen);

        GifImageView gifImageView = findViewById(R.id.gifImageView); // Reference to GifImageView

        // Handler to delay the transition to the next activity
        new Handler().postDelayed(() -> {
            FirebaseAuth firebaseAuth = FirebaseAuth.getInstance();

            Intent intent;
            if (firebaseAuth.getCurrentUser() != null) {
                // User is logged in, navigate to NotesActivity
                intent = new Intent(SplashScreenActivity.this, NotesActivity.class);
            } else {
                // User is not logged in, navigate to MainActivity
                intent = new Intent(SplashScreenActivity.this, MainActivity.class);
            }
            startActivity(intent);
            finish(); // Close the splash screen activity
        }, SPLASH_SCREEN_DURATION);
    }
}
