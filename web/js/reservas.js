// Gestión de Reservas

let reservas = [];
let reservasOriginales = [];
let clientes = [];
let habitaciones = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('📅 Reservas - Inicializando...');
    cargarDatos();
    
    // Actualizar grid cards cada 5 segundos
    setInterval(cargarDatos, 5000);
});

async function cargarDatos() {
    try {
        [reservas, clientes, habitaciones] = await Promise.all([
            fetchData('reservas?action=listar'),
            fetchData('clientes?action=listar'),
            fetchData('habitaciones?action=listar')
        ]);
        
        reservas = reservas || [];
        reservasOriginales = JSON.parse(JSON.stringify(reservas)); // Copia profunda
        clientes = clientes || [];
        habitaciones = habitaciones || [];
        
        // Calcular estadísticas
        const totalReservas = reservas.length;
        const confirmadas = reservas.filter(r => r.estado === 'Confirmada').length;
        const canceladas = reservas.filter(r => r.estado === 'Cancelada').length;
        const finalizadas = reservas.filter(r => r.estado === 'Finalizada').length;
        
        // Actualizar tarjetas de resumen si existen
        const totalEl = document.getElementById('totalReservas');
        const confirmadasEl = document.getElementById('reservasConfirmadas');
        const canceladasEl = document.getElementById('reservasCanceladas');
        const finalizadasEl = document.getElementById('reservasFinalizadas');
        
        if (totalEl) totalEl.textContent = totalReservas;
        if (confirmadasEl) confirmadasEl.textContent = confirmadas;
        if (canceladasEl) canceladasEl.textContent = canceladas;
        if (finalizadasEl) finalizadasEl.textContent = finalizadas;
        
        console.log('Reservas cargadas:', { totalReservas, confirmadas, canceladas, finalizadas });
        
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
    
    if (reservas.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center py-4 text-gray-500"><i class="fas fa-inbox mr-2"></i>No hay reservas registradas</td></tr>';
        return;
    }
    
    console.log('Renderizando', reservas.length, 'reservas');
    
    tbody.innerHTML = reservas.map(r => {
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
        
        const estadoIcono = r.estado === 'Confirmada' ? 'fa-check-circle text-green-600' :
                           r.estado === 'Cancelada' ? 'fa-times-circle text-red-600' :
                           r.estado === 'Finalizada' ? 'fa-check-double text-gray-600' :
                           'fa-clock text-yellow-600';
        
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
                        <i class="fas fa-door-open text-blue-600"></i>
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
                        <i class="fas ${estadoIcono}"></i>
                        <span>${r.estado}</span>
                    </span>
                </td>
                <td class="px-6 py-4 text-center">
                    <p class="text-sm font-bold text-green-600">${formatearMoneda(total)}</p>
                </td>
                <td class="px-6 py-4 text-center">
                    <div class="flex justify-center space-x-2">
                        <button onclick="editarReserva(${r.id})" class="text-blue-600 hover:text-blue-800 hover:bg-blue-100 p-2 rounded-lg transition" title="Editar">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button onclick="eliminarReserva(${r.id})" class="text-red-600 hover:text-red-800 hover:bg-red-100 p-2 rounded-lg transition" title="Eliminar">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </td>
            </tr>
        `;
    }).join('');
}

function abrirModalNuevo() {
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
    const formData = new URLSearchParams({
        action: id ? 'actualizar' : 'insertar',
        id: id || '',
        idCliente: document.getElementById('clienteReserva').value,
        habitacion: document.getElementById('habitacionReserva').value,
        fechaEntrada: document.getElementById('fechaEntrada').value,
        fechaSalida: document.getElementById('fechaSalida').value,
        tipoReserva: document.getElementById('tipoReserva').value,
        estado: document.getElementById('estadoReserva').value
    });
    
    try {
        const response = await fetch('reservas', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        const result = await response.json();
        
        if (result.success) {
            mostrarNotificacion(id ? 'Reserva actualizada correctamente' : 'Reserva creada correctamente');
            cerrarModal();
            cargarDatos();
        } else {
            mostrarNotificacion('Error al guardar reserva', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        mostrarNotificacion('Error al guardar reserva', 'error');
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
    const estado = document.getElementById('filtroEstado').value;
    const fechaEntrada = document.getElementById('filtroFechaEntrada').value;
    const fechaSalida = document.getElementById('filtroFechaSalida').value;
    const busqueda = document.getElementById('filtroBusqueda').value.toLowerCase();
    
    console.log('Aplicando filtros:', { estado, fechaEntrada, fechaSalida, busqueda });
    
    reservas = reservasOriginales.filter(r => {
        // Filtro por estado
        if (estado && r.estado !== estado) {
            return false;
        }
        
        // Filtro por fecha de entrada
        if (fechaEntrada) {
            const fechaR = new Date(r.fechaEntrada).toISOString().split('T')[0];
            if (fechaR !== fechaEntrada) {
                return false;
            }
        }
        
        // Filtro por fecha de salida
        if (fechaSalida) {
            const fechaR = new Date(r.fechaSalida).toISOString().split('T')[0];
            if (fechaR !== fechaSalida) {
                return false;
            }
        }
        
        // Filtro por búsqueda (cliente, habitación, ID)
        if (busqueda) {
            const cliente = clientes.find(c => c.id === r.idCliente);
            const habitacion = habitaciones.find(h => h.id === r.habitacion);
            
            const clienteNombre = cliente ? (cliente.nombre + ' ' + cliente.apellido).toLowerCase() : '';
            const habitacionId = habitacion ? habitacion.idHabitacion.toString() : '';
            const reservaId = r.id.toString();
            
            if (!clienteNombre.includes(busqueda) && 
                !habitacionId.includes(busqueda) && 
                !reservaId.includes(busqueda)) {
                return false;
            }
        }
        
        return true;
    });
    
    console.log('Reservas filtradas:', reservas.length);
    renderizarTabla();
}

function limpiarFiltros() {
    document.getElementById('filtroEstado').value = '';
    document.getElementById('filtroFechaEntrada').value = '';
    document.getElementById('filtroFechaSalida').value = '';
    document.getElementById('filtroBusqueda').value = '';
    
    reservas = JSON.parse(JSON.stringify(reservasOriginales));
    console.log('Filtros limpios, mostrando todas las reservas');
    renderizarTabla();
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

