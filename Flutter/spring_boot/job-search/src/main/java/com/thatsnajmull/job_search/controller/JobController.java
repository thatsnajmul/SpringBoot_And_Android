package com.thatsnajmull.job_search.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.thatsnajmull.job_search.entity.JobEntity;
import com.thatsnajmull.job_search.service.JobService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:9097")
public class JobController {

    private final Logger logger = LoggerFactory.getLogger(JobController.class);

    @Autowired
    private JobService jobService;

    // Get all jobs
    @GetMapping("getalljobs")
    public List<JobEntity> getAllJobs() {
        return jobService.getAllJob();
    }

    // Get job by ID
    @GetMapping("getjob/{id}")
    public ResponseEntity<JobEntity> getJobById(@PathVariable Long id) {
        JobEntity job = jobService.getJobById(id);
        if (job != null) {
            return ResponseEntity.ok(job);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Add job with image
    @PostMapping("addjob")
    public ResponseEntity<String> addJob(@RequestParam("jobDetails") String jobDetails,
                                         @RequestParam("image") MultipartFile image) {
        try {
            JobEntity job = new ObjectMapper().readValue(jobDetails, JobEntity.class);

            // Save the image and set the filename on the job entity
            String imageFilename = jobService.saveImage(image);
            job.setImage(imageFilename); // Set the image filename to the job entity

            // Add the job to the database
            String result = jobService.addJob(job);
            return ResponseEntity.ok(result);

        } catch (IOException e) {
            logger.error("Error saving image or parsing job details: " + e.getMessage(), e);
            return ResponseEntity.status(500).body("Server error: Could not process image or job details.");
        } catch (IllegalArgumentException e) {
            logger.error("Invalid image file: " + e.getMessage(), e);
            return ResponseEntity.status(400).body("Client error: Invalid image file.");
        }
    }

    // Update job with image
    @PutMapping("updatejob/{id}")
    public ResponseEntity<String> updateJob(@PathVariable Long id,
                                            @RequestParam("jobDetails") String jobDetails,
                                            @RequestParam(value = "image", required = false) MultipartFile image) {
        try {
            JobEntity job = new ObjectMapper().readValue(jobDetails, JobEntity.class);
            job.setId(id);

            if (image != null && !image.isEmpty()) {
                // Save the image and update the filename
                String imageFilename = jobService.saveImage(image);
                job.setImage(imageFilename); // Update the image filename in the job entity
            }

            // Update the job in the database
            String result = jobService.updateJob(job);
            return ResponseEntity.ok(result);

        } catch (IOException e) {
            logger.error("Error saving image or parsing job details: " + e.getMessage(), e);
            return ResponseEntity.status(500).body("Server error: Could not process image or job details.");
        }
    }

    // Delete job
    @DeleteMapping("deletejob/{id}")
    public ResponseEntity<String> removeJob(@PathVariable Long id) {
        String result = jobService.removeJob(id);
        return ResponseEntity.ok(result);
    }
}
