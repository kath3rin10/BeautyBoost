package com.example.beautyboost.repository;
import com.example.beautyboost.entity.DireccionEnvio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface DireccionEnvioRepository extends JpaRepository<DireccionEnvio, Integer> { }
