<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Modelo.Usuario" %>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioLogueado");
    String estado = (String) request.getAttribute("estado");
    String mensaje = (String) request.getAttribute("mensaje");
    boolean pagado = "Pagado".equals(estado);
    String icono = pagado ? "✓" : ("Rechazado".equals(estado) ? "✕" : "…");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost - Resultado del pago</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/css/style.css?v=20260923">
</head>
<body class="catalog-page checkout-body">
    <div class="checkout-confirmation-view" style="text-align:center; padding:60px 20px;">
        <div class="checkout-success-icon"><%= icono %></div>
        <h1 class="checkout-success-title"><%= pagado ? "¡Gracias por tu compra!" : "Estado de tu pago" %></h1>
        <p class="checkout-success-desc"><%= mensaje %></p>
        <p>
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="btn-primary-brown">Seguir comprando</a>
        </p>
    </div>
    <% if (pagado && user != null) { %>
    <script>
        // El pago fue aprobado: se vacia el carrito guardado en el navegador.
        localStorage.removeItem('beautyBoostCart_<%= user.getCorreo() %>');
    </script>
    <% } %>
</body>
</html>
