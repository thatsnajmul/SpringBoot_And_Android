package com.thatsnajmull.job_search.repository;

import com.thatsnajmull.job_search.entity.JobApplicationEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;

@Repository
public interface JobApplicationRepository extends JpaRepository<JobApplicationEntity, Long> {

    // This custom query method checks for duplicate job applications by relevant fields
    boolean existsByApplicantNameAndApplicantEmailAndApplicantPhoneAndResumeLinkAndApplicationDateAndApplicationStatusAndCoverLetterAndJobTitleAppliedAndSkillsAndJobTypeAppliedAndLocationPreferenceAndPositionLevel(
            String applicantName,
            String applicantEmail,
            String applicantPhone,
            String resumeLink,
            Date applicationDate, // Use LocalDate instead of String
            String applicationStatus,
            String coverLetter,
            String jobTitleApplied,
            String skills,
            String jobTypeApplied,
            String locationPreference,
            String positionLevel
    );
}
