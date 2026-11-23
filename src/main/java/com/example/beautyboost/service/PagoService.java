package com.example.beautyboost.service;
import com.example.beautyboost.entity.Pago;
import com.example.beautyboost.repository.PagoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class PagoService {
    private final PagoRepository repository;
    public PagoService(PagoRepository repository) { this.repository = repository; }
    public List<Pago> listar() { return repository.findAll(); }
    public Optional<Pago> consultar(Integer id) { return repository.findById(id); }
    public Pago guardar(Pago entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
