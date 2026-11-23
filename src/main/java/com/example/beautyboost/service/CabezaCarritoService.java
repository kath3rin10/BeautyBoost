package com.example.beautyboost.service;
import com.example.beautyboost.entity.CabezaCarrito;
import com.example.beautyboost.repository.CabezaCarritoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class CabezaCarritoService {
    private final CabezaCarritoRepository repository;
    public CabezaCarritoService(CabezaCarritoRepository repository) { this.repository = repository; }
    public List<CabezaCarrito> listar() { return repository.findAll(); }
    public Optional<CabezaCarrito> consultar(Integer id) { return repository.findById(id); }
    public CabezaCarrito guardar(CabezaCarrito entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
