<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Beauty Boost — belleza, maquillaje y cuidado personal.">
    <title>Beauty Boost | Tu belleza, tu brillo</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Vista/css/style.css?v=20261006">
</head>
<body class="portada-page">
    <main class="hero-container">
        <div class="welcome-carousel" aria-hidden="true">
            <div class="welcome-slide active" style="background-image:url('https://res.cloudinary.com/rzxmfg9i/image/upload/v1789523161/maquillaje1.png');"></div>
            <div class="welcome-slide" style="background-image:url('https://res.cloudinary.com/rzxmfg9i/image/upload/v1789523586/maquillaje3.png');"></div>
            <div class="welcome-slide" style="background-image:url('https://res.cloudinary.com/rzxmfg9i/image/upload/v1789523164/maquillaje0.png');"></div>
        </div>
        <div class="welcome-overlay">
            <section class="welcome-content" aria-label="Bienvenida a Beauty Boost">
                <div class="welcome-brand">
                    <span class="welcome-eyebrow">BELLEZA · MAQUILLAJE · CUIDADO</span>
                    <div class="welcome-logo">
                        <img src="https://res.cloudinary.com/rzxmfg9i/image/upload/v1789523154/logo.png" alt="Beauty Boost">
                    </div>
                    <h1>BEAUTY BOOST</h1>
                    <p>Realza tu brillo <span>natural</span></p>
                    <div class="welcome-divider" aria-hidden="true"><i></i><b>BB</b><i></i></div>
                    <a href="${pageContext.request.contextPath}/indexServlet" class="portada-explore-btn"><span>EXPLORAR TIENDA</span><span class="arrow" aria-hidden="true">→</span></a>
                </div>
            </section>
        </div>
    </main>
    <script src="${pageContext.request.contextPath}/Vista/js/portada-carousel.js?v=20261006"></script>
</body>
</html>
