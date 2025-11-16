// Gestión de Habitaciones

let habitaciones = [];
let habitacionesFiltradas = [];
let checkinsActivos = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('🏨 Habitaciones - Inicializando...');
    cargarDatos();
    
    // Event listeners para filtros
    document.getElementById('buscarHabitacion')?.addEventListener('input', aplicarFiltros);
    document.getElementById('filtroTipo')?.addEventListener('change', aplicarFiltros);
    document.getElementById('filtroEstado')?.addEventListener('change', aplicarFiltros);
    document.getElementById('filtroRango')?.addEventListener('input', (e) => {
        document.getElementById('rangoValor').textContent = e.target.value;
        aplicarFiltros();
    });
    
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
        
        const [habitacionesData, clientesData] = await Promise.all([
            fetchData('habitaciones?action=listar').catch(e => { console.error('Error habitaciones:', e); return []; }),
            fetchData('clientes?action=listar').catch(e => { console.error('Error clientes:', e); return []; })
        ]);
        
        habitaciones = habitacionesData || [];
        
        // Intentar cargar check-ins, pero si falla, usar array vacío (sin mostrar error)
        try {
            const response = await fetch('checkins?action=listar');
            if (response.ok) {
                checkinsActivos = await response.json() || [];
            } else {
                checkinsActivos = [];
            }
        } catch (e) {
            checkinsActivos = [];
        }
        
        console.log('✓ Datos obtenidos:', { habitacionesCount: habitaciones.length, checkinsCount: checkinsActivos.length });
        
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
        
        // Ingresos proyectados (ocupadas * precio promedio)
        const precioPromedio = habitaciones.length > 0 
            ? habitaciones.reduce((sum, h) => sum + (h.precioNoche || 0), 0) / habitaciones.length 
            : 0;
        const ingresosProyectados = ocupadas * precioPromedio * 30;
        
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
        
        // Limpiar filtros y renderizar
        habitacionesFiltradas = [];
        aplicarFiltros();
    } catch (error) {
        console.error('Error al cargar datos:', error);
    }
}

function aplicarFiltros() {
    const busqueda = document.getElementById('buscarHabitacion')?.value.toLowerCase() || '';
    const tipo = document.getElementById('filtroTipo')?.value || '';
    const estado = document.getElementById('filtroEstado')?.value || '';
    const rango = parseInt(document.getElementById('filtroRango')?.value || '500');
    
    habitacionesFiltradas = habitaciones.filter(h => {
        // Filtro búsqueda
        const coincideBusqueda = !busqueda || 
            h.idHabitacion.toString().includes(busqueda) ||
            h.tipoHabitacion.toLowerCase().includes(busqueda);
        
        // Filtro tipo
        const coincideTipo = !tipo || h.tipoHabitacion === tipo;
        
        // Filtro estado
        let coincideEstado = true;
        if (estado) {
            const tieneCheckinActivo = checkinsActivos.some(c => c.habitacion === h.id);
            const estadoReal = tieneCheckinActivo ? 'Ocupada' : h.estado;
            coincideEstado = estadoReal === estado;
        }
        
        // Filtro rango precio
        const coincideRango = h.precioNoche <= rango;
        
        return coincideBusqueda && coincideTipo && coincideEstado && coincideRango;
    });
    
    renderizarTabla();
}

function renderizarTabla() {
    const tbody = document.getElementById('tablaHabitaciones');
    
    if (!tbody) {
        console.error('ERROR: No se encontró tablaHabitaciones');
        return;
    }
    
    const habitacionesAMostrar = habitacionesFiltradas.length > 0 ? habitacionesFiltradas : habitaciones;
    
    if (habitacionesAMostrar.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center py-8 text-gray-500"><span class="material-icons-outlined text-4xl">inbox</span><p class="mt-2">No hay habitaciones</p></td></tr>';
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
