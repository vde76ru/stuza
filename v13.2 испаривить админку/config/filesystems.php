<?php
use Illuminate\Support\Str;
return [
    'default' => env('FILESYSTEM_DISK', 'local'),
    
    'disks' => [
        'local' => [
            'driver' => 'local',
            'root' => storage_path('app'),
            'throw' => false,
        ],
        
        'public' => [
            'driver' => 'local',
            'root' => storage_path('app/public'),
            'url' => env('APP_URL').'/storage',
            'visibility' => 'public',
            'throw' => false,
        ],
    ],
    
    'links' => [
        public_path('storage') => storage_path('app/public'),
    ],
];