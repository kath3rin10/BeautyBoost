package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "estado_pedido") @Getter @Setter @NoArgsConstructor
public class EstadoPedido {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_estado_pedido") private Integer id;
    @Column(name = "descripcion_estado") private String descripcionEstado;
}
