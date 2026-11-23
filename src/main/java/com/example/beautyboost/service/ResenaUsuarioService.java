package com.example.beautyboost.service;
import com.example.beautyboost.entity.ResenaUsuario;
import com.example.beautyboost.repository.ResenaUsuarioRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class ResenaUsuarioService {
    private final ResenaUsuarioRepository repository;
    public ResenaUsuarioService(ResenaUsuarioRepository repository) { this.repository = repository; }
    public List<ResenaUsuario> listar() { return repository.findAll(); }
    public Optional<ResenaUsuario> consultar(Integer id) { return repository.findById(id); }
    public ResenaUsuario guardar(ResenaUsuario entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
