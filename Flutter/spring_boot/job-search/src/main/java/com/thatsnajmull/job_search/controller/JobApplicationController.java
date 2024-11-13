package com.thatsnajmull.job_search.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.thatsnajmull.job_search.entity.JobApplicationEntity;
import com.thatsnajmull.job_search.entity.JobEntity;
import com.thatsnajmull.job_search.service.JobApplicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/job-applications")
public class JobApplicationController {

    @Autowired
    private JobApplicationService jobApplicationService;

    @GetMapping("/getall")
    public ResponseEntity<List<JobApplicationEntity>> getAllJobApplications() {
        List<JobApplicationEntity> applications = jobApplicationService.getAllJobApplications();
        return ResponseEntity.ok(applications);
    }

    @GetMapping("/{applicationId}")
    public ResponseEntity<JobApplicationEntity> getJobApplicationById(@PathVariable Long applicationId) {
        try {
            JobApplicationEntity application = jobApplicationService.getJobApplicationById(applicationId);
            return ResponseEntity.ok(application);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @PostMapping("/add")
    public ResponseEntity<String> addJobApplication(
            @RequestPart("jobApplication") String jobApplication,
            @RequestPart(value = "applicantImage", required = false) MultipartFile applicantImage) throws JsonProcessingException {
        JobApplicationEntity jobApplicationEntity = new ObjectMapper().readValue(jobApplication, JobApplicationEntity.class);
        String response = jobApplicationService.addJobApplication(jobApplicationEntity, applicantImage);
        return response.equals("Job application added successfully")
                ? ResponseEntity.status(HttpStatus.CREATED).body(response)
                : ResponseEntity.badRequest().body(response);
    }

    @PutMapping("/{applicationId}")
    public ResponseEntity<String> updateJobApplication(@PathVariable Long applicationId, @RequestBody JobApplicationEntity jobApplication) {
        String response = jobApplicationService.updateJobApplication(applicationId, jobApplication);
        return response.equals("Job application updated successfully")
                ? ResponseEntity.ok(response)
                : ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    @DeleteMapping("/{applicationId}")
    public ResponseEntity<String> deleteJobApplication(@PathVariable Long applicationId) {
        String response = jobApplicationService.removeJobApplication(applicationId);
        return response.equals("Job application deleted successfully")
                ? ResponseEntity.ok(response)
                : ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }
}
