package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "direccion_envio") @Getter @Setter @NoArgsConstructor
public class DireccionEnvio {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_direccion") private Integer id;
    @Column(name = "direccion_envio") private String direccionEnvio;
    @Column(name = "usuario_id_usuario") private Integer usuarioId;
    @Column(name = "ciudades_id_ciudades") private Integer ciudadId;
}
