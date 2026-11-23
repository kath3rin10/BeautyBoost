package com.example.beautyboost.controller;

import com.example.beautyboost.entity.*;
import com.example.beautyboost.repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
public class WebViewController {

    @Autowired private ProductoRepository productoRepository;
    @Autowired private TipoDocumentoRepository tipoDocumentoRepository;
    @Autowired private CiudadRepository ciudadRepository;
    @Autowired private DireccionEnvioRepository direccionEnvioRepository;
    @Autowired private PedidoRepository pedidoRepository;
    @Autowired private DetallePedidoRepository detallePedidoRepository;
    @Autowired private ResenaUsuarioRepository resenaUsuarioRepository;
    @Autowired private FavoritoRepository favoritoRepository;

    @GetMapping({"/", "/index"})
    public String inicio() {
        return "index";
    }

    @GetMapping("/login")
    public String login() {
        return "Login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/registro")
    public String registro() {
        return "Registro";
    }

    @GetMapping("/recuperar-password")
    public String recuperarPassword() {
        return "RecuperarPassword";
    }

    @GetMapping("/productos")
    public String productos(Model model, HttpSession session) {
        model.addAttribute("productosCatalogo", productoRepository.findAll());
        return "Producto";
    }

    @GetMapping("/producto")
    public String detalleProducto() {
        return "pantalla_Producto";
    }

    @GetMapping("/producto-carrito")
    public String productoCarrito() {
        return "pantalla_Producto_Carrito";
    }

    @GetMapping("/carrito")
    public String carrito() {
        return "pantalla_Producto_Carrito";
    }

    @GetMapping("/checkout")
    public String checkout() {
        return "pantalla_Checkout";
    }

    @GetMapping("/wompi-resultado")
    public String wompiResultado() {
        return "wompiResultado";
    }

    @GetMapping("/perfil")
    public String perfil(HttpSession session, Model model) {
        Object attr = session.getAttribute("usuarioLogueado");
        if (!(attr instanceof Usuario user)) {
            return "redirect:/login";
        }
        Integer userId = user.getId();
        String cloudBase = "https://res.cloudinary.com/demo/image/upload/";

        List<Map<String, Object>> listaTiposDoc = new ArrayList<>();
        String tipoDocNombre = "";
        String idTipoDocActual = "";
        for (TipoDocumento td : tipoDocumentoRepository.findAll()) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", td.getId());
            m.put("descripcion", td.getDescripcionTipoDocumento());
            listaTiposDoc.add(m);
            if (user.getTipoDocumentoId() != null && Objects.equals(td.getId(), user.getTipoDocumentoId())) {
                tipoDocNombre = td.getDescripcionTipoDocumento();
                idTipoDocActual = String.valueOf(td.getId());
            }
        }

        Map<Integer, Ciudad> ciudadesMap = new LinkedHashMap<>();
        List<Map<String, Object>> listaCiudades = new ArrayList<>();
        for (Ciudad c : ciudadRepository.findAll()) {
            ciudadesMap.put(c.getId(), c);
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", c.getId());
            m.put("ciudad", c.getDescripcionCiudad());
            m.put("cp", c.getCodigoPostal() != null ? c.getCodigoPostal() : "");
            listaCiudades.add(m);
        }

        List<Map<String, Object>> listaDirecciones = new ArrayList<>();
        for (DireccionEnvio d : direccionEnvioRepository.findAll()) {
            if (Objects.equals(d.getUsuarioId(), userId)) {
                Ciudad c = ciudadesMap.get(d.getCiudadId());
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("id", d.getId());
                m.put("direccion", d.getDireccionEnvio());
                m.put("ciudad", c != null ? c.getDescripcionCiudad() : "");
                m.put("cp", c != null && c.getCodigoPostal() != null ? c.getCodigoPostal() : "");
                listaDirecciones.add(m);
            }
        }

        Map<Integer, Producto> productosMap = new LinkedHashMap<>();
        for (Producto pr : productoRepository.findAll()) {
            productosMap.put(pr.getId(), pr);
        }

        List<DetallePedido> todosDetalles = detallePedidoRepository.findAll();
        List<Map<String, Object>> listaPedidos = new ArrayList<>();
        for (Pedido ped : pedidoRepository.findAll()) {
            if (Objects.equals(ped.getUsuarioId(), userId)) {
                List<Map<String, Object>> prodsPedido = new ArrayList<>();
                for (DetallePedido det : todosDetalles) {
                    if (Objects.equals(det.getPedidoId(), ped.getId())) {
                        Producto pr = productosMap.get(det.getProductoId());
                        Map<String, Object> pm = new LinkedHashMap<>();
                        pm.put("idProducto", det.getProductoId() != null ? det.getProductoId() : 0);
                        pm.put("nombre", pr != null && pr.getNombreProd() != null ? pr.getNombreProd() : "Producto");
                        pm.put("imagen", pr != null && pr.getImagenUrl() != null ? pr.getImagenUrl() : "");
                        pm.put("cantidad", det.getCantidad() != null ? det.getCantidad() : 1);
                        pm.put("subtotal", det.getSubtotal() != null ? det.getSubtotal() : 0);
                        prodsPedido.add(pm);
                    }
                }
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("idPedido", ped.getId());
                m.put("numPedido", ped.getNumeroPedido() != null ? ped.getNumeroPedido() : ped.getId());
                m.put("fecha", ped.getFechaPedido() != null ? ped.getFechaPedido().toString() : "");
                m.put("estado", ped.getEstadoPedido() != null ? ped.getEstadoPedido() : "Pendiente");
                m.put("productos", prodsPedido);
                listaPedidos.add(m);
            }
        }

        List<Map<String, Object>> listaResenas = new ArrayList<>();
        for (ResenaUsuario res : resenaUsuarioRepository.findAll()) {
            if (Objects.equals(res.getUsuarioId(), userId)) {
                Producto pr = productosMap.get(res.getProductoId());
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("id", res.getId());
                m.put("productoNombre", pr != null ? pr.getNombreProd() : "Producto");
                m.put("productoImagen", pr != null ? pr.getImagenUrl() : "");
                m.put("calificacion", res.getCalificacion() != null ? res.getCalificacion() : 0);
                m.put("observacion", res.getObservacion() != null ? res.getObservacion() : "");
                m.put("fecha", res.getFecha() != null ? res.getFecha().toLocalDate().toString() : "");
                listaResenas.add(m);
            }
        }

        List<Producto> listaFavoritos = new ArrayList<>();
        for (Favorito fav : favoritoRepository.findAll()) {
            if (Objects.equals(fav.getUsuarioId(), userId)) {
                Producto pr = productosMap.get(fav.getProductoId());
                if (pr != null) {
                    listaFavoritos.add(pr);
                }
            }
        }

        String fechaNacStr = user.getFechaNacimiento() != null ? user.getFechaNacimiento().toLocalDate().toString() : "";

        model.addAttribute("usuarioLogueado", user);
        model.addAttribute("cloudinaryBaseUrl", cloudBase);
        model.addAttribute("tipoDocNombre", tipoDocNombre);
        model.addAttribute("idTipoDocActual", idTipoDocActual);
        model.addAttribute("tipoUsuarioNombre", "CLIENTE");
        model.addAttribute("fechaNacimiento", fechaNacStr);
        model.addAttribute("listaTiposDoc", listaTiposDoc);
        model.addAttribute("listaCiudades", listaCiudades);
        model.addAttribute("listaDirecciones", listaDirecciones);
        model.addAttribute("listaPedidos", listaPedidos);
        model.addAttribute("listaResenas", listaResenas);
        model.addAttribute("listaFavoritos", listaFavoritos);
        model.addAttribute("totalPedidos", listaPedidos.size());
        model.addAttribute("totalResenas", listaResenas.size());
        model.addAttribute("totalDirecciones", listaDirecciones.size());
        model.addAttribute("totalFavoritos", listaFavoritos.size());
        return "perfil";
    }
}