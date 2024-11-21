package com.thatsnajmull.job_search.controller;

import com.thatsnajmull.job_search.entity.AuthenticationResponse;
import com.thatsnajmull.job_search.entity.User;
import com.thatsnajmull.job_search.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "http://localhost:9097/")
public class AuthenticationController {

    private final AuthService authService;

    @Autowired
    public AuthenticationController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register/{type}")
    public ResponseEntity<AuthenticationResponse> register(
            @PathVariable String type,
            @RequestBody User request
    ) {
        switch (type) {
            case "job-seeker":
                return ResponseEntity.status(HttpStatus.CREATED).body(authService.register(request));
            case "admin":
                return ResponseEntity.status(HttpStatus.CREATED).body(authService.registerAdmin(request));
            case "employer":
                return ResponseEntity.status(HttpStatus.CREATED).body(authService.registerEmployer(request));
            default:
                return ResponseEntity.badRequest().build();
        }
    }

    @PostMapping("/login")
    public ResponseEntity<AuthenticationResponse> login(
            @RequestBody User request
    ) {
        return ResponseEntity.ok(authService.authenticate(request));
    }

    @GetMapping("/activate/{id}")
    public ResponseEntity<String> activateUser(@PathVariable("id") int id) {
        String response = authService.activateUser(id);
        return ResponseEntity.ok(response);
    }
}
