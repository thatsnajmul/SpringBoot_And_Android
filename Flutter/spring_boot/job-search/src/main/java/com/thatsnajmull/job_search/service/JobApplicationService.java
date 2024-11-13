package com.thatsnajmull.job_search.service;

import com.thatsnajmull.job_search.entity.JobApplicationEntity;
import com.thatsnajmull.job_search.repository.JobApplicationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class JobApplicationService {

    @Value("${uploads.dir}")
    private String uploads;

    @Autowired
    private JobApplicationRepository jobApplicationRepository;

    // Logger for error handling
    private final Logger logger = LoggerFactory.getLogger(JobApplicationService.class);

    // Method to list all job applications
    public List<JobApplicationEntity> getAllJobApplications() {
        List<JobApplicationEntity> applications = jobApplicationRepository.findAll();
        List<JobApplicationEntity> customApplications = new ArrayList<>();
        applications.forEach(e -> {
            JobApplicationEntity model = new JobApplicationEntity();
            BeanUtils.copyProperties(e, model);
            customApplications.add(model);
        });
        return customApplications;
    }

    // Method to get a single job application by ID
    public JobApplicationEntity getJobApplicationById(Long applicationId) {
        Optional<JobApplicationEntity> jobApplicationEntity = jobApplicationRepository.findById(applicationId);
        return jobApplicationEntity.orElseThrow(() -> new RuntimeException("Job application not found for ID: " + applicationId));
    }

    // Save image to disk and return the image filename
    public String saveImage(MultipartFile image) throws IOException {
        if (image == null || image.isEmpty()) {
            throw new IllegalArgumentException("Image file is empty or null");
        }

        String originalFilename = StringUtils.cleanPath(image.getOriginalFilename());
        String newFilename = System.currentTimeMillis() + "_" + originalFilename;

        // Create the image file path
        Path imagePath = Paths.get(uploads + "/job-applications", newFilename);

        // Ensure the directory exists
        Files.createDirectories(imagePath.getParent());

        try {
            Files.copy(image.getInputStream(), imagePath);
        } catch (IOException e) {
            logger.error("Failed to save image: " + e.getMessage(), e);
            throw new IOException("Could not save image file", e);
        }

        return newFilename;
    }

    @Transactional
    public String addJobApplication(JobApplicationEntity jobApplication, MultipartFile applicantImage) {
        if (jobApplicationRepository.existsByApplicantNameAndApplicantEmailAndApplicantPhoneAndResumeLinkAndApplicationDateAndApplicationStatusAndCoverLetterAndJobTitleAppliedAndSkillsAndJobTypeAppliedAndLocationPreferenceAndPositionLevel(
                jobApplication.getApplicantName(),
                jobApplication.getApplicantEmail(),
                jobApplication.getApplicantPhone(),
                jobApplication.getResumeLink(),
                jobApplication.getApplicationDate(),
                jobApplication.getApplicationStatus(),
                jobApplication.getCoverLetter(),
                jobApplication.getJobTitleApplied(),
                jobApplication.getSkills(),
                jobApplication.getJobTypeApplied(),
                jobApplication.getLocationPreference(),
                jobApplication.getPositionLevel())) {
            return "This job application already exists in the database";
        }

        JobApplicationEntity jobApplicationEntity = new JobApplicationEntity();
        BeanUtils.copyProperties(jobApplication, jobApplicationEntity);

        // If an image is uploaded, save the image and set the image filename to the job application entity
        if (applicantImage != null && !applicantImage.isEmpty()) {
            try {
                String imageFilename = saveImage(applicantImage);
                jobApplicationEntity.setApplicantImage(imageFilename); // Set the image filename
            } catch (IOException e) {
                return "Failed to save image: " + e.getMessage();
            }
        }

        jobApplicationRepository.save(jobApplicationEntity);
        return "Job application added successfully";
    }

    // Method to delete a job application by ID
    @Transactional
    public String removeJobApplication(Long applicationId) {
        if (!jobApplicationRepository.existsById(applicationId)) {
            return "Job application doesn't exist";
        }

        // Get the job application and delete the associated image if it exists
        JobApplicationEntity jobApplication = jobApplicationRepository.findById(applicationId).orElse(null);
        if (jobApplication != null && jobApplication.getApplicantImage() != null) {
            try {
                deleteImage(jobApplication.getApplicantImage());  // Delete the image if associated
            } catch (IOException e) {
                return "Error deleting image: " + e.getMessage();
            }
        }

        jobApplicationRepository.deleteById(applicationId);
        return "Job application deleted successfully";
    }

    // Delete the image file from the disk
    public void deleteImage(String imageFilename) throws IOException {
        if (imageFilename != null && !imageFilename.isEmpty()) {
            Path imagePath = Paths.get(uploads + "/job-applications", imageFilename);
            Files.deleteIfExists(imagePath);
        }
    }

    // Update the job application details
    @Transactional
    public String updateJobApplication(Long applicationId, JobApplicationEntity jobApplication) {
        Optional<JobApplicationEntity> existingJobApplication = jobApplicationRepository.findById(applicationId);

        if (!existingJobApplication.isPresent()) {
            return "Job application not found";
        }

        JobApplicationEntity jobApplicationToUpdate = existingJobApplication.get();
        BeanUtils.copyProperties(jobApplication, jobApplicationToUpdate);

        jobApplicationRepository.save(jobApplicationToUpdate);
        return "Job application updated successfully";
    }
}
