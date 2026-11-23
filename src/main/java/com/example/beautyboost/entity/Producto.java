package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "producto") @Getter @Setter @NoArgsConstructor
public class Producto {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_producto") private Integer id;
    @Column(name = "nombre_prod") private String nombreProd;
    @Column(name = "descripcion_prod") private String descripcionProd;
    @Column(name = "precio") private java.math.BigDecimal precio;
    @Column(name = "stock") private Integer stock;
    @Column(name = "imagen_url") private String imagenUrl;
    @Column(name = "estado_producto") private String estadoProducto;
    @Column(name = "categoria_id_categoria") private Integer categoriaId;
    @Column(name = "subcategoria_id_subcategoria") private Integer subcategoriaId;
}
