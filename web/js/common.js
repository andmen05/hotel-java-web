// Utilidades comunes para el sistema hotelero

// Función para mostrar notificaciones
function mostrarNotificacion(mensaje, tipo = 'success') {
    const notification = document.createElement('div');
    notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg transform transition-all ${
        tipo === 'success' ? 'bg-green-500' : 'bg-red-500'
    } text-white`;
    notification.textContent = mensaje;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Función para formatear fechas
function formatearFecha(fecha) {
    if (!fecha) return '';
    const date = new Date(fecha);
    return date.toLocaleDateString('es-ES', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
    });
}

// Función para formatear moneda con formato colombiano personalizado
function formatearMoneda(valor) {
    // Convertir a número si es string
    const num = parseFloat(valor) || 0;
    
    // Redondear a número entero (sin decimales)
    const entero = Math.round(num).toString();
    
    // Agregar separador de miles con punto
    const conSeparador = entero.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    
    // Retornar con símbolo de peso
    return '$' + conSeparador;
}

// Función para hacer peticiones fetch con manejo de errores
async function fetchData(url, options = {}) {
    try {
        const response = await fetch(url, options);
        if (!response.ok) {
            throw new Error(`Error: ${response.status}`);
        }
        return await response.json();
    } catch (error) {
        console.error('Error en fetch:', error);
        mostrarNotificacion('Error al procesar la solicitud', 'error');
        throw error;
    }
}

// Función para confirmar eliminación
function confirmarEliminacion(callback) {
    if (confirm('¿Está seguro de que desea eliminar este registro?')) {
        callback();
    }
}

