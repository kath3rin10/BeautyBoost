package com.example.beautyboost.repository;
import com.example.beautyboost.entity.Ciudad;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface CiudadRepository extends JpaRepository<Ciudad, Integer> { }
