package com.example.beautyboost.controller;
import com.example.beautyboost.entity.Pedido;
import com.example.beautyboost.service.PedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/pedido")
public class PedidoController {
    private final PedidoService service;
    public PedidoController(PedidoService service) { this.service = service; }
    @GetMapping public List<Pedido> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<Pedido> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public Pedido crear(@RequestBody Pedido entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<Pedido> actualizar(@PathVariable Integer id, @RequestBody Pedido entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
