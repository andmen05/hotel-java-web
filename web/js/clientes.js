// Gestión de Clientes

let clientes = [];

// Cargar clientes al iniciar
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOMContentLoaded - Inicializando clientes.js');
    
    // Verificar que los elementos existan
    const clientesGrid = document.getElementById('clientesGrid');
    const buscarDocumento = document.getElementById('buscarDocumento');
    
    if (!clientesGrid) {
        console.error('ERROR: No se encontró el elemento clientesGrid');
        return;
    }
    
    if (!buscarDocumento) {
        console.error('ERROR: No se encontró el elemento buscarDocumento');
        return;
    }
    
    console.log('Elementos encontrados, cargando clientes...');
    cargarClientes();
    
    // Buscar en tiempo real
    buscarDocumento.addEventListener('input', (e) => {
        const termino = e.target.value.trim();
        if (termino.length >= 1) {
            buscarClientesServidor(termino);
        } else if (termino.length === 0) {
            cargarClientes();
        }
    });
});

async function cargarClientes() {
    try {
        const data = await fetchData('clientes?action=listar');
        clientes = data || [];
        
        // Actualizar estadísticas si existen los elementos
        const totalClientesEl = document.getElementById('totalClientes');
        if (totalClientesEl) {
            totalClientesEl.textContent = clientes.length;
        }
        
        console.log('Clientes cargados:', clientes.length);
        renderizarTabla();
    } catch (error) {
        console.error('Error al cargar clientes:', error);
    }
}

async function buscarClientesServidor(termino) {
    try {
        console.log('Buscando clientes con termino:', termino);
        
        // Buscar usando la acción buscarDocumento (que busca por documento)
        // Si no encuentra, buscar localmente en los clientes cargados
        let clientesFiltrados = [];
        
        try {
            // Intentar buscar por documento en el servidor
            const dataPorDocumento = await fetchData(`clientes?action=buscarDocumento&documento=${encodeURIComponent(termino)}`);
            clientesFiltrados = dataPorDocumento || [];
        } catch (e) {
            console.log('No encontrado por documento, buscando localmente...');
        }
        
        // Si no encontró por documento, buscar localmente por nombre, correo o teléfono
        if (clientesFiltrados.length === 0) {
            clientesFiltrados = clientes.filter(cliente => {
                const nombre = (cliente.nombre + ' ' + cliente.apellido).toLowerCase();
                const correo = (cliente.correo || '').toLowerCase();
                const telefono = (cliente.telefono || '').toLowerCase();
                const documento = (cliente.documento || '').toLowerCase();
                const terminoLower = termino.toLowerCase();
                
                return nombre.includes(terminoLower) || 
                       documento.includes(terminoLower) ||
                       correo.includes(terminoLower) || 
                       telefono.includes(terminoLower);
            });
        }
        
        console.log('Resultados encontrados:', clientesFiltrados.length);
        
        // Mostrar resultados filtrados
        const grid = document.getElementById('clientesGrid');
        if (clientesFiltrados.length === 0) {
            grid.innerHTML = `
                <div class="col-span-full text-center py-12">
                    <i class="fas fa-search text-6xl text-gray-300 mb-4"></i>
                    <p class="text-gray-500 text-lg">No se encontraron clientes con "${termino}"</p>
                </div>
            `;
            return;
        }
        
        // Renderizar clientes filtrados usando la misma función que renderizarTabla
        renderizarClientes(clientesFiltrados);
    } catch (error) {
        console.error('Error al buscar clientes:', error);
        const grid = document.getElementById('clientesGrid');
        grid.innerHTML = `
            <div class="col-span-full text-center py-12">
                <i class="fas fa-exclamation-circle text-6xl text-red-300 mb-4"></i>
                <p class="text-red-500 text-lg">Error al buscar clientes</p>
            </div>
        `;
    }
}

// Función única para renderizar clientes (usada en búsqueda y vista normal)
function renderizarClientes(clientesArray) {
    const grid = document.getElementById('clientesGrid');
    
    if (!grid) {
        console.error('ERROR: No se encontró el elemento clientesGrid');
        return;
    }
    
    if (clientesArray.length === 0) {
        grid.innerHTML = `
            <div class="col-span-full text-center py-12">
                <i class="fas fa-inbox text-6xl text-gray-300 mb-4"></i>
                <p class="text-gray-500 text-lg">No hay clientes registrados</p>
            </div>
        `;
        return;
    }
    
    grid.innerHTML = clientesArray.map(cliente => {
        const inicial = cliente.nombre.charAt(0).toUpperCase();
        const colores = ['from-blue-500 to-blue-600', 'from-purple-500 to-purple-600', 'from-pink-500 to-pink-600', 'from-green-500 to-green-600', 'from-orange-500 to-orange-600', 'from-red-500 to-red-600'];
        const colorIndex = cliente.id % colores.length;
        const colorGradient = colores[colorIndex];
        const bgColor = ['bg-blue-100', 'bg-purple-100', 'bg-pink-100', 'bg-green-100', 'bg-orange-100', 'bg-red-100'][colorIndex];
        
        return `
            <div class="group bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2">
                <!-- Card Header con Gradient -->
                <div class="bg-gradient-to-br ${colorGradient} p-6 text-white relative overflow-hidden">
                    <div class="absolute top-0 right-0 w-20 h-20 bg-white opacity-10 rounded-full -mr-10 -mt-10"></div>
                    <div class="relative z-10 flex items-center justify-between">
                        <div class="flex items-center space-x-4">
                            <div class="${bgColor} w-16 h-16 rounded-full flex items-center justify-center font-bold text-2xl text-gray-800 shadow-lg">
                                ${inicial}
                            </div>
                            <div>
                                <h3 class="font-bold text-xl">${cliente.nombre} ${cliente.apellido}</h3>
                                <p class="text-white text-opacity-80 text-sm">Cliente #${cliente.id}</p>
                            </div>
                        </div>
                        <div class="text-white text-opacity-60">
                            <i class="fas fa-user-circle text-3xl"></i>
                        </div>
                    </div>
                </div>
                
                <!-- Card Body -->
                <div class="p-6 space-y-4">
                    <!-- Documento -->
                    <div class="flex items-center space-x-3 pb-3 border-b border-gray-100">
                        <div class="w-10 h-10 ${bgColor} rounded-lg flex items-center justify-center">
                            <i class="fas fa-id-card text-gray-700"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 font-semibold">DOCUMENTO</p>
                            <p class="text-sm font-semibold text-gray-800">${cliente.documento}</p>
                        </div>
                    </div>
                    
                    <!-- Email -->
                    <div class="flex items-center space-x-3 pb-3 border-b border-gray-100">
                        <div class="w-10 h-10 ${bgColor} rounded-lg flex items-center justify-center">
                            <i class="fas fa-envelope text-gray-700"></i>
                        </div>
                        <div class="flex-1 min-w-0">
                            <p class="text-xs text-gray-500 font-semibold">CORREO</p>
                            <p class="text-sm font-semibold text-gray-800 truncate">${cliente.correo || 'No registrado'}</p>
                        </div>
                    </div>
                    
                    <!-- Teléfono -->
                    <div class="flex items-center space-x-3 pb-3 border-b border-gray-100">
                        <div class="w-10 h-10 ${bgColor} rounded-lg flex items-center justify-center">
                            <i class="fas fa-phone text-gray-700"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 font-semibold">TELÉFONO</p>
                            <p class="text-sm font-semibold text-gray-800">${cliente.telefono || 'No registrado'}</p>
                        </div>
                    </div>
                    
                    <!-- Dirección -->
                    <div class="flex items-start space-x-3">
                        <div class="w-10 h-10 ${bgColor} rounded-lg flex items-center justify-center flex-shrink-0">
                            <i class="fas fa-map-marker-alt text-gray-700"></i>
                        </div>
                        <div class="flex-1 min-w-0">
                            <p class="text-xs text-gray-500 font-semibold">DIRECCIÓN</p>
                            <p class="text-sm font-semibold text-gray-800 truncate">${cliente.direccion || 'No registrada'}</p>
                        </div>
                    </div>
                </div>
                
                <!-- Card Footer -->
                <div class="bg-gray-50 px-6 py-4 flex justify-end gap-2 border-t">
                    <button onclick="editarCliente(${cliente.id})" class="px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition flex items-center gap-2 text-sm font-semibold shadow-sm hover:shadow-md">
                        <i class="fas fa-edit"></i>
                        <span>Editar</span>
                    </button>
                    <button onclick="eliminarCliente(${cliente.id})" class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg transition flex items-center gap-2 text-sm font-semibold shadow-sm hover:shadow-md">
                        <i class="fas fa-trash"></i>
                        <span>Eliminar</span>
                    </button>
                </div>
            </div>
        `;
    }).join('');
}

function renderizarTabla() {
    // Usar la función única para renderizar clientes
    renderizarClientes(clientes);
}

function abrirModalNuevo() {
    document.getElementById('modalTitulo').textContent = 'Nuevo Cliente';
    document.getElementById('formCliente').reset();
    document.getElementById('clienteId').value = '';
    document.getElementById('modalCliente').classList.remove('hidden');
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
    
    const id = document.getElementById('clienteId').value;
    const nombre = document.getElementById('nombre').value;
    const apellido = document.getElementById('apellido').value;
    const documento = document.getElementById('documento').value;
    const correo = document.getElementById('correo').value;
    const telefono = document.getElementById('telefono').value;
    const direccion = document.getElementById('direccion').value;
    
    // Validar campos requeridos
    if (!nombre || !apellido || !documento) {
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
    
    console.log('Enviando datos:', {
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
            mostrarNotificacion(id ? 'Cliente actualizado correctamente' : 'Cliente creado correctamente');
            cerrarModal();
            cargarClientes();
        } else {
            console.error('Error en respuesta:', result);
            mostrarNotificacion(result.error || 'Error al guardar cliente', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
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
                cargarClientes();
            } else {
                mostrarNotificacion('Error al eliminar cliente: ' + (result.message || ''), 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            mostrarNotificacion('Error al eliminar cliente', 'error');
        }
    });
}

function limpiarBusqueda() {
    document.getElementById('buscarDocumento').value = '';
    cargarClientes();
}
