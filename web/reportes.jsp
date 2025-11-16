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
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Reportes y Análisis - Hotel Paradise</title>
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
                <a class="flex items-center px-4 py-2.5 bg-primary text-white rounded-lg font-semibold" href="reportes.jsp">
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
                    <h2 class="text-2xl font-bold text-gray-900">Reportes y Análisis</h2>
                    <p class="text-sm text-gray-500">Visualiza datos y estadísticas del hotel</p>
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

            <div class="p-6 flex-1">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                    <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                        <div>
                            <p class="text-sm text-gray-500">Ocupación</p>
                            <p class="text-2xl font-bold text-gray-900" id="ocupacion">0%</p>
                            <p class="text-xs text-gray-400">Habitaciones ocupadas</p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-teal-100 flex items-center justify-center text-teal-600">
                            <span class="material-icons-outlined text-2xl">hotel</span>
                        </div>
                    </div>
                    <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                        <div>
                            <p class="text-sm text-gray-500">Ingresos Totales</p>
                            <p class="text-2xl font-bold text-gray-900" id="ingresos">$0</p>
                            <p class="text-xs text-gray-400">Este mes</p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                            <span class="material-icons-outlined text-2xl">attach_money</span>
                        </div>
                    </div>
                    <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                        <div>
                            <p class="text-sm text-gray-500">Clientes Activos</p>
                            <p class="text-2xl font-bold text-gray-900" id="clientesActivos">0</p>
                            <p class="text-xs text-gray-400">Huéspedes registrados</p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center text-purple-600">
                            <span class="material-icons-outlined text-2xl">groups</span>
                        </div>
                    </div>
                    <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                        <div>
                            <p class="text-sm text-gray-500">Reservas Pendientes</p>
                            <p class="text-2xl font-bold text-gray-900" id="reservasPendientes">0</p>
                            <p class="text-xs text-gray-400">Próximos 30 días</p>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-rose-100 flex items-center justify-center text-rose-600">
                            <span class="material-icons-outlined text-2xl">calendar_today</span>
                        </div>
                    </div>
                </div>
                <h3 class="text-xl font-semibold mb-4 text-gray-800">Informes Detallados</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <div class="bg-white rounded-lg shadow-sm overflow-hidden flex flex-col group border border-gray-100 cursor-pointer hover:shadow-md transition-shadow">
                        <div class="p-6 bg-blue-500 text-white flex-1 flex flex-col items-center justify-center text-center">
                            <span class="material-icons-outlined text-5xl mb-2 opacity-80">show_chart</span>
                            <h4 class="text-lg font-semibold">Reporte de Ventas</h4>
                            <p class="text-sm opacity-90">Análisis de ventas por período</p>
                        </div>
                        <button onclick="generarReporte('ventas')" class="block p-4 bg-gray-50 text-sm text-center text-blue-600 font-medium hover:bg-gray-100 transition-colors duration-200 w-full">Ver detalles</button>
                    </div>
                    <div class="bg-white rounded-lg shadow-sm overflow-hidden flex flex-col group border border-gray-100 cursor-pointer hover:shadow-md transition-shadow">
                        <div class="p-6 bg-green-500 text-white flex-1 flex flex-col items-center justify-center text-center">
                            <span class="material-icons-outlined text-5xl mb-2 opacity-80">login</span>
                            <h4 class="text-lg font-semibold">Reporte de Check-ins</h4>
                            <p class="text-sm opacity-90">Entrada y salida de huéspedes</p>
                        </div>
                        <button onclick="generarReporte('checkins')" class="block p-4 bg-gray-50 text-sm text-center text-green-600 font-medium hover:bg-gray-100 transition-colors duration-200 w-full">Ver detalles</button>
                    </div>
                    <div class="bg-white rounded-lg shadow-sm overflow-hidden flex flex-col group border border-gray-100 cursor-pointer hover:shadow-md transition-shadow">
                        <div class="p-6 bg-orange-500 text-white flex-1 flex flex-col items-center justify-center text-center">
                            <span class="material-icons-outlined text-5xl mb-2 opacity-80">event_available</span>
                            <h4 class="text-lg font-semibold">Reporte de Reservas</h4>
                            <p class="text-sm opacity-90">Estado de reservaciones</p>
                        </div>
                        <button onclick="generarReporte('reservas')" class="block p-4 bg-gray-50 text-sm text-center text-orange-600 font-medium hover:bg-gray-100 transition-colors duration-200 w-full">Ver detalles</button>
                    </div>
                    <div class="bg-white rounded-lg shadow-sm overflow-hidden flex flex-col group border border-gray-100 cursor-pointer hover:shadow-md transition-shadow lg:col-span-1.5">
                        <div class="p-6 bg-indigo-500 text-white flex-1 flex flex-col items-center justify-center text-center">
                            <span class="material-icons-outlined text-5xl mb-2 opacity-80">pie_chart</span>
                            <h4 class="text-lg font-semibold">Reporte de Ocupación</h4>
                            <p class="text-sm opacity-90">Análisis de ocupación por habitación</p>
                        </div>
                        <button onclick="generarReporte('ocupacion')" class="block p-4 bg-gray-50 text-sm text-center text-indigo-600 font-medium hover:bg-gray-100 transition-colors duration-200 w-full">Ver detalles</button>
                    </div>
                    <div class="bg-white rounded-lg shadow-sm overflow-hidden flex flex-col group border border-gray-100 cursor-pointer hover:shadow-md transition-shadow lg:col-span-1.5">
                        <div class="p-6 bg-teal-500 text-white flex-1 flex flex-col items-center justify-center text-center">
                            <span class="material-icons-outlined text-5xl mb-2 opacity-80">payments</span>
                            <h4 class="text-lg font-semibold">Reporte de Ingresos</h4>
                            <p class="text-sm opacity-90">Análisis financiero detallado</p>
                        </div>
                        <button onclick="generarReporte('ingresos')" class="block p-4 bg-gray-50 text-sm text-center text-teal-600 font-medium hover:bg-gray-100 transition-colors duration-200 w-full">Ver detalles</button>
                    </div>
                </div>
                <!-- Contenedor de Reportes Dinámicos -->
                <div id="contenidoReporte" class="mt-12 bg-white rounded-lg shadow-sm p-6 border border-gray-100">
                    <div class="text-center py-12">
                        <span class="material-icons-outlined text-6xl text-gray-300">insights</span>
                        <p class="text-gray-500 text-lg mt-4">Selecciona un reporte para ver los datos y análisis</p>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="js/common.js"></script>
    <script src="js/avatar-global.js"></script>
    <script src="js/topbar.js"></script>
    <script src="js/reportes.js"></script>
</body>
</html>

