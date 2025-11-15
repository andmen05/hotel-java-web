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
    <title>Mi Perfil - Sistema Hotelero</title>
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
                <a href="reportes.jsp" class="flex items-center space-x-3 px-4 py-3 hover:bg-indigo-700 rounded-lg transition">
                    <i class="fas fa-chart-bar"></i>
                    <span>Reportes</span>
                </a>
                <a href="perfil.jsp" class="flex items-center space-x-3 px-4 py-3 bg-indigo-700 rounded-lg hover:bg-indigo-600 transition">
                    <i class="fas fa-user-circle"></i>
                    <span>Mi Perfil</span>
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
                    <h2 class="text-2xl font-bold text-gray-800">Mi Perfil</h2>
                    <p class="text-gray-600 text-sm">Gestiona tu información personal y seguridad</p>
                </div>
                <div class="flex items-center space-x-4">
                    <button class="p-2 hover:bg-gray-100 rounded-lg transition">
                        <i class="fas fa-bell text-gray-600 text-xl"></i>
                    </button>
                    <button class="p-2 hover:bg-gray-100 rounded-lg transition">
                        <i class="fas fa-cog text-gray-600 text-xl"></i>
                    </button>
                    <div class="w-10 h-10 bg-gradient-to-br from-indigo-500 to-blue-600 rounded-full flex items-center justify-center text-white font-bold">
                        <%= usuario.getNombre().charAt(0) %>
                    </div>
                </div>
            </div>

            <!-- Scrollable Content -->
            <div class="flex-1 overflow-auto">
                <div class="p-8">
                    <!-- Profile Header Card -->
                    <div class="bg-gradient-to-r from-indigo-600 to-blue-600 rounded-2xl shadow-lg p-8 text-white mb-8">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-6">
                                <div class="w-24 h-24 bg-white bg-opacity-20 rounded-full flex items-center justify-center border-4 border-white">
                                    <i class="fas fa-user text-5xl"></i>
                                </div>
                                <div>
                                    <h1 class="text-4xl font-bold"><%= usuario.getNombre() %></h1>
                                    <p class="text-indigo-100 text-lg">ID: <%= usuario.getId() %></p>
                                    <p class="text-indigo-100 mt-2">
                                        <i class="fas fa-user mr-2"></i>
                                        <%= usuario.getUsuario() != null ? usuario.getUsuario() : "No registrado" %>
                                    </p>
                                </div>
                            </div>
                            <div class="text-right">
                                <p class="text-indigo-100 text-sm">Miembro desde</p>
                                <p class="text-2xl font-bold">2024</p>
                            </div>
                        </div>
                    </div>

                    <!-- Two Column Layout -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        <!-- Left Column: Personal Info -->
                        <div class="lg:col-span-2 space-y-6">
                            <!-- Información Personal -->
                            <div class="bg-white rounded-2xl shadow-md p-8">
                                <div class="flex items-center justify-between mb-6">
                                    <h3 class="text-2xl font-bold text-gray-800 flex items-center space-x-3">
                                        <i class="fas fa-user-edit text-indigo-600"></i>
                                        <span>Información Personal</span>
                                    </h3>
                                    <button onclick="editarPerfil()" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg transition flex items-center space-x-2">
                                        <i class="fas fa-edit"></i>
                                        <span>Editar</span>
                                    </button>
                                </div>
                                
                                <form id="formPerfil" class="space-y-4" style="display: none;">
                                    <div class="grid grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">Nombre</label>
                                            <input type="text" id="nombre" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600" value="<%= usuario.getNombre() != null ? usuario.getNombre() : "" %>">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">Usuario</label>
                                            <input type="text" id="usuario" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600" value="<%= usuario.getUsuario() != null ? usuario.getUsuario() : "" %>">
                                        </div>
                                    </div>
                                    <div class="flex space-x-3 pt-4">
                                        <button type="submit" class="px-6 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg transition font-semibold">
                                            <i class="fas fa-save mr-2"></i>Guardar
                                        </button>
                                        <button type="button" onclick="cancelarEdicion()" class="px-6 py-2 bg-gray-400 hover:bg-gray-500 text-white rounded-lg transition font-semibold">
                                            <i class="fas fa-times mr-2"></i>Cancelar
                                        </button>
                                    </div>
                                </form>

                                <div id="infoPerfil" class="space-y-4">
                                    <div class="flex justify-between items-center pb-4 border-b border-gray-200">
                                        <span class="text-gray-600">Nombre:</span>
                                        <span class="font-semibold text-gray-800"><%= usuario.getNombre() != null ? usuario.getNombre() : "No registrado" %></span>
                                    </div>
                                    <div class="flex justify-between items-center pb-4 border-b border-gray-200">
                                        <span class="text-gray-600">Usuario:</span>
                                        <span class="font-semibold text-gray-800"><%= usuario.getUsuario() != null ? usuario.getUsuario() : "No registrado" %></span>
                                    </div>
                                    <div class="flex justify-between items-center pb-4 border-b border-gray-200">
                                        <span class="text-gray-600">ID Usuario:</span>
                                        <span class="font-semibold text-gray-800"><%= usuario.getId() %></span>
                                    </div>
                                    <div class="flex justify-between items-center">
                                        <span class="text-gray-600">Rol:</span>
                                        <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-semibold"><%= usuario.getRol() != null ? usuario.getRol() : "Usuario" %></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Cambiar Contraseña -->
                            <div class="bg-white rounded-2xl shadow-md p-8">
                                <h3 class="text-2xl font-bold text-gray-800 flex items-center space-x-3 mb-6">
                                    <i class="fas fa-lock text-red-600"></i>
                                    <span>Cambiar Contraseña</span>
                                </h3>
                                
                                <form id="formContrasena" class="space-y-4">
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">Contraseña Actual</label>
                                        <div class="relative">
                                            <input type="password" id="contraseniaActual" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600" placeholder="Ingresa tu contraseña actual">
                                            <button type="button" onclick="togglePassword('contraseniaActual')" class="absolute right-3 top-3 text-gray-500 hover:text-gray-700">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">Nueva Contraseña</label>
                                        <div class="relative">
                                            <input type="password" id="contraseniaNueva" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600" placeholder="Ingresa tu nueva contraseña">
                                            <button type="button" onclick="togglePassword('contraseniaNueva')" class="absolute right-3 top-3 text-gray-500 hover:text-gray-700">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">Confirmar Nueva Contraseña</label>
                                        <div class="relative">
                                            <input type="password" id="contraseniaConfirmar" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600" placeholder="Confirma tu nueva contraseña">
                                            <button type="button" onclick="togglePassword('contraseniaConfirmar')" class="absolute right-3 top-3 text-gray-500 hover:text-gray-700">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <button type="submit" class="w-full px-6 py-3 bg-red-600 hover:bg-red-700 text-white rounded-lg transition font-semibold mt-6">
                                        <i class="fas fa-key mr-2"></i>Cambiar Contraseña
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Right Column: Stats & Actions -->
                        <div class="space-y-6">
                            <!-- Foto de Perfil -->
                            <div class="bg-white rounded-2xl shadow-md p-8">
                                <h3 class="text-xl font-bold text-gray-800 flex items-center space-x-3 mb-6">
                                    <i class="fas fa-image text-blue-600"></i>
                                    <span>Foto de Perfil</span>
                                </h3>
                                
                                <div class="flex flex-col items-center space-y-4">
                                    <div id="avatarPerfil" class="w-32 h-32 bg-gradient-to-br from-indigo-500 to-blue-600 rounded-full flex items-center justify-center text-white border-4 border-gray-200 overflow-hidden">
                                        <i class="fas fa-user text-6xl"></i>
                                    </div>
                                    <button type="button" class="px-6 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition font-semibold flex items-center space-x-2 cursor-pointer">
                                        <i class="fas fa-upload"></i>
                                        <span>Subir Foto</span>
                                    </button>
                                    <p class="text-xs text-gray-500 text-center">JPG, PNG, GIF o WebP (máx. 5MB)</p>
                                </div>
                            </div>

                            <!-- Actividad Reciente -->
                            <div class="bg-white rounded-2xl shadow-md p-8">
                                <h3 class="text-xl font-bold text-gray-800 flex items-center space-x-3 mb-6">
                                    <i class="fas fa-history text-green-600"></i>
                                    <span>Actividad Reciente</span>
                                </h3>
                                
                                <div id="actividadRecienteContainer" class="space-y-3">
                                    <div class="text-center py-8">
                                        <i class="fas fa-spinner fa-spin text-gray-400 text-2xl"></i>
                                        <p class="text-gray-500 mt-2">Cargando actividad...</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Seguridad -->
                            <div class="bg-white rounded-2xl shadow-md p-8">
                                <h3 class="text-xl font-bold text-gray-800 flex items-center space-x-3 mb-6">
                                    <i class="fas fa-shield-alt text-purple-600"></i>
                                    <span>Seguridad</span>
                                </h3>
                                
                                <div class="space-y-3">
                                    <div class="flex items-center justify-between p-3 bg-green-50 rounded-lg border border-green-200">
                                        <div class="flex items-center space-x-2">
                                            <i class="fas fa-check-circle text-green-600"></i>
                                            <span class="text-sm font-semibold text-gray-800">Contraseña fuerte</span>
                                        </div>
                                        <i class="fas fa-check text-green-600"></i>
                                    </div>
                                    <div class="flex items-center justify-between p-3 bg-blue-50 rounded-lg border border-blue-200">
                                        <div class="flex items-center space-x-2">
                                            <i class="fas fa-lock text-blue-600"></i>
                                            <span class="text-sm font-semibold text-gray-800">Sesión activa</span>
                                        </div>
                                        <span class="text-xs bg-blue-600 text-white px-2 py-1 rounded">Activa</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="js/common.js"></script>
    <script src="js/avatar-global.js"></script>
    <script src="js/topbar.js"></script>
    <script src="js/perfil.js"></script>
    <script src="js/actividad-perfil.js"></script>
</body>
</html>
