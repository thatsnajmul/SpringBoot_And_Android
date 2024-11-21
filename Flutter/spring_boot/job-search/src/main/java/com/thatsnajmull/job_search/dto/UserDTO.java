package com.thatsnajmull.job_search.dto;

import com.thatsnajmull.job_search.entity.Role;

import java.sql.Date;

public class UserDTO {
    private long id;
    private String name;
    private String email;
    private String cell;
    private String address;
    private Date dob;
    private String gender;
    private String image;
    private boolean active;
    private boolean isLock;
    private Role role;

    // Default constructor
    public UserDTO() {
    }

    // Constructor to initialize fields
    public UserDTO(long id, String name, String email, String cell, String address, Date dob, String gender, String image, boolean active, boolean isLock, Role role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.cell = cell;
        this.address = address;
        this.dob = dob;
        this.gender = gender;
        this.image = image;
        this.active = active;
        this.isLock = isLock;
        this.role = role;
    }

    // Getters and Setters
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCell() {
        return cell;
    }

    public void setCell(String cell) {
        this.cell = cell;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public boolean isLock() {
        return isLock;
    }

    public void setLock(boolean isLock) {
        this.isLock = isLock;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }
}

