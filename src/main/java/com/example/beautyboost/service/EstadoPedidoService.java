package com.example.beautyboost.service;
import com.example.beautyboost.entity.EstadoPedido;
import com.example.beautyboost.repository.EstadoPedidoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class EstadoPedidoService {
    private final EstadoPedidoRepository repository;
    public EstadoPedidoService(EstadoPedidoRepository repository) { this.repository = repository; }
    public List<EstadoPedido> listar() { return repository.findAll(); }
    public Optional<EstadoPedido> consultar(Integer id) { return repository.findById(id); }
    public EstadoPedido guardar(EstadoPedido entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
