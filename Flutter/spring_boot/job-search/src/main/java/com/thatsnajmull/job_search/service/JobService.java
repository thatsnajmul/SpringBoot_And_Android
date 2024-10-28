package com.thatsnajmull.job_search.service;

import com.thatsnajmull.job_search.entity.JobEntity;
import com.thatsnajmull.job_search.model.Job;
import com.thatsnajmull.job_search.repository.JobRepository;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class JobService {

    @Autowired
    private JobRepository jobRepository;

    // Job show method
    public List<Job> getAllJob() {
        List<JobEntity> jobs = jobRepository.findAll();
        List<Job> customJobs = new ArrayList<>();
        jobs.forEach(e -> {
            Job job = new Job();
            BeanUtils.copyProperties(e, job);
            customJobs.add(job);
        });
        return customJobs;
    }

    public JobEntity getJobById(Long id) {
        return jobRepository.findById(id).orElse(null); // Assuming you have a JobRepository
    }


    // Job save/add method
    public String addJob(JobEntity job) {
        if (!jobRepository.existsByJobTitleAndDescriptionAndRequirementsAndLocationAndSalaryAndJobTypeAndPositionAndSkillsAndCompanyName(
                job.getJobTitle(),
                job.getDescription(),
                job.getRequirements(),
                job.getLocation(),
                job.getSalary(),
                job.getJobType(),
                job.getPosition(),
                job.getSkills(),
                job.getCompanyName())) {
            jobRepository.save(job);
            return "Job added successfully";
        } else {
            return "This job already exists in the database";
        }
    }


    // Job delete method in JobService
    public String removeJob(Long id) { // Accept id instead of JobEntity
        if (jobRepository.existsById(id)) {
            jobRepository.deleteById(id); // Use deleteById for better clarity
            return "Job deleted successfully";
        } else {
            return "Job doesn't exist";
        }
    }




//    // Job delete method
//    public String removeJob(Long job) {
//        if (jobRepository.existsById(job.getId())) {
//            jobRepository.delete(job);
//            return "Job deleted successfully";
//        } else {
//            return "Job doesn't exist";
//        }
//    }

    // Job update method
    public String updateJob(JobEntity job) {
        if (jobRepository.existsById(job.getId())) {
            jobRepository.save(job);
            return "Job updated successfully";
        } else {
            return "Job doesn't exist";
        }
    }


}



//package com.thatsnajmull.job_search.service;
//
//import com.thatsnajmull.job_search.entity.JobEntity;
//import com.thatsnajmull.job_search.model.Job;
//import com.thatsnajmull.job_search.repository.JobRepository;
//import org.springframework.beans.BeanUtils;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//
//import java.util.ArrayList;
//import java.util.List;
//
//@Service
//public class JobService {
//
//    @Autowired
//    JobRepository jobRepository;
//
//    //Job show method
//    public List<Job> getAllJob(){
//        try{
//            List<JobEntity> jobs = jobRepository.findAll();
//            List<Job> customJobs = new ArrayList<>();
//            jobs.stream().forEach(e ->{
//                Job job = new Job();
//                BeanUtils.copyProperties(e, job);
//                customJobs.add(job);
//            });
//            return customJobs;
//        }
//        catch (Exception e){
//            throw e;
//
//        }
//    }
//
//    //Job save/add method
//    public String addJob(JobEntity job){
//        try{
//            if (!jobRepository.existsByAllJobProperties(
//                    job.getJobTitle(),
//                    job.getDescription(),
//                    job.getRequirements(),
//                    job.getLocation(),
//                    job.getSalary(),
//                    job.getJobType(),
//                    job.getPosition(),
//                    job.getSkills(),
//                    job.getCompanyName())){
//                        jobRepository.save(job);
//                    return "Job added successfully";
//            }
//            else {
//                return "This job already exists in the database";
//            }
//        }
//        catch (Exception e){
//            throw e;
//        }
//    }
//
//
//    //Job delete method
//    public String removeJob(JobEntity job){
//        try{
//            if (jobRepository.existsById(job.getId())){
//                jobRepository.delete(job);
//                return "Job deleted successfully";
//            }
//            else {
//                return "Job doesn't exists";
//            }
//        }
//        catch (Exception e){
//            throw e;
//        }
//    }
////    public String removeJob(JobEntity job){
////        try{
////            if (jobRepository.existsByAllJobProperties(
////                    job.getJobTitle(),
////                    job.getDescription(),
////                    job.getRequirements(),
////                    job.getLocation(),
////                    job.getSalary(),
////                    job.getJobType(),
////                    job.getPosition(),
////                    job.getSkills(),
////                    job.getCompanyName())){
////                jobRepository.delete(job);
////                return "Job deleted successfully";
////            }
////            else {
////                return "Job doesn't exists";
////            }
////        }
////
////        catch (Exception e){
////            throw e;
////        }
////    }
//
//    //Job update method
//
//    public String updateJob(JobEntity job){
//        try{
//            if (jobRepository.existsById(job.getId())){
//                jobRepository.save(job);
//                return "Job updated successfully";
//            }
//            else {
//                return "Job doesn't exists";
//            }
//        }
//        catch (Exception e){
//            throw e;
//        }
//    }
//
//}
