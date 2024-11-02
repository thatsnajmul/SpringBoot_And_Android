package com.thatsnajmull.job_search.controller;

import com.thatsnajmull.job_search.entity.JobEntity;
import com.thatsnajmull.job_search.model.JobModel;
import com.thatsnajmull.job_search.service.JobService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin(origins = "http://localhost:9097")
public class JobController {

    @Autowired
    private JobService jobService;

    // Get API Response
    @GetMapping("getalljobs")
    public List<JobModel> getAllJobs() {
        return jobService.getAllJob();
    }


    // Get API Response - Get job by ID
    @GetMapping("getjob/{id}")
    public ResponseEntity<JobEntity> getJobById(@PathVariable Long id) {
        JobEntity job = jobService.getJobById(id); // Call service to get job by ID
        if (job != null) {
            return ResponseEntity.ok(job); // Return job if found
        } else {
            return ResponseEntity.notFound().build(); // Return 404 if not found
        }
    }


    // Post API Response
    @PostMapping("addjob")
    public String addJob(@RequestBody JobEntity job) {
        return jobService.addJob(job);
    }

    // Put API Response
    @PutMapping("updatejob/{id}")
    public String updateJob(@PathVariable Long id, @RequestBody JobEntity job) {
        job.setId(id); // Set the ID from the path variable
        return jobService.updateJob(job); // Pass the complete JobEntity for updating
    }

    // Delete API Response
    @DeleteMapping("deletejob/{id}")
    public String removeJob(@PathVariable Long id) { // Change from JobEntity to Long
        return jobService.removeJob(id); // Pass the ID directly to the service
    }
}



//package com.thatsnajmull.job_search.controller;
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
//@CrossOrigin(origins = "http://localhost:9097")
//public class JobController {
//
//    @Autowired
//    private JobService jobService;
//
//    // Get API Response
//    @GetMapping("getalljobs")
//    public List<Job> getAllJobs() {
//        return jobService.getAllJob();
//    }
//
//    // Post API Response
//    @PostMapping("addjob")
//    public String addJob(@RequestBody JobEntity job) {
//        return jobService.addJob(job);
//    }
//
//    // Put API Response
//    @PutMapping("updatejob/{id}")
//    public String updateJob(@RequestBody JobEntity job) {
//        return jobService.updateJob(job);
//    }
//
//    // Delete API Response
//    @DeleteMapping("deletejob/{id}")
//    public String removeJob(@PathVariable Long id, @RequestBody JobEntity job) {
//        return jobService.removeJob(job);
//    }
//}





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
