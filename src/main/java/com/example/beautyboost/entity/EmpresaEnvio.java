package com.example.beautyboost.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "empresas_envio") @Getter @Setter @NoArgsConstructor
public class EmpresaEnvio {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_empresa_envio") private Integer id;
    @Column(name = "nombre_empresa") private String nombreEmpresa;
    @Column(name = "nit") private String nit;
}
