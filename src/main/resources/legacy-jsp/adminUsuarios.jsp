<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modelo.Usuario" %>
<%@ page import="java.util.List" %>
<%
 Usuario admin=(Usuario)session.getAttribute("usuarioLogueado");
 if(admin==null||admin.getRolesIdRol()!=1){response.sendRedirect(request.getContextPath()+"/Vista/Login.jsp");return;}
 List<Usuario> listaUsuarios=(List<Usuario>)request.getAttribute("listaUsuarios");
 String mensajeExito=(String)session.getAttribute("mensajeExito"),mensajeError=(String)session.getAttribute("mensajeError");
 session.removeAttribute("mensajeExito");session.removeAttribute("mensajeError");
 String tituloAdmin="USUARIOS Y ROLES";
%>
<!DOCTYPE html><html lang="es"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Beauty Boost | Usuarios y Roles</title><%@ include file="admin/includes/head.jspf" %></head>
<body class="bb-admin-body">
<%@ include file="admin/includes/sidebar.jspf" %>
<main class="bb-main"><%@ include file="admin/includes/topbar.jspf" %>
<section class="bb-content">
<%if(mensajeExito!=null){%><div class="admin-alert success"><%=mensajeExito%></div><%}%><%if(mensajeError!=null){%><div class="admin-alert error"><%=mensajeError%></div><%}%>
<div class="admin-page-heading admin-users-heading"><div><span class="eyebrow">CENTRO DE CONTROL</span><h1>Usuarios registrados</h1><p>Gestiona datos, roles y estado de las cuentas directamente desde MySQL.</p></div><div class="admin-heading-actions"><button class="btn-admin" type="button" data-modal-open="crearUsuarioModal"><i class="fas fa-user-plus"></i> Agregar usuario</button></div></div>
<section class="content-card"><div class="card-header"><div><h3>Usuarios registrados</h3><span><%=listaUsuarios==null?0:listaUsuarios.size()%> registros encontrados.</span></div></div>
<div class="data-table-wrap"><table class="data-table admin-users-table"><thead><tr><th>ID</th><th>Usuario</th><th>Contacto</th><th>Rol</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>
<%if(listaUsuarios!=null&&!listaUsuarios.isEmpty()){for(Usuario usr:listaUsuarios){String estado=usr.getEstadoUsuario();if(estado==null||estado.isBlank())estado="Activo";%>
<tr data-searchable><td><strong>#<%=usr.getIdUsuario()%></strong></td>
<td><div class="admin-user-cell"><strong><%=usr.getNombre()%> <%=usr.getApellido()%></strong><small><%=usr.getNumeroIdentificacion()==null?"Sin identificación":usr.getNumeroIdentificacion()%></small></div></td>
<td><div class="admin-user-cell"><span><%=usr.getCorreo()%></span><small><%=usr.getTelefono()==null?"Sin teléfono":usr.getTelefono()%></small></div></td>
<td><span><%=usr.getRolesIdRol()==1?"Administrador":"Cliente"%></span></td><td><span class="status-badge <%= "Inactivo".equalsIgnoreCase(estado)?"inactive":"active" %>"><%=estado%></span></td>
<td><div class="admin-row-actions"><button type="button" class="user-action" title="Editar usuario" aria-label="Editar usuario" data-modal-open="editarUsuarioModal" data-id="<%=usr.getIdUsuario()%>" data-nombre="<%=usr.getNombre()==null?"":usr.getNombre()%>" data-apellido="<%=usr.getApellido()==null?"":usr.getApellido()%>" data-correo="<%=usr.getCorreo()==null?"":usr.getCorreo()%>" data-telefono="<%=usr.getTelefono()==null?"":usr.getTelefono()%>" data-documento="<%=usr.getNumeroIdentificacion()==null?"":usr.getNumeroIdentificacion()%>" data-rol="<%=usr.getRolesIdRol()%>" data-estado="<%=estado%>" data-fecha="<%=usr.getFechaNacimiento()!=null?new java.text.SimpleDateFormat("yyyy-MM-dd").format(usr.getFechaNacimiento()):""%>" data-tipo-documento="<%=usr.getTipoDocumentoIdTipoDocumento()%>" data-tipo-usuario="<%=usr.getTipoUsuarioIdTipoUsuario()%>" data-autorizacion="<%=usr.getAutorizacionDatos()==null?"SI":usr.getAutorizacionDatos()%>"><i class="fas fa-pen"></i><span>Editar</span></button>
<a class="user-action" title="Ver perfil" aria-label="Ver perfil" href="${pageContext.request.contextPath}/AdminUsuariosServlet?action=ver&idUsuario=<%=usr.getIdUsuario()%>"><i class="fas fa-eye"></i><span>Ver</span></a>
<form action="${pageContext.request.contextPath}/AdminUsuariosServlet" method="POST" onsubmit="return confirm('¿Eliminar este usuario? Esta acción no se puede deshacer.');"><input type="hidden" name="action" value="eliminar"><input type="hidden" name="idUsuario" value="<%=usr.getIdUsuario()%>"><button class="user-action delete" type="submit" title="Eliminar usuario" aria-label="Eliminar usuario"><i class="fas fa-trash"></i><span>Eliminar</span></button></form></div></td></tr>
<%}}else{%><tr><td colspan="6" class="empty-admin-state">No hay usuarios registrados en la base de datos.</td></tr><%}%>
</tbody></table></div></section>
</section></main>

<div class="bb-modal-overlay" id="crearUsuarioModal" hidden><div class="bb-modal-card"><div class="bb-modal-head"><div><span class="eyebrow">NUEVA CUENTA</span><h2>Agregar usuario</h2><p class="modal-subtitle">Registra todos los datos de la cuenta, incluida la fecha de nacimiento.</p></div><button type="button" class="bb-modal-close" data-modal-close aria-label="Cerrar"><i class="fas fa-xmark"></i></button></div>
<form action="${pageContext.request.contextPath}/AdminUsuariosServlet" method="POST" class="admin-create-grid"><input type="hidden" name="action" value="crear">
<label>Nombre<input class="form-control" name="nombre" required maxlength="80"></label><label>Apellido<input class="form-control" name="apellido" required maxlength="80"></label>
<label>Correo<input class="form-control" type="email" name="correo" required maxlength="120"></label><label>Teléfono<input class="form-control" name="telefono" data-validacion="telefono" inputmode="numeric" pattern="3[0-9]{9}" minlength="10" maxlength="10" autocomplete="tel" title="Celular colombiano: 10 dígitos y comienza por 3" required></label>
<label>Documento / Identificación<input class="form-control" name="identificacion" data-validacion="documento" inputmode="numeric" pattern="[0-9]{6,10}" minlength="6" maxlength="10" autocomplete="off" title="Documento colombiano: entre 6 y 10 dígitos" required></label>
<label>Fecha de nacimiento<input class="form-control" type="date" name="fechaNacimiento" required max="2099-12-31"></label>
<label>Contraseña<input class="form-control" type="password" name="clave" required minlength="8" maxlength="72"></label>
<label>Rol<select class="form-control" name="rolesIdRol" required><option value="2">Cliente</option><option value="1">Administrador</option></select></label>
<div></div><div class="modal-actions"><button type="button" class="btn-secondary" data-modal-close>Cancelar</button><button class="btn-admin" type="submit"><i class="fas fa-user-plus"></i> Crear usuario</button></div>
</form></div></div>

<div class="bb-modal-overlay" id="editarUsuarioModal" hidden><div class="bb-modal-card"><div class="bb-modal-head"><div><span class="eyebrow">GESTIÓN DE CUENTA</span><h2>Editar usuario</h2><p class="modal-subtitle">Actualiza todos los datos administrativos de la cuenta.</p></div><button type="button" class="bb-modal-close" data-modal-close aria-label="Cerrar"><i class="fas fa-xmark"></i></button></div>
<form action="${pageContext.request.contextPath}/AdminUsuariosServlet" method="POST" class="admin-create-grid" id="editarUsuarioForm"><input type="hidden" name="action" value="actualizarUsuarioCompleto"><input type="hidden" name="idUsuario" id="editId">
<label>Nombre<input class="form-control" name="nombre" id="editNombre" required maxlength="80"></label><label>Apellido<input class="form-control" name="apellido" id="editApellido" required maxlength="80"></label>
<label>Correo<input class="form-control" type="email" name="correo" id="editCorreo" required maxlength="120"></label><label>Teléfono<input class="form-control" name="telefono" id="editTelefono" data-validacion="telefono" inputmode="numeric" pattern="3[0-9]{9}" minlength="10" maxlength="10" title="Celular colombiano: 10 dígitos y comienza por 3" required></label>
<label>Documento / Identificación<input class="form-control" name="numeroIdentificacion" id="editDocumento" data-validacion="documento" inputmode="numeric" pattern="[0-9]{6,10}" minlength="6" maxlength="10" title="Documento colombiano: entre 6 y 10 dígitos" required></label>
<label>Fecha de nacimiento<input class="form-control" type="date" name="fechaNacimiento" id="editFecha"></label>
<label>Tipo de documento<select class="form-control" name="tipoDocumento" id="editTipoDocumento"><option value="1">Cédula de Ciudadanía</option><option value="2">Cédula de Extranjería</option><option value="3">Pasaporte</option></select></label>
<label>Tipo de usuario<select class="form-control" name="tipoUsuario" id="editTipoUsuario"><option value="1">Administrador</option><option value="4">Cliente</option></select></label>
<label>Rol<select class="form-control" name="rolesIdRol" id="editRol" required><option value="1">Administrador</option><option value="2">Cliente</option></select></label>
<label>Estado<select class="form-control" name="estadoUsuario" id="editEstado" required><option value="Activo">Activo</option><option value="Inactivo">Inactivo</option></select></label>
<label>Autorización de datos<select class="form-control" name="autorizacionDatos" id="editAutorizacion"><option value="SI">Sí</option><option value="NO">No</option></select></label>
<div class="modal-actions full"><button type="button" class="btn-secondary" data-modal-close>Cancelar</button><button class="btn-admin" type="submit"><i class="fas fa-save"></i> Guardar cambios</button></div></form></div></div>
<script>document.addEventListener('DOMContentLoaded',()=>{document.querySelectorAll('[data-modal-open="editarUsuarioModal"]').forEach(b=>b.addEventListener('click',()=>{const d=b.dataset;[['editId','id'],['editNombre','nombre'],['editApellido','apellido'],['editCorreo','correo'],['editTelefono','telefono'],['editDocumento','documento'],['editFecha','fecha'],['editTipoDocumento','tipoDocumento'],['editTipoUsuario','tipoUsuario'],['editRol','rol'],['editEstado','estado'],['editAutorizacion','autorizacion']].forEach(([id,k])=>{const e=document.getElementById(id);if(e)e.value=d[k]||'';});}));});</script>
<%@ include file="admin/includes/footer.jspf" %>
</body></html>