package com.example.beautyboost.controller;
import com.example.beautyboost.entity.Pago;
import com.example.beautyboost.service.PagoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/pago")
public class PagoController {
    private final PagoService service;
    public PagoController(PagoService service) { this.service = service; }
    @GetMapping public List<Pago> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<Pago> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public Pago crear(@RequestBody Pago entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<Pago> actualizar(@PathVariable Integer id, @RequestBody Pago entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
