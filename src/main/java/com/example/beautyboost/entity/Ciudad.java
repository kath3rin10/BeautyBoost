package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "ciudades") @Getter @Setter @NoArgsConstructor
public class Ciudad {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_ciudades") private Integer id;
    @Column(name = "descripcion_ciudad") private String descripcionCiudad;
    @Column(name = "codigo_postal") private String codigoPostal;
}
