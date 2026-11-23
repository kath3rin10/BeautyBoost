package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "control_envio") @Getter @Setter @NoArgsConstructor
public class ControlEnvio {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_control") private Integer id;
    @Column(name = "fecha_entrega") private java.time.LocalDate fechaEntrega;
    @Column(name = "codigo_seguimiento") private String codigoSeguimiento;
    @Column(name = "estado_pedido_id_estado_pedido") private Integer estadoPedidoId;
    @Column(name = "empresas_envio_id_empresa_envio") private Integer empresaEnvioId;
    @Column(name = "pedido_id_pedido") private Integer pedidoId;
}
