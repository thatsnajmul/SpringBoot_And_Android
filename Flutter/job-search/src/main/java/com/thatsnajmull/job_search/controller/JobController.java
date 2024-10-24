package com.thatsnajmull.job_search.controller;

import com.thatsnajmull.job_search.entity.JobEntity;
import com.thatsnajmull.job_search.model.Job;
import com.thatsnajmull.job_search.service.JobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "*")
public class JobController {

    @Autowired
    private JobService jobService;

    // Get API Response
    @GetMapping("getalljobs")
    public List<Job> getAllJobs() {
        return jobService.getAllJob();
    }

    // Post API Response
    @PostMapping("addjob")
    public String addJob(@RequestBody JobEntity job) {
        return jobService.addJob(job);
    }

    // Put API Response
    @PutMapping("updatejob")
    public String updateJob(@RequestBody JobEntity job) {
        return jobService.updateJob(job);
    }

    // Delete API Response
    @DeleteMapping("deletejob")
    public String removeJob(@RequestBody JobEntity job) {
        return jobService.removeJob(job);
    }
}


//package com.thatsnajmull.job_search.controller;
//
//
//import com.thatsnajmull.job_search.entity.JobEntity;
//import com.thatsnajmull.job_search.model.Job;
//import com.thatsnajmull.job_search.service.JobService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
//@RestController
//@CrossOrigin(origins = "*")
//public class JobController {
//
//    @Autowired
//    JobService jobService;
//
//    //Get API Response
//    @RequestMapping(value = "getalljobs", method = RequestMethod.GET)
//    public List<Job> getAllJobs(){
//        return jobService.getAllJob();
//    }
//
//    //Post API Response
//    @RequestMapping(value = "addjob", method = RequestMethod.POST)
//    public String addJob(@RequestBody JobEntity job){
//        return jobService.addJob(job);
//    }
//
//    //Put API Response
//    @RequestMapping(value = "updatejob", method = RequestMethod.PUT)
//    public String updateJob(@RequestBody JobEntity job){
//        return jobService.updateJob(job);
//    }
//
//    //Delete API Response
//    @RequestMapping(value = "deletejob", method = RequestMethod.DELETE)
//    public String removeJob(@RequestBody JobEntity job){
//        return jobService.removeJob(job);
//    }
//
//
//}
