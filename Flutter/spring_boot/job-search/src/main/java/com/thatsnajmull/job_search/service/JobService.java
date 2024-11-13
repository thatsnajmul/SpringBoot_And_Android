package com.thatsnajmull.job_search.service;

import com.thatsnajmull.job_search.entity.JobEntity;
import com.thatsnajmull.job_search.repository.JobRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;

@Service
public class JobService {

    @Value("${uploads.dir}")
    private String uploads;

    @Autowired
    private JobRepository jobRepository;

    // Logger for error handling
    private final Logger logger = LoggerFactory.getLogger(JobService.class);

    // Get all jobs
    public List<JobEntity> getAllJob() {
        return jobRepository.findAll();
    }

    // Get job by ID
    public JobEntity getJobById(Long id) {
        Optional<JobEntity> job = jobRepository.findById(id);
        return job.orElse(null); // Return null if not found
    }

    // Save image to disk and return the image filename
    public String saveImage(MultipartFile image) throws IOException {
        if (image == null || image.isEmpty()) {
            throw new IllegalArgumentException("Image file is empty or null");
        }

        String originalFilename = StringUtils.cleanPath(image.getOriginalFilename());
        String newFilename = System.currentTimeMillis() + "_" + originalFilename;

        // Create the image file path
        Path imagePath = Paths.get(uploads+ "/jobs", newFilename);

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

    // Add job with image filename
    public String addJob(JobEntity job) {
        // Check if the job already exists
        if (jobRepository.existsByJobTitleAndDescriptionAndRequirementsAndLocationAndSalaryAndJobTypeAndPositionAndSkillsAndCompanyName(
                job.getJobTitle(),
                job.getDescription(),
                job.getRequirements(),
                job.getLocation(),
                job.getSalary(),
                job.getJobType(),
                job.getPosition(),
                job.getSkills(),
                job.getCompanyName())) {
            return "This job already exists in the database";
        }

        // Save the job entity
        jobRepository.save(job);
        return "Job added successfully";
    }

    // Update job with image filename
    public String updateJob(JobEntity job) {
        if (!jobRepository.existsById(job.getId())) {
            return "Job not found";
        }

        // Update job entity in the repository
        jobRepository.save(job);
        return "Job updated successfully";
    }

    // Remove job
    public String removeJob(Long id) {
        if (jobRepository.existsById(id)) {
            JobEntity job = jobRepository.findById(id).orElse(null);
            if (job != null && job.getImage() != null) {
                try {
                    deleteImage(job.getImage());  // Delete the image if associated
                } catch (IOException e) {
                    return "Error deleting image: " + e.getMessage();
                }
            }
            jobRepository.deleteById(id);
            return "Job removed successfully";
        } else {
            return "Job not found";
        }
    }

    // Optionally, you can add logic to delete the image file from the disk when removing or updating jobs.
    public void deleteImage(String imageFilename) throws IOException {
        if (imageFilename != null && !imageFilename.isEmpty()) {
            Path imagePath = Paths.get(uploads + "/companies", imageFilename);
            Files.deleteIfExists(imagePath);
        }
    }

    // Other methods...
}
