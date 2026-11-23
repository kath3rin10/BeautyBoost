package com.example.beautyboost.service;
import com.example.beautyboost.entity.Rol;
import com.example.beautyboost.repository.RolRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class RolService {
    private final RolRepository repository;
    public RolService(RolRepository repository) { this.repository = repository; }
    public List<Rol> listar() { return repository.findAll(); }
    public Optional<Rol> consultar(Integer id) { return repository.findById(id); }
    public Rol guardar(Rol entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
