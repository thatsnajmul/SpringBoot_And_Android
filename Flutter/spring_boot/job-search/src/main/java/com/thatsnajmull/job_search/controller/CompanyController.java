package com.thatsnajmull.job_search.controller;

import com.thatsnajmull.job_search.entity.CompanyEntity;
import com.thatsnajmull.job_search.service.CompanyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:9097")
@RequestMapping("/api/companies") // Base URL for company-related APIs
public class CompanyController {

    @Autowired
    private CompanyService companyService;

    // Get all companies
    @GetMapping("get-all-companies")
    public List<CompanyEntity> getAllCompanies() {
        return companyService.getAllCompanies();
    }

    // Get company by ID
    @GetMapping("/{id}")
    public ResponseEntity<CompanyEntity> getCompanyById(@PathVariable Long id) {
        CompanyEntity company = companyService.getCompanyById(id);
        if (company != null) {
            return ResponseEntity.ok(company);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Add a new company
    @PostMapping("add-company")
    public String addCompany(@RequestBody CompanyEntity company) {
        return companyService.addCompany(company);
    }

    // Update an existing company
    @PutMapping("/{id}")
    public String updateCompany(@PathVariable Long id, @RequestBody CompanyEntity company) {
        company.setId(id); // Set the ID from the path variable
        return companyService.updateCompany(company);
    }

    // Delete a company by ID
    @DeleteMapping("/{id}")
    public String removeCompany(@PathVariable Long id) {
        return companyService.removeCompany(id);
    }
}

