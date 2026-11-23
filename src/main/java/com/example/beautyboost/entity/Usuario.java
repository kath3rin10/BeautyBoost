package com.example.beautyboost.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "usuario")
@Getter
@Setter
@NoArgsConstructor
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_usuario")
    private Integer id;

    @Column(name = "nombre")
    private String nombre;

    @Column(name = "apellido")
    private String apellido;

    @Column(name = "numero_identificacion")
    private String numeroIdentificacion;

    @Column(name = "telefono")
    private String telefono;

    @Column(name = "correo")
    private String correo;

    @Column(name = "clave")
    private String clave;

    @Column(name = "fecha_nacimiento")
    private java.time.LocalDateTime fechaNacimiento;

    @Column(name = "fecha_vencimiento_clave")
    private java.time.LocalDate fechaVencimientoClave;

    @Column(name = "autorizacion_datos")
    private String autorizacionDatos;

    @Column(name = "estado_usuario")
    private String estadoUsuario;

    @Column(name = "tipo_documento_id_tipo_documento")
    private Integer tipoDocumentoId;

    @Column(name = "tipo_usuario_id_tipo_usuario")
    private Integer tipoUsuarioId;

    @Column(name = "roles_id_rol")
    private Integer rolId;

    // Métodos de compatibilidad para plantillas que llaman a idUsuario
    public Integer getIdUsuario() {
        return id;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.id = idUsuario;
    }
}