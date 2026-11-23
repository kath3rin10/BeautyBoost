package com.example.beautyboost.service;
import com.example.beautyboost.entity.TipoDocumento;
import com.example.beautyboost.repository.TipoDocumentoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class TipoDocumentoService {
    private final TipoDocumentoRepository repository;
    public TipoDocumentoService(TipoDocumentoRepository repository) { this.repository = repository; }
    public List<TipoDocumento> listar() { return repository.findAll(); }
    public Optional<TipoDocumento> consultar(Integer id) { return repository.findById(id); }
    public TipoDocumento guardar(TipoDocumento entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
