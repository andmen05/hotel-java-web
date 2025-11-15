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
    <title>Check-in/Check-out - Sistema Hotelero</title>
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
                <a href="checkin.jsp" class="flex items-center space-x-3 px-4 py-3 bg-indigo-700 rounded-lg hover:bg-indigo-600 transition">
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
                    <h2 class="text-2xl font-bold text-gray-800">Check-in / Check-out</h2>
                    <p class="text-gray-600 text-sm">Registro de entrada y salida de huéspedes</p>
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
                    <!-- Agenda de Reservas (Arriba) -->
                    <div class="mb-8">
                        <div class="bg-white rounded-xl shadow-md overflow-hidden">
                            <div class="bg-gradient-to-r from-purple-500 to-purple-600 p-6 text-white flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <i class="fas fa-calendar-alt text-3xl"></i>
                                    <div>
                                        <h3 class="text-xl font-bold">📅 Agenda de Reservas - Próximos 7 Días</h3>
                                        <p class="text-purple-100 text-xs">Reservas confirmadas por fecha</p>
                                    </div>
                                </div>
                                <div class="bg-white bg-opacity-20 px-4 py-2 rounded-lg text-sm font-semibold">
                                    <span id="totalReservasProximas">0</span> reservas
                                </div>
                            </div>
                            <div class="p-6">
                                <div id="agendaReservas" class="grid grid-cols-1 md:grid-cols-7 gap-3">
                                    <!-- Se llenará dinámicamente -->
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <!-- Formulario Check-in (Columna Izquierda) -->
                        <div class="lg:col-span-1">
                            <div class="bg-white rounded-xl shadow-md overflow-hidden sticky top-8">
                                <!-- Header -->
                                <div class="bg-gradient-to-r from-green-500 to-green-600 p-6 text-white">
                                    <div class="flex items-center space-x-3">
                                        <i class="fas fa-sign-in-alt text-3xl"></i>
                                        <div>
                                            <h3 class="text-xl font-bold">Nuevo Check-in</h3>
                                            <p class="text-green-100 text-xs">Registra entrada de huéspedes</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Form -->
                                <form id="formCheckIn" onsubmit="guardarCheckIn(event)" class="p-6 space-y-4">
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="fas fa-user mr-2 text-green-600"></i>Cliente
                                        </label>
                                        <select id="clienteCheckIn" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition">
                                            <option value="">Selecciona un cliente</option>
                                        </select>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="fas fa-door-open mr-2 text-green-600"></i>Habitación
                                        </label>
                                        <select id="habitacionCheckIn" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition">
                                            <option value="">Selecciona una habitación</option>
                                        </select>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="fas fa-calendar-check mr-2 text-green-600"></i>Fecha de Ingreso
                                        </label>
                                        <input type="datetime-local" id="fechaIngreso" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="fas fa-moon mr-2 text-green-600"></i>Noches
                                        </label>
                                        <input type="number" id="noches" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="fas fa-car mr-2 text-green-600"></i>Transporte
                                        </label>
                                        <input type="text" id="transporte" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition" placeholder="Ej: Avión, Carro">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="fas fa-compass mr-2 text-green-600"></i>Motivo del Viaje
                                        </label>
                                        <input type="text" id="motivoViaje" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition" placeholder="Negocios, Turismo, etc.">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="fas fa-map-marker-alt mr-2 text-green-600"></i>Procedencia
                                        </label>
                                        <input type="text" id="procedencia" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition" placeholder="Ciudad/País">
                                    </div>

                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">
                                            <i class="fas fa-users mr-2 text-green-600"></i>Acompañantes
                                        </label>
                                        <input type="number" id="acompanantes" value="0" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-green-600 focus:ring-2 focus:ring-green-100 transition">
                                    </div>

                                    <button type="submit" class="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-4 py-3 rounded-lg transition font-semibold flex items-center justify-center space-x-2 mt-6">
                                        <i class="fas fa-sign-in-alt"></i>
                                        <span>Registrar Check-in</span>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Check-ins Activos (Columna Derecha) -->
                        <div class="lg:col-span-2">
                            <div class="bg-white rounded-xl shadow-md overflow-hidden">
                                <!-- Header -->
                                <div class="bg-gradient-to-r from-blue-500 to-blue-600 p-6 text-white flex items-center justify-between">
                                    <div class="flex items-center space-x-3">
                                        <i class="fas fa-list text-3xl"></i>
                                        <div>
                                            <h3 class="text-xl font-bold">Huéspedes Activos</h3>
                                            <p class="text-blue-100 text-xs">Registros de check-in vigentes</p>
                                        </div>
                                    </div>
                                    <div class="bg-white bg-opacity-20 px-4 py-2 rounded-lg">
                                        <p class="text-2xl font-bold" id="totalActivos">0</p>
                                    </div>
                                </div>

                                <!-- Table -->
                                <div class="overflow-x-auto">
                                    <table class="w-full">
                                        <thead class="bg-gray-100 border-b-2 border-gray-200">
                                            <tr>
                                                <th class="px-6 py-4 text-left font-semibold text-gray-700">Cliente</th>
                                                <th class="px-6 py-4 text-left font-semibold text-gray-700">Habitación</th>
                                                <th class="px-6 py-4 text-left font-semibold text-gray-700">Ingreso</th>
                                                <th class="px-6 py-4 text-left font-semibold text-gray-700">Noches</th>
                                                <th class="px-6 py-4 text-center font-semibold text-gray-700">Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody id="tablaCheckIns" class="divide-y divide-gray-200">
                                            <!-- Los check-ins se cargarán aquí dinámicamente -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Check-out -->
    <div id="modalCheckOut" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md">
            <!-- Modal Header -->
            <div class="bg-gradient-to-r from-red-500 to-red-600 text-white p-6">
                <div class="flex justify-between items-center">
                    <div class="flex items-center space-x-3">
                        <i class="fas fa-sign-out-alt text-3xl"></i>
                        <div>
                            <h3 class="text-2xl font-bold">Check-out</h3>
                            <p class="text-red-100 text-xs">Registra salida de huésped</p>
                        </div>
                    </div>
                    <button onclick="cerrarModalCheckOut()" class="text-white hover:bg-red-700 p-2 rounded-lg transition">
                        <i class="fas fa-times text-xl"></i>
                    </button>
                </div>
            </div>

            <!-- Modal Body -->
            <form id="formCheckOut" onsubmit="hacerCheckOut(event)" class="p-6 space-y-4">
                <input type="hidden" id="checkInId">
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-calendar-times mr-2 text-red-600"></i>Fecha de Salida
                    </label>
                    <input type="datetime-local" id="fechaSalida" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-red-600 focus:ring-2 focus:ring-red-100 transition">
                </div>

                <!-- Modal Footer -->
                <div class="flex justify-end space-x-3 pt-4 border-t">
                    <button type="button" onclick="cerrarModalCheckOut()" class="px-6 py-2 bg-gray-200 hover:bg-gray-300 text-gray-800 rounded-lg transition font-semibold">
                        Cancelar
                    </button>
                    <button type="submit" class="px-6 py-2 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white rounded-lg transition font-semibold flex items-center space-x-2">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Confirmar Check-out</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="js/common.js"></script>
    <script src="js/avatar-global.js"></script>
    <script src="js/topbar.js"></script>
    <script src="js/checkin.js"></script>
</body>
</html>

