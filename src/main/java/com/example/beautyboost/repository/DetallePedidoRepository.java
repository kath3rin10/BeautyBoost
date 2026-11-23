package com.example.beautyboost.repository;
import com.example.beautyboost.entity.DetallePedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface DetallePedidoRepository extends JpaRepository<DetallePedido, Integer> { }
