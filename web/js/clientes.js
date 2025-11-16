// Gestión de Clientes

let clientes = [];
let clientesFiltrados = [];
let reservas = [];
let habitaciones = [];

// Cargar clientes al iniciar
document.addEventListener('DOMContentLoaded', () => {
    console.log('👥 Clientes - Inicializando...');
    cargarDatos();
    
    // Event listeners para filtros - con delay para mejor rendimiento
    const buscarInput = document.getElementById('buscarCliente');
    const filtroEstado = document.getElementById('filtroEstado');
    
    if (buscarInput) {
        // Búsqueda en tiempo real mientras escribes
        buscarInput.addEventListener('input', (e) => {
            console.log('Búsqueda activada:', e.target.value);
            aplicarFiltros();
        });
        
        // También aplicar filtros al hacer Enter o perder el foco
        buscarInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                aplicarFiltros();
            }
        });
        
        buscarInput.addEventListener('blur', () => {
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
        const modalAbierto = !document.getElementById('modalCliente')?.classList.contains('hidden');
        if (modalAbierto) {
            console.log('Modal abierto, saltando recarga de datos');
            return;
        }
        
        console.log('Iniciando carga de datos de clientes...');
        
        const [clientesData, reservasData, habitacionesData] = await Promise.all([
            fetchData('clientes?action=listar').catch(e => { console.error('Error clientes:', e); return []; }),
            fetchData('reservas?action=listar').catch(e => { console.error('Error reservas:', e); return []; }),
            fetchData('habitaciones?action=listar').catch(e => { console.error('Error habitaciones:', e); return []; })
        ]);
        
        clientes = clientesData || [];
        reservas = reservasData || [];
        habitaciones = habitacionesData || [];
        
        console.log('✓ Datos obtenidos del servidor:', { 
            clientesCount: clientes.length, 
            reservasCount: reservas.length,
            habitacionesCount: habitaciones.length 
        });
        
        // Calcular estadísticas
        const totalClientes = clientes.length;
        
        // Clientes activos (con reservas confirmadas)
        const clientesActivos = new Set(
            reservas.filter(r => r.estado === 'Confirmada').map(r => r.idCliente)
        ).size;
        
        // Nuevos este mes - como no tenemos created_at en el modelo, 
        // contamos todos los clientes (o podemos cambiarlo a otra métrica)
        // Por ahora, contamos clientes que tienen reservas en el último mes
        const hoy = new Date();
        hoy.setHours(0, 0, 0, 0);
        const hace30Dias = new Date(hoy);
        hace30Dias.setDate(hace30Dias.getDate() - 30);
        
        const clientesConReservasRecientes = new Set(
            reservas.filter(r => {
                if (r.estado !== 'Confirmada') return false;
                const fechaEntrada = new Date(r.fechaEntrada);
                fechaEntrada.setHours(0, 0, 0, 0);
                return fechaEntrada >= hace30Dias && fechaEntrada <= hoy;
            }).map(r => r.idCliente)
        ).size;
        
        // Usar clientes con reservas recientes como "nuevos este mes"
        const clientesNuevos = clientesConReservasRecientes;
        
        // Ingresos totales - calcular basándose en noches * precio_noche
        const ingresosTotales = reservas
            .filter(r => r.estado === 'Confirmada')
            .reduce((sum, r) => {
                const habitacion = habitaciones.find(h => h.id === r.habitacion);
                if (!habitacion) return sum;
                
                const fechaEntrada = new Date(r.fechaEntrada);
                const fechaSalida = new Date(r.fechaSalida);
                const noches = Math.ceil((fechaSalida - fechaEntrada) / (1000 * 60 * 60 * 24));
                const precioNoche = habitacion.precioNoche || 0;
                const totalReserva = noches * precioNoche;
                
                return sum + totalReserva;
            }, 0);
        
        // Actualizar KPI
        const totalEl = document.getElementById('totalClientes');
        const activosEl = document.getElementById('clientesActivos');
        const nuevosEl = document.getElementById('clientesNuevos');
        const ingresosEl = document.getElementById('ingresosTotales');
        
        if (totalEl) totalEl.textContent = totalClientes;
        if (activosEl) activosEl.textContent = clientesActivos;
        if (nuevosEl) nuevosEl.textContent = clientesNuevos;
        if (ingresosEl) ingresosEl.textContent = formatearMoneda(ingresosTotales);
        
        console.log('✓ KPI actualizados:', { totalClientes, clientesActivos, clientesNuevos, ingresosTotales });
        
        // Aplicar filtros actuales (o mostrar todos si no hay filtros)
        // Preservar el valor de búsqueda si existe
        console.log('Aplicando filtros y renderizando tabla...');
        aplicarFiltros();
    } catch (error) {
        console.error('Error al cargar datos:', error);
        mostrarNotificacion('Error al cargar clientes', 'error');
    }
}

function aplicarFiltros() {
    console.log('aplicarFiltros() llamado');
    console.log('clientes disponibles:', clientes.length);
    
    if (clientes.length === 0) {
        console.warn('No hay clientes para filtrar');
        const tbody = document.getElementById('tablaClientes');
        if (tbody) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center py-8 text-gray-500"><span class="material-icons-outlined text-4xl block mb-2">inbox</span><p class="mt-2">Cargando clientes...</p></td></tr>';
        }
        return;
    }
    
    const buscarInput = document.getElementById('buscarCliente');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    
    if (!buscarInput) {
        console.error('ERROR: No se encontró el campo buscarCliente');
        return;
    }
    
    const busqueda = buscarInput.value ? buscarInput.value.trim().toLowerCase() : '';
    const estado = filtroEstadoSelect ? filtroEstadoSelect.value : '';
    
    console.log('Filtros aplicados:', { busqueda, estado, clientesCount: clientes.length });
    
    clientesFiltrados = clientes.filter(c => {
        // Filtro búsqueda - busca en nombre, apellido, documento, correo y teléfono
        let coincideBusqueda = true;
        if (busqueda && busqueda.length > 0) {
            // Normalizar y obtener valores de cada campo
            const nombre = (c.nombre || '').toString().toLowerCase().trim();
            const apellido = (c.apellido || '').toString().toLowerCase().trim();
            const nombreCompleto = (nombre + ' ' + apellido).trim();
            const documento = c.documento ? String(c.documento) : '';
            const correo = (c.correo || '').toString().toLowerCase().trim();
            const telefono = (c.telefono || '').toString().toLowerCase().trim();
            
            // Buscar en todos los campos (documento sin toLowerCase porque es numérico)
            coincideBusqueda = 
                nombre.includes(busqueda) ||
                apellido.includes(busqueda) ||
                nombreCompleto.includes(busqueda) ||
                documento.includes(busqueda) ||
                correo.includes(busqueda) ||
                telefono.includes(busqueda);
            
            // Log para debugging
            if (!coincideBusqueda) {
                console.log(`Cliente ${c.id} no coincide:`, {
                    nombre, apellido, documento, correo, telefono, busqueda
                });
            }
        }
        
        // Filtro estado - Activo = tiene reservas confirmadas, Inactivo = no tiene reservas confirmadas
        let coincideEstado = true;
        if (estado === 'Activo') {
            const tieneReservaActiva = reservas.some(r => 
                r.idCliente === c.id && r.estado === 'Confirmada'
            );
            coincideEstado = tieneReservaActiva;
        } else if (estado === 'Inactivo') {
            const tieneReservaActiva = reservas.some(r => 
                r.idCliente === c.id && r.estado === 'Confirmada'
            );
            coincideEstado = !tieneReservaActiva;
        }
        
        return coincideBusqueda && coincideEstado;
    });
    
    console.log('Clientes filtrados:', clientesFiltrados.length, 'de', clientes.length);
    renderizarTabla();
}


function abrirModalNuevo() {
    console.log('abrirModalNuevo() llamado');
    const form = document.getElementById('formCliente');
    const modal = document.getElementById('modalCliente');
    
    if (!form) {
        console.error('ERROR: No se encontró formCliente');
        return;
    }
    if (!modal) {
        console.error('ERROR: No se encontró modalCliente');
        return;
    }
    
    document.getElementById('modalTitulo').textContent = 'Nuevo Cliente';
    form.reset();
    document.getElementById('clienteId').value = '';
    modal.classList.remove('hidden');
    console.log('Modal abierto');
}

async function editarCliente(id) {
    try {
        const cliente = await fetchData(`clientes?action=buscar&id=${id}`);
        document.getElementById('modalTitulo').textContent = 'Editar Cliente';
        document.getElementById('clienteId').value = cliente.id;
        document.getElementById('nombre').value = cliente.nombre;
        document.getElementById('apellido').value = cliente.apellido;
        document.getElementById('documento').value = cliente.documento;
        document.getElementById('correo').value = cliente.correo || '';
        document.getElementById('telefono').value = cliente.telefono || '';
        document.getElementById('direccion').value = cliente.direccion || '';
        document.getElementById('modalCliente').classList.remove('hidden');
    } catch (error) {
        console.error('Error al cargar cliente:', error);
    }
}

function cerrarModal() {
    document.getElementById('modalCliente').classList.add('hidden');
}

async function guardarCliente(event) {
    event.preventDefault();
    console.log('guardarCliente() llamado');
    
    const id = document.getElementById('clienteId').value;
    const nombre = document.getElementById('nombre').value;
    const apellido = document.getElementById('apellido').value;
    const documento = document.getElementById('documento').value;
    const correo = document.getElementById('correo').value;
    const telefono = document.getElementById('telefono').value;
    const direccion = document.getElementById('direccion').value;
    
    console.log('Datos del formulario:', { id, nombre, apellido, documento, correo, telefono, direccion });
    
    // Validar campos requeridos
    if (!nombre || !apellido || !documento) {
        console.warn('Campos requeridos vacíos');
        mostrarNotificacion('Por favor completa los campos requeridos', 'error');
        return;
    }
    
    const formData = new URLSearchParams({
        action: id ? 'actualizar' : 'insertar',
        id: id || '',
        nombre: nombre,
        apellido: apellido,
        documento: documento,
        correo: correo || '',
        telefono: telefono || '',
        direccion: direccion || ''
    });
    
    console.log('Enviando datos al servidor:', {
        action: id ? 'actualizar' : 'insertar',
        nombre: nombre,
        apellido: apellido,
        documento: documento
    });
    
    try {
        const response = await fetch('clientes', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        
        console.log('Response status:', response.status);
        const result = await response.json();
        console.log('Response result:', result);
        
        if (result.success === true || result.success === 'true') {
            console.log('✓ Guardado exitoso');
            mostrarNotificacion(id ? '✓ Cliente actualizado correctamente' : '✓ Cliente creado correctamente');
            cerrarModal();
            console.log('Recargando datos después de guardar cliente...');
            await cargarDatos();
            console.log('✓ Datos recargados');
        } else {
            console.error('Error en respuesta:', result);
            mostrarNotificacion(result.error || 'Error al guardar cliente', 'error');
        }
    } catch (error) {
        console.error('Error al guardar:', error);
        mostrarNotificacion('Error al guardar cliente: ' + error.message, 'error');
    }
}

async function eliminarCliente(id) {
    confirmarEliminacion(async () => {
        try {
            const formData = new URLSearchParams({
                action: 'eliminar',
                id: id
            });
            
            const response = await fetch('clientes', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            });
            const result = await response.json();
            
            if (result.success) {
                mostrarNotificacion('✓ Cliente eliminado correctamente');
                await cargarDatos();
            } else {
                mostrarNotificacion('Error al eliminar cliente: ' + (result.message || ''), 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            mostrarNotificacion('Error al eliminar cliente', 'error');
        }
    });
}

function renderizarTabla() {
    const tbody = document.getElementById('tablaClientes');
    
    if (!tbody) {
        console.error('ERROR: No se encontró el elemento tablaClientes');
        return;
    }
    
    console.log('renderizarTabla() llamado');
    console.log('clientesFiltrados:', clientesFiltrados.length);
    console.log('clientes:', clientes.length);
    
    // Verificar si hay filtros activos
    const buscarInput = document.getElementById('buscarCliente');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    const hayFiltrosActivos = (buscarInput?.value?.trim() || '') !== '' ||
                              (filtroEstadoSelect?.value || '') !== '';
    
    // Si hay filtros activos, usar clientesFiltrados (aunque esté vacío)
    // Si no hay filtros, usar todos los clientes
    const clientesAMostrar = hayFiltrosActivos ? clientesFiltrados : clientes;
    
    console.log('hayFiltrosActivos:', hayFiltrosActivos);
    console.log('clientesAMostrar:', clientesAMostrar.length);
    
    if (clientesAMostrar.length === 0) {
        console.warn('No hay clientes para mostrar');
        
        const mensaje = hayFiltrosActivos 
            ? 'No se encontraron clientes con los filtros aplicados'
            : 'No hay clientes registrados';
        
        tbody.innerHTML = `<tr><td colspan="7" class="text-center py-8 text-gray-500">
            <span class="material-icons-outlined text-4xl block mb-2">inbox</span>
            <p class="mt-2">${mensaje}</p>
            ${hayFiltrosActivos ? '<button onclick="limpiarFiltros()" class="mt-4 px-4 py-2 bg-primary text-white rounded-lg hover:bg-indigo-700 transition text-sm">Limpiar Filtros</button>' : ''}
        </td></tr>`;
        return;
    }
    
    tbody.innerHTML = clientesAMostrar.map(c => {
        // Contar reservas del cliente
        const reservasCliente = reservas.filter(r => r.idCliente === c.id).length;
        
        // Calcular total gastado - basándose en noches * precio_noche
        const totalGastado = reservas
            .filter(r => r.idCliente === c.id && r.estado === 'Confirmada')
            .reduce((sum, r) => {
                const habitacion = habitaciones.find(h => h.id === r.habitacion);
                if (!habitacion) return sum;
                
                const fechaEntrada = new Date(r.fechaEntrada);
                const fechaSalida = new Date(r.fechaSalida);
                const noches = Math.ceil((fechaSalida - fechaEntrada) / (1000 * 60 * 60 * 24));
                const precioNoche = habitacion.precioNoche || 0;
                const totalReserva = noches * precioNoche;
                
                return sum + totalReserva;
            }, 0);
        
        // Determinar si está activo
        const esActivo = reservas.some(r => r.idCliente === c.id && r.estado === 'Confirmada');
        const estadoBadge = esActivo 
            ? '<span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded font-semibold">Activo</span>'
            : '<span class="px-2 py-1 bg-gray-100 text-gray-800 text-xs rounded font-semibold">Inactivo</span>';
        
        return `
            <tr class="border-b hover:bg-gray-50 transition">
                <td class="px-4 py-3 text-sm font-semibold text-gray-900">${c.nombre} ${c.apellido}</td>
                <td class="px-4 py-3 text-sm text-gray-700">${c.documento}</td>
                <td class="px-4 py-3 text-sm text-gray-700">${c.correo || 'N/A'}</td>
                <td class="px-4 py-3 text-sm text-gray-700">${c.telefono || 'N/A'}</td>
                <td class="px-4 py-3 text-sm text-center font-semibold text-blue-600">${reservasCliente}</td>
                <td class="px-4 py-3 text-sm font-semibold text-green-600">${formatearMoneda(totalGastado)}</td>
                <td class="px-4 py-3 text-center space-x-1">
                    <button onclick="editarCliente(${c.id})" class="text-blue-600 hover:text-blue-800 p-1 rounded transition" title="Editar">
                        <span class="material-icons-outlined text-lg">edit</span>
                    </button>
                    <button onclick="eliminarCliente(${c.id})" class="text-red-600 hover:text-red-800 p-1 rounded transition" title="Eliminar">
                        <span class="material-icons-outlined text-lg">delete</span>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

function exportarClientes() {
    if (clientes.length === 0) {
        mostrarNotificacion('No hay clientes para exportar', 'error');
        return;
    }
    
    // Preparar datos
    const clientesAExportar = clientesFiltrados.length > 0 ? clientesFiltrados : clientes;
    
    // Crear CSV
    const headers = ['Nombre', 'Documento', 'Email', 'Teléfono', 'Tipo', 'Reservas', 'Total Gastado'];
    const rows = clientesAExportar.map(c => {
        const reservasCliente = reservas.filter(r => r.idCliente === c.id).length;
        const totalGastado = reservas
            .filter(r => r.idCliente === c.id && r.estado === 'Confirmada')
            .reduce((sum, r) => {
                const habitacion = habitaciones.find(h => h.id === r.habitacion);
                if (!habitacion) return sum;
                
                const fechaEntrada = new Date(r.fechaEntrada);
                const fechaSalida = new Date(r.fechaSalida);
                const noches = Math.ceil((fechaSalida - fechaEntrada) / (1000 * 60 * 60 * 24));
                const precioNoche = habitacion.precioNoche || 0;
                const totalReserva = noches * precioNoche;
                
                return sum + totalReserva;
            }, 0);
        
        return [
            c.nombre + ' ' + c.apellido,
            c.documento,
            c.correo || 'N/A',
            c.telefono || 'N/A',
            c.tipo || 'N/A',
            reservasCliente,
            totalGastado.toFixed(2)
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
    link.setAttribute('download', `clientes_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    mostrarNotificacion('✓ Clientes exportados correctamente');
}

function limpiarFiltros() {
    console.log('limpiarFiltros() llamado');
    
    const buscarInput = document.getElementById('buscarCliente');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    
    if (buscarInput) {
        buscarInput.value = '';
    }
    if (filtroEstadoSelect) {
        filtroEstadoSelect.value = '';
    }
    
    clientesFiltrados = [];
    aplicarFiltros();
    
    mostrarNotificacion('Filtros limpiados');
}
