package com.example.beautyboost.controller;
import com.example.beautyboost.entity.Categoria;
import com.example.beautyboost.service.CategoriaService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/categoria")
public class CategoriaController {
    private final CategoriaService service;
    public CategoriaController(CategoriaService service) { this.service = service; }
    @GetMapping public List<Categoria> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<Categoria> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public Categoria crear(@RequestBody Categoria entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<Categoria> actualizar(@PathVariable Integer id, @RequestBody Categoria entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
