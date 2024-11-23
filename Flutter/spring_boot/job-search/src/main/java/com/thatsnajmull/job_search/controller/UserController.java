package com.thatsnajmull.job_search.controller;

import com.thatsnajmull.job_search.dto.UserDTO;
import com.thatsnajmull.job_search.entity.User;
import com.thatsnajmull.job_search.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@CrossOrigin(origins = "http://localhost:9097")
@RestController
@RequestMapping("/api/users")
//@PreAuthorize("hasRole('ADMIN') or hasRole('EMPLOYER')")
public class UserController {

    @Autowired
    private UserService userService;

    // Get user by Email
//    @GetMapping("/email/{email}")
//    public ResponseEntity<User> getUserByEmail(@PathVariable String username) {
//        Optional<User> user = userService.loadUserByUsername(username);
//        return user.map(ResponseEntity::ok)
//                .orElseGet(() -> ResponseEntity.notFound().build());
//    }

//    @GetMapping("/email/{email}")
//    public ResponseEntity<User> getUserByEmail(@PathVariable String email) {
//        Optional<User> user = userService.getUserByEmail(email);  // Use the new method here
//        return user.map(ResponseEntity::ok)
//                .orElseGet(() -> ResponseEntity.notFound().build());
//    }

    // Get user by ID and return DTO
    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable long id) {
        User user = userService.findUserById(id);  // Assuming findUserById returns a User entity
        UserDTO userDTO = userService.convertToDTO(user);
        return ResponseEntity.ok(userDTO);
    }

    // Example for POST/PUT endpoints
    @PostMapping
    public ResponseEntity<UserDTO> createUser(@RequestBody UserDTO userDTO) {
        User user = userService.convertToEntity(userDTO);
        User savedUser = userService.saveUser(user);  // Assuming saveUser saves the entity
        UserDTO savedUserDTO = userService.convertToDTO(savedUser);
        return ResponseEntity.ok(savedUserDTO);
    }

    // You can add more endpoints for different CRUD operations









    // Update user by Email
    @PutMapping("/email/{email}")
    public ResponseEntity<User> updateUserByEmail(@PathVariable String email, @RequestBody User updatedUser) {
        try {
            User user = userService.updateUserByEmail(email, updatedUser);
            return ResponseEntity.ok(user);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Delete user by Email
    @DeleteMapping("/email/{email}")
    public ResponseEntity<Void> deleteUserByEmail(@PathVariable String email) {
        try {
            userService.deleteUserByEmail(email);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
