<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Configuracion.CloudinaryConfig" %>
<%@ page import="Modelo.Usuario" %>
<%
    boolean usuarioLogueado = (session.getAttribute("usuarioLogueado") != null);
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    
    if (!usuarioLogueado || user == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login.jsp");
        return;
    }
    
    String nombreCompleto = user.getNombre() + " " + user.getApellido();
    String correoUsuario = user.getCorreo();
    String telefonoUsuario = user.getTelefono() != null ? user.getTelefono() : "";
    java.util.List<java.util.Map<String,Object>> direccionesCheckout =
            (java.util.List<java.util.Map<String,Object>>) request.getAttribute("direccionesCheckout");
    if (direccionesCheckout == null) direccionesCheckout = new java.util.ArrayList<>();
    boolean tieneDireccion = !direccionesCheckout.isEmpty();
    java.util.Map<String,Object> direccionSeleccionada = tieneDireccion ? direccionesCheckout.get(0) : null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost - Checkout</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/css/style.css?v=20260923">
</head>
<body class="catalog-page checkout-body">

    <!-- HEADER SUPERIOR -->
    <header class="custom-header no-print">
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

    <!-- NAVBAR HORIZONTAL -->
    <nav class="horizontal-navbar no-print">
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
            <a href="${pageContext.request.contextPath}/ProductoServlet?action=carrito" class="navbar-icon-btn" title="Carrito">🛒</a>
        </div>
    </nav>

    <!-- BARRA DE PASOS -->
    <div class="no-print checkout-steps-bar">
        <div class="step-pill active" id="pillStep1">
            <span class="step-number" id="numStep1">1</span>
            <span>PASO 01<br><small class="checkout-step-sub">Entrega y Envío</small></span>
        </div>
        <div class="checkout-step-divider"></div>
        <div class="step-pill" id="pillStep2">
            <span class="step-number" id="numStep2">2</span>
            <span>PASO 02<br><small class="checkout-step-sub">Método de Pago</small></span>
        </div>
        <div class="checkout-step-divider"></div>
        <div class="step-pill" id="pillStep3">
            <span class="step-number" id="numStep3">3</span>
            <span>PASO 03<br><small class="checkout-step-sub">Confirmación</small></span>
        </div>
    </div>

    <!-- MENSAJE DE CARRITO GENERADO POR EL SERVLET -->
    <% if (request.getAttribute("mensajeCarritoServidor") != null) { %>
    <div class="checkout-server-alert no-print" role="alert">
        <div class="checkout-server-alert-icon">🛍</div>
        <div>
            <strong><%= request.getAttribute("mensajeCarritoServidor") %></strong>
            <span><%= request.getAttribute("detalleCarritoServidor") %></span>
        </div>
        <a href="${pageContext.request.contextPath}/ProductoServlet" class="checkout-server-alert-btn">Explorar productos →</a>
    </div>
    <% } %>

    <!-- CONTENEDOR PRINCIPAL CHECKOUT -->
    <main class="checkout-main-container <%= request.getAttribute("mensajeCarritoServidor") != null ? "checkout-empty-server" : "" %>">
        
        <div class="checkout-grid-layout" id="checkoutMainLayout">
            
            <!-- COLUMNA IZQUIERDA -->
            <div id="leftStepContent">
                
                <!-- PASO 1: DATOS DE ENTREGA Y ENVÍO -->
                <div id="viewStep1">
                    <span class="checkout-process-tag">● PROCESO DE COMPRA</span>
                    <h2 class="checkout-section-title">1. Datos de Entrega y Envío</h2>
                    <p class="checkout-section-desc">Selecciona tu dirección de residencia y escoge el método de despacho ideal para tus cosméticos.</p>

                    <!-- DIRECCIONES REALES DEL USUARIO -->
                    <div class="checkout-card-box">
                        <div class="checkout-card-header">
                            <strong class="checkout-card-title">📍 Dirección de envío</strong>
                            <% if (tieneDireccion) { %>
                                <span class="checkout-badge-primary">REGISTRADA EN TU CUENTA</span>
                            <% } %>
                        </div>

                        <% if (!tieneDireccion) { %>
                            <div class="checkout-no-address">
                                <strong>No tienes ninguna dirección de envío registrada.</strong>
                                <span>Agrega una dirección desde tu perfil antes de continuar con la compra.</span>
                                <a href="${pageContext.request.contextPath}/PerfilServlet" class="btn-primary-brown checkout-add-address-btn">+ Agregar dirección</a>
                            </div>
                        <% } else { %>
                            <div class="checkout-address-inner">
                                <div class="checkout-flex-between">
                                    <strong class="checkout-card-title"><%= nombreCompleto %></strong>
                                    <% if (!telefonoUsuario.isEmpty()) { %><span class="checkout-phone-text">📞 +57 <%= telefonoUsuario %></span><% } %>
                                </div>
                                <% if (direccionesCheckout.size() == 1) { %>
                                    <input type="hidden" id="direccionId" value="<%= direccionSeleccionada.get("id") %>">
                                    <p class="checkout-address-text"><%= direccionSeleccionada.get("direccion") %> • <%= direccionSeleccionada.get("ciudad") %><br>Código postal: <%= direccionSeleccionada.get("cp") %></p>
                                <% } else { %>
                                    <label class="checkout-label" for="direccionId">Selecciona una de tus direcciones</label>
                                    <select id="direccionId" class="checkout-input checkout-address-select">
                                        <% for (java.util.Map<String,Object> dir : direccionesCheckout) { %>
                                            <option value="<%= dir.get("id") %>"><%= dir.get("direccion") %> • <%= dir.get("ciudad") %></option>
                                        <% } %>
                                    </select>
                                    <p class="checkout-address-text" id="direccionDetalleSeleccionada"><%= direccionSeleccionada.get("direccion") %> • <%= direccionSeleccionada.get("ciudad") %><br>Código postal: <%= direccionSeleccionada.get("cp") %></p>
                                <% } %>
                            </div>
                            <div class="checkout-card-footer">
                                <a href="${pageContext.request.contextPath}/PerfilServlet" class="checkout-link-brown">⚙ Cambiar o agregar dirección</a>
                                <span class="checkout-verified-text">✓ Registrada</span>
                            </div>
                        <% } %>
                    </div>

                    <!-- TIPO DE ENVÍO -->
                    <h3 class="checkout-subsection-title">Tipo de Envío <small class="checkout-subtitle-note">Empaquetado biodegradable incluido</small></h3>
                    
                    <div class="shipping-option selected" id="optEstandar" onclick="seleccionarEnvio('estandar', 0)">
                        <div class="checkout-flex-center">
                            <input type="radio" name="tipoEnvioRadio" id="radioEstandar" checked class="checkout-radio">
                            <div>
                                <strong class="checkout-option-title">Envío Estándar Nacional</strong> <span class="checkout-tag-gray">2-4 días hábiles</span>
                                <p class="checkout-option-desc">Coordinado con Servientrega & Coordinadora logística certificada. Despacho garantizado.</p>
                            </div>
                        </div>
                        <div class="checkout-text-right">
                            <strong class="checkout-price-green">GRATIS</strong>
                            <div class="checkout-price-strike">$14.500</div>
                        </div>
                    </div>

                    <div class="shipping-option" id="optExpress" onclick="seleccionarEnvio('express', 12000)">
                        <div class="checkout-flex-center">
                            <input type="radio" name="tipoEnvioRadio" id="radioExpress" class="checkout-radio">
                            <div>
                                <strong class="checkout-option-title">Envío Express Mismo Día (Bogotá)</strong> <span class="checkout-tag-red">Hoy Mismo</span>
                                <p class="checkout-option-desc">Pedidos realizados antes de las 2:00 p.m. entregados hoy mismo en moto ecológica.</p>
                            </div>
                        </div>
                        <div class="checkout-text-right">
                            <strong class="checkout-option-title">$12.000</strong>
                            <div class="checkout-price-muted">Urbano</div>
                        </div>
                    </div>

                    <!-- INSTRUCCIONES REPARTIDOR -->
                    <div class="checkout-instructions-box">
                        <label class="checkout-label">Instrucciones para el Repartidor <small class="checkout-subtitle-note">(Opcional)</small></label>
                        <textarea placeholder="Ej: Dejar en portería o timbre 402, llamar antes de llegar..." class="checkout-textarea"></textarea>
                    </div>

                    <div id="mensajeStep1" class="checkout-payment-selection-message" aria-live="polite"></div>
                    <div class="checkout-flex-between">
                        <a href="${pageContext.request.contextPath}/ProductoServlet?action=carrito" class="checkout-back-link">← Volver al carrito</a>
                        <button type="button" onclick="irAlPaso2()" class="btn-primary-brown" <%= tieneDireccion ? "" : "disabled" %>>Continuar al Pago →</button>
                    </div>
                </div>

                <!-- PASO 2: MÉTODO DE PAGO -->
                <div id="viewStep2" class="checkout-hidden-view">
                    
                    <span class="checkout-process-tag">● PASO SEGURO</span>
                    <h2 class="checkout-section-title">2. Método de Pago</h2>

                    <!-- PESTAÑAS DE PAGO -->
                    <div class="checkout-payment-tabs">
                        <div class="payment-tab" id="tabWompi" onclick="cambiarTabPago('wompi')">
                            💳 Pagar en línea con Wompi<br><small class="checkout-tab-sub">Tarjeta, PSE, Nequi y más</small>
                        </div>
                        <div class="payment-tab" id="tabContraentrega" onclick="cambiarTabPago('contraentrega')">
                            📦 Contra Entrega<br><small class="checkout-tab-sub">Selecciona para pagar al recibir</small>
                        </div>
                    </div>

                    <!-- FORMULARIO TARJETA -->
                    <div class="checkout-card-form checkout-cod-box" id="formContraentrega" style="display:none;">
                        <div class="checkout-cod-icon">📦</div>
                        <div>
                            <h3 class="checkout-option-title">Pago efectivo contra entrega</h3>
                            <p class="checkout-option-desc">No pagas ahora. Pagarás el total al recibir tu pedido.</p>
                        </div>
                        <div class="checkout-cod-note">✓ Sin tarjeta · ✓ Sin Wompi · ✓ Sin cargos en línea</div>
                        <div class="receiver-data-card">
                            <div class="receiver-data-heading"><span>👤</span><div><strong>Datos de quien recibe</strong><small>Todos los datos son obligatorios para confirmar el pedido.</small></div></div>
                            <div class="checkout-form-grid receiver-grid">
                                <div><label class="checkout-form-label" for="contraNombrePedido">Nombre completo *</label><input type="text" id="contraNombrePedido" name="contraNombrePedido" class="checkout-input" placeholder="Nombre y apellidos" autocomplete="name"></div>
                                <div><label class="checkout-form-label" for="contraDocumento">Cédula / ID *</label><input type="text" id="contraDocumento" name="contraDocumento" class="checkout-input" placeholder="Número de documento" inputmode="numeric"></div>
                                <div><label class="checkout-form-label" for="contraTelefono">Teléfono de contacto *</label><input type="tel" id="contraTelefono" name="contraTelefono" class="checkout-input" placeholder="300 000 0000" autocomplete="tel"></div>
                                <div class="receiver-notes-field"><label class="checkout-form-label" for="contraNotas">Notas adicionales de entrega</label><textarea id="contraNotas" name="contraNotas" class="checkout-textarea" rows="3" placeholder="Ej. Portería, apartamento, horario o indicaciones para el repartidor"></textarea></div>
                            </div>
                        </div>
                    </div>

                    <div class="checkout-card-form" id="formWompi" style="display:none;">
                        <h3 class="checkout-option-title">Pago seguro con Wompi</h3>
                        <p class="checkout-option-desc">Te llevaremos a la página segura de Wompi para pagar con tarjeta, PSE, Nequi u otros medios. Al terminar volverás a Beauty Boost.</p>
                    </div>

                    <div id="paymentSelectionMessage" class="checkout-payment-selection-message" aria-live="polite"></div>
                    <div class="checkout-flex-between mt-30">
                        <button type="button" onclick="volverAlPaso1()" class="checkout-text-btn">← Volver a Entrega</button>
                        <button type="button" id="btnConfirmarPago" onclick="procesarPagoFinal()" class="btn-primary-brown">Selecciona un método de pago →</button>
                    </div>
                </div>

            </div>

            <!-- COLUMNA DERECHA: RESUMEN DE COMPRA -->
            <div class="checkout-summary-container" id="rightSummaryContainer">
                <div class="checkout-summary-header">
                    <h3 class="checkout-summary-title">Resumen del pedido</h3>
                    <span class="checkout-summary-badge" id="lblNumArticulos">0 Artículos</span>
                </div>
                
                <!-- CUPÓN -->
                <div class="checkout-coupon-box">
                    <input type="text" placeholder="Código promo (Ej: BOOST10)" class="checkout-input-coupon">
                    <button type="button" class="checkout-coupon-btn">Aplicar</button>
                </div>

                <!-- LISTA DE PRODUCTOS DEL CARRITO -->
                <div id="checkoutItemsList" class="checkout-items-scroll">
                </div>

                <div class="checkout-summary-totals">
                    <div class="checkout-flex-between">
                        <span>Subtotal productos</span>
                        <span id="checkoutSubtotal">$0</span>
                    </div>
                    <div class="checkout-flex-between">
                        <span>Costo de Envío</span>
                        <span id="checkoutCostEnvio" class="checkout-price-green">GRATIS</span>
                    </div>
                    <div class="checkout-flex-between checkout-border-bottom">
                        <span>Descuento aplicado</span>
                        <span>-$0</span>
                    </div>
                    <div class="checkout-flex-between checkout-total-row">
                        <span>Total Estimado</span>
                        <span id="checkoutTotal" class="checkout-total-color">$0</span>
                    </div>
                </div>

                <div class="checkout-security-notes">
                    <div>🛡️ Pago 100% Seguro cifrado SSL de 256-bit</div>
                    <div>🔄 Garantía de cambio sin costo por 30 días</div>
                    <div>🌿 Fórmulas limpias, veganas y cruelty-free certificadas</div>
                </div>
            </div>

        </div>

        <!-- PASO 3: CONFIRMACIÓN Y ESTADO DEL PEDIDO -->
        <div id="viewStep3" class="checkout-confirmation-view" hidden>
            
            <!-- HEADER DE LOGO EXCLUSIVO PARA IMPRESIÓN -->
            <div class="print-logo-header">
                <div class="checkout-print-brand">BEAUTY BOOST</div>
                <div class="checkout-print-meta">COMPROBANTE OFICIAL DE COMPRA<br>www.beautyboost.com.co</div>
            </div>

            <div class="checkout-confirmation-hero">
                <div class="no-print checkout-success-icon">✓</div>
                <span class="checkout-order-number-badge" id="lblOrdenConfirmadaNum">ORDEN CONFIRMADA #BB-89241</span>
                <h1 class="checkout-success-title">¡Gracias por tu compra, <%= user.getNombre() %>! ✨</h1>
                <p class="checkout-success-desc">Tu pedido fue registrado correctamente. El pago quedó programado como <strong>efectivo contra entrega</strong>.</p>
                <div class="checkout-success-date">📅 <%= new java.text.SimpleDateFormat("dd 'de' MMMM, yyyy", new java.util.Locale("es", "ES")).format(new java.util.Date()) %> • 🚚 Pedido preparado para despacho</div>
            </div>

            <div class="checkout-confirmation-grid">
                
                <div class="checkout-confirmation-col">
                    
                    <div class="checkout-card-box">
                        <div class="checkout-card-header">
                            <strong class="checkout-card-title">📦 Estado del Pedido</strong>
                            <span class="checkout-badge-green">EN TIEMPO</span>
                        </div>

                        <div class="checkout-current-status-badge"><span class="status-pulse"></span><span id="checkoutCurrentStatus">📦 Pendiente</span><small>Estado actual del pedido</small></div>
                    </div>

                    <div class="checkout-card-box">
                        <div class="checkout-info-label">DESTINO DEL PAQUETE</div>
                        <h4 class="checkout-info-subtitle">Dirección de Entrega</h4>
                        <p class="checkout-address-block" id="confirmacionDireccionTexto">
                            <strong><%= nombreCompleto %></strong><br>
                            <% if (tieneDireccion) { %>
                                <%= direccionSeleccionada.get("direccion") %><br><%= direccionSeleccionada.get("ciudad") %>, Colombia
                            <% } else { %>
                                Sin dirección registrada.
                            <% } %>
                        </p>
                    </div>

                    <div class="checkout-card-box">
                        <div class="checkout-info-label">MÉTODO DE PAGO</div>
                        <h4 class="checkout-info-subtitle">Método de Pago</h4>
                        <div class="checkout-flex-between-center">
                            <div class="checkout-payment-desc">📦 <strong>Efectivo contra entrega</strong><br>Pago pendiente al recibir el pedido</div>
                            <span class="checkout-badge-green">Contra entrega</span>
                        </div>
                    </div>

                </div>

                <div class="checkout-card-box">
                    <div class="checkout-summary-header">
                        <h3 class="checkout-summary-title">Artículos Comprados</h3>
                        <span class="checkout-text-muted-xs">Boutique Bag</span>
                    </div>

                    <div id="confirmedItemsList" class="checkout-confirmed-list">
                    </div>

                    <div class="checkout-summary-totals">
                        <div class="checkout-flex-between">
                            <span>Subtotal</span>
                            <span id="finalSubtotal">$0</span>
                        </div>
                        <div class="checkout-flex-between">
                            <span>Envío Nacional</span>
                            <span class="checkout-price-green">GRATIS</span>
                        </div>
                        <div class="checkout-flex-between checkout-border-bottom">
                            <span>Impuestos IVA (19% incluido)</span>
                            <span id="finalIva">$0</span>
                        </div>
                        <div class="checkout-flex-between checkout-total-row">
                            <span>Total del pedido</span>
                            <span id="finalTotal" class="checkout-total-color">$0</span>
                        </div>
                    </div>

                </div>

            </div>

            <!-- BOTONES FINALES -->
            <div class="no-print checkout-final-buttons">
                <a href="${pageContext.request.contextPath}/ProductoServlet" class="btn-primary-brown checkout-anchor-btn">🛍️ Seguir comprando en el catálogo</a>
            </div>

        </div>

    </main>



    <!-- SCRIPT DE NAVEGACIÓN Y ENVÍO A MYSQL -->
    <script>
        window.contextPath = "${pageContext.request.contextPath}";
        const userEmail = "<%= correoUsuario %>";
        let costoEnvioActual = 0;

        function obtenerCarritoKey() {
            return 'beautyBoostCart_' + (userEmail ? userEmail : 'invitado');
        }

        document.addEventListener('DOMContentLoaded', () => {
            cargarResumenCheckout();
            const step3 = document.getElementById('viewStep3');
            if (step3) { step3.hidden = true; step3.style.display = 'none'; }
            const btn = document.getElementById('btnConfirmarPago');
            if (btn) { btn.disabled = true; btn.classList.add('is-disabled'); }
            const contra = document.getElementById('formContraentrega');
            if (contra) contra.style.display = 'none';
            ['tabWompi','tabContraentrega'].forEach(id => { const el=document.getElementById(id); if(el) el.classList.remove('selected'); });
        });

        const cloudinaryBase = '<%= CloudinaryConfig.BASE_URL %>';
        function resolveProductImage(value){
            const raw=(value||'').trim();
            if(!raw) return (window.contextPath||'')+'/Vista/img/default.jpg';
            if(/^https?:\/\//i.test(raw)) return raw;
            const clean=raw.replace(/^\/+/, '').replace(/^(?:Vista\/img\/|img\/)/i,'');
            return cloudinaryBase+encodeURI(clean);
        }

        function cargarResumenCheckout() {
            const container = document.getElementById('checkoutItemsList');
            const lblArticulos = document.getElementById('lblNumArticulos');
            let carrito = JSON.parse(localStorage.getItem(obtenerCarritoKey())) || [];

            if (lblArticulos) lblArticulos.innerText = carrito.length + " Artículos";

            if (carrito.length === 0) {
                container.innerHTML = `
                    <div class="checkout-inline-empty">
                        <div class="checkout-inline-empty-icon">🛍</div>
                        <div><strong>Tu carrito está vacío</strong><span>Agrega productos antes de continuar con la compra.</span></div>
                        <a href="\${window.contextPath}/ProductoServlet">Explorar productos</a>
                    </div>`;
                document.getElementById('checkoutSubtotal').innerText = '$0';
                document.getElementById('checkoutTotal').innerText = '$0';
                return;
            }

            let subtotal = 0;
            container.innerHTML = carrito.map(item => {
                let totalItem = item.precio * item.cantidad;
                subtotal += totalItem;

                return `
                    <div class="checkout-cart-item-row">
                        <div class="checkout-flex-center gap-10">
                            <img src="\${resolveProductImage(item.imagen)}" alt="\${item.nombre}" class="checkout-cart-img">
                            <div>
                                <span class="checkout-cart-name">\${item.nombre}</span>
                                <span class="checkout-cart-details">Cant: \${item.cantidad} • $\${Number(item.precio).toLocaleString('es-CO')}</span>
                            </div>
                        </div>
                        <span class="checkout-cart-item-total">$\${Number(totalItem).toLocaleString('es-CO')}</span>
                    </div>
                `;
            }).join('');

            const total = subtotal + costoEnvioActual;
            document.getElementById('checkoutSubtotal').innerText = '$' + Number(subtotal).toLocaleString('es-CO');
            document.getElementById('checkoutTotal').innerText = '$' + Number(total).toLocaleString('es-CO');
        }

        function seleccionarEnvio(tipo, costo) {
            costoEnvioActual = costo;
            document.getElementById('optEstandar').classList.remove('selected');
            document.getElementById('optExpress').classList.remove('selected');
            document.getElementById('radioEstandar').checked = (tipo === 'estandar');
            document.getElementById('radioExpress').checked = (tipo === 'express');

            if (tipo === 'estandar') {
                document.getElementById('optEstandar').classList.add('selected');
                document.getElementById('checkoutCostEnvio').innerText = 'GRATIS';
                document.getElementById('checkoutCostEnvio').style.color = '#2e7d32';
                const lblEnvio = document.getElementById('lblTipoEnvioSeleccionado'); if (lblEnvio) lblEnvio.innerText = 'Envío Estándar';
            } else {
                document.getElementById('optExpress').classList.add('selected');
                document.getElementById('checkoutCostEnvio').innerText = '$12.000';
                document.getElementById('checkoutCostEnvio').style.color = '#2b2b2b';
                const lblEnvio = document.getElementById('lblTipoEnvioSeleccionado'); if (lblEnvio) lblEnvio.innerText = 'Envío Express Mismo Día';
            }
            cargarResumenCheckout();
        }

        function irAlPaso2() {
            const carrito = JSON.parse(localStorage.getItem(obtenerCarritoKey())) || [];
            const direccion = document.getElementById('direccionId');
            if (!direccion || !direccion.value) {
                mostrarMensajeDireccion('Debes agregar y seleccionar una dirección de envío antes de continuar.');
                return;
            }
            if (carrito.length === 0) {
                window.location.href = `\${window.contextPath}/ProductoServlet?action=checkout&carritoVacio=true`;
                return;
            }
            document.getElementById('viewStep1').style.display = 'none';
            document.getElementById('viewStep2').style.display = 'block';

            document.getElementById('pillStep1').classList.remove('active');
            document.getElementById('pillStep1').classList.add('completed');
            document.getElementById('numStep1').innerText = '✓';

            document.getElementById('pillStep2').classList.add('active');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function volverAlPaso1() {
            document.getElementById('viewStep2').style.display = 'none';
            document.getElementById('viewStep1').style.display = 'block';

            document.getElementById('pillStep1').classList.remove('completed');
            document.getElementById('pillStep1').classList.add('active');
            document.getElementById('numStep1').innerText = '1';

            document.getElementById('pillStep2').classList.remove('active');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function cambiarTabPago(tab) {
            const esWompi = tab === 'wompi';
            document.getElementById('tabWompi').classList.toggle('selected', esWompi);
            document.getElementById('tabContraentrega').classList.toggle('selected', !esWompi);
            document.getElementById('formWompi').style.display = esWompi ? 'flex' : 'none';
            document.getElementById('formContraentrega').style.display = esWompi ? 'none' : 'flex';

            if (!esWompi) {
                const nombre = document.getElementById('contraNombrePedido');
                const telefono = document.getElementById('contraTelefono');
                const documento = document.getElementById('contraDocumento');
                if(nombre && !nombre.value) nombre.value = '<%= nombreCompleto.replace("'", "\\'") %>';
                if(telefono && !telefono.value) telefono.value = '<%= telefonoUsuario.replace("'", "\\'") %>';
                if(documento && !documento.value) documento.value = '<%= user.getNumeroIdentificacion() == null ? "" : user.getNumeroIdentificacion().replace("'", "\\'") %>';
            }
            const btn = document.getElementById('btnConfirmarPago');
            btn.disabled = false;
            btn.classList.remove('is-disabled');
            btn.textContent = esWompi ? 'Pagar con Wompi →' : 'Confirmar pedido →';
        }

        // Crea el pedido en el servidor y abre el checkout de Wompi.
        async function pagarConWompi(carrito) {
            mostrarMensajePago('Conectando con Wompi…');
            try {
                const params = new URLSearchParams({
                    action: 'prepararWompi', carritoJson: JSON.stringify(carrito),
                    direccionId: document.getElementById('direccionId').value,
                    tipoEnvio: costoEnvioActual > 0 ? 'express' : 'estandar'
                });
                const respuesta = await fetch(window.contextPath + '/ProductoServlet', {method:'POST',credentials:'same-origin',headers:{'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'},body:params});
                const w = await respuesta.json().catch(()=>({status:'error',message:'Respuesta inválida del servidor.'}));
                if (!respuesta.ok || w.status !== 'success') throw new Error(w.message || 'No fue posible iniciar el pago.');
                if (!w.publicKey || w.publicKey.includes('REEMPLAZAR')) throw new Error('Wompi no está configurado (beautyboost-wompi.properties).');

                const url = new URL(w.checkoutUrl);
                url.searchParams.set('public-key', w.publicKey);
                url.searchParams.set('currency', 'COP');
                url.searchParams.set('amount-in-cents', w.amountInCents);
                url.searchParams.set('reference', w.reference);
                url.searchParams.set('signature:integrity', w.integrity);
                if (w.redirectUrl) url.searchParams.set('redirect-url', w.redirectUrl);
                window.location.href = url.toString();
            } catch (error) { mostrarMensajePago(error.message); }
        }

        async function procesarPagoFinal() {
            const carrito = JSON.parse(localStorage.getItem(obtenerCarritoKey())) || [];
            if (!carrito.length) { window.location.href = `\${window.contextPath}/ProductoServlet?action=checkout&carritoVacio=true`; return; }
            if (document.getElementById('tabWompi').classList.contains('selected')) { pagarConWompi(carrito); return; }
            if (!document.getElementById('tabContraentrega').classList.contains('selected')) {
                mostrarMensajePago('Selecciona un método de pago para continuar.'); return;
            }
            const required = ['contraNombrePedido','contraDocumento','contraTelefono','contraNotas'];
            const invalid = required.find(id => !document.getElementById(id)?.value.trim());
            if (invalid) { mostrarMensajePago('Completa los datos obligatorios de quien recibe el pedido.'); document.getElementById(invalid)?.focus(); return; }
            const notas = document.getElementById('contraNotas')?.value.trim() || '';
            if (notas.length > 500) { mostrarMensajePago('Las notas de entrega no pueden superar 500 caracteres.'); return; }

            let subtotal = 0;
            const confirmedContainer = document.getElementById('confirmedItemsList');
            confirmedContainer.innerHTML = carrito.map(item => {
                const totalItem = Number(item.precio) * Number(item.cantidad); subtotal += totalItem;
                return `<div class="checkout-confirmed-row"><div class="checkout-flex-center gap-8"><img src="\${resolveProductImage(item.imagen)}" alt="\${item.nombre}" class="checkout-confirmed-img"><div><strong class="checkout-confirmed-name">\${item.nombre}</strong><span class="checkout-confirmed-qty">Cant: \${item.cantidad}</span></div></div><span class="checkout-confirmed-price">$\${Number(totalItem).toLocaleString('es-CO')}</span></div>`;
            }).join('');
            const totalLocal = subtotal + costoEnvioActual;
            document.getElementById('finalSubtotal').innerText = '$' + subtotal.toLocaleString('es-CO');
            document.getElementById('finalIva').innerText = '$' + Math.round(subtotal * 0.19).toLocaleString('es-CO');
            document.getElementById('finalTotal').innerText = '$' + totalLocal.toLocaleString('es-CO');
            mostrarMensajePago('Registrando tu pedido…');

            try {
                const params = new URLSearchParams({
                    action:'procesarCompra', metodoPago:'contraentrega', carritoJson:JSON.stringify(carrito),
                    numeroPedido:String(Math.floor(Math.random()*90000)+10000), total:String(totalLocal), costoEnvio:String(costoEnvioActual||0),
                    direccionId:document.getElementById('direccionId').value,
                    contraNombrePedido:document.getElementById('contraNombrePedido').value.trim(),
                    contraDocumento:document.getElementById('contraDocumento').value.trim(),
                    contraTelefono:document.getElementById('contraTelefono').value.trim(), contraNotas:notas
                });
                const respuesta = await fetch(window.contextPath + '/ProductoServlet', {method:'POST',credentials:'same-origin',headers:{'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8','X-Requested-With':'XMLHttpRequest'},body:params});
                const resultado = await respuesta.json().catch(()=>({status:'error',message:'Respuesta inválida del servidor.'}));
                if(!respuesta.ok || resultado.status!=='success') throw new Error(resultado.message || 'No fue posible guardar el pedido.');
                document.getElementById('lblOrdenConfirmadaNum').innerText='ORDEN CONFIRMADA #BB-'+resultado.numeroPedido;
                document.getElementById('finalTotal').innerText='$'+Number(resultado.totalServidor||totalLocal).toLocaleString('es-CO');
                const estadoTexto = resultado.estado || 'Pendiente';
                const estadoIcono = estadoTexto.toLowerCase().includes('camino') ? '🚚' : (estadoTexto.toLowerCase().includes('entregado') ? '✓' : '📦');
                document.getElementById('checkoutCurrentStatus').textContent = estadoIcono + ' ' + estadoTexto;
                localStorage.removeItem(obtenerCarritoKey());
                document.getElementById('checkoutMainLayout').style.display='none';
                document.getElementById('viewStep3').hidden=false; document.getElementById('viewStep3').style.display='block';
                document.getElementById('pillStep2').classList.remove('active'); document.getElementById('pillStep2').classList.add('completed'); document.getElementById('numStep2').innerText='✓';
                document.getElementById('pillStep3').classList.add('active');
                document.getElementById('numStep3').innerText='3';
                document.getElementById('paymentSelectionMessage').classList.remove('show');
                window.scrollTo({top:0,behavior:'smooth'});
            } catch(error) { mostrarMensajePago(error.message || 'No fue posible guardar el pedido.'); }
        }

        function mostrarMensajeDireccion(texto){
            const aviso = document.getElementById('mensajeStep1');
            if (aviso) { aviso.textContent = texto; aviso.classList.add('show'); }
        }

        function actualizarDetalleDireccion(){
            const select = document.getElementById('direccionId');
            const detalle = document.getElementById('direccionDetalleSeleccionada');
            if (!select || !detalle || select.tagName !== 'SELECT') return;
            const option = select.options[select.selectedIndex];
            if (!option) return;
            const textoDireccion = option.textContent.trim();
            detalle.textContent = textoDireccion;
            const confirmacion = document.getElementById('confirmacionDireccionTexto');
            if (confirmacion) {
                const nombre = confirmacion.querySelector("strong") ? confirmacion.querySelector("strong").textContent : "";
                confirmacion.textContent = "";
                const strong = document.createElement("strong");
                strong.textContent = nombre;
                confirmacion.appendChild(strong);
                confirmacion.appendChild(document.createElement("br"));
                confirmacion.appendChild(document.createTextNode(textoDireccion));
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            const selectDireccion = document.getElementById('direccionId');
            if (selectDireccion && selectDireccion.tagName === 'SELECT') {
                selectDireccion.addEventListener('change', actualizarDetalleDireccion);
            }
        });

        function mostrarMensajePago(texto){ const aviso=document.getElementById('paymentSelectionMessage'); if(aviso){ aviso.textContent=texto; aviso.classList.add('show'); } }

    </script>
</body>
</html>
