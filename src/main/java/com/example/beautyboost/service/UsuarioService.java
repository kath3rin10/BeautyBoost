package com.example.beautyboost.service;

import com.example.beautyboost.entity.Usuario;
import com.example.beautyboost.repository.UsuarioRepository;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {
    private final UsuarioRepository repository;
    private final CorreoService correoService;

    public UsuarioService(UsuarioRepository repository, CorreoService correoService) {
        this.repository = repository;
        this.correoService = correoService;
    }

    public List<Usuario> listar() {
        return repository.findAll();
    }

    public Optional<Usuario> consultar(Integer id) {
        return repository.findById(id);
    }

    public Optional<Usuario> buscarPorCorreo(String correo) {
        if (correo == null) return Optional.empty();
        return repository.findByCorreoIgnoreCase(correo.trim());
    }

    public Optional<Usuario> autenticar(String correo, String clavePlana) {
        if (correo == null || clavePlana == null) return Optional.empty();
        Optional<Usuario> opt = repository.findByCorreoIgnoreCase(correo.trim());
        if (opt.isEmpty()) return Optional.empty();

        Usuario u = opt.get();
        if (u.getEstadoUsuario() != null && "Inactivo".equalsIgnoreCase(u.getEstadoUsuario().trim())) {
            return Optional.empty();
        }

        String guardada = u.getClave();
        if (guardada == null || guardada.isBlank()) return Optional.empty();

        boolean coincide;
        if (guardada.startsWith("$2a$") || guardada.startsWith("$2b$") || guardada.startsWith("$2y$")) {
            coincide = BCrypt.checkpw(clavePlana, guardada);
        } else {
            coincide = guardada.equals(clavePlana);
        }

        return coincide ? Optional.of(u) : Optional.empty();
    }

    public Usuario guardar(Usuario entidad) {
        if (entidad.getClave() != null && !entidad.getClave().isBlank()
                && !entidad.getClave().startsWith("$2a$")
                && !entidad.getClave().startsWith("$2b$")
                && !entidad.getClave().startsWith("$2y$")) {
            entidad.setClave(BCrypt.hashpw(entidad.getClave(), BCrypt.gensalt()));
        }
        if (entidad.getRolId() == null) {
            entidad.setRolId(2);
        }
        if (entidad.getTipoUsuarioId() == null) {
            entidad.setTipoUsuarioId(4);
        }
        if (entidad.getFechaVencimientoClave() == null) {
            entidad.setFechaVencimientoClave(LocalDate.now().plusYears(2));
        }
        if (entidad.getEstadoUsuario() == null || entidad.getEstadoUsuario().isBlank()) {
            entidad.setEstadoUsuario("Activo");
        }
        return repository.save(entidad);
    }

    public Usuario registrarNuevoUsuario(Usuario entidad) {
        Usuario guardado = guardar(entidad);
        correoService.enviarCorreosRegistro(guardado);
        return guardado;
    }

    public String recuperarPassword(String correo) {
        Optional<Usuario> opt = buscarPorCorreo(correo);
        if (opt.isEmpty()) {
            throw new RuntimeException("El correo electrónico ingresado no se encuentra registrado en el sistema.");
        }
        Usuario u = opt.get();
        String tempPass = generarClaveAleatoria8();
        u.setClave(BCrypt.hashpw(tempPass, BCrypt.gensalt()));
        u.setFechaVencimientoClave(LocalDate.now().plusYears(2));
        repository.save(u);
        correoService.enviarCorreosRecuperacion(u, tempPass);
        return tempPass;
    }

    private String generarClaveAleatoria8() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(8);
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }

    public void eliminar(Integer id) {
        repository.deleteById(id);
    }
}