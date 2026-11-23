package com.example.beautyboost.controller;
import com.example.beautyboost.entity.MetodoPago;
import com.example.beautyboost.service.MetodoPagoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/metodo-pago")
public class MetodoPagoController {
    private final MetodoPagoService service;
    public MetodoPagoController(MetodoPagoService service) { this.service = service; }
    @GetMapping public List<MetodoPago> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<MetodoPago> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public MetodoPago crear(@RequestBody MetodoPago entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<MetodoPago> actualizar(@PathVariable Integer id, @RequestBody MetodoPago entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
