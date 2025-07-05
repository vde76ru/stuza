#!/bin/bash

# =============================================================================
# СКРИПТ ПЕРЕСБОРКИ ПРОЕКТА "СТУЖА"
# =============================================================================

echo "🚀 НАЧИНАЕМ ПЕРЕСБОРКУ ПРОЕКТА СТУЖА..."

# Переходим в корень проекта
cd /var/www/www-root/data/www/stuj.ru

echo "📁 Текущая директория: $(pwd)"

# =============================================================================
# ШАГ 1: КРИТИЧЕСКОЕ ИСПРАВЛЕНИЕ CORS MIDDLEWARE
# =============================================================================

echo ""
echo "🔧 ШАГ 1: ИСПРАВЛЕНИЕ КРИТИЧЕСКОЙ ОШИБКИ CORS..."

# Создаем резервную копию
cp app/Http/Kernel.php app/Http/Kernel.php.backup.$(date +%Y%m%d_%H%M%S)

# Исправляем CORS middleware
sed -i 's/\\Fruitcake\\Cors\\HandleCors::class/\\Illuminate\\Http\\Middleware\\HandleCors::class/g' app/Http/Kernel.php

echo "✅ CORS middleware исправлен"

# Проверяем синтаксис
echo "🔍 Проверяем синтаксис исправленного файла..."
if php -l app/Http/Kernel.php; then
    echo "✅ Синтаксис Kernel.php корректен"
else
    echo "❌ ОШИБКА в синтаксисе Kernel.php! Восстанавливаем из резервной копии..."
    cp app/Http/Kernel.php.backup.* app/Http/Kernel.php
    exit 1
fi

# =============================================================================
# ШАГ 2: ОЧИСТКА КЭШЕЙ LARAVEL
# =============================================================================

echo ""
echo "🧹 ШАГ 2: ОЧИСТКА КЭШЕЙ LARAVEL..."

# Очищаем все кэши Laravel
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

# Очищаем кэш Composer autoload
composer dump-autoload

echo "✅ Кэши Laravel очищены"

# =============================================================================
# ШАГ 3: ПРОВЕРКА И УСТАНОВКА ЗАВИСИМОСТЕЙ BACKEND
# =============================================================================

echo ""
echo "📦 ШАГ 3: ПРОВЕРКА ЗАВИСИМОСТЕЙ BACKEND..."

# Проверяем composer.json
if [ -f "composer.json" ]; then
    echo "📄 composer.json найден"
    
    # Обновляем зависимости
    echo "🔄 Обновляем Composer зависимости..."
    composer install --no-dev --optimize-autoloader
    
    echo "✅ Composer зависимости установлены"
else
    echo "❌ composer.json не найден!"
    exit 1
fi

# =============================================================================
# ШАГ 4: ПРОВЕРКА И УСТАНОВКА ЗАВИСИМОСТЕЙ FRONTEND
# =============================================================================

echo ""
echo "🎨 ШАГ 4: ПРОВЕРКА ЗАВИСИМОСТЕЙ FRONTEND..."

# Проверяем package.json
if [ -f "package.json" ]; then
    echo "📄 package.json найден"
    
    # Проверяем наличие node_modules
    if [ ! -d "node_modules" ] || [ ! -f "node_modules/.package-lock.json" ]; then
        echo "🔄 Устанавливаем NPM зависимости..."
        npm install
    else
        echo "📦 node_modules уже существует, обновляем..."
        npm ci
    fi
    
    echo "✅ NPM зависимости установлены"
else
    echo "❌ package.json не найден!"
    exit 1
fi

# =============================================================================
# ШАГ 5: СБОРКА FRONTEND (VUE + VITE)
# =============================================================================

echo ""
echo "🏗️ ШАГ 5: СБОРКА FRONTEND..."

# Проверяем наличие vite.config.js
if [ -f "vite.config.js" ]; then
    echo "⚡ Найден vite.config.js, используем Vite..."
    
    # Сборка для продакшена
    npm run build
    
    if [ $? -eq 0 ]; then
        echo "✅ Frontend собран успешно"
    else
        echo "❌ ОШИБКА при сборке frontend!"
        exit 1
    fi
else
    echo "❌ vite.config.js не найден!"
    exit 1
fi


# =============================================================================
# ШАГ 7: ПРОВЕРКА КОНФИГУРАЦИИ
# =============================================================================

echo ""
echo "⚙️ ШАГ 7: ПРОВЕРКА КОНФИГУРАЦИИ..."

# Проверяем внешний .env файл
if [ -f "/etc/stuj/.env" ]; then
    echo "✅ Внешний .env файл найден: /etc/stuj/.env"
else
    echo "⚠️ Внешний .env файл не найден в /etc/stuj/.env"
    
    # Проверяем локальный .env
    if [ -f ".env" ]; then
        echo "✅ Локальный .env файл найден"
    else
        echo "❌ .env файл не найден! Копируем из примера..."
        if [ -f ".env.example" ]; then
            cp .env.example .env
            echo "⚠️ Скопирован .env.example в .env - НУЖНО НАСТРОИТЬ!"
        fi
    fi
fi

# Генерируем ключ приложения если нужно
if ! grep -q "APP_KEY=base64:" .env 2>/dev/null && ! grep -q "APP_KEY=base64:" /etc/stuj/.env 2>/dev/null; then
    echo "🔑 Генерируем ключ приложения..."
    php artisan key:generate
fi

echo "✅ Конфигурация проверена"

# =============================================================================
# ШАГ 8: МИГРАЦИИ БАЗЫ ДАННЫХ
# =============================================================================

echo ""
echo "🗄️ ШАГ 8: ПРОВЕРКА БАЗЫ ДАННЫХ..."

# Проверяем соединение с БД
echo "🔍 Проверяем соединение с базой данных..."
if php artisan migrate:status >/dev/null 2>&1; then
    echo "✅ Соединение с БД установлено"
    
    # Запускаем миграции
    echo "🔄 Запускаем миграции..."
    php artisan migrate --force
    
    echo "✅ Миграции выполнены"
else
    echo "⚠️ Не удается подключиться к базе данных"
    echo "   Проверьте настройки БД в .env файле"
fi

# =============================================================================
# ШАГ 9: ПЕРЕЗАПУСК СЕРВИСОВ (ЕСЛИ НУЖНО)
# =============================================================================

echo ""
echo "🔄 ШАГ 9: ПЕРЕЗАПУСК СЕРВИСОВ..."

# Перезапускаем PHP-FPM (для ISPmanager)
if systemctl is-active --quiet php8.1-fpm; then
    echo "🔄 Перезапускаем PHP-FPM..."
    systemctl reload php8.1-fpm
    echo "✅ PHP-FPM перезапущен"
fi

# Перезапускаем nginx
if systemctl is-active --quiet nginx; then
    echo "🔄 Перезапускаем Nginx..."
    systemctl reload nginx
    echo "✅ Nginx перезапущен"
fi

# =============================================================================
# ШАГ 10: ФИНАЛЬНАЯ ПРОВЕРКА
# =============================================================================

echo ""
echo "🧪 ШАГ 10: ФИНАЛЬНАЯ ПРОВЕРКА..."

# Проверяем доступность сайта
echo "🌐 Проверяем доступность сайта..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://stuj.ru/ || echo "000")

case $HTTP_STATUS in
    200)
        echo "✅ УСПЕХ! Сайт доступен (HTTP 200)"
        ;;
    500)
        echo "❌ Ошибка сервера (HTTP 500) - проверьте логи"
        echo "📋 Последние ошибки из лога:"
        tail -5 storage/logs/laravel.log 2>/dev/null || echo "   Лог недоступен"
        ;;
    404)
        echo "⚠️ Страница не найдена (HTTP 404) - проверьте роуты"
        ;;
    000)
        echo "❌ Сайт недоступен - проверьте веб-сервер"
        ;;
    *)
        echo "⚠️ Неожиданный статус: HTTP $HTTP_STATUS"
        ;;
esac

# Проверяем API
echo "🔌 Проверяем API..."
API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://stuj.ru/api/catalog || echo "000")
if [ "$API_STATUS" = "200" ]; then
    echo "✅ API доступен"
else
    echo "⚠️ API недоступен (HTTP $API_STATUS)"
fi

# =============================================================================
# ЗАВЕРШЕНИЕ
# =============================================================================

echo ""
echo "🎉 ПЕРЕСБОРКА ЗАВЕРШЕНА!"
echo ""
echo "📊 РЕЗУЛЬТАТЫ:"
echo "   🌐 Основной сайт: HTTP $HTTP_STATUS"
echo "   🔌 API статус: HTTP $API_STATUS"
echo "   📁 Проект: /var/www/www-root/data/www/stuj.ru"
echo ""

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ ВСЕ ГОТОВО! Сайт работает корректно."
    echo ""
    echo "🔗 Ссылки для проверки:"
    echo "   📱 Сайт: http://stuj.ru/"
    echo "   ⚙️ Админка: http://stuj.ru/admin"
    echo "   🔌 API каталог: http://stuj.ru/api/catalog"
else
    echo "❌ ТРЕБУЕТСЯ ДОПОЛНИТЕЛЬНАЯ НАСТРОЙКА"
    echo ""
    echo "🔍 Для диагностики выполните:"
    echo "   tail -20 storage/logs/laravel.log"
    echo "   php artisan route:list"
    echo "   php artisan config:show"
fi

echo ""
echo "📝 Логи пересборки сохранены в: rebuild.log"