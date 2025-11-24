// Gestión del Perfil de Usuario

document.addEventListener('DOMContentLoaded', () => {
    console.log('Perfil - Inicializando...');

    // Crear input de archivo oculto
    const fileInput = document.createElement('input');
    fileInput.type = 'file';
    fileInput.id = 'fotoInput';
    fileInput.accept = 'image/*';
    fileInput.style.display = 'none';
    document.body.appendChild(fileInput);

    // Encontrar botón de subir foto por su contenido
    const buttons = document.querySelectorAll('button[type="button"]');
    let btnSubirFoto = null;

    buttons.forEach(btn => {
        if (btn.textContent.includes('Subir Foto')) {
            btnSubirFoto = btn;
        }
    });

    if (btnSubirFoto) {
        console.log('✓ Botón de subir foto encontrado');
        btnSubirFoto.addEventListener('click', (e) => {
            e.preventDefault();
            console.log('Click en botón subir foto');
            fileInput.click();
        });
    } else {
        console.error('ERROR: No se encontró botón de subir foto');
    }

    // Hacer que el avatar del header principal también sea clickeable
    const avatarHeader = document.getElementById('avatarPerfilHeader');
    if (avatarHeader) {
        console.log('✓ Avatar del header encontrado, haciéndolo clickeable');
        avatarHeader.style.cursor = 'pointer';
        avatarHeader.addEventListener('click', (e) => {
            e.preventDefault();
            console.log('Click en avatar del header');
            fileInput.click();
        });
    }

    // Manejar selección de archivo
    fileInput.addEventListener('change', (e) => {
        console.log('Archivo seleccionado');
        const file = e.target.files[0];
        if (file) {
            console.log('Archivo:', file.name, 'Tipo:', file.type, 'Tamaño:', file.size);

            // Validar tipo de archivo
            const tiposValidos = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
            if (!tiposValidos.includes(file.type)) {
                mostrarNotificacion('Por favor selecciona una imagen válida (JPG, PNG, GIF o WebP)', 'error');
                return;
            }

            // Validar tamaño (máx 5MB)
            const maxSize = 5 * 1024 * 1024; // 5MB
            if (file.size > maxSize) {
                mostrarNotificacion('La imagen no debe superar 5MB', 'error');
                return;
            }

            // Leer archivo y mostrar preview
            const reader = new FileReader();
            reader.onload = (event) => {
                const imgData = event.target.result;
                console.log('Imagen cargada, tamaño base64:', imgData.length);

                // Guardar en localStorage y actualizar globalmente
                actualizarFotoGlobal(imgData);

                mostrarNotificacion('✓ Foto de perfil actualizada correctamente');

                // Limpiar input
                fileInput.value = '';
            };
            reader.readAsDataURL(file);
        }
    });

    // Cargar foto guardada al iniciar
    cargarFotoGuardada();

    // Manejar formulario de contraseña
    const formContrasena = document.getElementById('formContrasena');
    if (formContrasena) {
        formContrasena.addEventListener('submit', (e) => {
            e.preventDefault();

            const contraseniaActual = document.getElementById('contraseniaActual').value;
            const contraseniaNueva = document.getElementById('contraseniaNueva').value;
            const contraseniaConfirmar = document.getElementById('contraseniaConfirmar').value;

            if (!contraseniaActual || !contraseniaNueva || !contraseniaConfirmar) {
                mostrarNotificacion('Por favor completa todos los campos', 'error');
                return;
            }

            if (contraseniaNueva !== contraseniaConfirmar) {
                mostrarNotificacion('Las contraseñas no coinciden', 'error');
                return;
            }

            if (contraseniaNueva.length < 6) {
                mostrarNotificacion('La contraseña debe tener al menos 6 caracteres', 'error');
                return;
            }

            mostrarNotificacion('✓ Contraseña cambiada correctamente', 'success');
            formContrasena.reset();
        });
    }
});

function cargarFotoGuardada() {
    // La foto se carga automáticamente desde avatar-global.js
    console.log('Foto guardada cargada desde localStorage');
}

function editarPerfil() {
    document.getElementById('infoPerfil').style.display = 'none';
    document.getElementById('formPerfil').style.display = 'block';
}

function cancelarEdicion() {
    document.getElementById('infoPerfil').style.display = 'block';
    document.getElementById('formPerfil').style.display = 'none';
}

function togglePassword(fieldId) {
    const field = document.getElementById(fieldId);
    if (field) {
        field.type = field.type === 'password' ? 'text' : 'password';
    }
}
