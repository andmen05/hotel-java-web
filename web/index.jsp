<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso - Sistema Hotelero</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .animate-slide-in {
            animation: slideInUp 0.8s ease-out;
        }
        .animate-fade-in {
            animation: fadeIn 1s ease-out;
        }
        .bg-gradient-premium {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 25%, #f093fb 50%, #4facfe 75%, #00f2fe 100%);
            background-size: 400% 400%;
            animation: gradient 15s ease infinite;
        }
        @keyframes gradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .glass-effect {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .input-focus {
            transition: all 0.3s ease;
        }
        .input-focus:focus {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(99, 102, 241, 0.2);
        }
        .btn-primary {
            position: relative;
            overflow: hidden;
        }
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }
        .btn-primary:hover::before {
            left: 100%;
        }
    </style>
</head>
<body class="bg-gradient-premium min-h-screen flex items-center justify-center relative overflow-hidden">
    <!-- Decorative Background Elements -->
    <div class="absolute top-0 left-0 w-full h-full">
        <div class="absolute top-20 left-10 w-72 h-72 bg-white opacity-10 rounded-full blur-3xl"></div>
        <div class="absolute bottom-20 right-10 w-96 h-96 bg-white opacity-5 rounded-full blur-3xl"></div>
        <div class="absolute top-1/2 right-1/4 w-64 h-64 bg-indigo-300 opacity-5 rounded-full blur-3xl"></div>
    </div>

    <div class="relative z-10 w-full max-w-sm px-4 sm:max-w-md lg:max-w-lg">
        <!-- Main Login Card -->
        <div class="glass-effect rounded-2xl shadow-2xl p-6 sm:p-8 animate-slide-in">
            <!-- Logo Section -->
            <div class="text-center mb-6 sm:mb-8">
                <div class="inline-flex items-center justify-center w-16 h-16 sm:w-20 sm:h-20 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 rounded-2xl mb-3 sm:mb-4 shadow-lg transform hover:scale-110 transition duration-300">
                    <i class="fas fa-hotel text-3xl sm:text-4xl text-white"></i>
                </div>
                <h1 class="text-3xl sm:text-4xl font-black bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-1">
                    Hotel Paradise
                </h1>
                <p class="text-gray-600 text-sm sm:text-base font-medium">Gestión de Hoteles</p>
            </div>
            
            <!-- Error Message -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="bg-red-50 border-l-4 border-red-500 text-red-700 px-4 py-3 rounded-lg mb-6 flex items-start gap-2 text-sm animate-slide-in" role="alert">
                    <i class="fas fa-circle-exclamation flex-shrink-0 mt-0.5"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            
            <!-- Login Form -->
            <form action="login" method="POST" id="loginForm" class="space-y-4 sm:space-y-5">
                <!-- Usuario Input -->
                <div>
                    <label for="usuario" class="block text-gray-800 text-xs sm:text-sm font-semibold mb-2 flex items-center gap-2">
                        <i class="fas fa-user text-indigo-600"></i>
                        <span>Usuario</span>
                    </label>
                    <input type="text" id="usuario" name="usuario" required
                           class="input-focus w-full px-4 py-2.5 sm:py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 text-gray-800 placeholder-gray-400 text-sm"
                           placeholder="Tu usuario"
                           autocomplete="username">
                </div>
                
                <!-- Password Input -->
                <div>
                    <label for="password" class="block text-gray-800 text-xs sm:text-sm font-semibold mb-2 flex items-center gap-2">
                        <i class="fas fa-lock text-indigo-600"></i>
                        <span>Contraseña</span>
                    </label>
                    <div class="relative">
                        <input type="password" id="password" name="password" required
                               class="input-focus w-full px-4 py-2.5 sm:py-3 border-2 border-gray-200 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100 text-gray-800 placeholder-gray-400 text-sm"
                               placeholder="Tu contraseña"
                               autocomplete="current-password">
                        <button type="button" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-indigo-600 transition text-sm" onclick="togglePassword()">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Submit Button -->
                <button type="submit" 
                        class="btn-primary w-full bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 text-white font-bold py-2.5 sm:py-3 px-4 rounded-lg focus:outline-none focus:ring-4 focus:ring-indigo-300 transform transition hover:shadow-lg active:scale-95 shadow-md flex items-center justify-center gap-2 mt-6 text-sm sm:text-base">
                    <i class="fas fa-sign-in-alt"></i>
                    <span>Iniciar Sesión</span>
                </button>
            </form>
        </div>

        <!-- Footer -->
        <div class="text-center mt-6 text-white text-xs sm:text-sm animate-fade-in">
            <p>© 2025 <span class="font-bold">Hotel Paradise</span></p>
        </div>
    </div>

    <script>
        // Toggle password visibility
        function togglePassword() {
            const passwordInput = document.getElementById('password');
            const icon = event.target.closest('button').querySelector('i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // Input validation feedback
        document.getElementById('usuario').addEventListener('input', function() {
            const icon = this.parentElement.querySelector('i');
            if (this.value.length > 0) {
                icon.style.opacity = '1';
            } else {
                icon.style.opacity = '0';
            }
        });
        
        // Form submission animation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const btn = this.querySelector('button[type="submit"]');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Iniciando sesión...</span>';
            btn.disabled = true;
        });
    </script>
</body>
</html>

