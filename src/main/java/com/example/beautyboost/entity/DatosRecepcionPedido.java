package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "datos_recepcion_pedido") @Getter @Setter @NoArgsConstructor
public class DatosRecepcionPedido {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_dato_recepcion") private Integer id;
    @Column(name = "pedido_id_pedido") private Integer pedidoId;
    @Column(name = "nombre_receptor") private String nombreReceptor;
    @Column(name = "documento_receptor") private String documentoReceptor;
    @Column(name = "telefono_receptor") private String telefonoReceptor;
    @Column(name = "notas_entrega") private String notasEntrega;
}
