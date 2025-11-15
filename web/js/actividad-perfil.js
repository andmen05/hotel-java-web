// Gestión de Actividad Reciente en Perfil

document.addEventListener('DOMContentLoaded', () => {
    console.log('Actividad Perfil - Inicializando...');
    cargarActividadReciente();
    
    // Actualizar actividad cada 10 segundos
    setInterval(cargarActividadReciente, 10000);
});

async function cargarActividadReciente() {
    try {
        console.log('Cargando actividad reciente...');
        
        // Obtener datos de diferentes fuentes
        const [checkinsData, reservasData, ventasData] = await Promise.all([
            fetchData('checkin?action=listar').catch(e => { console.error('Error checkins:', e); return []; }),
            fetchData('reservas?action=listar').catch(e => { console.error('Error reservas:', e); return []; }),
            fetchData('ventas?action=listar').catch(e => { console.error('Error ventas:', e); return []; })
        ]);
        
        const actividades = [];
        
        // Procesar check-ins
        if (checkinsData && Array.isArray(checkinsData)) {
            checkinsData.slice(0, 3).forEach(checkin => {
                actividades.push({
                    tipo: 'checkin',
                    titulo: 'Check-in realizado',
                    descripcion: 'Habitación #' + (checkin.habitacion || 'N/A'),
                    icono: 'fa-sign-in-alt',
                    color: 'green',
                    fecha: checkin.fechaCheckin || new Date().toLocaleString()
                });
            });
        }
        
        // Procesar reservas
        if (reservasData && Array.isArray(reservasData)) {
            reservasData.slice(0, 2).forEach(reserva => {
                actividades.push({
                    tipo: 'reserva',
                    titulo: 'Reserva confirmada',
                    descripcion: 'Reserva #' + (reserva.id || 'N/A'),
                    icono: 'fa-calendar-check',
                    color: 'blue',
                    fecha: reserva.fechaReserva || new Date().toLocaleString()
                });
            });
        }
        
        // Procesar ventas
        if (ventasData && Array.isArray(ventasData)) {
            ventasData.slice(0, 2).forEach(venta => {
                actividades.push({
                    tipo: 'venta',
                    titulo: 'Compra realizada',
                    descripcion: '$' + (venta.total || '0'),
                    icono: 'fa-shopping-cart',
                    color: 'yellow',
                    fecha: venta.fecha || new Date().toLocaleString()
                });
            });
        }
        
        // Agregar evento de inicio de sesión al principio
        actividades.unshift({
            tipo: 'login',
            titulo: 'Inicio de sesión',
            descripcion: 'Acceso a la plataforma',
            icono: 'fa-sign-in-alt',
            color: 'green',
            fecha: 'Hace 5 minutos'
        });
        
        // Renderizar actividades
        renderizarActividadReciente(actividades);
        
    } catch (error) {
        console.error('Error al cargar actividad reciente:', error);
    }
}

function renderizarActividadReciente(actividades) {
    const container = document.getElementById('actividadRecienteContainer');
    if (!container) {
        console.log('Contenedor de actividad no encontrado');
        return;
    }
    
    if (actividades.length === 0) {
        container.innerHTML = `
            <div class="text-center py-8">
                <p class="text-gray-500">No hay actividad reciente</p>
            </div>
        `;
        return;
    }
    
    const coloresMap = {
        green: 'bg-green-100 text-green-600',
        blue: 'bg-blue-100 text-blue-600',
        yellow: 'bg-yellow-100 text-yellow-600',
        red: 'bg-red-100 text-red-600',
        purple: 'bg-purple-100 text-purple-600'
    };
    
    container.innerHTML = actividades.slice(0, 5).map(actividad => `
        <div class="flex items-center space-x-3 pb-3 border-b border-gray-200">
            <div class="w-10 h-10 ${coloresMap[actividad.color] || coloresMap.blue} rounded-full flex items-center justify-center flex-shrink-0">
                <i class="fas ${actividad.icono}"></i>
            </div>
            <div class="flex-1 min-w-0">
                <p class="text-sm font-semibold text-gray-800">${actividad.titulo}</p>
                <p class="text-xs text-gray-500">${actividad.descripcion}</p>
            </div>
            <p class="text-xs text-gray-400 whitespace-nowrap">${actividad.fecha}</p>
        </div>
    `).join('');
    
    console.log('✓ Actividad reciente renderizada:', actividades.length, 'eventos');
}
