package com.thatsnajmull.job_search.repository;

import com.thatsnajmull.job_search.entity.JobEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface JobRepository extends JpaRepository<JobEntity, Long> {

    boolean existsByJobTitleAndDescriptionAndRequirementsAndLocationAndSalaryAndJobTypeAndPositionAndSkillsAndCompanyName(
            String jobTitle,
            String description,
            String requirements,
            String location,
            Double salary,
            String jobType,
            String position,
            String skills,
            String companyName);

    boolean existsById(Long id);
}


