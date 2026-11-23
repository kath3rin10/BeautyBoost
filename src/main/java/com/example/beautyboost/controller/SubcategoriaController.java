package com.example.beautyboost.controller;
import com.example.beautyboost.entity.Subcategoria;
import com.example.beautyboost.service.SubcategoriaService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/subcategoria")
public class SubcategoriaController {
    private final SubcategoriaService service;
    public SubcategoriaController(SubcategoriaService service) { this.service = service; }
    @GetMapping public List<Subcategoria> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<Subcategoria> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public Subcategoria crear(@RequestBody Subcategoria entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<Subcategoria> actualizar(@PathVariable Integer id, @RequestBody Subcategoria entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
