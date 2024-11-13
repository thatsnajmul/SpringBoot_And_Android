package com.thatsnajmull.job_search.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;

@Entity
public class JobApplicationEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long applicationId;

    private String applicantName;
    private String applicantEmail;
    private String applicantPhone;
    private String resumeLink;

    @Temporal(TemporalType.DATE)
    private Date applicationDate; // Changed to LocalDate
    private String applicationStatus;
    private String coverLetter;
    private String jobTitleApplied;
    private String skills;
    private String jobTypeApplied;
    private String locationPreference;
    private String positionLevel;
    private String applicantImage;

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

    public Date getApplicationDate() {
        return applicationDate;
    }

    public void setApplicationDate(Date applicationDate) {
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

    public String getApplicantImage() {
        return applicantImage;
    }

    public void setApplicantImage(String applicantImage) {
        this.applicantImage = applicantImage;
    }

}
