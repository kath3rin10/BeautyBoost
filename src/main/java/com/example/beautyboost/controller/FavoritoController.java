package com.example.beautyboost.controller;
import com.example.beautyboost.entity.Favorito;
import com.example.beautyboost.service.FavoritoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/favorito")
public class FavoritoController {
    private final FavoritoService service;
    public FavoritoController(FavoritoService service) { this.service = service; }
    @GetMapping public List<Favorito> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<Favorito> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public Favorito crear(@RequestBody Favorito entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<Favorito> actualizar(@PathVariable Integer id, @RequestBody Favorito entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
