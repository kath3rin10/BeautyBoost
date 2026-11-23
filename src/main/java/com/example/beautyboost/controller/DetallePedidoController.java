package com.example.beautyboost.controller;
import com.example.beautyboost.entity.DetallePedido;
import com.example.beautyboost.service.DetallePedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/detalle-pedido")
public class DetallePedidoController {
    private final DetallePedidoService service;
    public DetallePedidoController(DetallePedidoService service) { this.service = service; }
    @GetMapping public List<DetallePedido> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<DetallePedido> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public DetallePedido crear(@RequestBody DetallePedido entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<DetallePedido> actualizar(@PathVariable Integer id, @RequestBody DetallePedido entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
