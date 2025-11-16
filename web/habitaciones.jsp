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
    <title>Habitaciones - Hotel Paradise</title>
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
                <a class="flex items-center px-4 py-2.5 bg-primary text-white rounded-lg font-semibold" href="habitaciones.jsp">
                    <span class="material-icons-outlined mr-3">king_bed</span>
                    Habitaciones
                </a>
                <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-colors duration-200" href="reservas.jsp">
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
                    <h2 class="text-2xl font-bold text-gray-900">Gestión de Habitaciones</h2>
                    <p class="text-sm text-gray-500">Control completo del inventario de habitaciones</p>
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
                    <!-- Header with Buttons -->
                    <div class="flex justify-between items-center mb-6">
                        <div>
                            <h3 class="text-lg font-semibold text-gray-800">Gestión de Habitaciones</h3>
                        </div>
                        <div class="flex space-x-3">
                            <button onclick="exportarHabitaciones()" class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg transition flex items-center space-x-2 font-semibold text-sm">
                                <span class="material-icons-outlined text-lg">download</span>
                                <span>Exportar</span>
                            </button>
                            <button onclick="abrirModalNuevo()" class="px-6 py-2 bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 text-white rounded-lg transition flex items-center space-x-2 font-semibold">
                                <span class="material-icons-outlined">add</span>
                                <span>Nueva Habitación</span>
                            </button>
                        </div>
                    </div>

                    <!-- KPI Stats - Estilo Reportes -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 mb-8">
                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Total Habitaciones</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="totalHabitaciones">0</p>
                                <p class="text-xs text-gray-400">En el hotel</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                                <span class="material-icons-outlined text-2xl">king_bed</span>
                            </div>
                        </div>

                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Disponibles</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="disponibles">0</p>
                                <p class="text-xs text-gray-400">Listas para reservar</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                                <span class="material-icons-outlined text-2xl">check_circle</span>
                            </div>
                        </div>

                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Ocupadas</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="ocupadas">0</p>
                                <p class="text-xs text-gray-400">Con huéspedes</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center text-red-600">
                                <span class="material-icons-outlined text-2xl">person</span>
                            </div>
                        </div>

                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Mantenimiento</p>
                                <p class="text-2xl font-bold text-gray-900 mt-1" id="mantenimiento">0</p>
                                <p class="text-xs text-gray-400">En reparación</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-orange-100 flex items-center justify-center text-orange-600">
                                <span class="material-icons-outlined text-2xl">build</span>
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

                    <!-- Search and Filters -->
                    <div class="bg-white rounded-lg shadow-sm p-4 mb-6 border border-gray-100">
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <div>
                                <label class="block text-xs font-semibold text-gray-700 mb-2">Buscar</label>
                                <input type="text" id="buscarHabitacion" placeholder="ID, tipo..." class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-primary">
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-700 mb-2">Tipo</label>
                                <select id="filtroTipo" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-primary">
                                    <option value="">Todos</option>
                                    <option value="Individual">Individual</option>
                                    <option value="Doble">Doble</option>
                                    <option value="Suite">Suite</option>
                                    <option value="Presidencial">Presidencial</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-700 mb-2">Estado</label>
                                <select id="filtroEstado" class="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-primary">
                                    <option value="">Todos</option>
                                    <option value="Disponible">Disponible</option>
                                    <option value="Ocupada">Ocupada</option>
                                    <option value="Limpieza">Limpieza</option>
                                    <option value="Mantenimiento">Mantenimiento</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-gray-700 mb-2">Rango Precio</label>
                                <input type="range" id="filtroRango" min="0" max="500" step="10" class="w-full">
                                <p class="text-xs text-gray-500 mt-1">$0 - $<span id="rangoValor">500</span></p>
                            </div>
                        </div>
                    </div>

                    <!-- Habitaciones Table -->
                    <div class="bg-white rounded-lg shadow-sm overflow-hidden border border-gray-100">
                        <div class="overflow-x-auto">
                            <table class="w-full text-sm">
                                <thead class="bg-gray-50 border-b border-gray-200 sticky top-0">
                                    <tr>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">ID</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Tipo</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Estado</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Capacidad</th>
                                        <th class="px-4 py-3 text-left font-semibold text-gray-700">Precio/Noche</th>
                                        <th class="px-4 py-3 text-center font-semibold text-gray-700">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody id="tablaHabitaciones" class="divide-y divide-gray-200">
                                    <!-- Las habitaciones se cargarán aquí dinámicamente -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div id="modalHabitacion" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md max-h-[90vh] overflow-y-auto">
            <!-- Modal Header -->
            <div class="bg-gradient-to-r from-indigo-600 to-indigo-700 text-white p-6 sticky top-0">
                <div class="flex justify-between items-center">
                    <h3 class="text-2xl font-bold" id="modalTitulo">Nueva Habitación</h3>
                    <button onclick="cerrarModal()" class="text-white hover:bg-indigo-800 p-2 rounded-lg transition">
                        <i class="fas fa-times text-xl"></i>
                    </button>
                </div>
            </div>

            <!-- Modal Body -->
            <form id="formHabitacion" onsubmit="guardarHabitacion(event)" class="p-6 space-y-4">
                <input type="hidden" id="habitacionId">
                
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-door-open mr-2 text-indigo-600"></i>ID Habitación
                    </label>
                    <input type="text" id="idHabitacion" required 
                           class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition"
                           placeholder="Ej: 101">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-bed mr-2 text-indigo-600"></i>Tipo de Habitación
                    </label>
                    <select id="tipoHabitacion" required 
                            class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition">
                        <option value="">Selecciona un tipo</option>
                        <option value="Individual">Individual</option>
                        <option value="Doble">Doble</option>
                        <option value="Suite">Suite</option>
                        <option value="Presidencial">Presidencial</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-info-circle mr-2 text-indigo-600"></i>Estado
                    </label>
                    <select id="estado" required 
                            class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition">
                        <option value="">Selecciona un estado</option>
                        <option value="Disponible">Disponible</option>
                        <option value="Ocupada">Ocupada</option>
                        <option value="Limpieza">Limpieza</option>
                        <option value="Mantenimiento">Mantenimiento</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-dollar-sign mr-2 text-indigo-600"></i>Precio por Noche
                    </label>
                    <input type="number" id="precioNoche" step="0.01" required 
                           class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition"
                           placeholder="0.00">
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                        <i class="fas fa-users mr-2 text-indigo-600"></i>Capacidad (personas)
                    </label>
                    <input type="number" id="capacidad" required 
                           class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition"
                           placeholder="1">
                </div>

                <!-- Modal Footer -->
                <div class="flex justify-end space-x-3 pt-4 border-t">
                    <button type="button" onclick="cerrarModal()" 
                            class="px-6 py-2 bg-gray-200 hover:bg-gray-300 text-gray-800 rounded-lg transition font-semibold">
                        Cancelar
                    </button>
                    <button type="submit" 
                            class="px-6 py-2 bg-gradient-to-r from-indigo-600 to-blue-600 hover:from-indigo-700 hover:to-blue-700 text-white rounded-lg transition font-semibold flex items-center space-x-2">
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
    <script src="js/habitaciones.js"></script>
</body>
</html>

