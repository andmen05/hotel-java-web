// Gestión del Top Bar - Menú de Usuario

document.addEventListener('DOMContentLoaded', () => {
    // Agregar evento al avatar para mostrar/ocultar menú
    const avatarBtn = document.getElementById('avatarBtn');
    const userMenu = document.getElementById('userMenu');
    
    if (avatarBtn && userMenu) {
        avatarBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            userMenu.classList.toggle('hidden');
        });
        
        // Cerrar menú cuando se hace clic fuera
        document.addEventListener('click', (e) => {
            if (!avatarBtn.contains(e.target) && !userMenu.contains(e.target)) {
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
    }
});
