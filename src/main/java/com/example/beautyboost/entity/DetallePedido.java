package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "detalle_pedido") @Getter @Setter @NoArgsConstructor
public class DetallePedido {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_detalle_pedido") private Integer id;
    @Column(name = "cantidad") private Integer cantidad;
    @Column(name = "precio_unitario") private java.math.BigDecimal precioUnitario;
    @Column(name = "subtotal") private java.math.BigDecimal subtotal;
    @Column(name = "producto_id_producto") private Integer productoId;
    @Column(name = "pedido_id_pedido") private Integer pedidoId;
}
