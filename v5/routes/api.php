<?php
// routes/api.php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
| Здесь регистрируются API маршруты для приложения. Эти маршруты
| загружаются RouteServiceProvider в группе middleware "api".
*/

// Публичные API эндпоинты
Route::prefix('v1')->group(function () {
    // Каталог товаров
    Route::get('/catalog', [App\Http\Controllers\PublicController::class, 'catalog']);
    
    // Детали товара
    Route::get('/product/{slug}', [App\Http\Controllers\PublicController::class, 'product']);
    
    // Квиз подбора
    Route::post('/quiz', [App\Http\Controllers\QuizController::class, 'calculate']);
});

// Админские API эндпоинты (требуют авторизации)
Route::prefix('admin')->group(function () {
    // Вход в админку
    Route::post('/login', [App\Http\Controllers\AdminController::class, 'login']);
    
    // Защищенные маршруты
    Route::middleware(['auth:sanctum', 'admin'])->group(function () {
        // CRUD для товаров
        Route::apiResource('products', App\Http\Controllers\ProductController::class);
        
        // CRUD для категорий
        Route::apiResource('categories', App\Http\Controllers\CategoryController::class);
        
        // CRUD для тем
        Route::apiResource('themes', App\Http\Controllers\ThemeController::class);
        
        // CRUD для атрибутов
        Route::apiResource('attributes', App\Http\Controllers\AttributeController::class);
        
        // CRUD для правил квиза
        Route::apiResource('quiz-rules', App\Http\Controllers\QuizRuleController::class);
        
        // CRUD для маппинга маркетплейсов
        Route::apiResource('marketplace-maps', App\Http\Controllers\MarketplaceMappingController::class);
    });
});

// Служебные API эндпоинты
Route::prefix('marketplace')->group(function () {
    // Синхронизация с маркетплейсами
    Route::post('/sync', [App\Http\Controllers\MarketplaceController::class, 'sync']);
});
