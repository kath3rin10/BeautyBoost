package com.example.beautyboost.repository;
import com.example.beautyboost.entity.TipoUsuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface TipoUsuarioRepository extends JpaRepository<TipoUsuario, Integer> { }
