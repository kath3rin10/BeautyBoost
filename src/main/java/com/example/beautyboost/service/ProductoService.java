package com.example.beautyboost.service;
import com.example.beautyboost.entity.Producto;
import com.example.beautyboost.repository.ProductoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class ProductoService {
    private final ProductoRepository repository;
    public ProductoService(ProductoRepository repository) { this.repository = repository; }
    public List<Producto> listar() { return repository.findAll(); }
    public Optional<Producto> consultar(Integer id) { return repository.findById(id); }
    public Producto guardar(Producto entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
