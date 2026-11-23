package com.example.beautyboost.controller;
import com.example.beautyboost.entity.ResenaUsuario;
import com.example.beautyboost.service.ResenaUsuarioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/resena-usuario")
public class ResenaUsuarioController {
    private final ResenaUsuarioService service;
    public ResenaUsuarioController(ResenaUsuarioService service) { this.service = service; }
    @GetMapping public List<ResenaUsuario> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<ResenaUsuario> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public ResenaUsuario crear(@RequestBody ResenaUsuario entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<ResenaUsuario> actualizar(@PathVariable Integer id, @RequestBody ResenaUsuario entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
