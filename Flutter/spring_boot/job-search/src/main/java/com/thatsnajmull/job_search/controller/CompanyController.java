package com.thatsnajmull.job_search.controller;

import com.thatsnajmull.job_search.entity.CompanyEntity;
import com.thatsnajmull.job_search.service.CompanyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:9097")  // Enable CORS for the given frontend URL
@RequestMapping("api/companies")  // Simplified URL for consistency
public class CompanyController {

    @Autowired
    private CompanyService companyService;

    // Get all companies
    @GetMapping("/get-all-companies")
    public ResponseEntity<List<CompanyEntity>> getAllCompanies() {
        List<CompanyEntity> companies = companyService.getAllCompanies();
        return ResponseEntity.ok(companies);  // Return 200 OK with the list of companies
    }

    // Get company by ID
    @GetMapping("/get-by-id/{companyId}")
    public ResponseEntity<CompanyEntity> getCompanyById(@PathVariable Long companyId) {
        try {
            CompanyEntity company = companyService.getCompanyById(companyId);
            return ResponseEntity.ok(company);  // Return 200 OK with company details
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();  // Return 404 if company not found
        }
    }

    // Add a new company
    @PostMapping("/add-company")
    public ResponseEntity<String> addCompany(@RequestBody CompanyEntity company) {
        String response = companyService.addCompany(company);
        if (response.contains("successfully")) {
            return ResponseEntity.status(HttpStatus.CREATED).body(response);  // 201 Created when company is successfully added
        } else {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(response);  // 409 Conflict if company already exists
        }
    }

    // Update an existing company
    @PutMapping("/update/{companyId}")
    public ResponseEntity<String> updateCompany(@PathVariable Long companyId, @RequestBody CompanyEntity company) {
        company.setCompanyId(companyId);  // Corrected this line to set the ID properly
        String response = companyService.updateCompany(company);
        if (response.contains("updated")) {
            return ResponseEntity.ok(response);  // 200 OK if company is updated successfully
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);  // 404 Not Found if company does not exist
        }
    }

    // Delete a company by ID
    @DeleteMapping("/delete/{companyId}")
    public ResponseEntity<String> removeCompany(@PathVariable Long companyId) {
        String response = companyService.removeCompany(companyId);
        if (response.contains("deleted")) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();  // 204 No Content for successful deletion
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);  // 404 Not Found if company does not exist
        }
    }
}
