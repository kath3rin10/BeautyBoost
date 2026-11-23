(function () {
    'use strict';

    const body = document.body;
    const contextPath = body ? (body.dataset.contextPath || '') : '';
    const userEmail = body ? (body.dataset.userEmail || '') : '';
    const usuarioLogueado = body ? body.dataset.loggedIn === 'true' : false;
    const cloudinaryBase = body ? (body.dataset.cloudinaryBase || '') : '';
    window.contextPath = contextPath;

    function safeJSON(key) {
        try { return JSON.parse(localStorage.getItem(key)) || []; } catch (e) { return []; }
    }
    function cartKey() { return 'beautyBoostCart_' + (userEmail || 'invitado'); }
    function favKey() { return 'beautyBoostFavs_' + (userEmail || 'invitado'); }
    function money(value) { return '$' + Number(value || 0).toLocaleString('es-CO'); }
    function escaparHTML(value) {
        return String(value == null ? '' : value)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/\"/g, '&quot;')
            .replace(/'/g, '&#039;');
    }
    function showModal(id) { const el=document.getElementById(id); if(el){el.hidden=false;el.classList.add('modal-visible');} }
    function hideModal(id) { const el=document.getElementById(id); if(el){el.classList.remove('modal-visible');el.hidden=true;} }
    function showInlineMessage(message) {
        let box=document.getElementById('bbInlineMessage');
        if(!box){ box=document.createElement('div'); box.id='bbInlineMessage'; box.className='form-validation-error'; document.body.prepend(box); }
        box.textContent=message; box.scrollIntoView({behavior:'smooth',block:'center'});
    }

    /* ==================== CATÁLOGO ==================== */
    const IMAGENES_PRODUCTO = {
        'base hidratante': 'base_hidratante.png',
        'base natural': 'base_natural.png',
        'Base Fluida HD': 'Base_Fluida_HD.png',
        'Base Matte Pro': 'BaseMattePro.png',
        'Bronzer Bronze Sun': 'bronzer_bronze_sun.png',
        'Bronzer Sun Kiss': 'bronzer_sun_kiss.png',
        'Contorno Stick Pro': 'contorno_stick_pro.png',
        'Corrector Bright Touch': 'corrector_bright_touch.png',
        'Corrector Full Cover': 'corrector_full_cover.png',
        'Corrector Perfect Skin': 'corrector_perfect_skin.png',
        'Delineador Black Pro': 'Delineador_Black_Pro.png',
        'Delineador Liquid Pro': 'Delineador_Liquid_Pro.png',
        'Delineador Pencil Black': 'Delineador_Pencil_Black.png',
        'Gel Brow Fix': 'Gel_Brow_Fix.png',
        'Gel Fijador de Cejas': 'gel_fijador_de_cejas.png',
        'Iluminador Golden Glow': 'iluminador_golden_glow.png',
        'Iluminador Rose Light': 'iluminador_rose_light.png',
        'Iluminador Shine Gold': 'iluminador_shine_gold.png',
        'Lápiz para Cejas Brow Define': 'Lapiz_para_Cejas_Brow_Define.png',
        'Brow Pencil Define': 'Brow_Pencil_Define.png',
        'Labial Matte Chic': 'Labial_Matte_Chic.png',
        'Labial Nude Soft': 'Labial_Nude_Soft.png',
        'Labial Red Passion': 'Labial_Red_Passion.png',
        'Labial Velvet': 'Labial_Velvet.png',
        'Labial Nude': 'Labial_Nude.png',
        'Lip Gloss Crystal': 'Lip_Gloss_Crystal.png',
        'Lip Gloss Shine': 'Lip_Gloss_Shine.png',
        'Lip Tint Natural': 'Lip_Tint_Natural.png',
        'Máscara Mega Volume': 'Mascara_Mega_Volume.png',
        'Mascara Mega Volume': 'Mascara_Mega_Volume.png',
        'Máscara Waterproof Pro': 'Mascara_Waterproof_Pro.png',
        'Mascara Waterproof Pro': 'Mascara_Waterproof_Pro.png',
        'Mascara Volume Max': 'Mascara_Volumen_Max.png',
        'Máscara Volume Max': 'Mascara_Volumen_Max.png',
        'Paleta de Sombras Escarchada': 'paleta_de_sombras_escarchada.png',
        'Paleta de sombras escarchada': 'paleta_de_sombras_escarchada.png',
        'Paleta de Sombras Nude': 'paleta_de_sombras_Nude.png',
        'Paleta de sombras Nude': 'paleta_de_sombras_Nude.png',
        'Pestañas Postizas Glam': 'Pestanas_Postizas_Glam.png',
        'Polvo Compacto Matte': 'polvo_compacto_matte.png',
        'Polvo Suelto Soft Matte': 'polvo_suelto_soft_matte.png',
        'Primer': 'primer.png',
        'Primer Hidratante': 'primerhidratante.png',
        'Primer Matte': 'primermatte.png',
        'Rubor Coral': 'ruborcoral.png',
        'Rubor Rosa': 'ruborrosa.png',
        'Sombras Color': 'sombras_color.png',
        'Sombras Nude': 'sombras_nude.png',
        'Sombras': 'sombras.png',
        'Spray Fix Makeup': 'Spray_Fix_Makeup.png'
    };

    function resolverImagenProducto(producto) {
        if (!producto) return '';
        let rawImage = String(producto.imagen || producto.imagenUrl || '').trim().replace(/\\/g, '/');
        if (!rawImage) {
            const nombre = String(producto.nombre || '').trim();
            rawImage = IMAGENES_PRODUCTO[nombre] || '';
            if (!rawImage) {
                const clave = nombre.toLowerCase();
                const encontrada = Object.keys(IMAGENES_PRODUCTO).find(k => k.toLowerCase() === clave);
                rawImage = encontrada ? IMAGENES_PRODUCTO[encontrada] : '';
            }
        }
        if (!rawImage) return '';
        if (/^https?:\/\//i.test(rawImage)) return rawImage;
        rawImage = rawImage.replace(/^.*?Vista\/img\//i, '');
        rawImage = rawImage.replace(/^.*?web\/img\//i, '');
        rawImage = rawImage.replace(/^\/+/, '');
        if (/^img\//i.test(rawImage)) rawImage = rawImage.substring(4);
        return rawImage || '';
    }

    const listaProductosGlobal = [
        { id: 1, nombre: 'Base Matte Pro', categoria: 'maquillaje', precio: 45000, imagen: resolverImagenProducto({nombre:'Base Matte Pro'}), descripcion: 'Base de alta cobertura con acabado mate duradero.', badge: 'Popular' },
        { id: 2, nombre: 'Base Fluida HD', categoria: 'maquillaje', precio: 48000, imagen: resolverImagenProducto({nombre:'Base Fluida HD'}), descripcion: 'Textura ligera para un acabado natural de alta definición.', badge: 'Nuevo' },
        { id: 3, nombre: 'Labial Matte Chic', categoria: 'maquillaje', precio: 25000, imagen: resolverImagenProducto({nombre:'Labial Matte Chic'}), descripcion: 'Labial líquido mate de larga duración sin resecar.', badge: 'Ofertado' },
        { id: 4, nombre: 'Labial Nude Soft', categoria: 'maquillaje', precio: 22000, imagen: resolverImagenProducto({nombre:'Labial Nude Soft'}), descripcion: 'Tono nude versátil con textura suave y cremosa.', badge: 'Top' },
        { id: 5, nombre: 'Lip Gloss Crystal', categoria: 'maquillaje', precio: 18000, imagen: resolverImagenProducto({nombre:'Lip Gloss Crystal'}), descripcion: 'Brillo labial ultra hidratante efecto cristalino.', badge: 'Nuevo' },
        { id: 6, nombre: 'Máscara Mega Volume', categoria: 'maquillaje', precio: 32000, imagen: resolverImagenProducto({nombre:'Máscara Mega Volume'}), descripcion: 'Volumen extremo sin dejar grumos.', badge: 'Popular' },
        { id: 7, nombre: 'Máscara Waterproof Pro', categoria: 'maquillaje', precio: 35000, imagen: resolverImagenProducto({nombre:'Máscara Waterproof Pro'}), descripcion: 'Pestañina resistente al agua de máxima duración.', badge: 'Pro' },
        { id: 8, nombre: 'Paleta de Sombras Nude', categoria: 'novedades', precio: 65000, imagen: resolverImagenProducto({nombre:'Paleta de Sombras Nude'}), descripcion: 'Tonos neutros altamente pigmentados.', badge: 'Novedad' },
        { id: 9, nombre: 'Iluminador Golden Glow', categoria: 'mas-vendidos', precio: 28000, imagen: resolverImagenProducto({nombre:'Iluminador Golden Glow'}), descripcion: 'Polvo iluminador tono dorado cálido resplandeciente.', badge: 'Más Vendido' },
        { id: 10, nombre: 'Polvo Compacto Matte', categoria: 'cuidado-facial', precio: 30000, imagen: resolverImagenProducto({nombre:'Polvo Compacto Matte'}), descripcion: 'Controla el brillo facial con acabado aterciopelado.', badge: 'Básico' },
        { id: 11, nombre: 'Spray Fijador Pro', categoria: 'cuidado-facial', precio: 38000, imagen: resolverImagenProducto({nombre:'Spray Fijador Pro'}), descripcion: 'Fija y prolonga la duración de tu maquillaje.', badge: 'Pro' },
        { id: 12, nombre: 'Lápiz para Cejas Brow Define', categoria: 'brochas', precio: 20000, imagen: resolverImagenProducto({nombre:'Lápiz para Cejas Brow Define'}), descripcion: 'Lápiz de precisión para rellenar y enmarcar cejas.', badge: 'Especial' }
    ];

    function categoriaPorId(id) {
        switch (Number(id)) {
            case 1: return 'cuidado-facial';
            case 2: return 'maquillaje';
            case 11: return 'brochas';
            case 13: return 'novedades';
            default: return 'otros';
        }
    }

    function inferirSubcategoriaProducto(p) {
        // Fallback para bases que todavía tienen subcategoria_id_subcategoria NULL.
        // Permite que el filtro funcione inmediatamente mientras se aplica la migración SQL.
        const categoriaId = Number(p.categoriaIdCategoria || 0);
        const texto = (String(p.nombre || '') + ' ' + String(p.descripcion || '')).toLowerCase();
        if (![2, 13].includes(categoriaId)) return '';
        if (/corrector/.test(texto)) return 'Rostro - Correctores';
        if (/delineador/.test(texto) && /labio|labios/.test(texto)) return 'Labios - Delineadores';
        if (/delineador/.test(texto)) return 'Ojos - Delineadores';
        if (/cejas/.test(texto)) return 'Ojos - Cejas';
        if (/máscara|mascara|pestañina/.test(texto)) return 'Ojos - Pestañinas';
        if (/sombra|paleta de sombras/.test(texto)) return 'Ojos - Sombras';
        if (/gloss/.test(texto)) return 'Labios - Gloss';
        if (/labial|tinta de labios/.test(texto)) return 'Labios - Labiales';
        if (/rubor/.test(texto)) return 'Rostro - Rubores';
        if (/iluminador/.test(texto)) return 'Rostro - Iluminadores';
        if (/contorno/.test(texto)) return 'Rostro - Contornos';
        if (/polvo/.test(texto)) return 'Rostro - Polvos';
        if (/base/.test(texto)) return 'Rostro - Bases';
        return '';
    }

    function normalizarProductosBD(items) {
        return (Array.isArray(items) ? items : []).map(p => {
            const categoria = p.categoria || categoriaPorId(p.categoriaIdCategoria);
            const subcategoriaNombre = String(p.subcategoriaNombre || '').trim() || inferirSubcategoriaProducto(p);
            return { ...p, id: Number(p.id), categoria, imagen: resolverImagenProducto(p), subcategoriaNombre };
        });
    }

    function codificarRutaWeb(ruta) {
        return String(ruta || '').split('/').filter(Boolean).map(segment => encodeURIComponent(segment)).join('/');
    }

    function rutaImagen(producto) {
        let ruta = String(resolverImagenProducto(producto) || '').trim().replace(/\\/g, '/');
        if (!ruta) return contextPath + '/Vista/img/default.jpg';
        if (/^https?:\/\//i.test(ruta)) return ruta;
        ruta = ruta.replace(/^\/+/, '');
        return (cloudinaryBase || '') + encodeURI(ruta);
    }

    let productosCatalogoActual = [];
    let filtroCategoriaActual = 'todo';
    let filtroSubcategoriaActual = 'todo';
    let filtroBusquedaActual = '';

    function productosFuente() {
        if (productosCatalogoActual.length) return productosCatalogoActual;
        if (Array.isArray(window.products) && window.products.length) return normalizarProductosBD(window.products);
        return listaProductosGlobal;
    }

    function aplicarFiltrosCatalogo() {
        const fuente = productosFuente();
        const q = filtroBusquedaActual.toLowerCase().trim();
        let resultado = fuente;

        // Cuando se elige una subcategoría, esta es el filtro principal:
        // muestra todos los productos relacionados con ella, incluso si pertenecen
        // a Novedades u otra categoría comercial.
        if (filtroSubcategoriaActual !== 'todo') {
            resultado = fuente.filter(p => String(p.subcategoriaNombre || '').toLowerCase() === filtroSubcategoriaActual.toLowerCase());
        } else if (filtroCategoriaActual !== 'todo') {
            if (filtroCategoriaActual === 'mas-vendidos') {
                const destacados = fuente.filter(p => p.esMasVendido === true || p.esMasVendido === 'true' || p.badge === 'Más Vendido');
                resultado = destacados.length ? destacados : [...fuente].sort((a, b) => Number(b.stock || 0) - Number(a.stock || 0)).slice(0, 12);
            } else {
                resultado = fuente.filter(p => String(p.categoria || '').toLowerCase() === filtroCategoriaActual);
            }
        }

        if (q) {
            resultado = resultado.filter(p => (String(p.nombre || '') + ' ' + String(p.descripcion || '')).toLowerCase().includes(q));
        }
        renderizarGrid(resultado);
    }

    function filtrarSubcategoria(valor){filtroSubcategoriaActual=valor||'todo';aplicarFiltrosCatalogo();}

    let productoSeleccionadoId = null;

    function verDetalleFragment(id){
        abrirModalDetalle(id);
    }

    function actualizarContadorCarrito() {
        const total = safeJSON(cartKey()).reduce((sum, item) => sum + (Number(item.cantidad) || 0), 0);
        document.querySelectorAll('[data-cart-count]').forEach(function(el) {
            el.textContent = String(total);
            el.classList.toggle('is-empty', total === 0);
        });
    }

    function mostrarToast(mensaje) {
        let toast = document.getElementById('bbToast');
        if (!toast) {
            toast = document.createElement('div');
            toast.id = 'bbToast';
            toast.className = 'bb-toast';
            document.body.appendChild(toast);
        }
        toast.textContent = mensaje;
        toast.classList.add('show');
        clearTimeout(window.__bbToastTimer);
        window.__bbToastTimer = setTimeout(function(){ toast.classList.remove('show'); }, 2200);
    }

    async function validarStockServidor(id,cantidad){
        try{
            const r=await fetch(contextPath+'/ProductoServlet?action=validarStock&id='+encodeURIComponent(id)+'&cantidad='+encodeURIComponent(cantidad),{credentials:'same-origin'});
            const d=await r.json();
            return d;
        }catch(e){
            return {status:'error',message:'No fue posible validar el stock en este momento.'};
        }
    }
    
    async function agregarProductoAlCarrito(id, cantidad) {
        if (!usuarioLogueado) { mostrarAlertaPersonalizada('Debes iniciar sesión para agregar productos al carrito.'); return false; }
        const p = productosFuente().find(x => Number(x.id) === Number(id)); if (!p) return false;
        const q = Math.max(1, Number(cantidad) || 1);
        let cart = safeJSON(cartKey()); const i = cart.findIndex(x => Number(x.id) === Number(p.id));
        const existente=i>=0?(Number(cart[i].cantidad)||0):0; const requested=existente+q;
        const check=await validarStockServidor(p.id,requested);
        if(check.status!=='success'){mostrarToast(check.message||'No hay suficiente stock disponible.');return false;}
        if (i >= 0) { cart[i].cantidad=requested; cart[i].imagen=p.imagen; cart[i].precio=p.precio; cart[i].nombre=p.nombre; }
        else cart.push({id:p.id,nombre:p.nombre,precio:p.precio,imagen:p.imagen,cantidad:q});
        localStorage.setItem(cartKey(), JSON.stringify(cart)); actualizarContadorCarrito(); mostrarToast('✓ '+p.nombre+' se agregó al carrito'); return true;
    }

    function renderizarGrid(items) {
        const grid = document.getElementById('productGrid');
        if (!grid) return;
        const favoritos = safeJSON(favKey());
        if (!items || !items.length) {
            grid.innerHTML = '<div class="catalog-empty-message">No se encontraron productos en esta sección.</div>';
            return;
        }
        grid.innerHTML = items.map(function(p) {
            const fav = favoritos.some(x => Number(x.id) === Number(p.id));
            const nombre = String(p.nombre || 'Producto');
            const descripcion = String(p.descripcion || 'Producto Beauty Boost para complementar tu rutina.').trim();
            const stock = Number(p.stock || 0);
            const disponible = stock > 0;
            return '<article class="product-item-card" data-product-id="'+p.id+'" tabindex="0" role="button" aria-label="Ver detalles de '+escaparHTML(nombre)+'">' +
                '<span class="product-badge">'+escaparHTML(p.badge || 'Producto')+'</span>' +
                '<button type="button" class="product-favorite '+(fav?'is-favorite':'')+'" data-action="favorite" data-id="'+p.id+'" title="'+(fav?'Quitar de favoritos':'Marcar como favorito')+'" aria-pressed="'+(fav?'true':'false')+'">'+(fav?'♥':'♡')+'</button>' +
                '<div class="product-img-box"><img src="'+rutaImagen(p)+'" alt="'+escaparHTML(nombre)+'" loading="lazy"></div>' +
                '<div class="product-rating-row"><span class="product-rating">★ 4.9</span></div>' +
                '<h3 class="product-name">'+escaparHTML(nombre)+'</h3>' +
                '<p class="product-short-description">'+escaparHTML(descripcion)+'</p>' +
                '<div class="product-card-footer"><div><span class="product-price-value">'+money(p.precio)+'</span><span class="product-stock-mini '+(disponible?'':'out')+'">'+(disponible?'En existencia':'Agotado')+'</span></div>' +
                '<button type="button" class="add-to-cart-btn" data-action="add-cart" data-id="'+p.id+'" title="'+(disponible?'Agregar al carrito':'Producto agotado')+'" aria-label="'+(disponible?'Agregar '+escaparHTML(nombre)+' al carrito':'Producto agotado')+'" '+(disponible?'':'disabled')+'>+</button></div>' +
                '<button type="button" class="product-detail-link" data-action="detail" data-id="'+p.id+'">Ver detalles</button>' +
                '</article>';
        }).join('');

        grid.querySelectorAll('.product-img-box img').forEach(function(img) {
            img.addEventListener('error', function() {
                this.onerror = null;
                this.src = contextPath + '/Vista/img/default.jpg';
            });
        });
    }

    function renderizarFavoritosPerfil(){
        const box=document.getElementById('favoritesProfileGrid');
        if(!box)return;
        if(box.querySelector('.favorite-profile-card'))return;
        const favoritos=safeJSON(favKey());
        if(!favoritos.length && !box.querySelector('.favorites-empty')){
            box.innerHTML='<div class="favorites-empty"><div>♡</div><h4>Aún no tienes favoritos</h4><p>Marca el corazón de un producto y aparecerá aquí.</p><a href="'+contextPath+'/ProductoServlet" class="btn-primary-brown">Explorar productos</a></div>';
        }
    }

    function obtenerIdsFavoritosSesion(){
        if(!usuarioLogueado) return [];
        const raw=document.body?.dataset.favoriteIds || '';
        const ids=(raw.match(/\d+/g)||[]).map(Number).filter(Boolean);
        return [...new Set(ids)];
    }
    function sincronizarFavoritosConSesion(){
        if(!usuarioLogueado) return;
        const ids=obtenerIdsFavoritosSesion();
        const favoritos=ids.map(id=>productosFuente().find(p=>Number(p.id)===id)).filter(Boolean);
        localStorage.setItem(favKey(),JSON.stringify(favoritos));
    }
    function actualizarEstadoVisualFavorito(id, marcado){
        document.querySelectorAll('.product-favorite[data-id="'+id+'"], .modal-favorite-button[data-id="'+id+'"]').forEach(btn=>{
            btn.classList.toggle('is-favorite',marcado);
            btn.setAttribute('aria-pressed',marcado?'true':'false');
            if (btn.classList.contains('modal-favorite-button')) {
                btn.innerHTML=(marcado?'♥':'♡')+' <span>'+(marcado?'En favoritos':'Añadir a favoritos')+'</span>';
            } else {
                btn.textContent=marcado?'♥':'♡';
            }
            btn.title=marcado?'Quitar de favoritos':'Marcar como favorito';
        });
    }
    async function toggleFavorito(id){
        if(!usuarioLogueado){mostrarAlertaPersonalizada('Debes iniciar sesión para agregar productos a tus favoritos.');return;}
        const p=productosFuente().find(x=>Number(x.id)===Number(id));
        let fav=safeJSON(favKey());
        const i=fav.findIndex(x=>Number(x.id)===Number(id));
        const profileCard=document.querySelector('.favorite-profile-card[data-favorite-profile-id="'+id+'"]');
        const anterior=i>=0 || !!profileCard;

        if(p){
            if(anterior){
                const idx=fav.findIndex(x=>Number(x.id)===Number(id));
                if(idx>=0)fav.splice(idx,1);
            }else{
                fav.push(p);
            }
            localStorage.setItem(favKey(),JSON.stringify(fav));
        }

        actualizarEstadoVisualFavorito(id,!anterior);
        if(profileCard && anterior){
            profileCard.remove();
        }
        actualizarContadorFavoritos(anterior ? Math.max(0, Number(document.getElementById('favoritesCountBadge')?.textContent||0)-1) : fav.length);

        try{
            const r=await fetch(contextPath+'/PerfilServlet?action=toggleFavorito&productoId='+encodeURIComponent(id),{
                method:'POST',credentials:'same-origin',headers:{'X-Requested-With':'XMLHttpRequest'}
            });
            const data=await r.json();
            if(!r.ok || !data.ok) throw new Error(data.message||'No se pudo sincronizar el favorito');
            actualizarContadorFavoritos(Number(data.total)||0);

            const box=document.getElementById('favoritesProfileGrid');
            if(box && Number(data.total)===0 && !box.querySelector('.favorite-profile-card')){
                box.innerHTML='<div class="favorites-empty"><div>♡</div><h4>Aún no tienes favoritos</h4><p>Marca el corazón de un producto y aparecerá aquí.</p><a href="'+contextPath+'/ProductoServlet" class="btn-primary-brown">Explorar productos</a></div>';
            } else if(box && Number(data.total)>0){
                const empty=box.querySelector('.favorites-empty');
                if(empty) empty.remove();
            }
        }catch(err){
            if(p){
                let actual=safeJSON(favKey());
                const j=actual.findIndex(x=>Number(x.id)===Number(id));
                if(anterior && j<0)actual.push(p);
                if(!anterior && j>=0)actual.splice(j,1);
                localStorage.setItem(favKey(),JSON.stringify(actual));
            }
            actualizarEstadoVisualFavorito(id,anterior);
            showInlineMessage('No fue posible guardar el favorito. Inténtalo de nuevo.');
            location.reload();
        }
    }
    function actualizarContadorFavoritos(total){
        const value=Number(total)||0;
        ['favoritesCountBadge'].forEach(id=>{const e=document.getElementById(id);if(e)e.textContent=value});
        const title=document.getElementById('favoritesCountTitle');if(title)title.textContent='('+value+')';
    }
    function filtrarCategoria(cat){
        filtroCategoriaActual = String(cat || 'todo').toLowerCase();
        filtroSubcategoriaActual='todo';
        document.querySelectorAll('.navbar-link[data-category]').forEach(link => {
            link.classList.toggle('active', link.dataset.category === filtroCategoriaActual);
        });
        const subcat=document.getElementById('subcategoriaFiltro');
        if(subcat){subcat.value=filtroSubcategoriaActual;subcat.parentElement.style.display=(filtroCategoriaActual==='maquillaje'?'flex':'none');}
        aplicarFiltrosCatalogo();
    }

    function filtrarProductos(){
        const input=document.getElementById('txtBuscar');
        filtroBusquedaActual=(input ? input.value : '').toLowerCase().trim();
        aplicarFiltrosCatalogo();
    }
    function abrirModalDetalle(id) {
        const p = productosFuente().find(x => Number(x.id) === Number(id));
        if (!p) return;
        productoSeleccionadoId = Number(p.id);
        const badge = document.getElementById('modalCategoria');
        if (badge) {
            const isNew = Number(p.categoriaIdCategoria) === 13 || String(p.categoria || '').toLowerCase() === 'novedades';
            badge.textContent = isNew ? 'NOVEDAD' : categoriaVisible(p).toUpperCase();
        }
        setText('modalNombre', p.nombre || 'Producto');
        setText('modalDescripcion', p.descripcion || 'Sin descripción disponible.');
        setText('modalPrecio', money(p.precio));
        setText('modalModoUso', p.modoUso || modoUsoPorCategoria(p));
        const stock = Number(p.stock || 0);
        const stockEl = document.getElementById('modalStock');
        if (stockEl) {
            stockEl.textContent = stock > 0 ? 'En existencia' : 'Agotado';
            stockEl.classList.toggle('out', stock <= 0);
        }
        const productImage = rutaImagen(p);
        const img = document.getElementById('modalImg');
        if (img) {
            img.onerror = function(){ this.onerror=null; this.src=contextPath+'/Vista/img/default.jpg'; };
            img.src = productImage;
            img.alt = p.nombre || 'Producto';
        }
        // La BD actual entrega una imagen por producto. No repetimos la misma imagen
        // tres veces: mostramos una única miniatura hasta que existan imágenes adicionales.
        const thumbs = document.querySelectorAll('.bb-v5-thumb');
        thumbs.forEach(function(btn, index){
            btn.dataset.thumbSrc = productImage;
            btn.classList.toggle('is-active', index === 0);
            btn.style.display = index === 0 ? 'block' : 'none';
            const thumbImg = btn.querySelector('img');
            if (thumbImg) {
                thumbImg.onerror = function(){ this.onerror=null; this.src=contextPath+'/Vista/img/default.jpg'; };
                thumbImg.src = productImage;
                thumbImg.alt = p.nombre || 'Producto';
            }
        });
        const firstThumb = document.querySelector('.bb-v5-thumb');
        if (firstThumb) firstThumb.classList.add('is-active');
        const swatch = document.getElementById('modalColorSwatch');
        if (swatch) swatch.style.background = Number(p.categoriaIdCategoria) === 2 ? '#b43f5f' : '#d9b5c1';
        const favButton = document.getElementById('modalFavoriteButton');
        if (favButton) {
            const favs = safeJSON(favKey());
            const isFav = favs.some(function(x){ return Number(x.id) === Number(p.id); });
            favButton.dataset.id = String(p.id);
            favButton.classList.toggle('is-favorite', isFav);
            favButton.setAttribute('aria-pressed', isFav ? 'true' : 'false');
            favButton.innerHTML = (isFav ? '♥' : '♡') + ' <span>' + (isFav ? 'En favoritos' : 'Añadir a favoritos') + '</span>';
            favButton.title = isFav ? 'Quitar de favoritos' : 'Marcar como favorito';
        }
        const qty = document.getElementById('modalCantidadInput');
        if (qty) qty.value = stock > 0 ? '1' : '0';
        const add = document.querySelector('[data-action="add-modal"]');
        if (add) add.disabled = stock <= 0;
        actualizarLimitesCantidadModal();
        resetProductReviewForm(p.id);
        cargarResenasProducto(p.id);
        showModal('productModal');
    }

    function categoriaVisible(p) {
        const map = {'cuidado-facial':'Skincare','maquillaje':'Maquillaje','brochas':'Brochas','novedades':'Novedad','mas-vendidos':'Más vendido'};
        return map[String(p.categoria || '').toLowerCase()] || 'Beauty Boost';
    }

    function modoUsoPorCategoria(p) {
        const c = String(p.categoria || '').toLowerCase();
        if (c === 'maquillaje') return 'Aplicar sobre la piel limpia y difuminar de manera uniforme según el acabado deseado.';
        if (c === 'cuidado-facial') return 'Aplicar sobre la piel limpia como parte de la rutina facial y seguir con los productos habituales.';
        if (c === 'brochas') return 'Utilizar con movimientos suaves y limpiar después de cada uso para conservar las fibras en buen estado.';
        return 'Aplicar según las indicaciones del producto y ajustar la cantidad a la intensidad deseada.';
    }

    function actualizarLimitesCantidadModal() {
        const input = document.getElementById('modalCantidadInput');
        if (!input || productoSeleccionadoId == null) return;
        const p = productosFuente().find(x => Number(x.id) === Number(productoSeleccionadoId));
        if (!p) return;
        const stock = Math.max(0, Number(p.stock || 0));
        const cart = safeJSON(cartKey());
        const existente = cart.find(x => Number(x.id) === Number(p.id));
        const yaEnCarrito = existente ? Math.max(0, Number(existente.cantidad) || 0) : 0;
        const maxAgregar = Math.max(0, stock - yaEnCarrito);
        let n = Math.max(1, parseInt(input.value, 10) || 1);
        if (maxAgregar === 0) n = 0;
        else n = Math.min(n, maxAgregar);
        input.value = String(n);

        const minus = document.querySelector('[data-action="modal-qty"][data-change="-1"]');
        const plus = document.querySelector('[data-action="modal-qty"][data-change="1"]');
        const add = document.querySelector('[data-action="add-modal"]');
        if (minus) minus.disabled = n <= 1 || maxAgregar <= 0;
        if (plus) plus.disabled = n >= maxAgregar || maxAgregar <= 0;
        if (add) {
            add.disabled = maxAgregar <= 0;
            add.title = maxAgregar <= 0 ? 'Ya tienes todo el stock disponible en tu carrito' : 'Agregar al carrito';
        }
    }

    function cambiarCantidadModal(cambio) {
        const input = document.getElementById('modalCantidadInput');
        if (!input) return;
        const p = productosFuente().find(x => Number(x.id) === Number(productoSeleccionadoId));
        if (!p) return;
        const stock = Math.max(0, Number(p.stock || 0));
        const cart = safeJSON(cartKey());
        const existente = cart.find(x => Number(x.id) === Number(p.id));
        const yaEnCarrito = existente ? Math.max(0, Number(existente.cantidad) || 0) : 0;
        const maxAgregar = Math.max(0, stock - yaEnCarrito);
        if (maxAgregar <= 0) {
            input.value = '0';
            actualizarLimitesCantidadModal();
            mostrarToast('Ya tienes todo el stock disponible de este producto en el carrito.');
            return;
        }
        let n = parseInt(input.value, 10) || 1;
        n = Math.max(1, Math.min(maxAgregar, n + Number(cambio || 0)));
        input.value = String(n);
        actualizarLimitesCantidadModal();
    }

    async function cargarResenasProducto(productoId) {
        const list = document.getElementById('modalReviewsList');
        const avg = document.getElementById('modalReviewAverage');
        const stars = document.getElementById('modalReviewStars');
        const count = document.getElementById('modalReviewCount');
        if (!list) return;
        list.innerHTML = '<div class="modal-reviews-loading">Cargando opiniones…</div>';
        try {
            const r = await fetch(contextPath + '/ProductoServlet?action=resenasProducto&productoId=' + encodeURIComponent(productoId), {credentials:'same-origin'});
            const data = await r.json();
            if (!r.ok || data.status !== 'success') throw new Error(data.message || 'No fue posible cargar las reseñas.');
            const average = Number(data.average || 0);
            if (avg) avg.textContent = average.toFixed(1);
            if (stars) stars.textContent = '★★★★★'.split('').map((s,i)=>i < Math.round(average) ? '★' : '☆').join('');
            if (count) count.textContent = (data.count || 0) + ((data.count || 0) === 1 ? ' reseña' : ' reseñas');
            if (!data.reviews || !data.reviews.length) {
                list.innerHTML = '<div class="modal-reviews-empty"><span>♡</span><strong>Aún no hay reseñas</strong><small>Sé la primera persona en compartir su experiencia.</small></div>';
                return;
            }
            list.innerHTML = data.reviews.map(function(rv) {
                const rating = Number(rv.rating || 0);
                const safe = escaparHTML(rv.comment || '');
                return '<article class="modal-review-item"><div class="modal-review-item-top"><div><strong>'+escaparHTML(rv.user || 'Cliente')+'</strong><span>'+escaparHTML(String(rv.date || '').split(' ')[0])+'</span></div><span class="modal-review-stars">'+('★★★★★'.split('').map((x,i)=>i<rating?'★':'☆').join(''))+'</span></div><p>'+safe+'</p></article>';
            }).join('');
        } catch (e) {
            list.innerHTML = '<div class="modal-reviews-empty"><strong>No pudimos cargar las reseñas</strong><small>Intenta nuevamente en unos segundos.</small></div>';
        }
    }

    function resetProductReviewForm(productId) {
        const form = document.getElementById('productReviewForm');
        if (!form) return;
        const hidden = document.getElementById('productReviewProductId');
        if (hidden) hidden.value = String(productId);
        form.reset();
        if (hidden) hidden.value = String(productId);
        const msg = document.getElementById('productReviewMessage');
        if (msg) { msg.textContent = ''; msg.className = ''; }
        actualizarContadorComentario();
    }

    function actualizarContadorComentario() {
        const area = document.getElementById('productReviewComment');
        const counter = document.getElementById('productReviewCounter');
        if (area && counter) counter.textContent = String(area.value.length) + '/255';
    }

    async function publicarResenaDesdeproducto(event) {
        if (event) event.preventDefault();
        if (!usuarioLogueado) { mostrarAlertaPersonalizada('Debes iniciar sesión para publicar una reseña.'); return false; }
        const productoId = document.getElementById('productReviewProductId')?.value || productoSeleccionadoId;
        const rating = document.querySelector('#productReviewForm input[name="calificacion"]:checked')?.value;
        const comentario = (document.getElementById('productReviewComment')?.value || '').trim();
        const msg = document.getElementById('productReviewMessage');
        if (!rating) { if(msg){msg.textContent='Selecciona de 1 a 5 estrellas.';msg.className='error';} return false; }
        if (comentario.length < 3) { if(msg){msg.textContent='Escribe una opinión de al menos 3 caracteres.';msg.className='error';} return false; }
        try {
            const params = new URLSearchParams({action:'publicarResena', productoId:String(productoId), calificacion:String(rating), observacion:comentario, ajax:'true'});
            const r = await fetch(contextPath + '/PerfilServlet', {method:'POST', credentials:'same-origin', headers:{'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8','X-Requested-With':'XMLHttpRequest'}, body:params});
            const data = await r.json().catch(()=>({status:'error',message:'Respuesta inválida del servidor.'}));
            if (!r.ok || data.status !== 'success') throw new Error(data.message || 'No fue posible publicar la reseña.');
            if(msg){msg.textContent='✓ Reseña publicada correctamente.';msg.className='success';}
            await cargarResenasProducto(Number(productoId));
            document.querySelectorAll('#productReviewForm input[name="calificacion"]').forEach(r=>r.checked=false);
            const area=document.getElementById('productReviewComment'); if(area) area.value='';
        } catch (e) {
            if(msg){msg.textContent=e.message || 'No fue posible publicar la reseña.';msg.className='error';}
        }
        return false;
    }


    function publicarResenaDesdeProducto(event) {
        return publicarResenaDesdeproducto(event);
    }

    function agregarDesdeModal() {
        if (!usuarioLogueado) {
            mostrarAlertaPersonalizada('Debes iniciar sesión para agregar productos al carrito.');
            return;
        }
        const p = productosFuente().find(x => Number(x.id) === Number(productoSeleccionadoId));
        if (!p) return;
        if (Number(p.stock || 0) <= 0) {
            mostrarToast('Este producto está agotado.');
            return;
        }
        const q = Math.max(1, parseInt(document.getElementById('modalCantidadInput')?.value, 10) || 1);
        agregarProductoAlCarrito(p.id, q).then(function(ok){
            if(ok) {
                mostrarToast('✓ Producto agregado al carrito. Puedes seguir comprando.');
            }
        });
    }

    function cerrarModalDetalle(){hideModal('productModal')}
    function cerrarSuccessModal(){hideModal('cartSuccessModal')}
    function irAlCarritoDesdeModal(){location.href=contextPath+'/ProductoServlet?action=carrito'}
    function mostrarAlertaPersonalizada(msg){const e=document.getElementById('customAlertMessage');if(e)e.textContent=msg;showModal('customAlertModal')}
    function redirigirLogin(){location.href=contextPath+'/Vista/Login.jsp'}
    function verificarAccesoCarrito(e){if(e)e.preventDefault();if(!usuarioLogueado)mostrarAlertaPersonalizada('Para ingresar al apartado del carrito debes iniciar sesión.');else location.href=contextPath+'/ProductoServlet?action=carrito'}

    /* ==================== CARRITO ==================== */
    function renderCartItems(container, mode){
        const cart=safeJSON(cartKey());if(!container)return cart;
        if(!cart.length){container.innerHTML='<div class="cart-empty"><div class="cart-empty-icon">🛍️</div><h3>Tu carrito está vacío</h3><p>Agrega productos para verlos aquí.</p><a class="btn-primary" href="'+contextPath+'/ProductoServlet">EXPLORAR PRODUCTOS</a></div>';return cart;}
        let subtotal=0;
        container.innerHTML=cart.map((item,index)=>{const total=item.precio*item.cantidad;subtotal+=total;return '<div class="cart-item"><div class="cart-item-main"><img class="cart-item-image" src="'+rutaImagen(item)+'" alt="'+item.nombre+'"><div><h4 class="cart-item-name">'+item.nombre+'</h4><p class="cart-item-meta">Cantidad: '+item.cantidad+'</p><strong class="cart-item-price">'+money(item.precio)+'</strong></div></div><div class="cart-item-actions">'+(mode==='editable'?'<div class="qty-control"><button data-action="qty" data-index="'+index+'" data-change="-1">−</button><span class="qty-value">'+item.cantidad+'</span><button data-action="qty" data-index="'+index+'" data-change="1">+</button></div>':'')+'<span class="cart-item-price">'+money(total)+'</span><button class="btn-remove" data-action="remove" data-index="'+index+'">Eliminar</button></div></div>'}).join('');
        return cart;
    }
    function cargarCarrito(){
        const container=document.getElementById('cartItemsContainer');const cart=renderCartItems(container,document.body.contains(document.querySelector('.qty-control'))||document.getElementById('resumenSubtotal')?'editable':'summary');
        if(document.getElementById('lblSubtotal')){const sub=cart.reduce((a,x)=>a+x.precio*x.cantidad,0),ship=sub?10000:0,tax=Math.round(sub*.05);document.getElementById('lblSubtotal').textContent=money(sub);document.getElementById('lblEnvio').textContent=money(ship);document.getElementById('lblImpuestos').textContent=money(tax);document.getElementById('lblTotal').textContent=money(sub+ship+tax);}
        if(document.getElementById('resumenSubtotal')){const sub=cart.reduce((a,x)=>a+x.precio*x.cantidad,0);document.getElementById('resumenSubtotal').textContent=money(sub);document.getElementById('resumenTotal').textContent=money(sub);}
        const btn=document.getElementById('btnPagar');if(btn)btn.disabled=!cart.length;
    }
    async function cambiarCantidad(index,cambio){
        let c=safeJSON(cartKey()); if(!c[index])return;
        const nueva=(Number(c[index].cantidad)||0)+Number(cambio);
        if(nueva<=0){c.splice(index,1);localStorage.setItem(cartKey(),JSON.stringify(c));cargarCarrito();return;}
        const check=await validarStockServidor(c[index].id,nueva);
        if(check.status!=='success'){mostrarToast(check.message||'No puedes superar el stock disponible.');return;}
        c[index].cantidad=nueva;localStorage.setItem(cartKey(),JSON.stringify(c));cargarCarrito();
    }
    function eliminarItem(index){let c=safeJSON(cartKey());c.splice(index,1);localStorage.setItem(cartKey(),JSON.stringify(c));cargarCarrito()}
    function eliminarDelCarrito(index){eliminarItem(index)}
    function procesarPago(){const cart=safeJSON(cartKey());if(!usuarioLogueado){location.href=contextPath+'/LoginServlet';return;}if(!cart.length){location.assign(contextPath+'/ProductoServlet?action=checkout&carritoVacio=true');return;}location.assign(contextPath+'/ProductoServlet?action=checkout&step=1')}

    /* ==================== CHECKOUT ==================== */
    let costoEnvioActual=0;
    function cargarResumenCheckout(){
        const c=safeJSON(cartKey()),box=document.getElementById('checkoutItemsList');if(!box)return;const n=document.getElementById('lblNumArticulos');if(n)n.textContent=c.length+' Artículos';let sub=0;
        if(!c.length){box.innerHTML='<p class="field-hint">No hay productos en el carrito.</p>';setText('checkoutSubtotal',money(0));setText('checkoutTotal',money(0));setText('wompiCheckoutTotal',money(0));return;}
        box.innerHTML=c.map(item=>{const t=item.precio*item.cantidad;sub+=t;return '<div class="checkout-item"><div class="checkout-item-main"><img class="checkout-item-image" src="'+rutaImagen(item)+'" alt="'+item.nombre+'"><div><span class="checkout-item-name">'+item.nombre+'</span><span class="checkout-item-meta">Cant: '+item.cantidad+' • '+money(item.precio)+'</span></div></div><span class="checkout-item-total">'+money(t)+'</span></div>'}).join('');setText('checkoutSubtotal',money(sub));setText('checkoutTotal',money(sub+costoEnvioActual));setText('wompiCheckoutTotal',money(sub+costoEnvioActual));
    }
    function setText(id,v){const e=document.getElementById(id);if(e)e.textContent=v}
    function seleccionarEnvio(tipo,costo){costoEnvioActual=costo;['optEstandar','optExpress'].forEach(id=>{const e=document.getElementById(id);if(e)e.classList.remove('selected')});const selected=tipo==='estandar'?'optEstandar':'optExpress';document.getElementById(selected)?.classList.add('selected');const rs=document.getElementById('radioEstandar'),re=document.getElementById('radioExpress');if(rs)rs.checked=tipo==='estandar';if(re)re.checked=tipo==='express';setText('checkoutCostEnvio',tipo==='estandar'?'GRATIS':'$12.000');setText('lblTipoEnvioSeleccionado',tipo==='estandar'?'Envío Estándar':'Envío Express Mismo Día');cargarResumenCheckout()}
    function irAlPaso2(){toggleStep(1,2)}
    function volverAlPaso1(){toggleStep(2,1)}
    function toggleStep(from,to){document.getElementById('viewStep'+from)?.classList.remove('step-visible');document.getElementById('viewStep'+from)?.classList.add('step-hidden');document.getElementById('viewStep'+to)?.classList.remove('step-hidden');document.getElementById('viewStep'+to)?.classList.add('step-visible');for(let i=1;i<=3;i++){document.getElementById('pillStep'+i)?.classList.toggle('active',i===to);document.getElementById('pillStep'+i)?.classList.toggle('completed',i<to);if(document.getElementById('numStep'+i)&&i<to)document.getElementById('numStep'+i).textContent='✓'}window.scrollTo({top:0,behavior:'smooth'})}
    let metodoPagoActual='tarjeta';
    function cambiarTabPago(tab){
        metodoPagoActual=tab;
        const forms={tarjeta:'Tarjeta',pse:'Pse',nequi:'Nequi',daviplata:'Daviplata',contraentrega:'Contraentrega'};
        Object.keys(forms).forEach(function(x){
            const id='tab'+forms[x];
            document.getElementById(id)?.classList.toggle('selected',x===tab);
            const form=document.getElementById('form'+forms[x]);
            if(form){
                form.hidden=x!==tab;
                form.querySelectorAll('input,select,textarea').forEach(function(el){
                    el.disabled=x!==tab;
                    el.required=false;
                });
            }
        });
        const requiredByMethod={
            tarjeta:['txtNombreTitular','txtNumeroTarjeta','txtFechaVencimiento','txtCvv','selectCuotas'],
            pse:['pseTipoPersona','pseBanco','pseCorreo'],
            nequi:['nequiTelefono'],
            daviplata:['daviplataTipoDocumento','daviplataDocumento','daviplataTelefono'],
            contraentrega:['contraNombrePedido','contraDocumento','contraDireccion','contraTelefono','contraRecibe','contraRecibeTelefono']
        };
        (requiredByMethod[tab]||[]).forEach(function(id){const el=document.getElementById(id);if(el){el.disabled=false;el.required=true;}});
        document.getElementById('paymentReview')?.setAttribute('hidden','');
    }
    function obtenerDireccionCheckout(){
        const e=document.getElementById('txtDireccionEntrega');return e?e.value.trim():'';
    }
    function datosPagoValidos(){
        const req=(id)=>{const e=document.getElementById(id);return e?e.value.trim():''};
        if(metodoPagoActual==='tarjeta') return req('txtNombreTitular')&&req('txtNumeroTarjeta')&&req('txtFechaVencimiento')&&req('txtCvv')&&req('selectCuotas');
        if(metodoPagoActual==='pse') return req('pseTipoPersona')&&req('pseBanco')&&req('pseCorreo');
        if(metodoPagoActual==='nequi') return req('nequiTelefono');
        if(metodoPagoActual==='daviplata') return req('daviplataTipoDocumento')&&req('daviplataDocumento')&&req('daviplataTelefono');
        return req('contraNombrePedido')&&req('contraDocumento')&&req('contraDireccion')&&req('contraTelefono')&&req('contraRecibe')&&req('contraRecibeTelefono');
    }
    function etiquetaMetodoPago(){return {tarjeta:'Tarjeta Crédito/Débito',pse:'PSE',nequi:'Nequi',daviplata:'Daviplata',contraentrega:'Contra Entrega'}[metodoPagoActual]||'Método de pago';}
    function datosPagoResumen(){
        const req=(id)=>{const e=document.getElementById(id);return e?e.value.trim():''};
        if(metodoPagoActual==='tarjeta'){const n=req('txtNumeroTarjeta');return 'Tarjeta terminada en •••• '+(n.slice(-4)||'----')}
        if(metodoPagoActual==='pse')return 'Banco: '+req('pseBanco')+' · '+req('pseTipoPersona');
        if(metodoPagoActual==='nequi')return 'Celular: '+req('nequiTelefono');
        if(metodoPagoActual==='daviplata')return 'Documento: '+req('daviplataDocumento')+' · Celular: '+req('daviplataTelefono');
        return 'Recibe: '+req('contraRecibe')+' · Teléfono: '+req('contraRecibeTelefono');
    }
    function revisarPago(){
        const direccion=obtenerDireccionCheckout();
        if(!direccion){showInlineMessage('Escribe la dirección donde quieres recibir el pedido.');document.getElementById('txtDireccionEntrega')?.focus();return}
        setText('reviewDireccion',direccion);setText('reviewMetodo','Wompi');setText('reviewDatosPago','Checkout seguro de Wompi');setText('reviewTotal',document.getElementById('checkoutTotal')?.textContent||'$0');
        setText('step2Direccion',direccion);
        const review=document.getElementById('paymentReview');if(review){review.hidden=false;review.scrollIntoView({behavior:'smooth',block:'center'})}
    }
    function editarPago(){const r=document.getElementById('paymentReview');if(r)r.hidden=true}
    async function procesarPagoFinal(){
        const direccion=obtenerDireccionCheckout(); if(!direccion){revisarPago();return;}
        const c=safeJSON(cartKey()); if(!c.length){showInlineMessage('Tu carrito está vacío.');return;}
        try{
            const params=new URLSearchParams({action:'prepararWompi',carritoJson:JSON.stringify(c),direccionEntrega:direccion});
            const r=await fetch(contextPath+'/ProductoServlet',{method:'POST',credentials:'same-origin',headers:{'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8','X-Requested-With':'XMLHttpRequest'},body:params});
            const d=await r.json(); if(!r.ok||d.status!=='success') throw new Error(d.message||'No fue posible preparar el pago.');
            localStorage.setItem('beautyBoostPendingOrder',JSON.stringify(d));
            const form=document.createElement('form');form.method='GET';form.action=d.checkoutUrl;
            [['public-key',d.publicKey],['currency','COP'],['amount-in-cents',d.amountInCents],['reference',d.reference],['signature:integrity',d.integrity],['redirect-url',d.redirectUrl],['customer-data:email',document.body.dataset.userEmail||'']].forEach(function(x){const i=document.createElement('input');i.type='hidden';i.name=x[0];i.value=x[1];form.appendChild(i);});
            document.body.appendChild(form); form.submit();
        }catch(e){console.error(e);showInlineMessage(e.message||'No se pudo iniciar el pago con Wompi.');}
    }

    /* ==================== PERFIL ==================== */
    function switchTab(tabId,titleText){for(let i=1;i<=6;i++){document.getElementById('btnTab'+i)?.classList.remove('active');document.getElementById('tab'+i)?.classList.remove('active')}const n=tabId.replace('tab','');document.getElementById('btnTab'+n)?.classList.add('active');document.getElementById(tabId)?.classList.add('active');setText('lblBreadcrumbCurrent',titleText)}
    function cerrarModal(){hideModal('modalDetallePedido')}

    /* ==================== REGISTRO ==================== */
    function validarRegistro(event){
        const form=event.target,doc=document.getElementById('txtIdentificacion'),tel=document.getElementById('txtTelefono'),date=document.getElementById('txtFechaNacimientoDisplay'),hidden=document.getElementById('txtFechaNacimiento');
        let ok=true;const setErr=(id,msg)=>{const e=document.getElementById(id);if(e)e.textContent=msg};setErr('documentoError','');setErr('telefonoError','');setErr('fechaError','');
        if(doc){doc.value=doc.value.replace(/\D/g,'');if(doc.value.length<10){setErr('documentoError','El documento debe tener mínimo 10 números.');ok=false}}
        if(tel){tel.value=tel.value.replace(/\D/g,'');if(tel.value.length<10){setErr('telefonoError','El teléfono debe tener mínimo 10 números.');ok=false}}
        if(date){const v=date.value.trim();const m=/^(\d{2})\/(\d{2})\/(\d{4})$/.exec(v);let valid=false;if(m){const d=Number(m[1]),mo=Number(m[2]),y=Number(m[3]),dt=new Date(y,mo-1,d);valid=dt.getFullYear()===y&&dt.getMonth()===mo-1&&dt.getDate()===d;if(valid&&hidden)hidden.value=y+'-'+String(mo).padStart(2,'0')+'-'+String(d).padStart(2,'0')}if(!valid){setErr('fechaError','La fecha debe tener el formato DD/MM/AAAA y ser una fecha válida.');ok=false}}
        const consent=form.querySelector('input[name=chkAutorizacion]');if(consent&&!consent.checked){showInlineMessage('Debes aceptar el tratamiento de datos para crear tu cuenta.');ok=false;}if(!ok){event.preventDefault();return false}return true;
    }
    function maskDate(e){let v=e.target.value.replace(/\D/g,'').slice(0,8);if(v.length>4)v=v.slice(0,2)+'/'+v.slice(2,4)+'/'+v.slice(4);else if(v.length>2)v=v.slice(0,2)+'/'+v.slice(2);e.target.value=v}

    /* ==================== EVENTOS ==================== */
    document.addEventListener('click', function(e) {
        const category = e.target.closest('[data-category]');
        if (category) {
            e.preventDefault();
            filtrarCategoria(category.dataset.category);
            return;
        }
        const card = e.target.closest('.product-item-card');
        const action = e.target.closest('[data-action]');
        if (action) {
            const a = action.dataset.action;
            const id = Number(action.dataset.id);
            if (a === 'favorite' || a === 'modal-favorite') { e.stopPropagation(); toggleFavorito(id); return; }
            if (a === 'modal-thumb') {
                e.stopPropagation();
                const src = action.dataset.thumbSrc || action.querySelector('img')?.src;
                const main = document.getElementById('modalImg');
                if (main && src) main.src = src;
                document.querySelectorAll('.bb-v5-thumb').forEach(function(btn){btn.classList.toggle('is-active', btn === action);});
                return;
            }
            if (a === 'add-cart') { e.stopPropagation(); agregarProductoAlCarrito(id, 1); return; }
            if (a === 'detail') { e.stopPropagation(); abrirModalDetalle(id); return; }
            if (a === 'detail-fragment') { e.stopPropagation(); verDetalleFragment(id); return; }
            if (a === 'qty') { cambiarCantidad(Number(action.dataset.index), Number(action.dataset.change)); return; }
            if (a === 'remove') { eliminarItem(Number(action.dataset.index)); return; }
            if (a === 'cart-access') { verificarAccesoCarrito(e); return; }
            if (a === 'open-privacy') { showModal('privacyConsentModal'); return; }
            if (a === 'close-privacy') { hideModal('privacyConsentModal'); return; }
            if (a === 'close-sensitive') { hideModal('sensitiveConfirmModal'); return; }
            if (a === 'confirm-sensitive') { window.__bbSensitiveForm?.submit(); hideModal('sensitiveConfirmModal'); return; }
            if (a === 'close-product-modal') { cerrarModalDetalle(); return; }
            if (a === 'modal-qty') { cambiarCantidadModal(Number(action.dataset.change)); return; }
            if (a === 'add-modal') { agregarDesdeModal(); return; }
            if (a === 'close-success') { cerrarSuccessModal(); return; }
            if (a === 'go-cart') { irAlCarritoDesdeModal(); return; }
            if (a === 'go-login') { redirigirLogin(); return; }
            if (a === 'switch-tab') { switchTab(action.dataset.tab, action.dataset.title); return; }
            if (a === 'close-order-modal') { cerrarModal(); return; }
            if (a === 'shipping') { seleccionarEnvio(action.dataset.type, Number(action.dataset.cost)); return; }
            if (a === 'step2') { irAlPaso2(); return; }
            if (a === 'step1') { volverAlPaso1(); return; }
            if (a === 'payment-tab') { cambiarTabPago(action.dataset.tab); return; }
            if (a === 'review-payment') { revisarPago(); return; }
            if (a === 'confirm-payment') { procesarPagoFinal(); return; }
            if (a === 'edit-payment') { editarPago(); return; }
            if (a === 'pay') { procesarPago(); return; }
            if (a === 'go-checkout') { procesarPago(); return; }
        }
        if (card) abrirModalDetalle(Number(card.dataset.productId));
        if (e.target.matches('[data-close-modal]')) hideModal(e.target.dataset.closeModal);
    });

    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') {
            ['productModal', 'cartSuccessModal', 'customAlertModal', 'modalDetallePedido'].forEach(hideModal);
        }
    });

    document.addEventListener('DOMContentLoaded', function(){
        window.togglePassword = function(inputId, button){
            const input = document.getElementById(inputId);
            if(!input) return false;
            const visible = input.type === 'text';
            input.setAttribute('type', visible ? 'password' : 'text');
            if(button){
                button.innerHTML = visible
                    ? '<svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><path d="M2.2 12s3.5-6 9.8-6 9.8 6 9.8 6-3.5 6-9.8 6-9.8-6-9.8-6Z" fill="none" stroke="currentColor" stroke-width="1.8"/><circle cx="12" cy="12" r="2.7" fill="currentColor"/></svg>'
                    : '<svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><path d="M3 3l18 18" fill="none" stroke="currentColor" stroke-width="1.8"/><path d="M2.2 12s3.5-6 9.8-6c2 0 3.7.6 5.1 1.5M21.8 12s-1.5 2.6-4.5 4.2c-1.5.8-3.2 1.2-5.3 1.2-6.3 0-9.8-6-9.8-6s1.4-2.4 4.2-4" fill="none" stroke="currentColor" stroke-width="1.8"/></svg>';
                button.setAttribute('aria-label', visible ? 'Mostrar contraseña' : 'Ocultar contraseña');
                button.setAttribute('aria-pressed', visible ? 'false' : 'true');
            }
            return false;
        };
        document.querySelectorAll('[data-toggle-password]').forEach(function(btn){
            btn.addEventListener('click', function(e){
                e.preventDefault();
                togglePassword(btn.dataset.togglePassword, btn);
            });
        });
        const grid = document.getElementById('productGrid');
        if(grid){
            productosCatalogoActual = normalizarProductosBD(window.products);
            if(!productosCatalogoActual.length) productosCatalogoActual = listaProductosGlobal.slice();
            const params = new URLSearchParams(window.location.search);
            const initialCategory = (params.get('categoria') || params.get('id_categoria') || 'todo').toLowerCase();
            const initialSearch = params.get('busqueda') || params.get('buscar') || params.get('q') || '';
            const search = document.getElementById('txtBuscar');
            const subcat = document.getElementById('subcategoriaFiltro');
            if(subcat){
                subcat.addEventListener('change', function(){ filtrarSubcategoria(this.value); });
                subcat.parentElement.style.display = (filtroCategoriaActual === 'maquillaje' ? 'flex' : 'none');
            }
            if(search && initialSearch) search.value = initialSearch;
            filtroCategoriaActual = initialCategory || 'todo';
            filtroBusquedaActual = initialSearch || '';
            sincronizarFavoritosConSesion();
            aplicarFiltrosCatalogo();
            actualizarContadorCarrito();
            document.querySelectorAll('.navbar-link[data-category]').forEach(link => {
                link.classList.toggle('active', link.dataset.category === filtroCategoriaActual);
            });
            search?.addEventListener('input', filtrarProductos);
        }
        if(document.getElementById('cartItemsContainer')) cargarCarrito();
        if(document.getElementById('checkoutItemsList')){
            cargarResumenCheckout();
            if(new URLSearchParams(location.search).get('step') === '2') irAlPaso2();
        }
        if(document.getElementById('favoritesProfileGrid')) renderizarFavoritosPerfil();
        const reviewComment = document.getElementById('productReviewComment');
        if (reviewComment) reviewComment.addEventListener('input', actualizarContadorComentario);
        const reg = document.querySelector('form[action*="RegistroServlet"]');
        if(reg){
            reg.addEventListener('submit', validarRegistro);
            document.getElementById('txtFechaNacimientoDisplay')?.addEventListener('input', maskDate);
        }
        document.querySelectorAll('.btn-ver-detalles').forEach(btn => btn.addEventListener('click', function(){
            const card = this.closest('.tarjeta-pedido');
            if(!card) return;
            setText('mNumPedido', 'Pedido #' + card.dataset.num);
            setText('mFecha', card.dataset.fecha);
            setText('mEstado', card.dataset.estado);
            setText('mTotal', card.dataset.total);
            setText('mDireccion', card.dataset.direccion);
            const box = document.getElementById('mListaProductos');
            if(box){
                box.innerHTML = '';
                try {
                    JSON.parse(card.dataset.productos).forEach(p => {
                        const row = document.createElement('div');
                        row.className = 'cart-item';
                        row.innerHTML = '<span>' + p.cantidad + ' x ' + p.nombre + '</span><strong>' + p.subtotal + '</strong>';
                        box.appendChild(row);
                    });
                } catch(e) {
                    box.textContent = 'No hay detalles de productos disponibles.';
                }
            }
            showModal('modalDetallePedido');
        }));
    });

    Object.assign(window, {
        verDetalleFragment, agregarProductoAlCarrito, filtrarSubcategoria, actualizarContadorCarrito,
        filtrarCategoria, filtrarProductos, toggleFavorito, abrirModalDetalle, cambiarCantidadModal,
        verificarAccesoCarrito, agregarDesdeModal, cerrarSuccessModal, irAlCarritoDesdeModal,
        mostrarAlertaPersonalizada, redirigirLogin, cerrarModalDetalle, cargarCarrito,
        eliminarDelCarrito, cambiarCantidad, eliminarItem, procesarPago, cargarResumenCheckout,
        seleccionarEnvio, irAlPaso2, volverAlPaso1, cambiarTabPago, procesarPagoFinal,
        revisarPago, editarPago, renderizarFavoritosPerfil, switchTab, cerrarModal,
        cargarResenasProducto, publicarResenaDesdeproducto, publicarResenaDesdeProducto
    });
})();