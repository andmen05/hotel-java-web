// Gestión del Top Bar - Menú de Usuario

document.addEventListener('DOMContentLoaded', () => {
    // Agregar evento al avatar para mostrar/ocultar menú
    const avatarBtn = document.getElementById('avatarBtn');
    const userMenu = document.getElementById('userMenu');
    
    if (avatarBtn && userMenu) {
        avatarBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            e.preventDefault();
            userMenu.classList.toggle('hidden');
        });
        
        // Cerrar menú cuando se hace clic fuera
        document.addEventListener('click', (e) => {
            // Verificar si el clic fue fuera del avatar y del menú
            const clickedAvatar = avatarBtn.contains(e.target) || avatarBtn === e.target;
            const clickedMenu = userMenu.contains(e.target) || userMenu === e.target;
            
            if (!clickedAvatar && !clickedMenu) {
                userMenu.classList.add('hidden');
            }
        });
        
        // Cerrar menú cuando se hace clic en una opción
        const menuItems = userMenu.querySelectorAll('a, button');
        menuItems.forEach(item => {
            item.addEventListener('click', () => {
                userMenu.classList.add('hidden');
            });
        });
    } else {
        console.warn('Avatar o menú de usuario no encontrado');
    }
});
