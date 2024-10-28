//package com.thatsnajmull.job_search.controller;
//
//import com.thatsnajmull.job_search.entity.User;
//import com.thatsnajmull.job_search.service.UserService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.security.authentication.AuthenticationManager;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.annotation.AuthenticationPrincipal;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.web.bind.annotation.*;
//
//@RestController
//@RequestMapping("/api/auth")
//public class AuthController {
//
//    @Autowired
//    private UserService userService;
//
//    @Autowired
//    private AuthenticationManager authenticationManager;
//
//    @PostMapping("/register")
//    public ResponseEntity<String> register(@RequestBody User user) {
//        userService.registerUser(user);
//        return ResponseEntity.ok("User registered successfully!");
//    }
//
//    @PostMapping("/login")
//    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest) {
//        try {
//            // Authenticate user
//            authenticationManager.authenticate(
//                    new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword())
//            );
//
//            // Load user details post authentication
//            UserDetails userDetails = userService.loadUserByUsername(loginRequest.getUsername());
//            return ResponseEntity.ok(userDetails);
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
//        }
//    }
//
//    @GetMapping("/current")
//    public ResponseEntity<?> getCurrentUser(@AuthenticationPrincipal UserDetails userDetails) {
//        return ResponseEntity.ok(userService.getCurrentUser(userDetails.getUsername()));
//    }
//
//    // LoginRequest inner class
//    public static class LoginRequest {
//        private String username;
//        private String password;
//
//        // Getters and Setters
//        public String getUsername() {
//            return username;
//        }
//
//        public void setUsername(String username) {
//            this.username = username;
//        }
//
//        public String getPassword() {
//            return password;
//        }
//
//        public void setPassword(String password) {
//            this.password = password;
//        }
//    }
//}
