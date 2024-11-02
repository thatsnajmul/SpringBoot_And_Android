package com.thatsnajmull.job_search.service;

import com.thatsnajmull.job_search.entity.JobApplicationEntity;
import com.thatsnajmull.job_search.model.JobApplicationModel;
import com.thatsnajmull.job_search.repository.JobApplicationRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class JobApplicationService {

    @Autowired
    private JobApplicationRepository jobApplicationRepository;

    // Method to list all job applications
    public List<JobApplicationModel> getAllJobApplications() {
        List<JobApplicationEntity> applications = jobApplicationRepository.findAll();
        List<JobApplicationModel> customApplications = new ArrayList<>();
        applications.forEach(e -> {
            JobApplicationModel model = new JobApplicationModel();
            BeanUtils.copyProperties(e, model);
            customApplications.add(model);
        });
        return customApplications;
    }

    // Method to get a single job application by ID
    public JobApplicationModel getJobApplicationById(Long id) {
        Optional<JobApplicationEntity> jobApplicationEntity = jobApplicationRepository.findById(id);
        if (jobApplicationEntity.isPresent()) {
            JobApplicationModel model = new JobApplicationModel();
            BeanUtils.copyProperties(jobApplicationEntity.get(), model);
            return model;
        } else {
            throw new RuntimeException("Job application not found for ID: " + id); // Consider creating a custom exception
        }
    }

    @Transactional
    public String addJobApplication(JobApplicationModel jobApplication) {
        if (!jobApplicationRepository.existsByApplicantNameAndApplicantEmailAndApplicantPhoneAndResumeLinkAndApplicationDateAndApplicationStatusAndCoverLetterAndJobTitleAppliedAndSkillsAndJobTypeAppliedAndLocationPreferenceAndPositionLevel(
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
                jobApplication.getPositionLevel()
        )) {
            JobApplicationEntity jobApplicationEntity = new JobApplicationEntity();
            BeanUtils.copyProperties(jobApplication, jobApplicationEntity);
            jobApplicationRepository.save(jobApplicationEntity);
            return "Job application added successfully";
        } else {
            return "This job application already exists in the database";
        }
    }

    // Method to delete a job application by ID
    @Transactional
    public String removeJobApplication(Long id) {
        if (jobApplicationRepository.existsByApplicationId(id)) {
            jobApplicationRepository.deleteById(id);
            return "Job application deleted successfully";
        } else {
            return "Job application doesn't exist";
        }
    }

    // Method to update a job application
    @Transactional
    public String updateJobApplication(JobApplicationModel jobApplication) {
        Optional<JobApplicationEntity> existingApplicationOpt = jobApplicationRepository.findById(jobApplication.getApplicationId());
        if (existingApplicationOpt.isPresent()) {
            JobApplicationEntity existingApplication = existingApplicationOpt.get();
            BeanUtils.copyProperties(jobApplication, existingApplication, "applicationId"); // Exclude ID from copying
            jobApplicationRepository.save(existingApplication);
            return "Job application updated successfully";
        } else {
            return "Job application doesn't exist";
        }
    }
}
