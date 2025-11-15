// Gestión de Ventas a Habitaciones

let productos = [];
let habitaciones = [];
let ventas = [];
let carrito = [];

document.addEventListener('DOMContentLoaded', () => {
    console.log('Ventas - Inicializando...');
    cargarDatos();
    // Actualizar grid cards cada 5 segundos
    setInterval(actualizarGridCards, 5000);
});

async function cargarDatos() {
    try {
        console.log('Cargando datos de ventas...');
        
        [productos, habitaciones, ventas] = await Promise.all([
            fetchData('productos?action=disponibles').catch(e => { console.error('Error productos:', e); return []; }),
            fetchData('habitaciones?action=listar').catch(e => { console.error('Error habitaciones:', e); return []; }),
            fetchData('ventas?action=listar').catch(e => { console.error('Error ventas:', e); return []; })
        ]);
        
        productos = productos || [];
        habitaciones = habitaciones || [];
        ventas = ventas || [];
        
        console.log('✓ Datos cargados:', { productos: productos.length, habitaciones: habitaciones.length, ventas: ventas.length });
        
        // Actualizar grid cards
        actualizarGridCards();
        
        console.log('✓ Grid cards actualizadas');
        
        // Llenar selects
        const selectProducto = document.getElementById('productoVenta');
        selectProducto.innerHTML = '<option value="">Seleccione un producto</option>' +
            productos.map(p => `<option value="${p.id}" data-precio="${p.precioVenta}" data-iva="${p.iva}">${p.descripcion} - ${formatearMoneda(p.precioVenta)}</option>`).join('');
        
        const selectHabitacion = document.getElementById('habitacionVenta');
        selectHabitacion.innerHTML = '<option value="">Seleccione una habitación</option>' +
            habitaciones.map(h => `<option value="${h.id}">${h.idHabitacion} - ${h.tipoHabitacion}</option>`).join('');
        
        const filtroHabitacion = document.getElementById('filtroHabitacion');
        if (filtroHabitacion) {
            filtroHabitacion.innerHTML = '<option value="">Todas</option>' +
                habitaciones.map(h => `<option value="${h.id}">${h.idHabitacion}</option>`).join('');
        }
        
        selectProducto.addEventListener('change', (e) => {
            const option = e.target.options[e.target.selectedIndex];
            if (option.value) {
                document.getElementById('precioUnitario').value = option.dataset.precio;
            }
        });
        
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
    const cantidad = parseInt(document.getElementById('cantidad').value);
    const precioUnitario = parseFloat(document.getElementById('precioUnitario').value);
    
    if (!productoId || cantidad <= 0) {
        mostrarNotificacion('Seleccione un producto y cantidad válida', 'error');
        return;
    }
    
    const producto = productos.find(p => p.id == productoId);
    if (!producto) return;
    
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
    if (carrito.length === 0) {
        carritoDiv.innerHTML = '<p class="text-gray-500 text-center">No hay productos en el carrito</p>';
        return;
    }
    
    carritoDiv.innerHTML = carrito.map((item, index) => `
        <div class="flex justify-between items-center border-b pb-2 mb-2">
            <div>
                <p class="font-semibold">${item.descripcion}</p>
                <p class="text-sm text-gray-600">Cantidad: ${item.cantidad} x ${formatearMoneda(item.precioUnitario)}</p>
            </div>
            <button onclick="eliminarDelCarrito(${index})" class="text-red-600 hover:text-red-800">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `).join('');
}

function eliminarDelCarrito(index) {
    carrito.splice(index, 1);
    actualizarCarrito();
    calcularTotal();
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
    
    if (carrito.length === 0) {
        mostrarNotificacion('Agregue productos al carrito', 'error');
        return;
    }
    
    const habitacionId = document.getElementById('habitacionVenta').value;
    if (!habitacionId) {
        mostrarNotificacion('Seleccione una habitación', 'error');
        return;
    }
    
    const tipoPago = document.getElementById('tipoPago').value;
    
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
    
    const formData = new URLSearchParams({
        action: 'insertar',
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
        const response = await fetch('ventas', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: formData
        });
        const result = await response.json();
        
        if (result.success) {
            mostrarNotificacion('✓ Venta procesada correctamente');
            carrito = [];
            actualizarCarrito();
            calcularTotal();
            document.getElementById('formVenta').reset();
            
            // Recargar datos y actualizar grid cards
            console.log('Recargando datos después de venta...');
            await cargarDatos();
        } else {
            mostrarNotificacion('Error al procesar venta', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        mostrarNotificacion('Error al procesar venta', 'error');
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

