package com.thatsnajmull.job_search.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class JobEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String jobTitle;
    private String description;
    private String requirements;
    private String location;
    private Double salary;
    private String jobType; // e.g., Full-time, Part-time, Contract
    private String position; // e.g., Junior, Senior, Intern
    private String skills; // Comma-separated list of required skills
    private String companyName;

    // Added image field to store image file name
    private String image;

    @ManyToOne
    @JoinColumn(name = "userId")
    @JsonBackReference // This is the child
    private User user;

}
