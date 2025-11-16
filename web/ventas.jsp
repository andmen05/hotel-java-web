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
    <title>Ventas a Habitaciones - Hotel Paradise</title>
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
                <a class="flex items-center px-4 py-2.5 bg-primary text-white rounded-lg font-semibold" href="ventas.jsp">
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
                    <h2 class="text-2xl font-bold text-gray-900">Ventas a Habitaciones</h2>
                    <p class="text-sm text-gray-500">Gestiona ventas de productos a los huéspedes</p>
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

            <!-- Scrollable Content -->
            <div class="flex-1 overflow-auto">
                <div class="p-8">
                    <!-- KPI Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Ventas Hoy</p>
                                <p class="text-2xl font-bold text-gray-900" id="ventasHoy">$0</p>
                                <p class="text-xs text-gray-400">Total del día</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                                <span class="material-icons-outlined text-2xl">attach_money</span>
                            </div>
                        </div>
                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Transacciones</p>
                                <p class="text-2xl font-bold text-gray-900" id="transacciones">0</p>
                                <p class="text-xs text-gray-400">Ventas registradas</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                                <span class="material-icons-outlined text-2xl">receipt</span>
                            </div>
                        </div>
                        <div class="bg-white p-5 rounded-lg shadow-sm flex items-center justify-between border border-gray-100">
                            <div>
                                <p class="text-sm text-gray-500">Ticket Promedio</p>
                                <p class="text-2xl font-bold text-gray-900" id="ticketPromedio">$0</p>
                                <p class="text-xs text-gray-400">Venta promedio</p>
                            </div>
                            <div class="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center text-purple-600">
                                <span class="material-icons-outlined text-2xl">trending_up</span>
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
                                                <option value="1">Cerveza</option>
                                                <option value="2">Agua</option>
                                                <option value="3">Refresco</option>
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

                                    <button type="button" id="btnAgregarCarrito" onclick="console.log('Click en botón'); agregarProducto();" class="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-4 py-3 rounded-lg transition font-semibold flex items-center justify-center space-x-2">
                                        <span class="material-icons-outlined">add_shopping_cart</span>
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
                                    <button type="button" onclick="procesarVenta(event);" class="w-full bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-4 py-3 rounded-lg transition font-semibold flex items-center justify-center space-x-2 mt-4">
                                        <span class="material-icons-outlined">check_circle</span>
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

