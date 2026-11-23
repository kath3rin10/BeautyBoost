package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "metodo_de_pago") @Getter @Setter @NoArgsConstructor
public class MetodoPago {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_metodo_de_pago") private Integer id;
    @Column(name = "descripcion_metodo_de_pago") private String descripcionMetodoDePago;
}
