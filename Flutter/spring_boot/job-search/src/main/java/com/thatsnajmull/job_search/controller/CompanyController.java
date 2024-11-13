package com.thatsnajmull.job_search.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.thatsnajmull.job_search.entity.CompanyEntity;
import com.thatsnajmull.job_search.service.CompanyService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:9097")  // Enable CORS for the given frontend URL
@RequestMapping("api/companies")  // Simplified URL for consistency
public class CompanyController {

    private final Logger logger = LoggerFactory.getLogger(CompanyController.class);

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

    // Add a new company with image
    @PostMapping("/add-company")
    public ResponseEntity<String> addCompany(@RequestParam("companyDetails") String companyDetails,
                                             @RequestParam("image") MultipartFile image) {
        try {
            // Parse JSON string to CompanyEntity object
            CompanyEntity company = new ObjectMapper().readValue(companyDetails, CompanyEntity.class);

            // Save the image and set its filename in the entity
            String imageName = companyService.saveImage(image);
            company.setCompanyImage(imageName);

            // Add company to the database
            String response = companyService.addCompany(company, image);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);  // 201 Created for successful addition

        } catch (IOException e) {
            logger.error("Error saving image or parsing company details: " + e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Server error: Could not process image or company details.");
        } catch (IllegalArgumentException e) {
            logger.error("Invalid image file: " + e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Client error: Invalid image file.");
        }
    }

    // Update an existing company with optional image
    @PutMapping("/update/{companyId}")
    public ResponseEntity<String> updateCompany(@PathVariable Long companyId,
                                                @RequestParam("companyDetails") String companyDetails,
                                                @RequestParam(value = "image", required = false) MultipartFile image) {
        try {
            // Parse JSON string to CompanyEntity object
            CompanyEntity company = new ObjectMapper().readValue(companyDetails, CompanyEntity.class);
            company.setCompanyId(companyId);

            if (image != null && !image.isEmpty()) {
                // Save the image and update the filename
                String imageName = companyService.saveImage(image);
                company.setCompanyImage(imageName); // Update image filename in entity
            }

            // Update company in database
            String response = companyService.updateCompany(company, image);
            return ResponseEntity.ok(response);  // 200 OK if update is successful

        } catch (IOException e) {
            logger.error("Error saving image or parsing company details: " + e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Server error: Could not process image or company details.");
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
