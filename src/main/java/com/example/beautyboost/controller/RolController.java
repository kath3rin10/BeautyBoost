package com.example.beautyboost.controller;
import com.example.beautyboost.entity.Rol;
import com.example.beautyboost.service.RolService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/rol")
public class RolController {
    private final RolService service;
    public RolController(RolService service) { this.service = service; }
    @GetMapping public List<Rol> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<Rol> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public Rol crear(@RequestBody Rol entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<Rol> actualizar(@PathVariable Integer id, @RequestBody Rol entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
