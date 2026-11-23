package com.example.beautyboost.service;
import com.example.beautyboost.entity.MetodoPago;
import com.example.beautyboost.repository.MetodoPagoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class MetodoPagoService {
    private final MetodoPagoRepository repository;
    public MetodoPagoService(MetodoPagoRepository repository) { this.repository = repository; }
    public List<MetodoPago> listar() { return repository.findAll(); }
    public Optional<MetodoPago> consultar(Integer id) { return repository.findById(id); }
    public MetodoPago guardar(MetodoPago entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
