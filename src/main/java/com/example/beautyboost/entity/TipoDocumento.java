package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "tipo_documento") @Getter @Setter @NoArgsConstructor
public class TipoDocumento {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_tipo_documento") private Integer id;
    @Column(name = "descripcion_tipo_documento") private String descripcionTipoDocumento;
}
