package com.example.beautyboost.service;
import com.example.beautyboost.entity.Categoria;
import com.example.beautyboost.repository.CategoriaRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class CategoriaService {
    private final CategoriaRepository repository;
    public CategoriaService(CategoriaRepository repository) { this.repository = repository; }
    public List<Categoria> listar() { return repository.findAll(); }
    public Optional<Categoria> consultar(Integer id) { return repository.findById(id); }
    public Categoria guardar(Categoria entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
