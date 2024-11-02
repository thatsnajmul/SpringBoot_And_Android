package com.thatsnajmull.job_search.repository;

import com.thatsnajmull.job_search.entity.JobApplicationEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JobApplicationRepository extends JpaRepository<JobApplicationEntity, Long> {

    boolean existsByApplicantNameAndApplicantEmailAndApplicantPhoneAndResumeLinkAndApplicationDateAndApplicationStatusAndCoverLetterAndJobTitleAppliedAndSkillsAndJobTypeAppliedAndLocationPreferenceAndPositionLevel(
            String applicantName,
            String applicantEmail,
            String applicantPhone,
            String resumeLink,
            String applicationDate,
            String applicationStatus,
            String coverLetter,
            String jobTitleApplied,
            String skills,
            String jobTypeApplied,
            String locationPreference,
            String positionLevel);

    boolean existsByApplicationId(Long applicationId);
}
