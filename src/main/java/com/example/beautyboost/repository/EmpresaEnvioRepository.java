package com.example.beautyboost.repository;
import com.example.beautyboost.entity.EmpresaEnvio;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface EmpresaEnvioRepository extends JpaRepository<EmpresaEnvio, Integer> { }
