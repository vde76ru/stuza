<?php

/*
|--------------------------------------------------------------------------
| Путь: /var/www/www-root/data/www/stuj.ru/app/Http/Controllers/AdminController.php
| Описание: УЛУЧШЕННЫЙ контроллер админки с полным функционалом
|--------------------------------------------------------------------------
*/

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\UploadedFile;
use Intervention\Image\Facades\Image;

class AdminController extends Controller
{
    /**
     * Вход в админку
     * POST /api/admin/login
     */
    public function login(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string|min:6'
        ], [
            'email.required' => 'Email обязателен',
            'email.email' => 'Некорректный email',
            'password.required' => 'Пароль обязателен',
            'password.min' => 'Пароль должен быть не менее 6 символов'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Ошибка валидации',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'error' => 'Неверные учетные данные'
            ], 401);
        }

        $token = $user->createToken('admin-token')->plainTextToken;

        return response()->json([
            'message' => 'Успешный вход',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email
            ],
            'token' => $token
        ]);
    }

    /**
     * Выход из админки
     * POST /api/admin/logout
     */
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json([
            'message' => 'Успешный выход'
        ]);
    }

    /**
     * Получение данных текущего пользователя
     * GET /api/admin/me
     */
    public function me(Request $request): JsonResponse
    {
        return response()->json([
            'user' => [
                'id' => $request->user()->id,
                'name' => $request->user()->name,
                'email' => $request->user()->email,
                'created_at' => $request->user()->created_at
            ]
        ]);
    }

    /**
     * Изменение пароля
     * PUT /api/admin/change-password
     */
    public function changePassword(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'current_password' => 'required',
            'new_password' => 'required|string|min:6|confirmed'
        ], [
            'current_password.required' => 'Текущий пароль обязателен',
            'new_password.required' => 'Новый пароль обязателен',
            'new_password.min' => 'Новый пароль должен быть не менее 6 символов',
            'new_password.confirmed' => 'Подтверждение пароля не совпадает'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Ошибка валидации',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'error' => 'Неверный текущий пароль'
            ], 400);
        }

        $user->update([
            'password' => Hash::make($request->new_password)
        ]);

        return response()->json([
            'message' => 'Пароль успешно изменен'
        ]);
    }

    /**
     * Загрузка изображений (УЛУЧШЕННАЯ ВЕРСИЯ)
     * POST /api/admin/images/upload
     */
    public function uploadImage(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,webp|max:10240', // 10MB
            'type' => 'nullable|in:product,matryoshka_outer,matryoshka_inner',
            'resize_width' => 'nullable|integer|min:100|max:2000',
            'resize_height' => 'nullable|integer|min:100|max:2000'
        ], [
            'image.required' => 'Изображение обязательно',
            'image.image' => 'Файл должен быть изображением',
            'image.mimes' => 'Допустимые форматы: JPEG, PNG, JPG, GIF, WebP',
            'image.max' => 'Размер файла не должен превышать 10MB'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Ошибка валидации',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $image = $request->file('image');
            $type = $request->get('type', 'product');
            
            // Создание уникального имени файла
            $filename = time() . '_' . uniqid() . '.' . $image->getClientOriginalExtension();
            
            // Определение папки в зависимости от типа
            $folder = match($type) {
                'matryoshka_outer' => 'images/matryoshka/outer',
                'matryoshka_inner' => 'images/matryoshka/inner',
                default => 'images/products'
            };

            // Обработка изображения с помощью Intervention Image
            $processedImage = Image::make($image);

            // Изменение размера если указано
            if ($request->filled('resize_width') && $request->filled('resize_height')) {
                $processedImage->resize($request->resize_width, $request->resize_height, function ($constraint) {
                    $constraint->aspectRatio();
                    $constraint->upsize();
                });
            } else {
                // Автоматическое сжатие больших изображений
                if ($processedImage->width() > 1920 || $processedImage->height() > 1920) {
                    $processedImage->resize(1920, 1920, function ($constraint) {
                        $constraint->aspectRatio();
                        $constraint->upsize();
                    });
                }
            }

            // Оптимизация качества
            $processedImage->encode($image->getClientOriginalExtension(), 85);

            // Сохранение файла
            $path = $folder . '/' . $filename;
            Storage::disk('public')->put($path, $processedImage->stream());

            $url = Storage::disk('public')->url($path);

            return response()->json([
                'message' => 'Изображение успешно загружено',
                'image' => [
                    'filename' => $filename,
                    'path' => $path,
                    'url' => $url,
                    'type' => $type,
                    'size' => Storage::disk('public')->size($path),
                    'dimensions' => [
                        'width' => $processedImage->width(),
                        'height' => $processedImage->height()
                    ]
                ]
            ], 201);

        } catch (\Exception $e) {
            Log::error('Ошибка загрузки изображения: ' . $e->getMessage());
            return response()->json([
                'error' => 'Ошибка загрузки изображения'
            ], 500);
        }
    }

    /**
     * Получение списка изображений (УЛУЧШЕННАЯ ВЕРСИЯ)
     * GET /api/admin/images?type=product&page=1&per_page=20
     */
    public function getImages(Request $request): JsonResponse
    {
        try {
            $type = $request->get('type', 'product');
            $page = max(1, (int) $request->get('page', 1));
            $perPage = min(50, max(10, (int) $request->get('per_page', 20)));

            // Определение папки
            $folder = match($type) {
                'matryoshka_outer' => 'images/matryoshka/outer',
                'matryoshka_inner' => 'images/matryoshka/inner',
                default => 'images/products'
            };

            // Получение списка файлов
            $allFiles = collect(Storage::disk('public')->files($folder))
                ->filter(function ($file) {
                    $extension = strtolower(pathinfo($file, PATHINFO_EXTENSION));
                    return in_array($extension, ['jpg', 'jpeg', 'png', 'gif', 'webp']);
                })
                ->map(function ($file) {
                    $filename = basename($file);
                    $url = Storage::disk('public')->url($file);
                    $size = Storage::disk('public')->size($file);
                    $lastModified = Storage::disk('public')->lastModified($file);

                    return [
                        'filename' => $filename,
                        'path' => $file,
                        'url' => $url,
                        'size' => $size,
                        'size_human' => $this->formatBytes($size),
                        'last_modified' => date('Y-m-d H:i:s', $lastModified)
                    ];
                })
                ->sortByDesc('last_modified')
                ->values();

            // Пагинация
            $total = $allFiles->count();
            $offset = ($page - 1) * $perPage;
            $paginatedFiles = $allFiles->slice($offset, $perPage)->values();

            return response()->json([
                'images' => $paginatedFiles,
                'pagination' => [
                    'current_page' => $page,
                    'per_page' => $perPage,
                    'total' => $total,
                    'last_page' => ceil($total / $perPage),
                    'from' => $total > 0 ? $offset + 1 : 0,
                    'to' => min($offset + $perPage, $total)
                ],
                'type' => $type
            ]);

        } catch (\Exception $e) {
            Log::error('Ошибка получения изображений: ' . $e->getMessage());
            return response()->json([
                'error' => 'Ошибка получения изображений'
            ], 500);
        }
    }

    /**
     * Удаление изображения
     * DELETE /api/admin/images/{filename}
     */
    public function deleteImage(Request $request, string $filename): JsonResponse
    {
        $validator = Validator::make(['type' => $request->get('type')], [
            'type' => 'required|in:product,matryoshka_outer,matryoshka_inner'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => 'Тип изображения обязателен'
            ], 422);
        }

        try {
            $type = $request->get('type');
            
            // Определение папки
            $folder = match($type) {
                'matryoshka_outer' => 'images/matryoshka/outer',
                'matryoshka_inner' => 'images/matryoshka/inner',
                default => 'images/products'
            };

            $path = $folder . '/' . $filename;

            if (!Storage::disk('public')->exists($path)) {
                return response()->json([
                    'error' => 'Изображение не найдено'
                ], 404);
            }

            Storage::disk('public')->delete($path);

            return response()->json([
                'message' => 'Изображение успешно удалено'
            ]);

        } catch (\Exception $e) {
            Log::error('Ошибка удаления изображения: ' . $e->getMessage());
            return response()->json([
                'error' => 'Ошибка удаления изображения'
            ], 500);
        }
    }

    /**
     * Получение статистики системы
     * GET /api/admin/stats
     */
    public function getStats(): JsonResponse
    {
        try {
            $stats = [
                'products' => [
                    'total' => \App\Models\Product::count(),
                    'matryoshka' => \App\Models\Product::where('use_matryoshka', true)->count(),
                    'regular' => \App\Models\Product::where('use_matryoshka', false)->count()
                ],
                'categories' => \App\Models\Category::count(),
                'themes' => \App\Models\Theme::count(),
                'attributes' => \App\Models\Attribute::count(),
                'images' => [
                    'products' => count(Storage::disk('public')->files('images/products')),
                    'matryoshka_outer' => count(Storage::disk('public')->files('images/matryoshka/outer')),
                    'matryoshka_inner' => count(Storage::disk('public')->files('images/matryoshka/inner'))
                ],
                'storage' => [
                    'total_size' => $this->getDirectorySize('images'),
                    'total_size_human' => $this->formatBytes($this->getDirectorySize('images'))
                ]
            ];

            return response()->json($stats);

        } catch (\Exception $e) {
            Log::error('Ошибка получения статистики: ' . $e->getMessage());
            return response()->json([
                'error' => 'Ошибка получения статистики'
            ], 500);
        }
    }

    /**
     * Вспомогательные методы
     */
    private function formatBytes(int $bytes, int $precision = 2): string
    {
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];

        for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }

        return round($bytes, $precision) . ' ' . $units[$i];
    }

    private function getDirectorySize(string $directory): int
    {
        $size = 0;
        $files = Storage::disk('public')->allFiles($directory);
        
        foreach ($files as $file) {
            $size += Storage::disk('public')->size($file);
        }

        return $size;
    }
}