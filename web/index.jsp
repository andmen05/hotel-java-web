<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistema Hotelero</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .animate-slide-in {
            animation: slideIn 0.6s ease-out;
        }
        .bg-pattern {
            background-image: 
                radial-gradient(circle at 20% 50%, rgba(99, 102, 241, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(59, 130, 246, 0.1) 0%, transparent 50%);
        }
    </style>
</head>
<body class="bg-gradient-to-br from-indigo-600 via-blue-500 to-cyan-500 min-h-screen flex items-center justify-center bg-pattern">
    <!-- Decorative elements -->
    <div class="absolute top-0 left-0 w-96 h-96 bg-white opacity-5 rounded-full -translate-x-1/2 -translate-y-1/2"></div>
    <div class="absolute bottom-0 right-0 w-96 h-96 bg-white opacity-5 rounded-full translate-x-1/2 translate-y-1/2"></div>

    <div class="relative z-10 w-full max-w-md">
        <!-- Main Card -->
        <div class="bg-white rounded-3xl shadow-2xl p-8 animate-slide-in backdrop-blur-sm">
            <!-- Header -->
            <div class="text-center mb-8">
                <div class="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-indigo-600 to-blue-600 rounded-2xl mb-4 shadow-lg">
                    <i class="fas fa-hotel text-4xl text-white"></i>
                </div>
                <h1 class="text-4xl font-bold bg-gradient-to-r from-indigo-600 to-blue-600 bg-clip-text text-transparent">
                    Sistema Hotelero
                </h1>
                <p class="text-gray-600 mt-2 text-lg">Gestión Integral de Hoteles</p>
            </div>
            
            <!-- Error Message -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-50 border-l-4 border-red-500 text-red-700 px-4 py-4 rounded-lg mb-6 flex items-start" role="alert">
                    <i class="fas fa-exclamation-circle mt-0.5 mr-3 flex-shrink-0"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <!-- Form -->
            <form action="login" method="POST" id="loginForm" class="space-y-5">
                <!-- Usuario Input -->
                <div>
                    <label for="usuario" class="block text-gray-700 text-sm font-semibold mb-2">
                        <i class="fas fa-user mr-2 text-indigo-600"></i>Usuario
                    </label>
                    <input type="text" id="usuario" name="usuario" required
                           class="w-full px-4 py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition text-gray-700 placeholder-gray-400"
                           placeholder="Ingresa tu usuario"
                           autocomplete="username">
                </div>
                
                <!-- Password Input -->
                <div>
                    <label for="password" class="block text-gray-700 text-sm font-semibold mb-2">
                        <i class="fas fa-lock mr-2 text-indigo-600"></i>Contraseña
                    </label>
                    <input type="password" id="password" name="password" required
                           class="w-full px-4 py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 transition text-gray-700 placeholder-gray-400"
                           placeholder="Ingresa tu contraseña"
                           autocomplete="current-password">
                </div>
                
                <!-- Submit Button -->
                <button type="submit" 
                        class="w-full bg-gradient-to-r from-indigo-600 to-blue-600 hover:from-indigo-700 hover:to-blue-700 text-white font-bold py-3 px-4 rounded-lg focus:outline-none focus:ring-4 focus:ring-indigo-300 transform transition hover:scale-105 active:scale-95 shadow-lg flex items-center justify-center space-x-2">
                    <i class="fas fa-sign-in-alt"></i>
                    <span>Iniciar Sesión</span>
                </button>
            </form>
            
            <!-- Divider -->
            <div class="relative my-6">
                <div class="absolute inset-0 flex items-center">
                    <div class="w-full border-t border-gray-200"></div>
                </div>
                <div class="relative flex justify-center text-sm">
                    <span class="px-2 bg-white text-gray-500">Credenciales de prueba</span>
                </div>
            </div>
            
           
        </div>

        <!-- Footer -->
        <div class="text-center mt-6 text-white text-sm">
            <p>© 2025 Sistema Hotelero. Todos los derechos reservados andmen05.</p>
        </div>
    </div>

    <script>
        // Add focus effects
        document.querySelectorAll('input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('scale-105');
            });
            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('scale-105');
            });
        });
    </script>
</body>
</html>

