<template>
  <div class="min-h-screen bg-gray-900 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Заголовок -->
      <div class="flex justify-between items-center mb-8">
        <div>
          <h1 class="text-3xl font-bold text-white">
            {{ mode === 'edit' ? 'Редактировать товар' : 'Создать новый товар' }}
          </h1>
          <p class="text-gray-400 mt-1">Заполните информацию о товаре</p>
        </div>
        
        <router-link 
          to="/admin" 
          class="bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg transition-colors"
        >
          ← Назад к админке
        </router-link>
      </div>

      <!-- Форма создания/редактирования товара -->
      <form @submit.prevent="saveProduct" class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        
        <!-- Левая колонка: Основная информация -->
        <div class="lg:col-span-2 space-y-8">
          
          <!-- Основная информация -->
          <div class="bg-gray-800 rounded-lg p-6">
            <h2 class="text-xl font-semibold text-white mb-4">Основная информация</h2>
            
            <div class="space-y-6">
              <div>
                <label class="block text-sm font-medium text-white mb-2">
                  Название товара *
                </label>
                <input
                  v-model="form.name"
                  type="text"
                  required
                  class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                  placeholder="Например: Кольцо с агатом"
                >
              </div>

              <div>
                <label class="block text-sm font-medium text-white mb-2">
                  Описание *
                </label>
                <textarea
                  v-model="form.description"
                  required
                  rows="4"
                  class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                  placeholder="Подробное описание товара..."
                ></textarea>
              </div>

              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-white mb-2">
                    Цена (рубли) *
                  </label>
                  <input
                    v-model.number="form.price"
                    type="number"
                    required
                    min="0"
                    step="0.01"
                    class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                    placeholder="2500.00"
                  >
                </div>

                <div>
                  <label class="block text-sm font-medium text-white mb-2">
                    Артикул товара *
                  </label>
                  <div class="flex space-x-2">
                    <input
                      v-model="form.sku"
                      type="text"
                      required
                      class="flex-1 bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                      placeholder="STJ-123456-ABC"
                    >
                    <button
                      type="button"
                      @click="generateSKU()"
                      class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg text-sm transition-colors"
                    >
                      Генерировать
                    </button>
                  </div>
                </div>
              </div>

              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-white mb-2">
                    Количество на складе
                  </label>
                  <input
                    v-model.number="form.stock_quantity"
                    type="number"
                    min="0"
                    class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                    placeholder="0"
                  >
                </div>

                <div>
                  <label class="block text-sm font-medium text-white mb-2">
                    Вес (граммы)
                  </label>
                  <input
                    v-model.number="form.weight"
                    type="number"
                    min="0"
                    step="0.1"
                    class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                    placeholder="0.0"
                  >
                </div>
              </div>
            </div>
          </div>

          <!-- Категории и свойства (РАСШИРЕННАЯ ВЕРСИЯ) -->
          <div class="bg-gray-800 rounded-lg p-6">
            <h2 class="text-xl font-semibold text-white mb-4">Категории и свойства</h2>
            
            <div class="space-y-6">
              
              <!-- Тема -->
              <div>
                <div class="flex items-center justify-between mb-3">
                  <label class="block text-sm font-medium text-white">
                    Тема *
                  </label>
                  <button 
                    type="button" 
                    @click="showQuickAdd('theme')"
                    class="text-blue-400 hover:text-blue-300 text-sm"
                  >
                    + Добавить тему
                  </button>
                </div>
                <select
                  v-model="form.theme_id"
                  required
                  class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white focus:border-blue-500 focus:outline-none"
                >
                  <option value="">Выберите тему</option>
                  <option v-for="theme in themes" :key="theme.id" :value="theme.id">
                    {{ theme.name }}
                  </option>
                </select>
              </div>

              <!-- Категории и подкатегории (УЛУЧШЕННАЯ ВЕРСИЯ) -->
              <div>
                <div class="flex items-center justify-between mb-3">
                  <label class="block text-sm font-medium text-white">
                    Категории и подкатегории *
                  </label>
                  <button 
                    type="button" 
                    @click="showQuickAdd('category')"
                    class="text-blue-400 hover:text-blue-300 text-sm"
                  >
                    + Добавить категорию
                  </button>
                </div>
                
                <!-- Дерево категорий для выбора -->
                <div class="max-h-60 overflow-y-auto bg-gray-700 border border-gray-600 rounded-lg p-3">
                  <div v-for="category in categoryTree" :key="category.id" class="mb-3">
                    <!-- Корневая категория -->
                    <label class="flex items-center mb-2">
                      <input
                        v-model="form.category_ids"
                        :value="category.id"
                        type="checkbox"
                        class="mr-3 rounded border-gray-600 bg-gray-700 text-blue-600 focus:ring-blue-500"
                      >
                      <span class="text-white font-medium">{{ category.name }}</span>
                      <span class="ml-2 bg-gray-600 text-gray-300 px-2 py-1 rounded text-xs">
                        {{ category.products_count || 0 }} товаров
                      </span>
                    </label>
                    
                    <!-- Подкатегории -->
                    <div v-if="category.children && category.children.length" class="ml-6 space-y-1">
                      <label 
                        v-for="child in category.children" 
                        :key="child.id" 
                        class="flex items-center"
                      >
                        <input
                          v-model="form.category_ids"
                          :value="child.id"
                          type="checkbox"
                          class="mr-3 rounded border-gray-600 bg-gray-700 text-blue-600 focus:ring-blue-500"
                        >
                        <span class="text-gray-300">→ {{ child.name }}</span>
                        <span class="ml-2 bg-gray-600 text-gray-300 px-2 py-1 rounded text-xs">
                          {{ child.products_count || 0 }} товаров
                        </span>
                      </label>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Атрибуты со значениями (НОВАЯ ВЕРСИЯ) -->
              <div>
                <div class="flex items-center justify-between mb-3">
                  <label class="block text-sm font-medium text-white">
                    Атрибуты (камни, металлы, размеры)
                  </label>
                  <button 
                    type="button" 
                    @click="showQuickAdd('attribute')"
                    class="text-blue-400 hover:text-blue-300 text-sm"
                  >
                    + Добавить атрибут
                  </button>
                </div>
                
                <!-- Список атрибутов со значениями -->
                <div class="space-y-4">
                  <div 
                    v-for="attribute in attributesWithValues" 
                    :key="attribute.id"
                    class="bg-gray-700 border border-gray-600 rounded-lg p-4"
                  >
                    <div class="flex items-center justify-between mb-3">
                      <h4 class="text-white font-medium">
                        {{ attribute.name }}
                        <span v-if="attribute.is_stone" class="ml-2 bg-purple-600 text-white px-2 py-1 rounded text-xs">
                          Камень
                        </span>
                      </h4>
                      
                      <span class="text-gray-400 text-sm">
                        {{ attribute.values.length }} значений
                      </span>
                    </div>
                    
                    <!-- Существующие значения -->
                    <div v-if="attribute.values.length" class="mb-3">
                      <p class="text-gray-300 text-sm mb-2">Выберите подходящие значения:</p>
                      <div class="flex flex-wrap gap-2">
                        <label 
                          v-for="value in attribute.values" 
                          :key="value.id"
                          class="flex items-center bg-gray-600 rounded px-3 py-2 cursor-pointer hover:bg-gray-500 transition-colors"
                          :class="{ 'bg-blue-600 hover:bg-blue-500': isAttributeValueSelected(attribute.id, value.id) }"
                        >
                          <input
                            type="checkbox"
                            :checked="isAttributeValueSelected(attribute.id, value.id)"
                            @change="toggleAttributeValue(attribute.id, value.id)"
                            class="sr-only"
                          >
                          <span class="text-white text-sm">{{ value.value }}</span>
                          <span v-if="!value.is_active" class="ml-2 text-red-400 text-xs">(неакт.)</span>
                        </label>
                      </div>
                    </div>
                    
                    <!-- Кастомное значение -->
                    <div>
                      <p class="text-gray-300 text-sm mb-2">Или введите свое значение:</p>
                      <input
                        :value="form.attribute_values[attribute.id]?.customValue || ''"
                        @input="addCustomAttributeValue(attribute.id, $event.target.value)"
                        type="text"
                        class="w-full bg-gray-600 border border-gray-500 rounded px-3 py-2 text-white text-sm"
                        :placeholder="`Например: для '${attribute.name}' - новое значение`"
                      >
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Эффект матрёшки -->
          <div class="bg-gray-800 rounded-lg p-6">
            <h2 class="text-xl font-semibold text-white mb-4">Эффект матрёшки</h2>
            
            <div class="space-y-4">
              <label class="flex items-center">
                <input
                  v-model="form.use_matryoshka"
                  type="checkbox"
                  class="mr-3 rounded border-gray-600 bg-gray-700 text-blue-600 focus:ring-blue-500"
                >
                <span class="text-white font-medium">Использовать эффект матрёшки</span>
              </label>

              <div v-if="form.use_matryoshka" class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-white mb-2">
                    Внешний слой (URL изображения)
                  </label>
                  <input
                    v-model="form.image_layers.outer"
                    type="url"
                    class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                    placeholder="URL внешнего слоя"
                  >
                </div>
                <div>
                  <label class="block text-sm font-medium text-white mb-2">
                    Внутренний слой (URL изображения)
                  </label>
                  <input
                    v-model="form.image_layers.inner"
                    type="url"
                    class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                    placeholder="URL внутреннего слоя"
                  >
                </div>
                
                <!-- Предпросмотр матрёшки -->
                <div v-if="form.image_layers.outer || form.image_layers.inner" class="border border-gray-600 rounded-lg p-4">
                  <p class="text-white text-sm mb-2">Предпросмотр матрёшки:</p>
                  <div class="flex space-x-4">
                    <div v-if="form.image_layers.outer" class="text-center">
                      <img :src="form.image_layers.outer" class="w-24 h-24 object-cover rounded mb-2">
                      <p class="text-gray-400 text-xs">Внешний слой</p>
                    </div>
                    <div v-if="form.image_layers.inner" class="text-center">
                      <img :src="form.image_layers.inner" class="w-24 h-24 object-cover rounded mb-2">
                      <p class="text-gray-400 text-xs">Внутренний слой</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Изображения товара -->
          <div class="bg-gray-800 rounded-lg p-6">
            <h2 class="text-xl font-semibold text-white mb-4">Галерея изображений</h2>
            
            <MultiImagePicker
              v-model="form.gallery_images"
            />
          </div>

          <!-- Физические характеристики -->
          <div class="bg-gray-800 rounded-lg p-6">
            <h2 class="text-xl font-semibold text-white mb-4">Физические характеристики</h2>
            
            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-white mb-2">
                  Размеры (см)
                </label>
                <div class="grid grid-cols-3 gap-3">
                  <div>
                    <input
                      v-model.number="form.dimensions.length"
                      type="number"
                      min="0"
                      step="0.1"
                      class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white text-sm"
                      placeholder="Длина"
                    >
                    <p class="text-gray-400 text-xs mt-1">Длина</p>
                  </div>
                  <div>
                    <input
                      v-model.number="form.dimensions.width"
                      type="number"
                      min="0"
                      step="0.1"
                      class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white text-sm"
                      placeholder="Ширина"
                    >
                    <p class="text-gray-400 text-xs mt-1">Ширина</p>
                  </div>
                  <div>
                    <input
                      v-model.number="form.dimensions.height"
                      type="number"
                      min="0"
                      step="0.1"
                      class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white text-sm"
                      placeholder="Высота"
                    >
                    <p class="text-gray-400 text-xs mt-1">Высота</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- SEO настройки -->
          <div class="bg-gray-800 rounded-lg p-6">
            <h2 class="text-xl font-semibold text-white mb-4">SEO настройки</h2>
            
            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-white mb-2">
                  SEO заголовок (meta title)
                </label>
                <input
                  v-model="form.meta_title"
                  type="text"
                  maxlength="60"
                  class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                  placeholder="Автоматически генерируется из названия"
                >
                <p class="text-gray-400 text-xs mt-1">
                  {{ form.meta_title?.length || 0 }}/60 символов
                </p>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-white mb-2">
                  Мета описание (meta description)
                </label>
                <textarea
                  v-model="form.meta_description"
                  rows="3"
                  maxlength="160"
                  class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:border-blue-500 focus:outline-none"
                  placeholder="Автоматически генерируется из описания"
                ></textarea>
                <p class="text-gray-400 text-xs mt-1">
                  {{ form.meta_description?.length || 0 }}/160 символов
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Правая колонка: Предварительный просмотр -->
        <div>
          <div class="bg-gray-800 rounded-lg p-6 sticky top-6">
            <h2 class="text-xl font-semibold text-white mb-4">Предварительный просмотр</h2>
            
            <div class="bg-gray-700 rounded-lg p-4">
              <div v-if="form.gallery_images[0]" class="mb-4">
                <img 
                  :src="form.gallery_images[0]" 
                  :alt="form.name"
                  class="w-full h-48 object-cover rounded"
                >
              </div>
              
              <h3 class="text-xl font-bold text-white mb-2">
                {{ form.name || 'Название товара' }}
              </h3>
              
              <p class="text-gray-300 text-sm mb-3">
                {{ form.description || 'Описание товара' }}
              </p>
              
              <!-- Характеристики товара -->
              <div class="grid grid-cols-2 gap-4 mb-4 text-sm">
                <div>
                  <span class="text-gray-400">Артикул:</span>
                  <span class="text-white ml-2">{{ form.sku || 'Не указан' }}</span>
                </div>
                <div>
                  <span class="text-gray-400">В наличии:</span>
                  <span class="text-white ml-2">{{ form.stock_quantity || 0 }} шт.</span>
                </div>
                <div v-if="form.weight">
                  <span class="text-gray-400">Вес:</span>
                  <span class="text-white ml-2">{{ form.weight }} г</span>
                </div>
                <div v-if="form.dimensions.length || form.dimensions.width || form.dimensions.height">
                  <span class="text-gray-400">Размеры:</span>
                  <span class="text-white ml-2">
                    {{ form.dimensions.length }}×{{ form.dimensions.width }}×{{ form.dimensions.height }} см
                  </span>
                </div>
              </div>
              
              <!-- Выбранные категории -->
              <div v-if="form.category_ids.length" class="mb-3">
                <span class="text-gray-400 text-sm">Категории:</span>
                <div class="flex flex-wrap gap-1 mt-1">
                  <span 
                    v-for="catId in form.category_ids" 
                    :key="catId"
                    class="bg-blue-600 text-white px-2 py-1 rounded text-xs"
                  >
                    {{ getCategoryName(catId) }}
                  </span>
                </div>
              </div>
              
              <!-- Выбранные атрибуты -->
              <div v-if="Object.keys(form.attribute_values).length" class="mb-3">
                <span class="text-gray-400 text-sm">Атрибуты:</span>
                <div class="space-y-1 mt-1">
                  <div 
                    v-for="[attrId, data] in Object.entries(form.attribute_values)"
                    :key="attrId"
                    v-if="data.valueIds.length || data.customValue"
                    class="text-xs"
                  >
                    <span class="text-white font-medium">{{ getAttributeName(attrId) }}:</span>
                    <span class="text-gray-300 ml-2">
                      {{ getAttributeDisplayValues(attrId, data) }}
                    </span>
                  </div>
                </div>
              </div>
              
              <div class="flex items-center justify-between">
                <span class="text-2xl font-bold text-red-600">
                  {{ form.price ? formatPrice(form.price) : '0' }} ₽
                </span>
                <div class="flex space-x-2">
                  <span v-if="form.use_matryoshka" class="bg-purple-600 text-white px-3 py-1 rounded text-sm">
                    Матрёшка
                  </span>
                  <span class="bg-gray-600 text-gray-300 px-3 py-1 rounded text-sm">
                    {{ form.theme_id ? getThemeName(form.theme_id) : 'Без темы' }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Кнопки действий -->
            <div class="mt-6 space-y-3">
              <button
                type="submit"
                :disabled="loading || !isFormValid"
                class="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-gray-600 text-white py-3 rounded-lg font-medium transition-colors"
              >
                {{ loading ? 'Сохранение...' : (mode === 'edit' ? 'Обновить товар' : 'Создать товар') }}
              </button>
              
              <router-link
                to="/admin"
                class="block w-full bg-gray-600 hover:bg-gray-700 text-white py-3 rounded-lg font-medium text-center transition-colors"
              >
                Отмена
              </router-link>
            </div>
          </div>
        </div>
      </form>
    </div>

    <!-- Модальное окно быстрого добавления -->
    <QuickAddModal
      v-if="quickAddOpen"
      :type="quickAddType"
      @close="quickAddOpen = false"
      @added="onQuickAdded"
    />
  </div>
</template>

<script>
import { ref, reactive, computed, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { axios } from '../main.js';
import MultiImagePicker from '../components/admin/MultiImagePicker.vue';
import QuickAddModal from '../components/admin/QuickAddModal.vue';

export default {
  name: 'ProductCreate',
  components: {
    MultiImagePicker,
    QuickAddModal
  },
  setup() {
    const route = useRoute();
    const router = useRouter();
    
    // Состояние
    const loading = ref(false);
    const mode = computed(() => route.params.id ? 'edit' : 'create');
    const quickAddOpen = ref(false);
    const quickAddType = ref('category');
    
    // Данные
    const categories = ref([]);
    const themes = ref([]);
    const attributes = ref([]);
    const categoryTree = ref([]);
    const attributesWithValues = ref([]);
    
    // Форма товара
    const form = reactive({
      name: '',
      slug: '',
      description: '',
      price: 0,
      sku: '',
      stock_quantity: 0,
      weight: 0,
      use_matryoshka: false,
      image_layers: {
        outer: '',
        inner: ''
      },
      gallery_images: [],
      theme_id: '',
      category_ids: [],
      attribute_values: {},
      meta_title: '',
      meta_description: '',
      dimensions: {
        length: 0,
        width: 0,
        height: 0
      }
    });
    
    // Вычисляемые свойства
    const isFormValid = computed(() => {
      return form.name && 
             form.description && 
             form.price > 0 && 
             form.sku && 
             form.theme_id;
    });
    
    // Методы загрузки данных
    const loadCategories = async () => {
      try {
        const response = await axios.get('/admin/categories');
        categories.value = response.data;
      } catch (error) {
        console.error('Ошибка загрузки категорий:', error);
      }
    };
    
    const loadThemes = async () => {
      try {
        const response = await axios.get('/admin/themes');
        themes.value = response.data;
      } catch (error) {
        console.error('Ошибка загрузки тем:', error);
      }
    };
    
    const loadAttributes = async () => {
      try {
        const response = await axios.get('/admin/attributes');
        attributes.value = response.data;
      } catch (error) {
        console.error('Ошибка загрузки атрибутов:', error);
      }
    };
    
    const loadCategoryTree = async () => {
      try {
        const response = await axios.get('/admin/categories/tree');
        categoryTree.value = response.data;
      } catch (error) {
        console.error('Ошибка загрузки дерева категорий:', error);
      }
    };
    
    const loadAttributesWithValues = async () => {
      try {
        const response = await axios.get('/admin/attributes');
        const attributes = response.data;
        
        // Загружаем значения для каждого атрибута
        const attributesWithValues = await Promise.all(
          attributes.map(async (attr) => {
            try {
              const valuesResponse = await axios.get(`/admin/attributes/${attr.id}/values`);
              return {
                ...attr,
                values: valuesResponse.data || []
              };
            } catch (error) {
              return { ...attr, values: [] };
            }
          })
        );
        
        attributesWithValues.value = attributesWithValues;
      } catch (error) {
        console.error('Ошибка загрузки атрибутов:', error);
      }
    };
    
    const loadProduct = async () => {
      try {
        loading.value = true;
        const response = await axios.get(`/admin/products/${route.params.id}`);
        const product = response.data;
        
        // Заполняем форму данными товара
        Object.assign(form, {
          name: product.name,
          slug: product.slug,
          description: product.description,
          price: product.price,
          sku: product.sku || '',
          stock_quantity: product.stock_quantity || 0,
          weight: product.weight || 0,
          use_matryoshka: product.use_matryoshka,
          image_layers: product.image_layers || { outer: '', inner: '' },
          gallery_images: product.gallery_images || [],
          theme_id: product.theme_id,
          category_ids: product.categories?.map(c => c.id) || [],
          meta_title: product.meta_title || '',
          meta_description: product.meta_description || '',
          dimensions: product.dimensions || { length: 0, width: 0, height: 0 }
        });
        
        // Восстанавливаем attribute_values из product_attributes
        if (product.product_attributes) {
          const attributeValues = {};
          product.product_attributes.forEach(pa => {
            if (!attributeValues[pa.attribute_id]) {
              attributeValues[pa.attribute_id] = { valueIds: [], customValue: '' };
            }
            
            if (pa.attribute_value_id) {
              attributeValues[pa.attribute_id].valueIds.push(pa.attribute_value_id);
            }
            
            if (pa.custom_value) {
              attributeValues[pa.attribute_id].customValue = pa.custom_value;
            }
          });
          
          form.attribute_values = attributeValues;
        }
        
      } catch (error) {
        console.error('Ошибка загрузки товара:', error);
        alert('Ошибка загрузки товара');
        router.push('/admin');
      } finally {
        loading.value = false;
      }
    };
    
    // Методы работы с атрибутами
    const toggleAttributeValue = (attributeId, valueId) => {
      if (!form.attribute_values[attributeId]) {
        form.attribute_values[attributeId] = { valueIds: [], customValue: '' };
      }
      
      const valueIds = form.attribute_values[attributeId].valueIds;
      const index = valueIds.indexOf(valueId);
      
      if (index > -1) {
        valueIds.splice(index, 1);
      } else {
        valueIds.push(valueId);
      }
    };
    
    const addCustomAttributeValue = (attributeId, customValue) => {
      if (!form.attribute_values[attributeId]) {
        form.attribute_values[attributeId] = { valueIds: [], customValue: '' };
      }
      
      form.attribute_values[attributeId].customValue = customValue.trim();
    };
    
    const isAttributeValueSelected = (attributeId, valueId) => {
      return form.attribute_values[attributeId]?.valueIds?.includes(valueId) || false;
    };
    
    // Утилиты
    const generateSKU = () => {
      const prefix = 'STJ'; // Стужа
      const timestamp = Date.now().toString().slice(-6);
      const random = Math.random().toString(36).substring(2, 5).toUpperCase();
      form.sku = `${prefix}-${timestamp}-${random}`;
    };
    
    const generateMetaTags = () => {
      if (form.name && !form.meta_title) {
        form.meta_title = `${form.name} - купить в интернет-магазине Стужа`;
      }
      
      if (form.description && !form.meta_description) {
        form.meta_description = form.description.substring(0, 150) + '...';
      }
    };
    
    const formatPrice = (price) => {
      return new Intl.NumberFormat('ru-RU').format(price);
    };
    
    const getCategoryName = (categoryId) => {
      const findCategory = (cats) => {
        for (const cat of cats) {
          if (cat.id === categoryId) return cat.name;
          if (cat.children) {
            const found = findCategory(cat.children);
            if (found) return found;
          }
        }
        return null;
      };
      
      return findCategory(categoryTree.value) || 'Неизвестная категория';
    };
    
    const getThemeName = (themeId) => {
      const theme = themes.value.find(t => t.id === themeId);
      return theme ? theme.name : 'Неизвестная тема';
    };
    
    const getAttributeName = (attributeId) => {
      const attribute = attributesWithValues.value.find(a => a.id === parseInt(attributeId));
      return attribute ? attribute.name : 'Неизвестный атрибут';
    };
    
    const getAttributeDisplayValues = (attributeId, data) => {
      const attribute = attributesWithValues.value.find(a => a.id === parseInt(attributeId));
      if (!attribute) return '';
      
      const values = [];
      
      // Добавляем стандартные значения
      data.valueIds.forEach(valueId => {
        const value = attribute.values.find(v => v.id === valueId);
        if (value) values.push(value.value);
      });
      
      // Добавляем кастомное значение
      if (data.customValue) {
        values.push(`"${data.customValue}"`);
      }
      
      return values.join(', ');
    };
    
    // Модальные окна
    const showQuickAdd = (type) => {
      quickAddType.value = type;
      quickAddOpen.value = true;
    };
    
    const onQuickAdded = async (item) => {
      quickAddOpen.value = false;
      
      // Обновляем соответствующие данные
      if (quickAddType.value === 'category') {
        await Promise.all([loadCategories(), loadCategoryTree()]);
      } else if (quickAddType.value === 'theme') {
        await loadThemes();
      } else if (quickAddType.value === 'attribute') {
        await Promise.all([loadAttributes(), loadAttributesWithValues()]);
      }
      
      alert(`${quickAddType.value} добавлен!`);
    };
    
    // Сохранение товара
    const saveProduct = async () => {
      try {
        loading.value = true;
        
        // Подготовка данных для отправки
        const productData = {
          ...form,
          
          // Преобразуем attribute_values в формат для backend
          product_attributes: Object.entries(form.attribute_values)
            .filter(([_, data]) => data.valueIds.length > 0 || data.customValue)
            .flatMap(([attributeId, data]) => {
              const result = [];
              
              // Добавляем стандартные значения
              data.valueIds.forEach(valueId => {
                result.push({
                  attribute_id: parseInt(attributeId),
                  attribute_value_id: valueId,
                  custom_value: null
                });
              });
              
              // Добавляем кастомное значение
              if (data.customValue) {
                result.push({
                  attribute_id: parseInt(attributeId),
                  attribute_value_id: null,
                  custom_value: data.customValue
                });
              }
              
              return result;
            })
        };
        
        const isEdit = mode.value === 'edit';
        const url = isEdit ? `/admin/products/${route.params.id}` : '/admin/products';
        const method = isEdit ? 'put' : 'post';
        
        await axios[method](url, productData);
        
        alert(isEdit ? 'Товар обновлен!' : 'Товар создан!');
        router.push('/admin');
        
      } catch (error) {
        console.error('Ошибка сохранения товара:', error);
        const message = error.response?.data?.message || 'Ошибка сохранения';
        alert('Ошибка: ' + message);
      } finally {
        loading.value = false;
      }
    };
    
    // Watchers для автогенерации
    watch(() => form.name, () => {
      generateMetaTags();
    });
    
    watch(() => form.description, () => {
      generateMetaTags();
    });
    
    // Инициализация
    onMounted(async () => {
      await Promise.all([
        loadCategories(),
        loadThemes(),
        loadAttributes(),
        loadCategoryTree(),
        loadAttributesWithValues()
      ]);
      
      if (route.params.id) {
        await loadProduct();
      } else {
        generateSKU();
      }
    });
    
    return {
      // Состояние
      loading,
      mode,
      quickAddOpen,
      quickAddType,
      
      // Данные
      categories,
      themes,
      attributes,
      categoryTree,
      attributesWithValues,
      
      // Форма
      form,
      isFormValid,
      
      // Методы
      toggleAttributeValue,
      addCustomAttributeValue,
      isAttributeValueSelected,
      generateSKU,
      formatPrice,
      getCategoryName,
      getThemeName,
      getAttributeName,
      getAttributeDisplayValues,
      showQuickAdd,
      onQuickAdded,
      saveProduct
    };
  }
};
</script>