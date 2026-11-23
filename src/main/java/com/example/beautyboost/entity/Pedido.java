package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "pedido") @Getter @Setter @NoArgsConstructor
public class Pedido {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_pedido") private Integer id;
    @Column(name = "fecha_pedido") private java.time.LocalDate fechaPedido;
    @Column(name = "numero_pedido") private Integer numeroPedido;
    @Column(name = "total") private java.math.BigDecimal total;
    @Column(name = "estado_pedido") private String estadoPedido;
    @Column(name = "usuario_id_usuario") private Integer usuarioId;
    @Column(name = "direccion_id_direccion") private Integer direccionId;
    @Column(name = "direccion_entrega") private String direccionEntrega;
    @Column(name = "metodo_pago") private String metodoPago;
    @Column(name = "wompi_reference") private String wompiReference;
    @Column(name = "wompi_status") private String wompiStatus;
    @Column(name = "wompi_transaction_id") private String wompiTransactionId;
    @Column(name = "estado_pedido_id_estado_pedido") private Integer estadoPedidoId;
}
