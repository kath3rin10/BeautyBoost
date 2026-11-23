<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modelo.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="Configuracion.CloudinaryConfig" %>
<%!
    private String esc(Object value) {
        if (value == null) return "";
        return String.valueOf(value).replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    private String imageUrl(String context, Object value) {
        String raw = value == null ? "" : String.valueOf(value).trim();
        if (raw.isEmpty()) return context + "/Vista/img/default.jpg";
        return CloudinaryConfig.toUrl(raw);
    }
%>
<%
    HttpSession currentSession = request.getSession(false);
    Usuario admin = currentSession == null ? null : (Usuario) currentSession.getAttribute("usuarioLogueado");
    if (admin == null || admin.getRolesIdRol() != 1) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login.jsp");
        return;
    }

    List<Map<String,Object>> listaProductos = (List<Map<String,Object>>) request.getAttribute("listaProductos");
    List<Map<String,Object>> listaCategorias = (List<Map<String,Object>>) request.getAttribute("listaCategorias");
    List<Map<String,Object>> listaSubcategorias = (List<Map<String,Object>>) request.getAttribute("listaSubcategorias");
    String mensajeExito = (String) currentSession.getAttribute("mensajeExito");
    String mensajeError = (String) currentSession.getAttribute("mensajeError");
    currentSession.removeAttribute("mensajeExito");
    currentSession.removeAttribute("mensajeError");
    String tituloAdmin = "CATÁLOGO E INVENTARIO";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost | Catálogo e Inventario</title>
    <%@ include file="admin/includes/head.jspf" %>


</head>
<body class="bb-admin-body">
<%@ include file="admin/includes/sidebar.jspf" %>
<main class="bb-main">
    <%@ include file="admin/includes/topbar.jspf" %>
    <section class="bb-content">
        <% if (mensajeExito != null) { %>
            <div class="admin-alert success"><i class="fas fa-circle-check"></i> <%= esc(mensajeExito) %></div>
        <% } %>
        <% if (mensajeError != null) { %>
            <div class="admin-alert error"><i class="fas fa-triangle-exclamation"></i> <%= esc(mensajeError) %></div>
        <% } %>

        <div class="products-toolbar">
            <div class="products-toolbar-copy">
                <span class="eyebrow">CENTRO DE CONTROL</span>
                <h2>Catálogo e inventario</h2>
                <p>Administra productos, stock, categorías e imágenes desde un único panel.</p>
            </div>
            <div class="products-toolbar-actions">
                <div class="category-count"><i class="fas fa-layer-group"></i><span><strong><%= listaCategorias == null ? 0 : listaCategorias.size() %></strong> categorías</span></div>
                <div class="products-quick-actions" aria-label="Acciones rápidas del catálogo">
                    <button class="products-quick-btn quick-category" type="button" data-modal-open="categoriasModal" title="Crear y gestionar categorías">
                        <i class="fas fa-tags"></i><span>Nueva categoría</span>
                    </button>
                    <button class="products-quick-btn quick-product" type="button" data-modal-open="crearProductoModal" title="Agregar un nuevo producto">
                        <i class="fas fa-plus"></i><span>Nuevo producto</span>
                    </button>
                </div>
            </div>
        </div>

        <section class="content-card">
            <div class="card-header">
                <div>
                    <h3>Inventario general</h3>
                    <span><%= listaProductos == null ? 0 : listaProductos.size() %> productos encontrados.</span>
                </div>
            </div>
            <div class="data-table-wrap">
                <table class="data-table admin-products-table">
                    <thead>
                        <tr>
                            <th>Imagen</th><th>ID</th><th>Producto</th><th>Categoría</th>
                            <th>Precio</th><th>Stock</th><th>Estado</th><th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (listaProductos != null && !listaProductos.isEmpty()) {
                        for (Map<String,Object> prod : listaProductos) {
                            int id = prod.get("id") instanceof Number ? ((Number)prod.get("id")).intValue() : 0;
                            int stock = prod.get("stock") instanceof Number ? ((Number)prod.get("stock")).intValue() : 0;
                            double precio = prod.get("precio") instanceof Number ? ((Number)prod.get("precio")).doubleValue() : 0D;
                            int catId = prod.get("idCategoria") instanceof Number ? ((Number)prod.get("idCategoria")).intValue() : 0;
                            int subId = prod.get("subcategoriaId") instanceof Number ? ((Number)prod.get("subcategoriaId")).intValue() : 0;
                            String nombre = prod.get("nombre") == null ? "" : String.valueOf(prod.get("nombre"));
                            String descripcion = prod.get("descripcion") == null ? "" : String.valueOf(prod.get("descripcion"));
                            String categoria = prod.get("nombreCategoria") == null ? "Sin categoría" : String.valueOf(prod.get("nombreCategoria"));
                            String estado = prod.get("estado") == null ? "Activo" : String.valueOf(prod.get("estado"));
                            String img = prod.get("imagen") == null ? "" : String.valueOf(prod.get("imagen"));
                    %>
                        <tr data-searchable data-search-text="<%= esc(nombre) %> <%= esc(categoria) %> #<%= id %>">
                            <td><div class="product-admin-thumb"><img src="<%= imageUrl(request.getContextPath(), img) %>" alt="<%= esc(nombre) %>" onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/Vista/img/default.jpg';"></div></td>
                            <td><strong>#<%= id %></strong></td>
                            <td><div class="product-name-cell"><strong><%= esc(nombre) %></strong><small><%= esc(descripcion.length() > 55 ? descripcion.substring(0,55) + "…" : descripcion) %></small></div></td>
                            <td><%= esc(categoria) %></td>
                            <td class="product-price">$<%= String.format("%,.0f", precio).replace(',', '.') %></td>
                            <td><span class="stock-value <%= stock < 10 ? "stock-low" : "" %>"><%= stock %></span></td>
                            <td><span class="status-badge <%= "Inactivo".equalsIgnoreCase(estado) ? "inactive" : "active" %>"><%= esc(estado) %></span></td>
                            <td>
                                <div class="admin-row-actions">
                                    <button type="button" class="icon-btn product-edit-btn" title="Editar producto" aria-label="Editar producto"
                                        data-modal-open="editarProductoModal"
                                        data-id="<%= id %>"
                                        data-nombre="<%= esc(nombre) %>"
                                        data-descripcion="<%= esc(descripcion) %>"
                                        data-precio="<%= precio %>"
                                        data-stock="<%= stock %>"
                                        data-categoria="<%= catId %>"
                                        data-subcategoria="<%= subId %>"
                                        data-estado="<%= esc(estado) %>"
                                        data-imagen="<%= esc(img) %>">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="icon-btn" title="Ver producto" aria-label="Ver producto"
                                        data-modal-open="verProductoModal"
                                        data-id="<%= id %>"
                                        data-nombre="<%= esc(nombre) %>"
                                        data-descripcion="<%= esc(descripcion) %>"
                                        data-precio="<%= precio %>"
                                        data-stock="<%= stock %>"
                                        data-categoria="<%= esc(categoria) %>"
                                        data-estado="<%= esc(estado) %>"
                                        data-imagen="<%= esc(img) %>">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/AdminProductoServlet" method="POST" onsubmit="return confirm('¿Eliminar este producto? Esta acción no se puede deshacer.');">
                                        <input type="hidden" name="action" value="eliminar">
                                        <input type="hidden" name="idProducto" value="<%= id %>">
                                        <button class="icon-btn danger" type="submit" title="Eliminar producto" aria-label="Eliminar producto"><i class="fas fa-trash-can"></i></button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } } else { %>
                        <tr><td colspan="8" class="empty-admin-state">No hay productos registrados en el inventario.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </section>
</main>

<!-- Modal: gestión de categorías -->
<div class="bb-modal-overlay" id="categoriasModal" hidden>
    <div class="bb-modal-card bb-modal-wide" role="dialog" aria-modal="true" aria-labelledby="categoriasTitulo">
        <div class="bb-modal-head">
            <div><span class="eyebrow">CATÁLOGO</span><h2 id="categoriasTitulo">Gestionar categorías</h2><p class="modal-subtitle">Crea, edita o elimina las categorías utilizadas por los productos.</p></div>
            <button type="button" class="bb-modal-close" data-modal-close aria-label="Cerrar"><i class="fas fa-xmark"></i></button>
        </div>
        <form class="category-create-form" action="${pageContext.request.contextPath}/CategoriaServlet" method="POST">
            <input type="hidden" name="action" value="crear">
            <div class="category-create-copy"><span class="eyebrow">NUEVA CATEGORÍA</span><strong>Añade una categoría al catálogo</strong><small>El nombre quedará disponible para asignarlo a nuevos productos.</small></div>
            <label class="category-create-field"><span>Nombre</span><input class="form-control" type="text" name="nombreCategoria" maxlength="45" required placeholder="Ej. Cuidado facial"></label>
            <button class="btn-admin" type="submit"><i class="fas fa-plus"></i><span>Crear categoría</span></button>
        </form>
        <div class="data-table-wrap">
            <table class="data-table category-table">
                <thead><tr><th>ID</th><th>Nombre</th><th>Acciones</th></tr></thead>
                <tbody>
                <% if (listaCategorias != null && !listaCategorias.isEmpty()) { for (Map<String,Object> c : listaCategorias) { %>
                    <tr>
                        <td>#<%= c.get("id") %></td>
                        <td class="category-name"><%= esc(c.get("nombre")) %></td>
                        <td><div class="category-actions">
                            <button type="button" class="category-text-btn edit" data-category-edit data-id="<%= c.get("id") %>" data-name="<%= esc(c.get("nombre")) %>"><i class="fas fa-pen"></i> Editar</button>
                            <form action="${pageContext.request.contextPath}/CategoriaServlet" method="POST" onsubmit="return confirm('¿Eliminar esta categoría? Si tiene productos o subcategorías relacionadas, la base de datos impedirá la eliminación.');">
                                <input type="hidden" name="action" value="eliminar"><input type="hidden" name="idCategoria" value="<%= c.get("id") %>">
                                <button type="submit" class="category-text-btn delete"><i class="fas fa-trash-can"></i> Eliminar</button>
                            </form>
                        </div></td>
                    </tr>
                <% }} else { %><tr><td colspan="3" class="category-empty">No hay categorías registradas.</td></tr><% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal: editar categoría -->
<div class="bb-modal-overlay" id="editarCategoriaModal" hidden>
    <div class="bb-modal-card" role="dialog" aria-modal="true" aria-labelledby="editarCategoriaTitulo">
        <div class="bb-modal-head"><div><span class="eyebrow">CATÁLOGO</span><h2 id="editarCategoriaTitulo">Editar categoría</h2></div><button type="button" class="bb-modal-close" data-modal-close aria-label="Cerrar"><i class="fas fa-xmark"></i></button></div>
        <form action="${pageContext.request.contextPath}/CategoriaServlet" method="POST">
            <input type="hidden" name="action" value="editar"><input type="hidden" name="idCategoria" id="editCategoriaId">
            <label style="display:flex;flex-direction:column;gap:6px;font-size:10px;font-weight:600;color:#66565b;">Nombre categoría<input class="form-control" type="text" name="nombreCategoria" id="editCategoriaNombre" maxlength="45" required></label>
            <div class="modal-actions"><button type="button" class="btn-secondary" data-modal-close>Cancelar</button><button class="btn-admin" type="submit"><i class="fas fa-save"></i> Guardar cambios</button></div>
        </form>
    </div>
</div>

<!-- Modal: crear -->
<div class="bb-modal-overlay" id="crearProductoModal" hidden>
    <div class="bb-modal-card bb-modal-wide" role="dialog" aria-modal="true" aria-labelledby="crearProductoTitulo">
        <div class="bb-modal-head">
            <div><span class="eyebrow">NUEVO PRODUCTO</span><h2 id="crearProductoTitulo">Agregar producto</h2><p class="modal-subtitle">Completa la información del producto.</p></div>
            <button type="button" class="bb-modal-close" data-modal-close aria-label="Cerrar"><i class="fas fa-xmark"></i></button>
        </div>
        <form action="${pageContext.request.contextPath}/AdminProductoServlet" method="POST" class="admin-create-grid">
            <input type="hidden" name="action" value="crear">
            <label>Nombre producto<input class="form-control" type="text" name="nombre" required maxlength="150"></label>
            <label>Precio (COP)<input class="form-control" type="number" name="precio" min="0" step="0.01" required></label>
            <label>Stock<input class="form-control" type="number" name="stock" min="0" required></label>
            <label>Estado<select class="form-control" name="estado"><option value="Activo">Activo</option><option value="Inactivo">Inactivo</option></select></label>
            <label>Categoría<select class="form-control" name="categoriaId" required><option value="">Seleccione...</option>
                <% if (listaCategorias != null) for (Map<String,Object> c : listaCategorias) { %><option value="<%= c.get("id") %>"><%= esc(c.get("nombre")) %></option><% } %>
            </select></label>
            <label>Subcategoría<select class="form-control" id="crearSubcategoria" name="subcategoriaId"><option value="">Sin subcategoría</option>
                <% if (listaSubcategorias != null) for (Map<String,Object> sc : listaSubcategorias) { %><option value="<%= sc.get("id") %>" data-categoria="<%= sc.get("categoria") %>"><%= esc(sc.get("nombre")) %></option><% } %>
            </select></label>
            <label class="full">Descripción<textarea class="form-control" name="descripcion" rows="4" maxlength="1000" placeholder="Descripción del producto"></textarea></label>
            <label class="full">Imagen de Cloudinary<input class="form-control" type="text" name="imagenUrl" placeholder="nombre-del-archivo.png" required><small>Puedes pegar el nombre del archivo o una URL de Cloudinary. En la BD solo se guarda el nombre/referencia.</small></label>
            <div class="modal-actions full"><button type="button" class="btn-secondary" data-modal-close>Cancelar</button><button class="btn-admin" type="submit"><i class="fas fa-save"></i> Guardar producto</button></div>
        </form>
    </div>
</div>

<!-- Modal: editar -->
<div class="bb-modal-overlay" id="editarProductoModal" hidden>
    <div class="bb-modal-card bb-modal-wide" role="dialog" aria-modal="true" aria-labelledby="editarProductoTitulo">
        <div class="bb-modal-head">
            <div><span class="eyebrow">INVENTARIO</span><h2 id="editarProductoTitulo">Editar producto</h2><p class="modal-subtitle">Actualiza los datos. La imagen se identifica con un nombre/referencia de Cloudinary; también puedes pegar su URL.</p></div>
            <button type="button" class="bb-modal-close" data-modal-close aria-label="Cerrar"><i class="fas fa-xmark"></i></button>
        </div>
        <form id="editarProductoForm" action="${pageContext.request.contextPath}/AdminProductoServlet" method="POST" class="admin-create-grid">
            <input type="hidden" name="action" value="actualizar"><input type="hidden" name="idProducto" id="editIdProducto"><input type="hidden" name="imagenActual" id="editImagenActual">
            <label>Nombre producto<input class="form-control" type="text" name="nombre" id="editNombre" required maxlength="150"></label>
            <label>Precio (COP)<input class="form-control" type="number" name="precio" id="editPrecio" min="0" step="0.01" required></label>
            <label>Stock<input class="form-control" type="number" name="stock" id="editStock" min="0" required></label>
            <label>Estado<select class="form-control" name="estado" id="editEstado"><option value="Activo">Activo</option><option value="Inactivo">Inactivo</option></select></label>
            <label>Categoría<select class="form-control" name="categoriaId" id="editCategoria" required><option value="">Seleccione...</option>
                <% if (listaCategorias != null) for (Map<String,Object> c : listaCategorias) { %><option value="<%= c.get("id") %>"><%= esc(c.get("nombre")) %></option><% } %>
            </select></label>
            <label>Subcategoría<select class="form-control" name="subcategoriaId" id="editSubcategoria"><option value="">Sin subcategoría</option>
                <% if (listaSubcategorias != null) for (Map<String,Object> sc : listaSubcategorias) { %><option value="<%= sc.get("id") %>" data-categoria="<%= sc.get("categoria") %>"><%= esc(sc.get("nombre")) %></option><% } %>
            </select></label>
            <label class="full">Descripción<textarea class="form-control" name="descripcion" id="editDescripcion" rows="4" maxlength="1000"></textarea></label>
            <label class="full">Imagen de Cloudinary<input class="form-control" type="text" name="imagenUrl" id="editImagenUrl" placeholder="nombre-del-archivo.png"><small>Nombre del archivo o URL de Cloudinary. Se guarda únicamente la referencia.</small></label>
            <div class="modal-actions full"><button type="button" class="btn-secondary" data-modal-close>Cancelar</button><button class="btn-admin" type="submit"><i class="fas fa-save"></i> Guardar cambios</button></div>
        </form>
    </div>
</div>

<!-- Modal: ver -->
<div class="bb-modal-overlay" id="verProductoModal" hidden>
    <div class="bb-modal-card bb-modal-wide" role="dialog" aria-modal="true" aria-labelledby="verProductoTitulo">
        <div class="bb-modal-head">
            <div><span class="eyebrow">DETALLE DEL PRODUCTO</span><h2 id="verProductoTitulo">Información</h2></div>
            <button type="button" class="bb-modal-close" data-modal-close aria-label="Cerrar"><i class="fas fa-xmark"></i></button>
        </div>
        <div class="product-view-grid">
            <div class="product-view-image"><img id="viewImagen" src="${pageContext.request.contextPath}/Vista/img/default.jpg" alt="Producto"></div>
            <div class="product-view-info">
                <span class="status-badge active" id="viewEstado">Activo</span>
                <h3 id="viewNombre">Producto</h3>
                <div class="product-view-price" id="viewPrecio">$0</div>
                <div class="product-view-meta">
                    <div><small>ID</small><strong id="viewId">#0</strong></div>
                    <div><small>Stock</small><strong id="viewStock">0</strong></div>
                    <div><small>Categoría</small><strong id="viewCategoria">Sin categoría</strong></div>
                </div>
                <div class="product-description" id="viewDescripcion">Sin descripción registrada.</div>
            </div>
        </div>
        <div class="modal-actions"><button type="button" class="btn-admin" data-modal-close>Cerrar</button></div>
    </div>
</div>

<script>
(function(){
    const ctx = '${pageContext.request.contextPath}';
    const cloudinaryBase = '<%= CloudinaryConfig.BASE_URL %>';
    function imagePath(value){
        const raw = (value || '').trim();
        if (!raw) return ctx + '/Vista/img/default.jpg';
        if (/^https?:\/\//i.test(raw)) return raw;
        const clean = raw.replace(/^\/+/, '').replace(/^(?:Vista\/img\/|img\/)/i, '');
        return cloudinaryBase + clean;
    }
    function filterSubcategories(selectId, categoryId, selected){
        const select=document.getElementById(selectId); if(!select) return;
        Array.from(select.options).forEach(function(opt){
            if(!opt.value){opt.hidden=false;return;}
            const cat=opt.getAttribute('data-categoria'); opt.hidden=!!(categoryId && cat && cat!==String(categoryId));
        });
        if(selected) select.value=String(selected); else if(select.selectedOptions[0] && select.selectedOptions[0].hidden) select.value='';
    }
    document.addEventListener('click',function(e){
        const open=e.target.closest('[data-modal-open]');
        if(!open) return;
        const id=open.getAttribute('data-modal-open'); const modal=document.getElementById(id); if(!modal) return;
        if(id==='editarProductoModal'){
            document.getElementById('editIdProducto').value=open.dataset.id||'';
            document.getElementById('editNombre').value=open.dataset.nombre||'';
            document.getElementById('editDescripcion').value=open.dataset.descripcion||'';
            document.getElementById('editPrecio').value=open.dataset.precio||'';
            document.getElementById('editStock').value=open.dataset.stock||0;
            document.getElementById('editEstado').value=open.dataset.estado||'Activo';
            document.getElementById('editCategoria').value=open.dataset.categoria||'';
            document.getElementById('editImagenActual').value=open.dataset.imagen||'';
            document.getElementById('editImagenUrl').value=open.dataset.imagen||'';
            filterSubcategories('editSubcategoria',open.dataset.categoria||'',open.dataset.subcategoria||'');
        }
        if(id==='verProductoModal'){
            document.getElementById('viewId').textContent='#'+(open.dataset.id||'0');
            document.getElementById('viewNombre').textContent=open.dataset.nombre||'Producto';
            document.getElementById('viewPrecio').textContent='$'+new Intl.NumberFormat('es-CO',{maximumFractionDigits:0}).format(Number(open.dataset.precio||0));
            document.getElementById('viewStock').textContent=open.dataset.stock||'0';
            document.getElementById('viewCategoria').textContent=open.dataset.categoria||'Sin categoría';
            document.getElementById('viewDescripcion').textContent=open.dataset.descripcion||'Sin descripción registrada.';
            const badge=document.getElementById('viewEstado'); const estado=open.dataset.estado||'Activo'; badge.textContent=estado; badge.className='status-badge '+(estado.toLowerCase()==='inactivo'?'inactive':'active');
            document.getElementById('viewImagen').src=imagePath(open.dataset.imagen||'');
        }
        modal.hidden=false; document.body.classList.add('modal-open');
    });
    document.addEventListener('click',function(e){
        if(e.target.closest('[data-modal-close]')){
            const modal=e.target.closest('.bb-modal-overlay'); if(modal){modal.hidden=true;document.body.classList.remove('modal-open');}
        } else if(e.target.classList.contains('bb-modal-overlay')){
            e.target.hidden=true;document.body.classList.remove('modal-open');
        }
    });
    document.addEventListener('keydown',function(e){
        if(e.key==='Escape') document.querySelectorAll('.bb-modal-overlay:not([hidden])').forEach(m=>{m.hidden=true;document.body.classList.remove('modal-open');});
    });
    const createCat=document.querySelector('#crearProductoModal select[name="categoriaId"]');
    if(createCat) createCat.addEventListener('change',()=>filterSubcategories('crearSubcategoria',createCat.value,''));
    const editCat=document.getElementById('editCategoria');
    if(editCat) editCat.addEventListener('change',()=>filterSubcategories('editSubcategoria',editCat.value,''));
    function abrirEditarCategoria(btn){
        const id=document.getElementById('editCategoriaId');
        const nombre=document.getElementById('editCategoriaNombre');
        const modal=document.getElementById('editarCategoriaModal');
        if(!id || !nombre || !modal || !btn) return;
        id.value=btn.getAttribute('data-id') || '';
        nombre.value=btn.getAttribute('data-name') || '';
        modal.hidden=false;
        document.body.classList.add('modal-open');
        window.setTimeout(()=>nombre.focus(),50);
    }
    document.addEventListener('click',function(e){
        const btn=e.target.closest('[data-category-edit]');
        if(!btn) return;
        e.preventDefault();
        e.stopPropagation();
        abrirEditarCategoria(btn);
    });
    if(window.location.hash === '#categorias'){
        const categorias=document.getElementById('categoriasModal');
        if(categorias){ categorias.hidden=false; document.body.classList.add('modal-open'); }
    }
})();
</script>
<%@ include file="admin/includes/footer.jspf" %>
</body>
</html>
