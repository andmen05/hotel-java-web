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
    <title>Reportes - Sistema Hotelero</title>
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
                <a href="ventas.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Ventas</span>
                </a>
                <a href="reportes.jsp" class="flex items-center space-x-3 px-4 py-3 bg-indigo-700 rounded-lg hover:bg-indigo-600 transition">
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
                    <h2 class="text-2xl font-bold text-gray-800">Reportes y Análisis</h2>
                    <p class="text-gray-600 text-sm">Visualiza datos y estadísticas del hotel</p>
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
                    <!-- KPI Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                        <!-- Ocupación -->
                        <div class="bg-gradient-to-br from-cyan-500 to-cyan-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-cyan-100 text-sm font-semibold">Ocupación</p>
                                    <h3 class="text-4xl font-bold mt-2" id="ocupacion">0%</h3>
                                    <p class="text-cyan-100 text-xs mt-1">Habitaciones ocupadas</p>
                                </div>
                                <i class="fas fa-building text-4xl opacity-20"></i>
                            </div>
                        </div>

                        <!-- Ingresos -->
                        <div class="bg-gradient-to-br from-emerald-500 to-emerald-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-emerald-100 text-sm font-semibold">Ingresos Totales</p>
                                    <h3 class="text-4xl font-bold mt-2" id="ingresos">$0</h3>
                                    <p class="text-emerald-100 text-xs mt-1">Este mes</p>
                                </div>
                                <i class="fas fa-dollar-sign text-4xl opacity-20"></i>
                            </div>
                        </div>

                        <!-- Clientes -->
                        <div class="bg-gradient-to-br from-violet-500 to-violet-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-violet-100 text-sm font-semibold">Clientes Activos</p>
                                    <h3 class="text-4xl font-bold mt-2" id="clientesActivos">0</h3>
                                    <p class="text-violet-100 text-xs mt-1">Huéspedes registrados</p>
                                </div>
                                <i class="fas fa-users text-4xl opacity-20"></i>
                            </div>
                        </div>

                        <!-- Reservas -->
                        <div class="bg-gradient-to-br from-rose-500 to-rose-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-rose-100 text-sm font-semibold">Reservas Pendientes</p>
                                    <h3 class="text-4xl font-bold mt-2" id="reservasPendientes">0</h3>
                                    <p class="text-rose-100 text-xs mt-1">Próximos 30 días</p>
                                </div>
                                <i class="fas fa-calendar-alt text-4xl opacity-20"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Reportes Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <!-- Reporte Ventas -->
                        <button onclick="generarReporte('ventas')" class="group bg-white rounded-xl shadow-md overflow-hidden hover:shadow-xl transition transform hover:scale-105">
                            <div class="bg-gradient-to-br from-blue-500 to-blue-600 p-6 text-white">
                                <i class="fas fa-chart-line text-4xl mb-4"></i>
                                <h3 class="text-xl font-bold">Reporte de Ventas</h3>
                                <p class="text-blue-100 text-xs mt-1">Análisis de ventas por período</p>
                            </div>
                            <div class="p-4 text-gray-600 text-sm">
                                <i class="fas fa-arrow-right mr-2 text-blue-600"></i>Ver detalles
                            </div>
                        </button>

                        <!-- Reporte Check-ins -->
                        <button onclick="generarReporte('checkins')" class="group bg-white rounded-xl shadow-md overflow-hidden hover:shadow-xl transition transform hover:scale-105">
                            <div class="bg-gradient-to-br from-green-500 to-green-600 p-6 text-white">
                                <i class="fas fa-sign-in-alt text-4xl mb-4"></i>
                                <h3 class="text-xl font-bold">Reporte de Check-ins</h3>
                                <p class="text-green-100 text-xs mt-1">Entrada y salida de huéspedes</p>
                            </div>
                            <div class="p-4 text-gray-600 text-sm">
                                <i class="fas fa-arrow-right mr-2 text-green-600"></i>Ver detalles
                            </div>
                        </button>

                        <!-- Reporte Reservas -->
                        <button onclick="generarReporte('reservas')" class="group bg-white rounded-xl shadow-md overflow-hidden hover:shadow-xl transition transform hover:scale-105">
                            <div class="bg-gradient-to-br from-amber-500 to-amber-600 p-6 text-white">
                                <i class="fas fa-calendar-check text-4xl mb-4"></i>
                                <h3 class="text-xl font-bold">Reporte de Reservas</h3>
                                <p class="text-amber-100 text-xs mt-1">Estado de reservaciones</p>
                            </div>
                            <div class="p-4 text-gray-600 text-sm">
                                <i class="fas fa-arrow-right mr-2 text-amber-600"></i>Ver detalles
                            </div>
                        </button>
                    </div>

                    <!-- Más Reportes -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                        <!-- Reporte Ocupación -->
                        <button onclick="generarReporte('ocupacion')" class="group bg-white rounded-xl shadow-md overflow-hidden hover:shadow-xl transition transform hover:scale-105">
                            <div class="bg-gradient-to-br from-indigo-500 to-indigo-600 p-6 text-white">
                                <i class="fas fa-chart-pie text-4xl mb-4"></i>
                                <h3 class="text-xl font-bold">Reporte de Ocupación</h3>
                                <p class="text-indigo-100 text-xs mt-1">Análisis de ocupación por habitación</p>
                            </div>
                            <div class="p-4 text-gray-600 text-sm">
                                <i class="fas fa-arrow-right mr-2 text-indigo-600"></i>Ver detalles
                            </div>
                        </button>

                        <!-- Reporte Ingresos -->
                        <button onclick="generarReporte('ingresos')" class="group bg-white rounded-xl shadow-md overflow-hidden hover:shadow-xl transition transform hover:scale-105">
                            <div class="bg-gradient-to-br from-teal-500 to-teal-600 p-6 text-white">
                                <i class="fas fa-money-bill-wave text-4xl mb-4"></i>
                                <h3 class="text-xl font-bold">Reporte de Ingresos</h3>
                                <p class="text-teal-100 text-xs mt-1">Análisis financiero detallado</p>
                            </div>
                            <div class="p-4 text-gray-600 text-sm">
                                <i class="fas fa-arrow-right mr-2 text-teal-600"></i>Ver detalles
                            </div>
                        </button>
                    </div>

                    <!-- Contenido Dinámico -->
                    <div id="contenidoReporte" class="bg-white rounded-xl shadow-md p-8">
                        <div class="text-center py-12">
                            <i class="fas fa-chart-bar text-6xl text-gray-300 mb-4"></i>
                            <p class="text-gray-500 text-lg">Selecciona un reporte para ver los datos y análisis</p>
                            <p class="text-gray-400 text-sm mt-2">Los reportes se cargarán dinámicamente desde el servidor</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="js/common.js"></script>
    <script src="js/avatar-global.js"></script>
    <script src="js/topbar.js"></script>
    <script src="js/reportes.js"></script>
</body>
</html>

