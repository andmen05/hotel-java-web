// Gestión del Dashboard

async function cargarDatosCheckinsHoy() {
    try {
        const checkIns = await fetchData('checkin?action=activos');
        const checkInsArray = checkIns || [];
        
        console.log('Check-ins cargados:', checkInsArray.length);
        
        // Actualizar número de check-ins hoy
        document.getElementById('checkinsHoy').textContent = checkInsArray.length;
        
        if (checkInsArray.length > 0) {
            const proximoCheckin = checkInsArray[0];
            const fecha = new Date(proximoCheckin.fechaIngresoCheckin).toLocaleString('es-ES');
            document.getElementById('proximoCheckin').textContent = `📅 ${fecha}`;
        } else {
            document.getElementById('proximoCheckin').textContent = '⏰ Sin check-ins';
        }
        
        // Actualizar lista de check-ins pendientes
        document.getElementById('countCheckinsP').textContent = checkInsArray.length + ' pendientes';
        
        if (checkInsArray.length === 0) {
            document.getElementById('listaCheckinsP').innerHTML = `
                <p class="text-gray-500 text-center py-8">
                    <i class="fas fa-inbox text-2xl text-gray-300 mb-2"></i><br>
                    No hay check-ins pendientes
                </p>
            `;
            return;
        }
        
        let html = '';
        checkInsArray.slice(0, 5).forEach(checkin => {
            const fecha = new Date(checkin.fechaIngresoCheckin).toLocaleString('es-ES', {
                hour: '2-digit',
                minute: '2-digit'
            });
            html += `
                <div class="flex items-start space-x-3 p-3 bg-green-50 rounded-lg border border-green-200 hover:bg-green-100 transition">
                    <div class="bg-green-500 p-2 rounded-lg flex-shrink-0">
                        <i class="fas fa-sign-in-alt text-white"></i>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="font-semibold text-sm text-gray-800">Check-in Hab. ${checkin.habitacion || 'N/A'}</p>
                        <p class="text-xs text-gray-600">Noches: ${checkin.noches || 1}</p>
                        <p class="text-xs text-green-600 mt-1">🕐 ${fecha}</p>
                    </div>
                </div>
            `;
        });
        
        document.getElementById('listaCheckinsP').innerHTML = html;
    } catch (error) {
        console.error('Error al cargar check-ins:', error);
        document.getElementById('checkinsHoy').textContent = '0';
        document.getElementById('countCheckinsP').textContent = '0 pendientes';
        document.getElementById('listaCheckinsP').innerHTML = `
            <p class="text-gray-500 text-center py-8">
                <i class="fas fa-exclamation-circle text-2xl text-red-300 mb-2"></i><br>
                Error al cargar check-ins
            </p>
        `;
    }
}

async function cargarDatosCheckoutsHoy() {
    try {
        // Obtener todos los check-ins activos
        const checkIns = await fetchData('checkin?action=activos');
        const checkInsArray = checkIns || [];
        
        // Filtrar los que tienen fecha de salida hoy
        const hoy = new Date();
        const checkOutsHoy = checkInsArray.filter(ci => {
            if (!ci.fechaSalidaChecking) return false;
            const fechaSalida = new Date(ci.fechaSalidaChecking);
            return fechaSalida.toDateString() === hoy.toDateString();
        });
        
        console.log('Check-outs hoy:', checkOutsHoy.length);
        
        document.getElementById('countCheckoutsH').textContent = checkOutsHoy.length + ' hoy';
        
        if (checkOutsHoy.length === 0) {
            document.getElementById('listaCheckoutsH').innerHTML = `
                <p class="text-gray-500 text-center py-8">
                    <i class="fas fa-inbox text-2xl text-gray-300 mb-2"></i><br>
                    No hay check-outs programados
                </p>
            `;
            return;
        }
        
        let html = '';
        checkOutsHoy.slice(0, 5).forEach(checkout => {
            const fecha = new Date(checkout.fechaSalidaChecking).toLocaleString('es-ES', {
                hour: '2-digit',
                minute: '2-digit'
            });
            html += `
                <div class="flex items-start space-x-3 p-3 bg-blue-50 rounded-lg border border-blue-200 hover:bg-blue-100 transition">
                    <div class="bg-blue-500 p-2 rounded-lg flex-shrink-0">
                        <i class="fas fa-sign-out-alt text-white"></i>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="font-semibold text-sm text-gray-800">Check-out Hab. ${checkout.habitacion || 'N/A'}</p>
                        <p class="text-xs text-gray-600">Noches: ${checkout.noches || 1}</p>
                        <p class="text-xs text-blue-600 mt-1">🕐 ${fecha}</p>
                    </div>
                </div>
            `;
        });
        
        document.getElementById('listaCheckoutsH').innerHTML = html;
    } catch (error) {
        console.error('Error al cargar check-outs:', error);
        document.getElementById('countCheckoutsH').textContent = '0 hoy';
        document.getElementById('listaCheckoutsH').innerHTML = `
            <p class="text-gray-500 text-center py-8">
                <i class="fas fa-exclamation-circle text-2xl text-red-300 mb-2"></i><br>
                Error al cargar check-outs
            </p>
        `;
    }
}

async function cargarActividadReciente() {
    try {
        // Obtener datos de múltiples fuentes
        const [checkIns, reservas, ventas] = await Promise.all([
            fetchData('checkin?action=listar').catch(() => []),
            fetchData('reservas?action=listar').catch(() => []),
            fetchData('ventas?action=listar').catch(() => [])
        ]);
        
        const actividades = [];
        
        // Agregar check-ins recientes (TODOS, no solo activos)
        (checkIns || []).forEach(ci => {
            actividades.push({
                tipo: 'checkin',
                titulo: 'Check-in realizado',
                descripcion: `Hab. ${ci.habitacion || 'N/A'} - ${ci.noches || 1} noches`,
                fecha: new Date(ci.fechaIngresoCheckin),
                icono: 'fa-sign-in-alt',
                color: 'bg-green-500'
            });
        });
        
        // Agregar reservas recientes
        (reservas || []).forEach(r => {
            actividades.push({
                tipo: 'reserva',
                titulo: 'Reserva ' + r.estado,
                descripcion: `Reserva #${r.id}`,
                fecha: new Date(r.fechaEntrada),
                icono: 'fa-calendar-check',
                color: 'bg-blue-500'
            });
        });
        
        // Agregar ventas recientes
        (ventas || []).forEach(v => {
            actividades.push({
                tipo: 'venta',
                titulo: 'Venta registrada',
                descripcion: `${formatearMoneda(v.total)} - ${v.tipoPago}`,
                fecha: new Date(v.fecha),
                icono: 'fa-shopping-cart',
                color: 'bg-purple-500'
            });
        });
        
        // Ordenar por fecha descendente (más recientes primero)
        actividades.sort((a, b) => b.fecha - a.fecha);
        
        console.log('✓ Actividades cargadas:', actividades.length);
        
        if (actividades.length === 0) {
            document.getElementById('actividadReciente').innerHTML = `
                <p class="text-purple-100 text-center py-8">
                    <i class="fas fa-inbox text-2xl text-purple-300 mb-2"></i><br>
                    No hay actividad registrada
                </p>
            `;
            return;
        }
        
        let html = '';
        // Mostrar solo las últimas 10 actividades
        actividades.slice(0, 10).forEach(act => {
            // Mostrar fecha exacta, no "hace unos segundos"
            const fechaFormato = act.fecha.toLocaleDateString('es-ES', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            });
            const horaFormato = act.fecha.toLocaleTimeString('es-ES', {
                hour: '2-digit',
                minute: '2-digit'
            });
            
            html += `
                <div class="flex items-start space-x-3 p-3 bg-purple-400 bg-opacity-30 rounded-lg hover:bg-opacity-50 transition cursor-pointer">
                    <div class="${act.color} p-2 rounded-lg flex-shrink-0">
                        <i class="fas ${act.icono} text-white"></i>
                    </div>
                    <div class="flex-1 min-w-0">
                        <p class="font-semibold text-sm">${act.titulo}</p>
                        <p class="text-xs text-purple-100 truncate">${act.descripcion}</p>
                        <p class="text-xs text-purple-200 mt-1">📅 ${fechaFormato} ${horaFormato}</p>
                    </div>
                </div>
            `;
        });
        
        document.getElementById('actividadReciente').innerHTML = html;
    } catch (error) {
        console.error('Error al cargar actividad reciente:', error);
        document.getElementById('actividadReciente').innerHTML = `
            <p class="text-purple-100 text-center py-8">
                <i class="fas fa-exclamation-circle text-2xl text-purple-300 mb-2"></i><br>
                Error al cargar actividad
            </p>
        `;
    }
}

async function cargarIngresosSemanales() {
    try {
        const ventas = await fetchData('ventas?action=listar');
        const ventasArray = ventas || [];
        
        console.log('Ventas para gráfico:', ventasArray.length);
        
        // Calcular ingresos por día de la semana
        const ingresosPorDia = {
            0: 0, // Domingo
            1: 0, // Lunes
            2: 0, // Martes
            3: 0, // Miércoles
            4: 0, // Jueves
            5: 0, // Viernes
            6: 0  // Sábado
        };
        
        ventasArray.forEach(venta => {
            const fecha = new Date(venta.fecha);
            const dia = fecha.getDay();
            ingresosPorDia[dia] += venta.total || 0;
        });
        
        // Obtener el día de hoy para calcular la semana actual
        const hoy = new Date();
        const primerDiaSemanaMostrada = new Date(hoy);
        primerDiaSemanaMostrada.setDate(hoy.getDate() - hoy.getDay());
        
        const diasSemana = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sab'];
        const maxIngreso = Math.max(...Object.values(ingresosPorDia), 1); // Al menos 1 para evitar división por 0
        
        let html = '';
        for (let i = 0; i < 7; i++) {
            const dia = (i) % 7;
            const ingreso = ingresosPorDia[dia];
            const porcentaje = (ingreso / maxIngreso) * 100;
            const altura = Math.max(porcentaje, 10); // Mínimo 10% para que sea visible
            
            html += `
                <div class="flex-1 flex flex-col items-center">
                    <div class="w-full bg-gradient-to-t from-blue-500 to-blue-400 rounded-t-lg opacity-70 hover:opacity-100 transition" 
                         style="height: ${altura}px; min-height: 30px;" 
                         title="${formatearMoneda(ingreso)}">
                    </div>
                    <p class="text-xs text-gray-600 mt-2 font-semibold">${diasSemana[dia]}</p>
                    <p class="text-xs text-gray-500">${formatearMoneda(ingreso)}</p>
                </div>
            `;
        }
        
        document.getElementById('chartIngresosWeek').innerHTML = html;
    } catch (error) {
        console.error('Error al cargar ingresos semanales:', error);
        document.getElementById('chartIngresosWeek').innerHTML = `
            <div class="w-full text-center py-8 text-gray-500">
                <i class="fas fa-exclamation-circle text-2xl mb-2"></i><br>
                Error al cargar gráfico
            </div>
        `;
    }
}

async function actualizarReservasConfirmadas() {
    try {
        const reservas = await fetchData('reservas?action=listar');
        const reservasArray = reservas || [];
        
        // Filtrar reservas confirmadas
        const reservasConfirmadas = reservasArray.filter(r => r.estado === 'Confirmada').length;
        const proximaReserva = reservasArray.filter(r => r.estado === 'Confirmada').length;
        
        // Actualizar grid card
        document.getElementById('reservasConfirmadas').textContent = reservasConfirmadas;
        document.getElementById('variacionReservas').textContent = `📅 ${proximaReserva} activas`;
        
        console.log('✓ Reservas confirmadas:', reservasConfirmadas);
    } catch (error) {
        console.error('Error al actualizar reservas:', error);
        document.getElementById('reservasConfirmadas').textContent = '0';
        document.getElementById('variacionReservas').textContent = '📅 Error';
    }
}

function getHoraRelativa(fecha) {
    const ahora = new Date();
    const diferencia = ahora - fecha;
    const minutos = Math.floor(diferencia / 60000);
    const horas = Math.floor(diferencia / 3600000);
    const dias = Math.floor(diferencia / 86400000);
    
    if (minutos < 1) return 'Hace unos segundos';
    if (minutos < 60) return `Hace ${minutos} min`;
    if (horas < 24) return `Hace ${horas} hora${horas > 1 ? 's' : ''}`;
    if (dias < 7) return `Hace ${dias} día${dias > 1 ? 's' : ''}`;
    
    return fecha.toLocaleDateString('es-ES');
}
