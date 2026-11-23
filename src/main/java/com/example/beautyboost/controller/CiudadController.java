package com.example.beautyboost.controller;
import com.example.beautyboost.entity.Ciudad;
import com.example.beautyboost.service.CiudadService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/ciudad")
public class CiudadController {
    private final CiudadService service;
    public CiudadController(CiudadService service) { this.service = service; }
    @GetMapping public List<Ciudad> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<Ciudad> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public Ciudad crear(@RequestBody Ciudad entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<Ciudad> actualizar(@PathVariable Integer id, @RequestBody Ciudad entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
