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
    <title>Ventas a Habitaciones - Sistema Hotelero</title>
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
                <a href="productos.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-utensils"></i>
                    <span>Productos</span>
                </a>
                <a href="ventas.jsp" class="flex items-center space-x-3 px-4 py-3 bg-indigo-700 rounded-lg hover:bg-indigo-600 transition">
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
                    <h2 class="text-2xl font-bold text-gray-800">Ventas a Habitaciones</h2>
                    <p class="text-gray-600 text-sm">Gestiona ventas de productos a los huéspedes</p>
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
                    <!-- Stats Row -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <!-- Ventas Hoy -->
                        <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-green-100 text-sm font-semibold">Ventas Hoy</p>
                                    <h3 class="text-4xl font-bold mt-2" id="ventasHoy">$0</h3>
                                    <p class="text-green-100 text-xs mt-1">Total del día</p>
                                </div>
                                <i class="fas fa-dollar-sign text-4xl opacity-20"></i>
                            </div>
                        </div>

                        <!-- Transacciones -->
                        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-blue-100 text-sm font-semibold">Transacciones</p>
                                    <h3 class="text-4xl font-bold mt-2" id="transacciones">0</h3>
                                    <p class="text-blue-100 text-xs mt-1">Ventas registradas</p>
                                </div>
                                <i class="fas fa-receipt text-4xl opacity-20"></i>
                            </div>
                        </div>

                        <!-- Ticket Promedio -->
                        <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-purple-100 text-sm font-semibold">Ticket Promedio</p>
                                    <h3 class="text-4xl font-bold mt-2" id="ticketPromedio">$0</h3>
                                    <p class="text-purple-100 text-xs mt-1">Venta promedio</p>
                                </div>
                                <i class="fas fa-chart-line text-4xl opacity-20"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Main Layout: Form (Left) + Carrito (Right) -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <!-- Formulario de Venta -->
                        <div class="lg:col-span-2">
                            <div class="bg-white rounded-xl shadow-md overflow-hidden">
                                <!-- Header -->
                                <div class="bg-gradient-to-r from-green-500 to-green-600 p-6 text-white">
                                    <div class="flex items-center space-x-3">
                                        <i class="fas fa-shopping-bag text-3xl"></i>
                                        <div>
                                            <h3 class="text-xl font-bold">Nueva Venta</h3>
                                            <p class="text-green-100 text-xs">Registra una venta a habitación</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Form -->
                                <form id="formVenta" onsubmit="procesarVenta(event)" class="p-6 space-y-4">
                                    <div class="grid grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="fas fa-door-open mr-2 text-green-600"></i>Habitación
                                            </label>
                                            <select id="habitacionVenta" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition">
                                                <option value="">Selecciona habitación</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="fas fa-utensils mr-2 text-green-600"></i>Producto
                                            </label>
                                            <select id="productoVenta" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition">
                                                <option value="">Selecciona producto</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="fas fa-box mr-2 text-green-600"></i>Cantidad
                                            </label>
                                            <input type="number" id="cantidad" min="1" value="1" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                                <i class="fas fa-tag mr-2 text-green-600"></i>Precio Unitario
                                            </label>
                                            <input type="number" id="precioUnitario" step="0.01" readonly class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg bg-gray-100 text-gray-600">
                                        </div>
                                    </div>

                                    <button type="button" onclick="agregarProducto()" class="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-4 py-3 rounded-lg transition font-semibold flex items-center justify-center space-x-2">
                                        <i class="fas fa-plus"></i>
                                        <span>Agregar al Carrito</span>
                                    </button>

                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="fas fa-credit-card mr-2 text-green-600"></i>Tipo de Pago
                                        </label>
                                        <select id="tipoPago" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition">
                                            <option value="">Selecciona método</option>
                                            <option value="Efectivo">Efectivo</option>
                                            <option value="Tarjeta">Tarjeta</option>
                                            <option value="Transferencia">Transferencia</option>
                                        </select>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Carrito y Resumen -->
                        <div class="space-y-6">
                            <!-- Carrito -->
                            <div class="bg-white rounded-xl shadow-md overflow-hidden">
                                <div class="bg-gradient-to-r from-orange-500 to-orange-600 p-6 text-white">
                                    <div class="flex items-center space-x-3">
                                        <i class="fas fa-shopping-cart text-3xl"></i>
                                        <div>
                                            <h3 class="text-xl font-bold">Carrito</h3>
                                            <p class="text-orange-100 text-xs" id="carritoCount">0 productos</p>
                                        </div>
                                    </div>
                                </div>
                                <div id="carrito" class="p-4 min-h-[200px] max-h-[300px] overflow-y-auto">
                                    <p class="text-gray-500 text-center text-sm">No hay productos en el carrito</p>
                                </div>
                            </div>

                            <!-- Resumen -->
                            <div class="bg-white rounded-xl shadow-md overflow-hidden">
                                <div class="bg-gradient-to-r from-indigo-600 to-indigo-700 p-6 text-white">
                                    <h3 class="text-lg font-bold">Resumen</h3>
                                </div>
                                <div class="p-6 space-y-3">
                                    <div class="flex justify-between">
                                        <span class="text-gray-700">Subtotal:</span>
                                        <span class="font-semibold text-gray-800" id="subtotal">$0.00</span>
                                    </div>
                                    <div class="flex justify-between">
                                        <span class="text-gray-700">IVA 5%:</span>
                                        <span class="font-semibold text-gray-800" id="iva5">$0.00</span>
                                    </div>
                                    <div class="flex justify-between">
                                        <span class="text-gray-700">IVA 10%:</span>
                                        <span class="font-semibold text-gray-800" id="iva10">$0.00</span>
                                    </div>
                                    <div class="border-t-2 border-gray-200 pt-3 flex justify-between">
                                        <span class="text-lg font-bold text-gray-800">Total:</span>
                                        <span class="text-2xl font-bold text-green-600" id="total">$0.00</span>
                                    </div>
                                    <button type="submit" form="formVenta" class="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-4 py-3 rounded-lg transition font-semibold flex items-center justify-center space-x-2 mt-4">
                                        <i class="fas fa-check-circle"></i>
                                        <span>Procesar Venta</span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Historial -->
                    <div class="mt-8">
                        <div class="bg-white rounded-xl shadow-md overflow-hidden">
                            <div class="bg-gradient-to-r from-blue-600 to-blue-700 p-6 text-white flex justify-between items-center">
                                <div class="flex items-center space-x-3">
                                    <i class="fas fa-history text-3xl"></i>
                                    <div>
                                        <h3 class="text-xl font-bold">Historial de Ventas</h3>
                                        <p class="text-blue-100 text-xs">Últimas transacciones registradas</p>
                                    </div>
                                </div>
                                <select id="filtroHabitacion" class="px-4 py-2 border-2 border-blue-300 rounded-lg bg-blue-500 text-white focus:outline-none" onchange="filtrarVentas()">
                                    <option value="">Todas las habitaciones</option>
                                </select>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full">
                                    <thead class="bg-gray-100 border-b-2 border-gray-200">
                                        <tr>
                                            <th class="px-6 py-4 text-left font-semibold text-gray-700">Habitación</th>
                                            <th class="px-6 py-4 text-left font-semibold text-gray-700">Producto</th>
                                            <th class="px-6 py-4 text-left font-semibold text-gray-700">Cantidad</th>
                                            <th class="px-6 py-4 text-left font-semibold text-gray-700">Total</th>
                                            <th class="px-6 py-4 text-left font-semibold text-gray-700">Pago</th>
                                            <th class="px-6 py-4 text-left font-semibold text-gray-700">Fecha</th>
                                        </tr>
                                    </thead>
                                    <tbody id="historialVentas" class="divide-y divide-gray-200">
                                        <!-- Historial se cargará aquí dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="js/common.js"></script>
    <script src="js/avatar-global.js"></script>
    <script src="js/topbar.js"></script>
    <script src="js/ventas.js"></script>
</body>
</html>

