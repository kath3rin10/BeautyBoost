<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Configuracion.CloudinaryConfig" %>
<%
    boolean usuarioLogueado = false;
    String correoLogin = "";
    
    if (session != null) {
        if (session.getAttribute("usuarioLogueado") != null) {
            usuarioLogueado = true;
            Object obj = session.getAttribute("usuarioLogueado");
            if (obj instanceof Modelo.Usuario) {
                correoLogin = ((Modelo.Usuario) obj).getCorreo();
            } else {
                correoLogin = obj.toString();
            }
        } else if (session.getAttribute("usuario") != null) {
            usuarioLogueado = true;
            Object obj = session.getAttribute("usuario");
            if (obj instanceof Modelo.Usuario) {
                correoLogin = ((Modelo.Usuario) obj).getCorreo();
            } else {
                correoLogin = obj.toString();
            }
        }
    }
    if (correoLogin == null) correoLogin = "";
    correoLogin = correoLogin.trim();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost - Carrito</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/css/style.css?v=20260923">
</head>
<body class="catalog-page">

    <!-- HEADER SUPERIOR ESTRUCTURADO -->
    <header class="custom-header">
        <div class="header-top-row">
            <div class="header-logo-circle">
                <img src="https://res.cloudinary.com/rzxmfg9i/image/upload/v1789523154/logo.png" alt="Logo Beauty Boost">
            </div>
            <div class="app-name-oval">
                <h1>BEAUTY BOOST</h1>
            </div>
            <div class="header-right-space"></div>
        </div>
    </header>

    <!-- CAJA DE DEPURACIÓN TEMPORAL -->
    <div class="cart-debug-box">
        <strong>[Depuración]:</strong> Correo detectado en sesión: <span id="debugEmail" class="cart-debug-bold"></span> | 
        Llave de LocalStorage: <span id="debugKey" class="cart-debug-bold"></span> | 
        Contenido bruto: <span id="debugContent"></span>
    </div>

    <!-- CONTENEDOR PRINCIPAL DEL CARRITO -->
    <main class="cart-main-container">
        <div class="cart-header-title-box">
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="cart-back-link">← Volver a productos</a>
            <h2 class="cart-main-title">Tu Carrito</h2>
        </div>

        <div class="cart-grid-layout">
            <div id="cartItemsContainer" class="cart-items-box">
                <!-- Se llena con JS -->
            </div>

            <div class="cart-summary-box">
                <h3 class="cart-summary-title">Resumen</h3>
                <div class="cart-summary-row">
                    <span>Subtotal</span><span id="lblSubtotal">$0</span>
                </div>
                <div class="cart-summary-row">
                    <span>Envío</span><span id="lblEnvio">$0</span>
                </div>
                <div class="cart-summary-row">
                    <span>Impuestos (5%)</span><span id="lblImpuestos">$0</span>
                </div>
                <div class="cart-summary-total-row">
                    <span>Total</span><span id="lblTotal" class="cart-total-value">$0</span>
                </div>
                <button id="btnPagar" onclick="window.location.href='${pageContext.request.contextPath}/ProductoServlet?action=checkout'" class="cart-btn-checkout">IR A PAGAR</button>
            </div>
        </div>
    </main>

    <script>
        window.contextPath = "${pageContext.request.contextPath}";
        const userEmail = "<%= correoLogin %>";

        function obtenerCarritoKey() {
            return 'beautyBoostCart_' + (userEmail ? userEmail : 'invitado');
        }

        // Mostrar datos de depuración en pantalla
        document.getElementById('debugEmail').innerText = userEmail ? userEmail : '(Vacío / No detectado)';
        document.getElementById('debugKey').innerText = obtenerCarritoKey();
        document.getElementById('debugContent').innerText = localStorage.getItem(obtenerCarritoKey()) || '(Vacío en localStorage)';

        document.addEventListener('DOMContentLoaded', () => {
            cargarCarrito();
        });

        const cloudinaryBase = '<%= CloudinaryConfig.BASE_URL %>';
        function resolveProductImage(value){ const raw=(value||'').trim(); if(!raw) return (window.contextPath||'')+'/Vista/img/default.jpg'; if(/^https?:\/\//i.test(raw)) return raw; const clean=raw.replace(/^\/+/, '').replace(/^(?:Vista\/img\/|img\/)/i,''); return cloudinaryBase+encodeURI(clean); }

        function cargarCarrito() {
            const carrito = JSON.parse(localStorage.getItem(obtenerCarritoKey())) || [];
            const container = document.getElementById('cartItemsContainer');
            
            const lblSubtotal = document.getElementById('lblSubtotal');
            const lblEnvio = document.getElementById('lblEnvio');
            const lblImpuestos = document.getElementById('lblImpuestos');
            const lblTotal = document.getElementById('lblTotal');
            const btnPagar = document.getElementById('btnPagar');

            if (carrito.length === 0) {
                container.innerHTML = `
                    <div class="cart-empty-container">
                        <div class="cart-empty-icon">🛒</div>
                        <h3 class="cart-empty-title">Tu carrito está vacío</h3>
                        <p class="cart-empty-desc">Agrega productos para verlos aquí</p>
                        <a href="${window.contextPath}/ProductoServlet" class="cart-empty-btn">
                            EXPLORAR PRODUCTOS
                        </a>
                    </div>
                `;
                if (lblSubtotal) lblSubtotal.innerText = '$0';
                if (lblEnvio) lblEnvio.innerText = '$0';
                if (lblImpuestos) lblImpuestos.innerText = '$0';
                if (lblTotal) lblTotal.innerText = '$0';
                if (btnPagar) {
                    btnPagar.disabled = true;
                    btnPagar.classList.add('disabled');
                }
                return;
            }

            let subtotal = 0;
            let htmlProductos = '<div class="cart-items-list">';
            
            carrito.forEach((item, index) => {
                subtotal += item.precio * item.cantidad;
                htmlProductos += `
                    <div class="cart-item-row">
                        <div class="cart-item-left">
                            <img src="${resolveProductImage(item.imagen)}" alt="${item.nombre}" class="cart-item-img">
                            <div>
                                <h4 class="cart-item-name">${item.nombre}</h4>
                                <p class="cart-item-qty">Cantidad: ${item.cantidad}</p>
                            </div>
                        </div>
                        <div class="cart-item-right">
                            <p class="cart-item-price">$${(item.precio * item.cantidad).toLocaleString('es-CO')}</p>
                            <button onclick="eliminarDelCarrito(${index})" class="cart-item-delete-btn">Eliminar</button>
                        </div>
                    </div>
                `;
            });
            htmlProductos += '</div>';
            container.innerHTML = htmlProductos;

            const envio = subtotal > 0 ? 10000 : 0; 
            const impuestos = Math.round(subtotal * 0.05); 
            const total = subtotal + envio + impuestos;

            if (lblSubtotal) lblSubtotal.innerText = '$' + subtotal.toLocaleString('es-CO');
            if (lblEnvio) lblEnvio.innerText = '$' + envio.toLocaleString('es-CO');
            if (lblImpuestos) lblImpuestos.innerText = '$' + impuestos.toLocaleString('es-CO');
            if (lblTotal) lblTotal.innerText = '$' + total.toLocaleString('es-CO');
            
            if (btnPagar) {
                btnPagar.disabled = false;
                btnPagar.classList.remove('disabled');
            }
        }

        function eliminarDelCarrito(index) {
            let carrito = JSON.parse(localStorage.getItem(obtenerCarritoKey())) || [];
            carrito.splice(index, 1);
            localStorage.setItem(obtenerCarritoKey(), JSON.stringify(carrito));
            cargarCarrito();
        }
    </script>
</body>
</html>