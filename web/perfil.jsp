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
    <title>Mi Perfil - Hotel Paradise</title>
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
                    <h2 class="text-2xl font-bold text-gray-900">Mi Perfil</h2>
                    <p class="text-sm text-gray-500">Gestiona tu información personal y seguridad</p>
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

            <!-- Scrollable Content -->
            <div class="flex-1 overflow-auto">
                <div class="p-8">
                    <!-- Profile Header Card -->
                    <div class="bg-gradient-to-r from-indigo-600 to-blue-600 rounded-xl shadow-lg p-8 text-white mb-8">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-6">
                                <div id="avatarPerfil" class="w-24 h-24 bg-white bg-opacity-20 rounded-full flex items-center justify-center border-4 border-white overflow-hidden">
                                    <span class="material-icons-outlined text-5xl text-white">person</span>
                                </div>
                                <div>
                                    <h1 class="text-4xl font-bold"><%= usuario.getNombre() != null ? usuario.getNombre() : "Usuario" %></h1>
                                    <p class="text-indigo-100 text-lg">ID: <%= usuario.getId() %></p>
                                    <p class="text-indigo-100 mt-2 flex items-center">
                                        <span class="material-icons-outlined mr-2 text-sm">account_circle</span>
                                        <%= usuario.getUsuario() != null ? usuario.getUsuario() : "No registrado" %>
                                    </p>
                                </div>
                            </div>
                            <div class="text-right">
                                <p class="text-indigo-100 text-sm">Miembro desde</p>
                                <p class="text-2xl font-bold">2025</p>
                            </div>
                        </div>
                    </div>

                    <!-- Two Column Layout -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                        <!-- Left Column: Personal Info -->
                        <div class="lg:col-span-2 space-y-6">
                            <!-- Información Personal -->
                            <div class="bg-white rounded-xl shadow-md p-6">
                                <div class="flex items-center justify-between mb-6">
                                    <h3 class="text-xl font-bold text-gray-800 flex items-center space-x-3">
                                        <span class="material-icons-outlined text-primary">person</span>
                                        <span>Información Personal</span>
                                    </h3>
                                    <button onclick="editarPerfil()" class="px-4 py-2 bg-primary hover:bg-indigo-700 text-white rounded-lg transition flex items-center space-x-2 font-semibold">
                                        <span class="material-icons-outlined text-sm">edit</span>
                                        <span>Editar</span>
                                    </button>
                                </div>
                                
                                <form id="formPerfil" class="space-y-4" style="display: none;">
                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">Nombre</label>
                                            <input type="text" id="nombre" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-primary transition-colors" value="<%= usuario.getNombre() != null ? usuario.getNombre() : "" %>">
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold text-gray-700 mb-2">Usuario</label>
                                            <input type="text" id="usuario" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-primary transition-colors" value="<%= usuario.getUsuario() != null ? usuario.getUsuario() : "" %>">
                                        </div>
                                    </div>
                                    <div class="flex space-x-3 pt-4">
                                        <button type="submit" class="px-6 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg transition font-semibold flex items-center space-x-2">
                                            <span class="material-icons-outlined text-sm">save</span>
                                            <span>Guardar</span>
                                        </button>
                                        <button type="button" onclick="cancelarEdicion()" class="px-6 py-2 bg-gray-400 hover:bg-gray-500 text-white rounded-lg transition font-semibold flex items-center space-x-2">
                                            <span class="material-icons-outlined text-sm">close</span>
                                            <span>Cancelar</span>
                                        </button>
                                    </div>
                                </form>

                                <div id="infoPerfil" class="space-y-4">
                                    <div class="flex justify-between items-center pb-4 border-b border-gray-200">
                                        <span class="text-gray-600 flex items-center">
                                            <span class="material-icons-outlined mr-2 text-sm text-gray-400">badge</span>
                                            Nombre:
                                        </span>
                                        <span class="font-semibold text-gray-800"><%= usuario.getNombre() != null ? usuario.getNombre() : "No registrado" %></span>
                                    </div>
                                    <div class="flex justify-between items-center pb-4 border-b border-gray-200">
                                        <span class="text-gray-600 flex items-center">
                                            <span class="material-icons-outlined mr-2 text-sm text-gray-400">account_circle</span>
                                            Usuario:
                                        </span>
                                        <span class="font-semibold text-gray-800"><%= usuario.getUsuario() != null ? usuario.getUsuario() : "No registrado" %></span>
                                    </div>
                                    <div class="flex justify-between items-center pb-4 border-b border-gray-200">
                                        <span class="text-gray-600 flex items-center">
                                            <span class="material-icons-outlined mr-2 text-sm text-gray-400">fingerprint</span>
                                            ID Usuario:
                                        </span>
                                        <span class="font-semibold text-gray-800"><%= usuario.getId() %></span>
                                    </div>
                                    <div class="flex justify-between items-center">
                                        <span class="text-gray-600 flex items-center">
                                            <span class="material-icons-outlined mr-2 text-sm text-gray-400">admin_panel_settings</span>
                                            Rol:
                                        </span>
                                        <span class="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-semibold"><%= usuario.getRol() != null ? usuario.getRol() : "Usuario" %></span>
                                    </div>
                                </div>
                            </div>

                            <!-- Cambiar Contraseña -->
                            <div class="bg-white rounded-xl shadow-md p-6">
                                <h3 class="text-xl font-bold text-gray-800 flex items-center space-x-3 mb-6">
                                    <span class="material-icons-outlined text-red-600">lock</span>
                                    <span>Cambiar Contraseña</span>
                                </h3>
                                
                                <form id="formContrasena" class="space-y-4">
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">Contraseña Actual</label>
                                        <div class="relative">
                                            <input type="password" id="contraseniaActual" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-primary transition-colors pr-10" placeholder="Ingresa tu contraseña actual">
                                            <button type="button" onclick="togglePassword('contraseniaActual')" class="absolute right-3 top-3 text-gray-500 hover:text-gray-700">
                                                <span class="material-icons-outlined text-sm">visibility</span>
                                            </button>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">Nueva Contraseña</label>
                                        <div class="relative">
                                            <input type="password" id="contraseniaNueva" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-primary transition-colors pr-10" placeholder="Ingresa tu nueva contraseña">
                                            <button type="button" onclick="togglePassword('contraseniaNueva')" class="absolute right-3 top-3 text-gray-500 hover:text-gray-700">
                                                <span class="material-icons-outlined text-sm">visibility</span>
                                            </button>
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-semibold text-gray-700 mb-2">Confirmar Nueva Contraseña</label>
                                        <div class="relative">
                                            <input type="password" id="contraseniaConfirmar" class="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-primary transition-colors pr-10" placeholder="Confirma tu nueva contraseña">
                                            <button type="button" onclick="togglePassword('contraseniaConfirmar')" class="absolute right-3 top-3 text-gray-500 hover:text-gray-700">
                                                <span class="material-icons-outlined text-sm">visibility</span>
                                            </button>
                                        </div>
                                    </div>
                                    <button type="submit" class="w-full px-6 py-3 bg-red-600 hover:bg-red-700 text-white rounded-lg transition font-semibold mt-6 flex items-center justify-center space-x-2">
                                        <span class="material-icons-outlined text-sm">vpn_key</span>
                                        <span>Cambiar Contraseña</span>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Right Column: Stats & Actions -->
                        <div class="space-y-6">
                            <!-- Foto de Perfil -->
                            <div class="bg-white rounded-xl shadow-md p-6">
                                <h3 class="text-lg font-bold text-gray-800 flex items-center space-x-3 mb-6">
                                    <span class="material-icons-outlined text-blue-600">image</span>
                                    <span>Foto de Perfil</span>
                                </h3>
                                
                                <div class="flex flex-col items-center space-y-4">
                                    <div id="avatarPerfil" class="w-32 h-32 bg-gradient-to-br from-primary to-blue-600 rounded-full flex items-center justify-center text-white border-4 border-gray-200 overflow-hidden">
                                        <span class="material-icons-outlined text-6xl">person</span>
                                    </div>
                                    <button type="button" class="px-6 py-2 bg-primary hover:bg-indigo-700 text-white rounded-lg transition font-semibold flex items-center space-x-2 cursor-pointer">
                                        <span class="material-icons-outlined text-sm">upload</span>
                                        <span>Subir Foto</span>
                                    </button>
                                    <p class="text-xs text-gray-500 text-center">JPG, PNG, GIF o WebP (máx. 5MB)</p>
                                </div>
                            </div>

                            <!-- Actividad Reciente -->
                            <div class="bg-white rounded-xl shadow-md p-6">
                                <h3 class="text-lg font-bold text-gray-800 flex items-center space-x-3 mb-6">
                                    <span class="material-icons-outlined text-green-600">history</span>
                                    <span>Actividad Reciente</span>
                                </h3>
                                
                                <div id="actividadRecienteContainer" class="space-y-3">
                                    <div class="text-center py-8">
                                        <span class="material-icons-outlined text-gray-400 text-4xl animate-spin">refresh</span>
                                        <p class="text-gray-500 mt-2 text-sm">Cargando actividad...</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Seguridad -->
                            <div class="bg-white rounded-xl shadow-md p-6">
                                <h3 class="text-lg font-bold text-gray-800 flex items-center space-x-3 mb-6">
                                    <span class="material-icons-outlined text-purple-600">security</span>
                                    <span>Seguridad</span>
                                </h3>
                                
                                <div class="space-y-3">
                                    <div class="flex items-center justify-between p-3 bg-green-50 rounded-lg border border-green-200">
                                        <div class="flex items-center space-x-2">
                                            <span class="material-icons-outlined text-green-600 text-sm">check_circle</span>
                                            <span class="text-sm font-semibold text-gray-800">Contraseña fuerte</span>
                                        </div>
                                        <span class="material-icons-outlined text-green-600 text-sm">check</span>
                                    </div>
                                    <div class="flex items-center justify-between p-3 bg-blue-50 rounded-lg border border-blue-200">
                                        <div class="flex items-center space-x-2">
                                            <span class="material-icons-outlined text-blue-600 text-sm">lock</span>
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
        </main>
    </div>

    <!-- Scripts -->
    <script src="js/common.js"></script>
    <script src="js/avatar-global.js"></script>
    <script src="js/topbar.js"></script>
    <script src="js/perfil.js"></script>
    <script src="js/actividad-perfil.js"></script>
</body>
</html>
