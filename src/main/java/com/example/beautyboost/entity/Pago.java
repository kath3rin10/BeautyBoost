package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "pago") @Getter @Setter @NoArgsConstructor
public class Pago {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_pago") private Integer id;
    @Column(name = "fecha_pago") private java.time.LocalDate fechaPago;
    @Column(name = "monto_pagado") private java.math.BigDecimal montoPagado;
    @Column(name = "metodo_de_pago_id_metodo_pago") private Integer metodoPagoId;
    @Column(name = "pedido_id_pedido") private Integer pedidoId;
    @Column(name = "wompi_transaction_id") private String wompiTransactionId;
    @Column(name = "wompi_status") private String wompiStatus;
}
