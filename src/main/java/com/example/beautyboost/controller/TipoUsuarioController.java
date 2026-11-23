package com.example.beautyboost.controller;
import com.example.beautyboost.entity.TipoUsuario;
import com.example.beautyboost.service.TipoUsuarioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/tipo-usuario")
public class TipoUsuarioController {
    private final TipoUsuarioService service;
    public TipoUsuarioController(TipoUsuarioService service) { this.service = service; }
    @GetMapping public List<TipoUsuario> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<TipoUsuario> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public TipoUsuario crear(@RequestBody TipoUsuario entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<TipoUsuario> actualizar(@PathVariable Integer id, @RequestBody TipoUsuario entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
