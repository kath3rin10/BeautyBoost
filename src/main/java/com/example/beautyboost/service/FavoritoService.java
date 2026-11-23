package com.example.beautyboost.service;
import com.example.beautyboost.entity.Favorito;
import com.example.beautyboost.repository.FavoritoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class FavoritoService {
    private final FavoritoRepository repository;
    public FavoritoService(FavoritoRepository repository) { this.repository = repository; }
    public List<Favorito> listar() { return repository.findAll(); }
    public Optional<Favorito> consultar(Integer id) { return repository.findById(id); }
    public Favorito guardar(Favorito entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
