package com.example.beautyboost.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminViewController {

    @GetMapping({"", "/", "/dashboard"})
    public String dashboard() {
        return "adminDashboard";
    }

    @GetMapping("/productos")
    public String productos() {
        return "adminProductos";
    }

    @GetMapping("/pedidos")
    public String pedidos() {
        return "adminPedidos";
    }

    @GetMapping("/usuarios")
    public String usuarios() {
        return "admin_usuarios";
    }

    @GetMapping("/usuarios/perfil")
    public String usuarioPerfil() {
        return "admin_usuario_perfil";
    }

    @GetMapping("/resenas")
    public String resenas() {
        return "adminResenas";
    }
}
