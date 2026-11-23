package com.example.beautyboost.service;
import com.example.beautyboost.entity.ControlEnvio;
import com.example.beautyboost.repository.ControlEnvioRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class ControlEnvioService {
    private final ControlEnvioRepository repository;
    public ControlEnvioService(ControlEnvioRepository repository) { this.repository = repository; }
    public List<ControlEnvio> listar() { return repository.findAll(); }
    public Optional<ControlEnvio> consultar(Integer id) { return repository.findById(id); }
    public ControlEnvio guardar(ControlEnvio entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
