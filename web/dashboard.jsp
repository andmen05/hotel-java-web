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
    <title>Dashboard - Hotel Paradise</title>
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
                <a class="flex items-center px-4 py-2.5 bg-primary text-white rounded-lg font-semibold" href="dashboard.jsp">
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
                    <h2 class="text-2xl font-bold text-gray-900">Dashboard Principal</h2>
                    <p class="text-sm text-gray-500">Bienvenido de vuelta, <%= usuario.getNombre() != null ? usuario.getNombre() : "Admin" %> 👋</p>
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
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                        <!-- Habitaciones Ocupadas -->
                        <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-blue-100 text-sm font-semibold">Habitaciones</p>
                                    <p class="text-blue-100 text-xs">Ocupadas</p>
                                    <h3 class="text-4xl font-bold mt-2"><span id="ocupadasCount">0</span>/<span id="totalCount">0</span></h3>
                                    <p class="text-blue-100 text-xs mt-2"><span id="ocupacionPorcentaje">0</span>% ocupación</p>
                                </div>
                                <span class="material-icons-outlined text-4xl opacity-30">door_front</span>
                            </div>
                        </div>

                        <!-- Check-ins Hoy -->
                        <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-purple-100 text-sm font-semibold">Check-ins Hoy</p>
                                    <h3 class="text-4xl font-bold mt-2" id="checkinsHoy">0</h3>
                                    <p class="text-purple-100 text-xs mt-2"><span class="material-icons-outlined text-sm mr-1">person</span><span id="textCheckinsHoy">Sin check-ins</span></p>
                                </div>
                                <span class="material-icons-outlined text-4xl opacity-30">login</span>
                            </div>
                        </div>

                        <!-- Ingresos Hoy -->
                        <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-green-100 text-sm font-semibold">Ingresos Hoy</p>
                                    <h3 class="text-4xl font-bold mt-2" id="ingresosHoy">$0</h3>
                                    <p class="text-green-100 text-xs mt-2"><span class="material-icons-outlined text-sm mr-1">check_circle</span><span id="textIngresosHoy">Sin ventas hoy</span></p>
                                </div>
                                <span class="material-icons-outlined text-4xl opacity-30">attach_money</span>
                            </div>
                        </div>

                        <!-- Reservas Confirmadas -->
                        <div class="bg-gradient-to-br from-orange-500 to-orange-600 rounded-xl p-6 text-white shadow-lg">
                            <div class="flex justify-between items-start">
                                <div>
                                    <p class="text-orange-100 text-sm font-semibold">Reservas</p>
                                    <p class="text-orange-100 text-xs">Confirmadas</p>
                                    <h3 class="text-4xl font-bold mt-2"><span id="reservasConfirmadas">0</span></h3>
                                    <p class="text-orange-100 text-xs mt-2"><span class="material-icons-outlined text-sm mr-1">event</span><span id="textReservasConfirmadas">0 activas</span></p>
                                </div>
                                <span class="material-icons-outlined text-4xl opacity-30">calendar_month</span>
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
                                        andmen05
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
                
                const ingresosEl = document.getElementById('ingresosHoy');
                const textIngresosEl = document.getElementById('textIngresosHoy');
                if (!ingresosEl) return;
                
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
                    ingresosEl.textContent = ingresoFormateado;
                    if (textIngresosEl) {
                        if (ventasHoy.length === 0) {
                            textIngresosEl.textContent = 'Sin ventas hoy';
                        } else if (ventasHoy.length === 1) {
                            textIngresosEl.textContent = '1 venta hoy';
                        } else {
                            textIngresosEl.textContent = ventasHoy.length + ' ventas hoy';
                        }
                    }
                    
                    console.log('✓ Ingresos hoy:', ingresoFormateado + ' (' + ventasHoy.length + ' ventas)');
                } else {
                    ingresosEl.textContent = formatearMoneda(0);
                    if (textIngresosEl) {
                        textIngresosEl.textContent = 'Sin ventas hoy';
                    }
                    console.log('✓ Ingresos hoy: $0 (sin ventas)');
                }
            } catch (error) {
                console.warn('⚠️ Error al actualizar ingresos:', error);
                const ingresosEl = document.getElementById('ingresosHoy');
                const textIngresosEl = document.getElementById('textIngresosHoy');
                if (ingresosEl) {
                    ingresosEl.textContent = formatearMoneda(0);
                }
                if (textIngresosEl) {
                    textIngresosEl.textContent = 'Sin ventas hoy';
                }
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
            setInterval(cargarDatosCheckinsHoy, 5000);
            
            cargarDatosCheckoutsHoy();
            setInterval(cargarDatosCheckoutsHoy, 5000);
            
            cargarActividadReciente();
            cargarIngresosSemanales();
        });
    </script>
</body>
</html>

