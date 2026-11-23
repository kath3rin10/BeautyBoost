package com.example.beautyboost.controller;

import com.example.beautyboost.entity.Usuario;
import com.example.beautyboost.service.UsuarioService;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.Period;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/usuario")
public class UsuarioController {

    private final UsuarioService service;

    public UsuarioController(UsuarioService service) {
        this.service = service;
    }

    @GetMapping
    public List<Usuario> listar() {
        return service.listar();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Usuario> consultar(@PathVariable Integer id) {
        return service.consultar(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public Usuario crear(@RequestBody Usuario entidad) {
        return service.guardar(entidad);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Usuario> actualizar(@PathVariable Integer id, @RequestBody Usuario entidad) {
        entidad.setId(id);
        return ResponseEntity.ok(service.guardar(entidad));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Integer id) {
        service.eliminar(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String correo = body.get("correo") != null ? body.get("correo") : body.get("txtCorreo");
        String clave = body.get("clave") != null ? body.get("clave") : body.get("txtPassword");

        Optional<Usuario> autenticado = service.autenticar(correo, clave);
        Map<String, Object> resp = new HashMap<>();

        if (autenticado.isEmpty()) {
            resp.put("status", "error");
            resp.put("message", "Correo o contraseÃ±a incorrectos, o cuenta inactiva.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(resp);
        }

        Usuario u = autenticado.get();
        session.setAttribute("usuarioLogueado", u);

        resp.put("status", "success");
        resp.put("redirect", (u.getRolId() != null && u.getRolId() == 1) ? "/admin/dashboard" : "/productos");

        Map<String, Object> userMap = new HashMap<>();
        userMap.put("id", u.getId());
        userMap.put("nombre", u.getNombre() != null ? u.getNombre() : "");
        userMap.put("correo", u.getCorreo() != null ? u.getCorreo() : "");
        userMap.put("rolId", u.getRolId() != null ? u.getRolId() : 2);
        resp.put("usuario", userMap);

        return ResponseEntity.ok(resp);
    }

    @PostMapping("/registro")
    public ResponseEntity<Map<String, Object>> registrar(@RequestBody Map<String, Object> body) {
        Map<String, Object> resp = new HashMap<>();
        try {
            String nombre = body.get("nombre") != null ? String.valueOf(body.get("nombre")).trim() : "";
            String apellido = body.get("apellido") != null ? String.valueOf(body.get("apellido")).trim() : "";
            String numDoc = body.get("numeroIdentificacion") != null ? String.valueOf(body.get("numeroIdentificacion")).trim() : "";
            String telefono = body.get("telefono") != null ? String.valueOf(body.get("telefono")).trim() : "";
            String fechaNacStr = body.get("fechaNacimiento") != null ? String.valueOf(body.get("fechaNacimiento")).trim() : "";
            String correo = body.get("correo") != null ? String.valueOf(body.get("correo")).trim() : "";
            String clave = body.get("clave") != null ? String.valueOf(body.get("clave")).trim() : "";
            String autorizacion = body.get("autorizacionDatos") != null ? String.valueOf(body.get("autorizacionDatos")).trim() : "NO";
            int tipoDocId = body.get("tipoDocumentoId") != null ? Integer.parseInt(String.valueOf(body.get("tipoDocumentoId"))) : 1;

            if (nombre.isEmpty() || apellido.isEmpty() || correo.isEmpty() || !correo.contains("@")) {
                resp.put("status", "error");
                resp.put("message", "Por favor completa correctamente tus nombres, apellidos y correo electrÃ³nico.");
                return ResponseEntity.badRequest().body(resp);
            }
            if (!numDoc.matches("\\d{10}")) {
                resp.put("status", "error");
                resp.put("message", "El nÃºmero de documento debe tener exactamente 10 dÃ­gitos.");
                return ResponseEntity.badRequest().body(resp);
            }
            if (!telefono.matches("\\d{10}")) {
                resp.put("status", "error");
                resp.put("message", "El nÃºmero de celular debe tener exactamente 10 dÃ­gitos.");
                return ResponseEntity.badRequest().body(resp);
            }
            if (clave.length() < 8) {
                resp.put("status", "error");
                resp.put("message", "La contraseÃ±a debe tener mÃ­nimo 8 caracteres.");
                return ResponseEntity.badRequest().body(resp);
            }
            if (fechaNacStr.isEmpty()) {
                resp.put("status", "error");
                resp.put("message", "La fecha de nacimiento es obligatoria.");
                return ResponseEntity.badRequest().body(resp);
            }

            LocalDate fechaNac = LocalDate.parse(fechaNacStr.substring(0, 10));
            if (Period.between(fechaNac, LocalDate.now()).getYears() < 18) {
                resp.put("status", "error");
                resp.put("message", "Debes ser mayor de 18 aÃ±os para registrarte en Beauty Boost.");
                return ResponseEntity.badRequest().body(resp);
            }

            if (service.buscarPorCorreo(correo).isPresent()) {
                resp.put("status", "error");
                resp.put("message", "Error al guardar en base de datos. Verifique que la cÃ©dula o correo no estÃ©n registrados previamente.");
                return ResponseEntity.status(HttpStatus.CONFLICT).body(resp);
            }

            Usuario entidad = new Usuario();
            entidad.setNombre(nombre);
            entidad.setApellido(apellido);
            entidad.setTipoDocumentoId(tipoDocId);
            entidad.setNumeroIdentificacion(numDoc);
            entidad.setTelefono(telefono);
            entidad.setFechaNacimiento(fechaNac.atStartOfDay());
            entidad.setCorreo(correo);
            entidad.setClave(clave);
            entidad.setAutorizacionDatos(autorizacion);
            entidad.setEstadoUsuario("Activo");
            entidad.setTipoUsuarioId(4);
            entidad.setRolId(2);
            entidad.setFechaVencimientoClave(LocalDate.now().plusYears(2));

            service.registrarNuevoUsuario(entidad);

            resp.put("status", "success");
            resp.put("redirect", "/login?registro=ok");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            resp.put("status", "error");
            resp.put("message", "Error al guardar en base de datos. Verifique que la cÃ©dula o correo no estÃ©n registrados previamente.");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(resp);
        }
    }

    @PostMapping("/recuperar")
    public ResponseEntity<Map<String, Object>> recuperar(@RequestBody Map<String, String> body) {
        Map<String, Object> resp = new HashMap<>();
        String correo = body.get("correo");
        if (correo == null || correo.trim().isEmpty()) {
            resp.put("status", "error");
            resp.put("error", "Por favor ingresa un correo vÃ¡lido.");
            return ResponseEntity.badRequest().body(resp);
        }
        try {
            service.recuperarPassword(correo.trim());
            resp.put("status", "success");
            resp.put("mensaje", "Â¡Nueva contraseÃ±a generada y enviada con Ã©xito! Revisa tu correo.");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            resp.put("status", "error");
            resp.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(resp);
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        session.invalidate();
        Map<String, Object> resp = new HashMap<>();
        resp.put("status", "success");
        resp.put("redirect", "/login");
        return ResponseEntity.ok(resp);
    }

    @GetMapping("/sesion")
    public ResponseEntity<Map<String, Object>> sesionActual(HttpSession session) {
        Object attr = session.getAttribute("usuarioLogueado");
        Map<String, Object> resp = new HashMap<>();
        if (attr instanceof Usuario u) {
            resp.put("autenticado", true);
            resp.put("id", u.getId());
            resp.put("nombre", u.getNombre() != null ? u.getNombre() : "");
            resp.put("apellido", u.getApellido() != null ? u.getApellido() : "");
            resp.put("correo", u.getCorreo() != null ? u.getCorreo() : "");
            resp.put("rolId", u.getRolId() != null ? u.getRolId() : 2);
            return ResponseEntity.ok(resp);
        }
        resp.put("autenticado", false);
        return ResponseEntity.ok(resp);
    }
}