package com.example.beautyboost.service;
import com.example.beautyboost.entity.Pedido;
import com.example.beautyboost.repository.PedidoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class PedidoService {
    private final PedidoRepository repository;
    public PedidoService(PedidoRepository repository) { this.repository = repository; }
    public List<Pedido> listar() { return repository.findAll(); }
    public Optional<Pedido> consultar(Integer id) { return repository.findById(id); }
    public Pedido guardar(Pedido entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
