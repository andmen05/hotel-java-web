# 🏨 Sistema de Gestión Hotelero

Un sistema completo de gestión hotelera desarrollado con **Java (JSP)**, **JavaScript** y **Tailwind CSS**. Diseñado para administrar habitaciones, reservas, clientes, check-ins, productos, ventas y reportes en tiempo real.

---

## ✨ Características Principales

### 👥 Gestión de Usuarios
- **Autenticación segura** con sesiones
- **Perfil de usuario** con foto personalizada
- **Cambio de contraseña** seguro
- **Actividad reciente** en tiempo real
- **Avatar global** sincronizado en todas las páginas

### 🛏️ Gestión de Habitaciones
- Visualización de todas las habitaciones
- Estados: Disponible, Ocupada, Mantenimiento
- Filtrado y búsqueda avanzada
- Información detallada por habitación

### 📅 Gestión de Reservas
- Crear, editar y cancelar reservas
- Calendario interactivo
- Validación de fechas
- Historial de reservas

### 👤 Gestión de Clientes
- Base de datos de clientes
- Búsqueda y filtrado
- Información de contacto
- Historial de reservas por cliente

### ✅ Check-in / Check-out
- Registro de entrada y salida
- Generación de facturas
- Historial de huéspedes
- Estados de ocupación en tiempo real

### 🛒 Gestión de Productos
- Catálogo de productos/servicios
- Precios y disponibilidad
- Categorización

### 💰 Gestión de Ventas
- Ventas a habitaciones
- Registro de transacciones
- Historial de ventas
- Cálculo de totales

### 📊 Reportes y Análisis
- **KPIs en tiempo real:**
  - Ocupación de habitaciones
  - Ingresos totales
  - Clientes activos
  - Reservas pendientes
  - Check-ins activos
- Gráficos y estadísticas
- Exportación de datos

---

## 🛠️ Tecnologías Utilizadas

### Backend
- **Java 8+**
- **JSP (JavaServer Pages)**
- **Servlets**
- **JDBC**
- **MySQL 

### Frontend
- **HTML5**
- **CSS3 / Tailwind CSS**
- **JavaScript (Vanilla)**
- **Font Awesome Icons**

### Herramientas
- **NetBeans IDE**
- **Apache Tomcat 11**
- **Git & GitHub**

---

## 📋 Requisitos Previos

- **Java JDK 8 o superior**
- **Apache Tomcat 9 o superior**
- **MySQL 5.7 o superior** (o MariaDB)
- **NetBeans IDE** (recomendado)
- **Git**

---

## 🚀 Instalación

### 1. Clonar el Repositorio
```bash
git clone https://github.com/tu-usuario/sistema-HOTEL.git
cd sistema-HOTEL
```

### 2. Configurar la Base de Datos
```sql
-- Crear base de datos
CREATE DATABASE hotel_db;
USE hotel_db;

-- Importar esquema (si existe archivo SQL)
SOURCE database/schema.sql;
```

### 3. Configurar Conexión a BD
Editar archivo de configuración (si existe):
```
web/WEB-INF/config.properties
```

O en el código Java:
```java
String url = "jdbc:mysql://localhost:3306/hotel_db";
String usuario = "root";
String password = "tu_password";
```

### 4. Compilar y Desplegar
```bash
# En NetBeans:
# 1. Abrir proyecto
# 2. Clean and Build
# 3. Run

# O desde línea de comandos:
mvn clean install
```

### 5. Acceder a la Aplicación
```
http://localhost:8080/sistema-HOTEL
```

---

## 📁 Estructura del Proyecto

```
sistema-HOTEL/
├── src/
│   └── java/com/hotel/
│       ├── modelo/          # Clases de modelo (Usuario, Habitacion, etc)
│       ├── dao/             # Data Access Objects
│       ├── servlet/         # Servlets
│       └── util/            # Utilidades
├── web/
│   ├── index.jsp            # Página de login
│   ├── dashboard.jsp        # Dashboard principal
│   ├── perfil.jsp           # Perfil de usuario
│   ├── habitaciones.jsp     # Gestión de habitaciones
│   ├── reservas.jsp         # Gestión de reservas
│   ├── clientes.jsp         # Gestión de clientes
│   ├── checkin.jsp          # Check-in / Check-out
│   ├── productos.jsp        # Gestión de productos
│   ├── ventas.jsp           # Gestión de ventas
│   ├── reportes.jsp         # Reportes y análisis
│   ├── js/                  # Scripts JavaScript
│   │   ├── common.js        # Funciones comunes
│   │   ├── avatar-global.js # Gestión de avatar global
│   │   ├── perfil.js        # Lógica de perfil
│   │   ├── actividad-perfil.js
│   │   ├── topbar.js        # Menú desplegable
│   │   ├── clientes.js
│   │   ├── habitaciones.js
│   │   ├── reservas.js
│   │   ├── checkin.js
│   │   ├── productos.js
│   │   ├── ventas.js
│   │   ├── reportes.js
│   │   └── ...
│   ├── css/                 # Estilos CSS
│   └── WEB-INF/
│       └── web.xml          # Configuración web
└── database/
    └── schema.sql           # Esquema de base de datos
```

---

## 🔐 Autenticación

### Credenciales de Prueba
```
Usuario: admin
Contraseña: admin123
```

> ⚠️ **Importante:** Cambiar credenciales en producción

---

## 📱 Funcionalidades Principales

### Dashboard
- Vista general del sistema
- KPIs en tiempo real
- Acceso rápido a módulos

### Perfil de Usuario
- Información personal
- Foto de perfil (almacenada en localStorage)
- Cambio de contraseña
- Actividad reciente
- Menú desplegable con opciones

### Módulos de Gestión
Cada módulo incluye:
- ✅ Listado con búsqueda y filtrado
- ✅ Crear nuevo registro
- ✅ Editar registro existente
- ✅ Eliminar registro
- ✅ Validaciones en cliente y servidor

---

## 🎨 Diseño y UI

- **Interfaz moderna** con Tailwind CSS
- **Responsive design** (mobile, tablet, desktop)
- **Iconos profesionales** con Font Awesome
- **Colores consistentes** (Indigo/Blue)
- **Animaciones suaves** y transiciones
- **Notificaciones** de éxito/error

---

## 🔄 Flujos Principales

### Reserva de Habitación
```
Cliente → Buscar Habitación → Crear Reserva → Confirmar → Check-in → Check-out
```

### Venta de Producto
```
Seleccionar Habitación → Agregar Producto → Calcular Total → Registrar Venta
```

### Reporte
```
Seleccionar Período → Generar Datos → Visualizar Gráficos → Exportar
```

---

## 📊 Base de Datos

### Tablas Principales
- `usuarios` - Usuarios del sistema
- `habitaciones` - Habitaciones del hotel
- `reservas` - Reservas de clientes
- `clientes` - Información de clientes
- `checkins` - Registros de entrada/salida
- `productos` - Productos/servicios
- `ventas` - Transacciones de ventas

---

## 🐛 Debugging

### Logs en Consola
Abrir F12 en el navegador para ver:
- Inicialización de módulos
- Carga de datos
- Errores de validación
- Actualizaciones de avatar

### Logs del Servidor
Ver en Tomcat:
```
CATALINA_HOME/logs/catalina.out
```

---

## 🚀 Deployment

### Producción
1. Cambiar credenciales de BD
2. Configurar HTTPS
3. Minificar CSS/JS
4. Usar CDN para recursos
5. Configurar backups automáticos

### Variables de Entorno
```bash
export DB_HOST=localhost
export DB_PORT=3306
export DB_NAME=hotel_db
export DB_USER=root
export DB_PASSWORD=secure_password
```

---

## 📝 Notas Importantes


### Actividad Reciente
- Se carga en tiempo real
- Muestra últimas acciones del usuario
- Se actualiza cada 10 segundos


---

## 👨‍💻 Autor

**andmen05** - Desarrollador Full Stack

---

## 📞 Soporte

Para reportar bugs o sugerencias:
- 📧 Email: andmen05dev@gmail.com

---

## ⭐ Si te fue útil, ¡no olvides dar una estrella!

```
⭐ Star this repo if you find it helpful!
```

---

**Última actualización:** Noviembre 2025
**Versión:** 1.0.0
**Estado:** En desarrollo activo ✅
