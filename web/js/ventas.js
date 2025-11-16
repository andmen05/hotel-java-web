// Gestión de Ventas a Habitaciones

let productos = [];
let habitaciones = [];
let ventas = [];
let carrito = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('Ventas - Inicializando...');
    cargarDatos();
    
    // Event listener para el botón "Agregar al Carrito"
    const btnAgregar = document.getElementById('btnAgregarCarrito');
    if (btnAgregar) {
        console.log('✓ Botón Agregar al Carrito encontrado');
        btnAgregar.addEventListener('click', (e) => {
            e.preventDefault();
            console.log('🛒 Botón Agregar al Carrito clickeado');
            agregarProducto();
        });
    } else {
        console.error('❌ Botón Agregar al Carrito NO encontrado');
    }
    
    // Actualizar grid cards cada 5 segundos
    setInterval(actualizarGridCards, 5000);
});

async function cargarDatos() {
    try {
        console.log('🛒 Ventas - Cargando datos...');
        
        const productosData = await fetchData('productos?action=listar').catch(e => { 
            console.error('Error productos:', e); 
            return []; 
        });
        const habitacionesData = await fetchData('habitaciones?action=listar').catch(e => { 
            console.error('Error habitaciones:', e); 
            return []; 
        });
        const ventasData = await fetchData('ventas?action=listar').catch(e => { 
            console.error('Error ventas:', e); 
            return []; 
        });
        
        productos = productosData || [];
        habitaciones = habitacionesData || [];
        ventas = ventasData || [];
        
        console.log('✓ Datos cargados:', { productos: productos.length, habitaciones: habitaciones.length, ventas: ventas.length });
        console.log('Productos:', productos);
        
        // Actualizar grid cards
        actualizarGridCards();
        
        console.log('✓ Grid cards actualizadas');
        
        // Llenar selects
        const selectProducto = document.getElementById('productoVenta');
        console.log('Llenando select de productos con:', productos.length, 'productos');
        if (selectProducto) {
            selectProducto.innerHTML = '<option value="">Seleccione un producto</option>' +
                productos.map(p => `<option value="${p.id}" data-precio="${p.precioVenta}" data-iva="${p.iva}">${p.descripcion} - ${formatearMoneda(p.precioVenta)}</option>`).join('');
            
            // Event listener para auto-llenar precio
            selectProducto.addEventListener('change', (e) => {
                const option = e.target.options[e.target.selectedIndex];
                if (option.value) {
                    const precio = option.dataset.precio;
                    console.log('Producto seleccionado, precio:', precio);
                    document.getElementById('precioUnitario').value = precio;
                }
            });
        }
        
        const selectHabitacion = document.getElementById('habitacionVenta');
        if (selectHabitacion) {
            selectHabitacion.innerHTML = '<option value="">Seleccione una habitación</option>' +
                habitaciones.map(h => `<option value="${h.id}">${h.idHabitacion} - ${h.tipoHabitacion}</option>`).join('');
        }
        
        const filtroHabitacion = document.getElementById('filtroHabitacion');
        if (filtroHabitacion) {
            filtroHabitacion.innerHTML = '<option value="">Todas</option>' +
                habitaciones.map(h => `<option value="${h.id}">${h.idHabitacion}</option>`).join('');
        }
        
        console.log('✓ Selects llenados correctamente');
        renderizarHistorial();
    } catch (error) {
        console.error('Error al cargar datos:', error);
        mostrarNotificacion('Error al cargar datos de ventas', 'error');
    }
}

function actualizarGridCards() {
    try {
        // Calcular ventas de hoy
        const hoy = new Date();
        hoy.setHours(0, 0, 0, 0);
        
        const ventasHoyData = ventas.filter(v => {
            const fecha = new Date(v.fecha);
            fecha.setHours(0, 0, 0, 0);
            return fecha.getTime() === hoy.getTime();
        });
        
        // Calcular totales
        const totalVentasHoy = ventasHoyData.reduce((sum, v) => sum + (v.total || 0), 0);
        const cantidadTransacciones = ventasHoyData.length;
        const ticketPromedio = cantidadTransacciones > 0 ? totalVentasHoy / cantidadTransacciones : 0;
        
        // Actualizar grid card: Ventas Hoy
        const ventasHoyEl = document.getElementById('ventasHoy');
        if (ventasHoyEl) {
            ventasHoyEl.textContent = formatearMoneda(totalVentasHoy);
            console.log('✓ Ventas Hoy:', formatearMoneda(totalVentasHoy));
        }
        
        // Actualizar grid card: Transacciones
        const transaccionesEl = document.getElementById('transacciones');
        if (transaccionesEl) {
            transaccionesEl.textContent = cantidadTransacciones;
            console.log('✓ Transacciones:', cantidadTransacciones);
        }
        
        // Actualizar grid card: Ticket Promedio
        const ticketPromedioEl = document.getElementById('ticketPromedio');
        if (ticketPromedioEl) {
            ticketPromedioEl.textContent = formatearMoneda(ticketPromedio);
            console.log('✓ Ticket Promedio:', formatearMoneda(ticketPromedio));
        }
        
    } catch (error) {
        console.error('Error al actualizar grid cards:', error);
    }
}

function agregarProducto() {
    const productoId = document.getElementById('productoVenta').value;
    const cantidad = parseInt(document.getElementById('cantidad').value) || 0;
    const precioUnitario = parseFloat(document.getElementById('precioUnitario').value) || 0;
    
    console.log('agregarProducto() - productoId:', productoId, 'cantidad:', cantidad, 'precio:', precioUnitario);
    
    // Validar que haya un producto seleccionado
    if (!productoId) {
        mostrarNotificacion('⚠️ Selecciona un Producto', 'error');
        return;
    }
    
    // Validar cantidad
    if (cantidad <= 0) {
        mostrarNotificacion('⚠️ Ingresa una Cantidad válida', 'error');
        return;
    }
    
    // Validar precio
    if (!precioUnitario || precioUnitario <= 0) {
        mostrarNotificacion('⚠️ El precio no se ha cargado. Selecciona el producto nuevamente', 'error');
        return;
    }
    
    const producto = productos.find(p => p.id == productoId);
    console.log('Producto encontrado:', producto);
    if (!producto) {
        mostrarNotificacion('❌ Producto no encontrado', 'error');
        return;
    }
    
    const item = {
        idProducto: producto.id,
        descripcion: producto.descripcion,
        cantidad: cantidad,
        precioUnitario: precioUnitario,
        iva: producto.iva
    };
    
    carrito.push(item);
    actualizarCarrito();
    calcularTotal();
    
    // Limpiar formulario
    document.getElementById('productoVenta').value = '';
    document.getElementById('cantidad').value = 1;
    document.getElementById('precioUnitario').value = '';
}

function actualizarCarrito() {
    const carritoDiv = document.getElementById('carrito');
    const carritoCount = document.getElementById('carritoCount');
    
    if (carrito.length === 0) {
        carritoDiv.innerHTML = '<p class="text-gray-500 text-center text-sm">No hay productos en el carrito</p>';
        if (carritoCount) carritoCount.textContent = '0 productos';
        return;
    }
    
    if (carritoCount) {
        carritoCount.textContent = carrito.length + ' producto' + (carrito.length !== 1 ? 's' : '');
    }
    
    carritoDiv.innerHTML = carrito.map((item, index) => `
        <div class="border-b pb-3 mb-3">
            <div class="flex justify-between items-start mb-2">
                <div class="flex-1">
                    <p class="font-semibold text-sm">${item.descripcion}</p>
                    <p class="text-xs text-gray-600">${formatearMoneda(item.precioUnitario)}/unidad</p>
                </div>
                <button onclick="eliminarDelCarrito(${index})" class="text-red-600 hover:text-red-800 text-lg" title="Eliminar">
                    <span class="material-icons-outlined text-base">delete</span>
                </button>
            </div>
            <div class="flex items-center justify-between bg-gray-100 rounded p-2">
                <div class="flex items-center space-x-2">
                    <button onclick="disminuirCantidad(${index})" class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-2 py-1 rounded text-sm">−</button>
                    <span class="px-3 py-1 bg-white rounded border">${item.cantidad}</span>
                    <button onclick="aumentarCantidad(${index})" class="bg-gray-300 hover:bg-gray-400 text-gray-800 px-2 py-1 rounded text-sm">+</button>
                </div>
                <span class="font-semibold text-sm">${formatearMoneda(item.cantidad * item.precioUnitario)}</span>
            </div>
        </div>
    `).join('');
}

function eliminarDelCarrito(index) {
    carrito.splice(index, 1);
    actualizarCarrito();
    calcularTotal();
}

function aumentarCantidad(index) {
    if (carrito[index]) {
        carrito[index].cantidad++;
        actualizarCarrito();
        calcularTotal();
    }
}

function disminuirCantidad(index) {
    if (carrito[index] && carrito[index].cantidad > 1) {
        carrito[index].cantidad--;
        actualizarCarrito();
        calcularTotal();
    }
}

function calcularTotal() {
    let subtotal = 0;
    let iva5 = 0;
    let iva10 = 0;
    
    carrito.forEach(item => {
        const subtotalItem = item.cantidad * item.precioUnitario;
        subtotal += subtotalItem;
        
        if (item.iva === 5) {
            iva5 += subtotalItem * 0.05;
        } else if (item.iva === 10) {
            iva10 += subtotalItem * 0.10;
        }
    });
    
    const total = subtotal + iva5 + iva10;
    
    document.getElementById('subtotal').textContent = formatearMoneda(subtotal);
    document.getElementById('iva5').textContent = formatearMoneda(iva5);
    document.getElementById('iva10').textContent = formatearMoneda(iva10);
    document.getElementById('total').textContent = formatearMoneda(total);
}

async function procesarVenta(event) {
    event.preventDefault();
    
    console.log('💳 Procesando venta...');
    console.log('procesarVenta() - Carrito:', carrito);
    console.log('procesarVenta() - Carrito length:', carrito.length);
    
    // VALIDACIÓN 1: Carrito no vacío
    if (carrito.length === 0) {
        console.warn('⚠️ Carrito vacío');
        mostrarNotificacion('❌ Agrega productos al carrito primero', 'error');
        return;
    }
    
    // VALIDACIÓN 2: Habitación seleccionada
    const habitacionSelect = document.getElementById('habitacionVenta');
    const habitacionId = habitacionSelect ? habitacionSelect.value : '';
    
    console.log('Habitación select:', habitacionSelect);
    console.log('Habitación value:', habitacionId);
    console.log('Habitación options:', habitacionSelect ? habitacionSelect.options.length : 'N/A');
    
    if (!habitacionId || habitacionId === '' || habitacionId === 'undefined') {
        console.warn('⚠️ Habitación no seleccionada - value:', habitacionId);
        mostrarNotificacion('❌ Selecciona una Habitación', 'error');
        return;
    }
    
    // VALIDACIÓN 3: Tipo de pago seleccionado
    const tipoPago = document.getElementById('tipoPago').value;
    if (!tipoPago || tipoPago === '') {
        console.warn('⚠️ Tipo de pago no seleccionado');
        mostrarNotificacion('❌ Selecciona un Tipo de Pago', 'error');
        return;
    }
    
    console.log('✓ Validaciones pasadas - Habitación:', habitacionId, 'Pago:', tipoPago);
    
    // Calcular totales directamente desde el carrito (sin extraer del DOM)
    let subtotal = 0;
    let iva5 = 0;
    let iva10 = 0;
    
    carrito.forEach(item => {
        const subtotalItem = item.cantidad * item.precioUnitario;
        subtotal += subtotalItem;
        
        if (item.iva === 5) {
            iva5 += subtotalItem * 0.05;
        } else if (item.iva === 10) {
            iva10 += subtotalItem * 0.10;
        }
    });
    
    const total = subtotal + iva5 + iva10;
    
    // Obtener fecha actual
    const hoy = new Date();
    const fechaVenta = hoy.toISOString().split('T')[0]; // Formato: YYYY-MM-DD
    
    console.log('Fecha de venta:', fechaVenta);
    console.log('Total:', total, 'IVA5:', iva5, 'IVA10:', iva10);
    
    const formData = new URLSearchParams({
        action: 'insertar',
        fecha: fechaVenta,
        total: total,
        iva5: iva5,
        iva19: iva10, // Usando iva19 para el 10%
        exento: 0,
        tipoPago: tipoPago,
        idHabitacion: habitacionId,
        tipoVenta: 'Habitacion',
        productos: JSON.stringify(carrito.map(item => ({
            idProducto: item.idProducto,
            cantidad: item.cantidad,
            precioUnitario: item.precioUnitario
        })))
    });
    
    try {
        console.log('📤 Enviando venta al servidor...');
        console.log('FormData:', Object.fromEntries(formData));
        
        const response = await fetch('ventas', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        
        console.log('Response status:', response.status);
        const result = await response.json();
        console.log('Response result:', result);
        
        if (result.success) {
            mostrarNotificacion('✅ Venta procesada correctamente');
            carrito = [];
            actualizarCarrito();
            calcularTotal();
            document.getElementById('formVenta').reset();
            
            // Recargar datos y actualizar grid cards
            console.log('Recargando datos después de venta...');
            await cargarDatos();
        } else {
            console.error('Error en respuesta:', result);
            mostrarNotificacion('❌ Error: ' + (result.error || 'Error al procesar venta'), 'error');
        }
    } catch (error) {
        console.error('❌ Error al procesar venta:', error);
        mostrarNotificacion('❌ Error: ' + error.message, 'error');
    }
}

function filtrarVentas() {
    const habitacionId = document.getElementById('filtroHabitacion').value;
    renderizarHistorial(habitacionId);
}

function renderizarHistorial(habitacionId = null) {
    const historialDiv = document.getElementById('historialVentas');
    let ventasFiltradas = ventas;
    
    if (habitacionId) {
        ventasFiltradas = ventas.filter(v => v.idHabitacion == habitacionId);
    }
    
    if (ventasFiltradas.length === 0) {
        historialDiv.innerHTML = '<p class="text-gray-500 text-center py-8">No hay ventas registradas</p>';
        return;
    }
    
    // Ordenar ventas por fecha descendente (más recientes primero)
    ventasFiltradas = ventasFiltradas.sort((a, b) => new Date(b.fecha) - new Date(a.fecha));
    
    historialDiv.innerHTML = `
        <div class="overflow-x-auto">
            <table class="w-full text-sm">
                <thead class="bg-gray-100 sticky top-0">
                    <tr>
                        <th class="px-4 py-2 text-left">Habitación</th>
                        <th class="px-4 py-2 text-left">Fecha</th>
                        <th class="px-4 py-2 text-left">Hora</th>
                        <th class="px-4 py-2 text-left">Pago</th>
                        <th class="px-4 py-2 text-right">Total</th>
                    </tr>
                </thead>
                <tbody>
                    ${ventasFiltradas.map(v => {
                        const fecha = new Date(v.fecha);
                        const fechaFormato = fecha.toLocaleDateString('es-ES');
                        const horaFormato = fecha.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' });
                        const habitacion = habitaciones.find(h => h.id == v.idHabitacion);
                        
                        return `
                            <tr class="border-b hover:bg-gray-50">
                                <td class="px-4 py-3 font-semibold">Hab. ${habitacion ? habitacion.idHabitacion : 'N/A'}</td>
                                <td class="px-4 py-3 text-gray-600">${fechaFormato}</td>
                                <td class="px-4 py-3 text-gray-600">${horaFormato}</td>
                                <td class="px-4 py-3 text-gray-600">${v.tipoPago}</td>
                                <td class="px-4 py-3 text-right font-bold text-green-600">${formatearMoneda(v.total)}</td>
                            </tr>
                        `;
                    }).join('')}
                </tbody>
            </table>
        </div>
    `;
}

