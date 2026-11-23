package com.example.beautyboost.repository;
import com.example.beautyboost.entity.ResenaUsuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface ResenaUsuarioRepository extends JpaRepository<ResenaUsuario, Integer> { }
