package com.example.beautyboost.service;
import com.example.beautyboost.entity.DatosRecepcionPedido;
import com.example.beautyboost.repository.DatosRecepcionPedidoRepository;
import org.springframework.stereotype.Service;
import java.util.*;
@Service
public class DatosRecepcionPedidoService {
    private final DatosRecepcionPedidoRepository repository;
    public DatosRecepcionPedidoService(DatosRecepcionPedidoRepository repository) { this.repository = repository; }
    public List<DatosRecepcionPedido> listar() { return repository.findAll(); }
    public Optional<DatosRecepcionPedido> consultar(Integer id) { return repository.findById(id); }
    public DatosRecepcionPedido guardar(DatosRecepcionPedido entidad) { return repository.save(entidad); }
    public void eliminar(Integer id) { repository.deleteById(id); }
}
