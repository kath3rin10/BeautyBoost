package com.example.beautyboost.controller;
import com.example.beautyboost.entity.Producto;
import com.example.beautyboost.service.ProductoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/producto")
public class ProductoController {
    private final ProductoService service;
    public ProductoController(ProductoService service) { this.service = service; }
    @GetMapping public List<Producto> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<Producto> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public Producto crear(@RequestBody Producto entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<Producto> actualizar(@PathVariable Integer id, @RequestBody Producto entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
