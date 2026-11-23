package com.example.beautyboost.service;

import com.example.beautyboost.entity.Usuario;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class CorreoService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username:store.beautyboost@gmail.com}")
    private String remitente;

    public CorreoService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void enviarCorreosRegistro(Usuario u) {
        String nombre = u.getNombre() != null ? u.getNombre().trim() : "";
        String apellido = u.getApellido() != null ? u.getApellido().trim() : "";
        String correo = u.getCorreo() != null ? u.getCorreo().trim() : "";

        // 1. Bienvenida al usuario
        try {
            MimeMessage msgUsuario = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(msgUsuario, true, "UTF-8");
            helper.setFrom(remitente);
            helper.setTo(correo);
            helper.setSubject("¡Registro Exitoso - Bienvenido a Beauty Boost!");

            String htmlUsuario =
                "<div style='font-family: Arial, sans-serif; background-color: #faf5f3; padding: 30px; color: #333;'>" +
                    "<div style='max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 15px; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);'>" +
                        "<h1 style='color: #2b2b2b; text-align: center; font-family: serif; letter-spacing: 2px;'>BEAUTY BOOST</h1>" +
                        "<h2 style='color: #444;'>¡Hola, " + nombre + "!</h2>" +
                        "<p style='font-size: 14px; color: #666;'>Te escribimos para confirmarte que te has registrado correctamente a nuestra página.</p>" +
                        "<hr style='border: none; border-top: 1px solid #eaeaea; margin: 20px 0;'>" +
                        "<div style='background-color: #fdf8f6; padding: 20px; border-radius: 10px;'>" +
                            "<h3 style='color: #1f1b1b; margin-top: 0; font-family: serif;'>BIENVENIDA A Beauty Boost</h3>" +
                            "<p style='font-size: 14px; line-height: 1.6; color: #555;'>" +
                                "Estimado/a <b>" + nombre + " " + apellido + "</b>,<br><br>" +
                                "Queremos darte la más cordial bienvenida a nuestra página de maquillaje. " +
                                "<b>Estamos muy orgullosos de que te hayas registrado</b> y de que comiences a formar parte de nuestra gran familia Beauty Boost.<br><br>" +
                                "A partir de ahora podrás disfrutar de recomendaciones personalizadas, más de 50 marcas exclusivas y una experiencia de compra única pensada para ti.<br><br>" +
                                "Con mucho cariño,<br>" +
                                "<b>El equipo de Beauty Boost</b>" +
                            "</p>" +
                        "</div>" +
                    "</div>" +
                "</div>";

            helper.setText(htmlUsuario, true);
            mailSender.send(msgUsuario);
        } catch (Exception ex) {
            System.err.println("Aviso: No se pudo enviar el correo de bienvenida al usuario: " + ex.getMessage());
        }

        // 2. Notificación al correo institucional de Beauty Boost
        try {
            String fechaActual = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
            String tipoDocTexto = switch (u.getTipoDocumentoId() != null ? u.getTipoDocumentoId() : 1) {
                case 2 -> "Cédula de Extranjería";
                case 3 -> "Pasaporte";
                default -> "Cédula de Ciudadanía";
            };

            MimeMessage msgAdmin = mailSender.createMimeMessage();
            MimeMessageHelper helperAdmin = new MimeMessageHelper(msgAdmin, true, "UTF-8");
            helperAdmin.setFrom(remitente);
            helperAdmin.setTo("store.beautyboost@gmail.com");
            helperAdmin.setSubject("Nuevo Registro de Usuario en el Sistema");

            String htmlAdmin =
                "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333;'>" +
                    "<h2 style='color: #2c3e50;'>Registro de Nuevo Usuario</h2>" +
                    "<p>Se ha registrado exitosamente un nuevo usuario en la plataforma con los siguientes datos:</p>" +
                    "<ul>" +
                        "<li><b>Fecha y Hora (Día/Mes/Año):</b> " + fechaActual + "</li>" +
                        "<li><b>Nombre Completo:</b> " + nombre + " " + apellido + "</li>" +
                        "<li><b>Tipo de Identificación:</b> " + tipoDocTexto + "</li>" +
                        "<li><b>Número de Identificación:</b> " + (u.getNumeroIdentificacion() != null ? u.getNumeroIdentificacion() : "") + "</li>" +
                        "<li><b>Teléfono:</b> " + (u.getTelefono() != null ? u.getTelefono() : "") + "</li>" +
                        "<li><b>Correo Electrónico:</b> " + correo + "</li>" +
                    "</ul>" +
                "</div>";

            helperAdmin.setText(htmlAdmin, true);
            mailSender.send(msgAdmin);
        } catch (Exception ex) {
            System.err.println("Aviso: No se pudo enviar la notificación de registro al administrador: " + ex.getMessage());
        }
    }

    public void enviarCorreosRecuperacion(Usuario u, String claveTemporal) {
        String nombre = u.getNombre() != null ? u.getNombre().trim() : "";
        String correo = u.getCorreo() != null ? u.getCorreo().trim() : "";

        // 1. Correo al usuario con su contraseña temporal de 8 caracteres
        MimeMessage msgUsuario = mailSender.createMimeMessage();
        try {
            MimeMessageHelper helper = new MimeMessageHelper(msgUsuario, true, "UTF-8");
            helper.setFrom(remitente);
            helper.setTo(correo);
            helper.setSubject("Restablecimiento de Contraseña - Beauty Boost");

            String htmlUsuario =
                "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333;'>" +
                    "<h2 style='color: #d87d6a;'>Beauty Boost - Restablecimiento de Cuenta</h2>" +
                    "<p>Hola, <b>" + nombre + "</b>.</p>" +
                    "<p>Hemos recibido una solicitud para restablecer tu contraseña. Tu nueva contraseña temporal es:</p>" +
                    "<div style='background: #faf5f3; padding: 15px; border-radius: 8px; border: 1px solid #ebd5cd; margin: 20px 0; text-align: center;'>" +
                        "<b style='color: #d87d6a; font-size: 18px;'>" + claveTemporal + "</b>" +
                    "</div>" +
                    "<p>Te sugerimos iniciar sesión con esta clave y cambiarla posteriormente desde tu perfil si lo deseas.</p>" +
                "</div>";

            helper.setText(htmlUsuario, true);
            mailSender.send(msgUsuario);
        } catch (Exception ex) {
            throw new RuntimeException("Error técnico al enviar el correo de recuperación: " + ex.getMessage());
        }

        // 2. Notificación al administrador
        try {
            String fechaActual = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
            MimeMessage msgAdmin = mailSender.createMimeMessage();
            MimeMessageHelper helperAdmin = new MimeMessageHelper(msgAdmin, true, "UTF-8");
            helperAdmin.setFrom(remitente);
            helperAdmin.setTo("store.beautyboost@gmail.com");
            helperAdmin.setSubject("Nueva recuperación de contraseña - Beauty Boost");

            String htmlAdmin =
                "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333;'>" +
                    "<h2 style='color: #2c3e50;'>Registro de Recuperación de Contraseña</h2>" +
                    "<p>Se ha solicitado la recuperación de contraseña de un usuario en el sistema con los siguientes datos:</p>" +
                    "<ul>" +
                        "<li><b>Fecha y Hora (Día/Mes/Año):</b> " + fechaActual + "</li>" +
                        "<li><b>Nombre del Usuario:</b> " + nombre + "</li>" +
                        "<li><b>Correo del Usuario:</b> " + correo + "</li>" +
                    "</ul>" +
                "</div>";

            helperAdmin.setText(htmlAdmin, true);
            mailSender.send(msgAdmin);
        } catch (Exception ex) {
            System.err.println("Aviso: No se pudo enviar la notificación de recuperación al administrador: " + ex.getMessage());
        }
    }
}