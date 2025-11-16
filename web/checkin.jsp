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
    <title>Check-in/Check-out - Hotel Paradise</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
    <script>
        tailwind.config = {
          theme: {
            extend: {
              colors: {
                primary: "#4F46E5",
                "background-light": "#F8FAFC",
              },
              fontFamily: {
                display: ["Poppins", "sans-serif"],
              },
              borderRadius: {
                DEFAULT: "0.75rem",
              },
            },
          },
        };
    </script>
    <style>
        .material-icons-outlined {
          font-size: inherit;
        }
    </style>
</head>
<body class="font-display bg-background-light text-gray-700">
    <div class="flex h-screen">
        <aside class="w-64 flex-shrink-0 bg-indigo-900 text-indigo-100 flex flex-col">
            <div class="p-6 text-center">
                <div class="bg-indigo-800 rounded-lg p-3 inline-flex items-center justify-center mb-2">
                    <span class="material-icons-outlined text-4xl text-white">hotel</span>
                </div>
                <h1 class="text-xl font-bold text-white">Hotel Paradise</h1>
                <p class="text-sm text-indigo-300">andmen05</p>
            </div>
            <nav class="flex-1 px-4 space-y-2">
                <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-colors duration-200" href="dashboard.jsp">
                    <span class="material-icons-outlined mr-3">dashboard</span>
                    Dashboard
                </a>
                <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-colors duration-200" href="clientes.jsp">
                    <span class="material-icons-outlined mr-3">people</span>
                    Clientes
                </a>
                <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-colors duration-200" href="habitaciones.jsp">
                    <span class="material-icons-outlined mr-3">king_bed</span>
                    Habitaciones
                </a>
                <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-colors duration-200" href="reservas.jsp">
                    <span class="material-icons-outlined mr-3">book_online</span>
                    Reservas
                </a>
                <a class="flex items-center px-4 py-2.5 bg-primary text-white rounded-lg font-semibold" href="checkin.jsp">
                    <span class="material-icons-outlined mr-3">login</span>
                    Check-in
                </a>
                <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-colors duration-200" href="productos.jsp">
                    <span class="material-icons-outlined mr-3">restaurant</span>
                    Productos
                </a>
                <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-colors duration-200" href="ventas.jsp">
                    <span class="material-icons-outlined mr-3">shopping_cart</span>
                    Ventas
                </a>
                <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-colors duration-200" href="reportes.jsp">
                    <span class="material-icons-outlined mr-3">assessment</span>
                    Reportes
                </a>
            </nav>
            <div class="p-4 mt-auto">
                <a href="logout" class="w-full flex items-center justify-center px-4 py-2.5 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-colors duration-200">
                    <span class="material-icons-outlined mr-2">logout</span>
                    Salir
                </a>
            </div>
        </aside>

        <main class="flex-1 flex flex-col overflow-y-auto">
            <header class="flex-shrink-0 bg-white border-b border-gray-200 p-6 flex justify-between items-center sticky top-0 z-10">
                <div>
                    <h2 class="text-2xl font-bold text-gray-900">Check-in / Check-out</h2>
                    <p class="text-sm text-gray-500">Registro de entrada y salida de huéspedes</p>
                </div>
                <div class="flex items-center space-x-4">
                    <button class="p-2 rounded-full text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
                        <span class="material-icons-outlined">notifications</span>
                    </button>
                    <button class="p-2 rounded-full text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
                        <span class="material-icons-outlined">settings</span>
                    </button>
                    <div class="w-10 h-10 rounded-full bg-primary flex items-center justify-center text-white font-bold text-lg">
                        <%= usuario.getNombre() != null && usuario.getNombre().length() > 0 ? usuario.getNombre().charAt(0) : "A" %>
                    </div>
                </div>
            </header>

            <div class="flex-1 overflow-auto">
                <div class="p-8">
                    <!-- Agenda de Reservas (Arriba) -->
                    <div class="mb-8">
                        <div class="bg-white rounded-xl shadow-md overflow-hidden">
                            <div class="bg-gradient-to-r from-purple-500 to-purple-600 p-6 text-white flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <span class="material-icons-outlined text-3xl">calendar_month</span>
                                    <div>
                                        <h3 class="text-xl font-bold">Agenda de Reservas - Próximos 7 Días</h3>
                                        <p class="text-purple-100 text-xs">Reservas confirmadas por fecha</p>
                                    </div>
                                </div>
                                <div class="bg-white bg-opacity-20 px-4 py-2 rounded-lg text-sm font-semibold">
                                    <span id="totalReservasProximasHeader">0</span> reservas
                                </div>
                            </div>
                            <div class="p-6">
                                <div id="agendaReservas" class="grid grid-cols-1 md:grid-cols-7 gap-3">
                                    <!-- Se llenará dinámicamente -->
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- KPI Stats - Estilo Reportes -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Check-ins Hoy</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="checkinsHoyCount">0</p>
                                <p class="text-xs text-gray-400">Entrada de huéspedes</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                                <span class="material-icons-outlined text-2xl">login</span>
                            </div>
                        </div>
                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Huéspedes Activos</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="totalActivos">0</p>
                                <p class="text-xs text-gray-400">Check-ins vigentes</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                                <span class="material-icons-outlined text-2xl">people</span>
                            </div>
                        </div>
                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Próximas Reservas</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="totalReservasProximas">0</p>
                                <p class="text-xs text-gray-400">Próximos 7 días</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center text-purple-600">
                                <span class="material-icons-outlined text-2xl">calendar_month</span>
                            </div>
                        </div>
                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Check-outs Hoy</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="checkoutsHoyCount">0</p>
                                <p class="text-xs text-gray-400">Salida de huéspedes</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-orange-100 flex items-center justify-center text-orange-600">
                                <span class="material-icons-outlined text-2xl">logout</span>
                            </div>
                        </div>
                    </div>

                    <!-- Check-in & Check-out Grid -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <!-- Formulario Check-in (Columna Izquierda) -->
                        <div class="lg:col-span-1">
                            <div class="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-100 sticky top-8">
                                <!-- Header -->
                                <div class="bg-green-500 p-4 text-white flex items-center space-x-2">
                                    <span class="material-icons-outlined text-2xl">login</span>
                                    <div>
                                        <h3 class="font-semibold">Nuevo Check-in</h3>
                                        <p class="text-green-100 text-xs">Registra entrada</p>
                                    </div>
                                </div>

                                <!-- Form - Compacto y limpio -->
                                <form id="formCheckIn" onsubmit="guardarCheckIn(event)" class="p-4 space-y-3">
                                    <div>
                                        <label class="block text-xs font-semibold text-gray-700 mb-1">Cliente</label>
                                        <select id="clienteCheckIn" required class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-green-600">
                                            <option value="">Selecciona</option>
                                        </select>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-semibold text-gray-700 mb-1">Habitación</label>
                                        <select id="habitacionCheckIn" required class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-green-600">
                                            <option value="">Selecciona</option>
                                        </select>
                                    </div>

                                    <div class="grid grid-cols-2 gap-2">
                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Ingreso</label>
                                            <input type="datetime-local" id="fechaIngreso" required class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-green-600">
                                        </div>
                                        <div>
                                            <label class="block text-xs font-semibold text-gray-700 mb-1">Noches</label>
                                            <input type="number" id="noches" required class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-green-600">
                                        </div>
                                    </div>

                                    <div>
                                        <label class="block text-xs font-semibold text-gray-700 mb-1">Transporte</label>
                                        <input type="text" id="transporte" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-green-600" placeholder="Avión, Carro...">
                                    </div>

                                    <div>
                                        <label class="block text-xs font-semibold text-gray-700 mb-1">Motivo</label>
                                        <input type="text" id="motivoViaje" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-green-600" placeholder="Negocios, Turismo...">
                                    </div>

                                    <div>
                                        <label class="block text-xs font-semibold text-gray-700 mb-1">Procedencia</label>
                                        <input type="text" id="procedencia" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-green-600" placeholder="Ciudad/País">
                                    </div>

                                    <div>
                                        <label class="block text-xs font-semibold text-gray-700 mb-1">Acompañantes</label>
                                        <input type="number" id="acompanantes" value="0" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-green-600">
                                    </div>

                                    <button type="submit" class="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-3 py-2 rounded-lg transition font-semibold text-sm flex items-center justify-center space-x-2 mt-4">
                                        <span class="material-icons-outlined text-lg">login</span>
                                        <span>Registrar</span>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Check-ins Activos (Columna Derecha - Expandida) -->
                        <div class="lg:col-span-2">
                            <div class="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-100">
                                <!-- Header -->
                                <div class="bg-blue-500 p-4 text-white flex items-center space-x-2">
                                    <span class="material-icons-outlined text-2xl">people</span>
                                    <div>
                                        <h3 class="font-semibold">Huéspedes Activos</h3>
                                        <p class="text-blue-100 text-xs">Check-ins vigentes</p>
                                    </div>
                                </div>

                                <!-- Table -->
                                <div class="overflow-x-auto max-h-96">
                                    <table class="w-full text-sm">
                                        <thead class="bg-gray-50 border-b border-gray-200 sticky top-0">
                                            <tr>
                                                <th class="px-4 py-3 text-left font-semibold text-gray-700">Cliente</th>
                                                <th class="px-4 py-3 text-left font-semibold text-gray-700">Habitación</th>
                                                <th class="px-4 py-3 text-left font-semibold text-gray-700">Ingreso</th>
                                                <th class="px-4 py-3 text-left font-semibold text-gray-700">Noches</th>
                                                <th class="px-4 py-3 text-center font-semibold text-gray-700">Acciones</th>
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
                        <span class="material-icons-outlined text-3xl">logout</span>
                        <div>
                            <h3 class="text-2xl font-bold">Check-out</h3>
                            <p class="text-red-100 text-xs">Registra salida de huésped</p>
                        </div>
                    </div>
                    <button onclick="cerrarModalCheckOut()" class="text-white hover:bg-red-700 p-2 rounded-lg transition">
                        <span class="material-icons-outlined">close</span>
                    </button>
                </div>
            </div>

            <!-- Modal Body -->
            <form id="formCheckOut" onsubmit="hacerCheckOut(event)" class="p-6 space-y-4">
                <input type="hidden" id="checkInId">
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <span class="material-icons-outlined text-sm mr-2 text-red-600">event</span>Fecha de Salida
                    </label>
                    <input type="datetime-local" id="fechaSalida" required class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-red-600 focus:ring-2 focus:ring-red-100 transition">
                </div>

                <!-- Modal Footer -->
                <div class="flex justify-end space-x-3 pt-4 border-t">
                    <button type="button" onclick="cerrarModalCheckOut()" class="px-6 py-2 bg-gray-200 hover:bg-gray-300 text-gray-800 rounded-lg transition font-semibold">
                        Cancelar
                    </button>
                    <button type="submit" class="px-6 py-2 bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white rounded-lg transition font-semibold flex items-center space-x-2">
                        <span class="material-icons-outlined">logout</span>
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

