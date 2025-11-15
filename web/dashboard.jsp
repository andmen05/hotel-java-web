<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.hotel.modelo.Usuario"%>
<%@page import="com.hotel.dao.HabitacionDAO"%>
<%@page import="com.hotel.dao.ClienteDAO"%>
<%@page import="com.hotel.dao.ReservaDAO"%>
<%@page import="com.hotel.dao.VentaDAO"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // Obtener estadísticas
    int totalHabitaciones = 0;
    int habitacionesDisponibles = 0;
    int habitacionesOcupadas = 0;
    int totalClientes = 0;
    int totalReservas = 0;
    double totalVentas = 0;
    String errorMensaje = "";
    
    try {
        HabitacionDAO habDAO = new HabitacionDAO();
        if (habDAO != null) {
            totalHabitaciones = habDAO.getTotalHabitaciones();
            habitacionesDisponibles = habDAO.getHabitacionesDisponibles();
            habitacionesOcupadas = totalHabitaciones - habitacionesDisponibles;
        }
        
        ClienteDAO clientesDAO = new ClienteDAO();
        if (clientesDAO != null) {
            totalClientes = clientesDAO.getTotalClientes();
        }
        
        ReservaDAO reservasDAO = new ReservaDAO();
        if (reservasDAO != null) {
            totalReservas = reservasDAO.getTotalReservas();
        }
        
        VentaDAO ventasDAO = new VentaDAO();
        if (ventasDAO != null) {
            totalVentas = ventasDAO.getTotalVentasHoy();
        }
    } catch (Exception e) {
        errorMensaje = "Error al cargar estadísticas: " + e.getMessage();
        System.err.println(errorMensaje);
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sistema Hotelero</title>
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
                        <p class="text-xs text-indigo-200">andmen05</p>
                    </div>
                </div>
            </div>

            <nav class="mt-8 space-y-2 px-4">
                <a href="dashboard.jsp" class="flex items-center space-x-3 px-4 py-3 bg-indigo-700 rounded-lg hover:bg-indigo-600 transition">
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
                    <h2 class="text-2xl font-bold text-gray-800">Dashboard Principal</h2>
                    <p class="text-gray-600 text-sm">Bienvenido de vuelta, Admin 👋</p>
                </div>
                <div class="flex items-center space-x-4">
                    <button class="p-2 hover:bg-gray-100 rounded-lg transition">
                        <i class="fas fa-bell text-gray-600 text-xl"></i>
                    </button>
                    <button class="p-2 hover:bg-gray-100 rounded-lg transition">
                        <i class="fas fa-cog text-gray-600 text-xl"></i>
                    </button>
                    <!-- Avatar con Menú Desplegable -->
                    <div class="relative">
                        <button id="avatarBtn" class="w-10 h-10 bg-gradient-to-br from-indigo-500 to-blue-600 rounded-full flex items-center justify-center text-white font-bold hover:shadow-lg transition cursor-pointer">
                            <%= usuario.getNombre() != null && usuario.getNombre().length() > 0 ? usuario.getNombre().charAt(0) : "A" %>
                        </button>
                        <!-- Menú Desplegable -->
                        <div id="userMenu" class="hidden absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-xl z-50 overflow-hidden">
                            <!-- Header del Menú -->
                            <div class="bg-gradient-to-r from-indigo-600 to-blue-600 text-white p-4">
                                <div class="flex items-center space-x-3">
                                    <div class="w-10 h-10 bg-white bg-opacity-20 rounded-full flex items-center justify-center">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <div>
                                        <p class="font-semibold text-sm"><%= usuario.getNombre() != null ? usuario.getNombre() : "Usuario" %></p>
                                        <p class="text-xs text-indigo-100">ID: <%= usuario.getId() %></p>
                                    </div>
                                </div>
                            </div>
                            <!-- Opciones del Menú -->
                            <div class="py-2">
                                <a href="perfil.jsp" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-indigo-50 transition">
                                    <i class="fas fa-user-circle text-indigo-600 w-5"></i>
                                    <span>Mi Perfil</span>
                                </a>
                                <a href="#" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-indigo-50 transition">
                                    <i class="fas fa-cog text-gray-600 w-5"></i>
                                    <span>Configuración</span>
                                </a>
                                <a href="#" class="flex items-center space-x-3 px-4 py-3 text-gray-700 hover:bg-indigo-50 transition">
                                    <i class="fas fa-question-circle text-gray-600 w-5"></i>
                                    <span>Ayuda</span>
                                </a>
                                <hr class="my-2">
                                <a href="logout" class="flex items-center space-x-3 px-4 py-3 text-red-600 hover:bg-red-50 transition font-semibold">
                                    <i class="fas fa-sign-out-alt w-5"></i>
                                    <span>Cerrar Sesión</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Scrollable Content -->
            <div class="flex-1 overflow-auto">
                <div class="p-8">
                    <!-- Stats Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                        <!-- Habitaciones Ocupadas (EN VIVO) -->
                        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <p class="text-blue-100 text-sm font-semibold">Habitaciones Ocupadas</p>
                                    <h3 class="text-4xl font-bold mt-2"><span id="ocupadasCount">0</span>/<span id="totalCount">0</span></h3>
                                    <p class="text-blue-100 text-xs mt-2">📊 <span id="ocupacionPorcentaje">0</span>% Ocupación</p>
                                </div>
                                <i class="fas fa-door-open text-3xl opacity-30"></i>
                            </div>
                        </div>

                        <!-- Check-ins Hoy -->
                        <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <p class="text-purple-100 text-sm font-semibold">Check-ins Hoy</p>
                                    <h3 class="text-4xl font-bold mt-2" id="checkinsHoy">0</h3>
                                    <p class="text-purple-100 text-xs mt-2" id="proximoCheckin">⏰ Cargando...</p>
                                </div>
                                <i class="fas fa-sign-in-alt text-3xl opacity-30"></i>
                            </div>
                        </div>

                        <!-- Ingresos Hoy (EN VIVO) -->
                        <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <p class="text-green-100 text-sm font-semibold">Ingresos Hoy</p>
                                    <h3 class="text-4xl font-bold mt-2" id="ingresosHoy">$0</h3>
                                    <p class="text-green-100 text-xs mt-2" id="variacionIngresos">📈 Cargando...</p>
                                </div>
                                <i class="fas fa-dollar-sign text-3xl opacity-30"></i>
                            </div>
                        </div>

                        <!-- Reservas Confirmadas (EN VIVO) -->
                        <div class="bg-gradient-to-br from-orange-500 to-orange-600 rounded-xl p-6 text-white shadow-lg hover:shadow-xl transition">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <p class="text-orange-100 text-sm font-semibold">Reservas Confirmadas</p>
                                    <h3 class="text-4xl font-bold mt-2"><span id="reservasConfirmadas">0</span></h3>
                                    <p class="text-orange-100 text-xs mt-2" id="variacionReservas">📅 Cargando...</p>
                                </div>
                                <i class="fas fa-calendar-check text-3xl opacity-30"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Two Column Layout -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        <!-- Check-ins Pendientes -->
                        <div class="bg-white rounded-xl shadow-md overflow-hidden">
                            <div class="bg-gradient-to-r from-green-500 to-green-600 px-6 py-4 flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <i class="fas fa-sign-in-alt text-2xl text-white"></i>
                                    <div>
                                        <h3 class="text-lg font-bold text-white">Check-ins Pendientes</h3>
                                        <p class="text-green-100 text-xs" id="countCheckinsP">Cargando...</p>
                                    </div>
                                </div>
                            </div>
                            <div class="p-6 space-y-4" id="listaCheckinsP">
                                <p class="text-gray-500 text-center py-8">
                                    <i class="fas fa-spinner fa-spin mr-2"></i>Cargando check-ins pendientes...
                                </p>
                            </div>
                        </div>

                        <!-- Check-outs Hoy -->
                        <div class="bg-white rounded-xl shadow-md overflow-hidden">
                            <div class="bg-gradient-to-r from-blue-500 to-blue-600 px-6 py-4 flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <i class="fas fa-sign-out-alt text-2xl text-white"></i>
                                    <div>
                                        <h3 class="text-lg font-bold text-white">Check-outs Hoy</h3>
                                        <p class="text-blue-100 text-xs" id="countCheckoutsH">Cargando...</p>
                                    </div>
                                </div>
                            </div>
                            <div class="p-6 space-y-4" id="listaCheckoutsH">
                                <p class="text-gray-500 text-center py-8">
                                    <i class="fas fa-spinner fa-spin mr-2"></i>Cargando check-outs del día...
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Actividad Reciente Section -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-8">
                        <!-- Actividad Reciente -->
                        <div class="lg:col-span-1 bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl shadow-md overflow-hidden text-white">
                            <div class="p-6 border-b border-purple-400">
                                <h3 class="text-lg font-bold flex items-center space-x-2">
                                    <i class="fas fa-clock"></i>
                                    <span>Actividad Reciente</span>
                                </h3>
                            </div>
                            <div class="p-6 space-y-4 max-h-[400px] overflow-y-auto" id="actividadReciente">
                                <p class="text-purple-100 text-center py-8">
                                    <i class="fas fa-spinner fa-spin mr-2"></i>Cargando actividad...
                                </p>
                            </div>
                        </div>

                        <!-- Ingresos de la Semana -->
                        <div class="lg:col-span-2 bg-white rounded-xl shadow-md overflow-hidden">
                            <div class="p-6 border-b border-gray-200 flex justify-between items-center">
                                <h3 class="text-lg font-bold text-gray-800 flex items-center space-x-2">
                                    <i class="fas fa-chart-line text-green-600"></i>
                                    <span>Ingresos de la Semana</span>
                                </h3>
                                <a href="reportes.jsp" class="text-blue-600 hover:text-blue-700 text-sm font-semibold">Ver detalles →</a>
                            </div>
                            <div class="p-6">
                                <div class="flex justify-between items-end h-48 gap-2" id="chartIngresosWeek">
                                    <div class="flex-1 bg-gradient-to-t from-blue-500 to-blue-400 rounded-t-lg opacity-50 hover:opacity-100 transition" style="height: 30%; min-height: 30px;" title="Lun">
                                        <p class="text-xs text-center text-gray-600 mt-1">Lun</p>
                                    </div>
                                    <div class="flex-1 bg-gradient-to-t from-blue-500 to-blue-400 rounded-t-lg opacity-50 hover:opacity-100 transition" style="height: 45%; min-height: 45px;" title="Mar">
                                        <p class="text-xs text-center text-gray-600 mt-1">Mar</p>
                                    </div>
                                    <div class="flex-1 bg-gradient-to-t from-blue-500 to-blue-400 rounded-t-lg opacity-50 hover:opacity-100 transition" style="height: 60%; min-height: 60px;" title="Mié">
                                        <p class="text-xs text-center text-gray-600 mt-1">Mié</p>
                                    </div>
                                    <div class="flex-1 bg-gradient-to-t from-blue-500 to-blue-400 rounded-t-lg opacity-50 hover:opacity-100 transition" style="height: 75%; min-height: 75px;" title="Jue">
                                        <p class="text-xs text-center text-gray-600 mt-1">Jue</p>
                                    </div>
                                    <div class="flex-1 bg-gradient-to-t from-blue-500 to-blue-400 rounded-t-lg opacity-50 hover:opacity-100 transition" style="height: 55%; min-height: 55px;" title="Vie">
                                        <p class="text-xs text-center text-gray-600 mt-1">Vie</p>
                                    </div>
                                    <div class="flex-1 bg-gradient-to-t from-blue-500 to-blue-400 rounded-t-lg opacity-50 hover:opacity-100 transition" style="height: 80%; min-height: 80px;" title="Sab">
                                        <p class="text-xs text-center text-gray-600 mt-1">Sab</p>
                                    </div>
                                    <div class="flex-1 bg-gradient-to-t from-blue-500 to-blue-400 rounded-t-lg opacity-50 hover:opacity-100 transition" style="height: 40%; min-height: 40px;" title="Dom">
                                        <p class="text-xs text-center text-gray-600 mt-1">Dom</p>
                                    </div>
                                </div>
                                <div class="mt-6 pt-6 border-t border-gray-200">
                                    <p class="text-sm text-gray-600">
                                        <i class="fas fa-info-circle mr-2 text-blue-600"></i>
                                        Los datos se cargarán dinámicamente desde la base de datos
                                    </p>
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
    <script src="js/dashboard.js"></script>
    <script>
        // Actualizar ocupación en vivo
        async function actualizarOcupacionEnVivo() {
            try {
                const [habitacionesData, checkinsActivosData] = await Promise.all([
                    fetchData('habitaciones?action=listar').catch(e => { console.error('Error:', e); return []; }),
                    fetchData('checkin?action=activos').catch(e => { console.error('Error:', e); return []; })
                ]);
                
                if (habitacionesData && checkinsActivosData) {
                    const checkinsActivos = checkinsActivosData || [];
                    const habitacionesOcupadasPorCheckin = checkinsActivos.map(c => c.habitacion);
                    
                    const ocupadas = habitacionesData.filter(h => 
                        habitacionesOcupadasPorCheckin.includes(h.id) || h.estado === 'Ocupada'
                    ).length;
                    
                    const total = habitacionesData.length;
                    const porcentaje = total > 0 ? Math.round((ocupadas / total) * 100) : 0;
                    
                    // Actualizar grid card
                    document.getElementById('ocupadasCount').textContent = ocupadas;
                    document.getElementById('totalCount').textContent = total;
                    document.getElementById('ocupacionPorcentaje').textContent = porcentaje;
                    
                    console.log('✓ Ocupación en vivo:', ocupadas + '/' + total + ' (' + porcentaje + '%)');
                }
            } catch (error) {
                console.error('Error al actualizar ocupación:', error);
            }
        }
        
        // Actualizar ingresos hoy en vivo
        async function actualizarIngresosHoy() {
            try {
                const ventasData = await fetchData('ventas?action=listar').catch(e => { console.error('Error:', e); return []; });
                
                if (ventasData && ventasData.length > 0) {
                    // Filtrar ventas de hoy
                    const hoy = new Date();
                    hoy.setHours(0, 0, 0, 0);
                    
                    const ventasHoy = ventasData.filter(v => {
                        const fecha = new Date(v.fecha);
                        fecha.setHours(0, 0, 0, 0);
                        return fecha.getTime() === hoy.getTime();
                    });
                    
                    // Calcular total
                    const totalIngresos = ventasHoy.reduce((sum, v) => sum + (v.total || 0), 0);
                    
                    // Formatear moneda colombiana
                    const ingresoFormateado = formatearMoneda(totalIngresos);
                    
                    // Actualizar grid card
                    document.getElementById('ingresosHoy').textContent = ingresoFormateado;
                    document.getElementById('variacionIngresos').textContent = '📈 ' + ventasHoy.length + ' ventas hoy';
                    
                    console.log('✓ Ingresos hoy:', ingresoFormateado + ' (' + ventasHoy.length + ' ventas)');
                } else {
                    document.getElementById('ingresosHoy').textContent = formatearMoneda(0);
                    document.getElementById('variacionIngresos').textContent = '📈 Sin ventas hoy';
                    console.log('✓ Ingresos hoy: $0 (sin ventas)');
                }
            } catch (error) {
                console.error('Error al actualizar ingresos:', error);
            }
        }
        
        // Cargar datos dinámicamente del servidor
        document.addEventListener('DOMContentLoaded', function() {
            console.log('📊 Dashboard - Cargando datos...');
            
            // Actualizar ocupación inmediatamente
            actualizarOcupacionEnVivo();
            // Actualizar ocupación cada 5 segundos
            setInterval(actualizarOcupacionEnVivo, 5000);
            
            // Actualizar ingresos inmediatamente
            actualizarIngresosHoy();
            // Actualizar ingresos cada 5 segundos
            setInterval(actualizarIngresosHoy, 5000);
            
            // Actualizar reservas confirmadas inmediatamente
            actualizarReservasConfirmadas();
            // Actualizar reservas cada 5 segundos
            setInterval(actualizarReservasConfirmadas, 5000);
            
            cargarDatosCheckinsHoy();
            cargarDatosCheckoutsHoy();
            cargarActividadReciente();
            cargarIngresosSemanales();
        });
    </script>
</body>
</html>

