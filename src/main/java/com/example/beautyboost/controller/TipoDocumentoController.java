package com.example.beautyboost.controller;
import com.example.beautyboost.entity.TipoDocumento;
import com.example.beautyboost.service.TipoDocumentoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.*;
@RestController @RequestMapping("/api/tipo-documento")
public class TipoDocumentoController {
    private final TipoDocumentoService service;
    public TipoDocumentoController(TipoDocumentoService service) { this.service = service; }
    @GetMapping public List<TipoDocumento> listar() { return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<TipoDocumento> consultar(@PathVariable Integer id) { return service.consultar(id).map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build()); }
    @PostMapping public TipoDocumento crear(@RequestBody TipoDocumento entidad) { return service.guardar(entidad); }
    @PutMapping("/{id}") public ResponseEntity<TipoDocumento> actualizar(@PathVariable Integer id, @RequestBody TipoDocumento entidad) { entidad.setId(id); return ResponseEntity.ok(service.guardar(entidad)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> eliminar(@PathVariable Integer id) { service.eliminar(id); return ResponseEntity.noContent().build(); }
}
