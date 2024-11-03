package com.thatsnajmull.job_search.model;

public class CompanyModel {

    private long id;
    private String companyName;
    private String companyImage; // URL or path to the company image
    private String companyDetails;
    private String companyEmail;
    private String companyAddress;
    private String companyPhone;
    private int employeeSize; // Number of employees

    public CompanyModel() {}

    // Getters and Setters
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyImage() {
        return companyImage;
    }

    public void setCompanyImage(String companyImage) {
        this.companyImage = companyImage;
    }

    public String getCompanyDetails() {
        return companyDetails;
    }

    public void setCompanyDetails(String companyDetails) {
        this.companyDetails = companyDetails;
    }

    public String getCompanyEmail() {
        return companyEmail;
    }

    public void setCompanyEmail(String companyEmail) {
        this.companyEmail = companyEmail;
    }

    public String getCompanyAddress() {
        return companyAddress;
    }

    public void setCompanyAddress(String companyAddress) {
        this.companyAddress = companyAddress;
    }

    public String getCompanyPhone() {
        return companyPhone;
    }

    public void setCompanyPhone(String companyPhone) {
        this.companyPhone = companyPhone;
    }

    public int getEmployeeSize() {
        return employeeSize;
    }

    public void setEmployeeSize(int employeeSize) {
        this.employeeSize = employeeSize;
    }
}

