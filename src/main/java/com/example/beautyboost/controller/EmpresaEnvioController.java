package com.example.beautyboost.controller;
import com.example.beautyboost.entity.EmpresaEnvio;
import com.example.beautyboost.service.EmpresaEnvioService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/empresa-envio")
public class EmpresaEnvioController {
    private final EmpresaEnvioService service;
    public EmpresaEnvioController(EmpresaEnvioService service) { this.service = service; }
    @GetMapping public List<EmpresaEnvio> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<EmpresaEnvio> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public EmpresaEnvio crear(@RequestBody EmpresaEnvio entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<EmpresaEnvio> actualizar(@PathVariable Integer id, @RequestBody EmpresaEnvio entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
