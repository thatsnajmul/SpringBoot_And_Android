package com.thatsnajmull.job_search.controller;

import com.thatsnajmull.job_search.entity.CompanyEntity;
import com.thatsnajmull.job_search.service.CompanyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:9097")
@RequestMapping("api/companies")  // Use a simplified URL for consistency
public class CompanyController {

    @Autowired
    private CompanyService companyService;

    // Get all companies
    @GetMapping("/get-all-companies")
    public ResponseEntity<List<CompanyEntity>> getAllCompanies() {
        List<CompanyEntity> companies = companyService.getAllCompanies();
        return ResponseEntity.ok(companies);  // Return 200 OK with list
    }

    // Get company by ID
    @GetMapping("/getbyid/{id}")
    public ResponseEntity<CompanyEntity> getCompanyById(@PathVariable Long id) {
        CompanyEntity company = companyService.getCompanyById(id);
        if (company != null) {
            return ResponseEntity.ok(company);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();  // Return 404 if company not found
        }
    }

    // Add a new company
    @PostMapping("/add-company")
    public ResponseEntity<String> addCompany(@RequestBody CompanyEntity company) {
        String response = companyService.addCompany(company);
        if (response.contains("successfully")) {
            return ResponseEntity.status(HttpStatus.CREATED).body(response);  // 201 Created
        } else {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(response);  // 409 Conflict if company exists
        }
    }

    // Update an existing company
    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateCompany(@PathVariable Long id, @RequestBody CompanyEntity company) {
        company.setId(id);  // Set ID from path variable
        String response = companyService.updateCompany(company);
        if (response.contains("updated")) {
            return ResponseEntity.ok(response);  // 200 OK if updated successfully
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);  // 404 if company doesn't exist
        }
    }

    // Delete a company by ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> removeCompany(@PathVariable Long id) {
        String response = companyService.removeCompany(id);
        return ResponseEntity.ok(response);  // 200 OK response for successful deletion
    }
}


