package com.example.beautyboost.repository;
import com.example.beautyboost.entity.CabezaCarrito;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface CabezaCarritoRepository extends JpaRepository<CabezaCarrito, Integer> { }
