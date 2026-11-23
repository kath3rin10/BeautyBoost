package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "roles") @Getter @Setter @NoArgsConstructor
public class Rol {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_rol") private Integer id;
    @Column(name = "nombre") private String nombre;
}
