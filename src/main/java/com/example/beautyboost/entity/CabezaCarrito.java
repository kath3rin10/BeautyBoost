package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "cabeza_carrito") @Getter @Setter @NoArgsConstructor
public class CabezaCarrito {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_carrito") private Integer id;
    @Column(name = "fecha_creacion") private java.time.LocalDate fechaCreacion;
    @Column(name = "fecha_actualizacion") private java.time.LocalDate fechaActualizacion;
    @Column(name = "usuario_id_usuario") private Integer usuarioId;
}
