DROP DATABASE IF EXISTS script_beauty_boost;
CREATE DATABASE script_beauty_boost CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE script_beauty_boost;
SET SQL_SAFE_UPDATES = 0;

CREATE TABLE roles (id_rol INT AUTO_INCREMENT PRIMARY KEY, nombre VARCHAR(50) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE tipo_usuario (id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY, nombre_tipo_usuario VARCHAR(45) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE tipo_documento (id_tipo_documento INT AUTO_INCREMENT PRIMARY KEY, descripcion_tipo_documento VARCHAR(45) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE ciudades (id_ciudades INT AUTO_INCREMENT PRIMARY KEY, descripcion_ciudad VARCHAR(45) NOT NULL, codigo_postal VARCHAR(20) NOT NULL) ENGINE=InnoDB;

CREATE TABLE usuario (
 id_usuario INT AUTO_INCREMENT PRIMARY KEY,
 nombre VARCHAR(45) NOT NULL, apellido VARCHAR(45) NOT NULL,
 numero_identificacion VARCHAR(20) NOT NULL UNIQUE,
 telefono VARCHAR(20) NOT NULL, correo VARCHAR(120) NOT NULL UNIQUE,
 clave VARCHAR(255) NOT NULL, fecha_nacimiento DATETIME NOT NULL,
 fecha_vencimiento_clave DATE NOT NULL, autorizacion_datos VARCHAR(45) NOT NULL DEFAULT 'NO',
 estado_usuario VARCHAR(20) NOT NULL DEFAULT 'Activo',
 tipo_documento_id_tipo_documento INT NOT NULL, tipo_usuario_id_tipo_usuario INT NOT NULL,
 roles_id_rol INT NOT NULL DEFAULT 2,
 FOREIGN KEY (tipo_documento_id_tipo_documento) REFERENCES tipo_documento(id_tipo_documento),
 FOREIGN KEY (tipo_usuario_id_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario),
 FOREIGN KEY (roles_id_rol) REFERENCES roles(id_rol)
) ENGINE=InnoDB;

CREATE TABLE direccion_envio (
 id_direccion INT AUTO_INCREMENT PRIMARY KEY, direccion_envio VARCHAR(150) NOT NULL,
 usuario_id_usuario INT NOT NULL, ciudades_id_ciudades INT NOT NULL,
 FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario),
 FOREIGN KEY (ciudades_id_ciudades) REFERENCES ciudades(id_ciudades)
) ENGINE=InnoDB;

CREATE TABLE categoria (id_categoria INT AUTO_INCREMENT PRIMARY KEY, nombre_categoria VARCHAR(80) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE subcategoria (
 id_subcategoria INT AUTO_INCREMENT PRIMARY KEY, nombre_subcategoria VARCHAR(80) NOT NULL,
 categoria_id_categoria INT NOT NULL,
 UNIQUE KEY uq_subcat_cat (nombre_subcategoria,categoria_id_categoria),
 FOREIGN KEY (categoria_id_categoria) REFERENCES categoria(id_categoria) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE producto (
 id_producto INT AUTO_INCREMENT PRIMARY KEY,
 nombre_prod VARCHAR(120) NOT NULL, descripcion_prod VARCHAR(255) NOT NULL,
 precio DECIMAL(12,2) NOT NULL, stock INT NOT NULL DEFAULT 0,
 imagen_url VARCHAR(1000) NULL DEFAULT NULL, estado_producto VARCHAR(20) NOT NULL DEFAULT 'Activo',
 categoria_id_categoria INT NOT NULL, subcategoria_id_subcategoria INT NULL,
 FOREIGN KEY (categoria_id_categoria) REFERENCES categoria(id_categoria),
 FOREIGN KEY (subcategoria_id_subcategoria) REFERENCES subcategoria(id_subcategoria) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE favoritos (
 id_favorito INT AUTO_INCREMENT PRIMARY KEY, usuario_id_usuario INT NOT NULL, producto_id_producto INT NOT NULL,
 fecha_agregado DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY usuario_producto_unique(usuario_id_usuario,producto_id_producto),
 FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
 FOREIGN KEY (producto_id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE resena_usuario (
 id_resena INT AUTO_INCREMENT PRIMARY KEY, observacion VARCHAR(255) NOT NULL, calificacion INT NOT NULL CHECK (calificacion BETWEEN 1 AND 5),
 fecha DATETIME NOT NULL, estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO', usuario_id_usuario INT NOT NULL, producto_id_producto INT NOT NULL,
 FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario),
 FOREIGN KEY (producto_id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE,
 UNIQUE KEY uq_resena_usuario_producto (usuario_id_usuario, producto_id_producto)
) ENGINE=InnoDB;

CREATE TABLE cabeza_carrito (
 id_carrito INT AUTO_INCREMENT PRIMARY KEY, fecha_creacion DATE NOT NULL, fecha_actualizacion DATE NOT NULL,
 usuario_id_usuario INT NULL,
 FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE detalle_carrito (
 id_detalle_carrito INT AUTO_INCREMENT PRIMARY KEY, cantidad INT NOT NULL, descripcion VARCHAR(255) NULL,
 carrito_id_carrito INT NOT NULL, producto_id_producto INT NOT NULL,
 FOREIGN KEY (carrito_id_carrito) REFERENCES cabeza_carrito(id_carrito) ON DELETE CASCADE,
 FOREIGN KEY (producto_id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB;

CREATE TABLE estado_pedido (
 id_estado_pedido INT AUTO_INCREMENT PRIMARY KEY, descripcion_estado VARCHAR(45) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE pedido (
 id_pedido INT AUTO_INCREMENT PRIMARY KEY, fecha_pedido DATE NOT NULL, numero_pedido INT NOT NULL,
 total DECIMAL(12,2) NOT NULL, estado_pedido VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
 usuario_id_usuario INT NOT NULL, direccion_id_direccion INT NULL,
 direccion_entrega VARCHAR(255) NULL, metodo_pago VARCHAR(50) NULL,
 wompi_reference VARCHAR(100) NULL UNIQUE, wompi_status VARCHAR(40) NULL, wompi_transaction_id VARCHAR(120) NULL UNIQUE,
 estado_pedido_id_estado_pedido INT NOT NULL DEFAULT 1,
 FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario),
 FOREIGN KEY (direccion_id_direccion) REFERENCES direccion_envio(id_direccion),
 FOREIGN KEY (estado_pedido_id_estado_pedido) REFERENCES estado_pedido(id_estado_pedido)
) ENGINE=InnoDB;
CREATE TABLE metodo_de_pago (id_metodo_de_pago INT AUTO_INCREMENT PRIMARY KEY, descripcion_metodo_de_pago VARCHAR(45) NOT NULL) ENGINE=InnoDB;
CREATE TABLE pago (
 id_pago INT AUTO_INCREMENT PRIMARY KEY, fecha_pago DATE NOT NULL, monto_pagado DECIMAL(12,2) NOT NULL,
 metodo_de_pago_id_metodo_pago INT NOT NULL, pedido_id_pedido INT NOT NULL,
 wompi_transaction_id VARCHAR(120) NULL UNIQUE, wompi_status VARCHAR(40) NULL,
 FOREIGN KEY (metodo_de_pago_id_metodo_pago) REFERENCES metodo_de_pago(id_metodo_de_pago),
 FOREIGN KEY (pedido_id_pedido) REFERENCES pedido(id_pedido)
) ENGINE=InnoDB;
CREATE TABLE empresas_envio (id_empresa_envio INT AUTO_INCREMENT PRIMARY KEY, nombre_empresa VARCHAR(80) NOT NULL, nit VARCHAR(30) NOT NULL) ENGINE=InnoDB;
CREATE TABLE control_envio (
 id_control INT AUTO_INCREMENT PRIMARY KEY, fecha_entrega DATE NULL, codigo_seguimiento VARCHAR(80) NOT NULL,
 estado_pedido_id_estado_pedido INT NOT NULL, empresas_envio_id_empresa_envio INT NOT NULL, pedido_id_pedido INT NOT NULL,
 FOREIGN KEY (estado_pedido_id_estado_pedido) REFERENCES estado_pedido(id_estado_pedido),
 FOREIGN KEY (empresas_envio_id_empresa_envio) REFERENCES empresas_envio(id_empresa_envio),
 FOREIGN KEY (pedido_id_pedido) REFERENCES pedido(id_pedido)
) ENGINE=InnoDB;
CREATE TABLE datos_recepcion_pedido (
 id_dato_recepcion INT AUTO_INCREMENT PRIMARY KEY, pedido_id_pedido INT NOT NULL UNIQUE,
 nombre_receptor VARCHAR(120) NOT NULL, documento_receptor VARCHAR(30) NOT NULL, telefono_receptor VARCHAR(30) NOT NULL, notas_entrega VARCHAR(500) NULL,
 FOREIGN KEY (pedido_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE detalle_pedido (
 id_detalle_pedido INT AUTO_INCREMENT PRIMARY KEY, cantidad INT NOT NULL,
 precio_unitario DECIMAL(12,2) NOT NULL DEFAULT 0.00, subtotal DECIMAL(12,2) NOT NULL DEFAULT 0.00,
 producto_id_producto INT NOT NULL, pedido_id_pedido INT NOT NULL,
 FOREIGN KEY (producto_id_producto) REFERENCES producto(id_producto),
 FOREIGN KEY (pedido_id_pedido) REFERENCES pedido(id_pedido)
) ENGINE=InnoDB;

INSERT INTO roles VALUES (1,'Administrador'),(2,'Cliente');
INSERT INTO tipo_usuario (nombre_tipo_usuario) VALUES ('Administrador'),('Cliente VIP'),('Cliente Frecuente'),('Cliente Nuevo'),('Soporte'),('Distribuidor'),('Vendedor'),('Gestor de Inventario'),('Invitado'),('Super Admin');
INSERT INTO tipo_documento (descripcion_tipo_documento) VALUES ('Cédula de Ciudadanía'),('Cédula de Extranjería'),('Pasaporte'),('NIT'),('Tarjeta de Identidad'),('Registro Civil'),('Documento Nacional de Identidad'),('Permiso Especial de Permanencia'),('Carné de Extranjería'),('PEP');
INSERT INTO ciudades (descripcion_ciudad,codigo_postal) VALUES ('Bogotá','110111'),('Medellín','050001'),('Cali','760001'),('Barranquilla','080001'),('Cartagena','130001'),('Bucaramanga','680001'),('Pereira','660001'),('Santa Marta','470001'),('Cúcuta','540001'),('Manizales','170001');
INSERT INTO estado_pedido VALUES (1,'Pendiente'),(2,'En camino'),(3,'Entregado');
INSERT INTO metodo_de_pago (descripcion_metodo_de_pago) VALUES ('Tarjeta'),('PSE'),('Wompi'),('Efectivo'),('Efectivo contra entrega');
INSERT INTO empresas_envio (nombre_empresa,nit) VALUES ('Servientrega','800000001'),('Interrapidísimo','800000002');
INSERT INTO categoria (id_categoria,nombre_categoria) VALUES (1,'Cuidado Facial'),(2,'Maquillaje'),(3,'Cuidado Capilar'),(4,'Corporal'),(5,'Fragancias'),(6,'Protección Solar'),(7,'Uñas'),(8,'Herramientas de Belleza'),(9,'Skincare Vegano'),(10,'Accesorios'),(11,'Brochas'),(12,'Mas Vendidos'),(13,'Novedades');
INSERT INTO subcategoria (nombre_subcategoria,categoria_id_categoria) VALUES ('Labios',2),('Rostro',2),('Ojos',2),('Cejas',2),('Bases',2),('Correctores',2),('Cabello',3),('Tratamientos Capilares',3),('Cuerpo',4),('Fragancias Femeninas',5),('Fragancias Masculinas',5),('Protector Solar',6),('Esmaltes',7),('Herramientas',8),('Skincare Vegano',9),('Accesorios',10),('Brochas y Pinceles',11),('Más Vendidos',12),('Novedades',13);

INSERT INTO usuario (nombre,apellido,numero_identificacion,telefono,correo,clave,fecha_nacimiento,fecha_vencimiento_clave,autorizacion_datos,tipo_documento_id_tipo_documento,tipo_usuario_id_tipo_usuario,roles_id_rol) VALUES
('administrador','Beauty Boost','9999999999','3000000000','administrador@beautyboost.com','$2a$12$/KhQXlE8TXDspra6gegYOe95wvYlU74MEn7mmmjRGI3NT8HqCrDay','1990-01-01','2035-12-31','SI',1,1,1),
('cliente','Beauty Boost','8888888888','3100000000','cliente@beautyboost.com','$2a$12$/KhQXlE8TXDspra6gegYOe95wvYlU74MEn7mmmjRGI3NT8HqCrDay','2000-01-01','2035-12-31','SI',1,4,2),
('Sofi','Guzman','3333333333','3200000000','sofi.guzman@beautyboost.com','$2a$12$/KhQXlE8TXDspra6gegYOe95wvYlU74MEn7mmmjRGI3NT8HqCrDay','2001-05-10','2035-12-31','SI',1,4,2);
INSERT INTO direccion_envio (direccion_envio,usuario_id_usuario,ciudades_id_ciudades) VALUES ('Calle 100 # 15-20',1,1),('Carrera 43A # 1-50',2,2),('Calle 72 # 10-15',3,1);

INSERT INTO producto (nombre_prod,descripcion_prod,precio,stock,imagen_url,categoria_id_categoria) VALUES
('Sérum Vitamina C','Sérum iluminador 30ml',85000,50,'cuidado_facial_serum_de_vitamina_c.png',1),
('Agua micelar desmaquillante bifásica','Agua micelar 200ml',32000,40,'cuidado_facial_agua_micelar_desmaquillante_bifasica.png',1),
('Agua termal en spray','Agua termal hidratante',45000,30,'cuidado_facial_agua_termal_en_spray.png',1),
('Crema de noche reparadora','Crema de noche nutitiva',68000,25,'cuidado_facial_crema_de_noche_reparadora.png',1),
('Crema hidratante ligera diaria','Crema facial diaria',52000,50,'cuidado_facial_crema_hidratante_ligera_diaria.png',1),
('Exfoliante químico con AHA','Exfoliante químico suave',59000,35,'cuidado_facial_exfoliante_quimico_con_aha.png',1),
('Gel limpiador espumoso suave','Gel limpiador facial',41000,60,'cuidado_facial_gel_limpiador_espumoso_suave.png',1),
('Tónico Facial','Tónico con ácido hialurónico',55000,45,'cuidado_facial_tonico_facial_hidratante_calmante.png',9),
('Labial Rojo Mate','Labial de larga duración',35000,100,'maquillaje_labial_liquido_mate_fijo.png',2),
('Base líquida matificante','Base mate alta cobertura',45000,50,'maquillaje_base_liquida_matificante.png',2),
('Bronzer compacto opaco','Polvo bronceador',33000,40,'maquillaje_bronzer_compacto_opaco.png',2),
('Contorno oscuro en barra','Contorno en crema',30000,45,'maquillaje_contorno_oscuro_en_barra.png',2),
('Corrector líquido de ojeras','Corrector ojeras',28000,60,'maquillaje_corrector_liquido_de_ojeras.png',2),
('Delineador líquido negro','Delineador ojos mate',24000,50,'maquillaje_delineador_liquido_negro.png',2),
('Gel transparente de cejas','Fijador de cejas',21000,55,'maquillaje_gel_transparente_de_cejas.png',2),
('Iluminador líquido dorado','Iluminador facial',29000,35,'maquillaje_iluminador_liquido_dorado.png',2),
('Lápiz de cejas retráctil','Lápiz para cejas',20000,70,'maquillaje_lapiz_de_cejas_retractil.png',2),
('Máscara de pestañas alargadora','Pestañina negra',31000,80,'maquillaje_mascara_de_pestanas_alargadora.png',2),
('Paleta de sombras neutras','Sombras 12 tonos',62000,30,'maquillaje_paleta_de_sombras_neutras.png',2),
('Polvo traslúcido suelto','Polvo fijador',38000,65,'maquillaje_polvo_traslucido_suelto.png',2),
('Prebase facial alisadora','Primer facial',42000,40,'maquillaje_prebase_facial_alisadora.png',2),
('Rubor en crema rosado','Rubor cremoso',27000,50,'maquillaje_rubor_en_crema_rosado.png',2),
('Borla de felpa para polvos','Borla suave para maquillaje',15000,90,'brochas_borla_de_felpa_para_polvos.png',11),
('Brocha angular para contorno definido','Brocha de contorno',28000,50,'brochas_brocha_angular_para_contorno_definido.png',11),
('Brocha cónica para iluminador preciso','Brocha iluminador',26000,40,'brochas_brocha_conica_para_iluminador_preciso.png',11),
('Brocha grande para polvos sueltos','Brocha polvos',32000,60,'brochas_brocha_grande_para_polvos_sueltos.png',11),
('Brocha kabuki de tope plano','Brocha base',34000,45,'brochas_brocha_kabuki_de_tope_plano.png',11),
('Brocha lengua de gato para base','Brocha clásica base',29000,55,'brochas_brocha_lengua_de_gato_para_base.png',11),
('Brocha mofeta para acabados ligeros','Brocha mofeta',31000,35,'brochas_brocha_mofeta_para_acabados_ligeros.png',11),
('Brocha suave para aplicar rubor','Brocha rubor',27000,50,'brochas_brocha_suave_para_aplicar_rubor.png',11),
('Esponja de maquillaje de gota','Esponja difuminadora',18000,100,'brochas_esponja_de_maquillaje_de_gota.png',11),
('Pincel angular para diseñar cejas','Pincel de cejas',16000,75,'brochas_pincel_angular_para_disenar_cejas.png',11),
('Pincel difuminador ancho para transición','Pincel sombras',19000,80,'brochas_pincel_difuminador_ancho_para_transicion.png',11),
('Pincel fino para delinear ojos','Pincel eyeliner',14000,85,'brochas_pincel_fino_para_delinear_ojos.png',11),
('Pincel plano para aplicar corrector','Pincel corrector',17000,60,'brochas_pincel_plano_para_aplicar_corrector.png',11),
('Pincel plano para depositar sombras','Pincel sombras',16000,65,'brochas_pincel_plano_para_depositar_sombras.png',11),
('Base infusionada con suero antiedad','Base antiedad con suero',65000,30,'novedades_base_infusionada_con_suero_antiedad.png',13),
('Base líquida mate larga duración','Base líquida mate',48000,40,'novedades_base_liquida_mate_larga_duracion.png',13),
('Corrector líquido alta cobertura total','Corrector alta cobertura',32000,50,'novedades_corrector_liquido_alta_cobertura_total.png',13),
('Delineador con sello cat-eye integrado','Delineador cat eye',27000,60,'novedades_delineador_con_sello_cat_eye_integrado.png',13),
('Gel transparente fijación cejas extrema','Gel cejas ultra fijación',25000,45,'novedades_gel_transparente_fijacion_cejas_extrema.png',13),
('Iluminador corporal en gel brillante','Iluminador corporal',39000,35,'novedades_iluminador_corporal_en_gel_brillante.png',13),
('Máscara de pestañas cepillo giratorio','Pestañina innovadora',36000,40,'novedades_mascara_de_pestanas_cepillo_giratorio.png',13),
('Máscara pestañas efecto pestañas postizas','Pestañina volumen',34000,50,'novedades_mascara_pestanas_efecto_pestanas_postizas.png',13),
('Parches con microagujas para arrugas','Parches faciales',45000,25,'novedades_parches_con_microagujas_para_arrugas.png',13),
('Polvo traslúcido fijador universal mate','Polvo mate fijador',39000,55,'novedades_polvo_traslucido_fijador_universal_mate.png',13),
('Protector solar invisible en barra','Protector barra FPS 50',58000,45,'novedades_protector_solar_invisible_en_barra.png',13),
('Rubor inteligente que cambia según pH','Rubor reactivo pH',31000,50,'novedades_rubor_inteligente_que_cambia_segun_ph.png',13),
('Sérum facial en barra hidratante','Sérum barra facial',49000,30,'novedades_serum_facial_en_barra_hidratante.png',13),
('Sombras líquidas duocromáticas','Sombras tornasol',33000,40,'novedades_sombras_liquidas_duocromaticas.png',13),
('Tinta de labios efecto peeling','Tinta duradera labios',26000,60,'novedades_tinta_de_labios_efecto_peeling.png',13);

INSERT INTO cabeza_carrito (fecha_creacion,fecha_actualizacion,usuario_id_usuario) VALUES
('2026-08-01','2026-08-01',1),
('2026-08-02','2026-08-02',2),
('2026-08-03','2026-08-04',3);
INSERT INTO resena_usuario (observacion,calificacion,fecha,usuario_id_usuario,producto_id_producto) VALUES
('Excelente atención y productos',5,'2026-08-01 10:00:00',1,1),
('El envío llegó a tiempo',4,'2026-08-02 11:30:00',2,9),
('Buena relación calidad precio',4,'2026-08-03 14:20:00',3,10);

INSERT INTO pedido (fecha_pedido,numero_pedido,total,estado_pedido,usuario_id_usuario,direccion_id_direccion,direccion_entrega,metodo_pago,estado_pedido_id_estado_pedido) VALUES
('2026-01-15',900001,120000.00,'Entregado',2,2,'Carrera 43A # 1-50, Medellín','Efectivo contra entrega',3),
('2026-02-08',900002,85000.00,'Entregado',3,3,'Calle 72 # 10-15, Bogotá','Efectivo contra entrega',3),
('2026-03-20',900003,152000.00,'En camino',2,2,'Carrera 43A # 1-50, Medellín','Efectivo contra entrega',2),
('2026-04-05',900004,106000.00,'Entregado',3,3,'Calle 72 # 10-15, Bogotá','Efectivo contra entrega',3),
('2026-05-14',900005,172000.00,'Pendiente',2,2,'Carrera 43A # 1-50, Medellín','Efectivo contra entrega',1),
('2026-06-22',900006,90000.00,'Entregado',3,3,'Calle 72 # 10-15, Bogotá','Efectivo contra entrega',3),
('2026-07-10',900007,117000.00,'En camino',2,2,'Carrera 43A # 1-50, Medellín','Efectivo contra entrega',2),
('2026-08-18',900008,150000.00,'Entregado',3,3,'Calle 72 # 10-15, Bogotá','Efectivo contra entrega',3),
('2026-09-09',900009,91000.00,'Pendiente',2,2,'Carrera 43A # 1-50, Medellín','Efectivo contra entrega',1),
('2026-09-20',900010,100000.00,'Entregado',3,3,'Calle 72 # 10-15, Bogotá','Efectivo contra entrega',3);

INSERT INTO detalle_pedido (cantidad,precio_unitario,subtotal,producto_id_producto,pedido_id_pedido)
SELECT 1,85000,85000,1,id_pedido FROM pedido WHERE numero_pedido=900001 UNION ALL
SELECT 1,35000,35000,9,id_pedido FROM pedido WHERE numero_pedido=900001 UNION ALL
SELECT 1,35000,35000,3,id_pedido FROM pedido WHERE numero_pedido=900002 UNION ALL
SELECT 1,21000,21000,15,id_pedido FROM pedido WHERE numero_pedido=900002 UNION ALL
SELECT 1,29000,29000,16,id_pedido FROM pedido WHERE numero_pedido=900002 UNION ALL
SELECT 2,45000,90000,10,id_pedido FROM pedido WHERE numero_pedido=900003 UNION ALL
SELECT 1,62000,62000,19,id_pedido FROM pedido WHERE numero_pedido=900003 UNION ALL
SELECT 1,68000,68000,4,id_pedido FROM pedido WHERE numero_pedido=900004 UNION ALL
SELECT 1,38000,38000,20,id_pedido FROM pedido WHERE numero_pedido=900004 UNION ALL
SELECT 1,85000,85000,1,id_pedido FROM pedido WHERE numero_pedido=900005 UNION ALL
SELECT 1,45000,45000,8,id_pedido FROM pedido WHERE numero_pedido=900005 UNION ALL
SELECT 1,42000,42000,21,id_pedido FROM pedido WHERE numero_pedido=900005 UNION ALL
SELECT 2,28000,56000,13,id_pedido FROM pedido WHERE numero_pedido=900006 UNION ALL
SELECT 1,34000,34000,23,id_pedido FROM pedido WHERE numero_pedido=900006 UNION ALL
SELECT 1,20000,20000,17,id_pedido FROM pedido WHERE numero_pedido=900007 UNION ALL
SELECT 1,62000,62000,19,id_pedido FROM pedido WHERE numero_pedido=900007 UNION ALL
SELECT 1,35000,35000,9,id_pedido FROM pedido WHERE numero_pedido=900007 UNION ALL
SELECT 1,58000,58000,38,id_pedido FROM pedido WHERE numero_pedido=900008 UNION ALL
SELECT 1,32000,32000,22,id_pedido FROM pedido WHERE numero_pedido=900008 UNION ALL
SELECT 1,60000,60000,29,id_pedido FROM pedido WHERE numero_pedido=900008 UNION ALL
SELECT 1,32000,32000,2,id_pedido FROM pedido WHERE numero_pedido=900009 UNION ALL
SELECT 1,59000,59000,6,id_pedido FROM pedido WHERE numero_pedido=900009 UNION ALL
SELECT 1,41000,41000,7,id_pedido FROM pedido WHERE numero_pedido=900010 UNION ALL
SELECT 1,26000,26000,33,id_pedido FROM pedido WHERE numero_pedido=900010 UNION ALL
SELECT 1,33000,33000,11,id_pedido FROM pedido WHERE numero_pedido=900010;

INSERT INTO pago (fecha_pago,monto_pagado,metodo_de_pago_id_metodo_pago,pedido_id_pedido,wompi_status)
SELECT fecha_pedido,total,5,id_pedido,'CONTRAENTREGA' FROM pedido WHERE numero_pedido BETWEEN 900001 AND 900010;

INSERT INTO control_envio (fecha_entrega,codigo_seguimiento,estado_pedido_id_estado_pedido,empresas_envio_id_empresa_envio,pedido_id_pedido)
SELECT CASE WHEN estado_pedido_id_estado_pedido=3 THEN DATE_ADD(fecha_pedido, INTERVAL 3 DAY) ELSE NULL END,
       CONCAT('BB-TEST-',numero_pedido),estado_pedido_id_estado_pedido,
       CASE WHEN MOD(numero_pedido,2)=0 THEN 1 ELSE 2 END,id_pedido
FROM pedido WHERE numero_pedido BETWEEN 900001 AND 900010;

INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Rostro - Bases', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Rostro - Bases' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Rostro - Correctores', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Rostro - Correctores' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Rostro - Polvos', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Rostro - Polvos' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Rostro - Rubores', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Rostro - Rubores' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Rostro - Iluminadores', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Rostro - Iluminadores' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Rostro - Contornos', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Rostro - Contornos' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Ojos - Pestañinas', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Ojos - Pestañinas' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Ojos - Sombras', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Ojos - Sombras' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Ojos - Delineadores', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Ojos - Delineadores' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Ojos - Cejas', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Ojos - Cejas' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Labios - Labiales', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Labios - Labiales' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Labios - Gloss', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Labios - Gloss' AND categoria_id_categoria=2);
INSERT INTO subcategoria (nombre_subcategoria, categoria_id_categoria)
SELECT 'Labios - Delineadores', 2 WHERE NOT EXISTS (SELECT 1 FROM subcategoria WHERE nombre_subcategoria='Labios - Delineadores' AND categoria_id_categoria=2);

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Rostro - Bases' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%base%' OR LOWER(p.descripcion_prod) LIKE '%base%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Rostro - Correctores' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%corrector%' OR LOWER(p.descripcion_prod) LIKE '%corrector%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Rostro - Polvos' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE (LOWER(p.nombre_prod) LIKE '%polvo%' OR LOWER(p.descripcion_prod) LIKE '%polvo%')
  AND LOWER(p.nombre_prod) NOT LIKE '%rubor%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Rostro - Rubores' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%rubor%' OR LOWER(p.descripcion_prod) LIKE '%rubor%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Rostro - Iluminadores' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%iluminador%' OR LOWER(p.descripcion_prod) LIKE '%iluminador%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Rostro - Contornos' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%contorno%' OR LOWER(p.descripcion_prod) LIKE '%contorno%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Ojos - Pestañinas' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%máscara%' OR LOWER(p.nombre_prod) LIKE '%mascara%' OR LOWER(p.descripcion_prod) LIKE '%pestañina%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Ojos - Sombras' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%sombra%' OR LOWER(p.nombre_prod) LIKE '%paleta de sombras%' OR LOWER(p.descripcion_prod) LIKE '%sombras%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Ojos - Delineadores' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%delineador%' OR LOWER(p.descripcion_prod) LIKE '%delineador%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Ojos - Cejas' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%cejas%' OR LOWER(p.descripcion_prod) LIKE '%cejas%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Labios - Labiales' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%labial%' OR LOWER(p.descripcion_prod) LIKE '%labial%';

UPDATE producto p JOIN subcategoria s ON s.nombre_subcategoria='Labios - Gloss' AND s.categoria_id_categoria=2
SET p.subcategoria_id_subcategoria=s.id_subcategoria
WHERE LOWER(p.nombre_prod) LIKE '%gloss%' OR LOWER(p.descripcion_prod) LIKE '%gloss%';

CREATE INDEX idx_producto_categoria ON producto(categoria_id_categoria);
CREATE INDEX idx_producto_subcategoria ON producto(subcategoria_id_subcategoria);
CREATE INDEX idx_usuario_correo ON usuario(correo);

CREATE INDEX idx_pedido_estado ON pedido(estado_pedido_id_estado_pedido);
CREATE INDEX idx_resena_producto ON resena_usuario(producto_id_producto);
