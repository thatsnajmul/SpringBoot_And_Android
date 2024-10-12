package com.thatsnajmul.userloginandlogout;

import android.content.Intent;
import android.os.Bundle;
import android.widget.EditText;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.FirebaseFirestore;

public class LoginActivity extends AppCompatActivity {

    private FirebaseAuth mAuth;
    private EditText loginEmail, loginPassword;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        mAuth = FirebaseAuth.getInstance();
        loginEmail = findViewById(R.id.loginEmail);
        loginPassword = findViewById(R.id.loginPassword);

        findViewById(R.id.loginButton).setOnClickListener(view -> {
            String email = loginEmail.getText().toString();
            String password = loginPassword.getText().toString();
            loginUser(email, password);
        });

        findViewById(R.id.registerText).setOnClickListener(view -> {
            startActivity(new Intent(LoginActivity.this, RegisterActivity.class));
        });
    }

    private void loginUser(String email, String password) {
        mAuth.signInWithEmailAndPassword(email, password).addOnCompleteListener(this, task -> {
            if (task.isSuccessful()) {
                FirebaseUser user = mAuth.getCurrentUser();
                checkUserRole(user.getUid());
            } else {
                Toast.makeText(LoginActivity.this, "Login failed", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void checkUserRole(String uid) {
        FirebaseFirestore db = FirebaseFirestore.getInstance();
        db.collection("users").document(uid).get().addOnSuccessListener(documentSnapshot -> {
            if (documentSnapshot.exists()) {
                String role = documentSnapshot.getString("role");
                if ("admin".equals(role)) {
                    startActivity(new Intent(LoginActivity.this, AdminActivity.class));
                } else {
                    startActivity(new Intent(LoginActivity.this, UserActivity.class));
                }
                finish();
            }
        });
    }

    


}
