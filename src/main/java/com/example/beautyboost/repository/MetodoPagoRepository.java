package com.example.beautyboost.repository;
import com.example.beautyboost.entity.MetodoPago;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface MetodoPagoRepository extends JpaRepository<MetodoPago, Integer> { }
