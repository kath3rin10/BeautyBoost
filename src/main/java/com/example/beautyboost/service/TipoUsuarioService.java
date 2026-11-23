package com.example.beautyboost.service;
import com.example.beautyboost.entity.TipoUsuario;
import com.example.beautyboost.repository.TipoUsuarioRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class TipoUsuarioService {
    private final TipoUsuarioRepository repository;
    public TipoUsuarioService(TipoUsuarioRepository repository) { this.repository = repository; }
    public List<TipoUsuario> listar() { return repository.findAll(); }
    public Optional<TipoUsuario> consultar(Integer id) { return repository.findById(id); }
    public TipoUsuario guardar(TipoUsuario entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
