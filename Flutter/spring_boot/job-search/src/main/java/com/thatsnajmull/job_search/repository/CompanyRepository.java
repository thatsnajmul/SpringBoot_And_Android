package com.thatsnajmull.job_search.repository;

import com.thatsnajmull.job_search.entity.CompanyEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CompanyRepository extends JpaRepository<CompanyEntity, Long> {

    // Checks if a company with a given company ID exists (This is provided by JpaRepository, no need to define explicitly)
    boolean existsByCompanyId(Long companyId);

    // Custom method to check if a company exists by multiple fields
    boolean existsByCompanyNameAndCompanyEmailAndCompanyPhoneAndCompanyAddressAndCompanyImageAndCompanyDetailsAndEmployeeSize(
            String companyName,
            String companyEmail,
            String companyPhone,
            String companyAddress,
            String companyImage, // URL or path to the company image
            String companyDetails,
            int employeeSize
    );
    boolean existsById(Long companyId);
}



