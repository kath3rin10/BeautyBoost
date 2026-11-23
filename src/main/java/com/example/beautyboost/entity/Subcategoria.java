package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "subcategoria") @Getter @Setter @NoArgsConstructor
public class Subcategoria {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_subcategoria") private Integer id;
    @Column(name = "nombre_subcategoria") private String nombreSubcategoria;
    @Column(name = "categoria_id_categoria") private Integer categoriaId;
}
