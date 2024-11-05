package com.thatsnajmull.job_search.service;

import com.thatsnajmull.job_search.entity.CompanyEntity;
import com.thatsnajmull.job_search.repository.CompanyRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CompanyService {

    @Autowired
    private CompanyRepository companyRepository;

    // Retrieve all companies
    public List<CompanyEntity> getAllCompanies() {
        return companyRepository.findAll();
    }

    // Retrieve company by ID
    public CompanyEntity getCompanyById(Long id) {
        return companyRepository.findById(id).orElseThrow(() -> new EntityNotFoundException("Company not found for ID: " + id));
    }

    // Add a new company
    public String addCompany(CompanyEntity company) {
        if (!companyRepository.existsByCompanyName(company.getCompanyName())) {
            companyRepository.save(company);
            return "Company added successfully";
        } else {
            return "This company already exists in the database";
        }
    }

    // Update an existing company
    public String updateCompany(CompanyEntity company) {
        if (companyRepository.existsById(company.getId())) {
            companyRepository.save(company);
            return "Company updated successfully";
        } else {
            return "Company doesn't exist";
        }
    }

    // Delete company by ID
    public String removeCompany(Long id) {
        if (companyRepository.existsById(id)) {
            companyRepository.deleteById(id);
            return "Company deleted successfully";
        } else {
            return "Company doesn't exist";
        }
    }
}
