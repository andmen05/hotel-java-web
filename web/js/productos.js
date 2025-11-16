// Gestión de Productos

let productos = [];
let categorias = [];
let productosFiltrados = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('📦 Productos - Inicializando...');
    cargarCategorias();
    cargarProductos();
    
    // Event listeners para filtros
    const buscarInput = document.getElementById('buscarProducto');
    const filtroCategoriaSelect = document.getElementById('filtroCategoria');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    const filtroRangoInput = document.getElementById('filtroRango');
    
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
    
    if (filtroCategoriaSelect) {
        filtroCategoriaSelect.addEventListener('change', () => {
            console.log('Filtro de categoría cambiado:', filtroCategoriaSelect.value);
            aplicarFiltros();
        });
    }
    
    if (filtroEstadoSelect) {
        filtroEstadoSelect.addEventListener('change', () => {
            console.log('Filtro de estado cambiado:', filtroEstadoSelect.value);
            aplicarFiltros();
        });
    }
    
    if (filtroRangoInput) {
        filtroRangoInput.addEventListener('input', (e) => {
            const rangoValor = document.getElementById('rangoValor');
            if (rangoValor) {
                rangoValor.textContent = e.target.value;
            }
            console.log('Filtro de rango cambiado:', e.target.value);
            aplicarFiltros();
        });
    }
    
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
        hoy.setHours(0, 0, 0, 0);
        const hace30Dias = new Date(hoy.getTime() + 30 * 24 * 60 * 60 * 1000);
        const proximosVencer = productos.filter(p => {
            if (!p.vencimiento) return false;
            
            // Intentar parsear la fecha
            let fechaVencimiento = null;
            if (typeof p.vencimiento === 'string' && p.vencimiento.trim() !== '') {
                try {
                    fechaVencimiento = new Date(p.vencimiento);
                    if (isNaN(fechaVencimiento.getTime())) {
                        return false;
                    }
                } catch (e) {
                    return false;
                }
            } else if (typeof p.vencimiento === 'number') {
                fechaVencimiento = new Date(p.vencimiento);
            } else {
                return false;
            }
            
            fechaVencimiento.setHours(0, 0, 0, 0);
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
        
        // Limpiar filtros cuando se cargan nuevos productos y aplicar filtros actuales
        productosFiltrados = [];
        aplicarFiltros();
    } catch (error) {
        console.error('Error al cargar productos:', error);
    }
}

function aplicarFiltros() {
    console.log('aplicarFiltros() llamado');
    
    // Verificar que productos esté cargado
    if (!productos || productos.length === 0) {
        console.warn('⚠️ No hay productos cargados aún');
        return;
    }
    
    const buscarInput = document.getElementById('buscarProducto');
    const filtroCategoriaSelect = document.getElementById('filtroCategoria');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    const filtroRangoInput = document.getElementById('filtroRango');
    
    const busqueda = buscarInput ? buscarInput.value.trim().toLowerCase() : '';
    const categoria = filtroCategoriaSelect ? filtroCategoriaSelect.value : '';
    const estado = filtroEstadoSelect ? filtroEstadoSelect.value : '';
    const rangoMaximo = parseInt(filtroRangoInput ? filtroRangoInput.max : '100000');
    const rango = parseInt(filtroRangoInput ? filtroRangoInput.value : rangoMaximo.toString());
    
    // Solo aplicar filtro de rango si es menor al máximo (es decir, el usuario lo cambió)
    const aplicarFiltroRango = rango < rangoMaximo;
    
    console.log('Filtros aplicados:', { busqueda, categoria, estado, rango, rangoMaximo, aplicarFiltroRango, productosCount: productos.length });
    
    productosFiltrados = productos.filter(p => {
        // Filtro búsqueda - buscar en código y descripción
        let coincideBusqueda = true;
        if (busqueda && busqueda.length > 0) {
            const codigo = (p.codigo || '').toString().toLowerCase();
            const descripcion = (p.descripcion || '').toString().toLowerCase();
            coincideBusqueda = codigo.includes(busqueda) || descripcion.includes(busqueda);
            if (!coincideBusqueda) {
                return false;
            }
        }
        
        // Filtro categoría
        const coincideCategoria = !categoria || String(p.codCategoria) === String(categoria);
        if (!coincideCategoria) {
            return false;
        }
        
        // Filtro estado
        let coincideEstado = true;
        if (estado === 'bajo') {
            coincideEstado = p.existencia > 0 && p.existencia < 5;
        } else if (estado === 'normal') {
            coincideEstado = p.existencia >= 5;
        } else if (estado === 'vencer') {
            const hoy = new Date();
            hoy.setHours(0, 0, 0, 0);
            const hace30Dias = new Date(hoy.getTime() + 30 * 24 * 60 * 60 * 1000);
            
            if (p.vencimiento) {
                // Intentar parsear la fecha
                let fechaVencimiento = null;
                if (typeof p.vencimiento === 'string' && p.vencimiento.trim() !== '') {
                    try {
                        fechaVencimiento = new Date(p.vencimiento);
                        if (isNaN(fechaVencimiento.getTime())) {
                            coincideEstado = false;
                        } else {
                            fechaVencimiento.setHours(0, 0, 0, 0);
                            coincideEstado = fechaVencimiento <= hace30Dias && fechaVencimiento >= hoy;
                        }
                    } catch (e) {
                        coincideEstado = false;
                    }
                } else if (typeof p.vencimiento === 'number') {
                    fechaVencimiento = new Date(p.vencimiento);
                    fechaVencimiento.setHours(0, 0, 0, 0);
                    coincideEstado = fechaVencimiento <= hace30Dias && fechaVencimiento >= hoy;
                } else {
                    coincideEstado = false;
                }
            } else {
                coincideEstado = false;
            }
        }
        if (!coincideEstado) {
            return false;
        }
        
        // Filtro rango precio - solo aplicar si el usuario cambió el rango
        if (aplicarFiltroRango) {
            const precioVenta = parseFloat(p.precioVenta) || 0;
            const coincideRango = precioVenta <= rango;
            if (!coincideRango) {
                return false;
            }
        }
        
        return true;
    });
    
    console.log('✓ Productos filtrados:', productosFiltrados.length, 'de', productos.length);
    renderizarTabla();
}

function renderizarTabla() {
    const tbody = document.getElementById('tablaProductos');
    
    if (!tbody) {
        console.error('ERROR: No se encontró el elemento tablaProductos');
        return;
    }
    
    // Verificar si hay filtros activos
    const buscarInput = document.getElementById('buscarProducto');
    const filtroCategoriaSelect = document.getElementById('filtroCategoria');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    const filtroRangoInput = document.getElementById('filtroRango');
    const rangoMaximo = parseInt(filtroRangoInput ? filtroRangoInput.max : '100000');
    const rangoActual = parseInt(filtroRangoInput ? filtroRangoInput.value : rangoMaximo.toString());
    
    // Solo considerar el rango como filtro activo si es menor al máximo
    const hayFiltrosActivos = (buscarInput?.value?.trim() || '') !== '' ||
                              (filtroCategoriaSelect?.value || '') !== '' ||
                              (filtroEstadoSelect?.value || '') !== '' ||
                              (rangoActual < rangoMaximo);
    
    // Si hay filtros activos, usar productosFiltrados (aunque esté vacío)
    // Si no hay filtros, usar todos los productos
    const productosAMostrar = hayFiltrosActivos ? productosFiltrados : productos;
    
    console.log('renderizarTabla() - productosAMostrar:', productosAMostrar.length, 'hayFiltrosActivos:', hayFiltrosActivos);
    
    if (productosAMostrar.length === 0) {
        const mensaje = hayFiltrosActivos 
            ? 'No se encontraron productos con los filtros aplicados'
            : 'No hay productos registrados';
        
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="text-center py-8 text-gray-500">
                    <span class="material-icons-outlined text-4xl block mb-2">inbox</span>
                    <p class="mt-2">${mensaje}</p>
                    ${hayFiltrosActivos ? '<button onclick="limpiarFiltros()" class="mt-4 px-4 py-2 bg-primary text-white rounded-lg hover:bg-indigo-700 transition text-sm">Limpiar Filtros</button>' : ''}
                </td>
            </tr>
        `;
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
        
        // Determinar estado de vencimiento y mostrar fecha
        let vencimientoBadge = '';
        let fechaVencimientoTexto = '';
        
        // Intentar parsear la fecha de diferentes formatos posibles
        let fechaVencimiento = null;
        if (p.vencimiento) {
            // Puede venir como string "YYYY-MM-DD" o como timestamp
            if (typeof p.vencimiento === 'string' && p.vencimiento.trim() !== '') {
                try {
                    // Intentar parsear como fecha ISO (YYYY-MM-DD)
                    fechaVencimiento = new Date(p.vencimiento);
                    // Verificar que sea una fecha válida
                    if (isNaN(fechaVencimiento.getTime())) {
                        fechaVencimiento = null;
                    }
                } catch (e) {
                    fechaVencimiento = null;
                }
            } else if (typeof p.vencimiento === 'number') {
                // Si viene como timestamp
                fechaVencimiento = new Date(p.vencimiento);
            }
        }
        
        if (fechaVencimiento && !isNaN(fechaVencimiento.getTime())) {
            const hoy = new Date();
            hoy.setHours(0, 0, 0, 0);
            fechaVencimiento.setHours(0, 0, 0, 0);
            const diasFaltantes = Math.floor((fechaVencimiento - hoy) / (1000 * 60 * 60 * 24));
            
            // Formatear fecha para mostrar (DD/MM/YYYY)
            fechaVencimientoTexto = fechaVencimiento.toLocaleDateString('es-ES', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit'
            });
            
            if (diasFaltantes < 0) {
                vencimientoBadge = `<span class="px-2 py-1 bg-red-100 text-red-800 text-xs rounded font-semibold">Vencido</span>`;
            } else if (diasFaltantes <= 30) {
                vencimientoBadge = `<span class="px-2 py-1 bg-orange-100 text-orange-800 text-xs rounded font-semibold">${diasFaltantes} días</span>`;
            } else {
                vencimientoBadge = `<span class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded font-semibold">${diasFaltantes} días</span>`;
            }
        } else {
            fechaVencimientoTexto = 'N/A';
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
                <td class="px-4 py-3">
                    <div class="flex flex-col items-center space-y-1">
                        ${fechaVencimientoTexto !== 'N/A' ? `<span class="text-xs text-gray-600 font-medium">${fechaVencimientoTexto}</span>` : ''}
                        ${vencimientoBadge}
                    </div>
                </td>
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
        
        // Manejar fecha de vencimiento - puede venir en diferentes formatos
        const vencimientoInput = document.getElementById('vencimiento');
        if (producto.vencimiento) {
            let fechaVencimiento = null;
            
            // Intentar parsear la fecha
            if (typeof producto.vencimiento === 'string' && producto.vencimiento.trim() !== '') {
                try {
                    fechaVencimiento = new Date(producto.vencimiento);
                    if (isNaN(fechaVencimiento.getTime())) {
                        fechaVencimiento = null;
                    }
                } catch (e) {
                    console.warn('Error al parsear fecha de vencimiento:', producto.vencimiento);
                    fechaVencimiento = null;
                }
            } else if (typeof producto.vencimiento === 'number') {
                fechaVencimiento = new Date(producto.vencimiento);
            }
            
            // Formatear para input type="date" (YYYY-MM-DD)
            if (fechaVencimiento && !isNaN(fechaVencimiento.getTime())) {
                const year = fechaVencimiento.getFullYear();
                const month = String(fechaVencimiento.getMonth() + 1).padStart(2, '0');
                const day = String(fechaVencimiento.getDate()).padStart(2, '0');
                vencimientoInput.value = `${year}-${month}-${day}`;
            } else {
                vencimientoInput.value = '';
            }
        } else {
            vencimientoInput.value = '';
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

function limpiarFiltros() {
    console.log('limpiarFiltros() llamado');
    
    const buscarInput = document.getElementById('buscarProducto');
    const filtroCategoriaSelect = document.getElementById('filtroCategoria');
    const filtroEstadoSelect = document.getElementById('filtroEstado');
    const filtroRangoInput = document.getElementById('filtroRango');
    const rangoValor = document.getElementById('rangoValor');
    
    if (buscarInput) buscarInput.value = '';
    if (filtroCategoriaSelect) filtroCategoriaSelect.value = '';
    if (filtroEstadoSelect) filtroEstadoSelect.value = '';
    if (filtroRangoInput) {
        filtroRangoInput.value = filtroRangoInput.max || '100000';
        if (rangoValor) rangoValor.textContent = filtroRangoInput.value;
    }
    
    productosFiltrados = [];
    aplicarFiltros();
    
    mostrarNotificacion('Filtros limpiados');
}

