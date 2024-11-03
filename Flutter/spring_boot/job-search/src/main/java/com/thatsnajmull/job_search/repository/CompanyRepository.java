package com.thatsnajmull.job_search.repository;

import com.thatsnajmull.job_search.entity.CompanyEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CompanyRepository extends JpaRepository<CompanyEntity, Long> {

    boolean existsByCompanyName(String companyName);

    boolean existsById(Long id);
}

