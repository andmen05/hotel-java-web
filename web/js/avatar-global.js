// Gestión Global del Avatar en todas las páginas

document.addEventListener('DOMContentLoaded', () => {
    console.log('Avatar Global - Inicializando...');
    
    // Cargar y mostrar foto guardada en TODOS los avatares
    cargarFotoGlobalEnTodoLado();
    
    // Actualizar cada 500ms para detectar cambios rápidamente
    setInterval(cargarFotoGlobalEnTodoLado, 500);
});

function cargarFotoGlobalEnTodoLado() {
    const fotoPerfil = localStorage.getItem('fotoPerfil');
    console.log('Avatar Global - Buscando foto:', fotoPerfil ? 'Encontrada (' + fotoPerfil.length + ' bytes)' : 'No encontrada');
    
    if (fotoPerfil) {
        // 1. Actualizar avatar en top bar (en cualquier página)
        const avatarBtn = document.getElementById('avatarBtn');
        if (avatarBtn) {
            const img = avatarBtn.querySelector('img');
            if (!img) {
                console.log('✓ Actualizando avatar en top bar');
                avatarBtn.innerHTML = `<img src="${fotoPerfil}" alt="Foto de Perfil" class="w-full h-full object-cover rounded-full">`;
                avatarBtn.style.backgroundImage = 'none';
                avatarBtn.style.color = 'transparent';
            }
        }
        
        // 2. Actualizar avatar en perfil por ID (más específico)
        const avatarPerfil = document.getElementById('avatarPerfil');
        if (avatarPerfil) {
            const img = avatarPerfil.querySelector('img');
            if (!img) {
                console.log('✓ Actualizando avatar en perfil (por ID)');
                avatarPerfil.innerHTML = `<img src="${fotoPerfil}" alt="Foto de Perfil" class="w-full h-full object-cover">`;
            }
        } else {
            console.log('⚠ Avatar en perfil no encontrado por ID');
        }
    }
}

// Función para actualizar foto desde perfil.js
function actualizarFotoGlobal(imgData) {
    console.log('Actualizando foto global');
    localStorage.setItem('fotoPerfil', imgData);
    cargarFotoGlobalEnTodoLado();
}
