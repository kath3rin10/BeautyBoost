package com.example.beautyboost.controller;
import com.example.beautyboost.entity.DatosRecepcionPedido;
import com.example.beautyboost.service.DatosRecepcionPedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/datos-recepcion-pedido")
public class DatosRecepcionPedidoController {
    private final DatosRecepcionPedidoService service;
    public DatosRecepcionPedidoController(DatosRecepcionPedidoService service) { this.service = service; }
    @GetMapping public List<DatosRecepcionPedido> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<DatosRecepcionPedido> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public DatosRecepcionPedido crear(@RequestBody DatosRecepcionPedido entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<DatosRecepcionPedido> actualizar(@PathVariable Integer id, @RequestBody DatosRecepcionPedido entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
