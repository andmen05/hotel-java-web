// Gestión de Reportes

document.addEventListener('DOMContentLoaded', () => {
    console.log('📊 Reportes - Cargando KPIs en tiempo real');
    cargarKPIs();
    
    // Actualizar KPIs cada 5 segundos
    setInterval(cargarKPIs, 5000);
});

async function cargarKPIs() {
    try {
        console.log('Iniciando carga de KPIs...');
        
        // Cargar todos los datos en paralelo
        const [ocupacionData, ingresosData, clientesData, reservasData, ventasData, habitacionesData, checkinsActivosData] = await Promise.all([
            fetchData('reportes?tipo=ocupacion').catch(e => { console.error('Error ocupación:', e); return null; }),
            fetchData('reportes?tipo=ingresos').catch(e => { console.error('Error ingresos:', e); return null; }),
            fetchData('clientes?action=listar').catch(e => { console.error('Error clientes:', e); return null; }),
            fetchData('reservas?action=listar').catch(e => { console.error('Error reservas:', e); return null; }),
            fetchData('ventas?action=listar').catch(e => { console.error('Error ventas:', e); return null; }),
            fetchData('habitaciones?action=listar').catch(e => { console.error('Error habitaciones:', e); return null; }),
            fetchData('checkin?action=activos').catch(e => { console.error('Error check-ins activos:', e); return []; })
        ]);
        
        // 1. OCUPACIÓN - Porcentaje de habitaciones ocupadas
        // IMPORTANTE: Calcular desde check-ins activos + habitaciones ocupadas
        if (habitacionesData && checkinsActivosData) {
            const checkinsActivos = checkinsActivosData || [];
            const habitacionesOcupadasPorCheckin = checkinsActivos.map(c => c.habitacion);
            
            const ocupadas = habitacionesData.filter(h => 
                habitacionesOcupadasPorCheckin.includes(h.id) || h.estado === 'Ocupada'
            ).length;
            
            const totalHabitaciones = habitacionesData.length;
            const porcentaje = totalHabitaciones > 0 ? (ocupadas / totalHabitaciones) * 100 : 0;
            
            document.getElementById('ocupacion').textContent = Math.round(porcentaje) + '%';
            console.log('✓ Ocupación:', Math.round(porcentaje) + '% (' + ocupadas + '/' + totalHabitaciones + ' ocupadas)');
        } else if (ocupacionData) {
            const porcentaje = ocupacionData.porcentajeOcupacion || 0;
            document.getElementById('ocupacion').textContent = Math.round(porcentaje) + '%';
            console.log('✓ Ocupación:', porcentaje + '%');
        } else {
            document.getElementById('ocupacion').textContent = '0%';
        }
        
        // 2. INGRESOS TOTALES - Total de todas las ventas
        if (ventasData && ventasData.length > 0) {
            const totalIngresos = ventasData.reduce((sum, v) => sum + (v.total || 0), 0);
            document.getElementById('ingresos').textContent = formatearMoneda(totalIngresos);
            console.log('✓ Ingresos totales:', formatearMoneda(totalIngresos), '(' + ventasData.length + ' ventas)');
        } else {
            document.getElementById('ingresos').textContent = formatearMoneda(0);
            console.log('✓ Ingresos totales: $0 (sin ventas)');
        }
        
        // 3. CLIENTES ACTIVOS - Total de clientes registrados
        if (clientesData && Array.isArray(clientesData)) {
            const totalClientes = clientesData.length;
            document.getElementById('clientesActivos').textContent = totalClientes;
            console.log('✓ Clientes activos:', totalClientes);
        } else {
            document.getElementById('clientesActivos').textContent = '0';
            console.log('✓ Clientes activos: 0');
        }
        
        // 4. RESERVAS PENDIENTES - Reservas no canceladas en próximos 30 días
        if (reservasData && Array.isArray(reservasData)) {
            const hoy = new Date();
            hoy.setHours(0, 0, 0, 0);
            const treintaDias = new Date(hoy.getTime() + 30 * 24 * 60 * 60 * 1000);
            
            const reservasPendientes = reservasData.filter(r => {
                const fechaEntrada = new Date(r.fechaEntrada);
                fechaEntrada.setHours(0, 0, 0, 0);
                return fechaEntrada >= hoy && fechaEntrada <= treintaDias && r.estado !== 'Cancelada';
            }).length;
            
            document.getElementById('reservasPendientes').textContent = reservasPendientes;
            console.log('✓ Reservas pendientes (próximos 30 días):', reservasPendientes);
        } else {
            document.getElementById('reservasPendientes').textContent = '0';
            console.log('✓ Reservas pendientes: 0');
        }
        
        // 5. CHECK-INS ACTIVOS - Huéspedes actualmente en el hotel
        if (checkinsActivosData && Array.isArray(checkinsActivosData)) {
            const checkinsActivos = checkinsActivosData.length;
            
            console.log('✓ Check-ins activos:', checkinsActivos);
        }
        
        console.log('✓✓✓ TODOS LOS KPIs CARGADOS CORRECTAMENTE ✓✓✓');
    } catch (error) {
        console.error('Error al cargar KPIs:', error);
        mostrarNotificacion('Error al cargar datos de reportes', 'error');
    }
}

async function generarReporte(tipo) {
    try {
        console.log('Generando reporte de tipo:', tipo);
        const data = await fetchData(`reportes?tipo=${tipo}`);
        renderizarReporte(tipo, data);
        // Scroll al contenedor de reportes
        document.getElementById('contenidoReporte').scrollIntoView({ behavior: 'smooth' });
    } catch (error) {
        console.error('Error al generar reporte:', error);
        mostrarNotificacion('Error al generar reporte', 'error');
    }
}

function renderizarReporte(tipo, data) {
    const contenido = document.getElementById('contenidoReporte');
    
    // Si data es null o undefined, mostrar mensaje
    if (!data) {
        contenido.innerHTML = `
            <div class="p-6 bg-yellow-50 rounded-lg border border-yellow-200">
                <p class="text-yellow-800">No hay datos disponibles para este reporte</p>
            </div>
        `;
        return;
    }
    
    switch (tipo) {
        case 'ocupacion':
            contenido.innerHTML = `
                <h2 class="text-2xl font-bold mb-4">Reporte de Ocupación</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                    <div class="p-4 bg-green-50 rounded-lg border border-green-200">
                        <p class="text-sm text-gray-600">Disponibles</p>
                        <p class="text-3xl font-bold text-green-600">${data.disponibles || 0}</p>
                    </div>
                    <div class="p-4 bg-red-50 rounded-lg border border-red-200">
                        <p class="text-sm text-gray-600">Ocupadas</p>
                        <p class="text-3xl font-bold text-red-600">${data.ocupadas || 0}</p>
                    </div>
                    <div class="p-4 bg-orange-50 rounded-lg border border-orange-200">
                        <p class="text-sm text-gray-600">Mantenimiento</p>
                        <p class="text-3xl font-bold text-orange-600">${data.mantenimiento || 0}</p>
                    </div>
                </div>
                <div class="p-4 bg-blue-50 rounded-lg">
                    <p class="text-lg"><strong>Tasa de Ocupación:</strong> ${data.porcentajeOcupacion || 0}%</p>
                </div>
            `;
            break;
        case 'ingresos':
            contenido.innerHTML = `
                <h2 class="text-2xl font-bold mb-4">Reporte de Ingresos</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                    <div class="p-4 bg-green-50 rounded-lg border border-green-200">
                        <p class="text-sm text-gray-600">Total Ingresos</p>
                        <p class="text-2xl font-bold text-green-600">${formatearMoneda(data.totalIngresos || 0)}</p>
                    </div>
                    <div class="p-4 bg-blue-50 rounded-lg border border-blue-200">
                        <p class="text-sm text-gray-600">Ventas Hoy</p>
                        <p class="text-2xl font-bold text-blue-600">${formatearMoneda(data.ventasHoy || 0)}</p>
                    </div>
                    <div class="p-4 bg-purple-50 rounded-lg border border-purple-200">
                        <p class="text-sm text-gray-600">Promedio por Venta</p>
                        <p class="text-2xl font-bold text-purple-600">${formatearMoneda(data.promedioVenta || 0)}</p>
                    </div>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-200">
                            <tr>
                                <th class="px-4 py-2 text-left">Período</th>
                                <th class="px-4 py-2 text-left">Ingresos</th>
                                <th class="px-4 py-2 text-left">Cantidad Ventas</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${data.detalles && data.detalles.map(d => `
                                <tr class="border-b">
                                    <td class="px-4 py-2">${d.periodo}</td>
                                    <td class="px-4 py-2">${formatearMoneda(d.ingresos)}</td>
                                    <td class="px-4 py-2">${d.cantidad}</td>
                                </tr>
                            `).join('') || '<tr><td colspan="3" class="px-4 py-2 text-center">Sin datos</td></tr>'}
                        </tbody>
                    </table>
                </div>
            `;
            break;
        case 'ventas':
            contenido.innerHTML = `
                <h2 class="text-2xl font-bold mb-4">Reporte de Ventas</h2>
                <div class="mb-4 p-4 bg-blue-50 rounded-lg">
                    <p class="text-lg"><strong>Total de Ventas:</strong> ${data.cantidad}</p>
                    <p class="text-lg"><strong>Total Recaudado:</strong> ${formatearMoneda(data.total)}</p>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-200">
                            <tr>
                                <th class="px-4 py-2 text-left">ID</th>
                                <th class="px-4 py-2 text-left">Fecha</th>
                                <th class="px-4 py-2 text-left">Total</th>
                                <th class="px-4 py-2 text-left">Tipo Pago</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${data.ventas.map(v => `
                                <tr class="border-b">
                                    <td class="px-4 py-2">${v.id}</td>
                                    <td class="px-4 py-2">${new Date(v.fecha).toLocaleString('es-ES')}</td>
                                    <td class="px-4 py-2">${formatearMoneda(v.total)}</td>
                                    <td class="px-4 py-2">${v.tipoPago}</td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                </div>
            `;
            break;
        case 'checkins':
            contenido.innerHTML = `
                <h2 class="text-2xl font-bold mb-4">Reporte de Check-ins</h2>
                <div class="mb-4 p-4 bg-green-50 rounded-lg">
                    <p class="text-lg"><strong>Total de Check-ins:</strong> ${data.cantidad}</p>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-200">
                            <tr>
                                <th class="px-4 py-2 text-left">ID</th>
                                <th class="px-4 py-2 text-left">Fecha Ingreso</th>
                                <th class="px-4 py-2 text-left">Fecha Salida</th>
                                <th class="px-4 py-2 text-left">Noches</th>
                                <th class="px-4 py-2 text-left">Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${data.checkins.map(c => `
                                <tr class="border-b">
                                    <td class="px-4 py-2">${c.idCheckin}</td>
                                    <td class="px-4 py-2">${new Date(c.fechaIngresoCheckin).toLocaleString('es-ES')}</td>
                                    <td class="px-4 py-2">${c.fechaSalidaChecking ? new Date(c.fechaSalidaChecking).toLocaleString('es-ES') : 'Activo'}</td>
                                    <td class="px-4 py-2">${c.noches}</td>
                                    <td class="px-4 py-2">
                                        <span class="px-2 py-1 rounded text-xs ${c.estado === 'Activo' ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'}">
                                            ${c.estado}
                                        </span>
                                    </td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                </div>
            `;
            break;
        case 'reservas':
            contenido.innerHTML = `
                <h2 class="text-2xl font-bold mb-4">Reporte de Reservas</h2>
                <div class="mb-4 p-4 bg-yellow-50 rounded-lg">
                    <p class="text-lg"><strong>Total de Reservas:</strong> ${data.cantidad}</p>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-200">
                            <tr>
                                <th class="px-4 py-2 text-left">ID</th>
                                <th class="px-4 py-2 text-left">Fecha Entrada</th>
                                <th class="px-4 py-2 text-left">Fecha Salida</th>
                                <th class="px-4 py-2 text-left">Tipo</th>
                                <th class="px-4 py-2 text-left">Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${data.reservas.map(r => `
                                <tr class="border-b">
                                    <td class="px-4 py-2">${r.id}</td>
                                    <td class="px-4 py-2">${formatearFecha(r.fechaEntrada)}</td>
                                    <td class="px-4 py-2">${formatearFecha(r.fechaSalida)}</td>
                                    <td class="px-4 py-2">${r.tipoReserva}</td>
                                    <td class="px-4 py-2">
                                        <span class="px-2 py-1 rounded text-xs ${
                                            r.estado === 'Confirmada' ? 'bg-green-100 text-green-800' :
                                            r.estado === 'Cancelada' ? 'bg-red-100 text-red-800' :
                                            'bg-yellow-100 text-yellow-800'
                                        }">${r.estado}</span>
                                    </td>
                                </tr>
                            `).join('')}
                        </tbody>
                    </table>
                </div>
            `;
            break;
        case 'checkouts':
            contenido.innerHTML = `
                <h2 class="text-2xl font-bold mb-4">Reporte de Check-outs</h2>
                <div class="mb-4 p-4 bg-red-50 rounded-lg">
                    <p class="text-lg"><strong>Total de Check-outs:</strong> ${data.cantidad || 0}</p>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-200">
                            <tr>
                                <th class="px-4 py-2 text-left">ID</th>
                                <th class="px-4 py-2 text-left">Fecha Ingreso</th>
                                <th class="px-4 py-2 text-left">Fecha Salida</th>
                                <th class="px-4 py-2 text-left">Noches</th>
                                <th class="px-4 py-2 text-left">Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${(data.checkins || []).filter(c => c.estado === 'Finalizado').map(c => `
                                <tr class="border-b">
                                    <td class="px-4 py-2">${c.idCheckin}</td>
                                    <td class="px-4 py-2">${new Date(c.fechaIngresoCheckin).toLocaleString('es-ES')}</td>
                                    <td class="px-4 py-2">${c.fechaSalidaChecking ? new Date(c.fechaSalidaChecking).toLocaleString('es-ES') : 'N/A'}</td>
                                    <td class="px-4 py-2">${c.noches}</td>
                                    <td class="px-4 py-2">
                                        <span class="px-2 py-1 rounded text-xs bg-red-100 text-red-800">
                                            ${c.estado}
                                        </span>
                                    </td>
                                </tr>
                            `).join('') || '<tr><td colspan="5" class="px-4 py-2 text-center">Sin check-outs realizados</td></tr>'}
                        </tbody>
                    </table>
                </div>
            `;
            break;
    }
}

