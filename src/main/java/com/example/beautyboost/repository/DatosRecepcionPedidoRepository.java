package com.example.beautyboost.repository;
import com.example.beautyboost.entity.DatosRecepcionPedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface DatosRecepcionPedidoRepository extends JpaRepository<DatosRecepcionPedido, Integer> { }
