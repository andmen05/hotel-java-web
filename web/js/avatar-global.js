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
    
    if (fotoPerfil) {
        // 1. Actualizar avatar en top bar (en cualquier página)
        const avatarBtn = document.getElementById('avatarBtn');
        if (avatarBtn) {
            const img = avatarBtn.querySelector('img');
            if (!img) {
                // Guardar las clases originales del botón
                const originalClasses = avatarBtn.className;
                avatarBtn.innerHTML = `<img src="${fotoPerfil}" alt="Foto de Perfil" class="w-full h-full object-cover rounded-full">`;
                // Restaurar las clases del botón
                avatarBtn.className = originalClasses;
                avatarBtn.style.backgroundColor = 'transparent';
                avatarBtn.style.color = 'transparent';
            } else {
                // Actualizar la imagen si ya existe
                img.src = fotoPerfil;
            }
        }
        
        // 2. Actualizar avatar en perfil por ID (sidebar de foto de perfil)
        const avatarPerfil = document.getElementById('avatarPerfil');
        if (avatarPerfil) {
            const img = avatarPerfil.querySelector('img');
            if (!img) {
                avatarPerfil.innerHTML = `<img src="${fotoPerfil}" alt="Foto de Perfil" class="w-full h-full object-cover">`;
            } else {
                img.src = fotoPerfil;
            }
        }
        
        // 3. Actualizar avatar en el HEADER PRINCIPAL del perfil (el card grande)
        const avatarPerfilHeader = document.getElementById('avatarPerfilHeader');
        if (avatarPerfilHeader) {
            const img = avatarPerfilHeader.querySelector('img');
            if (!img) {
                avatarPerfilHeader.innerHTML = `<img src="${fotoPerfil}" alt="Foto de Perfil" class="w-full h-full object-cover rounded-2xl">`;
            } else {
                img.src = fotoPerfil;
            }
        }
    } else {
        // Si no hay foto, asegurarse de que el avatar muestre la inicial
        const avatarBtn = document.getElementById('avatarBtn');
        if (avatarBtn) {
            const img = avatarBtn.querySelector('img');
            if (img) {
                // Si hay una imagen pero no hay foto guardada, restaurar el estado original
                // Esto puede pasar si se borra el localStorage
                const initial = avatarBtn.getAttribute('data-initial');
                if (initial) {
                    avatarBtn.innerHTML = initial;
                    avatarBtn.style.backgroundColor = '';
                    avatarBtn.style.color = '';
                }
            }
        }
    }
}

// Función para actualizar foto desde perfil.js
function actualizarFotoGlobal(imgData) {
    console.log('Actualizando foto global');
    localStorage.setItem('fotoPerfil', imgData);
    cargarFotoGlobalEnTodoLado();
}
