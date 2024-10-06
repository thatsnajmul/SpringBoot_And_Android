package com.example.myapplication;

import java.util.List;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.DELETE;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;

public interface ApiService {


        @GET("/api/users")
        Call<List<User>> getUsers();

        @POST("/api/users")
        Call<User> createUser(@Body User user);

        @PUT("/api/users/{id}")
        Call<User> updateUser(@Path("id") Long id, @Body User user);

        @DELETE("/api/users/{id}")
        Call<Void> deleteUser(@Path("id") Long id);

}
