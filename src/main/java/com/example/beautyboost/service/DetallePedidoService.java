package com.example.beautyboost.service;
import com.example.beautyboost.entity.DetallePedido;
import com.example.beautyboost.repository.DetallePedidoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class DetallePedidoService {
    private final DetallePedidoRepository repository;
    public DetallePedidoService(DetallePedidoRepository repository) { this.repository = repository; }
    public List<DetallePedido> listar() { return repository.findAll(); }
    public Optional<DetallePedido> consultar(Integer id) { return repository.findById(id); }
    public DetallePedido guardar(DetallePedido entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
