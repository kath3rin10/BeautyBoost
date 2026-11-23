package com.example.beautyboost.controller;
import com.example.beautyboost.entity.ControlEnvio;
import com.example.beautyboost.service.ControlEnvioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/control-envio")
public class ControlEnvioController {
    private final ControlEnvioService service;
    public ControlEnvioController(ControlEnvioService service) { this.service = service; }
    @GetMapping public List<ControlEnvio> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<ControlEnvio> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public ControlEnvio crear(@RequestBody ControlEnvio entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<ControlEnvio> actualizar(@PathVariable Integer id, @RequestBody ControlEnvio entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
