package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "detalle_carrito") @Getter @Setter @NoArgsConstructor
public class DetalleCarrito {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_detalle_carrito") private Integer id;
    @Column(name = "cantidad") private Integer cantidad;
    @Column(name = "descripcion") private String descripcion;
    @Column(name = "carrito_id_carrito") private Integer carritoId;
    @Column(name = "producto_id_producto") private Integer productoId;
}
