package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "resena_usuario") @Getter @Setter @NoArgsConstructor
public class ResenaUsuario {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_resena") private Integer id;
    @Column(name = "observacion") private String observacion;
    @Column(name = "calificacion") private Integer calificacion;
    @Column(name = "fecha") private java.time.LocalDateTime fecha;
    @Column(name = "estado") private String estado;
    @Column(name = "usuario_id_usuario") private Integer usuarioId;
    @Column(name = "producto_id_producto") private Integer productoId;
}
