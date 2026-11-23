(function () {
    'use strict';

    // El carrusel avanza automáticamente cada 3 segundos, sin controles visibles.
    const INTERVALO_CARRUSEL = 3000;
    const slides = Array.from(document.querySelectorAll('.welcome-slide'));

    if (slides.length === 0) return;

    let indiceActual = 0;
    let temporizador = null;

    function mostrarSlide(indice) {
        indiceActual = (indice + slides.length) % slides.length;

        slides.forEach((slide, i) => {
            const activo = i === indiceActual;
            slide.classList.toggle('active', activo);
            slide.setAttribute('aria-hidden', activo ? 'false' : 'true');
        });
    }

    function siguienteSlide() {
        mostrarSlide(indiceActual + 1);
    }

    function iniciarCarrusel() {
        clearInterval(temporizador);
        temporizador = setInterval(siguienteSlide, INTERVALO_CARRUSEL);
    }

    // El carrusel continúa automáticamente aunque el cursor permanezca sobre la portada.

    document.addEventListener('visibilitychange', function () {
        if (document.hidden) clearInterval(temporizador);
        else iniciarCarrusel();
    });

    mostrarSlide(0);
    iniciarCarrusel();
})();
