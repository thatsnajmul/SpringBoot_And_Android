package com.thatsnajmull.job_search.service;

import com.thatsnajmull.job_search.entity.CompanyEntity;
import com.thatsnajmull.job_search.repository.CompanyRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CompanyService {

    @Autowired
    private CompanyRepository companyRepository;

    // Method to list all companies
    public List<CompanyEntity> getAllCompanies() {
        return companyRepository.findAll();
    }

    // Method to get a single company by ID
    public CompanyEntity getCompanyById(Long companyId) {
        Optional<CompanyEntity> companyEntity = companyRepository.findById(companyId);
        if (companyEntity.isPresent()) {
            return companyEntity.get();
        } else {
            throw new RuntimeException("Company not found for ID: " + companyId); // Handle exception as needed
        }
    }

    @Transactional
    // Method to add a new company
    public String addCompany(CompanyEntity company) {
        // Checking if the company already exists based on the combination of fields
        if (!companyRepository.existsByCompanyNameAndCompanyEmailAndCompanyPhoneAndCompanyAddressAndCompanyImageAndCompanyDetailsAndEmployeeSize(
                company.getCompanyName(),
                company.getCompanyEmail(),
                company.getCompanyPhone(),
                company.getCompanyAddress(),
                company.getCompanyImage(),
                company.getCompanyDetails(),
                company.getEmployeeSize())) {
            // If not exists, save the new company
            companyRepository.save(company);
            return "Company added successfully";
        } else {
            return "This company already exists in the database";
        }
    }

    @Transactional
    // Method to update an existing company
    public String updateCompany(CompanyEntity company) {
        Optional<CompanyEntity> existingCompanyOpt = companyRepository.findById(company.getCompanyId());
        if (existingCompanyOpt.isPresent()) {
            CompanyEntity existingCompany = existingCompanyOpt.get();
            // Copy properties from the new company to the existing one, excluding the ID
            BeanUtils.copyProperties(company, existingCompany, "companyId");
            companyRepository.save(existingCompany);
            return "Company updated successfully";
        } else {
            return "Company doesn't exist";
        }
    }

    @Transactional
    // Method to delete a company by ID
    public String removeCompany(Long companyId) {
        if (companyRepository.existsById(companyId)) {
            companyRepository.deleteById(companyId);
            return "Company deleted successfully";
        } else {
            return "Company doesn't exist";
        }
    }
}
