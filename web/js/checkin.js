// Gestión de Check-in/Check-out

let checkIns = [];
let clientes = [];
let habitaciones = [];
let reservas = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('Check-in - Inicializando...');
    cargarDatos();
    setInterval(cargarCheckInsActivos, 5000); // Actualizar cada 5 segundos
});

async function cargarDatos() {
    try {
        console.log('Cargando datos para check-in...');
        
        // Cargar todos los datos en paralelo
        [clientes, habitaciones, reservas] = await Promise.all([
            fetchData('clientes?action=listar').catch(e => { console.error('Error clientes:', e); return []; }),
            fetchData('habitaciones?action=listar').catch(e => { console.error('Error habitaciones:', e); return []; }),
            fetchData('reservas?action=listar').catch(e => { console.error('Error reservas:', e); return []; })
        ]);
        
        clientes = clientes || [];
        habitaciones = habitaciones || [];
        reservas = reservas || [];
        
        console.log('✓ Datos cargados:', { clientes: clientes.length, habitaciones: habitaciones.length, reservas: reservas.length });
        
        // PASO 1: Obtener hoy
        const hoy = new Date();
        hoy.setHours(0, 0, 0, 0);
        
        // PASO 2: Filtrar SOLO reservas confirmadas para HOY
        const reservasHoy = reservas.filter(r => {
            const fechaEntrada = new Date(r.fechaEntrada);
            fechaEntrada.setHours(0, 0, 0, 0);
            return fechaEntrada.getTime() === hoy.getTime() && r.estado === 'Confirmada';
        });
        
        console.log('📋 Reservas confirmadas para hoy:', reservasHoy.length);
        
        // PASO 2.5: Obtener IDs de check-ins ya realizados
        const checkInsRealizados = checkIns.map(ci => ci.idCliente);
        console.log('✓ Check-ins ya realizados:', checkInsRealizados.length);
        
        // PASO 3: Filtrar reservas que AÚN NO tienen check-in
        const reservasDisponibles = reservasHoy.filter(r => 
            !checkInsRealizados.includes(r.idCliente)
        );
        
        console.log('✓ Reservas disponibles para check-in:', reservasDisponibles.length);
        
        // PASO 4: Obtener clientes y habitaciones con reserva DISPONIBLE
        const clientesConReserva = clientes.filter(c => 
            reservasDisponibles.some(r => r.idCliente === c.id)
        );
        const habitacionesConReserva = habitaciones.filter(h => 
            reservasDisponibles.some(r => r.habitacion === h.id)
        );
        
        // PASO 4: Llenar select de clientes
        const selectCliente = document.getElementById('clienteCheckIn');
        if (selectCliente) {
            if (clientesConReserva.length === 0) {
                selectCliente.innerHTML = '<option value="">❌ No hay reservas para hoy</option>';
                console.warn('⚠️ Sin reservas confirmadas para hoy');
            } else {
                selectCliente.innerHTML = '<option value="">👤 Seleccione un cliente</option>' +
                    clientesConReserva.map(c => {
                        const reserva = reservasDisponibles.find(r => r.idCliente === c.id);
                        return `<option value="${c.id}" data-reserva="${reserva.id}" data-habitacion="${reserva.habitacion}" data-noches="${Math.ceil((new Date(reserva.fechaSalida) - new Date(reserva.fechaEntrada)) / (1000 * 60 * 60 * 24))}">${c.nombre} ${c.apellido}</option>`;
                    }).join('');
            }
            
            // Evento: Al seleccionar cliente, auto-llenar habitación
            selectCliente.addEventListener('change', (e) => {
                const option = e.target.options[e.target.selectedIndex];
                if (option.value) {
                    const habitacionId = option.dataset.habitacion;
                    const noches = option.dataset.noches;
                    
                    document.getElementById('habitacionCheckIn').value = habitacionId;
                    document.getElementById('noches').value = noches;
                    document.getElementById('fechaIngreso').value = new Date().toISOString().slice(0, 16);
                    
                    console.log('✓ Datos auto-llenados:', { habitacionId, noches });
                }
            });
        }
        
        // PASO 5: Llenar select de habitaciones (SOLO las con reserva para hoy)
        const selectHabitacion = document.getElementById('habitacionCheckIn');
        if (selectHabitacion) {
            if (habitacionesConReserva.length === 0) {
                selectHabitacion.innerHTML = '<option value="">❌ No hay habitaciones reservadas para hoy</option>';
            } else {
                selectHabitacion.innerHTML = '<option value="">🚪 Seleccione una habitación</option>' +
                    habitacionesConReserva.map(h => `<option value="${h.id}">${h.idHabitacion} - ${h.tipoHabitacion}</option>`).join('');
            }
        }
        
        // PASO 6: Cargar check-ins activos
        cargarCheckInsActivos();
    } catch (error) {
        console.error('Error al cargar datos:', error);
        mostrarNotificacion('Error al cargar datos de check-in', 'error');
    }
}

async function cargarCheckInsActivos() {
    try {
        // Cargar check-ins activos Y todos los check-ins (para calcular check-outs)
        let checkInsActivos = [];
        let todosLosCheckIns = [];
        
        try {
            checkInsActivos = await fetchData('checkin?action=activos') || [];
            console.log('✓ Check-ins activos cargados:', checkInsActivos.length);
        } catch (e) {
            console.warn('⚠️ Check-ins activos no disponibles:', e.message);
            checkInsActivos = [];
        }
        
        try {
            todosLosCheckIns = await fetchData('checkin?action=listar') || [];
            console.log('✓ Todos los check-ins cargados:', todosLosCheckIns.length);
        } catch (e) {
            console.warn('⚠️ No se pudieron cargar todos los check-ins:', e.message);
            todosLosCheckIns = [];
        }
        
        checkIns = checkInsActivos;
        
        // Calcular estadísticas
        const totalCheckIns = checkInsActivos.length;
        
        // Actualizar tarjetas de resumen si existen
        const totalActivos = document.getElementById('totalActivos');
        if (totalActivos) {
            totalActivos.textContent = totalCheckIns;
        }
        
        // Calcular check-ins de hoy (RESERVAS confirmadas para hoy)
        const hoy = new Date();
        hoy.setHours(0, 0, 0, 0);
        
        const checkinsHoy = reservas.filter(r => {
            if (!r.fechaEntrada) return false;
            const fechaEntrada = new Date(r.fechaEntrada);
            fechaEntrada.setHours(0, 0, 0, 0);
            return fechaEntrada.getTime() === hoy.getTime() && r.estado === 'Confirmada';
        }).length;
        
        const checkinsHoyEl = document.getElementById('checkinsHoyCount');
        if (checkinsHoyEl) {
            checkinsHoyEl.textContent = checkinsHoy;
        }
        
        // Calcular check-outs de hoy (TODOS los check-ins con fecha de salida hoy - incluyendo finalizados)
        const checkoutsHoy = todosLosCheckIns.filter(ci => {
            if (!ci.fechaSalidaChecking) return false;
            const fechaSalida = new Date(ci.fechaSalidaChecking);
            fechaSalida.setHours(0, 0, 0, 0);
            return fechaSalida.getTime() === hoy.getTime();
        }).length;
        
        const checkoutsHoyEl = document.getElementById('checkoutsHoyCount');
        if (checkoutsHoyEl) {
            checkoutsHoyEl.textContent = checkoutsHoy;
        }
        
        console.log('✓ Check-ins activos:', totalCheckIns, '| Reservas para hoy:', checkinsHoy, '| Salidas hoy:', checkoutsHoy);
        
        renderizarTabla();
        renderizarAgenda();
    } catch (error) {
        console.error('Error al cargar check-ins:', error);
    }
}

function renderizarAgenda() {
    try {
        const agendaDiv = document.getElementById('agendaReservas');
        if (!agendaDiv) return;
        
        // Obtener próximos 7 días
        const hoy = new Date();
        hoy.setHours(0, 0, 0, 0);
        
        const dias = [];
        for (let i = 0; i < 7; i++) {
            const fecha = new Date(hoy);
            fecha.setDate(fecha.getDate() + i);
            dias.push(fecha);
        }
        
        // Obtener IDs de clientes que ya tienen check-in
        const clientesConCheckIn = checkIns.map(ci => ci.idCliente);
        console.log('📋 Clientes con check-in:', clientesConCheckIn);
        console.log('📅 Total reservas:', reservas.length);
        
        // Contar reservas PENDIENTES de check-in por día (confirmadas pero sin check-in)
        const reservasPorDia = {};
        dias.forEach(dia => {
            const diaStr = dia.toISOString().split('T')[0];
            const reservasDelDia = reservas.filter(r => {
                const fechaEntrada = new Date(r.fechaEntrada);
                const esEseDia = fechaEntrada.toISOString().split('T')[0] === diaStr;
                const esConfirmada = r.estado === 'Confirmada';
                const sinCheckIn = !clientesConCheckIn.includes(r.idCliente);
                return esEseDia && esConfirmada && sinCheckIn;
            });
            reservasPorDia[diaStr] = reservasDelDia.length;
            if (reservasDelDia.length > 0) {
                console.log(`📅 ${diaStr}: ${reservasDelDia.length} check-ins pendientes`);
            }
        });
        
        // Renderizar días
        agendaDiv.innerHTML = dias.map((dia, index) => {
            const diaStr = dia.toISOString().split('T')[0];
            const cantidad = reservasPorDia[diaStr] || 0;
            const esHoy = index === 0;
            const nombreDia = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'][dia.getDay()];
            
            const colorBg = cantidad === 0 ? 'bg-gray-100' :
                           cantidad <= 2 ? 'bg-green-100' :
                           cantidad <= 4 ? 'bg-yellow-100' :
                           'bg-red-100';
            
            const colorTexto = cantidad === 0 ? 'text-gray-600' :
                              cantidad <= 2 ? 'text-green-600' :
                              cantidad <= 4 ? 'text-yellow-600' :
                              'text-red-600';
            
            const borde = esHoy ? 'border-2 border-purple-500' : 'border border-gray-200';
            
            return `
                <div class="${colorBg} ${borde} rounded-lg p-4 text-center cursor-pointer hover:shadow-lg transition">
                    <p class="text-xs font-semibold text-gray-600">${nombreDia}</p>
                    <p class="text-lg font-bold text-gray-800">${dia.getDate()}</p>
                    <p class="text-xs text-gray-500 mb-2">${dia.toLocaleDateString('es-ES', { month: 'short' })}</p>
                    <div class="flex items-center justify-center space-x-1">
                        <span class="material-icons-outlined text-sm ${colorTexto}">login</span>
                        <span class="text-sm font-bold ${colorTexto}">${cantidad}</span>
                    </div>
                    ${esHoy ? '<p class="text-xs font-bold text-purple-600 mt-1">HOY</p>' : ''}
                </div>
            `;
        }).join('');
        
        // Total de reservas PENDIENTES de check-in próximas
        const totalReservasPendientes = Object.values(reservasPorDia).reduce((a, b) => a + b, 0);
        
        // Actualizar ambos elementos (header y KPI card)
        const totalElHeader = document.getElementById('totalReservasProximasHeader');
        if (totalElHeader) {
            totalElHeader.textContent = totalReservasPendientes;
        }
        
        const totalElCard = document.getElementById('totalReservasProximas');
        if (totalElCard) {
            totalElCard.textContent = totalReservasPendientes;
        }
        
        console.log('✓ Agenda renderizada:', totalReservasPendientes, 'check-ins pendientes próximos 7 días');
    } catch (error) {
        console.error('Error al renderizar agenda:', error);
    }
}

function renderizarTabla() {
    const tbody = document.getElementById('tablaCheckIns');
    
    if (!tbody) {
        console.error('ERROR: No se encontró el elemento tablaCheckIns');
        return;
    }
    
    if (checkIns.length === 0) {
        tbody.innerHTML = '<tr><td colspan="5" class="text-center py-8 text-gray-500"><i class="fas fa-inbox text-3xl mb-2"></i><p>No hay huéspedes activos</p><p class="text-xs mt-1">Registra un check-in para comenzar</p></td></tr>';
        return;
    }
    
    console.log('✓ Renderizando', checkIns.length, 'huéspedes activos');
    
    tbody.innerHTML = checkIns.map(ci => {
        const cliente = clientes.find(c => c.id === ci.idCliente);
        const habitacion = habitaciones.find(h => h.id === ci.habitacion) || { idHabitacion: 'N/A', tipoHabitacion: 'N/A' };
        
        const fechaIngreso = new Date(ci.fechaIngresoCheckin);
        const fechaIngresoFormato = fechaIngreso.toLocaleString('es-ES', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        });
        
        // Calcular horas desde ingreso
        const ahora = new Date();
        const horasTranscurridas = Math.floor((ahora - fechaIngreso) / (1000 * 60 * 60));
        const minutosTranscurridos = Math.floor(((ahora - fechaIngreso) % (1000 * 60 * 60)) / (1000 * 60));
        
        // Avatar del cliente
        const inicial = cliente ? cliente.nombre.charAt(0).toUpperCase() : '?';
        const coloresAvatar = ['bg-blue-500', 'bg-purple-500', 'bg-pink-500', 'bg-green-500', 'bg-orange-500', 'bg-red-500'];
        const colorAvatar = coloresAvatar[ci.idCliente % coloresAvatar.length];
        
        // Estado de la habitación
        const estadoHab = habitacion.estado === 'Disponible' ? 'bg-green-100 text-green-800 border border-green-300' :
                         habitacion.estado === 'Ocupada' ? 'bg-blue-100 text-blue-800 border border-blue-300' :
                         'bg-orange-100 text-orange-800 border border-orange-300';
        
        return `
            <tr class="border-b hover:bg-blue-50 transition">
                <td class="px-6 py-4">
                    <div class="flex items-center space-x-3">
                        <div class="${colorAvatar} w-12 h-12 rounded-full flex items-center justify-center text-white font-bold text-lg shadow-md">
                            ${inicial}
                        </div>
                        <div>
                            <p class="text-sm font-bold text-gray-900">${cliente ? cliente.nombre + ' ' + cliente.apellido : 'N/A'}</p>
                            <p class="text-xs text-gray-500">${cliente ? cliente.documento : 'N/A'}</p>
                        </div>
                    </div>
                </td>
                <td class="px-6 py-4">
                    <div class="flex items-center space-x-2">
                        <i class="fas fa-door-open text-blue-600 text-lg"></i>
                        <div>
                            <p class="text-sm font-bold text-gray-900">${habitacion.idHabitacion}</p>
                            <p class="text-xs text-gray-500">${habitacion.tipoHabitacion}</p>
                        </div>
                    </div>
                </td>
                <td class="px-6 py-4">
                    <div class="text-sm">
                        <p class="font-semibold text-gray-900">${fechaIngresoFormato}</p>
                        <p class="text-xs text-gray-500">⏱️ ${horasTranscurridas}h ${minutosTranscurridos}m</p>
                    </div>
                </td>
                <td class="px-6 py-4 text-center">
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold ${estadoHab}">
                        <i class="fas fa-circle text-xs mr-1"></i>
                        ${habitacion.estado}
                    </span>
                </td>
                <td class="px-6 py-4 text-center">
                    <button onclick="abrirModalCheckOut(${ci.idCheckin})" class="bg-gradient-to-r from-red-500 to-red-600 hover:from-red-600 hover:to-red-700 text-white px-4 py-2 rounded-lg text-sm transition flex items-center justify-center space-x-2 font-semibold">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Check-out</span>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

async function guardarCheckIn(event) {
    event.preventDefault();
    
    // VALIDACIÓN 1: Campos requeridos
    const idCliente = document.getElementById('clienteCheckIn').value;
    const habitacion = document.getElementById('habitacionCheckIn').value;
    const fechaIngreso = document.getElementById('fechaIngreso').value;
    const noches = document.getElementById('noches').value;
    
    if (!idCliente || !habitacion || !fechaIngreso || !noches) {
        mostrarNotificacion('❌ Por favor completa todos los campos requeridos', 'error');
        return;
    }
    
    // VALIDACIÓN 2: Noches válidas
    if (noches <= 0) {
        mostrarNotificacion('❌ El número de noches debe ser mayor a 0', 'error');
        return;
    }
    
    // VALIDACIÓN 3: Verificar que existe reserva para este cliente hoy
    const hoy = new Date();
    hoy.setHours(0, 0, 0, 0);
    const reservaExiste = reservas.some(r => {
        const fechaEntrada = new Date(r.fechaEntrada);
        fechaEntrada.setHours(0, 0, 0, 0);
        return r.idCliente == idCliente && 
               r.habitacion == habitacion && 
               fechaEntrada.getTime() === hoy.getTime() && 
               r.estado === 'Confirmada';
    });
    
    if (!reservaExiste) {
        mostrarNotificacion('❌ No existe reserva confirmada para este cliente hoy', 'error');
        return;
    }
    
    // VALIDACIÓN 4: Verificar que el cliente NO ya hizo check-in
    const yaHizoCheckIn = checkIns.some(ci => ci.idCliente == idCliente);
    
    if (yaHizoCheckIn) {
        mostrarNotificacion('❌ Este cliente ya realizó check-in hoy', 'error');
        return;
    }
    
    // VALIDACIÓN 5: Verificar que la habitación NO esté ocupada por otro cliente
    const habitacionOcupada = checkIns.some(ci => ci.habitacion == habitacion);
    
    if (habitacionOcupada) {
        mostrarNotificacion('❌ La habitación ya está ocupada por otro huésped. No se pueden hacer dos check-ins en la misma habitación', 'error');
        return;
    }
    
    // VALIDACIÓN 6: Verificar que NO haya otra reserva confirmada para la misma habitación en las mismas fechas
    const fechaIngresoObj = new Date(fechaIngreso);
    fechaIngresoObj.setHours(0, 0, 0, 0);
    
    const reservaConflictiva = reservas.some(r => {
        if (r.habitacion != habitacion || r.estado !== 'Confirmada' || r.idCliente == idCliente) {
            return false; // No es conflictiva
        }
        
        const fechaEntradaReserva = new Date(r.fechaEntrada);
        fechaEntradaReserva.setHours(0, 0, 0, 0);
        
        // Verificar si la fecha de entrada coincide
        return fechaEntradaReserva.getTime() === fechaIngresoObj.getTime();
    });
    
    if (reservaConflictiva) {
        mostrarNotificacion('❌ Ya existe otra reserva confirmada para esta habitación en la misma fecha. No se pueden hacer dos check-ins simultáneos', 'error');
        return;
    }
    
    console.log('✓ Registrando check-in:', { idCliente, habitacion, fechaIngreso, noches });
    
    const formData = new URLSearchParams({
        action: 'insertar',
        idCliente: idCliente,
        habitacion: habitacion,
        fechaIngreso: fechaIngreso,
        noches: noches,
        transporte: document.getElementById('transporte').value || '',
        motivoViaje: document.getElementById('motivoViaje').value || '',
        procedencia: document.getElementById('procedencia').value || '',
        acompanantes: document.getElementById('acompanantes').value || ''
    });
    
    try {
        const response = await fetch('checkin', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        const result = await response.json();
        
        if (result.success) {
            mostrarNotificacion('✅ Check-in registrado correctamente - Habitación OCUPADA');
            document.getElementById('formCheckIn').reset();
            await cargarDatos();
            await cargarCheckInsActivos();
        } else {
            mostrarNotificacion('❌ Error: ' + (result.message || 'No se pudo registrar el check-in'), 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        mostrarNotificacion('Error al registrar check-in', 'error');
    }
}

function abrirModalCheckOut(idCheckin) {
    document.getElementById('checkInId').value = idCheckin;
    document.getElementById('fechaSalida').value = new Date().toISOString().slice(0, 16);
    document.getElementById('modalCheckOut').classList.remove('hidden');
}

function cerrarModalCheckOut() {
    document.getElementById('modalCheckOut').classList.add('hidden');
    document.getElementById('modalFactura').classList.add('hidden');
}

async function generarFactura(checkIn, cliente, habitacion, ventas) {
    // Cargar productos si no están disponibles
    let productos = [];
    try {
        productos = await fetchData('productos?action=listar') || [];
    } catch (e) {
        console.error('Error al cargar productos:', e);
    }
    
    // Formatear fechas
    const fechaIngreso = new Date(checkIn.fechaIngresoCheckin);
    const fechaSalida = new Date(checkIn.fechaSalidaChecking);
    
    // Calcular total de habitación
    const totalHabitacion = (habitacion?.precioNoche || 0) * checkIn.noches;
    
    // Calcular totales de ventas
    let totalVentas = 0;
    let iva5Total = 0;
    let iva19Total = 0;
    let totalConsumos = 0;
    
    const itemsVentas = [];
    ventas.forEach(venta => {
        const subtotalVenta = venta.total - (venta.iva5 || 0) - (venta.iva19 || 0);
        totalVentas += venta.total;
        iva5Total += venta.iva5 || 0;
        iva19Total += venta.iva19 || 0;
        totalConsumos += subtotalVenta;
        
        // Agregar productos de la venta
        if (venta.productos && venta.productos.length > 0) {
            venta.productos.forEach(pv => {
                const producto = productos.find(p => p.id === pv.idProducto);
                const subtotalItem = pv.cantidad * pv.precioUnitario;
                itemsVentas.push({
                    descripcion: producto ? producto.descripcion : `Producto #${pv.idProducto}`,
                    cantidad: pv.cantidad,
                    precioUnitario: pv.precioUnitario,
                    subtotal: subtotalItem,
                    iva: producto ? producto.iva : 0
                });
            });
        } else {
            // Si no hay productos, mostrar como consumo general
            itemsVentas.push({
                descripcion: `Consumo - ${new Date(venta.fecha).toLocaleString('es-ES')}`,
                cantidad: 1,
                precioUnitario: subtotalVenta,
                subtotal: subtotalVenta,
                iva: 0
            });
        }
    });
    
    // Calcular totales finales
    const subtotalHabitacion = totalHabitacion;
    const subtotalConsumos = totalConsumos;
    const subtotalGeneral = subtotalHabitacion + subtotalConsumos;
    const totalIVA = iva5Total + iva19Total;
    const totalFinal = subtotalGeneral + totalIVA;
    
    // Generar HTML de la factura
    const facturaHTML = `
        <div class="max-w-4xl mx-auto bg-white p-8">
            <!-- Encabezado -->
            <div class="border-b-4 border-indigo-600 pb-6 mb-6">
                <div class="flex justify-between items-start">
                    <div>
                        <h1 class="text-3xl font-bold text-gray-900 mb-2">FACTURA</h1>
                        <p class="text-sm text-gray-600">Sistema Hotelero</p>
                    </div>
                    <div class="text-right">
                        <p class="text-sm text-gray-600">Factura #${checkIn.idCheckin}</p>
                        <p class="text-sm text-gray-600">${new Date().toLocaleDateString('es-ES', { year: 'numeric', month: 'long', day: 'numeric' })}</p>
                    </div>
                </div>
            </div>
            
            <!-- Datos del Cliente -->
            <div class="grid grid-cols-2 gap-6 mb-6">
                <div>
                    <h3 class="text-sm font-bold text-gray-700 mb-2">CLIENTE</h3>
                    <p class="text-sm text-gray-900 font-semibold">${cliente ? cliente.nombre + ' ' + cliente.apellido : 'N/A'}</p>
                    <p class="text-xs text-gray-600">Documento: ${cliente ? cliente.documento : 'N/A'}</p>
                    <p class="text-xs text-gray-600">${cliente ? cliente.correo || '' : ''}</p>
                    <p class="text-xs text-gray-600">${cliente ? cliente.telefono || '' : ''}</p>
                </div>
                <div>
                    <h3 class="text-sm font-bold text-gray-700 mb-2">ESTADÍA</h3>
                    <p class="text-sm text-gray-900">Habitación: <span class="font-semibold">${habitacion ? habitacion.idHabitacion : 'N/A'}</span></p>
                    <p class="text-xs text-gray-600">Tipo: ${habitacion ? habitacion.tipoHabitacion : 'N/A'}</p>
                    <p class="text-xs text-gray-600">Ingreso: ${fechaIngreso.toLocaleString('es-ES')}</p>
                    <p class="text-xs text-gray-600">Salida: ${fechaSalida.toLocaleString('es-ES')}</p>
                    <p class="text-xs text-gray-600">Noches: <span class="font-semibold">${checkIn.noches}</span></p>
                </div>
            </div>
            
            <!-- Detalle de Habitación -->
            <div class="mb-6">
                <h3 class="text-sm font-bold text-gray-700 mb-3">DETALLE DE HABITACIÓN</h3>
                <table class="w-full text-sm">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-4 py-2 text-left font-semibold text-gray-700">Descripción</th>
                            <th class="px-4 py-2 text-center font-semibold text-gray-700">Cantidad</th>
                            <th class="px-4 py-2 text-right font-semibold text-gray-700">Precio Unitario</th>
                            <th class="px-4 py-2 text-right font-semibold text-gray-700">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y">
                        <tr>
                            <td class="px-4 py-3 text-gray-900">Habitación ${habitacion ? habitacion.idHabitacion : 'N/A'} - ${habitacion ? habitacion.tipoHabitacion : 'N/A'}</td>
                            <td class="px-4 py-3 text-center text-gray-700">${checkIn.noches} noche(s)</td>
                            <td class="px-4 py-3 text-right text-gray-700">${formatearMoneda(habitacion?.precioNoche || 0)}</td>
                            <td class="px-4 py-3 text-right font-semibold text-gray-900">${formatearMoneda(totalHabitacion)}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- Detalle de Consumos -->
            ${itemsVentas.length > 0 ? `
            <div class="mb-6">
                <h3 class="text-sm font-bold text-gray-700 mb-3">CONSUMOS A HABITACIÓN</h3>
                <table class="w-full text-sm">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-4 py-2 text-left font-semibold text-gray-700">Descripción</th>
                            <th class="px-4 py-2 text-center font-semibold text-gray-700">Cantidad</th>
                            <th class="px-4 py-2 text-right font-semibold text-gray-700">Precio Unitario</th>
                            <th class="px-4 py-2 text-right font-semibold text-gray-700">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y">
                        ${itemsVentas.map(item => `
                            <tr>
                                <td class="px-4 py-3 text-gray-900">${item.descripcion}</td>
                                <td class="px-4 py-3 text-center text-gray-700">${item.cantidad}</td>
                                <td class="px-4 py-3 text-right text-gray-700">${formatearMoneda(item.precioUnitario)}</td>
                                <td class="px-4 py-3 text-right font-semibold text-gray-900">${formatearMoneda(item.subtotal)}</td>
                            </tr>
                        `).join('')}
                    </tbody>
                </table>
            </div>
            ` : '<div class="mb-6"><p class="text-sm text-gray-500 italic">No hay consumos registrados</p></div>'}
            
            <!-- Totales -->
            <div class="border-t-2 border-gray-300 pt-4">
                <div class="flex justify-end">
                    <div class="w-80 space-y-2">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-700">Subtotal Habitación:</span>
                            <span class="font-semibold text-gray-900">${formatearMoneda(subtotalHabitacion)}</span>
                        </div>
                        ${subtotalConsumos > 0 ? `
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-700">Subtotal Consumos:</span>
                            <span class="font-semibold text-gray-900">${formatearMoneda(subtotalConsumos)}</span>
                        </div>
                        ` : ''}
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-700">Subtotal:</span>
                            <span class="font-semibold text-gray-900">${formatearMoneda(subtotalGeneral)}</span>
                        </div>
                        ${iva5Total > 0 ? `
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-700">IVA 5%:</span>
                            <span class="font-semibold text-gray-900">${formatearMoneda(iva5Total)}</span>
                        </div>
                        ` : ''}
                        ${iva19Total > 0 ? `
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-700">IVA 19%:</span>
                            <span class="font-semibold text-gray-900">${formatearMoneda(iva19Total)}</span>
                        </div>
                        ` : ''}
                        <div class="flex justify-between text-lg font-bold border-t-2 border-gray-400 pt-2 mt-2">
                            <span class="text-gray-900">TOTAL A PAGAR:</span>
                            <span class="text-indigo-600">${formatearMoneda(totalFinal)}</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Pie de página -->
            <div class="mt-8 pt-6 border-t text-center text-xs text-gray-500">
                <p>Gracias por su estadía. ¡Esperamos verlo pronto!</p>
            </div>
        </div>
    `;
    
    // Mostrar en modal
    const modalFactura = document.getElementById('modalFactura');
    const contenidoFactura = document.getElementById('contenidoFactura');
    if (modalFactura && contenidoFactura) {
        contenidoFactura.innerHTML = facturaHTML;
        modalFactura.classList.remove('hidden');
    }
}

function cerrarModalFactura() {
    document.getElementById('modalFactura').classList.add('hidden');
}

function imprimirFactura() {
    const contenido = document.getElementById('contenidoFactura').innerHTML;
    const ventana = window.open('', '_blank');
    ventana.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Factura</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                table { width: 100%; border-collapse: collapse; }
                th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
                th { background-color: #f2f2f2; }
                .total { font-weight: bold; font-size: 1.2em; }
            </style>
        </head>
        <body>
            ${contenido}
        </body>
        </html>
    `);
    ventana.document.close();
    ventana.print();
}

async function hacerCheckOut(event) {
    event.preventDefault();
    
    const formData = new URLSearchParams({
        action: 'checkout',
        idCheckin: document.getElementById('checkInId').value,
        fechaSalida: document.getElementById('fechaSalida').value
    });
    
    try {
        const response = await fetch('checkin', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        const result = await response.json();
        
        if (result.success) {
            // Obtener datos completos para la factura
            const checkIn = result.checkIn;
            const ventas = result.ventas || [];
            
            // Obtener datos del cliente y habitación
            const cliente = clientes.find(c => c.id === checkIn.idCliente);
            const habitacion = habitaciones.find(h => h.id === checkIn.habitacion);
            
            // Generar y mostrar factura
            generarFactura(checkIn, cliente, habitacion, ventas);
            
            mostrarNotificacion('✅ Check-out realizado correctamente - Habitación DISPONIBLE');
            await cargarDatos();
            await cargarCheckInsActivos();
        } else {
            mostrarNotificacion('❌ Error al realizar check-out', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        mostrarNotificacion('Error al realizar check-out', 'error');
    }
}

