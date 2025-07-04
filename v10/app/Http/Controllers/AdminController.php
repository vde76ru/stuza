<?php

/*
|--------------------------------------------------------------------------
| Путь: /var/www/www-root/data/www/stuj.ru/app/Http/Controllers/AdminController.php
| Описание: ИСПРАВЛЕННЫЙ контроллер для админки со всеми методами
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
        return response()->json(['message' => 'Успешный выход']);
    }

    /**
     * ИСПРАВЛЕННАЯ загрузка изображений
     * POST /api/admin/images/upload
     */
    public function uploadImage(Request $request): JsonResponse
    {
        Log::info('Запрос на загрузку изображения получен');
        
        $validator = Validator::make($request->all(), [
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,webp|max:5120'
        ], [
            'image.required' => 'Изображение обязательно',
            'image.image' => 'Файл должен быть изображением',
            'image.mimes' => 'Поддерживаемые форматы: JPEG, PNG, JPG, GIF, WebP',
            'image.max' => 'Максимальный размер файла: 5MB'
        ]);

        if ($validator->fails()) {
            Log::error('Ошибка валидации при загрузке изображения', $validator->errors()->toArray());
            return response()->json([
                'error' => 'Ошибка валидации',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $image = $request->file('image');
            Log::info('Файл получен: ' . $image->getClientOriginalName());
            
            // Создание уникального имени
            $filename = time() . '_' . uniqid() . '.' . $image->getClientOriginalExtension();
            Log::info('Сгенерирован filename: ' . $filename);
            
            // Использование Laravel Storage
            $path = $image->storeAs('public/images/products', $filename);
            Log::info('Файл сохранен по пути: ' . $path);
            
            // Правильный URL
            $url = Storage::url('images/products/' . $filename);
            Log::info('URL для доступа: ' . $url);
            
            return response()->json([
                'message' => 'Изображение успешно загружено',
                'url' => $url,
                'filename' => $filename,
                'path' => $path
            ]);
            
        } catch (\Exception $e) {
            Log::error('Ошибка загрузки изображения: ' . $e->getMessage());
            Log::error('Stack trace: ' . $e->getTraceAsString());
            
            return response()->json([
                'error' => 'Ошибка загрузки файла',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * ИСПРАВЛЕННОЕ получение списка изображений
     * GET /api/admin/images
     */
    public function getImages(Request $request): JsonResponse
    {
        try {
            Log::info('Запрос списка изображений');
            
            // Правильный путь к storage
            $storagePath = 'public/images/products';
            
            if (!Storage::exists($storagePath)) {
                Log::info('Папка с изображениями не существует, создаем...');
                Storage::makeDirectory($storagePath);
            }
            
            $files = Storage::files($storagePath);
            Log::info('Найдено файлов: ' . count($files));
            
            $images = [];
            
            foreach ($files as $file) {
                $filename = basename($file);
                
                // Проверяем, что это изображение
                $extension = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
                if (in_array($extension, ['jpg', 'jpeg', 'png', 'gif', 'webp'])) {
                    $images[] = [
                        'filename' => $filename,
                        'url' => Storage::url('images/products/' . $filename),
                        'size' => Storage::size($file),
                        'created' => date('Y-m-d H:i:s', Storage::lastModified($file))
                    ];
                }
            }
            
            // Сортировка по дате (новые первыми)
            usort($images, function($a, $b) {
                return strtotime($b['created']) - strtotime($a['created']);
            });
            
            Log::info('Отправляем ' . count($images) . ' изображений');
            
            return response()->json([
                'images' => $images
            ]);
            
        } catch (\Exception $e) {
            Log::error('Ошибка получения изображений: ' . $e->getMessage());
            
            return response()->json([
                'error' => 'Ошибка получения изображений',
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Получение информации о пользователе
     * GET /api/admin/me
     */
    public function me(Request $request): JsonResponse
    {
        return response()->json([
            'user' => [
                'id' => $request->user()->id,
                'name' => $request->user()->name,
                'email' => $request->user()->email
            ]
        ]);
    }

    /**
     * Смена пароля
     * PUT /api/admin/change-password
     */
    public function changePassword(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'current_password' => 'required',
            'new_password' => 'required|min:6|confirmed'
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
            ], 401);
        }

        $user->update([
            'password' => Hash::make($request->new_password)
        ]);

        return response()->json([
            'message' => 'Пароль успешно изменен'
        ]);
    }
}