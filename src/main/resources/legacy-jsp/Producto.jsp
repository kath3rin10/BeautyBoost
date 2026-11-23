<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modelo.Usuario" %>
<%@ page import="Modelo.Producto" %>
<%@ page import="java.util.List" %>
<%@ page import="Configuracion.CloudinaryConfig" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String cloudinaryBase = CloudinaryConfig.BASE_URL;
    boolean usuarioLogueado = (session.getAttribute("usuarioLogueado") != null || session.getAttribute("usuario") != null || session.getAttribute("user") != null);
    
    // Obtenemos el correo del usuario logueado para aislar sus favoritos y carrito en localStorage
    String correoLogin = "";
    String nombreLogin = "";
    boolean esAdmin = false;
    if (session.getAttribute("usuarioLogueado") != null) {
        Modelo.Usuario uTemp = (Modelo.Usuario) session.getAttribute("usuarioLogueado");
        correoLogin = uTemp.getCorreo();
        nombreLogin = uTemp.getNombre();
        esAdmin = uTemp.getRolesIdRol() == 1;
    } else if (session.getAttribute("usuario") != null) {
        correoLogin = session.getAttribute("usuario").toString();
            nombreLogin = correoLogin;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost - Catálogo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/css/style.css?v=20261006-modal-final">

<style id="bb-modal-final-layout">
/* BEAUTY BOOST — MODAL FINAL / LAYOUT DE REFERENCIA */
#productModal.bb-v5-overlay.modal-visible{
    display:flex !important;
    align-items:center !important;
    justify-content:center !important;
    position:fixed !important;
    inset:0 !important;
    z-index:99999 !important;
    padding:24px !important;
    overflow:hidden !important;
    background:rgba(43,31,36,.68) !important;
    backdrop-filter:blur(7px) !important;
    -webkit-backdrop-filter:blur(7px) !important;
}
#productModal.bb-v5-overlay .bb-v5-modal{
    position:relative !important;
    width:min(1060px, calc(100vw - 48px)) !important;
    height:min(700px, calc(100vh - 48px)) !important;
    max-width:none !important;
    max-height:none !important;
    min-width:0 !important;
    min-height:0 !important;
    display:flex !important;
    flex-direction:row !important;
    overflow:hidden !important;
    box-sizing:border-box !important;
    border-radius:26px !important;
    background:#fff !important;
    box-shadow:0 28px 80px rgba(35,22,29,.34) !important;
}
#productModal.bb-v5-overlay .bb-v5-close{
    position:absolute !important;
    top:15px !important;
    right:15px !important;
    z-index:50 !important;
    width:40px !important;
    height:40px !important;
    min-width:40px !important;
    padding:0 !important;
    border:1px solid #eadfe3 !important;
    border-radius:50% !important;
    background:#fff !important;
    color:#4b343c !important;
    font-size:23px !important;
    line-height:1 !important;
    display:grid !important;
    place-items:center !important;
}
#productModal.bb-v5-overlay .bb-v5-gallery{
    flex:0 0 47% !important;
    width:47% !important;
    height:100% !important;
    min-width:0 !important;
    min-height:0 !important;
    box-sizing:border-box !important;
    display:flex !important;
    flex-direction:column !important;
    padding:24px !important;
    overflow:hidden !important;
    background:linear-gradient(145deg,#fff8fa,#faeef2 62%,#f4e8e5) !important;
}
#productModal.bb-v5-overlay .bb-v5-gallery-label{
    flex:0 0 auto !important;
    padding:2px 3px 13px !important;
    color:#9b6877 !important;
    font-size:9px !important;
    line-height:1 !important;
    letter-spacing:2px !important;
    font-weight:900 !important;
}
#productModal.bb-v5-overlay .bb-v5-image-frame{
    flex:1 1 auto !important;
    width:100% !important;
    height:auto !important;
    min-height:0 !important;
    display:flex !important;
    align-items:center !important;
    justify-content:center !important;
    overflow:hidden !important;
    box-sizing:border-box !important;
    border:1px solid #eadfe3 !important;
    border-radius:18px !important;
    background:#fff !important;
}
#productModal.bb-v5-overlay .bb-v5-main-image{
    display:block !important;
    width:100% !important;
    height:100% !important;
    max-width:100% !important;
    max-height:100% !important;
    padding:20px !important;
    box-sizing:border-box !important;
    object-fit:contain !important;
    object-position:center !important;
}
#productModal.bb-v5-overlay .bb-v5-gallery-footer{
    flex:0 0 70px !important;
    height:70px !important;
    min-height:70px !important;
    display:flex !important;
    align-items:center !important;
    gap:12px !important;
    padding:11px 0 0 !important;
    box-sizing:border-box !important;
}
#productModal.bb-v5-overlay .bb-v5-thumb{
    width:56px !important;
    height:56px !important;
    flex:0 0 56px !important;
    padding:4px !important;
    box-sizing:border-box !important;
    border:1px solid #dfd1d7 !important;
    border-radius:10px !important;
    background:#fff !important;
}
#productModal.bb-v5-overlay .bb-v5-thumb img{
    width:100% !important;
    height:100% !important;
    object-fit:contain !important;
    border-radius:7px !important;
}
#productModal.bb-v5-overlay .bb-v5-gallery-note{
    flex:1 1 auto !important;
    color:#8f7d84 !important;
    font-size:10px !important;
}
#productModal.bb-v5-overlay .bb-v5-swatch{
    flex:0 0 36px !important;
    width:36px !important;
    height:36px !important;
}
#productModal.bb-v5-overlay .bb-v5-details{
    flex:1 1 53% !important;
    width:53% !important;
    height:100% !important;
    min-width:0 !important;
    min-height:0 !important;
    display:grid !important;
    grid-template-rows:minmax(0,1fr) auto !important;
    overflow:hidden !important;
    background:#fff !important;
}
#productModal.bb-v5-overlay .bb-v5-details-scroll{
    min-width:0 !important;
    min-height:0 !important;
    overflow-x:hidden !important;
    overflow-y:auto !important;
    padding:43px 34px 16px !important;
    box-sizing:border-box !important;
}
#productModal.bb-v5-overlay .bb-v5-topline{
    display:flex !important;
    align-items:center !important;
    flex-wrap:wrap !important;
    gap:8px !important;
    margin:0 46px 14px 0 !important;
}
#productModal.bb-v5-overlay .bb-v5-badge{
    min-height:27px !important;
    padding:5px 10px !important;
    box-sizing:border-box !important;
}
#productModal.bb-v5-overlay .bb-v5-favorite{
    min-height:30px !important;
    padding:5px 10px !important;
    white-space:nowrap !important;
}
#productModal.bb-v5-overlay .bb-v5-title{
    margin:0 45px 10px 0 !important;
    font-size:36px !important;
    line-height:1.04 !important;
    letter-spacing:-.025em !important;
}
#productModal.bb-v5-overlay .bb-v5-price{
    margin:0 0 17px !important;
    font-size:29px !important;
}
#productModal.bb-v5-overlay .bb-v5-stock{
    min-height:50px !important;
    margin-bottom:15px !important;
    box-sizing:border-box !important;
}
#productModal.bb-v5-overlay .bb-v5-info-block{
    padding:13px 0 !important;
}
#productModal.bb-v5-overlay .bb-v5-info-block h3{
    margin-bottom:6px !important;
    font-size:12px !important;
}
#productModal.bb-v5-overlay .bb-v5-info-block p{
    font-size:12px !important;
    line-height:1.55 !important;
}
#productModal.bb-v5-overlay .bb-v5-reviews{
    padding-top:13px !important;
}
#productModal.bb-v5-overlay .bb-v5-reviews-head{
    min-height:72px !important;
    padding:10px 12px !important;
}
#productModal.bb-v5-overlay .bb-v5-reviews-head h3{
    font-size:18px !important;
}
#productModal.bb-v5-overlay .bb-v5-reviews-list{
    max-height:100px !important;
}
#productModal.bb-v5-overlay .bb-v5-details .product-modal-review-box{
    margin-top:7px !important;
    padding:10px !important;
}
#productModal.bb-v5-overlay .bb-v5-details .product-review-form textarea{
    min-height:58px !important;
}
#productModal.bb-v5-overlay .bb-v5-purchase{
    width:100% !important;
    box-sizing:border-box !important;
    padding:11px 34px 17px !important;
    border-top:1px solid #eee5e8 !important;
    background:rgba(255,255,255,.98) !important;
    box-shadow:0 -7px 20px rgba(65,39,49,.04) !important;
}
#productModal.bb-v5-overlay .bb-v5-quantity{
    margin-bottom:8px !important;
}
#productModal.bb-v5-overlay .bb-v5-add{
    min-height:48px !important;
    border-radius:12px !important;
}
@media (max-width:760px){
    #productModal.bb-v5-overlay.modal-visible{padding:10px !important;}
    #productModal.bb-v5-overlay .bb-v5-modal{
        width:96vw !important;
        height:94vh !important;
        flex-direction:column !important;
        border-radius:20px !important;
    }
    #productModal.bb-v5-overlay .bb-v5-gallery{
        flex:0 0 300px !important;
        width:100% !important;
        height:300px !important;
        padding:16px !important;
    }
    #productModal.bb-v5-overlay .bb-v5-gallery-label{padding-bottom:8px !important;font-size:8px !important;}
    #productModal.bb-v5-overlay .bb-v5-gallery-footer{flex-basis:50px !important;height:50px !important;min-height:50px !important;}
    #productModal.bb-v5-overlay .bb-v5-thumb{width:42px !important;height:42px !important;flex-basis:42px !important;}
    #productModal.bb-v5-overlay .bb-v5-details{width:100% !important;flex:1 1 auto !important;}
    #productModal.bb-v5-overlay .bb-v5-details-scroll{padding:22px 20px 14px !important;}
    #productModal.bb-v5-overlay .bb-v5-title{font-size:28px !important;}
    #productModal.bb-v5-overlay .bb-v5-price{font-size:25px !important;}
    #productModal.bb-v5-overlay .bb-v5-purchase{padding:10px 20px 14px !important;}
}
</style>
</head>
<body class="catalog-page" data-context-path="${pageContext.request.contextPath}" data-cloudinary-base="<%= cloudinaryBase %>" data-user-email="<%= correoLogin %>" data-logged-in="<%= usuarioLogueado %>" data-favorite-ids="<%= session.getAttribute("favoritos") != null ? session.getAttribute("favoritos") : "[]" %>">
    <%
        java.util.List<Modelo.Producto> productosCatalogo =
                (java.util.List<Modelo.Producto>) request.getAttribute("productosCatalogo");
    %>

    <!-- HEADER SUPERIOR ESTRUCTURADO -->
    <header class="custom-header">
        <div class="header-top-row">
            <div class="header-logo-circle">
                <img src="<%= CloudinaryConfig.BASE_URL %>logo.png" alt="Logo Beauty Boost">
            </div>
            <div class="app-name-oval">
                <h1>BEAUTY BOOST</h1>
            </div>
            <div class="header-right-space"></div>
            <% if (esAdmin) { %>
            <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="admin-store-back" title="Volver al dashboard administrativo">← Volver al dashboard</a>
            <% } %>
        </div>
    </header>

    <!-- NAVBAR HORIZONTAL DE NAVEGACIÓN Y BÚSQUEDA -->
    <nav class="horizontal-navbar">
        <div class="navbar-categories">
            <a href="javascript:void(0)" data-category="todo" class="navbar-link">Todo</a>
            <a href="javascript:void(0)" data-category="maquillaje" class="navbar-link">Maquillaje</a>
            <a href="javascript:void(0)" data-category="cuidado-facial" class="navbar-link">Cuidado Facial</a>
            <a href="javascript:void(0)" data-category="brochas" class="navbar-link">Brochas</a>
            <a href="javascript:void(0)" data-category="novedades" class="navbar-link">Novedades</a>
            <a href="javascript:void(0)" data-category="mas-vendidos" class="navbar-link">Más Vendidos</a>
        </div>
        <div class="navbar-right">
            <div class="input-container">
                <input placeholder="Buscar productos..." class="input" id="txtBuscar" type="text" onkeyup="filtrarProductos()">
                <svg class="icon" viewBox="0 0 24 24">
                    <path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                </svg>
            </div>
            <% if (usuarioLogueado) { %><a href="${pageContext.request.contextPath}/PerfilServlet" class="header-user navbar-user-name" title="Mi Perfil"><span class="header-user-icon">👤</span><strong><%= nombreLogin %></strong></a><% } else { %><a href="${pageContext.request.contextPath}/LoginServlet" class="header-user navbar-user-name login-header-btn">Iniciar Sesión</a><% } %>
            <a href="javascript:void(0);" data-action="cart-access" class="navbar-icon-btn cart-nav-button" title="Carrito" aria-label="Carrito">🛒<span class="cart-count-badge is-empty" data-cart-count>0</span></a>
        </div>
    </nav>

    <!-- CONTENEDOR PRINCIPAL DEL CATÁLOGO -->
    <main class="catalog-container">
        <div class="catalog-subcategory-bar" id="subcategoryBar">
            <label for="subcategoriaFiltro">Maquillaje por categoría</label>
            <select id="subcategoriaFiltro">
                <option value="todo">Todas las subcategorías</option>
                <option value="Rostro - Bases">Rostro · Bases</option>
                <option value="Rostro - Correctores">Rostro · Correctores</option>
                <option value="Rostro - Polvos">Rostro · Polvos</option>
                <option value="Rostro - Rubores">Rostro · Rubores</option>
                <option value="Rostro - Iluminadores">Rostro · Iluminadores</option>
                <option value="Rostro - Contornos">Rostro · Contornos</option>
                <option value="Ojos - Pestañinas">Ojos · Pestañinas</option>
                <option value="Ojos - Sombras">Ojos · Sombras</option>
                <option value="Ojos - Delineadores">Ojos · Delineadores</option>
                <option value="Ojos - Cejas">Ojos · Cejas</option>
                <option value="Labios - Labiales">Labios · Labiales</option>
                <option value="Labios - Gloss">Labios · Gloss</option>
                <option value="Labios - Delineadores">Labios · Delineadores</option>
            </select>
        </div>
        <div class="slider-wrapper-layout">
            <div class="products-grid" id="productGrid"></div>
        </div>
    </main>

    <!-- MODAL DE PRODUCTO · DISEÑO FINAL -->
    <div id="productModal" class="product-modal-overlay bb-v5-overlay" role="dialog" aria-modal="true" aria-labelledby="modalNombre">
        <div class="bb-v5-modal" role="document">
            <button type="button" data-action="close-product-modal" class="bb-v5-close" aria-label="Cerrar detalles">×</button>

            <section class="bb-v5-gallery" aria-label="Galería del producto">
                <div class="bb-v5-gallery-label">BEAUTY BOOST <span>·</span> SELECCIÓN ESPECIAL</div>
                <div class="bb-v5-image-frame">
                    <img id="modalImg" src="<%= cloudinaryBase %>cuidado_facial_serum_de_vitamina_c.png" alt="Producto" class="bb-v5-main-image">
                </div>
                <div class="bb-v5-gallery-footer">
                    <button type="button" class="bb-v5-thumb is-active" data-action="modal-thumb" data-thumb-src="" aria-label="Vista principal">
                        <img id="modalThumb1" src="<%= cloudinaryBase %>cuidado_facial_serum_de_vitamina_c.png" alt="Vista principal">
                    </button>
                    <span class="bb-v5-gallery-note">Vista del producto</span>
                    <span id="modalColorSwatch" class="bb-v5-swatch" aria-hidden="true"></span>
                </div>
            </section>

            <section class="bb-v5-details">
                <div class="bb-v5-details-scroll">
                    <div class="bb-v5-topline">
                        <span id="modalCategoria" class="bb-v5-badge">NOVEDAD</span>
                        <button type="button" id="modalFavoriteButton" data-action="modal-favorite" data-id="0" class="bb-v5-favorite" aria-pressed="false" title="Marcar como favorito">♡ <span>Añadir a favoritos</span></button>
                    </div>

                    <h2 id="modalNombre" class="bb-v5-title"></h2>
                    <div id="modalPrecio" class="bb-v5-price"></div>

                    <div class="bb-v5-stock">
                        <span>Disponibilidad</span>
                        <strong id="modalStock">En existencia</strong>
                    </div>

                    <div class="bb-v5-info-block">
                        <h3>Descripción del producto</h3>
                        <p id="modalDescripcion"></p>
                    </div>
                    <div class="bb-v5-info-block">
                        <h3>Modo de empleo</h3>
                        <p id="modalModoUso"></p>
                    </div>

                    <section class="bb-v5-reviews">
                        <div class="bb-v5-reviews-head">
                            <div>
                                <span class="bb-v5-kicker">EXPERIENCIAS REALES</span>
                                <h3>Reseñas de clientes</h3>
                            </div>
                            <div class="bb-v5-rating">
                                <strong id="modalReviewAverage">0.0</strong>
                                <span id="modalReviewStars">☆☆☆☆☆</span>
                                <small id="modalReviewCount">0 reseñas</small>
                            </div>
                        </div>
                        <div id="modalReviewsList" class="bb-v5-reviews-list"><div class="modal-reviews-loading">Cargando opiniones…</div></div>

                        <div class="product-modal-review-box">
                            <% if (usuarioLogueado) { %>
                            <div class="product-modal-review-box-head">
                                <div class="review-write-icon">✦</div>
                                <div><span class="review-write-kicker">TU EXPERIENCIA</span><strong>¿Ya probaste este producto?</strong><small>Califícalo con estrellas y deja un comentario.</small></div>
                            </div>
                            <form id="productReviewForm" class="product-review-form" onsubmit="publicarResenaDesdeProducto(event)">
                                <input type="hidden" id="productReviewProductId" name="productoId">
                                <div class="review-form-label">Tu calificación</div>
                                <div class="product-review-stars" role="radiogroup" aria-label="Calificación de 1 a 5 estrellas">
                                    <input type="radio" id="productStar5" name="calificacion" value="5"><label for="productStar5" title="5 estrellas">★</label>
                                    <input type="radio" id="productStar4" name="calificacion" value="4"><label for="productStar4" title="4 estrellas">★</label>
                                    <input type="radio" id="productStar3" name="calificacion" value="3"><label for="productStar3" title="3 estrellas">★</label>
                                    <input type="radio" id="productStar2" name="calificacion" value="2"><label for="productStar2" title="2 estrellas">★</label>
                                    <input type="radio" id="productStar1" name="calificacion" value="1"><label for="productStar1" title="1 estrella">★</label>
                                </div>
                                <textarea id="productReviewComment" name="observacion" maxlength="255" placeholder="Cuéntanos qué te pareció…" required></textarea>
                                <div class="review-character-row"><span>Tu comentario será visible para otros clientes.</span><span id="productReviewCounter">0/255</span></div>
                                <div class="product-review-form-footer"><small id="productReviewMessage" aria-live="polite"></small><button type="submit" class="modal-review-submit"><span>Publicar reseña</span><span>→</span></button></div>
                            </form>
                            <% } else { %>
                            <div class="product-modal-review-login"><strong>Inicia sesión para escribir una reseña.</strong><a href="${pageContext.request.contextPath}/LoginServlet">Iniciar sesión →</a></div>
                            <% } %>
                        </div>
                    </section>
                </div>

                <div class="bb-v5-purchase">
                    <div class="bb-v5-quantity">
                        <span>Cantidad</span>
                        <div class="modal-quantity-control">
                            <button type="button" data-action="modal-qty" data-change="-1" class="modal-qty-btn" aria-label="Disminuir cantidad">−</button>
                            <input type="text" id="modalCantidadInput" value="1" readonly aria-label="Cantidad">
                            <button type="button" data-action="modal-qty" data-change="1" class="modal-qty-btn" aria-label="Aumentar cantidad">+</button>
                        </div>
                    </div>
                    <button type="button" data-action="add-modal" class="bb-v5-add"><span>🛒</span> Añadir a la cesta</button>
                </div>
            </section>
        </div>
    </div>

    <!-- MODAL DE ÉXITO CARRITO -->
    <div id="cartSuccessModal" class="success-modal-overlay bb-inline-c91f383c07">
        <div class="bb-inline-0ecafc3766">
            <div class="bb-inline-815b262785">🛍️</div>
            <h3 class="bb-inline-5424676451">¡Producto agregado!</h3>
            <p class="bb-inline-cd9b1cf8f5">El producto se ha añadido correctamente a tu carrito de compras.</p>
            <div class="bb-inline-d5f7d6ccce">
                <button data-action="close-success" class="bb-inline-f34dd080ae">Seguir comprando</button>
                <button data-action="go-cart" class="bb-inline-f83b3aa116">Ver carrito</button>
            </div>
        </div>
    </div>

    <!-- MODAL DE ALERTA -->
    <div id="customAlertModal" class="login-alert-overlay bb-inline-c4da155410">
        <div class="bb-inline-0ecafc3766">
            <div class="bb-inline-5711b60f30">🔒</div>
            <h3 class="bb-inline-5424676451">Iniciar Sesión</h3>
            <p id="customAlertMessage" class="bb-inline-cd9b1cf8f5"></p>
            <button data-action="go-login" class="bb-inline-d6a764f76e">IR A INICIAR SESIÓN</button>
        </div>
    </div>

    <!-- Fallback accesible sin JavaScript: EL/JSTL usa directamente producto.imagenUrl. -->
    <noscript>
        <section class="catalog-container">
            <div class="products-grid">
                <c:forEach var="producto" items="${productosCatalogo}">
                    <article class="product-card">
                        <img src="${producto.imagenUrl}"
                             alt="${producto.nombreProd}"
                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/Vista/img/default.jpg';">
                        <h3>${producto.nombreProd}</h3>
                        <p>${producto.descripcionProd}</p>
                    </article>
                </c:forEach>
            </div>
        </section>
    </noscript>

    <!-- PRODUCTOS DESDE MYSQL: se envían al frontend para render dinámico -->
    <script>
        window.products = [
        <% 
            if (productosCatalogo != null) {
                for (int i = 0; i < productosCatalogo.size(); i++) {
                    Modelo.Producto p = productosCatalogo.get(i);
                    String nombre = p.getNombreProd() == null ? "" : p.getNombreProd();
                    String desc = p.getDescripcionProd() == null ? "" : p.getDescripcionProd();
                    String img = p.getImagenUrl();
                    String subcat = p.getSubcategoriaNombre() == null ? "" : p.getSubcategoriaNombre();
                    subcat = subcat.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", " ").replace("\n", " ");
                    String categoria = p.getCategoriaIdCategoria() == 1 ? "cuidado-facial"
                            : (p.getCategoriaIdCategoria() == 2 ? "maquillaje"
                            : (p.getCategoriaIdCategoria() == 11 ? "brochas"
                            : (p.getCategoriaIdCategoria() == 13 ? "novedades" : "otros")));

                    // Escapado seguro para insertar valores de MySQL dentro de una cadena JS.
                    nombre = nombre.replace("\\", "\\\\").replace("\"", "\\\"")
                            .replace("\r", " ").replace("\n", " ");
                    desc = desc.replace("\\", "\\\\").replace("\"", "\\\"")
                            .replace("\r", " ").replace("\n", " ");
                    img = img.replace("\\", "\\\\").replace("\"", "\\\"")
                            .replace("\r", " ").replace("\n", " ");
        %>
            {id:<%= p.getIdProducto() %>,nombre:"<%= nombre %>",categoria:"<%= categoria %>",categoriaIdCategoria:<%= p.getCategoriaIdCategoria() %>,precio:<%= p.getPrecio() %>,stock:<%= p.getStock() %>,imagen:"<%= img %>",descripcion:"<%= desc %>",badge:"Producto",subcategoriaId:<%=p.getSubcategoriaId()%>,subcategoriaNombre:"<%=subcat%>"}<%= i < productosCatalogo.size() - 1 ? "," : "" %>
        <%      }
            }
        %>
        ];
    </script>
    <script src="${pageContext.request.contextPath}/Vista/js/validaciones.js"></script>
    <script src="${pageContext.request.contextPath}/Vista/js/beauty-boost.js"></script>

<footer class="footer-social-links"><span>Síguenos en Beauty Boost</span><a href="#" aria-label="Instagram oficial">Instagram</a><a href="#" aria-label="Facebook oficial">Facebook</a><a href="#" aria-label="TikTok oficial">TikTok</a></footer>
</body>
</html>