package com.thatsnajmull.job_search.service;

import com.thatsnajmull.job_search.entity.AuthenticationResponse;
import com.thatsnajmull.job_search.entity.Role;
import com.thatsnajmull.job_search.entity.Token;
import com.thatsnajmull.job_search.entity.User;
import com.thatsnajmull.job_search.jwt.JwtService;
import com.thatsnajmull.job_search.repository.TokenRepository;
import com.thatsnajmull.job_search.repository.UserRepository;
import jakarta.mail.MessagingException;
import lombok.AllArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final TokenRepository tokenRepository;
    private final AuthenticationManager authenticationManager;
    private final EmailService emailService;


    private void saveUserToken(String jwt, User user) {
        Token token = new Token();
        token.setToken(jwt);
        token.setLoggedOut(false);
        token.setUser(user);

        tokenRepository.save(token);
    }


    private void revokeAllTokenByUser(User user) {

        List<Token> validTokens = tokenRepository.findAllTokensByUser(user.getId());
        if (validTokens.isEmpty()) {
            return;
        }

        // Set all valid tokens for the user to logged out
        validTokens.forEach(t -> {
            t.setLoggedOut(true);
        });

        // Save the changes to the tokens in the token repository
        tokenRepository.saveAll(validTokens);
    }

    public AuthenticationResponse register(User user) {

        // Check if the user already exists
        if (userRepository.findByEmail(user.getUsername()).isPresent()) {
            return new AuthenticationResponse(null, "User already exists", null);
        }

        // Create a new user entity and save it to the database

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.valueOf("JOB_SEEKER"));
        user.setLock(true);
        user.setActive(false);

        userRepository.save(user);

        // Generate JWT token for the newly registered user
        String jwt = jwtService.generateToken(user);

        // Save the token to the token repository
        saveUserToken(jwt, user);
        sendActivationEmail(user);

        return new AuthenticationResponse(jwt, "User registration was successful", null);
    }


    public AuthenticationResponse registerAdmin(User user) {

        // Check if the user already exists
        if (userRepository.findByEmail(user.getUsername()).isPresent()) {
            return new AuthenticationResponse(null, "User already exists", null);
        }

        // Create a new user entity and save it to the database

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.valueOf("ADMIN"));
        user.setLock(true);
        user.setActive(false);

        userRepository.save(user);

        // Generate JWT token for the newly registered user
        String jwt = jwtService.generateToken(user);

        // Save the token to the token repository
        saveUserToken(jwt, user);
        sendActivationEmail(user);

        return new AuthenticationResponse(jwt, "User registration was successful", null);
    }

    public AuthenticationResponse registerEmployer(User user) {

        // Check if the user already exists
        if (userRepository.findByEmail(user.getUsername()).isPresent()) {
            return new AuthenticationResponse(null, "User already exists", null);
        }

        // Create a new user entity and save it to the database

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.valueOf("EMPLOYER"));
        user.setLock(true);
        user.setActive(false);

        userRepository.save(user);

        // Generate JWT token for the newly registered user
        String jwt = jwtService.generateToken(user);

        // Save the token to the token repository
        saveUserToken(jwt, user);
        sendActivationEmail(user);

        return new AuthenticationResponse(jwt, "User registration was successful", null);
    }

    // Method to authenticate a user
    public AuthenticationResponse authenticate(User request) {

        // Authenticate user credentials using Spring Security's AuthenticationManager
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        // Retrieve the user from the database
        User user = userRepository.findByEmail(request.getUsername()).orElseThrow();

        // Generate JWT token for the authenticated user
        String jwt = jwtService.generateToken(user);

        // Revoke all existing tokens for this user
        revokeAllTokenByUser(user);

        // Save the new token to the token repository
        saveUserToken(jwt, user);


        return new AuthenticationResponse(jwt, "User login was successful", user);
    }


    private void sendActivationEmail(User user) {
        String activationLink = "http://localhost:8080/activate/" + user.getId();

        String mailText = "Dear " + user.getName()
                + ","+ "\n"+
                 "Please click on the following link to confirm your account: "
                + activationLink + " Activate Account" +"\n"+
                 "Regards, Job Portal";

        String subject = "Confirm User Account";

        try {

            emailService.sendSimpleEmail(user.getEmail(), subject, mailText);

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }


    }


    // Activate user based on the token
    public String activateUser(long id) {

        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not Found with this ID"));

        if (user != null) {

            user.setActive(true);
            //  user.setActivationToken(null); // Clear token after activation
            userRepository.save(user);
            return "User activated successfully!";
        } else {
            return "Invalid activation token!";
        }
    }



    public long getUserId(String email){
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not Found with this ID"));

        return  user.getId();

    }






}


