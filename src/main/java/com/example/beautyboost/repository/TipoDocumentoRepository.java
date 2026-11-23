package com.example.beautyboost.repository;
import com.example.beautyboost.entity.TipoDocumento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface TipoDocumentoRepository extends JpaRepository<TipoDocumento, Integer> { }
