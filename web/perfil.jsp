<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="com.hotel.modelo.Usuario" %>
        <% Usuario usuario=(Usuario) session.getAttribute("usuario"); if (usuario==null) {
            response.sendRedirect("index.jsp"); return; } %>
            <!DOCTYPE html>
            <html lang="es">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Mi Perfil - Hotel Paradise</title>
                <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
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

                    /* Animated Gradient Background */
                    @keyframes gradient {
                        0% {
                            background-position: 0% 50%;
                        }

                        50% {
                            background-position: 100% 50%;
                        }

                        100% {
                            background-position: 0% 50%;
                        }
                    }

                    .bg-gradient-animated {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 25%, #f093fb 50%, #4facfe 75%, #00f2fe 100%);
                        background-size: 400% 400%;
                        animation: gradient 15s ease infinite;
                    }

                    /* Glassmorphism Effect */
                    .glass-card {
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(10px);
                        border: 1px solid rgba(255, 255, 255, 0.2);
                    }

                    /* Slide In Animation */
                    @keyframes slideInUp {
                        from {
                            opacity: 0;
                            transform: translateY(30px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .animate-slide-in {
                        animation: slideInUp 0.6s ease-out;
                    }

                    /* Fade In Animation */
                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                        }

                        to {
                            opacity: 1;
                        }
                    }

                    .animate-fade-in {
                        animation: fadeIn 0.8s ease-out;
                    }

                    /* Enhanced Input Focus */
                    .input-enhanced {
                        transition: all 0.3s ease;
                    }

                    .input-enhanced:focus {
                        transform: translateY(-2px);
                        box-shadow: 0 10px 25px rgba(79, 70, 229, 0.15);
                    }

                    /* Button Shimmer Effect */
                    .btn-shimmer {
                        position: relative;
                        overflow: hidden;
                    }

                    .btn-shimmer::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: -100%;
                        width: 100%;
                        height: 100%;
                        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
                        transition: left 0.5s;
                    }

                    .btn-shimmer:hover::before {
                        left: 100%;
                    }

                    /* Card Hover Effect */
                    .card-hover {
                        transition: all 0.3s ease;
                    }

                    .card-hover:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                    }

                    /* Pulse Animation for Active Badge */
                    @keyframes pulse {

                        0%,
                        100% {
                            opacity: 1;
                        }

                        50% {
                            opacity: 0.5;
                        }
                    }

                    .animate-pulse-slow {
                        animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
                    }

                    /* Avatar Glow */
                    .avatar-glow {
                        box-shadow: 0 0 30px rgba(79, 70, 229, 0.4);
                    }

                    /* Skeleton Loading */
                    @keyframes skeleton {
                        0% {
                            background-position: -200px 0;
                        }

                        100% {
                            background-position: calc(200px + 100%) 0;
                        }
                    }

                    .skeleton {
                        background: linear-gradient(90deg, #f0f0f0 0px, #f8f8f8 40px, #f0f0f0 80px);
                        background-size: 200px 100%;
                        animation: skeleton 1.2s ease-in-out infinite;
                    }
                </style>
            </head>

            <body class="font-display bg-background-light text-gray-700">
                <div class="flex h-screen">
                    <!-- Sidebar -->
                    <aside class="w-64 flex-shrink-0 bg-indigo-900 text-indigo-100 flex flex-col">
                        <div class="p-6 text-center">
                            <div
                                class="bg-indigo-800 rounded-lg p-3 inline-flex items-center justify-center mb-2 transform hover:scale-110 transition duration-300">
                                <span class="material-icons-outlined text-4xl text-white">hotel</span>
                            </div>
                            <h1 class="text-xl font-bold text-white">Hotel Paradise</h1>
                            <p class="text-sm text-indigo-300">andmen05</p>
                        </div>
                        <nav class="flex-1 px-4 space-y-2">
                            <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-all duration-200 transform hover:translate-x-1"
                                href="dashboard.jsp">
                                <span class="material-icons-outlined mr-3">dashboard</span>
                                Dashboard
                            </a>
                            <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-all duration-200 transform hover:translate-x-1"
                                href="clientes.jsp">
                                <span class="material-icons-outlined mr-3">people</span>
                                Clientes
                            </a>
                            <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-all duration-200 transform hover:translate-x-1"
                                href="habitaciones.jsp">
                                <span class="material-icons-outlined mr-3">king_bed</span>
                                Habitaciones
                            </a>
                            <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-all duration-200 transform hover:translate-x-1"
                                href="reservas.jsp">
                                <span class="material-icons-outlined mr-3">book_online</span>
                                Reservas
                            </a>
                            <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-all duration-200 transform hover:translate-x-1"
                                href="checkin.jsp">
                                <span class="material-icons-outlined mr-3">login</span>
                                Check-in
                            </a>
                            <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-all duration-200 transform hover:translate-x-1"
                                href="productos.jsp">
                                <span class="material-icons-outlined mr-3">restaurant</span>
                                Productos
                            </a>
                            <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-all duration-200 transform hover:translate-x-1"
                                href="ventas.jsp">
                                <span class="material-icons-outlined mr-3">shopping_cart</span>
                                Ventas
                            </a>
                            <a class="flex items-center px-4 py-2.5 text-indigo-300 hover:bg-indigo-800 hover:text-white rounded-lg transition-all duration-200 transform hover:translate-x-1"
                                href="reportes.jsp">
                                <span class="material-icons-outlined mr-3">assessment</span>
                                Reportes
                            </a>
                        </nav>
                        <div class="p-4 mt-auto">
                            <a href="logout"
                                class="w-full flex items-center justify-center px-4 py-2.5 bg-red-600 hover:bg-red-700 text-white rounded-lg transition-all duration-200 transform hover:scale-105">
                                <span class="material-icons-outlined mr-2">logout</span>
                                Salir
                            </a>
                        </div>
                    </aside>

                    <!-- Main Content -->
                    <main class="flex-1 flex flex-col overflow-y-auto">
                        <!-- Header -->
                        <header
                            class="flex-shrink-0 bg-white border-b border-gray-200 p-6 flex justify-between items-center sticky top-0 z-10 shadow-sm">
                            <div class="animate-fade-in">
                                <h2 class="text-2xl font-bold text-gray-900">Mi Perfil</h2>
                                <p class="text-sm text-gray-500">Gestiona tu información personal y seguridad</p>
                            </div>
                            <div class="flex items-center space-x-4 relative">
                                <button
                                    class="p-2 rounded-full text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary transition-all transform hover:scale-110">
                                    <span class="material-icons-outlined">notifications</span>
                                </button>
                                <button
                                    class="p-2 rounded-full text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary transition-all transform hover:scale-110">
                                    <span class="material-icons-outlined">settings</span>
                                </button>
                                <button id="avatarBtn"
                                    class="w-10 h-10 rounded-full bg-gradient-to-br from-primary to-purple-600 flex items-center justify-center text-white font-bold text-lg cursor-pointer hover:ring-2 hover:ring-primary hover:ring-offset-2 transition-all transform hover:scale-110 relative">
                                    <%= usuario.getNombre() !=null && usuario.getNombre().length()> 0 ?
                                        usuario.getNombre().charAt(0) : "A" %>
                                </button>
                                <!-- User Menu Dropdown -->
                                <div id="userMenu"
                                    class="hidden absolute right-0 top-14 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50">
                                    <a href="perfil.jsp"
                                        class="flex items-center px-4 py-2 text-gray-700 hover:bg-gray-100 transition-colors">
                                        <span class="material-icons-outlined mr-3 text-lg">person</span>
                                        <span>Mi Perfil</span>
                                    </a>
                                    <a href="logout"
                                        class="flex items-center px-4 py-2 text-red-600 hover:bg-red-50 transition-colors">
                                        <span class="material-icons-outlined mr-3 text-lg">logout</span>
                                        <span>Cerrar Sesión</span>
                                    </a>
                                </div>
                            </div>
                        </header>

                        <!-- Scrollable Content -->
                        <div class="flex-1 overflow-auto">
                            <div class="p-8">
                                <!-- Profile Header Card with Animated Gradient -->
                                <div
                                    class="bg-gradient-animated rounded-2xl shadow-2xl p-8 text-white mb-8 animate-slide-in relative overflow-hidden">
                                    <!-- Decorative Elements -->
                                    <div
                                        class="absolute top-0 right-0 w-64 h-64 bg-white opacity-5 rounded-full blur-3xl">
                                    </div>
                                    <div
                                        class="absolute bottom-0 left-0 w-48 h-48 bg-white opacity-5 rounded-full blur-3xl">
                                    </div>

                                    <div class="relative z-10">
                                        <!-- Main Profile Info -->
                                        <div class="flex flex-col md:flex-row items-center md:items-start gap-8 mb-6">
                                            <!-- Avatar -->
                                            <div class="relative group">
                                                <div id="avatarPerfilHeader"
                                                    class="w-32 h-32 bg-white bg-opacity-20 rounded-2xl flex items-center justify-center border-4 border-white overflow-hidden avatar-glow transform hover:scale-105 transition duration-300 cursor-pointer">
                                                    <span
                                                        class="material-icons-outlined text-7xl text-white">person</span>
                                                </div>
                                                <div
                                                    class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 rounded-2xl flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300">
                                                    <span
                                                        class="material-icons-outlined text-white text-3xl">photo_camera</span>
                                                </div>
                                            </div>

                                            <!-- User Info -->
                                            <div class="flex-1 text-center md:text-left">
                                                <div class="flex flex-col md:flex-row md:items-center gap-3 mb-3">
                                                    <h1 class="text-4xl md:text-5xl font-bold">
                                                        <%= usuario.getNombre() !=null ? usuario.getNombre() : "Usuario"
                                                            %>
                                                    </h1>
                                                    <span
                                                        class="inline-flex items-center px-4 py-1.5 bg-white bg-opacity-25 rounded-full text-sm font-bold backdrop-blur-sm border border-white border-opacity-30">
                                                        <span
                                                            class="material-icons-outlined text-base mr-1.5">admin_panel_settings</span>
                                                        <%= usuario.getRol() !=null ? usuario.getRol() : "Usuario" %>
                                                    </span>
                                                </div>

                                                <div class="space-y-2 mb-4">
                                                    <div
                                                        class="flex items-center justify-center md:justify-start gap-2 text-white text-opacity-90">
                                                        <span
                                                            class="material-icons-outlined text-lg">account_circle</span>
                                                        <span class="font-medium">@<%= usuario.getUsuario() !=null ?
                                                                usuario.getUsuario() : "usuario" %></span>
                                                    </div>
                                                    <div
                                                        class="flex items-center justify-center md:justify-start gap-2 text-white text-opacity-90">
                                                        <span class="material-icons-outlined text-lg">fingerprint</span>
                                                        <span class="font-medium">ID: <%= usuario.getId() %></span>
                                                    </div>
                                                </div>

                                                <div
                                                    class="flex flex-wrap items-center justify-center md:justify-start gap-3">
                                                    <div
                                                        class="inline-flex items-center px-3 py-1.5 bg-green-500 bg-opacity-30 rounded-full text-sm backdrop-blur-sm border border-green-400 border-opacity-30">
                                                        <span
                                                            class="w-2 h-2 bg-green-300 rounded-full mr-2 animate-pulse-slow"></span>
                                                        <span class="font-semibold">Sesión Activa</span>
                                                    </div>
                                                    <div
                                                        class="inline-flex items-center px-3 py-1.5 bg-blue-500 bg-opacity-30 rounded-full text-sm backdrop-blur-sm border border-blue-400 border-opacity-30">
                                                        <span
                                                            class="material-icons-outlined text-sm mr-1.5">verified</span>
                                                        <span class="font-semibold">Verificado</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Stats Grid -->
                                        <div
                                            class="grid grid-cols-1 md:grid-cols-3 gap-4 pt-6 border-t border-white border-opacity-20">
                                            <div
                                                class="bg-white bg-opacity-10 rounded-xl p-4 backdrop-blur-sm border border-white border-opacity-20 hover:bg-opacity-20 transition-all">
                                                <div class="flex items-center gap-3">
                                                    <div
                                                        class="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center">
                                                        <span
                                                            class="material-icons-outlined text-2xl">calendar_today</span>
                                                    </div>
                                                    <div>
                                                        <p class="text-white text-opacity-70 text-xs font-medium">
                                                            Miembro desde</p>
                                                        <p class="text-2xl font-bold">2025</p>
                                                    </div>
                                                </div>
                                            </div>

                                            <div
                                                class="bg-white bg-opacity-10 rounded-xl p-4 backdrop-blur-sm border border-white border-opacity-20 hover:bg-opacity-20 transition-all">
                                                <div class="flex items-center gap-3">
                                                    <div
                                                        class="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center">
                                                        <span class="material-icons-outlined text-2xl">schedule</span>
                                                    </div>
                                                    <div>
                                                        <p class="text-white text-opacity-70 text-xs font-medium">Último
                                                            acceso</p>
                                                        <p class="text-lg font-bold">Hoy</p>
                                                    </div>
                                                </div>
                                            </div>

                                            <div
                                                class="bg-white bg-opacity-10 rounded-xl p-4 backdrop-blur-sm border border-white border-opacity-20 hover:bg-opacity-20 transition-all">
                                                <div class="flex items-center gap-3">
                                                    <div
                                                        class="w-12 h-12 bg-white bg-opacity-20 rounded-lg flex items-center justify-center">
                                                        <span class="material-icons-outlined text-2xl">security</span>
                                                    </div>
                                                    <div>
                                                        <p class="text-white text-opacity-70 text-xs font-medium">
                                                            Seguridad</p>
                                                        <p class="text-lg font-bold">Alta</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Two Column Layout -->
                                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                                    <!-- Left Column: Personal Info -->
                                    <div class="lg:col-span-2 space-y-6">
                                        <!-- Personal Information Card -->
                                        <div class="bg-white rounded-2xl shadow-lg p-6 card-hover animate-slide-in">
                                            <div class="flex items-center justify-between mb-6">
                                                <h3 class="text-xl font-bold text-gray-800 flex items-center gap-3">
                                                    <div
                                                        class="w-10 h-10 bg-gradient-to-br from-primary to-purple-600 rounded-lg flex items-center justify-center">
                                                        <span
                                                            class="material-icons-outlined text-white text-xl">person</span>
                                                    </div>
                                                    <span>Información Personal</span>
                                                </h3>
                                                <button onclick="editarPerfil()"
                                                    class="btn-shimmer px-5 py-2.5 bg-gradient-to-r from-primary to-purple-600 hover:from-primary hover:to-purple-700 text-white rounded-lg transition-all flex items-center gap-2 font-semibold shadow-md transform hover:scale-105">
                                                    <span class="material-icons-outlined text-sm">edit</span>
                                                    <span>Editar</span>
                                                </button>
                                            </div>

                                            <form id="formPerfil" class="space-y-4" style="display: none;">
                                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                                    <div>
                                                        <label
                                                            class="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                                                            <span
                                                                class="material-icons-outlined text-primary text-sm">badge</span>
                                                            Nombre
                                                        </label>
                                                        <input type="text" id="nombre"
                                                            class="input-enhanced w-full px-4 py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-primary transition-all"
                                                            value="<%= usuario.getNombre() != null ? usuario.getNombre() : "" %>">
                                                    </div>
                                                    <div>
                                                        <label
                                                            class="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                                                            <span
                                                                class="material-icons-outlined text-primary text-sm">account_circle</span>
                                                            Usuario
                                                        </label>
                                                        <input type="text" id="usuario"
                                                            class="input-enhanced w-full px-4 py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-primary transition-all"
                                                            value="<%= usuario.getUsuario() != null ? usuario.getUsuario() : "" %>">
                                                    </div>
                                                </div>
                                                <div class="flex gap-3 pt-4">
                                                    <button type="submit"
                                                        class="btn-shimmer px-6 py-2.5 bg-gradient-to-r from-green-600 to-green-700 hover:from-green-700 hover:to-green-800 text-white rounded-lg transition-all font-semibold flex items-center gap-2 shadow-md transform hover:scale-105">
                                                        <span class="material-icons-outlined text-sm">save</span>
                                                        <span>Guardar</span>
                                                    </button>
                                                    <button type="button" onclick="cancelarEdicion()"
                                                        class="px-6 py-2.5 bg-gray-400 hover:bg-gray-500 text-white rounded-lg transition-all font-semibold flex items-center gap-2 transform hover:scale-105">
                                                        <span class="material-icons-outlined text-sm">close</span>
                                                        <span>Cancelar</span>
                                                    </button>
                                                </div>
                                            </form>

                                            <div id="infoPerfil" class="space-y-4">
                                                <div
                                                    class="flex justify-between items-center pb-4 border-b border-gray-100 hover:bg-gray-50 px-3 py-2 rounded-lg transition-colors">
                                                    <span class="text-gray-600 flex items-center gap-2">
                                                        <span
                                                            class="material-icons-outlined text-sm text-primary">badge</span>
                                                        Nombre
                                                    </span>
                                                    <span class="font-semibold text-gray-800">
                                                        <%= usuario.getNombre() !=null ? usuario.getNombre()
                                                            : "No registrado" %>
                                                    </span>
                                                </div>
                                                <div
                                                    class="flex justify-between items-center pb-4 border-b border-gray-100 hover:bg-gray-50 px-3 py-2 rounded-lg transition-colors">
                                                    <span class="text-gray-600 flex items-center gap-2">
                                                        <span
                                                            class="material-icons-outlined text-sm text-primary">account_circle</span>
                                                        Usuario
                                                    </span>
                                                    <span class="font-semibold text-gray-800">
                                                        <%= usuario.getUsuario() !=null ? usuario.getUsuario()
                                                            : "No registrado" %>
                                                    </span>
                                                </div>
                                                <div
                                                    class="flex justify-between items-center pb-4 border-b border-gray-100 hover:bg-gray-50 px-3 py-2 rounded-lg transition-colors">
                                                    <span class="text-gray-600 flex items-center gap-2">
                                                        <span
                                                            class="material-icons-outlined text-sm text-primary">fingerprint</span>
                                                        ID Usuario
                                                    </span>
                                                    <span class="font-semibold text-gray-800">
                                                        <%= usuario.getId() %>
                                                    </span>
                                                </div>
                                                <div
                                                    class="flex justify-between items-center hover:bg-gray-50 px-3 py-2 rounded-lg transition-colors">
                                                    <span class="text-gray-600 flex items-center gap-2">
                                                        <span
                                                            class="material-icons-outlined text-sm text-primary">admin_panel_settings</span>
                                                        Rol
                                                    </span>
                                                    <span
                                                        class="px-4 py-1.5 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-full text-sm font-semibold shadow-sm">
                                                        <%= usuario.getRol() !=null ? usuario.getRol() : "Usuario" %>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Change Password Card -->
                                        <div class="bg-white rounded-2xl shadow-lg p-6 card-hover animate-slide-in">
                                            <h3 class="text-xl font-bold text-gray-800 flex items-center gap-3 mb-6">
                                                <div
                                                    class="w-10 h-10 bg-gradient-to-br from-red-500 to-red-600 rounded-lg flex items-center justify-center">
                                                    <span class="material-icons-outlined text-white text-xl">lock</span>
                                                </div>
                                                <span>Cambiar Contraseña</span>
                                            </h3>

                                            <form id="formContrasena" class="space-y-5">
                                                <div>
                                                    <label
                                                        class="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                                                        <span
                                                            class="material-icons-outlined text-red-600 text-sm">lock</span>
                                                        Contraseña Actual
                                                    </label>
                                                    <div class="relative">
                                                        <input type="password" id="contraseniaActual"
                                                            class="input-enhanced w-full px-4 py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-red-500 transition-all pr-12"
                                                            placeholder="Ingresa tu contraseña actual">
                                                        <button type="button"
                                                            onclick="togglePassword('contraseniaActual')"
                                                            class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-red-600 transition-colors">
                                                            <span
                                                                class="material-icons-outlined text-xl">visibility</span>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div>
                                                    <label
                                                        class="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                                                        <span
                                                            class="material-icons-outlined text-red-600 text-sm">vpn_key</span>
                                                        Nueva Contraseña
                                                    </label>
                                                    <div class="relative">
                                                        <input type="password" id="contraseniaNueva"
                                                            class="input-enhanced w-full px-4 py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-red-500 transition-all pr-12"
                                                            placeholder="Ingresa tu nueva contraseña">
                                                        <button type="button"
                                                            onclick="togglePassword('contraseniaNueva')"
                                                            class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-red-600 transition-colors">
                                                            <span
                                                                class="material-icons-outlined text-xl">visibility</span>
                                                        </button>
                                                    </div>
                                                </div>
                                                <div>
                                                    <label
                                                        class="block text-sm font-semibold text-gray-700 mb-2 flex items-center gap-2">
                                                        <span
                                                            class="material-icons-outlined text-red-600 text-sm">verified_user</span>
                                                        Confirmar Nueva Contraseña
                                                    </label>
                                                    <div class="relative">
                                                        <input type="password" id="contraseniaConfirmar"
                                                            class="input-enhanced w-full px-4 py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-red-500 transition-all pr-12"
                                                            placeholder="Confirma tu nueva contraseña">
                                                        <button type="button"
                                                            onclick="togglePassword('contraseniaConfirmar')"
                                                            class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-red-600 transition-colors">
                                                            <span
                                                                class="material-icons-outlined text-xl">visibility</span>
                                                        </button>
                                                    </div>
                                                </div>
                                                <button type="submit"
                                                    class="btn-shimmer w-full px-6 py-3.5 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white rounded-lg transition-all font-semibold mt-6 flex items-center justify-center gap-2 shadow-lg transform hover:scale-105">
                                                    <span class="material-icons-outlined text-lg">vpn_key</span>
                                                    <span>Cambiar Contraseña</span>
                                                </button>
                                            </form>
                                        </div>
                                    </div>

                                    <!-- Right Column: Stats & Actions -->
                                    <div class="space-y-6">
                                        <!-- Profile Photo Card -->
                                        <div class="bg-white rounded-2xl shadow-lg p-6 card-hover animate-slide-in">
                                            <h3 class="text-lg font-bold text-gray-800 flex items-center gap-3 mb-6">
                                                <div
                                                    class="w-9 h-9 bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg flex items-center justify-center">
                                                    <span
                                                        class="material-icons-outlined text-white text-lg">image</span>
                                                </div>
                                                <span>Foto de Perfil</span>
                                            </h3>

                                            <div class="flex flex-col items-center gap-4">
                                                <div
                                                    class="w-36 h-36 bg-gradient-to-br from-primary via-purple-600 to-pink-600 rounded-full flex items-center justify-center text-white border-4 border-white shadow-2xl overflow-hidden avatar-glow transform hover:scale-110 transition duration-300">
                                                    <span class="material-icons-outlined text-7xl">person</span>
                                                </div>
                                                <button type="button"
                                                    class="btn-shimmer px-6 py-2.5 bg-gradient-to-r from-primary to-purple-600 hover:from-primary hover:to-purple-700 text-white rounded-lg transition-all font-semibold flex items-center gap-2 cursor-pointer shadow-md transform hover:scale-105">
                                                    <span class="material-icons-outlined text-sm">upload</span>
                                                    <span>Subir Foto</span>
                                                </button>
                                                <p class="text-xs text-gray-500 text-center">JPG, PNG, GIF o
                                                    WebP<br>(máx. 5MB)</p>
                                            </div>
                                        </div>

                                        <!-- Recent Activity Card -->
                                        <div class="bg-white rounded-2xl shadow-lg p-6 card-hover animate-slide-in">
                                            <h3 class="text-lg font-bold text-gray-800 flex items-center gap-3 mb-6">
                                                <div
                                                    class="w-9 h-9 bg-gradient-to-br from-green-500 to-green-600 rounded-lg flex items-center justify-center">
                                                    <span
                                                        class="material-icons-outlined text-white text-lg">history</span>
                                                </div>
                                                <span>Actividad Reciente</span>
                                            </h3>

                                            <div id="actividadRecienteContainer"
                                                class="space-y-3 max-h-64 overflow-y-auto">
                                                <div class="text-center py-8">
                                                    <span
                                                        class="material-icons-outlined text-primary text-5xl animate-spin">refresh</span>
                                                    <p class="text-gray-500 mt-3 text-sm font-medium">Cargando
                                                        actividad...</p>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Security Card -->
                                        <div class="bg-white rounded-2xl shadow-lg p-6 card-hover animate-slide-in">
                                            <h3 class="text-lg font-bold text-gray-800 flex items-center gap-3 mb-6">
                                                <div
                                                    class="w-9 h-9 bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg flex items-center justify-center">
                                                    <span
                                                        class="material-icons-outlined text-white text-lg">security</span>
                                                </div>
                                                <span>Seguridad</span>
                                            </h3>

                                            <div class="space-y-3">
                                                <div
                                                    class="flex items-center justify-between p-4 bg-gradient-to-r from-green-50 to-green-100 rounded-xl border-2 border-green-200 transform hover:scale-105 transition-all">
                                                    <div class="flex items-center gap-3">
                                                        <span
                                                            class="material-icons-outlined text-green-600 text-xl">check_circle</span>
                                                        <span class="text-sm font-semibold text-gray-800">Contraseña
                                                            fuerte</span>
                                                    </div>
                                                    <span
                                                        class="material-icons-outlined text-green-600 text-xl">check</span>
                                                </div>
                                                <div
                                                    class="flex items-center justify-between p-4 bg-gradient-to-r from-blue-50 to-blue-100 rounded-xl border-2 border-blue-200 transform hover:scale-105 transition-all">
                                                    <div class="flex items-center gap-3">
                                                        <span
                                                            class="material-icons-outlined text-blue-600 text-xl">lock</span>
                                                        <span class="text-sm font-semibold text-gray-800">Sesión
                                                            activa</span>
                                                    </div>
                                                    <span
                                                        class="inline-flex items-center text-xs bg-gradient-to-r from-blue-600 to-blue-700 text-white px-3 py-1.5 rounded-full font-bold shadow-sm">
                                                        <span
                                                            class="w-1.5 h-1.5 bg-white rounded-full mr-1.5 animate-pulse-slow"></span>
                                                        Activa
                                                    </span>
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