package com.thatsnajmull.job_search;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
public class JobSearchApplication {

	public static void main(String[] args) {
		SpringApplication.run(JobSearchApplication.class, args);
	}

}
