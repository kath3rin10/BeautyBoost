package com.example.beautyboost.service;
import com.example.beautyboost.entity.DireccionEnvio;
import com.example.beautyboost.repository.DireccionEnvioRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class DireccionEnvioService {
    private final DireccionEnvioRepository repository;
    public DireccionEnvioService(DireccionEnvioRepository repository) { this.repository = repository; }
    public List<DireccionEnvio> listar() { return repository.findAll(); }
    public Optional<DireccionEnvio> consultar(Integer id) { return repository.findById(id); }
    public DireccionEnvio guardar(DireccionEnvio entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
