// Gestión de Reservas

let reservas = [];
let reservasOriginales = [];
let reservasFiltradas = [];
let clientes = [];
let habitaciones = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('📅 Reservas - Inicializando...');
    cargarDatos();
    
    // Event listeners para filtros
    document.getElementById('buscarReserva')?.addEventListener('input', aplicarFiltros);
    document.getElementById('filtroEstado')?.addEventListener('change', aplicarFiltros);
    document.getElementById('filtroFechaEntrada')?.addEventListener('change', aplicarFiltros);
    document.getElementById('filtroFechaSalida')?.addEventListener('change', aplicarFiltros);
    document.getElementById('filtroHabitacion')?.addEventListener('change', aplicarFiltros);
    
    // Event listener para el formulario
    const formReserva = document.getElementById('formReserva');
    if (formReserva) {
        // Remover el onsubmit del HTML si existe
        formReserva.onsubmit = null;
        formReserva.addEventListener('submit', guardarReserva);
    }
    
    // Actualizar grid cards cada 5 segundos
    setInterval(cargarDatos, 5000);
});

async function cargarDatos() {
    try {
        // No recargar si el modal está abierto
        const modalAbierto = !document.getElementById('modalReserva')?.classList.contains('hidden');
        if (modalAbierto) {
            console.log('Modal abierto, saltando recarga de datos');
            return;
        }
        
        const nuevasReservas = await fetchData('reservas?action=listar') || [];
        const nuevosClientes = await fetchData('clientes?action=listar') || [];
        const nuevasHabitaciones = await fetchData('habitaciones?action=listar') || [];
        
        // Solo actualizar si los datos realmente cambiaron
        if (JSON.stringify(reservas) !== JSON.stringify(nuevasReservas)) {
            reservas = nuevasReservas;
            reservasOriginales = JSON.parse(JSON.stringify(reservas)); // Copia profunda
            reservasFiltradas = []; // Limpiar filtros cuando se cargan nuevas reservas
            console.log('✓ Reservas actualizadas:', reservas.length);
        }
        
        if (JSON.stringify(clientes) !== JSON.stringify(nuevosClientes)) {
            clientes = nuevosClientes;
            console.log('✓ Clientes actualizados:', clientes.length);
        }
        
        if (JSON.stringify(habitaciones) !== JSON.stringify(nuevasHabitaciones)) {
            habitaciones = nuevasHabitaciones;
            console.log('✓ Habitaciones actualizadas:', habitaciones.length);
        }
        
        // Calcular estadísticas
        const totalReservas = reservas.length;
        const confirmadas = reservas.filter(r => r.estado === 'Confirmada').length;
        const pendientes = reservas.filter(r => r.estado === 'Pendiente').length;
        
        // Ocupación hoy
        const hoy = new Date();
        hoy.setHours(0, 0, 0, 0);
        const mañana = new Date(hoy);
        mañana.setDate(mañana.getDate() + 1);
        
        const ocupadasHoy = reservas.filter(r => {
            const entrada = new Date(r.fechaEntrada);
            entrada.setHours(0, 0, 0, 0);
            const salida = new Date(r.fechaSalida);
            salida.setHours(0, 0, 0, 0);
            return entrada <= hoy && salida > hoy && r.estado === 'Confirmada';
        }).length;
        
        const totalHabitaciones = habitaciones.length || 1;
        const ocupacionPorcentaje = Math.round((ocupadasHoy / totalHabitaciones) * 100);
        
        // Ingresos proyectados (reservas confirmadas)
        const ingresosProyectados = confirmadas * 150; // Promedio por noche
        
        // Actualizar tarjetas de resumen
        const totalEl = document.getElementById('totalReservas');
        const confirmadasEl = document.getElementById('reservasConfirmadas');
        const pendientesEl = document.getElementById('reservasPendientes');
        const ocupacionEl = document.getElementById('ocupacionHoy');
        const ingresosEl = document.getElementById('ingresosProyectados');
        
        if (totalEl) totalEl.textContent = totalReservas;
        if (confirmadasEl) confirmadasEl.textContent = confirmadas;
        if (pendientesEl) pendientesEl.textContent = pendientes;
        if (ocupacionEl) ocupacionEl.textContent = ocupacionPorcentaje + '%';
        if (ingresosEl) ingresosEl.textContent = formatearMoneda(ingresosProyectados);
        
        // Llenar select de habitaciones en filtros
        const filtroHabitacion = document.getElementById('filtroHabitacion');
        if (filtroHabitacion && filtroHabitacion.options.length === 1) {
            habitaciones.forEach(h => {
                const option = document.createElement('option');
                option.value = h.id;
                option.textContent = h.idHabitacion + ' - ' + h.tipoHabitacion;
                filtroHabitacion.appendChild(option);
            });
        }
        
        console.log('✓ Reservas cargadas:', { totalReservas, confirmadas, pendientes, ocupacionPorcentaje });
        
        // Llenar selects
        const selectCliente = document.getElementById('clienteReserva');
        if (selectCliente) {
            selectCliente.innerHTML = '<option value="">Seleccione un cliente</option>' +
                clientes.map(c => `<option value="${c.id}">${c.nombre} ${c.apellido} - ${c.documento}</option>`).join('');
        }
        
        const selectHabitacion = document.getElementById('habitacionReserva');
        if (selectHabitacion) {
            selectHabitacion.innerHTML = '<option value="">Seleccione una habitación</option>' +
                habitaciones.map(h => `<option value="${h.id}">${h.idHabitacion} - ${h.tipoHabitacion}</option>`).join('');
        }
        
        renderizarTabla();
    } catch (error) {
        console.error('Error al cargar datos:', error);
    }
}

function renderizarTabla() {
    const tbody = document.getElementById('tablaReservas');
    
    if (!tbody) {
        console.error('ERROR: No se encontró el elemento tablaReservas');
        return;
    }
    
    // Usar reservasFiltradas si hay filtros aplicados, sino usar reservas
    const reservasAMostrar = reservasFiltradas.length > 0 ? reservasFiltradas : reservas;
    
    if (reservasAMostrar.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" class="text-center py-4 text-gray-500"><span class="material-icons-outlined mr-2">inbox</span>No hay reservas registradas</td></tr>';
        return;
    }
    
    console.log('Renderizando', reservasAMostrar.length, 'reservas');
    
    tbody.innerHTML = reservasAMostrar.map(r => {
        const cliente = clientes.find(c => c.id === r.idCliente);
        const habitacion = habitaciones.find(h => h.id === r.habitacion);
        
        // Calcular noches
        const fechaEntrada = new Date(r.fechaEntrada);
        const fechaSalida = new Date(r.fechaSalida);
        const noches = Math.ceil((fechaSalida - fechaEntrada) / (1000 * 60 * 60 * 24));
        
        // Calcular total (noches * precio por noche)
        const precioNoche = habitacion ? habitacion.precioNoche : 0;
        const total = noches * precioNoche;
        
        // Colores por estado
        const estadoBadge = r.estado === 'Confirmada' ? 'bg-green-100 text-green-800 border border-green-300' :
                           r.estado === 'Cancelada' ? 'bg-red-100 text-red-800 border border-red-300' :
                           r.estado === 'Finalizada' ? 'bg-gray-100 text-gray-800 border border-gray-300' :
                           'bg-yellow-100 text-yellow-800 border border-yellow-300';
        
        const estadoIcono = r.estado === 'Confirmada' ? 'check_circle' :
                           r.estado === 'Cancelada' ? 'cancel' :
                           r.estado === 'Finalizada' ? 'done_all' :
                           'schedule';
        
        const estadoIconoColor = r.estado === 'Confirmada' ? 'text-green-600' :
                                r.estado === 'Cancelada' ? 'text-red-600' :
                                r.estado === 'Finalizada' ? 'text-gray-600' :
                                'text-yellow-600';
        
        // Avatar del cliente
        const inicial = cliente ? cliente.nombre.charAt(0).toUpperCase() : '?';
        const coloresAvatar = ['bg-blue-500', 'bg-purple-500', 'bg-pink-500', 'bg-green-500', 'bg-orange-500', 'bg-red-500'];
        const colorAvatar = coloresAvatar[r.id % coloresAvatar.length];
        
        return `
            <tr class="border-b hover:bg-blue-50 transition">
                <td class="px-6 py-4">
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-bold bg-blue-100 text-blue-800">
                        R-${String(r.id).padStart(3, '0')}
                    </span>
                </td>
                <td class="px-6 py-4">
                    <div class="flex items-center space-x-3">
                        <div class="${colorAvatar} w-10 h-10 rounded-full flex items-center justify-center text-white font-bold text-sm">
                            ${inicial}
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-gray-900">${cliente ? cliente.nombre + ' ' + cliente.apellido : 'N/A'}</p>
                            <p class="text-xs text-gray-500">${cliente ? cliente.documento : 'N/A'}</p>
                        </div>
                    </div>
                </td>
                <td class="px-6 py-4">
                    <div class="flex items-center space-x-2">
                        <span class="material-icons-outlined text-blue-600">meeting_room</span>
                        <div>
                            <p class="text-sm font-semibold text-gray-900">${habitacion ? habitacion.idHabitacion : 'N/A'}</p>
                            <p class="text-xs text-gray-500">${habitacion ? habitacion.tipoHabitacion : 'N/A'}</p>
                        </div>
                    </div>
                </td>
                <td class="px-6 py-4">
                    <div class="text-sm">
                        <p class="font-semibold text-gray-900">${formatearFecha(r.fechaEntrada)}</p>
                        <p class="text-xs text-gray-500">Check-in</p>
                    </div>
                </td>
                <td class="px-6 py-4">
                    <div class="text-sm">
                        <p class="font-semibold text-gray-900">${formatearFecha(r.fechaSalida)}</p>
                        <p class="text-xs text-gray-500">Check-out</p>
                    </div>
                </td>
                <td class="px-6 py-4 text-center">
                    <span class="inline-flex items-center justify-center w-8 h-8 rounded-full bg-blue-100 text-blue-800 font-bold text-sm">
                        ${noches}
                    </span>
                </td>
                <td class="px-6 py-4 text-center">
                    <span class="inline-flex items-center space-x-1 px-3 py-1 rounded-full text-xs font-semibold ${estadoBadge}">
                        <span class="material-icons-outlined ${estadoIconoColor} text-sm">${estadoIcono}</span>
                        <span>${r.estado}</span>
                    </span>
                </td>
                <td class="px-6 py-4 text-center">
                    <p class="text-sm font-bold text-green-600">${formatearMoneda(total)}</p>
                </td>
                <td class="px-6 py-4 text-center">
                    <div class="flex justify-center items-center space-x-2">
                        <button onclick="editarReserva(${r.id})" class="text-blue-600 hover:text-blue-800 hover:bg-blue-100 p-2 rounded-lg transition flex items-center justify-center" title="Editar">
                            <span class="material-icons-outlined text-lg">edit</span>
                        </button>
                        <button onclick="eliminarReserva(${r.id})" class="text-red-600 hover:text-red-800 hover:bg-red-100 p-2 rounded-lg transition flex items-center justify-center" title="Eliminar">
                            <span class="material-icons-outlined text-lg">delete</span>
                        </button>
                    </div>
                </td>
            </tr>
        `;
    }).join('');
}

function abrirModalNuevo() {
    console.log('abrirModalNuevo() - Clientes:', clientes.length, 'Habitaciones:', habitaciones.length);
    
    // Validar que haya datos
    if (clientes.length === 0 || habitaciones.length === 0) {
        mostrarNotificacion('Cargando datos... Intenta de nuevo en un momento', 'error');
        return;
    }
    
    document.getElementById('modalTitulo').textContent = 'Nueva Reserva';
    document.getElementById('formReserva').reset();
    document.getElementById('reservaId').value = '';
    document.getElementById('modalReserva').classList.remove('hidden');
}

async function editarReserva(id) {
    try {
        const reserva = await fetchData(`reservas?action=buscar&id=${id}`);
        document.getElementById('modalTitulo').textContent = 'Editar Reserva';
        document.getElementById('reservaId').value = reserva.id;
        document.getElementById('clienteReserva').value = reserva.idCliente;
        document.getElementById('habitacionReserva').value = reserva.habitacion;
        document.getElementById('fechaEntrada').value = reserva.fechaEntrada;
        document.getElementById('fechaSalida').value = reserva.fechaSalida;
        document.getElementById('tipoReserva').value = reserva.tipoReserva;
        document.getElementById('estadoReserva').value = reserva.estado;
        document.getElementById('modalReserva').classList.remove('hidden');
    } catch (error) {
        console.error('Error al cargar reserva:', error);
    }
}

function cerrarModal() {
    document.getElementById('modalReserva').classList.add('hidden');
}

async function guardarReserva(event) {
    event.preventDefault();
    
    const id = document.getElementById('reservaId').value;
    const idCliente = document.getElementById('clienteReserva').value;
    const habitacion = document.getElementById('habitacionReserva').value;
    const fechaEntrada = document.getElementById('fechaEntrada').value;
    const fechaSalida = document.getElementById('fechaSalida').value;
    const tipoReserva = document.getElementById('tipoReserva').value;
    const estado = document.getElementById('estadoReserva').value;
    
    // Validar campos
    if (!idCliente || !habitacion || !fechaEntrada || !fechaSalida || !tipoReserva || !estado) {
        mostrarNotificacion('Por favor completa todos los campos requeridos', 'error');
        console.warn('Campos faltantes:', { idCliente, habitacion, fechaEntrada, fechaSalida, tipoReserva, estado });
        return;
    }
    
    const formData = new URLSearchParams({
        action: id ? 'actualizar' : 'insertar',
        id: id || '',
        idCliente: idCliente,
        habitacion: habitacion,
        fechaEntrada: fechaEntrada,
        fechaSalida: fechaSalida,
        tipoReserva: tipoReserva,
        estado: estado
    });
    
    console.log('Guardando reserva:', Object.fromEntries(formData));
    
    try {
        const response = await fetch('reservas', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        const result = await response.json();
        
        console.log('Respuesta del servidor:', result);
        
        if (result.success) {
            mostrarNotificacion(id ? '✓ Reserva actualizada' : '✓ Reserva creada');
            cerrarModal();
            await cargarDatos();
        } else {
            console.error('Error en respuesta:', result);
            mostrarNotificacion(result.error || 'Error al guardar reserva', 'error');
        }
    } catch (error) {
        console.error('Error al guardar:', error);
        mostrarNotificacion('Error al guardar reserva: ' + error.message, 'error');
    }
}

async function eliminarReserva(id) {
    confirmarEliminacion(async () => {
        try {
            const response = await fetch(`reservas?id=${id}`, { method: 'DELETE' });
            const result = await response.json();
            
            if (result.success) {
                mostrarNotificacion('Reserva eliminada correctamente');
                cargarDatos();
            } else {
                mostrarNotificacion('Error al eliminar reserva', 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            mostrarNotificacion('Error al eliminar reserva', 'error');
        }
    });
}

// Funciones de Filtrado
function aplicarFiltros() {
    const busqueda = document.getElementById('buscarReserva')?.value.toLowerCase() || '';
    const estado = document.getElementById('filtroEstado')?.value || '';
    const fechaEntrada = document.getElementById('filtroFechaEntrada')?.value || '';
    const fechaSalida = document.getElementById('filtroFechaSalida')?.value || '';
    const habitacion = document.getElementById('filtroHabitacion')?.value || '';
    
    reservasFiltradas = reservasOriginales.filter(r => {
        // Filtro búsqueda
        const cliente = clientes.find(c => c.id === r.idCliente);
        const coincideBusqueda = !busqueda || 
            (cliente && (cliente.nombre.toLowerCase().includes(busqueda) || cliente.apellido.toLowerCase().includes(busqueda))) ||
            r.id.toString().includes(busqueda);
        
        // Filtro estado
        const coincideEstado = !estado || r.estado === estado;
        
        // Filtro fecha entrada
        const coincideFechaEntrada = !fechaEntrada || r.fechaEntrada.startsWith(fechaEntrada);
        
        // Filtro fecha salida
        const coincideFechaSalida = !fechaSalida || r.fechaSalida.startsWith(fechaSalida);
        
        // Filtro habitación
        const coincideHabitacion = !habitacion || r.habitacion == habitacion;
        
        return coincideBusqueda && coincideEstado && coincideFechaEntrada && coincideFechaSalida && coincideHabitacion;
    });
    
    renderizarTabla();
}

function limpiarFiltros() {
    document.getElementById('buscarReserva').value = '';
    document.getElementById('filtroEstado').value = '';
    document.getElementById('filtroFechaEntrada').value = '';
    document.getElementById('filtroFechaSalida').value = '';
    document.getElementById('filtroHabitacion').value = '';
    
    reservasFiltradas = [];
    renderizarTabla();
}

function exportarReservas() {
    if (reservasOriginales.length === 0) {
        mostrarNotificacion('No hay reservas para exportar', 'error');
        return;
    }
    
    // Preparar datos
    const reservasAExportar = reservasFiltradas.length > 0 ? reservasFiltradas : reservasOriginales;
    
    // Crear CSV
    const headers = ['ID', 'Cliente', 'Email', 'Habitación', 'Tipo', 'Entrada', 'Salida', 'Noches', 'Estado', 'Total'];
    const rows = reservasAExportar.map(r => {
        const cliente = clientes.find(c => c.id === r.idCliente);
        const habitacion = habitaciones.find(h => h.id === r.habitacion);
        const noches = Math.ceil((new Date(r.fechaSalida) - new Date(r.fechaEntrada)) / (1000 * 60 * 60 * 24));
        
        return [
            r.id,
            cliente ? cliente.nombre + ' ' + cliente.apellido : 'N/A',
            cliente ? cliente.email : 'N/A',
            habitacion ? habitacion.idHabitacion : 'N/A',
            habitacion ? habitacion.tipoHabitacion : 'N/A',
            r.fechaEntrada,
            r.fechaSalida,
            noches,
            r.estado,
            r.total || '0'
        ];
    });
    
    // Crear contenido CSV
    let csv = headers.join(',') + '\n';
    rows.forEach(row => {
        csv += row.map(cell => `"${cell}"`).join(',') + '\n';
    });
    
    // Descargar
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    link.setAttribute('href', url);
    link.setAttribute('download', `reservas_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    mostrarNotificacion('✓ Reservas exportadas correctamente');
}

function filtrarPorPeriodo(periodo) {
    const hoy = new Date();
    hoy.setHours(0, 0, 0, 0);
    
    let fechaInicio, fechaFin;
    
    switch (periodo) {
        case 'hoy':
            fechaInicio = new Date(hoy);
            fechaFin = new Date(hoy);
            fechaFin.setDate(fechaFin.getDate() + 1);
            console.log('Filtro HOY:', fechaInicio, 'a', fechaFin);
            break;
            
        case 'semana':
            // Obtener el primer día de la semana (lunes)
            fechaInicio = new Date(hoy);
            const dia = hoy.getDay();
            const diff = hoy.getDate() - dia + (dia === 0 ? -6 : 1); // Ajuste para lunes
            fechaInicio.setDate(diff);
            
            // Fin de semana (domingo)
            fechaFin = new Date(fechaInicio);
            fechaFin.setDate(fechaFin.getDate() + 7);
            console.log('Filtro SEMANA:', fechaInicio, 'a', fechaFin);
            break;
            
        case 'mes':
            // Primer día del mes actual
            fechaInicio = new Date(hoy.getFullYear(), hoy.getMonth(), 1);
            
            // Primer día del próximo mes
            fechaFin = new Date(hoy.getFullYear(), hoy.getMonth() + 1, 1);
            console.log('Filtro MES:', fechaInicio, 'a', fechaFin);
            break;
    }
    
    reservas = reservasOriginales.filter(r => {
        const fechaEntrada = new Date(r.fechaEntrada);
        fechaEntrada.setHours(0, 0, 0, 0);
        
        const coincide = fechaEntrada >= fechaInicio && fechaEntrada < fechaFin;
        console.log(`Reserva ${r.id}: ${fechaEntrada} - ${coincide ? 'SÍ' : 'NO'}`);
        return coincide;
    });
    
    console.log(`✓ Filtro por ${periodo}:`, reservas.length, 'reservas encontradas');
    renderizarTabla();
}

