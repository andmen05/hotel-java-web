// Gestión de Habitaciones

let habitaciones = [];
let clientes = [];
let checkinsActivos = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('🏨 Habitaciones - Inicializando...');
    
    // Verificar que los elementos existan
    const habitacionesGrid = document.getElementById('habitacionesGrid');
    
    if (!habitacionesGrid) {
        console.error('ERROR: No se encontró el elemento habitacionesGrid');
        return;
    }
    
    console.log('✓ Elementos encontrados, cargando habitaciones...');
    cargarHabitaciones();
    
    // Actualizar grid cards cada 5 segundos
    setInterval(cargarHabitaciones, 5000);
});

async function cargarHabitaciones() {
    try {
        // IMPORTANTE: Cargar habitaciones, check-ins activos Y clientes
        const [habitacionesData, checkinsData, clientesData] = await Promise.all([
            fetchData('habitaciones?action=listar').catch(e => { console.error('Error habitaciones:', e); return []; }),
            fetchData('checkin?action=activos').catch(e => { console.error('Error check-ins activos:', e); return []; }),
            fetchData('clientes?action=listar').catch(e => { console.error('Error clientes:', e); return []; })
        ]);
        
        habitaciones = habitacionesData || [];
        checkinsActivos = checkinsData || [];
        clientes = clientesData || [];
        
        // Obtener IDs de habitaciones con check-in activo
        const habitacionesOcupadasPorCheckin = checkinsActivos.map(c => c.habitacion);
        
        // Calcular estadísticas CORRECTAMENTE
        const disponibles = habitaciones.filter(h => 
            h.estado === 'Disponible' && !habitacionesOcupadasPorCheckin.includes(h.id)
        ).length;
        
        const ocupadas = habitaciones.filter(h => 
            habitacionesOcupadasPorCheckin.includes(h.id) || h.estado === 'Ocupada'
        ).length;
        
        const mantenimiento = habitaciones.filter(h => h.estado === 'Mantenimiento').length;
        
        // Actualizar tarjetas de resumen
        const disponiblesEl = document.getElementById('disponibles');
        const ocupadasEl = document.getElementById('ocupadas');
        const mantenimientoEl = document.getElementById('mantenimiento');
        
        if (disponiblesEl) disponiblesEl.textContent = disponibles;
        if (ocupadasEl) ocupadasEl.textContent = ocupadas;
        if (mantenimientoEl) mantenimientoEl.textContent = mantenimiento;
        
        console.log('✓ Habitaciones - Disponibles: ' + disponibles + ', Ocupadas: ' + ocupadas + ', Mantenimiento: ' + mantenimiento);
        console.log('✓ Check-ins activos: ' + checkinsActivos.length);
        console.log('✓ Clientes cargados: ' + clientes.length);
        
        renderizarTabla();
    } catch (error) {
        console.error('Error al cargar habitaciones:', error);
    }
}

function renderizarTabla() {
    const grid = document.getElementById('habitacionesGrid');
    
    if (!grid) {
        console.error('ERROR: No se encontró el elemento habitacionesGrid en renderizarTabla');
        return;
    }
    
    if (habitaciones.length === 0) {
        grid.innerHTML = `
            <div class="col-span-full text-center py-12">
                <i class="fas fa-inbox text-6xl text-gray-300 mb-4"></i>
                <p class="text-gray-500 text-lg">No hay habitaciones registradas</p>
            </div>
        `;
        return;
    }
    
    grid.innerHTML = habitaciones.map(h => {
        // Obtener check-in activo para esta habitación
        const checkinActivo = checkinsActivos.find(c => c.habitacion === h.id);
        
        // Obtener cliente si está ocupada
        let huespedInfo = 'Disponible';
        if (checkinActivo) {
            const cliente = clientes.find(c => c.id === checkinActivo.idCliente);
            huespedInfo = cliente ? `👤 ${cliente.nombre} ${cliente.apellido}` : `👤 Huésped ${checkinActivo.idCliente}`;
        }
        
        // Determinar estado basado en check-in activo
        const tieneCheckinActivo = checkinsActivos.some(c => c.habitacion === h.id);
        const estado = tieneCheckinActivo ? 'Ocupada' : h.estado;
        
        // Determinar color según estado
        const borderColor = estado === 'Disponible' ? 'border-4 border-green-500' :
                           estado === 'Ocupada' ? 'border-4 border-red-500' :
                           'border-4 border-orange-500';
        
        const bgColor = estado === 'Disponible' ? 'bg-green-50' :
                       estado === 'Ocupada' ? 'bg-red-50' :
                       'bg-orange-50';
        
        const textColor = estado === 'Disponible' ? 'text-green-700' :
                         estado === 'Ocupada' ? 'text-red-700' :
                         'text-orange-700';
        
        return `
            <div class="rounded-lg p-6 text-center transition hover:shadow-lg ${borderColor} ${bgColor}">
                <h3 class="text-3xl font-bold ${textColor} mb-2">Hab. ${h.idHabitacion}</h3>
                <p class="text-sm text-gray-600 mb-3">${h.tipoHabitacion}</p>
                
                <div class="mb-4 p-3 bg-white rounded-lg border ${estado === 'Disponible' ? 'border-green-200' : 'border-red-200'}">
                    <p class="text-xs text-gray-500 mb-1">Huésped:</p>
                    <p class="text-lg font-bold ${textColor}">${huespedInfo}</p>
                </div>
                
                <p class="text-xs text-gray-600 mb-2">${formatearMoneda(h.precioNoche)}/noche • ${h.capacidad} pax</p>
                
                <div class="flex space-x-2">
                    <button onclick="editarHabitacion(${h.id})" class="flex-1 px-2 py-1 bg-blue-500 hover:bg-blue-600 text-white rounded text-xs transition">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button onclick="eliminarHabitacion(${h.id})" class="flex-1 px-2 py-1 bg-red-500 hover:bg-red-600 text-white rounded text-xs transition">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
        `;
    }).join('');
}

function abrirModalNuevo() {
    document.getElementById('modalTitulo').textContent = 'Nueva Habitación';
    document.getElementById('formHabitacion').reset();
    document.getElementById('habitacionId').value = '';
    document.getElementById('modalHabitacion').classList.remove('hidden');
}

async function editarHabitacion(id) {
    try {
        const habitacion = await fetchData(`habitaciones?action=buscar&id=${id}`);
        document.getElementById('modalTitulo').textContent = 'Editar Habitación';
        document.getElementById('habitacionId').value = habitacion.id;
        document.getElementById('idHabitacion').value = habitacion.idHabitacion;
        document.getElementById('tipoHabitacion').value = habitacion.tipoHabitacion;
        document.getElementById('estado').value = habitacion.estado;
        document.getElementById('precioNoche').value = habitacion.precioNoche;
        document.getElementById('capacidad').value = habitacion.capacidad;
        document.getElementById('modalHabitacion').classList.remove('hidden');
    } catch (error) {
        console.error('Error al cargar habitación:', error);
    }
}

function cerrarModal() {
    document.getElementById('modalHabitacion').classList.add('hidden');
}

async function guardarHabitacion(event) {
    event.preventDefault();
    
    const id = document.getElementById('habitacionId').value;
    const formData = new URLSearchParams({
        action: id ? 'actualizar' : 'insertar',
        id: id || '',
        idHabitacion: document.getElementById('idHabitacion').value,
        tipoHabitacion: document.getElementById('tipoHabitacion').value,
        estado: document.getElementById('estado').value,
        precioNoche: document.getElementById('precioNoche').value,
        capacidad: document.getElementById('capacidad').value,
        idCliente: ''
    });
    
    try {
        const response = await fetch('habitaciones', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        const result = await response.json();
        
        if (result.success) {
            mostrarNotificacion(id ? 'Habitación actualizada correctamente' : 'Habitación creada correctamente');
            cerrarModal();
            cargarHabitaciones();
        } else {
            mostrarNotificacion('Error al guardar habitación', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        mostrarNotificacion('Error al guardar habitación', 'error');
    }
}

async function eliminarHabitacion(id) {
    confirmarEliminacion(async () => {
        try {
            const response = await fetch(`habitaciones?id=${id}`, { method: 'DELETE' });
            const result = await response.json();
            
            if (result.success) {
                mostrarNotificacion('Habitación eliminada correctamente');
                cargarHabitaciones();
            } else {
                mostrarNotificacion('Error al eliminar habitación', 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            mostrarNotificacion('Error al eliminar habitación', 'error');
        }
    });
}

