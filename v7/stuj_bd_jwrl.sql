-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Хост: localhost
-- Время создания: Июл 04 2025 г., 15:19
-- Версия сервера: 8.0.42-0ubuntu0.22.04.1
-- Версия PHP: 8.1.2-1ubuntu2.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `stuj_bd_jwrl`
--

-- --------------------------------------------------------

--
-- Структура таблицы `attributes`
--

CREATE TABLE `attributes` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `attributes`
--

INSERT INTO `attributes` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'агат', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(2, 'турмалин', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(3, 'аметист', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(4, 'хризолит', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(5, 'гранат', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(6, 'лазурит', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(7, 'малахит', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(8, 'янтарь', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(9, 'жемчуг', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(10, 'опал', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(11, 'топаз', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(12, 'изумруд', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(13, 'рубин', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(14, 'сапфир', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(15, 'алмаз', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(16, 'кварц', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(17, 'оникс', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(18, 'обсидиан', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(19, 'лунный камень', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(20, 'тигровый глаз', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(21, 'серебро', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(22, 'золото', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(23, 'латунь', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(24, 'медь', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(25, 'сталь', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(26, 'титан', '2025-07-03 11:51:48', '2025-07-03 11:51:48');

-- --------------------------------------------------------

--
-- Структура таблицы `categories`
--

CREATE TABLE `categories` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `created_at`, `updated_at`) VALUES
(1, 'Кольца', 'kolca', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(2, 'Браслеты', 'braslety', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(3, 'Серьги', 'sergi', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(4, 'Колье', 'kole', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(5, 'Подвески', 'podveski', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(6, 'Броши', 'brosi', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(7, 'Комплекты', 'komplekty', '2025-07-03 11:51:48', '2025-07-03 11:51:48');

-- --------------------------------------------------------

--
-- Структура таблицы `marketplace_maps`
--

CREATE TABLE `marketplace_maps` (
  `id` bigint UNSIGNED NOT NULL,
  `marketplace` enum('wildberries','ozon','yandex_market','flowwow') COLLATE utf8mb4_unicode_ci NOT NULL,
  `our_attr_id` bigint UNSIGNED NOT NULL,
  `marketplace_attr_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(2, '2025_01_01_000000_create_users_table', 1),
(3, '2025_01_01_000001_create_categories_table', 1),
(4, '2025_01_01_000002_create_themes_table', 1),
(5, '2025_01_01_000003_create_attributes_table', 1),
(6, '2025_01_01_000004_create_products_table', 1),
(7, '2025_01_01_000005_create_product_categories_table', 1),
(8, '2025_01_01_000006_create_product_attributes_table', 1),
(9, '2025_01_01_000007_create_marketplace_maps_table', 1),
(10, '2025_01_01_000008_create_quiz_rules_table', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'admin-token', '1b7166c2ae0c120d5b88aa8ed7ce4184f8a63ac88dc984a835b5d38e1937b5f9', '[\"*\"]', '2025-07-04 10:40:44', NULL, '2025-07-04 10:38:01', '2025-07-04 10:40:44'),
(2, 'App\\Models\\User', 1, 'admin-token', '2bff027f29a2876639d20f2786292fe58a163930dc0eb52dda003df5711f53cf', '[\"*\"]', '2025-07-04 12:19:05', NULL, '2025-07-04 10:42:36', '2025-07-04 12:19:05');

-- --------------------------------------------------------

--
-- Структура таблицы `products`
--

CREATE TABLE `products` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `use_matryoshka` tinyint(1) NOT NULL DEFAULT '0',
  `image_layers` json DEFAULT NULL,
  `gallery_images` json DEFAULT NULL,
  `theme_id` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `product_attributes`
--

CREATE TABLE `product_attributes` (
  `product_id` bigint UNSIGNED NOT NULL,
  `attribute_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `product_categories`
--

CREATE TABLE `product_categories` (
  `product_id` bigint UNSIGNED NOT NULL,
  `category_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `quiz_rules`
--

CREATE TABLE `quiz_rules` (
  `id` bigint UNSIGNED NOT NULL,
  `month` int NOT NULL,
  `day` int NOT NULL,
  `hour_start` int NOT NULL,
  `hour_end` int NOT NULL,
  `stones` json NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `themes`
--

CREATE TABLE `themes` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `themes`
--

INSERT INTO `themes` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Минимализм', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(2, 'Готика', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(3, 'Винтаж', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(4, 'Бохо', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(5, 'Классика', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(6, 'Модерн', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(7, 'Этника', '2025-07-03 11:51:48', '2025-07-03 11:51:48'),
(8, 'Романтика', '2025-07-03 11:51:48', '2025-07-03 11:51:48');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@stuj.ru', NULL, '$2y$12$23Z7sGDAalrrdPMMrMxbLebwYhTwbz5xeJwbG5Jz.gbpjmBeK1ZC.', NULL, '2025-07-03 11:51:48', '2025-07-03 11:51:48');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `attributes`
--
ALTER TABLE `attributes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `attributes_name_index` (`name`);

--
-- Индексы таблицы `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`),
  ADD KEY `categories_slug_index` (`slug`);

--
-- Индексы таблицы `marketplace_maps`
--
ALTER TABLE `marketplace_maps`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `marketplace_maps_marketplace_our_attr_id_unique` (`marketplace`,`our_attr_id`),
  ADD KEY `marketplace_maps_marketplace_index` (`marketplace`),
  ADD KEY `marketplace_maps_our_attr_id_index` (`our_attr_id`);

--
-- Индексы таблицы `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Индексы таблицы `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_slug_unique` (`slug`),
  ADD KEY `products_slug_index` (`slug`),
  ADD KEY `products_theme_id_index` (`theme_id`),
  ADD KEY `products_price_index` (`price`),
  ADD KEY `products_use_matryoshka_index` (`use_matryoshka`);

--
-- Индексы таблицы `product_attributes`
--
ALTER TABLE `product_attributes`
  ADD PRIMARY KEY (`product_id`,`attribute_id`),
  ADD KEY `product_attributes_product_id_index` (`product_id`),
  ADD KEY `product_attributes_attribute_id_index` (`attribute_id`);

--
-- Индексы таблицы `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`product_id`,`category_id`),
  ADD KEY `product_categories_product_id_index` (`product_id`),
  ADD KEY `product_categories_category_id_index` (`category_id`);

--
-- Индексы таблицы `quiz_rules`
--
ALTER TABLE `quiz_rules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quiz_rules_month_day_index` (`month`,`day`),
  ADD KEY `quiz_rules_hour_start_hour_end_index` (`hour_start`,`hour_end`);

--
-- Индексы таблицы `themes`
--
ALTER TABLE `themes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `themes_name_index` (`name`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `attributes`
--
ALTER TABLE `attributes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT для таблицы `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `marketplace_maps`
--
ALTER TABLE `marketplace_maps`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `quiz_rules`
--
ALTER TABLE `quiz_rules`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `themes`
--
ALTER TABLE `themes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `marketplace_maps`
--
ALTER TABLE `marketplace_maps`
  ADD CONSTRAINT `marketplace_maps_our_attr_id_foreign` FOREIGN KEY (`our_attr_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_theme_id_foreign` FOREIGN KEY (`theme_id`) REFERENCES `themes` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `product_attributes`
--
ALTER TABLE `product_attributes`
  ADD CONSTRAINT `product_attributes_attribute_id_foreign` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_attributes_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `product_categories`
--
ALTER TABLE `product_categories`
  ADD CONSTRAINT `product_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_categories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
