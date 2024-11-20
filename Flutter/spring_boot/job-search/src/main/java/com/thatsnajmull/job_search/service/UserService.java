//package com.thatsnajmull.job_search.service;
//
//import com.thatsnajmull.job_search.dto.UserDTO;
//import com.thatsnajmull.job_search.entity.User;
//import com.thatsnajmull.job_search.repository.UserRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.core.userdetails.UserDetails;
//import org.springframework.security.core.userdetails.UserDetailsService;
//import org.springframework.security.core.userdetails.UsernameNotFoundException;
//import org.springframework.stereotype.Service;
//
//import java.util.Optional;
//
//@Service
//public class UserService implements UserDetailsService {
//
//    @Autowired
//    private UserRepository userRepository;
//
//
//    // This is for authentication purposes
//    @Override
//    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
//        return userRepository.findByEmail(email)
//                .orElseThrow(() -> new UsernameNotFoundException("User Not Found With this Email Address"));
//    }
//
//    // This method is for retrieving the user profile
//    public Optional<User> getUserByEmail(String email) {
//        return userRepository.findByEmail(email);  // Ensure this method returns Optional<User>
//    }
//
//
//
////    // Find user by Email
////    public Optional<User> getUserByEmail(String email) {
////        return userRepository.findByEmail(email);
////    }
//
//    // Update user by Email
//    public User updateUserByEmail(String email, User updatedUser) {
//        return userRepository.findByEmail(email).map(user -> {
//            user.setName(updatedUser.getName());
//            user.setEmail(updatedUser.getEmail());
//            user.setPassword(updatedUser.getPassword());
//            user.setCell(updatedUser.getCell());
//            user.setAddress(updatedUser.getAddress());
//            user.setDob(updatedUser.getDob());
//            user.setGender(updatedUser.getGender());
//            user.setImage(updatedUser.getImage());
//            user.setActive(updatedUser.isActive());
//            user.setLock(updatedUser.isLock());
//            user.setRole(updatedUser.getRole());
//            return userRepository.save(user);
//        }).orElseThrow(() -> new RuntimeException("User not found"));
//    }
//
//    // Delete user by Email
//    public void deleteUserByEmail(String email) {
//        userRepository.findByEmail(email).ifPresent(userRepository::delete);
//    }
//
//
//    public UserDTO convertToDTO(User user) {
//        return new UserDTO(
//                user.getId(),
//                user.getName(),
//                user.getEmail(),
//                user.getCell(),
//                user.getAddress(),
//                user.getDob(),
//                user.getGender(),
//                user.getImage(),
//                user.isActive(),
//                user.isLock(),
//                user.getRole()
//        );
//    }
//
//    // Method to convert DTO to entity
//    public User convertToEntity(UserDTO userDTO) {
//        User user = new User();
//        user.setId(userDTO.getId());
//        user.setName(userDTO.getName());
//        user.setEmail(userDTO.getEmail());
//        user.setCell(userDTO.getCell());
//        user.setAddress(userDTO.getAddress());
//        user.setDob(userDTO.getDob());
//        user.setGender(userDTO.getGender());
//        user.setImage(userDTO.getImage());
//        user.setActive(userDTO.isActive());
//        user.setLock(userDTO.isLock());
//        user.setRole(userDTO.getRole());
//        return user;
//    }
//
//    // Find user by ID method
//    public User findUserById(long id) {
//        Optional<User> user = userRepository.findById(id);
//        if (user.isPresent()) {
//            return user.get();
//        } else {
//            throw new RuntimeException("User not found with id: " + id);
//        }
//    }
//
//    // Save user method
//    public User saveUser(User user) {
//        return userRepository.save(user);
//    }
//
//
//}
//
