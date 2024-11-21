//package com.thatsnajmull.job_search;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestBody;
//import org.springframework.web.bind.annotation.RestController;
//
//import java.util.List;
//import java.util.Optional;
//
//@RestController
//public class OldUserController {
//
//    @Autowired
//    private OldUserRepository userRepository;
//
//    // Register a new user
//    @PostMapping("/register")
//    public _OldUser Register(@RequestBody _OldUser user) {
//        return userRepository.save(user);
//    }
//
//    // Login a user
//    @PostMapping("/login")
//    public _OldUser Login(@RequestBody _OldUser user) {
//        _OldUser oldUser = userRepository.findByEmailAndPassword(user.email, user.password);
//        if (oldUser != null) {
//            return oldUser;
//        } else {
//            throw new RuntimeException("Invalid email or password");
//        }
//    }
//
//    // Get all users
//    @GetMapping("/users")
//    public List<_OldUser> getAllUsers() {
//        return userRepository.findAll();
//    }
//
//    // Get a specific user by ID
//    @GetMapping("/users/{id}")
//    public _OldUser getUserById(@PathVariable Long id) {
//        Optional<_OldUser> user = userRepository.findById(Math.toIntExact(id));
//        if (user.isPresent()) {
//            return user.get();
//        } else {
//            throw new RuntimeException("User not found with ID: " + id);
//        }
//    }
//}
