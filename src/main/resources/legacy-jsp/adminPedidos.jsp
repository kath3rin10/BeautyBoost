<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modelo.Usuario" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<% Usuario admin=(Usuario)session.getAttribute("usuarioLogueado"); if(admin==null||admin.getRolesIdRol()!=1){response.sendRedirect(request.getContextPath()+"/Vista/Login.jsp");return;} List<Map<String,Object>> listaPedidos=(List<Map<String,Object>>)request.getAttribute("listaPedidos"); String mensajeExito=(String)session.getAttribute("mensajeExito"); session.removeAttribute("mensajeExito"); String tituloAdmin="GESTIÓN DE PEDIDOS";%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><title>Beauty Boost | Gestión de Pedidos</title><%@ include file="admin/includes/head.jspf" %></head><body class="bb-admin-body"><%@ include file="admin/includes/sidebar.jspf" %><main class="bb-main"><%@ include file="admin/includes/topbar.jspf" %><section class="bb-content">

        <% if (mensajeExito != null) { %>
            <div class="alert-success"><%= mensajeExito %></div>
        <% } %>

        <div class="admin-page-heading"><div><span class="eyebrow">CENTRO DE CONTROL</span><h1>Gestión de pedidos</h1><p>Consulta pedidos y actualiza sus estados de forma segura.</p></div></div>

        <div class="content-card">
            <div class="card-header">
                <h3>Listado General de Pedidos y Envíos</h3>
                <span class="bb-inline-ccdca83d16">Actualice el estado de los pedidos de forma interactiva</span>
            </div>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID Pedido</th>
                        <th>Fecha</th>
                        <th>Cliente</th>
                        <th>Total (COP)</th>
                        <th>Transportadora</th>
                        <th>Guía de Envíos</th>
                        <th>Estado Actual</th>
                        <th>Cambiar Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (listaPedidos != null && !listaPedidos.isEmpty()) {
                        for (Map<String, Object> ped : listaPedidos) {
                            double totalVal = (Double) ped.get("total");
                            String totalFormateado = String.format("%,.0f", totalVal).replace(",", ".");
                            int estadoId = ped.get("idEstado") != null ? (Integer) ped.get("idEstado") : 1;
                    %>
                        <tr>
                            <td><strong>#<%= ped.get("idPedido") %></strong></td>
                            <td><%= ped.get("fecha") %></td>
                            <td><%= ped.get("cliente") %></td>
                            <td>$ <%= totalFormateado %></td>
                            <td><%= ped.get("empresaEnvio") != null ? ped.get("empresaEnvio") : "Sin asignar" %></td>
                            <td><%= ped.get("codigoSeguimiento") != null ? ped.get("codigoSeguimiento") : "N/A" %></td>
                            <td><span class="bb-inline-90038280ae order-status-badge" data-pedido-id="<%= ped.get("idPedido") %>"><%= ped.get("estado") %></span></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/AdminPedidoServlet" method="POST" class="bb-inline-3a8ee43064 order-status-form" data-pedido-id="<%= ped.get("idPedido") %>">
                                    <input type="hidden" name="action" value="actualizarEstado">
                                    <input type="hidden" name="idPedido" value="<%= ped.get("idPedido") %>">
                                    <select name="nuevoEstadoId" class="form-control order-status-select" onchange="actualizarEstadoPedido(this)" required>
                                        <option value="1" <%= estadoId == 1 ? "selected" : "" %>>Pendiente</option>
                                        <option value="2" <%= estadoId == 2 ? "selected" : "" %>>En camino</option>
                                        <option value="3" <%= estadoId == 3 ? "selected" : "" %>>Entregado</option>
                                    </select>
                                    <span class="order-status-saving" aria-live="polite"></span>
                                </form>
                            </td>
                        </tr>
                    <%  }
                    } else { %>
                        <tr>
                            <td colspan="8" class="bb-inline-6c9cd9926d">No hay pedidos registrados en el sistema.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

</section></main><%@ include file="admin/includes/footer.jspf" %>
<script>
async function actualizarEstadoPedido(select){
    const form=select.closest('form'); if(!form)return;
    const previo=select.dataset.previous || select.value;
    select.dataset.previous=select.value;
    select.disabled=true;
    const saving=form.querySelector('.order-status-saving');
    if(saving) saving.textContent='Guardando…';
    const params=new URLSearchParams(new FormData(form));
    params.set('ajax','true');
    try{
        const r=await fetch(form.action,{method:'POST',headers:{'X-Requested-With':'XMLHttpRequest','Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},body:params,credentials:'same-origin'});
        const d=await r.json();
        if(!r.ok || d.status!=='success') throw new Error(d.message||'No fue posible actualizar el estado.');
        const badge=document.querySelector('.order-status-badge[data-pedido-id="'+form.dataset.pedidoId+'"]');
        if(badge) badge.textContent=d.estado;
        if(saving) { saving.textContent='✓ Actualizado'; setTimeout(()=>saving.textContent='',1800); }
    }catch(e){
        select.value=previo;
        if(saving) { saving.textContent='No se pudo guardar'; setTimeout(()=>saving.textContent='',2200); }
        alert(e.message||'No fue posible actualizar el estado.');
    }finally{ select.disabled=false; }
}
</script>
</body></html>