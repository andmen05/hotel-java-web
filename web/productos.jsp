<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.hotel.modelo.Usuario"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Productos - Sistema Hotelero</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <div class="w-48 bg-gradient-to-b from-indigo-900 to-indigo-800 text-white shadow-2xl">
            <div class="p-6 border-b border-indigo-700">
                <div class="flex items-center space-x-3">
                    <div class="bg-white bg-opacity-20 p-2 rounded-lg">
                        <i class="fas fa-hotel text-2xl"></i>
                    </div>
                    <div>
                        <h1 class="text-lg font-bold">Hotel Paradise</h1>
                        <p class="text-xs text-indigo-200">Sistema Moderno</p>
                    </div>
                </div>
            </div>

            <nav class="mt-8 space-y-2 px-4">
                <a href="dashboard.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>
                <a href="clientes.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-users"></i>
                    <span>Clientes</span>
                </a>
                <a href="habitaciones.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-bed"></i>
                    <span>Habitaciones</span>
                </a>
                <a href="reservas.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-calendar-check"></i>
                    <span>Reservas</span>
                </a>
                <a href="checkin.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-sign-in-alt"></i>
                    <span>Check-in</span>
                </a>
                <a href="productos.jsp" class="flex items-center space-x-3 px-4 py-3 bg-indigo-700 rounded-lg hover:bg-indigo-600 transition">
                    <i class="fas fa-utensils"></i>
                    <span>Productos</span>
                </a>
                <a href="ventas.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Ventas</span>
                </a>
                <a href="reportes.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-chart-bar"></i>
                    <span>Reportes</span>
                </a>
            </nav>

            <div class="absolute bottom-0 left-0 right-0 p-4 border-t border-indigo-700 w-48">
                <a href="logout" class="flex items-center space-x-3 px-4 py-3 bg-red-600 hover:bg-red-700 rounded-lg transition w-full justify-center">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Salir</span>
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Top Bar -->
            <div class="bg-white shadow-md px-8 py-4 flex justify-between items-center">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Gestión de Productos - Restaurante</h2>
                    <p class="text-gray-600 text-sm">Administra el menú y el inventario</p>
                </div>
                <div class="flex items-center space-x-4">
                    <button class="p-2 hover:bg-gray-100 rounded-lg transition">
                        <i class="fas fa-bell text-gray-600 text-xl"></i>
                    </button>
                    <button class="p-2 hover:bg-gray-100 rounded-lg transition">
                        <i class="fas fa-cog text-gray-600 text-xl"></i>
                    </button>
                    <!-- Avatar con Menú Desplegable -->
                    <div class="relative">
                        <button id="avatarBtn" class="w-10 h-10 bg-gradient-to-br from-indigo-500 to-blue-600 rounded-full flex items-center justify-center text-white font-bold hover:shadow-lg transition cursor-pointer overflow-hidden">
                            <%= usuario.getNombre() != null && usuario.getNombre().length() > 0 ? usuario.getNombre().charAt(0) : "A" %>
                        </button>
                        <!-- Menú Desplegable -->
                        <div id="userMenu" class="hidden absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-xl z-50 overflow-hidden">
                            <!-- Header del Menú -->
                            <div class="bg-gradient-to-r from-indigo-600 to-blue-600 text-white p-4">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div>
                                        <p class="font-semibold text-sm"><%= usuario.getNombre() != null ? usuario.getNombre() : "Usuario" %></p>
                                        <p class="text-xs text-indigo-100">ID: <%= usuario.getId() %></p>
                                    </div>
                                </div>
                            </div>
                            <!-- Opciones del Menú -->
                            <div class="py-2">
                                <a href="perfil.jsp" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-indigo-50 transition">
                                    <i class="fas fa-user-circle text-indigo-600 w-5"></i>
                                    <span>Mi Perfil</span>
                                </a>
                                <a href="#" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-indigo-50 transition">
                                    <i class="fas fa-cog text-gray-600 w-5"></i>
                                    <span>Configuración</span>
                                </a>
                                <a href="#" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-indigo-50 transition">
                                    <i class="fas fa-question-circle text-gray-600 w-5"></i>
                                    <span>Ayuda</span>
                                </a>
                                <hr class="my-2">
                                <a href="logout" class="flex items-center space-x-3 px-4 py-3 text-red-600 hover:bg-red-50 transition font-semibold">
                                    <i class="fas fa-sign-out-alt w-5"></i>
                                    <span>Cerrar Sesión</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Scrollable Content -->
            <div class="flex-1 overflow-auto">
                <div class="p-8">
                    <!-- Header with Button -->
                    <div class="flex justify-between items-center mb-6">
                        <div>
                            <h3 class="text-lg font-semibold text-gray-800">Inventario de Productos</h3>
                        </div>
                        <button onclick="abrirModalNuevo()" class="px-6 py-2 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white rounded-lg transition flex items-center space-x-2 font-semibold">
                            <i class="fas fa-plus"></i>
                            <span>Nuevo Producto</span>
                        </button>
                    </div>

                    <!-- Stats Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                        <!-- Total Productos -->
                        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-blue-100 text-sm font-semibold">Total Productos</p>
                                    <h3 class="text-4xl font-bold mt-2" id="totalProductos">0</h3>
                                </div>
                                <i class="fas fa-shopping-bag text-3xl opacity-30"></i>
                            </div>
                        </div>

                        <!-- Comidas -->
                        <div class="bg-gradient-to-br from-orange-500 to-orange-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-orange-100 text-sm font-semibold">Comidas</p>
                                    <h3 class="text-4xl font-bold mt-2" id="comidas">0</h3>
                                </div>
                                <i class="fas fa-utensils text-3xl opacity-30"></i>
                            </div>
                        </div>

                        <!-- Bebidas -->
                        <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-purple-100 text-sm font-semibold">Bebidas</p>
                                    <h3 class="text-4xl font-bold mt-2" id="bebidas">0</h3>
                                </div>
                                <i class="fas fa-wine-glass text-3xl opacity-30"></i>
                            </div>
                        </div>

                        <!-- Postres -->
                        <div class="bg-gradient-to-br from-pink-500 to-pink-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-pink-100 text-sm font-semibold">Postres</p>
                                    <h3 class="text-4xl font-bold mt-2" id="postres">0</h3>
                                </div>
                                <i class="fas fa-birthday-cake text-3xl opacity-30"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Info Box -->
                    <div class="bg-blue-50 border-l-4 border-blue-500 p-4 mb-6 rounded">
                        <p class="text-blue-700 text-sm">
                            <i class="fas fa-info-circle mr-2"></i>
                            Lista de productos en desarrollo. El código completo incluye gestión completo del menú del restaurante, categorías, precios, inventario y más.
                        </p>
                    </div>

                    <!-- Products Table -->
                    <div class="bg-white rounded-xl shadow-md overflow-hidden">
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead class="bg-gradient-to-r from-indigo-600 to-indigo-700 text-white">
                                    <tr>
                                        <th class="px-6 py-4 text-left font-semibold">Código</th>
                                        <th class="px-6 py-4 text-left font-semibold">Descripción</th>
                                        <th class="px-6 py-4 text-left font-semibold">Categoría</th>
                                        <th class="px-6 py-4 text-left font-semibold">Precio Venta</th>
                                        <th class="px-6 py-4 text-left font-semibold">Existencia</th>
                                        <th class="px-6 py-4 text-left font-semibold">IVA</th>
                                        <th class="px-6 py-4 text-center font-semibold">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="tablaProductos" class="divide-y divide-gray-200">
                                    <!-- Los productos se cargarán aquí dinámicamente -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div id="modalProducto" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md max-h-[90vh] overflow-y-auto">
            <!-- Modal Header -->
            <div class="bg-gradient-to-r from-indigo-600 to-indigo-700 text-white p-6 sticky top-0">
                <div class="flex justify-between items-center">
                    <h3 class="text-2xl font-bold" id="modalTitulo">Nuevo Producto</h3>
                    <button onclick="cerrarModal()" class="text-white hover:bg-indigo-800 p-2 rounded-lg transition">
                        <i class="fas fa-times text-xl"></i>
                    </button>
                </div>
            </div>

            <!-- Modal Body -->
            <form id="formProducto" onsubmit="guardarProducto(event)" class="p-6 space-y-4">
                <input type="hidden" id="productoId">
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-barcode mr-2 text-indigo-600"></i>Código
                    </label>
                    <input type="text" id="codigo" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition" placeholder="Ej: PROD001">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-file-alt mr-2 text-indigo-600"></i>Descripción
                    </label>
                    <input type="text" id="descripcion" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition" placeholder="Nombre del producto">
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-tag mr-2 text-indigo-600"></i>Precio Venta
                        </label>
                        <input type="number" id="precioVenta" step="0.01" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition" placeholder="0.00">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-shopping-cart mr-2 text-indigo-600"></i>Precio Compra
                        </label>
                        <input type="number" id="precioCompra" step="0.01" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition" placeholder="0.00">
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-percent mr-2 text-indigo-600"></i>IVA (%)
                        </label>
                        <select id="iva" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition">
                            <option value="">Selecciona IVA</option>
                            <option value="0">0%</option>
                            <option value="5">5%</option>
                            <option value="10">10%</option>
                            <option value="19">19%</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                            <i class="fas fa-box mr-2 text-indigo-600"></i>Existencia
                        </label>
                        <input type="number" id="existencia" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition" placeholder="0">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-list mr-2 text-indigo-600"></i>Categoría
                    </label>
                    <select id="codCategoria" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition">
                        <option value="">Selecciona una categoría</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-calendar mr-2 text-indigo-600"></i>Vencimiento (opcional)
                    </label>
                    <input type="date" id="vencimiento" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition">
                </div>

                <!-- Modal Footer -->
                <div class="flex justify-end space-x-3 pt-4 border-t">
                    <button type="button" onclick="cerrarModal()" class="px-6 py-2 bg-gray-200 hover:bg-gray-300 text-gray-800 rounded-lg transition font-semibold">
                        Cancelar
                    </button>
                    <button type="submit" class="px-6 py-2 bg-gradient-to-r from-indigo-600 to-blue-600 hover:from-indigo-700 hover:to-blue-700 text-white rounded-lg transition font-semibold flex items-center space-x-2">
                        <i class="fas fa-save"></i>
                        <span>Guardar</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="js/common.js"></script>
    <script src="js/avatar-global.js"></script>
    <script src="js/topbar.js"></script>
    <script src="js/productos.js"></script>
</body>
</html>

