<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    
    <title>{{ config('app.name', 'Стужа') }}</title>
    
    <!-- SEO метатеги -->
    <meta name="description" content="Уникальные украшения с натуральными камнями. Астрологический подбор украшений по дате рождения.">
    <meta name="keywords" content="украшения, камни, астрология, кольца, серьги, подвески, натуральные камни">
    <meta name="author" content="Стужа">
    
    <!-- Open Graph -->
    <meta property="og:title" content="Стужа - Украшения с натуральными камнями">
    <meta property="og:description" content="Подберите идеальное украшение с помощью астрологических расчетов">
    <meta property="og:image" content="{{ asset('images/og-image.jpg') }}">
    <meta property="og:url" content="{{ url('/') }}">
    <meta property="og:type" content="website">
    
    <!-- Favicon -->
    <link rel="icon" type="image/png" href="{{ asset('favicon.png') }}">
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Vite Assets -->
    @vite(['client/src/main.js'])
</head>
<body class="antialiased">
    <div id="app"></div>
    
    <!-- Preloader -->
    <div id="preloader" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: #121212; z-index: 9999; display: flex; align-items: center; justify-content: center;">
        <div style="color: #e63946; font-size: 24px; font-weight: bold;">Стужа</div>
    </div>
    
    <script>
        // Убираем прелоадер когда Vue загрузится
        window.addEventListener('load', function() {
            setTimeout(function() {
                const preloader = document.getElementById('preloader');
                if (preloader) {
                    preloader.style.opacity = '0';
                    setTimeout(() => preloader.remove(), 300);
                }
            }, 500);
        });
    </script>
</body>
</html>
