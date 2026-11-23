package com.example.beautyboost.service;
import com.example.beautyboost.entity.Ciudad;
import com.example.beautyboost.repository.CiudadRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class CiudadService {
    private final CiudadRepository repository;
    public CiudadService(CiudadRepository repository) { this.repository = repository; }
    public List<Ciudad> listar() { return repository.findAll(); }
    public Optional<Ciudad> consultar(Integer id) { return repository.findById(id); }
    public Ciudad guardar(Ciudad entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
