//package com.thatsnajmull.job_search.service;
//
//import com.thatsnajmull.job_search.entity.User;
//import com.thatsnajmull.job_search.entity.Role;
//import com.thatsnajmull.job_search.repository.UserRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.annotation.Lazy;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.security.core.userdetails.UserDetailsService;
//import org.springframework.security.core.userdetails.UsernameNotFoundException;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.stereotype.Service;
//
//import java.util.HashSet;
//import java.util.Set;
//
//@Service
//public class UserService implements UserDetailsService {
//
//    @Autowired
//    private UserRepository userRepository;
//
//    private final PasswordEncoder passwordEncoder;
//
//    @Autowired
//    public UserService(PasswordEncoder passwordEncoder) {
//        this.passwordEncoder = passwordEncoder;
//    }
//
//    public void registerUser(User user) {
//        user.setPassword(passwordEncoder.encode(user.getPassword())); // Ensure password is encoded
//        Set<Role> roles = new HashSet<>();
//        roles.add(new Role("USER")); // Set default role
//        user.setRoles(roles); // Set roles
//        userRepository.save(user); // Save the user
//    }
//
//    @Override
//    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
//        User user = userRepository.findByUsername(username);
//        if (user == null) {
//            throw new UsernameNotFoundException("User not found with username: " + username);
//        }
//        return user; // Return the User entity, which implements UserDetails
//    }
//
//    public User getCurrentUser(String username) {
//        return userRepository.findByUsername(username);
//    }
//}
//
