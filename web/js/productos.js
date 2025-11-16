// Gestión de Productos

let productos = [];
let categorias = [];
let productosFiltrados = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('📦 Productos - Inicializando...');
    cargarCategorias();
    cargarProductos();
    
    // Event listeners para filtros
    document.getElementById('buscarProducto')?.addEventListener('input', aplicarFiltros);
    document.getElementById('filtroCategoria')?.addEventListener('change', aplicarFiltros);
    document.getElementById('filtroEstado')?.addEventListener('change', aplicarFiltros);
    document.getElementById('filtroRango')?.addEventListener('input', (e) => {
        document.getElementById('rangoValor').textContent = e.target.value;
        aplicarFiltros();
    });
    
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
        // No recargar si el modal está abierto
        const modalAbierto = !document.getElementById('modalProducto')?.classList.contains('hidden');
        if (modalAbierto) {
            console.log('Modal abierto, saltando recarga de datos');
            return;
        }
        
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
        
        // Calcular estadísticas principales
        const totalProductos = productos.length;
        
        // Stock bajo (menos de 5 unidades)
        const stockBajo = productos.filter(p => p.existencia > 0 && p.existencia < 5).length;
        
        // Próximos a vencer (en 30 días)
        const hoy = new Date();
        const hace30Dias = new Date(hoy.getTime() + 30 * 24 * 60 * 60 * 1000);
        const proximosVencer = productos.filter(p => {
            if (!p.vencimiento) return false;
            const fechaVencimiento = new Date(p.vencimiento);
            return fechaVencimiento <= hace30Dias && fechaVencimiento >= hoy;
        }).length;
        
        // Valor total del inventario
        const valorTotal = productos.reduce((sum, p) => sum + ((p.precioCompra || 0) * (p.existencia || 0)), 0);
        
        // Margen promedio
        const margenes = productos
            .filter(p => p.precioCompra && p.precioCompra > 0)
            .map(p => ((p.precioVenta - p.precioCompra) / p.precioCompra) * 100);
        const margenPromedio = margenes.length > 0 ? (margenes.reduce((a, b) => a + b, 0) / margenes.length).toFixed(1) : 0;
        
        // Actualizar tarjetas de resumen
        const totalEl = document.getElementById('totalProductos');
        const stockBajoEl = document.getElementById('stockBajo');
        const proximosVencerEl = document.getElementById('proximosVencer');
        const valorTotalEl = document.getElementById('valorTotal');
        const margenPromedioEl = document.getElementById('margenPromedio');
        
        if (totalEl) totalEl.textContent = totalProductos;
        if (stockBajoEl) stockBajoEl.textContent = stockBajo;
        if (proximosVencerEl) proximosVencerEl.textContent = proximosVencer;
        if (valorTotalEl) valorTotalEl.textContent = formatearMoneda(valorTotal);
        if (margenPromedioEl) margenPromedioEl.textContent = margenPromedio + '%';
        
        // Llenar select de categorías en filtros
        const filtroCategoria = document.getElementById('filtroCategoria');
        if (filtroCategoria && filtroCategoria.options.length === 1) {
            categorias.forEach(c => {
                const option = document.createElement('option');
                option.value = c.codCategoria;
                option.textContent = c.detalle;
                filtroCategoria.appendChild(option);
            });
        }
        
        console.log('✓ Productos cargados:', { totalProductos, stockBajo, proximosVencer, valorTotal, margenPromedio });
        
        aplicarFiltros();
    } catch (error) {
        console.error('Error al cargar productos:', error);
    }
}

function aplicarFiltros() {
    const busqueda = document.getElementById('buscarProducto')?.value.toLowerCase() || '';
    const categoria = document.getElementById('filtroCategoria')?.value || '';
    const estado = document.getElementById('filtroEstado')?.value || '';
    const rango = parseInt(document.getElementById('filtroRango')?.value || '1000');
    
    productosFiltrados = productos.filter(p => {
        // Filtro búsqueda
        const coincideBusqueda = !busqueda || 
            p.codigo.toLowerCase().includes(busqueda) ||
            p.descripcion.toLowerCase().includes(busqueda);
        
        // Filtro categoría
        const coincideCategoria = !categoria || p.codCategoria == categoria;
        
        // Filtro estado
        let coincideEstado = true;
        if (estado === 'bajo') {
            coincideEstado = p.existencia > 0 && p.existencia < 5;
        } else if (estado === 'normal') {
            coincideEstado = p.existencia >= 5;
        } else if (estado === 'vencer') {
            const hoy = new Date();
            const hace30Dias = new Date(hoy.getTime() + 30 * 24 * 60 * 60 * 1000);
            if (p.vencimiento) {
                const fechaVencimiento = new Date(p.vencimiento);
                coincideEstado = fechaVencimiento <= hace30Dias && fechaVencimiento >= hoy;
            } else {
                coincideEstado = false;
            }
        }
        
        // Filtro rango precio
        const coincideRango = p.precioVenta <= rango;
        
        return coincideBusqueda && coincideCategoria && coincideEstado && coincideRango;
    });
    
    renderizarTabla();
}

function renderizarTabla() {
    const tbody = document.getElementById('tablaProductos');
    
    if (!tbody) {
        console.error('ERROR: No se encontró el elemento tablaProductos');
        return;
    }
    
    const productosAMostrar = productosFiltrados.length > 0 ? productosFiltrados : productos;
    
    if (productosAMostrar.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center py-8 text-gray-500"><span class="material-icons-outlined text-4xl">inbox</span><p class="mt-2">No hay productos</p></td></tr>';
        return;
    }
    
    tbody.innerHTML = productosAMostrar.map(p => {
        // Determinar estado del stock
        let stockBadge = 'bg-green-100 text-green-800';
        if (p.existencia === 0) {
            stockBadge = 'bg-red-100 text-red-800';
        } else if (p.existencia < 5) {
            stockBadge = 'bg-orange-100 text-orange-800';
        }
        
        // Calcular margen
        const margen = p.precioCompra && p.precioCompra > 0 
            ? (((p.precioVenta - p.precioCompra) / p.precioCompra) * 100).toFixed(1)
            : 0;
        
        // Determinar estado de vencimiento
        let vencimientoBadge = '';
        if (p.vencimiento) {
            const hoy = new Date();
            const fechaVencimiento = new Date(p.vencimiento);
            const diasFaltantes = Math.floor((fechaVencimiento - hoy) / (1000 * 60 * 60 * 24));
            
            if (diasFaltantes < 0) {
                vencimientoBadge = '<span class="px-2 py-1 bg-red-100 text-red-800 text-xs rounded font-semibold">Vencido</span>';
            } else if (diasFaltantes <= 30) {
                vencimientoBadge = `<span class="px-2 py-1 bg-orange-100 text-orange-800 text-xs rounded font-semibold">${diasFaltantes} días</span>`;
            } else {
                vencimientoBadge = `<span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded font-semibold">${diasFaltantes} días</span>`;
            }
        } else {
            vencimientoBadge = '<span class="text-gray-400 text-xs">N/A</span>';
        }
        
        return `
            <tr class="border-b hover:bg-gray-50 transition">
                <td class="px-4 py-3 text-sm font-semibold text-gray-900">${p.codigo}</td>
                <td class="px-4 py-3 text-sm text-gray-700">${p.descripcion}</td>
                <td class="px-4 py-3 text-sm text-gray-700">${p.categoria || 'Sin categoría'}</td>
                <td class="px-4 py-3 text-sm font-semibold text-green-600">${formatearMoneda(p.precioVenta)}</td>
                <td class="px-4 py-3 text-center">
                    <span class="px-2 py-1 rounded text-xs font-semibold ${stockBadge}">
                        ${p.existencia} unid.
                    </span>
                </td>
                <td class="px-4 py-3 text-sm text-center font-semibold text-purple-600">${margen}%</td>
                <td class="px-4 py-3 text-center">${vencimientoBadge}</td>
                <td class="px-4 py-3 text-center space-x-1">
                    <button onclick="editarProducto(${p.id})" class="text-blue-600 hover:text-blue-800 p-1 rounded transition" title="Editar">
                        <span class="material-icons-outlined text-lg">edit</span>
                    </button>
                    <button onclick="eliminarProducto(${p.id})" class="text-red-600 hover:text-red-800 p-1 rounded transition" title="Eliminar">
                        <span class="material-icons-outlined text-lg">delete</span>
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

function exportarExcel() {
    if (productos.length === 0) {
        mostrarNotificacion('No hay productos para exportar', 'error');
        return;
    }
    
    // Preparar datos
    const productosAExportar = productosFiltrados.length > 0 ? productosFiltrados : productos;
    
    // Crear CSV
    const headers = ['Código', 'Descripción', 'Categoría', 'Precio Venta', 'Precio Compra', 'Stock', 'Margen %', 'IVA %', 'Vencimiento'];
    const rows = productosAExportar.map(p => {
        const margen = p.precioCompra && p.precioCompra > 0 
            ? (((p.precioVenta - p.precioCompra) / p.precioCompra) * 100).toFixed(1)
            : 0;
        
        return [
            p.codigo,
            p.descripcion,
            p.categoria || 'Sin categoría',
            p.precioVenta.toFixed(2),
            p.precioCompra.toFixed(2),
            p.existencia,
            margen,
            p.iva,
            p.vencimiento || 'N/A'
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
    link.setAttribute('download', `productos_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    mostrarNotificacion('✓ Productos exportados correctamente');
}

