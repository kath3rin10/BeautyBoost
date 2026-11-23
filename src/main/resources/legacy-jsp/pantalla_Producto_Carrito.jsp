<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Configuracion.CloudinaryConfig" %>
<%
    boolean usuarioLogueado = (session.getAttribute("usuarioLogueado") != null || session.getAttribute("usuario") != null || session.getAttribute("user") != null);
    
    // Obtenemos el correo del usuario logueado para aislar el carrito de forma única en localStorage
    String correoLogin = "";
    if (session.getAttribute("usuarioLogueado") != null) {
        Object obj = session.getAttribute("usuarioLogueado");
        if (obj instanceof Modelo.Usuario) {
            correoLogin = ((Modelo.Usuario) obj).getCorreo();
        } else {
            correoLogin = obj.toString();
        }
    } else if (session.getAttribute("usuario") != null) {
        Object obj = session.getAttribute("usuario");
        if (obj instanceof Modelo.Usuario) {
            correoLogin = ((Modelo.Usuario) obj).getCorreo();
        } else {
            correoLogin = obj.toString();
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
<body class="catalog-page" data-cloudinary-base="<%= CloudinaryConfig.BASE_URL %>">

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

    <!-- NAVBAR HORIZONTAL DE NAVEGACIÓN Y BÚSQUEDA -->
    <nav class="horizontal-navbar">
        <div class="navbar-categories">
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Todo</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Maquillaje</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Cuidado Facial</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Brochas</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Novedades</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Más Vendidos</a>
        </div>
        <div class="navbar-right">
            <a href="${pageContext.request.contextPath}/PerfilServlet" class="navbar-icon-btn" title="Mi Cuenta">👤</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet?action=carrito" class="navbar-icon-btn cart-active-icon" title="Carrito">🛒</a>
        </div>
    </nav>

    <!-- CONTENEDOR PRINCIPAL DEL CARRITO -->
    <main class="cart-page-shell">
        <div class="cart-breadcrumb-wrap">
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="cart-back-link">← Seguir comprando</a>
        </div>

        <div class="cart-page-heading">
            <div>
                <span class="cart-eyebrow">BEAUTY BOOST · TU COMPRA</span>
                <h2 class="cart-section-title">Tu carrito</h2>
                <p class="cart-heading-copy">Revisa tus productos, ajusta las cantidades y continúa cuando estés lista.</p>
            </div>
            <div class="cart-heading-badge"><span>🛍</span> Compra segura</div>
        </div>

        <div class="cart-grid-layout">
            <section class="cart-items-box cart-products-panel">
                <div class="cart-panel-heading">
                    <div>
                        <h3>Productos seleccionados</h3>
                        <p id="cartItemCountLabel">0 productos</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/ProductoServlet" class="cart-add-more">+ Agregar más</a>
                </div>
                <div id="cartItemsContainer">
                    <!-- Se llena dinámicamente con JavaScript -->
                </div>
            </section>

            <aside class="cart-summary-box">
                <div class="cart-summary-top">
                    <span class="cart-summary-kicker">RESUMEN DE PEDIDO</span>
                    <div class="cart-summary-icon">♡</div>
                </div>
                <h3 class="cart-summary-title">Tu compra</h3>

                <div class="cart-summary-row">
                    <span>Subtotal</span>
                    <strong id="resumenSubtotal">$0</strong>
                </div>
                <div class="cart-summary-row">
                    <span>Envío</span>
                    <strong class="cart-free-shipping">Por calcular</strong>
                </div>
                <div class="cart-summary-row cart-border-bottom">
                    <span>Impuestos</span>
                    <strong>Incluidos</strong>
                </div>

                <div class="cart-summary-total-row">
                    <span>Total estimado</span>
                    <strong id="resumenTotal" class="cart-total-color">$0</strong>
                </div>

                <div class="cart-cod-highlight">
                    <span class="cart-cod-icon">📦</span>
                    <div><strong>Pago efectivo contra entrega</strong><small>Paga al recibir tu pedido.</small></div>
                </div>

                <button onclick="procesarPago()" class="btn-primary-cart">
                    <span>Continuar al pago</span><span>→</span>
                </button>
                <p class="cart-secure-note">🔒 Tus datos se procesan de forma segura.</p>
            </aside>
        </div>
    </main>

    <!-- SCRIPT DE RENDERIZADO Y GESTIÓN DEL CARRITO -->
    <script>
        window.contextPath = "${pageContext.request.contextPath}";
        const userEmail = "<%= correoLogin %>";

        // Función clave para aislar el carrito por cada usuario
        function obtenerCarritoKey() {
            return 'beautyBoostCart_' + (userEmail ? userEmail : 'invitado');
        }

        const cloudinaryBase = '<%= CloudinaryConfig.BASE_URL %>';

        function resolveCartImage(value) {
            const raw = String(value || '').trim().replace(/\\/g, '/');
            if (!raw || /^null$|^undefined$/i.test(raw)) return window.contextPath + '/Vista/img/default.jpg';
            if (/^https?:\/\//i.test(raw)) return raw;
            let clean = raw.replace(/^\/+/, '');
            clean = clean.replace(/^.*?Vista\/img\//i, '');
            clean = clean.replace(/^.*?web\/img\//i, '');
            clean = clean.replace(/^img\//i, '');
            if (!clean || /^default\.jpg$/i.test(clean)) return window.contextPath + '/Vista/img/default.jpg';
            return cloudinaryBase + encodeURI(clean);
        }

        async function completarImagenesCarrito(carrito) {
            const pendientes = carrito.filter(item => !item.imagen || /^img\/default\.jpg$|^Vista\/img\/default\.jpg$/i.test(String(item.imagen)));
            if (!pendientes.length) return carrito;
            await Promise.all(pendientes.map(async item => {
                try {
                    const r = await fetch(window.contextPath + '/ProductoServlet?action=productoInfo&id=' + encodeURIComponent(item.id), {credentials:'same-origin'});
                    const d = await r.json();
                    if (r.ok && d.status === 'success' && d.imagen) item.imagen = d.imagen;
                } catch (e) { /* se conserva el fallback */ }
            }));
            localStorage.setItem(obtenerCarritoKey(), JSON.stringify(carrito));
            return carrito;
        }

        async function validarStockCarrito(id, cantidad) {
            try {
                const r = await fetch(window.contextPath + '/ProductoServlet?action=validarStock&id=' + encodeURIComponent(id) + '&cantidad=' + encodeURIComponent(cantidad), {credentials:'same-origin'});
                return await r.json();
            } catch (e) {
                return {status:'error', message:'No fue posible validar el stock en este momento.'};
            }
        }

        async function sincronizarStockCarrito(carrito) {
            const resultado = [];
            let huboCambios = false;
            for (const item of carrito) {
                try {
                    const r = await fetch(window.contextPath + '/ProductoServlet?action=productoInfo&id=' + encodeURIComponent(item.id), {credentials:'same-origin'});
                    const d = await r.json();
                    if (!r.ok || d.status !== 'success') {
                        huboCambios = true;
                        continue;
                    }
                    const stock = Math.max(0, Number(d.stock) || 0);
                    const cantidadAnterior = Math.max(0, Number(item.cantidad) || 0);
                    if (stock <= 0) {
                        huboCambios = true;
                        continue;
                    }
                    const cantidad = Math.min(cantidadAnterior || 1, stock);
                    if (cantidad !== cantidadAnterior) huboCambios = true;
                    item.cantidad = cantidad;
                    if (d.precio != null) item.precio = Number(d.precio);
                    if (d.nombre) item.nombre = d.nombre;
                    if (d.imagen) item.imagen = d.imagen;
                    item.stock = stock;
                    resultado.push(item);
                } catch (e) {
                    resultado.push(item);
                }
            }
            if (huboCambios) {
                localStorage.setItem(obtenerCarritoKey(), JSON.stringify(resultado));
                const originales = carrito.reduce((sum, x) => sum + (Number(x.cantidad) || 0), 0);
                const actuales = resultado.reduce((sum, x) => sum + (Number(x.cantidad) || 0), 0);
                if (actuales < originales) mostrarAvisoStockCarrito('Ajustamos una cantidad porque el stock disponible cambió.');
            }
            return resultado;
        }

        function mostrarAvisoStockCarrito(mensaje) {
            let aviso = document.getElementById('bbCartStockNotice');
            if (!aviso) {
                aviso = document.createElement('div');
                aviso.id = 'bbCartStockNotice';
                aviso.className = 'cart-stock-notice';
                const panel = document.querySelector('.cart-products-panel');
                if (panel) panel.insertBefore(aviso, panel.querySelector('#cartItemsContainer'));
            }
            aviso.textContent = '⚠ ' + mensaje;
            aviso.classList.add('show');
            clearTimeout(window.__bbCartStockNoticeTimer);
            window.__bbCartStockNoticeTimer = setTimeout(() => aviso.classList.remove('show'), 5000);
        }

        async function cargarCarrito() {
            const container = document.getElementById('cartItemsContainer');
            let carrito = JSON.parse(localStorage.getItem(obtenerCarritoKey())) || [];
            carrito = await sincronizarStockCarrito(carrito);
            carrito = await completarImagenesCarrito(carrito);

            if (carrito.length === 0) {
                container.innerHTML = `
                    <div class="cart-empty-container">
                        <div class="cart-empty-icon">🛍</div>
                        <span class="cart-empty-label">AÚN NO HAS AGREGADO PRODUCTOS</span>
                        <h3 class="cart-empty-title">Tu carrito está vacío</h3>
                        <p class="cart-empty-desc">Descubre tus favoritos y agrégalos aquí para continuar con tu compra.</p>
                        <a href="\${window.contextPath}/ProductoServlet" class="cart-empty-btn">EXPLORAR PRODUCTOS <span>→</span></a>
                    </div>
                `;
                document.getElementById('resumenSubtotal').innerText = '$0';
                document.getElementById('resumenTotal').innerText = '$0';
                const countLabel = document.getElementById('cartItemCountLabel');
                if (countLabel) countLabel.innerText = '0 productos';
                return;
            }

            let subtotalGeneral = 0;

            container.innerHTML = carrito.map((item, index) => {
                let totalItem = item.precio * item.cantidad;
                subtotalGeneral += totalItem;

                return `
                    <article class="cart-item-row">
                        <div class="cart-item-left">
                            <div class="cart-item-img-box">
                                <img src="\${resolveCartImage(item.imagen)}" alt="\${item.nombre}" class="cart-item-img" onerror="this.onerror=null;this.src=window.contextPath + '/Vista/img/default.jpg';">
                            </div>
                            <div class="cart-item-info">
                                <span class="cart-item-tag">BEAUTY BOOST</span>
                                <h4 class="cart-item-name">\${item.nombre}</h4>
                                <p class="cart-item-price">$\${Number(item.precio).toLocaleString('es-CO')} <span>c/u</span></p>
                            </div>
                        </div>

                        <div class="cart-item-right">
                            <div class="cart-qty-block">
                                <span class="cart-qty-label">Cantidad</span>
                                <div class="cart-qty-controls">
                                    <button type="button" onclick="cambiarCantidad(\${index}, -1)" class="cart-qty-btn">−</button>
                                    <span class="cart-qty-val">\${item.cantidad}</span>
                                    <button type="button" onclick="cambiarCantidad(\${index}, 1)" class="cart-qty-btn" \${Number(item.cantidad) >= Number(item.stock || 0) ? 'disabled title=\"Stock máximo disponible\"' : ''}>+</button>
                                </div>
                            </div>
                            <div class="cart-item-total-wrap">
                                <span class="cart-item-total-label">Total</span>
                                <strong class="cart-item-total-price">$\${Number(totalItem).toLocaleString('es-CO')}</strong>
                            </div>
                            <button type="button" onclick="eliminarItem(\${index})" class="cart-delete-btn" title="Eliminar producto">×</button>
                        </div>
                    </article>
                `;
            }).join('');

            const countLabel = document.getElementById('cartItemCountLabel');
            if (countLabel) countLabel.innerText = carrito.reduce((sum, item) => sum + (Number(item.cantidad) || 0), 0) + ' unidades';
            document.getElementById('resumenSubtotal').innerText = '$' + Number(subtotalGeneral).toLocaleString('es-CO');
            document.getElementById('resumenTotal').innerText = '$' + Number(subtotalGeneral).toLocaleString('es-CO');
        }

        async function cambiarCantidad(index, cambio) {
            let carrito = JSON.parse(localStorage.getItem(obtenerCarritoKey())) || [];
            if (!carrito[index]) return;
            const nueva = (Number(carrito[index].cantidad) || 0) + Number(cambio || 0);
            if (nueva <= 0) {
                carrito.splice(index, 1);
                localStorage.setItem(obtenerCarritoKey(), JSON.stringify(carrito));
                await cargarCarrito();
                return;
            }
            const check = await validarStockCarrito(carrito[index].id, nueva);
            if (check.status !== 'success') {
                mostrarAvisoStockCarrito(check.message || 'No puedes superar el stock disponible.');
                await cargarCarrito();
                return;
            }
            carrito[index].cantidad = nueva;
            carrito[index].stock = Number(check.stock);
            localStorage.setItem(obtenerCarritoKey(), JSON.stringify(carrito));
            await cargarCarrito();
        }

        function eliminarItem(index) {
            let carrito = JSON.parse(localStorage.getItem(obtenerCarritoKey())) || [];
            carrito.splice(index, 1);
            localStorage.setItem(obtenerCarritoKey(), JSON.stringify(carrito));
            cargarCarrito();
        }

        function procesarPago() {
            let carrito = JSON.parse(localStorage.getItem(obtenerCarritoKey())) || [];
            if (carrito.length === 0) {
                window.location.href = window.contextPath + '/ProductoServlet?action=checkout&carritoVacio=true';
                return;
            }
            window.location.href = window.contextPath + '/ProductoServlet?action=checkout';
        }

        document.addEventListener('DOMContentLoaded', () => {
            cargarCarrito();
        });
    </script>

    <script src="${pageContext.request.contextPath}/Vista/js/menu.js"></script>
</body>
</html>