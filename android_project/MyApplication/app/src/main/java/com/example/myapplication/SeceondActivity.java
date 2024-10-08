package com.example.myapplication;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;

public class SeceondActivity extends AppCompatActivity {

//    private ApiService apiService;
//
//    private RecyclerView recyclerView;
//    private UserAdapter userAdapter;
//    private List<User> userList = new ArrayList<>();
//    private ProgressBar progressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_seceond);

//        Retrofit retrofit = RetrofitClient.getClient("http://localhost:8080/api/users/");
//        apiService = retrofit.create(ApiService.class);

//        recyclerView = findViewById(R.id.recyclerViewUsers);
//        recyclerView.setLayoutManager(new LinearLayoutManager(this));
//        progressBar = findViewById(R.id.progressBar);

        // Fetch users
//        fetchUsers();


    }

//    private void fetchUsers() {
//        progressBar.setVisibility(View.VISIBLE);
//        Call<List<User>> call = apiService.getUsers();
//
//        call.enqueue(new Callback<List<User>>() {
//            @Override
//            public void onResponse(Call<List<User>> call, Response<List<User>> response) {
//                progressBar.setVisibility(View.GONE);
//                if (response.isSuccessful()) {
//                    userList = response.body();
//                    userAdapter = new UserAdapter(SeceondActivity.this, userList);
//                    recyclerView.setAdapter(userAdapter);
//                } else {
//                    Toast.makeText(SeceondActivity.this, "Failed to retrieve users", Toast.LENGTH_SHORT).show();
//                }
//            }
//
//            @Override
//            public void onFailure(Call<List<User>> call, Throwable t) {
//                progressBar.setVisibility(View.GONE);
//                Log.e("Error", t.getMessage());
//                Toast.makeText(SeceondActivity.this, "Error fetching users", Toast.LENGTH_SHORT).show();
//            }
//        });
//
//    }

//    private void createUser() {
//        User newUser = new User();
//        newUser.setName("John Doe");
//        newUser.setEmail("john.doe@example.com");
//        newUser.setPhone("123456789");
//
//        Call<User> call = apiService.createUser(newUser);
//        call.enqueue(new Callback<User>() {
//            @Override
//            public void onResponse(Call<User> call, Response<User> response) {
//                if (response.isSuccessful()) {
//                    User createdUser = response.body();
//                    Log.d("User", "Created ID: " + createdUser.getId());
//                    Toast.makeText(SeceondActivity.this, "User created!", Toast.LENGTH_SHORT).show();
//                } else {
//                    Toast.makeText(SeceondActivity.this, "Failed to create user", Toast.LENGTH_SHORT).show();
//                }
//            }
//
//            @Override
//            public void onFailure(Call<User> call, Throwable t) {
//                Log.e("Error", t.getMessage());
//                Toast.makeText(SeceondActivity.this, "Error creating user", Toast.LENGTH_SHORT).show();
//            }
//        });
//    }



}