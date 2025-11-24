// Gestión de Habitaciones

let habitaciones = [];
let habitacionesFiltradas = [];
let checkinsActivos = [];
let reservas = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('🏨 Habitaciones - Inicializando...');
    cargarDatos();
    
    // Event listeners para filtros
    const buscarInput = document.getElementById('buscarHabitacion');
    const filtroTipo = document.getElementById('filtroTipo');
    const filtroEstado = document.getElementById('filtroEstado');
    
    if (buscarInput) {
        buscarInput.addEventListener('input', () => {
            console.log('Búsqueda activada:', buscarInput.value);
            aplicarFiltros();
        });
        
        buscarInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                aplicarFiltros();
            }
        });
    }
    
    if (filtroTipo) {
        filtroTipo.addEventListener('change', () => {
            console.log('Filtro de tipo cambiado:', filtroTipo.value);
            aplicarFiltros();
        });
    }
    
    if (filtroEstado) {
        filtroEstado.addEventListener('change', () => {
            console.log('Filtro de estado cambiado:', filtroEstado.value);
            aplicarFiltros();
        });
    }
    
    // Actualizar cada 5 segundos
    setInterval(cargarDatos, 5000);
});

async function cargarDatos() {
    try {
        // No recargar si el modal está abierto
        const modalAbierto = !document.getElementById('modalHabitacion')?.classList.contains('hidden');
        if (modalAbierto) {
            console.log('Modal abierto, saltando recarga de datos');
            return;
        }
        
        console.log('Iniciando carga de datos de habitaciones...');
        
        const [habitacionesData, reservasData] = await Promise.all([
            fetchData('habitaciones?action=listar').catch(e => { console.error('Error habitaciones:', e); return []; }),
            fetchData('reservas?action=listar').catch(e => { console.error('Error reservas:', e); return []; })
        ]);
        
        habitaciones = habitacionesData || [];
        reservas = reservasData || [];
        
        // Intentar cargar check-ins activos
        try {
            checkinsActivos = await fetchData('checkin?action=activos') || [];
        } catch (e) {
            console.warn('⚠️ No se pudieron cargar check-ins activos:', e.message);
            checkinsActivos = [];
        }
        
        console.log('✓ Datos obtenidos:', { 
            habitacionesCount: habitaciones.length, 
            checkinsCount: checkinsActivos.length,
            reservasCount: reservas.length 
        });
        
        // Obtener IDs de habitaciones con check-in activo
        const habitacionesOcupadasPorCheckin = checkinsActivos.map(c => c.habitacion);
        
        // Calcular estadísticas
        const total = habitaciones.length;
        const disponibles = habitaciones.filter(h => 
            h.estado === 'Disponible' && !habitacionesOcupadasPorCheckin.includes(h.id)
        ).length;
        
        const ocupadas = habitaciones.filter(h => 
            habitacionesOcupadasPorCheckin.includes(h.id) || h.estado === 'Ocupada'
        ).length;
        
        const mantenimiento = habitaciones.filter(h => h.estado === 'Mantenimiento').length;
        
        // Ingresos proyectados - calcular basándose en reservas confirmadas del mes actual
        const hoy = new Date();
        hoy.setHours(0, 0, 0, 0);
        const inicioMes = new Date(hoy.getFullYear(), hoy.getMonth(), 1);
        const finMes = new Date(hoy.getFullYear(), hoy.getMonth() + 1, 0);
        
        const reservasDelMes = reservas.filter(r => {
            if (r.estado !== 'Finalizada') return false;
            const fechaEntrada = new Date(r.fechaEntrada);
            fechaEntrada.setHours(0, 0, 0, 0);
            return fechaEntrada >= inicioMes && fechaEntrada <= finMes;
        });
        
        const ingresosProyectados = reservasDelMes.reduce((sum, r) => {
            const habitacion = habitaciones.find(h => h.id === r.habitacion);
            if (!habitacion) return sum;
            
            const fechaEntrada = new Date(r.fechaEntrada);
            const fechaSalida = new Date(r.fechaSalida);
            const noches = Math.ceil((fechaSalida - fechaEntrada) / (1000 * 60 * 60 * 24));
            const precioNoche = habitacion.precioNoche || 0;
            const totalReserva = noches * precioNoche;
            
            return sum + totalReserva;
        }, 0);
        
        // Actualizar tarjetas de resumen
        const disponiblesEl = document.getElementById('disponibles');
        const ocupadasEl = document.getElementById('ocupadas');
        const mantenimientoEl = document.getElementById('mantenimiento');
        
        if (disponiblesEl) disponiblesEl.textContent = disponibles;
        if (ocupadasEl) ocupadasEl.textContent = ocupadas;
        if (mantenimientoEl) mantenimientoEl.textContent = mantenimiento;
        
        // Actualizar KPI
        const totalEl = document.getElementById('totalHabitaciones');
        const ingresosEl = document.getElementById('ingresosProyectados');
        
        if (totalEl) totalEl.textContent = total;
        if (ingresosEl) ingresosEl.textContent = formatearMoneda(ingresosProyectados);
        
        console.log('✓ KPI actualizados:', { total, disponibles, ocupadas, mantenimiento, ingresosProyectados });
        
        // Aplicar filtros actuales (o mostrar todos si no hay filtros)
        aplicarFiltros();
    } catch (error) {
        console.error('Error al cargar datos:', error);
    }
}

function aplicarFiltros() {
    console.log('aplicarFiltros() llamado');
    console.log('habitaciones disponibles:', habitaciones.length);
    
    if (habitaciones.length === 0) {
        console.warn('No hay habitaciones para filtrar');
        const tbody = document.getElementById('tablaHabitaciones');
        if (tbody) {
            tbody.innerHTML = '<tr><td colspan="6" class="text-center py-8 text-gray-500"><span class="material-icons-outlined text-4xl block mb-2">inbox</span><p class="mt-2">Cargando habitaciones...</p></td></tr>';
        }
        return;
    }
    
    const buscarInput = document.getElementById('buscarHabitacion');
    const filtroTipoSelect = document.getElementById('filtroTipo');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    
    if (!buscarInput) {
        console.error('ERROR: No se encontró el campo buscarHabitacion');
        return;
    }
    
    const busqueda = buscarInput.value ? buscarInput.value.trim().toLowerCase() : '';
    const tipo = filtroTipoSelect ? filtroTipoSelect.value : '';
    const estado = filtroEstadoSelect ? filtroEstadoSelect.value : '';
    
    console.log('Filtros aplicados:', { busqueda, tipo, estado, habitacionesCount: habitaciones.length });
    
    habitacionesFiltradas = habitaciones.filter(h => {
        // Filtro búsqueda - busca en ID, tipo, precio y capacidad
        let coincideBusqueda = true;
        if (busqueda && busqueda.length > 0) {
            const idHabitacion = (h.idHabitacion || '').toString().toLowerCase();
            const tipoHabitacion = (h.tipoHabitacion || '').toString().toLowerCase();
            const precio = String(h.precioNoche || 0).toLowerCase();
            const capacidad = String(h.capacidad || 0).toLowerCase();
            
            coincideBusqueda = 
                idHabitacion.includes(busqueda) ||
                tipoHabitacion.includes(busqueda) ||
                precio.includes(busqueda) ||
                capacidad.includes(busqueda);
        }
        
        // Filtro tipo
        const coincideTipo = !tipo || h.tipoHabitacion === tipo;
        
        // Filtro estado - considerar check-ins activos
        let coincideEstado = true;
        if (estado) {
            const tieneCheckinActivo = checkinsActivos.some(c => c.habitacion === h.id);
            const estadoReal = tieneCheckinActivo ? 'Ocupada' : h.estado;
            coincideEstado = estadoReal === estado;
        }
        
        return coincideBusqueda && coincideTipo && coincideEstado;
    });
    
    console.log('Habitaciones filtradas:', habitacionesFiltradas.length, 'de', habitaciones.length);
    renderizarTabla();
}

function renderizarTabla() {
    const tbody = document.getElementById('tablaHabitaciones');
    
    if (!tbody) {
        console.error('ERROR: No se encontró tablaHabitaciones');
        return;
    }
    
    // Verificar si hay filtros activos
    const buscarInput = document.getElementById('buscarHabitacion');
    const filtroTipoSelect = document.getElementById('filtroTipo');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    const hayFiltrosActivos = (buscarInput?.value?.trim() || '') !== '' ||
                              (filtroTipoSelect?.value || '') !== '' ||
                              (filtroEstadoSelect?.value || '') !== '';
    
    // Si hay filtros activos, usar habitacionesFiltradas (aunque esté vacío)
    // Si no hay filtros, usar todas las habitaciones
    const habitacionesAMostrar = hayFiltrosActivos ? habitacionesFiltradas : habitaciones;
    
    console.log('renderizarTabla() - habitacionesAMostrar:', habitacionesAMostrar.length);
    
    if (habitacionesAMostrar.length === 0) {
        const mensaje = hayFiltrosActivos 
            ? 'No se encontraron habitaciones con los filtros aplicados'
            : 'No hay habitaciones registradas';
        
        tbody.innerHTML = `<tr><td colspan="6" class="text-center py-8 text-gray-500">
            <span class="material-icons-outlined text-4xl block mb-2">inbox</span>
            <p class="mt-2">${mensaje}</p>
            ${hayFiltrosActivos ? '<button onclick="limpiarFiltros()" class="mt-4 px-4 py-2 bg-primary text-white rounded-lg hover:bg-indigo-700 transition text-sm">Limpiar Filtros</button>' : ''}
        </td></tr>`;
        return;
    }
    
    tbody.innerHTML = habitacionesAMostrar.map(h => {
        // Determinar estado basado en check-in activo
        const tieneCheckinActivo = checkinsActivos.some(c => c.habitacion === h.id);
        const estadoReal = tieneCheckinActivo ? 'Ocupada' : h.estado;
        
        // Badge de estado
        let estadoBadge = 'bg-green-100 text-green-800';
        if (estadoReal === 'Ocupada') {
            estadoBadge = 'bg-red-100 text-red-800';
        } else if (estadoReal === 'Mantenimiento') {
            estadoBadge = 'bg-orange-100 text-orange-800';
        } else if (estadoReal === 'Limpieza') {
            estadoBadge = 'bg-yellow-100 text-yellow-800';
        }
        
        return `
            <tr class="border-b hover:bg-gray-50 transition">
                <td class="px-4 py-3 text-sm font-semibold text-gray-900">${h.idHabitacion}</td>
                <td class="px-4 py-3 text-sm text-gray-700">${h.tipoHabitacion}</td>
                <td class="px-4 py-3 text-sm">
                    <span class="px-2 py-1 rounded text-xs font-semibold ${estadoBadge}">${estadoReal}</span>
                </td>
                <td class="px-4 py-3 text-sm text-center text-gray-700">${h.capacidad} pax</td>
                <td class="px-4 py-3 text-sm font-semibold text-green-600">${formatearMoneda(h.precioNoche)}</td>
                <td class="px-4 py-3 text-center space-x-1">
                    <button onclick="editarHabitacion(${h.id})" class="text-blue-600 hover:text-blue-800 p-1 rounded transition" title="Editar">
                        <span class="material-icons-outlined text-lg">edit</span>
                    </button>
                    <button onclick="eliminarHabitacion(${h.id})" class="text-red-600 hover:text-red-800 p-1 rounded transition" title="Eliminar">
                        <span class="material-icons-outlined text-lg">delete</span>
                    </button>
                </td>
            </tr>
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
            mostrarNotificacion(id ? '✓ Habitación actualizada' : '✓ Habitación creada');
            cerrarModal();
            await cargarDatos();
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
                mostrarNotificacion('✓ Habitación eliminada');
                await cargarDatos();
            } else {
                mostrarNotificacion('Error al eliminar habitación', 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            mostrarNotificacion('Error al eliminar habitación', 'error');
        }
    });
}

function exportarHabitaciones() {
    if (habitaciones.length === 0) {
        mostrarNotificacion('No hay habitaciones para exportar', 'error');
        return;
    }
    
    // Preparar datos
    const habitacionesAExportar = habitacionesFiltradas.length > 0 ? habitacionesFiltradas : habitaciones;
    
    // Crear CSV
    const headers = ['ID', 'Tipo', 'Estado', 'Capacidad', 'Precio/Noche'];
    const rows = habitacionesAExportar.map(h => {
        const tieneCheckinActivo = checkinsActivos.some(c => c.habitacion === h.id);
        const estadoReal = tieneCheckinActivo ? 'Ocupada' : h.estado;
        
        return [
            h.idHabitacion,
            h.tipoHabitacion,
            estadoReal,
            h.capacidad,
            h.precioNoche.toFixed(2)
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
    link.setAttribute('download', `habitaciones_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    mostrarNotificacion('✓ Habitaciones exportadas correctamente');
}

function limpiarFiltros() {
    console.log('limpiarFiltros() llamado');
    
    const buscarInput = document.getElementById('buscarHabitacion');
    const filtroTipoSelect = document.getElementById('filtroTipo');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    
    if (buscarInput) {
        buscarInput.value = '';
    }
    if (filtroTipoSelect) {
        filtroTipoSelect.value = '';
    }
    if (filtroEstadoSelect) {
        filtroEstadoSelect.value = '';
    }
    
    habitacionesFiltradas = [];
    aplicarFiltros();
    
    mostrarNotificacion('Filtros limpiados');
}
