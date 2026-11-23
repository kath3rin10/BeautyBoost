package com.example.beautyboost.service;
import com.example.beautyboost.entity.DetalleCarrito;
import com.example.beautyboost.repository.DetalleCarritoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class DetalleCarritoService {
    private final DetalleCarritoRepository repository;
    public DetalleCarritoService(DetalleCarritoRepository repository) { this.repository = repository; }
    public List<DetalleCarrito> listar() { return repository.findAll(); }
    public Optional<DetalleCarrito> consultar(Integer id) { return repository.findById(id); }
    public DetalleCarrito guardar(DetalleCarrito entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
