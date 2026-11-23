package com.example.beautyboost.service;
import com.example.beautyboost.entity.EmpresaEnvio;
import com.example.beautyboost.repository.EmpresaEnvioRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class EmpresaEnvioService {
    private final EmpresaEnvioRepository repository;
    public EmpresaEnvioService(EmpresaEnvioRepository repository) { this.repository = repository; }
    public List<EmpresaEnvio> listar() { return repository.findAll(); }
    public Optional<EmpresaEnvio> consultar(Integer id) { return repository.findById(id); }
    public EmpresaEnvio guardar(EmpresaEnvio entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
