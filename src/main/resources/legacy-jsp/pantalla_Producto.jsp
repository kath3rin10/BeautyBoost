document.addEventListener('DOMContentLoaded', () => {
    renderProducts();
});

function renderProducts() {
    const productGrid = document.getElementById('productGrid');
    if (!productGrid) return;

    // Obtener la lista de productos definida en products-data.js
    const items = window.products || window.productsData || [];

    if (items.length === 0) {
        productGrid.innerHTML = '<p style="text-align:center; width:100%;">No hay productos disponibles.</p>';
        return;
    }

    // Dibujar cada producto en la cuadrcula
    productGrid.innerHTML = items.map(product => `
        <div class="product-card" style="background: white; border-radius: 12px; padding: 15px; text-align: center; box-shadow: 0 4px 10px rgba(0,0,0,0.05); border: 1px solid #f0f0f0;">
            <div class="product-img-container" style="height: 180px; display: flex; align-items: center; justify-content: center; overflow: hidden; margin-bottom: 12px;">
                <img src="${window.contextPath || ''}/Vista/${product.imagen}" alt="${product.nombre}" style="max-height: 100%; max-width: 100%; object-fit: contain;">
            </div>
            <h3 style="font-size: 16px; margin: 8px 0; color: #333;">${product.nombre}</h3>
            <p style="color: #777; font-size: 13px; margin-bottom: 8px; text-transform: capitalize;">${product.categoria}</p>
            <p style="font-weight: bold; color: #d87d6a; font-size: 18px; margin-bottom: 12px;">$${product.precio.toLocaleString('es-CO')}</p>
            <button class="btn-primary" onclick="verDetalle(${product.id})" style="background: #d87d6a; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 500;">
                Ver detalles
            </button>
        </div>
    `).join('');
}

// Funcin para desplegar la ventana emergente modal con la informacin detallada del producto
function verDetalle(id) {
    const items = window.products || window.productsData || [];
    const prod = items.find(p => p.id === id);
    if (!prod) return;

    const modal = document.getElementById('productModal');
    if (modal) {
        // Llenar los campos dinmicamente con los IDs del modal
        const modalNombre = document.getElementById('modalNombre');
        const modalDescripcion = document.getElementById('modalDescripcion');
        const modalPrecio = document.getElementById('modalPrecio');
        const modalImg = document.getElementById('modalImg');
        const modalModoUso = document.getElementById('modalModoUso');
        const modalStock = document.getElementById('modalStock');

        if (modalNombre) modalNombre.innerText = prod.nombre;
        if (modalDescripcion) modalDescripcion.innerText = prod.descripcion || 'Sin descripcin disponible.';
        if (modalPrecio) modalPrecio.innerText = '$' + prod.precio.toLocaleString('es-CO');
        if (modalImg) modalImg.src = (window.contextPath || '') + '/Vista/' + prod.imagen;
        if (modalModoUso) modalModoUso.innerText = prod.modoUso || 'Aplicar segn indicacin del producto.';
        if (modalStock) modalStock.innerText = prod.stock > 0 ? 'En existencia' : 'Agotado';
        cargarResenasProducto(prod.id);

        // Mostrar el modal usando flex para centrarlo correctamente
        modal.style.display = 'flex';
    }
}

// Funcin para cerrar la ventana modal
function cerrarModalDetalle() {
    const modal = document.getElementById('productModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

async function cargarResenasProducto(productoId) {
    const list = document.getElementById('modalReviewsList');
    const avg = document.getElementById('modalReviewAverage');
    const stars = document.getElementById('modalReviewStars');
    const count = document.getElementById('modalReviewCount');
    if (!list) return;
    list.innerHTML = '<div class="modal-reviews-loading">Cargando opiniones…</div>';
    try {
        const r = await fetch((window.contextPath || '') + '/ProductoServlet?action=resenasProducto&productoId=' + encodeURIComponent(productoId));
        const data = await r.json();
        if (!r.ok || data.status !== 'success') throw new Error();
        const average = Number(data.average || 0);
        if (avg) avg.textContent = average.toFixed(1);
        if (stars) stars.textContent = '★★★★★'.split('').map((s,i)=>i < Math.round(average) ? '★' : '☆').join('');
        if (count) count.textContent = (data.count || 0) + ((data.count || 0) === 1 ? ' reseña' : ' reseñas');
        if (!data.reviews || !data.reviews.length) {
            list.innerHTML = '<div class="modal-reviews-empty"><span>♡</span><strong>Aún no hay reseñas</strong><small>Sé la primera persona en compartir su experiencia.</small></div>';
            return;
        }
        list.innerHTML = data.reviews.map(rv => {
            const rating = Number(rv.rating || 0);
            const safe = String(rv.comment || '').replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
            return '<article class="modal-review-item"><div class="modal-review-item-top"><div><strong>'+String(rv.user || 'Cliente')+'</strong><span>'+String(rv.date || '').split(' ')[0]+'</span></div><span class="modal-review-stars">'+('★★★★★'.split('').map((x,i)=>i<rating?'★':'☆').join(''))+'</span></div><p>'+safe+'</p></article>';
        }).join('');
    } catch (e) {
        list.innerHTML = '<div class="modal-reviews-empty"><strong>No pudimos cargar las reseñas</strong><small>Intenta nuevamente en unos segundos.</small></div>';
    }
}
