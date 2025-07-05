<template>
  <div class="admin-panel min-h-screen bg-gray-900 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Заголовок с статистикой -->
      <div class="flex justify-between items-center mb-8">
        <div>
          <h1 class="text-3xl font-bold text-white">Админ-панель "Стужа"</h1>
          <p class="text-gray-400 mt-1">Управление интернет-магазином украшений</p>
        </div>
        
        <!-- Статистика -->
        <div class="hidden lg:flex space-x-4">
          <div class="bg-gray-800 rounded-lg p-4 text-center" v-if="stats">
            <div class="text-2xl font-bold text-blue-400">{{ stats.products?.total || 0 }}</div>
            <div class="text-gray-400 text-sm">Товаров</div>
          </div>
          <div class="bg-gray-800 rounded-lg p-4 text-center" v-if="stats">
            <div class="text-2xl font-bold text-green-400">{{ stats.categories || 0 }}</div>
            <div class="text-gray-400 text-sm">Категорий</div>
          </div>
          <div class="bg-gray-800 rounded-lg p-4 text-center" v-if="stats">
            <div class="text-2xl font-bold text-purple-400">{{ stats.products?.matryoshka || 0 }}</div>
            <div class="text-gray-400 text-sm">Матрёшек</div>
          </div>
        </div>
        
        <button @click="logout" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg transition-colors">
          Выйти
        </button>
      </div>

      <!-- Навигация -->
      <div class="bg-gray-800 rounded-lg p-2 mb-8">
        <nav class="flex flex-wrap space-x-1">
          <button
            v-for="tab in tabs"
            :key="tab.id"
            @click="activeTab = tab.id"
            class="px-4 py-2 rounded-lg text-sm font-medium transition-colors"
            :class="activeTab === tab.id ? 'bg-red-600 text-white' : 'text-gray-300 hover:text-white hover:bg-gray-700'"
          >
            {{ tab.name }}
          </button>
        </nav>
      </div>

      <!-- Контент вкладок -->
      <div class="bg-gray-800 rounded-lg p-6">
        
        <!-- Категории и подкатегории (РАСШИРЕННАЯ ВЕРСИЯ) -->
        <div v-if="activeTab === 'categories'">
          <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-semibold text-white">Категории и подкатегории</h2>
            <div class="flex space-x-2">
              <button 
                @click="createCategory()"
                class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg text-sm transition-colors"
              >
                + Создать категорию
              </button>
            </div>
          </div>

          <!-- Дерево категорий -->
          <div class="space-y-2">
            <div 
              v-for="category in categoryTree" 
              :key="category.id"
              class="bg-gray-700 rounded-lg p-4"
            >
              <!-- Корневая категория -->
              <div class="flex items-center justify-between">
                <div class="flex items-center space-x-3">
                  <span class="text-white font-medium">{{ category.name }}</span>
                  <span class="bg-blue-600 text-white px-2 py-1 rounded text-xs">
                    {{ category.products_count || 0 }} товаров
                  </span>
                  <span v-if="category.children && category.children.length" 
                        class="bg-purple-600 text-white px-2 py-1 rounded text-xs">
                    {{ category.children.length }} подкат.
                  </span>
                </div>
                
                <div class="flex space-x-2">
                  <button 
                    @click="createSubcategory(category.id)"
                    class="bg-green-600 hover:bg-green-700 text-white px-2 py-1 rounded text-xs transition-colors"
                  >
                    + Подкатегория
                  </button>
                  <button 
                    @click="editCategory(category)"
                    class="bg-blue-600 hover:bg-blue-700 text-white px-2 py-1 rounded text-xs transition-colors"
                  >
                    Изменить
                  </button>
                  <button 
                    @click="confirmDelete(category, 'category')"
                    class="bg-red-600 hover:bg-red-700 text-white px-2 py-1 rounded text-xs transition-colors"
                  >
                    Удалить
                  </button>
                </div>
              </div>

              <!-- Подкатегории -->
              <div v-if="category.children && category.children.length" class="ml-6 mt-3 space-y-2">
                <div 
                  v-for="child in category.children" 
                  :key="child.id"
                  class="bg-gray-600 rounded p-3 flex items-center justify-between"
                >
                  <div class="flex items-center space-x-3">
                    <span class="text-gray-300">→</span>
                    <span class="text-white">{{ child.name }}</span>
                    <span class="bg-gray-500 text-white px-2 py-1 rounded text-xs">
                      {{ child.products_count || 0 }} товаров
                    </span>
                  </div>
                  
                  <div class="flex space-x-2">
                    <button 
                      @click="editCategory(child)"
                      class="bg-blue-600 hover:bg-blue-700 text-white px-2 py-1 rounded text-xs transition-colors"
                    >
                      Изменить
                    </button>
                    <button 
                      @click="confirmDelete(child, 'category')"
                      class="bg-red-600 hover:bg-red-700 text-white px-2 py-1 rounded text-xs transition-colors"
                    >
                      Удалить
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Атрибуты и значения (РАСШИРЕННАЯ ВЕРСИЯ) -->
        <div v-if="activeTab === 'attributes'">
          <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-semibold text-white">Атрибуты и значения</h2>
            <button 
              @click="createAttribute()"
              class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-lg transition-colors"
            >
              + Создать атрибут
            </button>
          </div>

          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Список атрибутов -->
            <div>
              <h3 class="text-lg font-medium text-white mb-4">Атрибуты</h3>
              <div class="space-y-3">
                <div 
                  v-for="attribute in attributes" 
                  :key="attribute.id"
                  class="bg-gray-700 rounded-lg p-4 cursor-pointer hover:bg-gray-600 transition-colors"
                  :class="{ 'ring-2 ring-blue-500': selectedAttribute === attribute.id }"
                  @click="loadAttributeValues(attribute.id)"
                >
                  <div class="flex items-center justify-between">
                    <div class="flex items-center space-x-3">
                      <span class="text-white font-medium">{{ attribute.name }}</span>
                      <span v-if="attribute.is_stone" 
                            class="bg-purple-600 text-white px-2 py-1 rounded text-xs">
                        Камень
                      </span>
                    </div>
                    
                    <div class="flex space-x-2">
                      <span class="bg-gray-600 text-gray-300 px-2 py-1 rounded text-xs">
                        {{ attribute.values_count || 0 }} значений
                      </span>
                      <button 
                        @click.stop="createAttributeValue(attribute.id)"
                        class="bg-green-600 hover:bg-green-700 text-white px-2 py-1 rounded text-xs transition-colors"
                      >
                        + Значение
                      </button>
                      <button 
                        @click.stop="editAttribute(attribute)"
                        class="bg-blue-600 hover:bg-blue-700 text-white px-2 py-1 rounded text-xs transition-colors"
                      >
                        Изменить
                      </button>
                      <button 
                        @click.stop="confirmDelete(attribute, 'attribute')"
                        class="bg-red-600 hover:bg-red-700 text-white px-2 py-1 rounded text-xs transition-colors"
                      >
                        Удалить
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Значения выбранного атрибута -->
            <div>
              <h3 class="text-lg font-medium text-white mb-4">
                Значения атрибута
                <span v-if="selectedAttribute" class="text-gray-400">
                  ({{ getAttributeName(selectedAttribute) }})
                </span>
              </h3>
              
              <div v-if="!selectedAttribute" class="text-center py-8 text-gray-400">
                Выберите атрибут для просмотра значений
              </div>
              
              <div v-else class="space-y-2">
                <div 
                  v-for="value in attributeValues" 
                  :key="value.id"
                  class="bg-gray-700 rounded p-3 flex items-center justify-between"
                >
                  <div class="flex items-center space-x-3">
                    <span class="text-white">{{ value.value }}</span>
                    <span class="bg-gray-600 text-gray-300 px-2 py-1 rounded text-xs">
                      {{ value.products_count || 0 }} товаров
                    </span>
                    <span v-if="!value.is_active" 
                          class="bg-red-600 text-white px-2 py-1 rounded text-xs">
                      Неактивно
                    </span>
                  </div>
                  
                  <div class="flex space-x-2">
                    <button 
                      @click="editAttributeValue(value)"
                      class="bg-blue-600 hover:bg-blue-700 text-white px-2 py-1 rounded text-xs transition-colors"
                    >
                      Изменить
                    </button>
                    <button 
                      @click="deleteAttributeValue(value.id)"
                      class="bg-red-600 hover:bg-red-700 text-white px-2 py-1 rounded text-xs transition-colors"
                    >
                      Удалить
                    </button>
                  </div>
                </div>
                
                <button 
                  @click="createAttributeValue(selectedAttribute)"
                  class="w-full bg-green-600 hover:bg-green-700 text-white py-2 rounded text-sm transition-colors"
                >
                  + Добавить значение
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Остальные табы остаются как были -->
        <!-- ... продолжение файла ... -->
        
      </div>
    </div>

    <!-- Модальное окно категории -->
    <div v-if="showCategoryModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-gray-800 rounded-lg p-6 max-w-md w-full">
        <h3 class="text-xl text-white mb-4">
          {{ categoryForm.id ? 'Редактировать' : 'Создать' }} категорию
        </h3>
        
        <form @submit.prevent="saveCategory()">
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-white mb-2">Название</label>
              <input 
                v-model="categoryForm.name"
                type="text" 
                required
                class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white"
                placeholder="Название категории"
              >
            </div>
            
            <div>
              <label class="block text-sm font-medium text-white mb-2">Родительская категория</label>
              <select 
                v-model="categoryForm.parent_id"
                class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white"
              >
                <option value="">Корневая категория</option>
                <option 
                  v-for="category in categories.filter(c => !c.parent_id && c.id !== categoryForm.id)" 
                  :key="category.id" 
                  :value="category.id"
                >
                  {{ category.name }}
                </option>
              </select>
            </div>
            
            <div>
              <label class="block text-sm font-medium text-white mb-2">Slug</label>
              <input 
                v-model="categoryForm.slug"
                type="text" 
                required
                class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white"
                placeholder="category-slug"
              >
            </div>
            
            <div>
              <label class="block text-sm font-medium text-white mb-2">Порядок сортировки</label>
              <input 
                v-model.number="categoryForm.sort_order"
                type="number" 
                min="0"
                class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white"
              >
            </div>
          </div>
          
          <div class="flex justify-end space-x-3 mt-6">
            <button 
              type="button"
              @click="showCategoryModal = false"
              class="px-4 py-2 text-gray-400 hover:text-white transition-colors"
            >
              Отмена
            </button>
            <button 
              type="submit"
              :disabled="loading"
              class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded transition-colors disabled:opacity-50"
            >
              {{ loading ? 'Сохранение...' : 'Сохранить' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Модальное окно атрибута -->
    <div v-if="showAttributeModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-gray-800 rounded-lg p-6 max-w-md w-full">
        <h3 class="text-xl text-white mb-4">
          {{ attributeForm.id ? 'Редактировать' : 'Создать' }} атрибут
        </h3>
        
        <form @submit.prevent="saveAttribute()">
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-white mb-2">Название атрибута</label>
              <input 
                v-model="attributeForm.name"
                type="text" 
                required
                class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white"
                placeholder="Например: Материал, Размер, Цвет камня"
              >
            </div>
            
            <div>
              <label class="flex items-center">
                <input 
                  v-model="attributeForm.is_stone"
                  type="checkbox"
                  class="mr-2 rounded border-gray-600 bg-gray-700 text-blue-600"
                >
                <span class="text-white">Это атрибут камня</span>
              </label>
            </div>
          </div>
          
          <div class="flex justify-end space-x-3 mt-6">
            <button 
              type="button"
              @click="showAttributeModal = false"
              class="px-4 py-2 text-gray-400 hover:text-white transition-colors"
            >
              Отмена
            </button>
            <button 
              type="submit"
              :disabled="loading"
              class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded transition-colors disabled:opacity-50"
            >
              {{ loading ? 'Сохранение...' : 'Сохранить' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Модальное окно значения атрибута -->
    <div v-if="showAttributeValueModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div class="bg-gray-800 rounded-lg p-6 max-w-md w-full">
        <h3 class="text-xl text-white mb-4">
          {{ attributeValueForm.id ? 'Редактировать' : 'Создать' }} значение
        </h3>
        
        <form @submit.prevent="saveAttributeValue()">
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-white mb-2">Значение</label>
              <input 
                v-model="attributeValueForm.value"
                type="text" 
                required
                class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white"
                placeholder="Например: Красный, Синий, XL, 925 проба"
              >
            </div>
            
            <div>
              <label class="block text-sm font-medium text-white mb-2">Порядок сортировки</label>
              <input 
                v-model.number="attributeValueForm.sort_order"
                type="number" 
                min="0"
                class="w-full bg-gray-700 border border-gray-600 rounded px-3 py-2 text-white"
              >
            </div>
            
            <div>
              <label class="flex items-center">
                <input 
                  v-model="attributeValueForm.is_active"
                  type="checkbox"
                  class="mr-2 rounded border-gray-600 bg-gray-700 text-blue-600"
                >
                <span class="text-white">Активное значение</span>
              </label>
            </div>
          </div>
          
          <div class="flex justify-end space-x-3 mt-6">
            <button 
              type="button"
              @click="showAttributeValueModal = false"
              class="px-4 py-2 text-gray-400 hover:text-white transition-colors"
            >
              Отмена
            </button>
            <button 
              type="submit"
              :disabled="loading"
              class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded transition-colors disabled:opacity-50"
            >
              {{ loading ? 'Сохранение...' : 'Сохранить' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, reactive, computed, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';
import { axios } from '../main.js';
import SimpleList from '../components/admin/SimpleList.vue';
import SimpleModal from '../components/admin/SimpleModal.vue';
import ConfirmModal from '../components/admin/ConfirmModal.vue';

export default {
  name: 'AdminPanel',
  components: {
    SimpleList,
    SimpleModal, 
    ConfirmModal
  },
  setup() {
    const router = useRouter();
    
    // Состояние приложения
    const activeTab = ref('products');
    const loading = ref(false);
    
    // Данные
    const categories = ref([]);
    const categoryTree = ref([]);
    const attributes = ref([]);
    const attributeValues = ref([]);
    const selectedAttribute = ref(null);
    const stats = ref(null);
    
    // Модальные окна
    const showCategoryModal = ref(false);
    const showAttributeModal = ref(false);
    const showAttributeValueModal = ref(false);
    
    // Формы
    const categoryForm = reactive({
      id: null,
      name: '',
      slug: '',
      parent_id: null,
      sort_order: 0
    });
    
    const attributeForm = reactive({
      id: null,
      name: '',
      is_stone: false
    });
    
    const attributeValueForm = reactive({
      id: null,
      attribute_id: null,
      value: '',
      sort_order: 0,
      is_active: true
    });
    
    // Навигационные табы
    const tabs = [
      { id: 'products', name: 'Товары' },
      { id: 'images', name: 'Изображения' },
      { id: 'categories', name: 'Категории' },
      { id: 'themes', name: 'Темы' },
      { id: 'attributes', name: 'Атрибуты' },
      { id: 'quiz', name: 'Квиз' },
      { id: 'marketplace', name: 'Маркетплейсы' },
      { id: 'settings', name: 'Настройки' }
    ];
    
    // Методы загрузки данных
    const loadCategoryTree = async () => {
      try {
        const response = await axios.get('/admin/categories/tree');
        categoryTree.value = response.data;
      } catch (error) {
        console.error('Ошибка загрузки дерева категорий:', error);
      }
    };
    
    const loadCategories = async () => {
      try {
        const response = await axios.get('/admin/categories');
        categories.value = response.data;
      } catch (error) {
        console.error('Ошибка загрузки категорий:', error);
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
    
    const loadAttributeValues = async (attributeId) => {
      try {
        selectedAttribute.value = attributeId;
        const response = await axios.get(`/admin/attributes/${attributeId}/values`);
        attributeValues.value = response.data;
      } catch (error) {
        console.error('Ошибка загрузки значений атрибута:', error);
      }
    };
    
    // Категории
    const createCategory = () => {
      Object.assign(categoryForm, {
        id: null,
        name: '',
        slug: '',
        parent_id: null,
        sort_order: 0
      });
      showCategoryModal.value = true;
    };
    
    const createSubcategory = (parentId) => {
      Object.assign(categoryForm, {
        id: null,
        name: '',
        slug: '',
        parent_id: parentId,
        sort_order: 0
      });
      showCategoryModal.value = true;
    };
    
    const editCategory = (category) => {
      Object.assign(categoryForm, {
        id: category.id,
        name: category.name,
        slug: category.slug,
        parent_id: category.parent_id,
        sort_order: category.sort_order || 0
      });
      showCategoryModal.value = true;
    };
    
    const saveCategory = async () => {
      try {
        loading.value = true;
        
        const isEdit = categoryForm.id;
        const url = isEdit ? `/admin/categories/${categoryForm.id}` : '/admin/categories';
        const method = isEdit ? 'put' : 'post';
        
        await axios[method](url, categoryForm);
        
        showCategoryModal.value = false;
        await Promise.all([loadCategories(), loadCategoryTree()]);
        alert(isEdit ? 'Категория обновлена!' : 'Категория создана!');
        
      } catch (error) {
        console.error('Ошибка сохранения категории:', error);
        alert('Ошибка: ' + (error.response?.data?.message || 'Неизвестная ошибка'));
      } finally {
        loading.value = false;
      }
    };
    
    // Атрибуты
    const createAttribute = () => {
      Object.assign(attributeForm, {
        id: null,
        name: '',
        is_stone: false
      });
      showAttributeModal.value = true;
    };
    
    const editAttribute = (attribute) => {
      Object.assign(attributeForm, {
        id: attribute.id,
        name: attribute.name,
        is_stone: attribute.is_stone
      });
      showAttributeModal.value = true;
    };
    
    const saveAttribute = async () => {
      try {
        loading.value = true;
        
        const isEdit = attributeForm.id;
        const url = isEdit ? `/admin/attributes/${attributeForm.id}` : '/admin/attributes';
        const method = isEdit ? 'put' : 'post';
        
        await axios[method](url, attributeForm);
        
        showAttributeModal.value = false;
        await loadAttributes();
        alert(isEdit ? 'Атрибут обновлен!' : 'Атрибут создан!');
        
      } catch (error) {
        console.error('Ошибка сохранения атрибута:', error);
        alert('Ошибка: ' + (error.response?.data?.message || 'Неизвестная ошибка'));
      } finally {
        loading.value = false;
      }
    };
    
    // Значения атрибутов
    const createAttributeValue = (attributeId) => {
      Object.assign(attributeValueForm, {
        id: null,
        attribute_id: attributeId,
        value: '',
        sort_order: 0,
        is_active: true
      });
      showAttributeValueModal.value = true;
    };
    
    const editAttributeValue = (value) => {
      Object.assign(attributeValueForm, {
        id: value.id,
        attribute_id: value.attribute_id,
        value: value.value,
        sort_order: value.sort_order,
        is_active: value.is_active
      });
      showAttributeValueModal.value = true;
    };
    
    const saveAttributeValue = async () => {
      try {
        loading.value = true;
        
        const isEdit = attributeValueForm.id;
        const url = isEdit 
          ? `/admin/attribute-values/${attributeValueForm.id}`
          : `/admin/attributes/${attributeValueForm.attribute_id}/values`;
        const method = isEdit ? 'put' : 'post';
        
        await axios[method](url, attributeValueForm);
        
        showAttributeValueModal.value = false;
        await loadAttributeValues(attributeValueForm.attribute_id);
        alert(isEdit ? 'Значение обновлено!' : 'Значение создано!');
        
      } catch (error) {
        console.error('Ошибка сохранения значения:', error);
        alert('Ошибка: ' + (error.response?.data?.message || 'Неизвестная ошибка'));
      } finally {
        loading.value = false;
      }
    };
    
    const deleteAttributeValue = async (valueId) => {
      if (!confirm('Удалить это значение атрибута?')) return;
      
      try {
        await axios.delete(`/admin/attribute-values/${valueId}`);
        await loadAttributeValues(selectedAttribute.value);
        alert('Значение удалено!');
      } catch (error) {
        console.error('Ошибка удаления значения:', error);
        alert('Ошибка удаления');
      }
    };
    
    // Утилиты
    const getAttributeName = (attributeId) => {
      const attribute = attributes.value.find(a => a.id === attributeId);
      return attribute ? attribute.name : 'Неизвестный атрибут';
    };
    
    const confirmDelete = (item, type) => {
      // Реализация подтверждения удаления
      if (!confirm(`Удалить ${type} "${item.name}"?`)) return;
      // ... логика удаления
    };
    
    const logout = () => {
      localStorage.removeItem('auth_token');
      delete axios.defaults.headers.common['Authorization'];
      router.push('/admin/login');
    };
    
    // Автогенерация slug для категорий
    watch(() => categoryForm.name, (newName) => {
      if (newName && !categoryForm.id) {
        categoryForm.slug = newName
          .toLowerCase()
          .replace(/[^a-z0-9\s-]/g, '')
          .replace(/\s+/g, '-')
          .replace(/-+/g, '-')
          .trim('-');
      }
    });
    
    // Инициализация
    onMounted(async () => {
      await Promise.all([
        loadCategories(),
        loadCategoryTree(),
        loadAttributes()
      ]);
    });
    
    return {
      // Состояние
      activeTab,
      loading,
      
      // Данные
      categories,
      categoryTree,
      attributes,
      attributeValues,
      selectedAttribute,
      stats,
      
      // Модальные окна
      showCategoryModal,
      showAttributeModal,
      showAttributeValueModal,
      
      // Формы
      categoryForm,
      attributeForm,
      attributeValueForm,
      
      // Константы
      tabs,
      
      // Методы
      createCategory,
      createSubcategory,
      editCategory,
      saveCategory,
      createAttribute,
      editAttribute,
      saveAttribute,
      createAttributeValue,
      editAttributeValue,
      saveAttributeValue,
      deleteAttributeValue,
      loadAttributeValues,
      getAttributeName,
      confirmDelete,
      logout
    };
  }
};
</script>