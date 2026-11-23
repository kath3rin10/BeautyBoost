package com.example.beautyboost.controller;
import com.example.beautyboost.entity.CabezaCarrito;
import com.example.beautyboost.service.CabezaCarritoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/cabeza-carrito")
public class CabezaCarritoController {
    private final CabezaCarritoService service;
    public CabezaCarritoController(CabezaCarritoService service) { this.service = service; }
    @GetMapping public List<CabezaCarrito> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<CabezaCarrito> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public CabezaCarrito crear(@RequestBody CabezaCarrito entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<CabezaCarrito> actualizar(@PathVariable Integer id, @RequestBody CabezaCarrito entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
