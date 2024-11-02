package com.thatsnajmull.job_search.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
public class JobApplicationEntity {

    @Id
    @GeneratedValue
    private Long applicationId;

    private String applicantName;
    private String applicantEmail;
    private String applicantPhone;
    private String resumeLink; // Link to the applicant's resume or uploaded file path
    private String applicationDate; // Date of application submission
    private String applicationStatus; // e.g., "Pending", "Reviewed", "Interview Scheduled", "Rejected"
    private String coverLetter;
    private String jobTitleApplied; // Title of the job the applicant applied for
    private String skills; // Skills of the applicant relevant to the job
    private String jobTypeApplied; // e.g., Full-time, Part-time, Contract
    private String locationPreference; // Applicant's preferred job location
    private String positionLevel; // e.g., Junior, Mid, Senior, Intern

    public JobApplicationEntity() {}

    // Getters and Setters
    public Long getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Long applicationId) {
        this.applicationId = applicationId;
    }

    public String getApplicantName() {
        return applicantName;
    }

    public void setApplicantName(String applicantName) {
        this.applicantName = applicantName;
    }

    public String getApplicantEmail() {
        return applicantEmail;
    }

    public void setApplicantEmail(String applicantEmail) {
        this.applicantEmail = applicantEmail;
    }

    public String getApplicantPhone() {
        return applicantPhone;
    }

    public void setApplicantPhone(String applicantPhone) {
        this.applicantPhone = applicantPhone;
    }

    public String getResumeLink() {
        return resumeLink;
    }

    public void setResumeLink(String resumeLink) {
        this.resumeLink = resumeLink;
    }

    public String getApplicationDate() {
        return applicationDate;
    }

    public void setApplicationDate(String applicationDate) {
        this.applicationDate = applicationDate;
    }

    public String getApplicationStatus() {
        return applicationStatus;
    }

    public void setApplicationStatus(String applicationStatus) {
        this.applicationStatus = applicationStatus;
    }

    public String getCoverLetter() {
        return coverLetter;
    }

    public void setCoverLetter(String coverLetter) {
        this.coverLetter = coverLetter;
    }

    public String getJobTitleApplied() {
        return jobTitleApplied;
    }

    public void setJobTitleApplied(String jobTitleApplied) {
        this.jobTitleApplied = jobTitleApplied;
    }

    public String getSkills() {
        return skills;
    }

    public void setSkills(String skills) {
        this.skills = skills;
    }

    public String getJobTypeApplied() {
        return jobTypeApplied;
    }

    public void setJobTypeApplied(String jobTypeApplied) {
        this.jobTypeApplied = jobTypeApplied;
    }

    public String getLocationPreference() {
        return locationPreference;
    }

    public void setLocationPreference(String locationPreference) {
        this.locationPreference = locationPreference;
    }

    public String getPositionLevel() {
        return positionLevel;
    }

    public void setPositionLevel(String positionLevel) {
        this.positionLevel = positionLevel;
    }
}
