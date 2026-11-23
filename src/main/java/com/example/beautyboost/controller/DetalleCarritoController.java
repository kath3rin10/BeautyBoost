package com.example.beautyboost.controller;
import com.example.beautyboost.entity.DetalleCarrito;
import com.example.beautyboost.service.DetalleCarritoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/detalle-carrito")
public class DetalleCarritoController {
    private final DetalleCarritoService service;
    public DetalleCarritoController(DetalleCarritoService service) { this.service = service; }
    @GetMapping public List<DetalleCarrito> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<DetalleCarrito> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public DetalleCarrito crear(@RequestBody DetalleCarrito entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<DetalleCarrito> actualizar(@PathVariable Integer id, @RequestBody DetalleCarrito entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
