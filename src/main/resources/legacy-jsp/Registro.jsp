<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String fechaMaximaNacimiento = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()); %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Boost - Crear Cuenta</title>
    <!-- CSS Principal -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/css/style.css">
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
<style>
.login-feedback-success{background:#eaf7ee;color:#176b38;border:1px solid #bfe4cb;padding:10px 12px;border-radius:8px;margin-bottom:15px;font-size:13px;}
.login-feedback-error{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb;padding:10px 12px;border-radius:8px;margin-bottom:15px;font-size:13px;}
#btnCrearCuenta:disabled{opacity:.65;cursor:not-allowed;}
</style>
</head>
<body>

    <!-- HEADER CON BOTÓN VOLVER -->
    <header class="custom-header">
        <div class="header-top-row">
            <a href="${pageContext.request.contextPath}/ProductoServlet" class="btn-back-circle" title="Volver">←</a>
            <div class="app-name-oval">
                <h1>BEAUTY BOOST</h1>
            </div>
            <div style="width: 36px;"></div>
        </div>
    </header>

    <!-- CONTENEDOR DE REGISTRO -->
    <main class="register-container-main">

        <!-- LADO IZQUIERDO: INFORMACIÓN DE BIENVENIDA -->
        <div class="info-card-left">
            <div>
                <span class="welcome-pill">Bienvenida a Beauty Boost</span>
                <h2>Regístrate y descubre un mundo de belleza personalizada</h2>
                <p class="desc">Accede a recomendaciones especiales, ofertas exclusivas y seguimiento fácil de tus pedidos.</p>
            </div>
            <div>
                <div class="feature-box-item">
                    <strong>+50 marcas</strong>
                    <span>Productos seleccionados</span>
                </div>
                <div class="feature-box-item">
                    <strong>Envío rápido</strong>
                    <span>Compras sin complicaciones</span>
                </div>
            </div>
        </div>

        <!-- LADO DERECHO: FORMULARIO SEGÚN BASE DE DATOS -->
        <div class="form-card-right">
            <h2>Crear cuenta</h2>
            <p class="sub">Completa tus datos para empezar a comprar.</p>

            <!-- MENSAJE DE ERROR O ÉXITO SI EXISTE -->
            <%
                String errorMsg = (String) request.getAttribute("error");
                if (errorMsg != null) {
            %>
                <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 6px; margin-bottom: 15px; border: 1px solid #f5c6cb; font-size: 13px;">
                    <%= errorMsg %>
                </div>
            <%
                }
            %>

            <!-- FORMULARIO APUNTANDO AL NUEVO REGISTRO SERVLET CON novalidate -->
            <form id="registroForm" action="${pageContext.request.contextPath}/RegistroServlet" method="POST" novalidate>
                
                <!-- NOMBRES Y APELLIDOS -->
                <div class="form-row-double">
                    <div class="form-group-custom">
                        <label for="txtNombre">Nombres</label>
                        <input type="text" id="txtNombre" name="txtNombre" class="form-control-custom" placeholder="Ingresa tus nombres" oninput="this.value = this.value.replace(/[^A-Za-zÁÉÍÓÚáéíóúñÑ\s]/g, '');">
                        <div id="errorNombre" class="error-message"></div>
                    </div>
                    <div class="form-group-custom">
                        <label for="txtApellido">Apellidos</label>
                        <input type="text" id="txtApellido" name="txtApellido" class="form-control-custom" placeholder="Ingresa tus apellidos" oninput="this.value = this.value.replace(/[^A-Za-zÁÉÍÓÚáéíóúñÑ\s]/g, '');">
                        <div id="errorApellido" class="error-message"></div>
                    </div>
                </div>

                <!-- TIPO Y NÚMERO DE DOCUMENTO -->
                <div class="form-row-double">
                    <div class="form-group-custom">
                        <label for="cboTipoDoc">Tipo de Documento</label>
                        <select id="cboTipoDoc" name="cboTipoDoc" class="form-control-custom">
                            <option value="" disabled selected>Selecciona el documento</option>
                            <option value="1">Cédula de Ciudadanía</option>
                            <option value="2">Cédula de Extranjería</option>
                            <option value="3">Pasaporte</option>
                        </select>
                        <div id="errorTipoDoc" class="error-message"></div>
                    </div>
                    <div class="form-group-custom">
                        <label for="txtIdentificacion">Número de Documento</label>
                        <!-- MODIFICADO: maxlength cambiado a 10 y limitación a 10 dígitos -->
                        <input type="text" id="txtIdentificacion" name="txtIdentificacion" class="form-control-custom" placeholder="Ej. 1098765432" maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10);">
                        <div id="errorIdentificacion" class="error-message"></div>
                    </div>
                </div>

                <!-- TELÉFONO Y FECHA DE NACIMIENTO -->
                <div class="form-row-double">
                    <div class="form-group-custom">
                        <label for="txtTelefono">Teléfono</label>
                        <!-- MODIFICADO: maxlength cambiado a 10 -->
                        <input type="tel" id="txtTelefono" name="txtTelefono" class="form-control-custom" placeholder="Ej. 3158889900" maxlength="10" oninput="this.value = this.value.replace(/[^0-9]/g, '').slice(0, 10);">
                        <div id="errorTelefono" class="error-message"></div>
                    </div>
                    <div class="form-group-custom">
                        <label for="txtFechaNacimiento">Fecha de Nacimiento</label>
                        <!-- max configurado para permitir únicamente mayores de 18 años (evita fecha actual/reciente y menores) -->
                        <input type="date" id="txtFechaNacimiento" name="txtFechaNacimiento" class="form-control-custom" max="<%= fechaMaximaNacimiento %>">
                        <div id="errorFechaNacimiento" class="error-message"></div>
                    </div>
                </div>

                <!-- CORREO ELECTRÓNICO -->
                <div class="form-group-custom">
                    <label for="txtCorreo">Correo electrónico</label>
                    <input type="email" id="txtCorreo" name="txtCorreo" class="form-control-custom" placeholder="ejemplo@gmail.com">
                    <div id="errorCorreo" class="error-message"></div>
                </div>

                <!-- CONTRASEÑA CON EL OJITO -->
                <div class="form-group-custom">
                    <label for="txtClave">Contraseña</label>
                    <div style="position: relative;">
                        <input type="password" id="txtClave" name="txtClave" class="form-control-custom" placeholder="Mínimo 8 caracteres" minlength="8" maxlength="72" autocomplete="new-password" style="padding-right: 40px;">
                        <button type="button" id="togglePasswordBtn" onclick="togglePasswordVisibility()" aria-label="Mostrar contraseña" title="Mostrar contraseña" style="position:absolute; right:8px; top:50%; transform:translateY(-50%); width:32px; height:32px; border:0; background:transparent; color:#6b4b52; cursor:pointer; display:flex; align-items:center; justify-content:center; padding:0;">
                            <svg id="passwordEyeIcon" viewBox="0 0 24 24" width="19" height="19" aria-hidden="true"><path d="M2.2 12s3.5-6 9.8-6 9.8 6 9.8 6-3.5 6-9.8 6-9.8-6-9.8-6Z" fill="none" stroke="currentColor" stroke-width="1.8"/><circle cx="12" cy="12" r="2.7" fill="none" stroke="currentColor" stroke-width="1.8"/></svg>
                        </button>
                    </div>
                    <div id="errorClave" class="error-message"></div>
                </div>

                <!-- AUTORIZACIÓN DE TRATAMIENTO DE DATOS -->
                <div class="form-group-custom">
                    <label class="checkbox-label-custom">
                        <input type="checkbox" name="chkAutorizacion" value="SI" checked>
                        <span>Acepto la autorización y <a href="javascript:void(0);" onclick="openPrivacyModal(event)" style="color: #1f1b1b; font-weight: 700; text-decoration: underline;">tratamiento de datos personales</a>.</span>
                    </label>
                </div>

                <button type="submit" id="btnCrearCuenta" class="btn-submit-account">CREAR CUENTA</button>
            </form>

            <p class="login-redirect-text">
                ¿Ya tienes cuenta? <a href="${pageContext.request.contextPath}/Vista/Login.jsp">Inicia sesión</a>
            </p>
        </div>

    </main>

    <!-- VENTANA MODAL DE POLÍTICAS DE PRIVACIDAD -->
    <div id="privacyModal" class="modal-overlay">
        <div class="modal-content-box">
            <h3>Política de Privacidad y Tratamiento de Datos Personales — Habeas Data</h3>
            <p>Beauty Boost trata los datos personales suministrados por el usuario para gestionar la cuenta, procesar pedidos, coordinar entregas, atender solicitudes, administrar favoritos y mejorar la experiencia de uso de la plataforma.</p>
            <p>El tratamiento se realiza de acuerdo con la normativa colombiana aplicable en materia de protección de datos personales, incluyendo la Ley 1581 de 2012 y sus normas reglamentarias. El titular puede conocer, actualizar, rectificar o solicitar la supresión de sus datos cuando legalmente corresponda, así como consultar el uso dado a su información y presentar las solicitudes relacionadas con sus derechos de Habeas Data.</p>
            <p>La información personal no debe compartirse con terceros ajenos al servicio salvo cuando sea necesario para cumplir la finalidad autorizada, una obligación legal o una orden de autoridad competente. Beauty Boost adopta medidas razonables de seguridad para proteger la información contra acceso, modificación, pérdida o uso no autorizado.</p>
            <button type="button" class="modal-close-btn" onclick="closePrivacyModal()">Entendido</button>
            <div style="clear: both;"></div>
        </div>
    </div>

    <!-- SCRIPTS PARA EL OJITO, MODAL Y VALIDACIÓN ESTÉTICA -->
    <script>
        function togglePasswordVisibility() {
            const inputClave = document.getElementById('txtClave');
            const iconBtn = document.getElementById('togglePasswordBtn');
            const icon = document.getElementById('passwordEyeIcon');
            const visible = inputClave.type === 'password';

            inputClave.type = visible ? 'text' : 'password';
            iconBtn.title = visible ? 'Ocultar contraseña' : 'Mostrar contraseña';
            iconBtn.setAttribute('aria-label', visible ? 'Ocultar contraseña' : 'Mostrar contraseña');
            // Cuando la contraseña está visible se muestra un ojo normal;
            // no usamos el emoji del muñeco que se tapa los ojos.
            icon.innerHTML = visible
                ? '<path d="M2.2 12s3.5-6 9.8-6 9.8 6 9.8 6-3.5 6-9.8 6-9.8-6-9.8-6Z" fill="none" stroke="currentColor" stroke-width="1.8"/><circle cx="12" cy="12" r="2.7" fill="currentColor"/>'
                : '<path d="M3 3l18 18" fill="none" stroke="currentColor" stroke-width="1.8"/><path d="M2.2 12s3.5-6 9.8-6c2 0 3.7.6 5.1 1.5M21.8 12s-1.5 2.6-4.5 4.2c-1.5.8-3.2 1.2-5.3 1.2-6.3 0-9.8-6-9.8-6s1.4-2.4 4.2-4" fill="none" stroke="currentColor" stroke-width="1.8"/>';
        }

        // Funciones para abrir y cerrar el Modal de Políticas de Privacidad
        function openPrivacyModal(event) {
            event.preventDefault(); // Evita que el checkbox cambie de estado al hacer clic en el texto
            document.getElementById('privacyModal').style.display = 'flex';
        }

        function closePrivacyModal() {
            document.getElementById('privacyModal').style.display = 'none';
        }

        // Controlador de validación personalizado para mostrar los avisos limpios debajo de cada input
        document.getElementById('registroForm').addEventListener('submit', function(event) {
            let isValid = true;

            function validateField(inputId, errorId, isEmail = false) {
                const input = document.getElementById(inputId);
                const error = document.getElementById(errorId);
                
                error.style.display = 'none';
                error.textContent = '';
                input.classList.remove('error-input');

                const val = input.value.trim();
                if (val === '') {
                    error.textContent = '⚠ Completa este campo';
                    error.style.display = 'block';
                    input.classList.add('error-input');
                    return false;
                } else if (isEmail && !val.includes('@')) {
                    error.textContent = '⚠ Incluye un signo "@" en la dirección de correo electrónico';
                    error.style.display = 'block';
                    input.classList.add('error-input');
                    return false;
                }
                return true;
            }

            if (!validateField('txtNombre', 'errorNombre')) isValid = false;
            if (!validateField('txtApellido', 'errorApellido')) isValid = false;
            if (!validateField('cboTipoDoc', 'errorTipoDoc')) isValid = false;
            
            if (!validateField('txtIdentificacion', 'errorIdentificacion')) isValid = false;
            const documento = document.getElementById('txtIdentificacion');
            const errorDocumento = document.getElementById('errorIdentificacion');
            
            // MODIFICADO: Validación estricta de exactamente 10 dígitos para el documento con alerta
            if (documento && documento.value.trim().length > 0) {
                if (documento.value.trim().length !== 10) {
                    errorDocumento.textContent = '⚠ Le falta un dígito al número de documento (debe tener exactamente 10 dígitos)';
                    errorDocumento.style.display = 'block';
                    documento.classList.add('error-input');
                    isValid = false;
                }
            }

            if (!validateField('txtTelefono', 'errorTelefono')) isValid = false;
            const telefono = document.getElementById('txtTelefono');
            const errorTelefono = document.getElementById('errorTelefono');
            
            // MODIFICADO: Validación estricta de exactamente 10 dígitos para el teléfono con alerta
            if (telefono && telefono.value.trim().length > 0) {
                if (telefono.value.trim().length !== 10) {
                    errorTelefono.textContent = '⚠ Le falta un dígito al número de celular (debe tener exactamente 10 dígitos)';
                    errorTelefono.style.display = 'block';
                    telefono.classList.add('error-input');
                    isValid = false;
                }
            }
            
            // Validación estricta de Fecha de Nacimiento (Mayor de 18 años / No fecha actual o futura)
            const inputFecha = document.getElementById('txtFechaNacimiento');
            const errorFecha = document.getElementById('errorFechaNacimiento');
            errorFecha.style.display = 'none';
            errorFecha.textContent = '';
            inputFecha.classList.remove('error-input');

            if (inputFecha.value.trim() === '') {
                errorFecha.textContent = '⚠ Completa este campo';
                errorFecha.style.display = 'block';
                inputFecha.classList.add('error-input');
                isValid = false;
            } else {
                const fechaNac = new Date(inputFecha.value);
                const hoy = new Date();
                
                let edad = hoy.getFullYear() - fechaNac.getFullYear();
                const m = hoy.getMonth() - fechaNac.getMonth();
                if (m < 0 || (m === 0 && hoy.getDate() < fechaNac.getDate())) {
                    edad--;
                }

                if (edad < 18) {
                    errorFecha.textContent = '⚠ Debes ser mayor de 18 años para realizar pagos en línea';
                    errorFecha.style.display = 'block';
                    inputFecha.classList.add('error-input');
                    isValid = false;
                }
            }

            if (!validateField('txtCorreo', 'errorCorreo', true)) isValid = false;

            // La contraseña debe tener mínimo 8 caracteres.
            const inputClave = document.getElementById('txtClave');
            const errorClave = document.getElementById('errorClave');
            errorClave.style.display = 'none';
            errorClave.textContent = '';
            inputClave.classList.remove('error-input');
            const clave = inputClave.value.trim();
            if (clave === '') {
                errorClave.textContent = '⚠ Completa este campo';
                errorClave.style.display = 'block';
                inputClave.classList.add('error-input');
                isValid = false;
            } else if (clave.length < 8) {
                errorClave.textContent = '⚠ La contraseña debe tener mínimo 8 caracteres';
                errorClave.style.display = 'block';
                inputClave.classList.add('error-input');
                isValid = false;
            }

            if (!isValid) {
                event.preventDefault(); // Evita el envío si hay campos vacíos o incorrectos
            } else {
                // Evita doble clic y dobles POST que puedan crear la cuenta y luego
                // mostrar erróneamente "correo ya registrado" en la segunda petición.
                const btn = document.getElementById('btnCrearCuenta');
                btn.disabled = true;
                btn.textContent = 'CREANDO CUENTA...';
            }
        });
    </script>

</body>
</html>