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
    <title>Reservas - Hotel Paradise</title>
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
                <a class="flex items-center px-4 py-2.5 bg-primary text-white rounded-lg font-semibold" href="reservas.jsp">
                    <span class="material-icons-outlined mr-3">book_online</span>
                    Reservas
                </a>
                <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-colors duration-200" href="checkin.jsp">
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
                    <h2 class="text-2xl font-bold text-gray-900">Gestión de Reservas</h2>
                    <p class="text-sm text-gray-500">Administra todas tus reservas del hotel</p>
                </div>
                <div class="flex items-center space-x-4 relative">
                    <button class="p-2 rounded-full text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
                        <span class="material-icons-outlined">notifications</span>
                    </button>
                    <button class="p-2 rounded-full text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
                        <span class="material-icons-outlined">settings</span>
                    </button>
                    <button id="avatarBtn" class="w-10 h-10 rounded-full bg-primary flex items-center justify-center text-white font-bold text-lg cursor-pointer hover:ring-2 hover:ring-primary hover:ring-offset-2 transition-all relative">
                        <%= usuario.getNombre() != null && usuario.getNombre().length() > 0 ? usuario.getNombre().charAt(0) : "A" %>
                    </button>
                    <!-- Menú desplegable del usuario -->
                    <div id="userMenu" class="hidden absolute right-0 top-14 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50">
                        <a href="perfil.jsp" class="flex items-center px-4 py-2 text-gray-700 hover:bg-gray-100 transition-colors">
                            <span class="material-icons-outlined mr-3 text-lg">person</span>
                            <span>Mi Perfil</span>
                        </a>
                        <a href="logout" class="flex items-center px-4 py-2 text-red-600 hover:bg-red-50 transition-colors">
                            <span class="material-icons-outlined mr-3 text-lg">logout</span>
                            <span>Cerrar Sesión</span>
                        </a>
                    </div>
                </div>
            </header>

            <div class="flex-1 overflow-auto">
                <div class="p-8">
                    <!-- Header with Buttons -->
                    <div class="flex justify-between items-center mb-6">
                        <div>
                            <h3 class="text-lg font-semibold text-gray-800">Gestión de Reservas</h3>
                        </div>
                        <div class="flex space-x-3">
                            <button onclick="exportarReservas()" class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg transition flex items-center space-x-2 font-semibold text-sm">
                                <span class="material-icons-outlined text-lg">download</span>
                                <span>Exportar</span>
                            </button>
                            <button onclick="abrirModalNuevo()" class="px-6 py-2 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white rounded-lg transition flex items-center space-x-2 font-semibold">
                                <span class="material-icons-outlined">add</span>
                                <span>Nueva Reserva</span>
                            </button>
                        </div>
                    </div>

                    <!-- KPI Stats - Estilo Reportes -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 mb-8">
                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Total Reservas</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="totalReservas">0</p>
                                <p class="text-xs text-gray-400">Todas</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                                <span class="material-icons-outlined text-2xl">book_online</span>
                            </div>
                        </div>

                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Confirmadas</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="reservasConfirmadas">0</p>
                                <p class="text-xs text-gray-400">Activas</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                                <span class="material-icons-outlined text-2xl">check_circle</span>
                            </div>
                        </div>

                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Pendientes</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="reservasPendientes">0</p>
                                <p class="text-xs text-gray-400">Por confirmar</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-orange-100 flex items-center justify-center text-orange-600">
                                <span class="material-icons-outlined text-2xl">schedule</span>
                            </div>
                        </div>

                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Ocupación Hoy</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="ocupacionHoy">0%</p>
                                <p class="text-xs text-gray-400">Habitaciones</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center text-purple-600">
                                <span class="material-icons-outlined text-2xl">hotel</span>
                            </div>
                        </div>

                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Ingresos Proyectados</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="ingresosProyectados">$0</p>
                                <p class="text-xs text-gray-400">Este mes</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                                <span class="material-icons-outlined text-2xl">trending_up</span>
                            </div>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="bg-white rounded-lg shadow-sm p-4 mb-6 border border-gray-100">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
                            <div>
                                <label class="block text-xs font-semibold text-gray-700 mb-2">Buscar</label>
                                <input type="text" id="buscarReserva" placeholder="Cliente, email..." class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-primary">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-700 mb-2">Estado</label>
                                <select id="filtroEstado" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-primary">
                                    <option value="">Todos</option>
                                    <option value="Confirmada">Confirmada</option>
                                    <option value="Pendiente">Pendiente</option>
                                    <option value="Cancelada">Cancelada</option>
                                    <option value="Finalizada">Finalizada</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-700 mb-2">Fecha Salida</label>
                                <input type="date" id="filtroFechaSalida" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-primary">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-700 mb-2">Habitación</label>
                                <select id="filtroHabitacion" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-primary">
                                    <option value="">Todas</option>
                                </select>
                            </div>
                        </div>
                        <div class="mt-3 flex space-x-2 text-sm">
                            <button type="button" onclick="filtrarPorPeriodo('hoy')" class="px-3 py-1 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded transition cursor-pointer text-xs">Hoy</button>
                            <button type="button" onclick="filtrarPorPeriodo('semana')" class="px-3 py-1 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded transition cursor-pointer text-xs">Esta semana</button>
                            <button type="button" onclick="filtrarPorPeriodo('mes')" class="px-3 py-1 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded transition cursor-pointer text-xs">Este mes</button>
                        </div>
                    </div>

                    <!-- Table -->
                    <div class="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-100">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-gray-50 border-b border-gray-200 sticky top-0">
                                    <tr>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">ID</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Cliente</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Habitación</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Check-in</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Check-out</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Noches</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Estado</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Total</th>
                                        <th class="px-4 py-3 text-center font-semibold text-gray-700">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="tablaReservas" class="divide-y divide-gray-200">
                                    <!-- Las reservas se cargarán aquí dinámicamente -->
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination -->
                        <div class="bg-gray-50 px-6 py-4 flex justify-between items-center border-t">
                            <p class="text-sm text-gray-600" id="paginationInfo">Cargando...</p>
                            <div class="flex space-x-2" id="paginationButtons">
                                <!-- Los botones de paginación se cargarán aquí dinámicamente -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div id="modalReserva" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-lg shadow-2xl w-full max-w-md max-h-[90vh] overflow-y-auto border border-gray-100">
            <!-- Modal Header -->
            <div class="bg-blue-600 text-white p-4 sticky top-0">
                <div class="flex justify-between items-center">
                    <div class="flex items-center space-x-2">
                        <span class="material-icons-outlined">book_online</span>
                        <h3 class="font-bold" id="modalTitulo">Nueva Reserva</h3>
                    </div>
                    <button onclick="cerrarModal()" class="text-white hover:bg-blue-700 p-1 rounded transition">
                        <span class="material-icons-outlined">close</span>
                    </button>
                </div>
            </div>

            <!-- Modal Body -->
            <form id="formReserva" onsubmit="guardarReserva(event)" class="p-4 space-y-3">
                <input type="hidden" id="reservaId">
                
                <div>
                    <label class="block text-xs font-semibold text-gray-700 mb-1">Cliente</label>
                    <select id="clienteReserva" required 
                            class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-600">
                        <option value="">Selecciona un cliente</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-gray-700 mb-1">Habitación</label>
                    <select id="habitacionReserva" required 
                            class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-600">
                        <option value="">Selecciona una habitación</option>
                    </select>
                </div>

                <div class="grid grid-cols-2 gap-2">
                    <div>
                        <label class="block text-xs font-semibold text-gray-700 mb-1">Entrada</label>
                        <input type="date" id="fechaEntrada" required 
                               class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-600">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-gray-700 mb-1">Salida</label>
                        <input type="date" id="fechaSalida" required 
                               class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-600">
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-gray-700 mb-1">Tipo Reserva</label>
                    <select id="tipoReserva" required 
                            class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-600">
                        <option value="">Selecciona un tipo</option>
                        <option value="Otro">Otro</option>
                        <option value="Airbnb">Airbnb</option>
                        <option value="Booking">Booking</option>
                        <option value="Directo">Directo</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-gray-700 mb-1">Estado</label>
                    <select id="estadoReserva" required 
                            class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-blue-600">
                        <option value="">Selecciona un estado</option>
                        <option value="Pendiente">Pendiente</option>
                        <option value="Confirmada">Confirmada</option>
                        <option value="Cancelada">Cancelada</option>
                        <option value="Finalizada">Finalizada</option>
                    </select>
                </div>

                <!-- Modal Footer -->
                <div class="flex justify-end space-x-3 pt-4 border-t">
                    <button type="button" onclick="cerrarModal()" 
                            class="px-6 py-2 bg-gray-200 hover:bg-gray-300 text-gray-800 rounded-lg transition font-semibold">
                        Cancelar
                    </button>
                    <button type="submit" 
                            class="px-6 py-2 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white rounded-lg transition font-semibold flex items-center space-x-2">
                        <span class="material-icons-outlined text-sm">save</span>
                        <span>Guardar</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="js/common.js"></script>
    <script src="js/avatar-global.js"></script>
    <script src="js/topbar.js"></script>
    <script src="js/reservas.js"></script>
</body>
</html>

