package com.thatsnajmull.job_search.controller;

import com.thatsnajmull.job_search.model.JobApplicationModel;
import com.thatsnajmull.job_search.service.JobApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:9097")
@RequestMapping("/jobapplications") // Base URL for all endpoints
public class JobApplicationController {

    @Autowired
    private JobApplicationService jobApplicationService;

    // Get all job applications
    @GetMapping("/getall") // URL: /jobapplications/getall
    public ResponseEntity<List<JobApplicationModel>> getAllJobApplications() {
        List<JobApplicationModel> applications = jobApplicationService.getAllJobApplications();
        return ResponseEntity.ok(applications); // Return applications with 200 OK
    }

    // Get job application by ID
    @GetMapping("/get/{applicationId}") // URL: /jobapplications/get/{id}
    public ResponseEntity<JobApplicationModel> getJobApplicationById(@PathVariable Long applicationId) {
        JobApplicationModel jobApplication = jobApplicationService.getJobApplicationById(applicationId);
        return ResponseEntity.ok(jobApplication); // Return application if found
    }

    // Add a new job application
    @PostMapping("/add") // URL: /jobapplications/add
    public ResponseEntity<String> addJobApplication(@RequestBody JobApplicationModel jobApplication) {
        String responseMessage = jobApplicationService.addJobApplication(jobApplication);
        return responseMessage.equals("Job application added successfully")
                ? ResponseEntity.status(HttpStatus.CREATED).body(responseMessage) // 201 Created
                : ResponseEntity.status(HttpStatus.CONFLICT).body(responseMessage); // 409 Conflict
    }

    // Update job application
    @PutMapping("/update/{applicationId}") // URL: /jobapplications/update/{id}
    public ResponseEntity<String> updateJobApplication(@PathVariable Long applicationId, @RequestBody JobApplicationModel jobApplication) {
        jobApplication.setApplicationId(applicationId); // Set the ID from the path variable
        String responseMessage = jobApplicationService.updateJobApplication(jobApplication);
        return ResponseEntity.ok(responseMessage); // Return update response
    }

    // Remove job application by ID
    @DeleteMapping("delete/{applicationId}") // URL: /jobapplications/delete/{id}
    public ResponseEntity<String> removeJobApplication(@PathVariable Long applicationId) {
        String responseMessage = jobApplicationService.removeJobApplication(applicationId);
        return ResponseEntity.ok(responseMessage); // Return deletion response
    }
}
