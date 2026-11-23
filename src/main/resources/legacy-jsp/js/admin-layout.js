(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {
        const body = document.body;
        const menu = document.getElementById('bbMenu');
        const sidebarToggle = document.getElementById('bbSidebarToggle');
        const storageKey = 'beautyboost.admin.sidebar.collapsed';

        function isMobile() {
            return window.matchMedia('(max-width: 900px)').matches;
        }

        function setCollapsed(collapsed, persist) {
            if (isMobile()) return;
            body.classList.toggle('bb-sidebar-collapsed', collapsed);
            if (sidebarToggle) {
                sidebarToggle.setAttribute('aria-expanded', String(!collapsed));
                sidebarToggle.setAttribute('aria-label', collapsed ? 'Mostrar barra lateral' : 'Ocultar barra lateral');
                sidebarToggle.title = collapsed ? 'Mostrar barra lateral' : 'Ocultar barra lateral';
            }
            if (persist) localStorage.setItem(storageKey, collapsed ? '1' : '0');
        }

        if (!isMobile() && localStorage.getItem(storageKey) === '1') {
            setCollapsed(true, false);
        }

        if (sidebarToggle) {
            sidebarToggle.addEventListener('click', function () {
                setCollapsed(!body.classList.contains('bb-sidebar-collapsed'), true);
            });
        }

        if (menu) {
            menu.addEventListener('click', function () {
                if (isMobile()) body.classList.toggle('bb-open');
                else setCollapsed(!body.classList.contains('bb-sidebar-collapsed'), true);
            });
        }

        window.addEventListener('resize', function () {
            if (isMobile()) {
                body.classList.remove('bb-sidebar-collapsed');
            } else if (localStorage.getItem(storageKey) === '1') {
                setCollapsed(true, false);
            }
        });

        // Apertura/cierre global de modales administrativos.
        // Algunas vistas usan data-modal-open sin tener un script propio;
        // centralizamos el comportamiento para que botones como "Agregar usuario" funcionen siempre.
        function abrirModal(modal) {
            if (!modal) return;
            modal.hidden = false;
            body.classList.add('modal-open');
            const firstField = modal.querySelector('input:not([type=hidden]), select, textarea, button.bb-modal-close');
            if (firstField && firstField.tagName !== 'BUTTON') {
                window.setTimeout(function () { firstField.focus(); }, 50);
            }
        }

        document.addEventListener('click', function (event) {
            const trigger = event.target.closest('[data-modal-open]');
            if (trigger) {
                const modalId = trigger.getAttribute('data-modal-open');
                const modal = document.getElementById(modalId);
                if (modal) {
                    event.preventDefault();
                    abrirModal(modal);
                }
                return;
            }

            const close = event.target.closest('[data-modal-close]');
            if (close) {
                const modal = close.closest('.bb-modal-overlay');
                if (modal) {
                    modal.hidden = true;
                    body.classList.remove('modal-open');
                }
                return;
            }

            if (event.target.classList && event.target.classList.contains('bb-modal-overlay')) {
                event.target.hidden = true;
                body.classList.remove('modal-open');
            }
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                document.querySelectorAll('.bb-modal-overlay:not([hidden])').forEach(function (modal) {
                    modal.hidden = true;
                });
                body.classList.remove('modal-open');
            }
        });

        const search = document.getElementById('adminSearch');
        if (search) {
            search.addEventListener('input', function () {
                const q = search.value.trim().toLowerCase();
                document.querySelectorAll('.data-table tbody tr').forEach(function (row) {
                    row.classList.toggle('admin-search-hidden', !!q && !row.innerText.toLowerCase().includes(q));
                });
                document.querySelectorAll('[data-searchable]').forEach(function (el) {
                    el.classList.toggle('admin-search-hidden', !!q && !el.innerText.toLowerCase().includes(q));
                });
            });
        }
    });
})();
