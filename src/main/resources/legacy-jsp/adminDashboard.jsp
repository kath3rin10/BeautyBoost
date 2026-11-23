<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modelo.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    Usuario admin = (Usuario) session.getAttribute("usuarioLogueado");
    if (admin == null || admin.getRolesIdRol() != 1) {
        response.sendRedirect(request.getContextPath() + "/Vista/Login.jsp");
        return;
    }
    double ventasTotales = request.getAttribute("ventasTotales") instanceof Number ? ((Number) request.getAttribute("ventasTotales")).doubleValue() : 0D;
    int pedidosPendientes = request.getAttribute("pedidosPendientes") instanceof Number ? ((Number) request.getAttribute("pedidosPendientes")).intValue() : 0;
    int stockBajo = request.getAttribute("stockBajo") instanceof Number ? ((Number) request.getAttribute("stockBajo")).intValue() : 0;
    int clientesRegistrados = request.getAttribute("clientesRegistrados") instanceof Number ? ((Number) request.getAttribute("clientesRegistrados")).intValue() : 0;
    int productosRegistrados = request.getAttribute("productosRegistrados") instanceof Number ? ((Number) request.getAttribute("productosRegistrados")).intValue() : 0;
    List<Number> ventasMensuales = (List<Number>) request.getAttribute("ventasMensuales");
    List<Number> pedidosMensuales = (List<Number>) request.getAttribute("pedidosMensuales");
    List<Map<String,Object>> inventarioDashboard = (List<Map<String,Object>>) request.getAttribute("inventarioDashboard");
    int stockActivo = request.getAttribute("stockActivo") instanceof Number ? ((Number)request.getAttribute("stockActivo")).intValue() : 0;
    int stockBajoCount = request.getAttribute("stockBajoCount") instanceof Number ? ((Number)request.getAttribute("stockBajoCount")).intValue() : 0;
    int stockAgotado = request.getAttribute("stockAgotado") instanceof Number ? ((Number)request.getAttribute("stockAgotado")).intValue() : 0;
    StringBuilder salesJson = new StringBuilder("[");
    StringBuilder ordersJson = new StringBuilder("[");
    for (int i = 0; i < 12; i++) {
        if (i > 0) { salesJson.append(','); ordersJson.append(','); }
        Number salesValue = ventasMensuales != null && i < ventasMensuales.size() && ventasMensuales.get(i) != null ? ventasMensuales.get(i) : 0;
        Number ordersValue = pedidosMensuales != null && i < pedidosMensuales.size() && pedidosMensuales.get(i) != null ? pedidosMensuales.get(i) : 0;
        salesJson.append(salesValue.doubleValue());
        ordersJson.append(ordersValue.intValue());
    }
    salesJson.append(']');
    ordersJson.append(']');
    String inventoryJson = "[" + stockActivo + "," + stockBajoCount + "," + stockAgotado + "]";
    String tituloAdmin = "GERENCIA GENERAL: DASHBOARD UNIFICADO";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost | Dashboard Gerencial</title>
    <%@ include file="admin/includes/head.jspf" %>
</head>
<body class="bb-admin-body dashboard-page">
<%@ include file="admin/includes/sidebar.jspf" %>
<main class="bb-main">
    <%@ include file="admin/includes/topbar.jspf" %>
    <section class="bb-content dashboard-content">
        <section class="bb-kpis" aria-label="Indicadores principales">
            <article class="content-card dashboard-kpi">
                <div class="kpi-icon"><i class="fas fa-sack-dollar"></i></div>
                <div class="kpi-copy"><span>VENTAS TOTALES</span><strong>$<%= String.format("%,.0f", ventasTotales).replace(',', '.') %></strong><small>Acumuladas</small></div>
            </article>
            <article class="content-card dashboard-kpi">
                <div class="kpi-icon"><i class="fas fa-cart-shopping"></i></div>
                <div class="kpi-copy"><span>PEDIDOS PENDIENTES</span><strong><%= pedidosPendientes %></strong><small>Por gestionar</small></div>
            </article>
            <article class="content-card dashboard-kpi">
                <div class="kpi-icon"><i class="fas fa-boxes-stacked"></i></div>
                <div class="kpi-copy"><span>PRODUCTOS EN INVENTARIO</span><strong><%= productosRegistrados %></strong><small>Total de productos registrados</small></div>
            </article>
            <article class="content-card dashboard-kpi">
                <div class="kpi-icon"><i class="fas fa-users"></i></div>
                <div class="kpi-copy"><span>USUARIOS REGISTRADOS</span><strong><%= clientesRegistrados %></strong><small>Cuentas registradas</small></div>
            </article>
        </section>

        <section class="bb-dashboard-charts bb-analytics-stack">
            <section class="bb-panel sales-panel dashboard-sales-panel analytics-sales-card">
                <div class="analytics-card-head">
                    <div class="analytics-title-block">
                        <span class="eyebrow">ANALÍTICA</span>
                        <h2>DESEMPEÑO MENSUAL DE VENTAS</h2>
                        <p>Consulta cuánto ingresó cada mes y detecta con facilidad los picos de facturación.</p>
                    </div>
                    <div class="analytics-period-pill"><i class="fas fa-calendar-days"></i> Año actual</div>
                </div>
                <div id="salesChart" class="dashboard-chart analytics-sales-chart" aria-label="Gráfica de ventas mensuales"></div>
            </section>

            <section class="bb-panel sales-panel dashboard-sales-panel analytics-orders-card">
                <div class="analytics-card-head">
                    <div class="analytics-title-block">
                        <span class="eyebrow">OPERACIÓN</span>
                        <h2>PEDIDOS POR MES</h2>
                        <p>Identifica los meses con mayor carga operativa y controla el comportamiento de los pedidos.</p>
                    </div>
                    <div class="analytics-period-pill"><i class="fas fa-bag-shopping"></i> Actividad mensual</div>
                </div>
                <div id="ordersChart" class="dashboard-chart analytics-orders-chart" aria-label="Pedidos creados por mes"></div>
            </section>
        </section>

        <section class="bb-panel sales-panel dashboard-stock-panel">
            <div class="sales-panel-head">
                <div>
                    <span class="eyebrow">INVENTARIO</span>
                    <h2>ESTADO DEL INVENTARIO</h2>
                    <p>Distribución actual de productos según sus existencias.</p>
                </div>
            </div>
            <div id="inventoryChart" class="dashboard-inventory-chart" aria-label="Estado del inventario"></div>
        </section>

        <section class="bb-panel dashboard-inventory-panel">
            <div class="sales-panel-head dashboard-section-head">
                <div>
                    <span class="eyebrow">CONTROL DE INVENTARIO</span>
                    <h2>INVENTARIO ACTUAL</h2>
                    <p>Resumen de productos y existencias disponibles.</p>
                </div>
                <a class="btn-admin btn-admin-compact" href="${pageContext.request.contextPath}/AdminProductoServlet"><i class="fas fa-boxes-stacked"></i> Ver inventario</a>
            </div>
            <div class="data-table-wrap dashboard-inventory-wrap">
                <table class="data-table dashboard-inventory-table">
                    <thead><tr><th>ID</th><th>Producto</th><th>Categoría</th><th>Stock</th><th>Estado</th></tr></thead>
                    <tbody>
                    <% if (inventarioDashboard != null && !inventarioDashboard.isEmpty()) {
                        for (Map<String,Object> prod : inventarioDashboard) {
                            int id = prod.get("id") instanceof Number ? ((Number)prod.get("id")).intValue() : 0;
                            int stock = prod.get("stock") instanceof Number ? ((Number)prod.get("stock")).intValue() : 0;
                            String nombre = prod.get("nombre") == null ? "" : String.valueOf(prod.get("nombre"));
                            String categoria = prod.get("categoria") == null ? "Sin categoría" : String.valueOf(prod.get("categoria"));
                            String estado = prod.get("estado") == null ? (stock > 0 ? "Activo" : "Agotado") : String.valueOf(prod.get("estado"));
                            String stockClass = stock <= 0 ? "inventory-danger" : (stock < 10 ? "inventory-warning" : "inventory-ok");
                    %>
                        <tr><td>#<%=id%></td><td class="inventory-product-name"><%=nombre%></td><td><%=categoria%></td><td><span class="inventory-stock <%=stockClass%>"><%=stock%></span></td><td><span class="status-badge <%=stock<=0?"inactive":"active"%>"><%=estado%></span></td></tr>
                    <% } } else { %>
                        <tr><td colspan="5" class="empty-admin-state">No hay productos para mostrar.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </section>
</main>
<script>window.BB_ADMIN={sales:<%= salesJson.toString() %>,orders:<%= ordersJson.toString() %>,inventory:<%= inventoryJson %>};</script>
<script src="${pageContext.request.contextPath}/Vista/js/admin-dashboard-analytics.js?v=20261001-analytics"></script>
<%@ include file="admin/includes/footer.jspf" %>
</body>
</html>
