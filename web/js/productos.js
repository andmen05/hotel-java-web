// Gestión de Productos

let productos = [];
let categorias = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('📦 Productos - Inicializando...');
    cargarCategorias();
    cargarProductos();
    
    // Actualizar grid cards cada 5 segundos
    setInterval(cargarProductos, 5000);
});

async function cargarCategorias() {
    try {
        categorias = await fetchData('productos?action=categorias');
        const select = document.getElementById('codCategoria');
        select.innerHTML = categorias.map(c => `<option value="${c.codCategoria}">${c.detalle}</option>`).join('');
    } catch (error) {
        console.error('Error al cargar categorías:', error);
    }
}

async function cargarProductos() {
    try {
        const [productosData, categoriasData] = await Promise.all([
            fetchData('productos?action=listar').catch(e => { console.error('Error productos:', e); return []; }),
            fetchData('productos?action=categorias').catch(e => { console.error('Error categorías:', e); return []; })
        ]);
        
        productos = productosData || [];
        categorias = categoriasData || [];
        
        // Enriquecer productos con nombre de categoría
        productos = productos.map(p => {
            const cat = categorias.find(c => c.codCategoria === p.codCategoria);
            return {
                ...p,
                categoria: cat ? cat.detalle : 'Sin categoría'
            };
        });
        
        // Calcular estadísticas
        const totalProductos = productos.length;
        const totalExistencia = productos.reduce((sum, p) => sum + (p.existencia || 0), 0);
        const productosAgotados = productos.filter(p => p.existencia === 0).length;
        
        // Actualizar tarjetas de resumen si existen
        const totalEl = document.getElementById('totalProductos');
        const existenciaEl = document.getElementById('totalExistencia');
        const agotadosEl = document.getElementById('productosAgotados');
        
        if (totalEl) totalEl.textContent = totalProductos;
        if (existenciaEl) existenciaEl.textContent = totalExistencia;
        if (agotadosEl) agotadosEl.textContent = productosAgotados;
        
        // Calcular productos por categoría (usando el nombre enriquecido)
        const comidas = productos.filter(p => p.categoria && p.categoria.toLowerCase().includes('comida')).length;
        const bebidas = productos.filter(p => p.categoria && p.categoria.toLowerCase().includes('bebida')).length;
        const postres = productos.filter(p => p.categoria && p.categoria.toLowerCase().includes('postre')).length;
        
        // Actualizar grid cards de categorías
        const comidasEl = document.getElementById('comidas');
        const bebidasEl = document.getElementById('bebidas');
        const postresEl = document.getElementById('postres');
        
        if (comidasEl) comidasEl.textContent = comidas;
        if (bebidasEl) bebidasEl.textContent = bebidas;
        if (postresEl) postresEl.textContent = postres;
        
        console.log('✓ Productos cargados:', { totalProductos, totalExistencia, productosAgotados, comidas, bebidas, postres });
        
        renderizarTabla();
    } catch (error) {
        console.error('Error al cargar productos:', error);
    }
}

function renderizarTabla() {
    const tbody = document.getElementById('tablaProductos');
    
    if (!tbody) {
        console.error('ERROR: No se encontró el elemento tablaProductos');
        return;
    }
    
    if (productos.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center py-4 text-gray-500"><i class="fas fa-inbox mr-2"></i>No hay productos registrados</td></tr>';
        return;
    }
    
    console.log('Renderizando', productos.length, 'productos');
    
    tbody.innerHTML = productos.map(p => {
        const existenciaBadge = p.existencia > 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800';
        
        return `
            <tr class="border-b hover:bg-gray-50 transition">
                <td class="px-6 py-4 text-sm font-semibold text-gray-900">${p.codigo}</td>
                <td class="px-6 py-4 text-sm text-gray-700">${p.descripcion}</td>
                <td class="px-6 py-4 text-sm text-gray-700">${p.categoria || 'Sin categoría'}</td>
                <td class="px-6 py-4 text-sm font-semibold text-green-600">${formatearMoneda(p.precioVenta)}</td>
                <td class="px-6 py-4 text-center">
                    <span class="px-3 py-1 rounded-full text-xs font-semibold ${existenciaBadge}">
                        ${p.existencia} unid.
                    </span>
                </td>
                <td class="px-6 py-4 text-sm text-gray-700 text-center">${p.iva}%</td>
                <td class="px-6 py-4 text-center space-x-2">
                    <button onclick="editarProducto(${p.id})" class="text-blue-600 hover:text-blue-800 hover:bg-blue-50 p-2 rounded transition" title="Editar">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button onclick="eliminarProducto(${p.id})" class="text-red-600 hover:text-red-800 hover:bg-red-50 p-2 rounded transition" title="Eliminar">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
}

function abrirModalNuevo() {
    document.getElementById('modalTitulo').textContent = 'Nuevo Producto';
    document.getElementById('formProducto').reset();
    document.getElementById('productoId').value = '';
    document.getElementById('modalProducto').classList.remove('hidden');
}

async function editarProducto(id) {
    try {
        const producto = await fetchData(`productos?action=buscar&id=${id}`);
        document.getElementById('modalTitulo').textContent = 'Editar Producto';
        document.getElementById('productoId').value = producto.id;
        document.getElementById('codigo').value = producto.codigo;
        document.getElementById('descripcion').value = producto.descripcion;
        document.getElementById('precioVenta').value = producto.precioVenta;
        document.getElementById('precioCompra').value = producto.precioCompra;
        document.getElementById('iva').value = producto.iva;
        document.getElementById('existencia').value = producto.existencia;
        document.getElementById('codCategoria').value = producto.codCategoria;
        if (producto.vencimiento) {
            document.getElementById('vencimiento').value = producto.vencimiento;
        }
        document.getElementById('modalProducto').classList.remove('hidden');
    } catch (error) {
        console.error('Error al cargar producto:', error);
    }
}

function cerrarModal() {
    document.getElementById('modalProducto').classList.add('hidden');
}

async function guardarProducto(event) {
    event.preventDefault();
    
    const id = document.getElementById('productoId').value;
    const formData = new URLSearchParams({
        action: id ? 'actualizar' : 'insertar',
        id: id || '',
        codigo: document.getElementById('codigo').value,
        descripcion: document.getElementById('descripcion').value,
        precioVenta: document.getElementById('precioVenta').value,
        precioCompra: document.getElementById('precioCompra').value,
        iva: document.getElementById('iva').value,
        existencia: document.getElementById('existencia').value,
        idUsuario: '1', // TODO: obtener del usuario de sesión
        codCategoria: document.getElementById('codCategoria').value,
        vencimiento: document.getElementById('vencimiento').value || ''
    });
    
    try {
        const response = await fetch('productos', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        const result = await response.json();
        
        if (result.success) {
            mostrarNotificacion(id ? 'Producto actualizado correctamente' : 'Producto creado correctamente');
            cerrarModal();
            cargarProductos();
        } else {
            mostrarNotificacion('Error al guardar producto', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        mostrarNotificacion('Error al guardar producto', 'error');
    }
}

async function eliminarProducto(id) {
    confirmarEliminacion(async () => {
        try {
            const formData = new URLSearchParams({
                action: 'eliminar',
                id: id
            });
            
            const response = await fetch('productos', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            });
            const result = await response.json();
            
            if (result.success) {
                mostrarNotificacion('✓ Producto eliminado correctamente');
                cargarProductos();
            } else {
                mostrarNotificacion('Error al eliminar producto: ' + (result.message || ''), 'error');
            }
        } catch (error) {
            console.error('Error:', error);
            mostrarNotificacion('Error al eliminar producto', 'error');
        }
    });
}

