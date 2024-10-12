package com.thatsnajmul.userloginandlogout;

import android.content.Intent;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

public class RegisterActivity extends AppCompatActivity {

    private FirebaseAuth mAuth;
    private EditText registerEmail, registerPassword;
    private Spinner roleSpinner;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);

        mAuth = FirebaseAuth.getInstance();
        registerEmail = findViewById(R.id.registerEmail);
        registerPassword = findViewById(R.id.registerPassword);
        roleSpinner = findViewById(R.id.roleSpinner);

        findViewById(R.id.registerButton).setOnClickListener(view -> {
            String email = registerEmail.getText().toString();
            String password = registerPassword.getText().toString();
            String role = roleSpinner.getSelectedItem().toString();
            registerUser(email, password, role);
        });
    }

    private void registerUser(String email, String password, String role) {
        mAuth.createUserWithEmailAndPassword(email, password).addOnCompleteListener(this, task -> {
            if (task.isSuccessful()) {
                FirebaseUser user = mAuth.getCurrentUser();
                FirebaseFirestore db = FirebaseFirestore.getInstance();

                Map<String, Object> userInfo = new HashMap<>();
                userInfo.put("email", email);  // Store the user's email
                userInfo.put("role", role);    // Store the user's role

                // Store the user data in Firestore under the "Users" collection
                db.collection("Users").document(user.getUid()).set(userInfo)
                        .addOnSuccessListener(aVoid -> {
                            // Successfully stored user info in Firestore
                            Toast.makeText(RegisterActivity.this, "Registration successful", Toast.LENGTH_SHORT).show();
                            // Redirect to another activity or perform other actions
                            startActivity(new Intent(RegisterActivity.this, LoginActivity.class));
                            finish();
                        })
                        .addOnFailureListener(e -> {
                            // Failed to store user info in Firestore
                            Toast.makeText(RegisterActivity.this, "Failed to store user info: " + e.getMessage(), Toast.LENGTH_SHORT).show();
                        });

            } else {
                // If registration fails, display a message to the user
                Toast.makeText(RegisterActivity.this, "Registration failed: " + task.getException().getMessage(), Toast.LENGTH_SHORT).show();
            }
        });
    }
}
