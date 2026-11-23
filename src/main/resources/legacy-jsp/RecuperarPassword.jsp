<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost | Recuperar contraseña</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/css/style.css?v=20260923">
</head>
<body class="recover-page">
    <main class="recover-shell">
        <section class="recover-card">
            <div class="recover-brand">
                <img src="https://res.cloudinary.com/rzxmfg9i/image/upload/v1789523154/logo.png" alt="Beauty Boost">
                <h1>BEAUTY BOOST</h1>
            </div>
            <p class="recover-kicker">Seguridad de tu cuenta</p>
            <h2 class="recover-title">Recuperar Contraseña</h2>
            <p class="recover-desc">Ingresa el correo con el que te registraste y te enviaremos una nueva contraseña temporal.</p>

            <% String mensaje=(String)request.getAttribute("mensaje"); String error=(String)request.getAttribute("error"); %>
            <% if (mensaje != null) { %>
                <div class="recover-success-icon"><i class="fas fa-check"></i></div>
                <div class="recover-alert success"><%= mensaje %></div>
                <a class="btn-recover-submit" style="display:block;text-align:center;text-decoration:none;box-sizing:border-box" href="${pageContext.request.contextPath}/Vista/Login.jsp">IR A INICIAR SESIÓN</a>
                <a class="recover-back" href="${pageContext.request.contextPath}/RecuperarPasswordServlet">Intentar con otro correo</a>
            <% } else { %>
                <% if (error != null) { %>
                    <div class="recover-alert error"><i class="fas fa-circle-exclamation"></i> <%= error %></div>
                <% } %>
                <form action="${pageContext.request.contextPath}/RecuperarPasswordServlet" method="POST" autocomplete="off">
                    <div class="recover-form-group">
                        <label class="recover-label" for="txtCorreo">Correo electrónico</label>
                        <input class="recover-input" id="txtCorreo" type="email" name="txtCorreo" required placeholder="ejemplo@gmail.com">
                    </div>
                    <button class="btn-recover-submit" type="submit"><i class="fas fa-paper-plane"></i> &nbsp;Enviar instrucciones</button>
                </form>
                <div class="recover-help"><i class="fas fa-shield-halved"></i><span>Por seguridad, la nueva contraseña temporal solo se envía al correo que ya está registrado en Beauty Boost.</span></div>
                <a class="recover-back" href="${pageContext.request.contextPath}/Vista/Login.jsp">← Volver a iniciar sesión</a>
            <% } %>
        </section>
    </main>
</body>
</html>
