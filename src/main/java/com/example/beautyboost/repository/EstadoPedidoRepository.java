package com.example.beautyboost.repository;
import com.example.beautyboost.entity.EstadoPedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
@Repository
public interface EstadoPedidoRepository extends JpaRepository<EstadoPedido, Integer> { }
