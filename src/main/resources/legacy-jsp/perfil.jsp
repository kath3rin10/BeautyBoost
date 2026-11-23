<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Modelo.Usuario" %>
<%@ page import="Configuracion.CloudinaryConfig" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login.jsp");
        return;
    }

    String tipoDocNombre = (String) request.getAttribute("tipoDocNombre");
    String tipoUsuarioNombre = (String) request.getAttribute("tipoUsuarioNombre");
    List<Map<String, Object>> listaTiposDoc = (List<Map<String, Object>>) request.getAttribute("listaTiposDoc");
    List<Map<String, Object>> listaCiudades = (List<Map<String, Object>>) request.getAttribute("listaCiudades");
    List<Map<String, Object>> listaDirecciones = (List<Map<String, Object>>) request.getAttribute("listaDirecciones");
    List<Map<String, Object>> listaPedidos = (List<Map<String, Object>>) request.getAttribute("listaPedidos");
    List<Map<String, Object>> listaResenas = (List<Map<String, Object>>) request.getAttribute("listaResenas");

    int totalPedidos = (listaPedidos != null) ? listaPedidos.size() : 0;
    int totalResenas = (listaResenas != null) ? listaResenas.size() : 0;
    int totalDirecciones = (listaDirecciones != null) ? listaDirecciones.size() : 0;
    List<Modelo.Producto> listaFavoritos = (List<Modelo.Producto>) request.getAttribute("listaFavoritos");
    int totalFavoritos = listaFavoritos != null ? listaFavoritos.size() : 0;

    String direccionDefectoUsuario = "Sin dirección registrada";
    if (listaDirecciones != null && !listaDirecciones.isEmpty()) {
        Map<String, Object> primeraDir = listaDirecciones.get(0);
        String dirTexto = primeraDir.get("direccion") != null ? primeraDir.get("direccion").toString() : "";
        String ciuTexto = primeraDir.get("ciudad") != null ? primeraDir.get("ciudad").toString() : "";
        direccionDefectoUsuario = dirTexto + (ciuTexto.isEmpty() ? "" : ", " + ciuTexto);
    }

    String mensajeExito = (String) session.getAttribute("mensajeExito");
    String mensajeError = (String) session.getAttribute("mensajeError");
    session.removeAttribute("mensajeExito");
    session.removeAttribute("mensajeError");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost - Mi Perfil</title>
    <!-- ENLACE AL ARCHIVO CSS EXTERNO -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/css/style.css?v=20261001-logo">
</head>
<body class="profile-page" data-context-path="${pageContext.request.contextPath}" data-cloudinary-base="<%= CloudinaryConfig.BASE_URL %>" data-user-email="<%= user.getCorreo() %>" data-logged-in="true">

    <!-- HEADER PRINCIPAL: misma estructura visual del catálogo -->
    <header class="custom-header profile-store-header">
        <div class="header-top-row">
            <div class="header-logo-circle">
                <img src="<%= CloudinaryConfig.BASE_URL %>logo.png" alt="Logo Beauty Boost">
            </div>
            <div class="app-name-oval"><h1>BEAUTY BOOST</h1></div>
            <div class="header-right-space"></div>
        </div>
    </header>
    <nav class="horizontal-navbar profile-store-navbar">
        <div class="navbar-categories">
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Todo</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Maquillaje</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Cuidado Facial</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Brochas</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Novedades</a>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="navbar-link">Más Vendidos</a>
        </div>
        <div class="navbar-right">
            <a href="${pageContext.request.contextPath}/PerfilServlet" class="header-user navbar-user-name" title="Mi Perfil"><span class="header-user-icon">👤</span><strong><%= user.getNombre() %></strong></a>
            <a href="${pageContext.request.contextPath}/ProductoServlet?action=carrito" class="navbar-icon-btn cart-nav-button" title="Carrito">🛒</a>
        </div>
    </nav>

    <!-- CONTENEDOR PRINCIPAL PERFIL -->
    <main class="profile-container">
        
        <% if (mensajeExito != null) { %>
            <div class="alert-box alert-success"><%= mensajeExito %></div>
        <% } %>
        <% if (mensajeError != null) { %>
            <div class="alert-box alert-danger"><%= mensajeError %></div>
        <% } %>

        <!-- BREADCRUMB -->
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/ProductoServlet">🏠 Inicio (Catálogo)</a>
            <span class="breadcrumb-separator">&gt;</span>
            <span id="lblBreadcrumbCurrent" class="breadcrumb-current">Información Personal</span>
        </div>

        <!-- HERO CARD -->
        <section class="hero-profile-card">
            <div class="profile-info-left">
                <img src="<%= CloudinaryConfig.BASE_URL %>logo.png" alt="Avatar" class="avatar-img">
                <div>
                    <h2 class="profile-user-title"><%= user.getNombre() %> <%= user.getApellido() %> <span class="badge-vip"><%= tipoUsuarioNombre != null ? tipoUsuarioNombre : "CLIENTE" %></span></h2>
                    <div class="profile-meta-row">
                        <span>✉ <%= user.getCorreo() %></span>
                        <span>📱 +57 <%= user.getTelefono() %></span>
                        <span>🆔 Doc: <%= user.getNumeroIdentificacion() %></span>
                    </div>
                </div>
            </div>

            <div class="stats-group">
                <div class="stat-card">
                    <span class="stat-number"><%= totalPedidos %></span>
                    <span class="stat-label">Pedidos</span>
                </div>
                <div class="stat-card">
                    <span class="stat-number"><%= totalResenas %></span>
                    <span class="stat-label">Reseñas</span>
                </div>
                <div class="stat-card">
                    <span class="stat-number"><%= totalDirecciones %></span>
                    <span class="stat-label">Direcciones</span>
                </div>
            </div>
        </section>

        <!-- LAYOUT GRID -->
        <div class="profile-grid-layout">
            
            <!-- SIDEBAR -->
            <aside>
                <div class="sidebar-card">
                    <span class="sidebar-title-label">Centro de Control</span>
                    <div class="menu-list">
                        <button class="menu-btn active" id="btnTab1" onclick="switchTab('tab1', 'Información Personal')">
                            <span>👤 Información Personal</span>
                            <span>›</span>
                        </button>
                        <button class="menu-btn" id="btnTab2" onclick="switchTab('tab2', 'Direcciones de Envío')">
                            <span>📍 Direcciones de Envío</span>
                            <span class="menu-badge-count"><%= totalDirecciones %></span>
                        </button>
                        <button class="menu-btn" id="btnTab3" onclick="switchTab('tab3', 'Mis Pedidos e Historial')">
                            <span>📦 Mis Pedidos e Historial</span>
                            <span class="menu-badge-count"><%= totalPedidos %></span>
                        </button>
                        <button class="menu-btn" id="btnTab4" onclick="switchTab('tab4', 'Mis Reseñas y Opiniones')">
                            <span>✍️ Mis Reseñas y Opiniones</span>
                            <span class="menu-badge-count"><%= totalResenas %></span>
                        </button>
                        <button class="menu-btn" id="btnTab5" onclick="switchTab('tab5', 'Seguridad y Privacidad')">
                            <span>🛡️ Seguridad y Privacidad</span>
                            <span>›</span>
                        </button>
                        <button class="menu-btn" id="btnTab6" onclick="switchTab('tab6', 'Mis Favoritos')">
                            <span>♥ Mis Favoritos</span>
                            <span class="menu-badge-count" id="favoritesCountBadge"><%= totalFavoritos %></span>
                        </button>
                    </div>

                    <a href="${pageContext.request.contextPath}/LoginServlet?action=logout" class="logout-link">
                        <button class="btn-logout" type="button">🚪 Cerrar Sesión</button>
                    </a>
                </div>
            </aside>

            <!-- PANEL PRINCIPAL -->
            <section class="content-panel">
                
                <!-- PESTAÑA 1 -->
                <div class="tab-content active" id="tab1">
                    <div class="panel-header-block">
                        <h3>Información Personal</h3>
                        <p>Actualiza tus datos registrados en el sistema.</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/PerfilServlet" method="POST">
                        <input type="hidden" name="action" value="actualizarDatos">
                        <div class="form-grid-2">
                            <div class="form-group">
                                <label>Tipo de Documento</label>
                                <select class="form-control" name="tipoDocumento" disabled>
                                    <% if (listaTiposDoc != null) {
                                        for (Map<String, Object> td : listaTiposDoc) { %>
                                            <option value="<%= td.get("id") %>" <%= td.get("descripcion").equals(tipoDocNombre) ? "selected" : "" %>><%= td.get("descripcion") %></option>
                                    <%  }
                                    } %>
                                </select>
                                <% 
                                    String idTipoDocActual = "";
                                    if (listaTiposDoc != null && tipoDocNombre != null) {
                                        for (Map<String, Object> td : listaTiposDoc) {
                                            if (td.get("descripcion").equals(tipoDocNombre)) {
                                                idTipoDocActual = String.valueOf(td.get("id"));
                                                break;
                                            }
                                        }
                                    }
                                %>
                                <!-- Campo oculto para mantener el valor al enviar el formulario -->
                                <input type="hidden" name="tipoDocumento" value="<%= idTipoDocActual %>">
                            </div>
                            <div class="form-group">
                                <label>Número de Identificación</label>
                                <input type="text" class="form-control" name="numeroIdentificacion" value="<%= user.getNumeroIdentificacion() %>" readonly>
                            </div>
                            <div class="form-group">
                                <label>Nombres</label>
                                <input type="text" class="form-control" name="nombre" value="<%= user.getNombre() %>" required>
                            </div>
                            <div class="form-group">
                                <label>Apellidos</label>
                                <input type="text" class="form-control" name="apellido" value="<%= user.getApellido() %>" required>
                            </div>
                            <div class="form-group">
                                <label>Teléfono móvil</label>
                                <input type="text" class="form-control" name="telefono" value="<%= user.getTelefono() %>" required>
                            </div>
                            <div class="form-group">
                                <label>Correo Electrónico</label>
                                <input type="email" class="form-control" name="correo" value="<%= user.getCorreo() %>" required>
                            </div>
                            <div class="form-group">
                                <label>Fecha de Nacimiento</label>
                                <input type="date" class="form-control" name="fechaNacimiento" value="<%= request.getAttribute("fechaNacimiento") != null ? request.getAttribute("fechaNacimiento") : "" %>">
                            </div>
                            <!-- BOTÓN UBICADO AL LADO DE LA FECHA DE NACIMIENTO -->
                            <div class="form-submit-container">
                                <button type="submit" class="btn-action-primary">Guardar Cambios</button>
                            </div>
                        </div>
                    </form>

                   <!-- GESTIÓN DE DATOS SENSIBLES -->
                    <div style="margin-top: 25px; padding: 18px; background: #fff8f6; border: 1px solid #e8d5d0; border-radius: 8px;">
                        <h4 style="margin-bottom: 6px; color: #5a3e36; font-size: 15px;">🔒 Gestión de Datos Sensibles</h4>
                        <p style="font-size: 13px; color: #666; margin-bottom: 12px;">¿Necesitas modificar tu Tipo de Documento, Número de Identificación o Fecha de Nacimiento? Envía una solicitud formal al equipo de soporte.</p>
                        <button type="button" onclick="abrirModalSensible()" style="background-color: #7d5a50; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: bold;">Solicitar Modificación de Datos Sensibles</button>
                    </div>

                    <!-- MODAL FORMULARIO DE SOLICITUD -->
                    <div id="customModalSensible" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.4); justify-content: center; align-items: center; z-index: 9999;">
                        <div style="background: #ffffff; padding: 30px; border-radius: 12px; max-width: 450px; width: 90%; text-align: left; box-shadow: 0 10px 30px rgba(90, 62, 54, 0.25); border: 1px solid #e8d5d0; font-family: inherit;">
                            <div style="text-align: center; font-size: 28px; margin-bottom: 5px;">🔒</div>
                            <h3 style="color: #5a3e36; margin-bottom: 8px; font-size: 17px; text-align: center;">Solicitud de Modificación de Datos Sensibles</h3>
                            <p style="color: #666; font-size: 13px; line-height: 1.4; margin-bottom: 15px; text-align: center;">Indica el motivo por el cual necesitas modificar tus datos sensibles:</p>
                            
                            <form action="${pageContext.request.contextPath}/PerfilServlet" method="POST">
                                <input type="hidden" name="action" value="solicitarDatosSensibles">
                                <div style="margin-bottom: 15px;">
                                    <textarea name="motivo" rows="4" placeholder="Escribe aquí detalladamente el motivo..." required style="width: 100%; padding: 10px; border: 1px solid #e8d5d0; border-radius: 6px; font-size: 13px; font-family: inherit; resize: vertical; box-sizing: border-box;"></textarea>
                                </div>
                                <div style="display: flex; gap: 10px; justify-content: flex-end;">
                                    <button type="button" onclick="cerrarModalSensible()" style="background-color: #e8d5d0; color: #5a3e36; border: none; padding: 9px 18px; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: bold;">Cancelar</button>
                                    <button type="submit" style="background-color: #7d5a50; color: white; border: none; padding: 9px 18px; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: bold;">Enviar Solicitud</button>
                                </div>
                            </form>
                        </div>
                    </div>

                </div>

                <!-- PESTAÑA 2 -->
                <div class="tab-content" id="tab2">
                    <div class="panel-header-block">
                        <h3>Direcciones de Envío</h3>
                        <p>Gestión de direcciones registradas.</p>
                    </div>

                    <div class="grid-direcciones">
                        <% if (listaDirecciones != null && !listaDirecciones.isEmpty()) {
                            for (Map<String, Object> dir : listaDirecciones) { %>
                                <div class="card-direccion">
                                    <div class="address-card-head"><h4><%= user.getNombre() %> <%= user.getApellido() %></h4><span class="address-badge">Envío</span></div>
                                    <p>
                                        <%= dir.get("direccion") %><br>
                                        <%= dir.get("ciudad") %> • CP: <%= dir.get("cp") %><br>
                                        📞 +57 <%= user.getTelefono() %>
                                    </p>
                                    <form action="${pageContext.request.contextPath}/PerfilServlet" method="POST" class="address-delete-form" onsubmit="return confirm('¿Eliminar esta dirección de envío?');">
                                        <input type="hidden" name="action" value="eliminarDireccion">
                                        <input type="hidden" name="idDireccion" value="<%= dir.get("id") %>">
                                        <button type="submit" class="btn-address-delete">🗑 Eliminar dirección</button>
                                    </form>
                                </div>
                        <%  }
                        } else { %>
                            <p class="text-muted-msg">No tienes direcciones registradas.</p>
                        <% } %>
                    </div>

                    <div class="seccion-agregar-dir">
                        <h4>+ Agregar Nueva Dirección</h4>
                        <form action="${pageContext.request.contextPath}/PerfilServlet" method="POST">
                            <input type="hidden" name="action" value="agregarDireccion">
                            <div class="form-group">
                                <label>Dirección de Envío</label>
                                <input type="text" class="form-control" name="direccion_envio" placeholder="Ej: Calle 100 # 15-20" required>
                            </div>
                            <div class="form-group">
                                <label>Ciudad</label>
                                <select class="form-control" name="id_ciudad" required>
                                    <option value="" disabled selected>-- Selecciona una ciudad --</option>
                                    <% if (listaCiudades != null && !listaCiudades.isEmpty()) {
                                        for (Map<String, Object> c : listaCiudades) { %>
                                            <option value="<%= c.get("id") %>"><%= c.get("ciudad") %> (CP: <%= c.get("cp") %>)</option>
                                    <%  }
                                    } %>
                                </select>
                            </div>
                            <button type="submit" class="btn-action-primary margin-top-sm">Guardar Dirección</button>
                        </form>
                    </div>
                </div>

                <!-- PESTAÑA 3 -->
                <div class="tab-content" id="tab3">
                    <div class="panel-header-block">
                        <h3>Mis Pedidos e Historial</h3>
                        <p>Revisa tus compras y deja una reseña cuando el pedido haya sido entregado.</p>
                    </div>

                    <div class="orders-list">
                        <% if (listaPedidos != null && !listaPedidos.isEmpty()) {
                            for (Map<String, Object> ped : listaPedidos) {
                                String numPedido = String.valueOf(ped.get("numPedido"));
                                String fecha = String.valueOf(ped.get("fecha"));
                                String estado = String.valueOf(ped.get("estado") != null ? ped.get("estado") : "Pendiente");
                                String estadoIcono = estado.toLowerCase().contains("entregado") ? "✓" : (estado.toLowerCase().contains("camino") ? "🚚" : "📦");
                                double totalVal = ped.get("total") != null ? Double.parseDouble(ped.get("total").toString()) : 0.0;
                                String totalFormateado = String.format("%,.0f", totalVal).replace(",", ".");
                                boolean entregado = "entregado".equalsIgnoreCase(estado) || "3".equals(String.valueOf(ped.get("idEstado")));
                                List<Map<String,Object>> productosPedido = (List<Map<String,Object>>) ped.get("productos");
                        %>
                            <article class="order-history-card" data-pedido-id="<%= ped.get("idPedido") %>">
                                <div class="order-history-head">
                                    <div class="order-history-id">
                                        <span class="order-history-kicker">BEAUTY BOOST · PEDIDO</span>
                                        <h4>#<%= numPedido %></h4>
                                        <span><%= fecha %></span>
                                    </div>
                                    <div class="order-history-status <%= entregado ? "delivered" : "" %>">
                                        <span class="status-dot"></span><%= estadoIcono %> <%= estado %>
                                    </div>
                                </div>

                                <div class="order-history-products">
                                    <% if (productosPedido != null && !productosPedido.isEmpty()) {
                                        for (Map<String,Object> prod : productosPedido) {
                                            int productoId = prod.get("idProducto") != null ? Integer.parseInt(prod.get("idProducto").toString()) : 0;
                                            String nombreProducto = prod.get("nombre") != null ? prod.get("nombre").toString() : "Producto";
                                            String imagenProducto = prod.get("imagen") != null ? prod.get("imagen").toString() : "";
                                            String imagenSrc = imagenProducto.trim().isEmpty()
                                                    ? request.getContextPath() + "/Vista/img/product-placeholder.svg"
                                                    : CloudinaryConfig.toUrl(imagenProducto);
                                            double subtotalProd = prod.get("subtotal") != null ? Double.parseDouble(prod.get("subtotal").toString()) : 0;
                                            boolean puedeResenar = productoId > 0;
                                            String jsNombre = nombreProducto.replace("\\","\\\\").replace("'","\\'");
                                    %>
                                        <div class="order-product-row">
                                            <div class="order-product-main">
                                                <div class="order-product-image"><img src="<%= imagenSrc %>" alt="<%= nombreProducto %>"></div>
                                                <div>
                                                    <strong><%= nombreProducto %></strong>
                                                    <span>Cantidad: <%= prod.get("cantidad") %></span>
                                                </div>
                                            </div>
                                            <div class="order-product-side">
                                                <strong>$ <%= String.format("%,.0f", subtotalProd).replace(",", ".") %></strong>
                                                <% if (puedeResenar) { %>
                                                    <button type="button" class="review-open-btn"
                                                        onclick="abrirModalResena(<%= ped.get("idPedido") %>, <%= productoId %>, '<%= jsNombre %>')">
                                                        ★ Dejar Reseña
                                                    </button>
                                                <% } else if (!entregado) { %>
                                                    <span class="review-pending-note">Reseña disponible desde este pedido.</span>
                                                <% } %>
                                                <button type="button" class="order-add-cart-btn" onclick="agregarProductoPedido(<%= productoId %>, <%= prod.get("cantidad") != null ? prod.get("cantidad") : 1 %>)">🛒 Agregar al carrito</button>
                                            </div>
                                        </div>
                                    <%  }
                                    } else { %>
                                        <div class="order-no-products">No hay detalle de productos disponible para este pedido.</div>
                                    <% } %>
                                </div>

                                <div class="order-history-foot">
                                    <span>Total del pedido</span>
                                    <strong>$ <%= totalFormateado %></strong>
                                </div>
                            </article>
                        <%  }
                        } else { %>
                            <div class="profile-empty-state">
                                <div class="profile-empty-icon">🛍</div>
                                <h4>Aún no tienes pedidos</h4>
                                <p>Cuando realices una compra, aparecerá aquí tu historial.</p>
                                <a href="${pageContext.request.contextPath}/ProductoServlet">Explorar la tienda →</a>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- PESTAÑA 4 -->
                <div class="tab-content" id="tab4">
                    <div class="panel-header-block">
                        <h3>Mis Reseñas y Opiniones</h3>
                        <p>Tus opiniones registradas.</p>
                    </div>

                    <% if (listaResenas != null && !listaResenas.isEmpty()) {
                        for (Map<String, Object> res : listaResenas) {
                            int rating = res.get("calificacion") != null ? Integer.parseInt(res.get("calificacion").toString()) : 0;
                            String reviewImage = res.get("productoImagen") != null ? res.get("productoImagen").toString() : "";
                            reviewImage = reviewImage.trim().isEmpty()
                                    ? request.getContextPath() + "/Vista/img/product-placeholder.svg"
                                    : CloudinaryConfig.toUrl(reviewImage);
                    %>
                        <article class="my-review-card">
                            <div class="my-review-image"><img src="<%= reviewImage %>" alt="Producto reseñado"></div>
                            <div class="my-review-content">
                                <div class="my-review-top">
                                    <div>
                                        <span class="review-kicker">TU OPINIÓN</span>
                                        <h4><%= res.get("productoNombre") != null ? res.get("productoNombre") : "Producto" %></h4>
                                    </div>
                                    <time><%= res.get("fecha") %></time>
                                </div>
                                <div class="review-stars-display" aria-label="<%= rating %> de 5 estrellas">
                                    <% for (int s = 1; s <= 5; s++) { %><span class="<%= s <= rating ? "filled" : "" %>">★</span><% } %>
                                </div>
                                <p><%= res.get("observacion") %></p>
                            </div>
                        </article>
                    <%  }
                    } else { %>
                        <div class="profile-empty-state">
                            <div class="profile-empty-icon">✍</div>
                            <h4>Todavía no has publicado reseñas</h4>
                            <p>Cuando un pedido sea entregado podrás valorar cada producto desde tu historial.</p>
                        </div>
                    <% } %>
                </div>
                
                <!-- PESTAÑA 5 -->
                <div class="tab-content" id="tab5">
                    <div class="panel-header-block">
                        <h3>Seguridad y Privacidad</h3>
                        <p>Aquí encontrarás los términos, condiciones y tu autorización para el tratamiento de datos personales.</p>
                    </div>

                    <section class="terms-privacy-card">
                        <div class="terms-privacy-icon">📜</div>
                        <div class="terms-privacy-copy">
                            <span class="privacy-kicker">TÉRMINOS Y CONDICIONES</span>
                            <h4>Tratamiento de datos personales</h4>
                            <p>Beauty Boost utilizará tus datos para administrar tu cuenta, procesar pedidos, gestionar entregas, atender solicitudes y mantener la seguridad de la plataforma.</p>
                            <details class="terms-details" open>
                                <summary>Leer términos y condiciones</summary>
                                <div class="terms-details-body">
                                    <p><strong>1. Cuenta:</strong> la información registrada debe ser correcta y mantenerse actualizada.</p>
                                    <p><strong>2. Pedidos:</strong> los datos de contacto y dirección se usan para preparar y entregar tus compras.</p>
                                    <p><strong>3. Privacidad:</strong> la información personal no debe utilizarse para finalidades diferentes a las informadas sin la autorización correspondiente.</p>
                                    <p><strong>4. Autorización:</strong> puedes cambiar tu decisión desde este apartado cuando quieras.</p>
                                </div>
                            </details>
                        </div>
                    </section>

                    <div class="privacy-section profile-privacy-card">
                        <div class="privacy-section-heading">
                            <div class="privacy-icon">🛡️</div>
                            <div><h4>Autorización</h4><p>Selecciona la casilla para aceptar los términos y el tratamiento de tus datos personales.</p></div>
                        </div>
                        <form action="${pageContext.request.contextPath}/PerfilServlet" method="POST" class="privacy-consent-form">
                            <input type="hidden" name="action" value="actualizarAutorizacion">
                            <label class="privacy-checkbox-label">
                                <input type="checkbox" name="autorizacionDatos" value="true" <%= ("SI".equalsIgnoreCase(String.valueOf(request.getAttribute("autorizacionDatos"))) || "1".equals(String.valueOf(request.getAttribute("autorizacionDatos"))) || "true".equalsIgnoreCase(String.valueOf(request.getAttribute("autorizacionDatos")))) ? "checked" : "" %>>
                                <span><strong>Acepto los términos y el tratamiento de mis datos personales</strong><small>Puedes cambiar esta autorización cuando quieras.</small></span>
                            </label>
                            <button type="submit" class="btn-action-primary privacy-save-btn">Guardar autorización</button>
                        </form>
                    </div>
                </div>

                <!-- PESTAÑA 6 -->
                <div class="tab-content" id="tab6">
                    <div class="panel-header-block">
                        <h3>Mis Favoritos</h3>
                        <p>Tu lista de productos guardados para comprar más tarde.</p>
                    </div>
                    <div id="favoritesProfileGrid" class="favorites-profile-grid">
                    <% if (listaFavoritos != null && !listaFavoritos.isEmpty()) {
                        for (Modelo.Producto fav : listaFavoritos) {
                            String img = fav.getImagenUrl();
                            if (img == null || img.trim().isEmpty()) img = "img/default.jpg";
                            String src = (img.startsWith("http://") || img.startsWith("https://")) ? img : request.getContextPath() + "/Vista/" + img.replace(" ", "%20");
                    %>
                        <article class="favorite-profile-card" data-favorite-profile-id="<%= fav.getIdProducto() %>">
                            <button type="button" class="favorite-remove-btn" onclick="quitarFavoritoPerfil(<%= fav.getIdProducto() %>)" title="Quitar de favoritos">♥</button>
                            <div class="favorite-profile-image"><img src="<%= src %>" alt="<%= fav.getNombreProd() %>" onerror="this.src='<%= request.getContextPath() %>/Vista/img/default.jpg'"></div>
                            <div class="favorite-profile-info">
                                <span>BEAUTY BOOST</span>
                                <h4><%= fav.getNombreProd() %></h4>
                                <strong>$ <%= String.format("%,.0f", fav.getPrecio()).replace(",", ".") %></strong>
                                <button type="button" class="btn-action-primary" onclick="abrirModalDetalle(<%= fav.getIdProducto() %>)">Ver producto</button>
                            </div>
                        </article>
                    <% } } else { %>
                        <div class="favorites-empty"><div>♡</div><h4>Aún no tienes favoritos</h4><p>Marca el corazón de un producto y aparecerá aquí.</p><a href="${pageContext.request.contextPath}/ProductoServlet" class="btn-action-primary">Explorar productos</a></div>
                    <% } %>
                    </div>
                </div>

            </section>
        </div>
    </main>



    <!-- MODAL DE PRODUCTO DESDE FAVORITOS -->
    <div id="productModal" class="product-modal-overlay" role="dialog" aria-modal="true" aria-labelledby="modalNombre" hidden>
        <div class="modal-panel product-modal-panel">
            <button type="button" data-action="close-product-modal" class="modal-close" aria-label="Cerrar detalles">×</button>
            <div class="modal-product-image">
                <img id="modalImg" src="<%= CloudinaryConfig.BASE_URL %>logo.png" alt="Producto" class="modal-product-image-img">
            </div>
            <div class="modal-product-content">
                <span id="modalCategoria" class="modal-category-badge">Beauty Boost</span>
                <h2 id="modalNombre" class="modal-product-title"></h2>
                <div id="modalPrecio" class="modal-product-price"></div>
                <div class="modal-stock-row"><span class="modal-info-label">Disponibilidad</span><span id="modalStock" class="modal-stock">En existencia</span></div>
                <section class="modal-detail-section"><h4>Descripción del producto</h4><p id="modalDescripcion" class="modal-product-description"></p></section>
                <section class="modal-detail-section"><h4>Modo de empleo</h4><p id="modalModoUso" class="modal-use-text"></p></section>
                <section class="modal-reviews-section">
                    <div class="modal-reviews-heading">
                        <div><span class="modal-reviews-kicker">EXPERIENCIAS REALES</span><h4>Reseñas de clientes</h4></div>
                        <div class="modal-review-summary"><strong id="modalReviewAverage">0.0</strong><span id="modalReviewStars">☆☆☆☆☆</span><small id="modalReviewCount">0 reseñas</small></div>
                    </div>
                    <div id="modalReviewsList" class="modal-reviews-list"><div class="modal-reviews-loading">Cargando opiniones…</div></div>
                    <div class="product-modal-review-box">
                        <div class="product-modal-review-box-head"><div><strong>¿Ya probaste este producto?</strong><small>Comparte tu experiencia con estrellas y un comentario.</small></div></div>
                        <form id="productReviewForm" class="product-review-form" onsubmit="return publicarResenaDesdeProducto(event)">
                            <input type="hidden" id="productReviewProductId" name="productoId">
                            <div class="product-review-stars" role="radiogroup" aria-label="Calificación de 1 a 5 estrellas">
                                <input type="radio" id="productStar5" name="calificacion" value="5"><label for="productStar5" title="5 estrellas">★</label>
                                <input type="radio" id="productStar4" name="calificacion" value="4"><label for="productStar4" title="4 estrellas">★</label>
                                <input type="radio" id="productStar3" name="calificacion" value="3"><label for="productStar3" title="3 estrellas">★</label>
                                <input type="radio" id="productStar2" name="calificacion" value="2"><label for="productStar2" title="2 estrellas">★</label>
                                <input type="radio" id="productStar1" name="calificacion" value="1"><label for="productStar1" title="1 estrella">★</label>
                            </div>
                            <textarea id="productReviewComment" name="observacion" maxlength="255" placeholder="Escribe tu opinión sobre el producto..." required></textarea>
                            <div class="product-review-form-footer"><small id="productReviewMessage" aria-live="polite"></small><button type="submit" class="modal-review-submit">Publicar Reseña</button></div>
                        </form>
                    </div>
                </section>
                <div class="modal-quantity-row">
                    <span class="modal-quantity-label">Cantidad</span>
                    <div class="modal-quantity-control" aria-label="Seleccionar cantidad">
                        <button type="button" data-action="modal-qty" data-change="-1" class="modal-qty-btn" aria-label="Disminuir cantidad">−</button>
                        <input type="text" id="modalCantidadInput" value="1" readonly aria-label="Cantidad">
                        <button type="button" data-action="modal-qty" data-change="1" class="modal-qty-btn" aria-label="Aumentar cantidad">+</button>
                    </div>
                </div>
                <button type="button" data-action="add-modal" class="modal-add-button">🛍 Agregar al Carrito</button>
            </div>
        </div>
    </div>

    <div id="customAlertModal" class="login-alert-overlay" hidden>
        <div class="modal-panel">
            <div class="bb-inline-5711b60f30">🔒</div>
            <h3 class="bb-inline-5424676451">Iniciar Sesión</h3>
            <p id="customAlertMessage" class="bb-inline-cd9b1cf8f5"></p>
            <button data-action="go-login" class="bb-inline-d6a764f76e">IR A INICIAR SESIÓN</button>
        </div>
    </div>

    <!-- MODAL DE RESEÑA -->
    <div id="reviewModal" class="review-modal" aria-hidden="true">
        <div class="review-modal-card">
            <button type="button" class="review-modal-close" onclick="cerrarModalResena()" aria-label="Cerrar">×</button>
            <span class="review-modal-kicker">BEAUTY BOOST · TU EXPERIENCIA</span>
            <h3>Cuéntanos qué te pareció</h3>
            <p class="review-modal-product" id="reviewProductName">Producto</p>

            <form action="${pageContext.request.contextPath}/PerfilServlet" method="POST" id="reviewForm">
                <input type="hidden" name="action" value="publicarResena">
                <input type="hidden" name="pedidoId" id="reviewPedidoId">
                <input type="hidden" name="productoId" id="reviewProductoId">

                <div class="star-picker" role="radiogroup" aria-label="Calificación">
                    <input type="radio" id="star5" name="calificacion" value="5"><label for="star5" title="5 estrellas">★</label>
                    <input type="radio" id="star4" name="calificacion" value="4"><label for="star4" title="4 estrellas">★</label>
                    <input type="radio" id="star3" name="calificacion" value="3"><label for="star3" title="3 estrellas">★</label>
                    <input type="radio" id="star2" name="calificacion" value="2"><label for="star2" title="2 estrellas">★</label>
                    <input type="radio" id="star1" name="calificacion" value="1"><label for="star1" title="1 estrella">★</label>
                </div>
                <div class="star-picker-help">Selecciona de 1 a 5 estrellas</div>

                <label class="review-field-label" for="reviewComment">Tu comentario</label>
                <textarea id="reviewComment" name="observacion" maxlength="255" rows="5"
                          placeholder="Cuéntanos sobre la calidad, textura, empaque o cómo te fue con el producto..." required></textarea>
                <div class="review-character-count"><span id="reviewChars">0</span>/255</div>

                <button type="submit" class="review-submit-btn">Publicar Reseña <span>→</span></button>
            </form>
        </div>
    </div>

    <!-- SCRIPT DE PESTAÑAS Y MODAL CONECTADO AL SERVLET -->
    <script>
        function switchTab(tabId, titleText) {
            for (let i = 1; i <= 5; i++) {
                const btn = document.getElementById('btnTab' + i);
                const tab = document.getElementById('tab' + i);
                if (btn) btn.classList.remove('active');
                if (tab) tab.classList.remove('active');
            }
            const activeIndex = tabId.replace('tab', '');
            const currentBtn = document.getElementById('btnTab' + activeIndex);
            const currentTab = document.getElementById(tabId);
            if (currentBtn) currentBtn.classList.add('active');
            if (currentTab) currentTab.classList.add('active');
            const breadcrumb = document.getElementById('lblBreadcrumbCurrent');
            if (breadcrumb) breadcrumb.innerText = titleText;
        }
        
        function abrirModalSensible() {
            const modal = document.getElementById('customModalSensible');
            if (modal) {
                modal.style.display = 'flex';
            }
        }

        function cerrarModalSensible() {
            const modal = document.getElementById('customModalSensible');
            if (modal) {
                modal.style.display = 'none';
            }
        }

        function abrirModalResena(pedidoId, productoId, nombreProducto) {
            const modal = document.getElementById('reviewModal');
            if (!modal) return;
            document.getElementById('reviewPedidoId').value = pedidoId;
            document.getElementById('reviewProductoId').value = productoId;
            document.getElementById('reviewProductName').textContent = nombreProducto || 'Producto';
            document.getElementById('reviewComment').value = '';
            document.getElementById('reviewChars').textContent = '0';
            document.querySelectorAll('#reviewForm input[name="calificacion"]').forEach(r => r.checked = false);
            modal.classList.add('open');
            modal.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');
        }

        function cerrarModalResena() {
            const modal = document.getElementById('reviewModal');
            if (!modal) return;
            modal.classList.remove('open');
            modal.setAttribute('aria-hidden', 'true');
            document.body.classList.remove('modal-open');
        }

        async function quitarFavoritoPerfil(id) {
            try {
                const r = await fetch('${pageContext.request.contextPath}/PerfilServlet?action=toggleFavorito&productoId=' + encodeURIComponent(id), {method:'POST', credentials:'same-origin', headers:{'X-Requested-With':'XMLHttpRequest'}});
                const d = await r.json();
                if (!r.ok || !d.ok) throw new Error(d.message || 'No fue posible quitar el favorito.');
                const card = document.querySelector('.favorite-profile-card[data-favorite-profile-id="' + id + '"]');
                if (card) card.remove();
                const badge = document.getElementById('favoritesCountBadge');
                if (badge) badge.textContent = String(d.total || 0);
                if (!(d.total > 0)) {
                    const box = document.getElementById('favoritesProfileGrid');
                    if (box) box.innerHTML = '<div class="favorites-empty"><div>♡</div><h4>Aún no tienes favoritos</h4><p>Marca el corazón de un producto y aparecerá aquí.</p><a href="${pageContext.request.contextPath}/ProductoServlet" class="btn-action-primary">Explorar productos</a></div>';
                }
            } catch(e) { alert(e.message || 'No fue posible actualizar favoritos.'); }
        }

        async function sincronizarEstadosPedidos() {
            try {
                const r = await fetch('${pageContext.request.contextPath}/PedidoEstadoServlet', {credentials:'same-origin', cache:'no-store'});
                if (!r.ok) return;
                const data = await r.json();
                if (!data || data.status !== 'success' || !Array.isArray(data.pedidos)) return;
                data.pedidos.forEach(function(pedido){
                    const card=document.querySelector('.order-history-card[data-pedido-id="'+pedido.idPedido+'"]');
                    if(!card) return;
                    const badge=card.querySelector('.order-history-status');
                    if(!badge) return;
                    const entregado=Number(pedido.estadoId)===3 || String(pedido.estado||'').toLowerCase()==='entregado';
                    const icono=entregado?'✓':(Number(pedido.estadoId)===2?'🚚':'📦');
                    badge.classList.toggle('delivered',entregado);
                    badge.innerHTML='<span class="status-dot"></span> '+icono+' '+pedido.estado;
                });
            } catch(e) { /* la vista conserva el último estado conocido */ }
        }

        document.addEventListener('DOMContentLoaded', function () {
            sincronizarEstadosPedidos();
            window.setInterval(sincronizarEstadosPedidos, 8000);
            const comment = document.getElementById('reviewComment');
            if (comment) {
                comment.addEventListener('input', function () {
                    document.getElementById('reviewChars').textContent = this.value.length;
                });
            }
            const modal = document.getElementById('reviewModal');
            if (modal) {
                modal.addEventListener('click', function (e) {
                    if (e.target === modal) cerrarModalResena();
                });
            }
        });

    </script>
    <script>
        window.products = [
        <% if (listaFavoritos != null) {
            for (int i = 0; i < listaFavoritos.size(); i++) {
                Modelo.Producto fp = listaFavoritos.get(i);
                String fn = fp.getNombreProd() == null ? "" : fp.getNombreProd();
                String fd = fp.getDescripcionProd() == null ? "" : fp.getDescripcionProd();
                String fi = fp.getImagen() == null ? "" : fp.getImagen();
                fn = fn.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", " ").replace("\n", " ");
                fd = fd.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", " ").replace("\n", " ");
                fi = fi.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", " ").replace("\n", " ");
        %>{id:<%= fp.getIdProducto() %>,nombre:"<%= fn %>",categoria:"<%= fp.getCategoriaIdCategoria()==1?"cuidado-facial":(fp.getCategoriaIdCategoria()==2?"maquillaje":(fp.getCategoriaIdCategoria()==11?"brochas":(fp.getCategoriaIdCategoria()==13?"novedades":"otros"))) %>",precio:<%= fp.getPrecio() %>,stock:<%= fp.getStock() %>,imagen:"<%= fi %>",descripcion:"<%= fd %>",badge:"Favorito"}<%= (i < listaFavoritos.size()-1) ? "," : "" %>
        <% } } %>
        ];
    </script>
    <script src="${pageContext.request.contextPath}/Vista/js/beauty-boost.js"></script>
    <script>
        async function agregarProductoPedido(id, cantidad, nombre, precio, imagen) {
            try {
                const q = Math.max(1, Number(cantidad) || 1);
                const key = 'beautyBoostCart_' + '<%= user.getCorreo() %>';
                const response = await fetch('${pageContext.request.contextPath}/ProductoServlet?action=productoInfo&id=' + encodeURIComponent(id), {credentials:'same-origin'});
                const product = await response.json();
                if (!response.ok || product.status !== 'success') throw new Error('No fue posible cargar la información del producto.');
                const stockResponse = await fetch('${pageContext.request.contextPath}/ProductoServlet?action=validarStock&id=' + encodeURIComponent(id) + '&cantidad=' + encodeURIComponent(q), {credentials:'same-origin'});
                const stock = await stockResponse.json();
                if (stock.status !== 'success') { alert(stock.message || 'No hay stock disponible.'); return; }
                let cart = []; try { cart = JSON.parse(localStorage.getItem(key) || '[]'); } catch(e) {}
                const idx = cart.findIndex(x => Number(x.id) === Number(id));
                const imageValue = product.imagen || imagen || '';
                if (idx >= 0) {
                    cart[idx].cantidad = (Number(cart[idx].cantidad) || 0) + q;
                    cart[idx].imagen = imageValue;
                    cart[idx].nombre = product.nombre || nombre || cart[idx].nombre;
                    cart[idx].precio = Number(product.precio) || Number(precio) || cart[idx].precio;
                } else {
                    cart.push({id:Number(id), nombre:product.nombre || nombre || 'Producto', precio:Number(product.precio) || Number(precio) || 0, imagen:imageValue, cantidad:q});
                }
                localStorage.setItem(key, JSON.stringify(cart));
                if (typeof actualizarContadorCarrito === 'function') actualizarContadorCarrito();
                const toast = document.createElement('div'); toast.className='bb-toast show'; toast.textContent='✓ Producto agregado al carrito'; document.body.appendChild(toast);
                setTimeout(()=>toast.remove(),2200);
            } catch (e) { alert(e.message || 'No fue posible agregar el producto al carrito.'); }
        }
    </script>
</body>
</html>