<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost - Iniciar Sesión</title>
    <!-- Rutas dinámicas para CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Oculta el ícono nativo de mostrar contraseña que traen por defecto los navegadores */
        input[type="password"]::-ms-reveal,
        input[type="password"]::-ms-clear {
            display: none;
        }
        input[type="password"]::-webkit-password-reveal-button {
            display: none !important;
        }
    </style>
</head>
<body>

    <header class="custom-header">
        <div class="header-top-row">
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="btn-back-circle" title="Volver">←</a>
            <div class="app-name-oval"><h1>BEAUTY BOOST</h1></div>
            <div style="width: 36px;"></div>
        </div>
    </header>

    <!-- CONTENEDOR PRINCIPAL DE LOGIN -->
    <main class="login-container-main">

        <!-- LADO IZQUIERDO: MENSAJE BIENVENIDA Y FRASE DE LA MARCA -->
        <div class="info-card-left">
            <div>
                <span class="welcome-pill">✦ Bienvenida de nuevo</span>
                <h2>Realza tu belleza única con cada detalle</h2>
                <p class="desc">Inicia sesión para acceder a tus favoritos guardados, realizar compras rápidas y descubrir colecciones diseñadas exclusivamente para ti.</p>
            </div>
            <div>
                <div class="feature-box-item">
                    <strong>Tu espacio de cuidado</strong>
                    <span>Gestiona tus pedidos y lista de deseos al instante.</span>
                </div>
            </div>
        </div>

        <!-- LADO DERECHO: FORMULARIO DE ACCESO -->
        <div class="form-card-right">
            <h2 style="font-family: 'Playfair Display', serif; font-size: 26px; color: #1f1b1b; margin-top: 0; margin-bottom: 5px;">Iniciar Sesión</h2>
            <p style="color: #777; font-size: 13px; margin-bottom: 20px;">Ingresa tus credenciales de acceso</p>

            <!-- MENSAJES DEL SERVIDOR: ÉXITO EN VERDE / ERROR EN ROJO -->
            <%
                String successMsg = (String) request.getAttribute("success");
                if (successMsg == null) {
                    successMsg = (String) session.getAttribute("registroExitoso");
                    if (successMsg != null) session.removeAttribute("registroExitoso");
                }
                String errorMsg = (String) request.getAttribute("error");
                
                // Si viene un mensaje de éxito o si el error contiene la palabra "éxito", lo tratamos como éxito (verde)
                if ((successMsg != null && !successMsg.trim().isEmpty()) || (errorMsg != null && errorMsg.toLowerCase().contains("éxito"))) {
                    String mensajeVerde = (successMsg != null && !successMsg.trim().isEmpty()) ? successMsg : errorMsg;
            %>
                <div class="login-feedback-success" role="status" aria-live="polite" style="background-color: #eaf7ee; color: #176b38; padding: 10px 12px; border-radius: 8px; margin-bottom: 15px; border: 1px solid #bfe4cb; font-size: 13px;">
                    <i class="fas fa-circle-check" aria-hidden="true"></i>
                    <span><%= mensajeVerde %></span>
                </div>
            <%
                } else if (errorMsg != null && !errorMsg.trim().isEmpty()) {
            %>
                <div class="alert-danger login-feedback-error" role="alert" aria-live="polite">
                    <i class="fas fa-circle-exclamation" aria-hidden="true"></i>
                    <span><%= errorMsg %></span>
                </div>
            <%
                }
            %>

            <!-- Formulario apuntando hacia LoginServlet con novalidate para evitar alertas nativas -->
            <form id="loginForm" action="${pageContext.request.contextPath}/LoginServlet" method="POST" novalidate>
                <div class="form-group" style="margin-bottom: 15px;">
                    <label for="txtCorreo" style="display: block; font-size: 12px; font-weight: 600; color: #333; margin-bottom: 5px;">Gmail</label>
                    <input type="email" id="txtCorreo" name="txtCorreo" class="form-control" placeholder="usuario@gmail.com" style="width: 100%; padding: 10px 12px; border: 1px solid #eaeaea; border-radius: 8px; font-size: 13px; box-sizing: border-box; outline: none;">
                    <div id="errorCorreo" class="error-message"></div>
                </div>

                <!-- CONTRASEÑA CON EL OJITO INTEGRADO -->
                <div class="form-group" style="margin-bottom: 15px;">
                    <label for="txtPassword" style="display: block; font-size: 12px; font-weight: 600; color: #333; margin-bottom: 5px;">Contraseña</label>
                    <div style="position: relative;">
                        <input type="password" id="txtPassword" name="txtPassword" class="form-control" placeholder="••••••••" style="width: 100%; padding: 10px 40px 10px 12px; border: 1px solid #eaeaea; border-radius: 8px; font-size: 13px; box-sizing: border-box; outline: none;">
                        <button type="button" id="togglePasswordBtn" onclick="togglePasswordVisibility()" aria-label="Mostrar contraseña" title="Mostrar contraseña" style="position:absolute; right:8px; top:50%; transform:translateY(-50%); width:32px; height:32px; border:0; background:transparent; color:#6b4b52; cursor:pointer; display:flex; align-items:center; justify-content:center; padding:0;">
                            <svg id="passwordEyeIcon" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><path d="M2.2 12s3.5-6 9.8-6 9.8 6 9.8 6-3.5 6-9.8 6-9.8-6-9.8-6Z" fill="none" stroke="currentColor" stroke-width="1.8"/><circle cx="12" cy="12" r="2.7" fill="none" stroke="currentColor" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                    <div id="errorPassword" class="error-message"></div>
                </div>
                
                <div style="margin-bottom: 20px;">
                    <a href="${pageContext.request.contextPath}/RecuperarPasswordServlet" class="forgot-password-link" style="font-size: 12px; color: #d87d6a; text-decoration: none; font-weight: 600;">¿Olvidaste tu contraseña?</a>
                </div>
                
                <button type="submit" class="btn-primary" style="width:100%; background: #e2beaf; color: #2b2b2b; border: none; padding: 12px; border-radius: 10px; font-weight: 700; cursor: pointer; letter-spacing: 1px; font-size: 13px;">ENTRAR</button>

                <!-- APARTADO PARA REGISTRARSE -->
                <p style="text-align: center; font-size: 13px; color: #666; margin-top: 20px;">
                    ¿No tienes una cuenta? 
                    <a href="${pageContext.request.contextPath}/Vista/Registro.jsp" style="color: #1f1b1b; font-weight: 700; text-decoration: none;">Regístrate aquí</a>
                </p>
            </form>
        </div>

    </main>

    <!-- SCRIPTS PARA EL OJITO Y VALIDACIÓN ESTÉTICA -->
    <script>
        function togglePasswordVisibility() {
            const inputPassword = document.getElementById('txtPassword');
            const iconBtn = document.getElementById('togglePasswordBtn');
            const icon = document.getElementById('passwordEyeIcon');
            const visible = inputPassword.type === 'password';

            inputPassword.type = visible ? 'text' : 'password';
            iconBtn.title = visible ? 'Ocultar contraseña' : 'Mostrar contraseña';
            iconBtn.setAttribute('aria-label', visible ? 'Ocultar contraseña' : 'Mostrar contraseña');
            icon.innerHTML = visible
                ? '<path d="M2.2 12s3.5-6 9.8-6 9.8 6 9.8 6-3.5 6-9.8 6-9.8-6-9.8-6Z" fill="none" stroke="currentColor" stroke-width="1.8"/><circle cx="12" cy="12" r="2.7" fill="currentColor"/>'
                : '<path d="M3 3l18 18" fill="none" stroke="currentColor" stroke-width="1.8"/><path d="M2.2 12s3.5-6 9.8-6c2 0 3.7.6 5.1 1.5M21.8 12s-1.5 2.6-4.5 4.2c-1.5.8-3.2 1.2-5.3 1.2-6.3 0-9.8-6-9.8-6s1.4-2.4 4.2-4" fill="none" stroke="currentColor" stroke-width="1.8"/>';
        }

        // Controlador de validación personalizado para mostrar los avisos limpios debajo de los inputs
        document.getElementById('loginForm').addEventListener('submit', function(event) {
            let isValid = true;

            const inputCorreo = document.getElementById('txtCorreo');
            const errorCorreo = document.getElementById('errorCorreo');
            
            const inputPassword = document.getElementById('txtPassword');
            const errorPassword = document.getElementById('errorPassword');

            // Limpiar estados previos
            errorCorreo.style.display = 'none';
            errorCorreo.textContent = '';
            inputCorreo.classList.remove('error-input');

            errorPassword.style.display = 'none';
            errorPassword.textContent = '';
            inputPassword.classList.remove('error-input');

            // Validación de correo
            const valorCorreo = inputCorreo.value.trim();
            if (valorCorreo === '') {
                errorCorreo.textContent = '⚠ Completa este campo';
                errorCorreo.style.display = 'block';
                inputCorreo.classList.add('error-input');
                isValid = false;
            } else if (!valorCorreo.includes('@')) {
                errorCorreo.textContent = '⚠ Incluye un signo "@" en la dirección de correo electrónico';
                errorCorreo.style.display = 'block';
                inputCorreo.classList.add('error-input');
                isValid = false;
            }

            // Validación de contraseña
            if (inputPassword.value.trim() === '') {
                errorPassword.textContent = '⚠ Completa este campo';
                errorPassword.style.display = 'block';
                inputPassword.classList.add('error-input');
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault(); // Evita el envío si hay campos vacíos o incorrectos
            }
        });
    </script>

</body>
</html>