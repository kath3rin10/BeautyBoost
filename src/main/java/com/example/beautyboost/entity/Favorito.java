package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "favoritos") @Getter @Setter @NoArgsConstructor
public class Favorito {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_favorito") private Integer id;
    @Column(name = "usuario_id_usuario") private Integer usuarioId;
    @Column(name = "producto_id_producto") private Integer productoId;
    @Column(name = "fecha_agregado") private java.time.LocalDateTime fechaAgregado;
}
