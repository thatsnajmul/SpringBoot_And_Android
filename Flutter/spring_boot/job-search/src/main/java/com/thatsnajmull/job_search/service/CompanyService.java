package com.thatsnajmull.job_search.service;

import com.thatsnajmull.job_search.entity.CompanyEntity;
import com.thatsnajmull.job_search.repository.CompanyRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;

@Service
public class CompanyService {

    @Value("${uploads.dir}")
    private String uploads;

    @Autowired
    private CompanyRepository companyRepository;

    private final Logger logger = LoggerFactory.getLogger(CompanyService.class);

    // Method to upload and save an image
    public String saveImage(MultipartFile image) throws IOException {
        if (image == null || image.isEmpty()) {
            throw new IllegalArgumentException("Image file is empty or null");
        }

        String originalFilename = StringUtils.cleanPath(image.getOriginalFilename());
        String newFilename = System.currentTimeMillis() + "_" + originalFilename;
        Path imagePath = Paths.get(uploads + "/companies", newFilename);
        Files.createDirectories(imagePath.getParent());

        try {
            Files.copy(image.getInputStream(), imagePath);
        } catch (IOException e) {
            logger.error("Failed to save image: " + e.getMessage(), e);
            throw new IOException("Could not save image file", e);
        }

        return newFilename;
    }

    // Method to list all companies
    public List<CompanyEntity> getAllCompanies() {
        return companyRepository.findAll();
    }

    // Method to get a single company by ID
    public CompanyEntity getCompanyById(Long companyId) {
        Optional<CompanyEntity> companyEntity = companyRepository.findById(companyId);
        return companyEntity.orElseThrow(() -> new RuntimeException("Company not found for ID: " + companyId));
    }

    @Transactional
    // Method to add a new company with image
    public String addCompany(CompanyEntity company, MultipartFile image) throws IOException {
        if (image != null && !image.isEmpty()) {
            String imageName = saveImage(image);
            company.setCompanyImage(imageName); // Set image name in the entity
        }

        if (!companyRepository.existsByCompanyNameAndCompanyEmailAndCompanyPhoneAndCompanyAddressAndCompanyImageAndCompanyDetailsAndEmployeeSize(
                company.getCompanyName(), company.getCompanyEmail(), company.getCompanyPhone(),
                company.getCompanyAddress(), company.getCompanyImage(), company.getCompanyDetails(),
                company.getEmployeeSize())) {
            companyRepository.save(company);
            return "Company added successfully";
        } else {
            return "This company already exists in the database";
        }
    }

    @Transactional
    // Method to update an existing company with new image
    public String updateCompany(CompanyEntity company, MultipartFile image) throws IOException {
        Optional<CompanyEntity> existingCompanyOpt = companyRepository.findById(company.getCompanyId());
        if (existingCompanyOpt.isPresent()) {
            CompanyEntity existingCompany = existingCompanyOpt.get();

            // Delete old image if a new one is provided
            if (image != null && !image.isEmpty()) {
                if (existingCompany.getCompanyImage() != null) {
                    deleteImage(existingCompany.getCompanyImage());
                }
                String imageName = saveImage(image);
                company.setCompanyImage(imageName); // Set new image name
            }

            // Copy properties from the updated company object
            BeanUtils.copyProperties(company, existingCompany, "companyId", "companyImage");
            companyRepository.save(existingCompany);
            return "Company updated successfully";
        } else {
            return "Company doesn't exist";
        }
    }

    @Transactional
    // Method to delete a company and its associated image
    public String removeCompany(Long companyId) {
        Optional<CompanyEntity> companyOpt = companyRepository.findById(companyId);
        if (companyOpt.isPresent()) {
            CompanyEntity company = companyOpt.get();
            if (company.getCompanyImage() != null) {
                try {
                    deleteImage(company.getCompanyImage()); // Delete associated image
                } catch (IOException e) {
                    return "Error deleting image: " + e.getMessage();
                }
            }
            companyRepository.deleteById(companyId);
            return "Company deleted successfully";
        } else {
            return "Company doesn't exist";
        }
    }

    // Helper method to delete an image file
    public void deleteImage(String imageFilename) throws IOException {
        if (imageFilename != null && !imageFilename.isEmpty()) {
            Path imagePath = Paths.get(uploads + "/companies", imageFilename);
            Files.deleteIfExists(imagePath);
        }
    }
}
