package com.example.beautyboost.controller;
import com.example.beautyboost.entity.EstadoPedido;
import com.example.beautyboost.service.EstadoPedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/estado-pedido")
public class EstadoPedidoController {
    private final EstadoPedidoService service;
    public EstadoPedidoController(EstadoPedidoService service) { this.service = service; }
    @GetMapping public List<EstadoPedido> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<EstadoPedido> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public EstadoPedido crear(@RequestBody EstadoPedido entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<EstadoPedido> actualizar(@PathVariable Integer id, @RequestBody EstadoPedido entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
