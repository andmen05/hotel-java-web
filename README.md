# 🏨 Sistema de Gestión Hotelero

Un sistema web integral para la administración completa de operaciones hoteleras. Desarrollado con **Java**, **JSP**, **Servlets** y **MySQL**, ofrece funcionalidades robustas para gestionar habitaciones, reservas, clientes, check-ins, productos y ventas en tiempo real.

---

## 📋 Tabla de Contenidos

- [Características Principales](#-características-principales)
- [Tecnologías](#-tecnologías)
- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Base de Datos](#-base-de-datos)
- [Configuración](#-configuración)
- [Funcionalidades por Página](#-funcionalidades-por-página)
- [Troubleshooting](#-troubleshooting)
- [JARs necesarios y cómo cargarlos en NetBeans](#-jars-necesarios-y-cómo-cargarlos-en-netbeans)
- [Al bajar desde GitHub: archivos que suelen faltar](#-al-bajar-desde-github-archivos-que-suelen-faltar-y-cómo-resolverlo-en-netbeans)
- [Soporte](#-soporte)
- [Autor](#-autor)

---

## ✨ Características Principales

### 🔐 Autenticación y Usuarios
- Sistema de login con sesiones HTTP
- Tres roles de usuario: Administrador, Recepcionista, Cajero
- Perfil de usuario con foto personalizada
- Avatar sincronizado globalmente en todas las páginas
- Control de acceso basado en roles

### 🛏️ Gestión de Habitaciones
- Listado completo de habitaciones con búsqueda
- Estados: Disponible, Ocupada, Mantenimiento
- Asignación de clientes a habitaciones
- Información detallada por cuarto (tipo, capacidad, precio)
- Visualización de ocupación en tiempo real

### 📅 Gestión de Reservas
- CRUD completo de reservas
- Validación de fechas de entrada y salida
- Tipos de reserva: Airbnb, Otro
- Estados: Pendiente, Confirmada, Cancelada, Finalizada
- Historial de reservas por cliente

### 👥 Gestión de Clientes
- Base de datos centralizada de huéspedes
- Búsqueda y filtrado avanzado
- Información completa: nombre, documento, correo, teléfono, dirección
- Vinculación con reservas y check-ins
- Historial de estancias

### ✅ Check-in / Check-out
- Registro detallado de entrada y salida
- Cálculo automático de noches
- Información del huésped: transporte, motivo del viaje, acompañantes
- Generación de registros de ocupación
- Historial de huéspedes

### 🛒 Gestión de Productos y Servicios
- Catálogo de productos/servicios del hotel
- Organización por categorías
- Control de precios (venta y compra)
- Gestión de inventario
- Cálculo automático de IVA

### 💰 Gestión de Ventas
- Registro de transacciones de servicios
- Vinculación con habitaciones
- Cálculo de totales y pagos
- Historial de ventas por período
- Reportes de ingresos

### 📊 Dashboard y Reportes
- KPIs en tiempo real:
  - Total de habitaciones y disponibilidad
  - Clientes registrados
  - Reservas activas
  - Ventas del día
- Estadísticas visuales
- Análisis de ocupación

---

## 🛠️ Tecnologías

### Backend
| Tecnología | Versión | Propósito |
|-----------|---------|----------|
| **Java** | 8+ | Lenguaje principal |
| **JSP** | 2.3+ | Vistas dinámicas |
| **Servlets** | Jakarta EE 6.0 | Controladores |
| **JDBC** | - | Acceso a datos |
| **MySQL** | 5.7+ | Base de datos relacional |

### Frontend
| Tecnología | Propósito |
|-----------|----------|
| **HTML5** | Estructura |
| **Tailwind CSS** | Estilos y diseño responsivo |
| **JavaScript (Vanilla)** | Interactividad sin dependencias |
| **Font Awesome** | Iconografía |

### Herramientas
| Herramienta | Propósito |
|-----------|----------|
| **NetBeans IDE** | Entorno de desarrollo |
| **Apache Tomcat 11** | Servidor de aplicaciones |
| **Ant** | Herramienta de build |
| **Git** | Control de versiones |

---

## 📋 Requisitos

### Sistema
- **Windows**, **macOS** o **Linux**
- **Java Development Kit (JDK) 8 o superior**
- **Apache Tomcat 9 o superior**
- **MySQL 5.7 o superior** (o MariaDB compatible)

### Dependencias
- **MySQL Connector/J 8.0.33** (debe estar en `web/WEB-INF/lib/`)
- **Navegador web moderno** (Chrome, Firefox, Safari, Edge)

### Recomendado
- **NetBeans IDE 11+** para desarrollo
- **MySQL Workbench** para administración de BD

---

## 🚀 Instalación

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/andmen05/hotel-java-web.git
cd hotel-java-web
```

### Paso 2: Configurar la Base de Datos

1. **Abrir MySQL CLI o Workbench**

2. **Ejecutar el script SQL:**
```bash
mysql -u root -p < database/sistema_hotel.sql
```

O manualmente en MySQL:
```sql
SOURCE database/sistema_hotel.sql;
```

3. **Verificar la creación:**
```sql
SHOW DATABASES;
USE sistema_hotel;
SHOW TABLES;
```

### Paso 3: Preparar el Controlador MySQL

1. Descargar [MySQL Connector/J 8.0.33](https://dev.mysql.com/downloads/connector/j/)
2. Extraer el archivo JAR
3. Copiar a: `web/WEB-INF/lib/mysql-connector-java-8.0.33.jar`

### Paso 4: Compilar y Desplegar

**En NetBeans:**
1. Abrir proyecto en NetBeans
2. Menú: `Run → Clean and Build Project`
3. Menú: `Run → Run Project`
4. Se abrirá automáticamente en `http://localhost:8080/hotel-java-web`

**Desde Terminal (Ant):**
```bash
ant clean
ant build
# Desplegar WAR en Tomcat manualmente
cp build/hotel-java-web.war $TOMCAT_HOME/webapps/
```

### Paso 5: Verificar Instalación

Acceder a: `http://localhost:8080/hotel-java-web`

Debería ver la página de login.

---

## 📁 Estructura del Proyecto

```
hotel-java-web/
├── src/
│   └── java/com/hotel/
│       ├── dao/                    # Data Access Objects (CRUD)
│       │   ├── CategoriaDAO.java
│       │   ├── CheckInDAO.java
│       │   ├── ClienteDAO.java
│       │   ├── HabitacionDAO.java
│       │   ├── ProductoDAO.java
│       │   ├── ReservaDAO.java
│       │   ├── UsuarioDAO.java
│       │   └── VentaDAO.java
│       │
│       ├── modelo/                 # Clases de Modelo (POJO)
│       │   ├── Categoria.java
│       │   ├── CheckIn.java
│       │   ├── Cliente.java
│       │   ├── Habitacion.java
│       │   ├── Producto.java
│       │   ├── ProductoVendido.java
│       │   ├── Reserva.java
│       │   ├── Usuario.java
│       │   └── Venta.java
│       │
│       ├── servlets/               # Controladores HTTP
│       │   ├── CheckInServlet.java
│       │   ├── ClienteServlet.java
│       │   ├── HabitacionServlet.java
│       │   ├── LoginServlet.java
│       │   ├── LogoutServlet.java
│       │   ├── ProductoServlet.java
│       │   ├── ReporteServlet.java
│       │   ├── ReservaServlet.java
│       │   └── VentaServlet.java
│       │
│       └── util/                   # Utilidades
│           └── Conexion.java       # Gestor de conexión MySQL
│
├── web/                            # Archivos web
│   ├── index.jsp                   # Página de login

│   ├── dashboard.jsp               # Panel principal

│   ├── clientes.jsp                # Gestión de clientes
│   ├── habitaciones.jsp            # Gestión de habitaciones
│   ├── reservas.jsp                # Gestión de reservas
│   ├── checkin.jsp                 # Check-in/Check-out
│   ├── productos.jsp               # Gestión de productos
│   ├── ventas.jsp                  # Gestión de ventas
│   ├── reportes.jsp                # Reportes y análisis
│   ├── perfil.jsp                  # Perfil de usuario
│   │
│   ├── js/                         # Scripts JavaScript
│   │   ├── common.js               # Funciones compartidas
│   │   ├── avatar-global.js        # Sincronización de avatar
│   │   ├── topbar.js               # Menú de navegación
│   │   ├── perfil.js               # Lógica de perfil
│   │   ├── clientes.js
│   │   ├── habitaciones.js
│   │   ├── reservas.js
│   │   ├── checkin.js
│   │   ├── productos.js
│   │   ├── ventas.js
│   │   ├── reportes.js
│   │   └── actividad-perfil.js
│   │
│   ├── css/                        # Estilos CSS (si existen)
│   │
│   ├── WEB-INF/
│   │   ├── web.xml                 # Configuración de Servlets
│   │   ├── context.xml             # Contexto de la aplicación
│   │   └── lib/                    # Librerías Java (JAR)
│   │       └── mysql-connector-java-8.0.33.jar
│   │
│   └── META-INF/
│       ├── context.xml
│       └── MANIFEST.MF
│
├── database/
│   └── sistema_hotel.sql           # Script SQL inicial
│
├── build.xml                       # Configuración de Ant
├── README.md                       # Este archivo
└── nbproject/                      # Configuración NetBeans
```

---



## 🗄️ Base de Datos

`database/sistema_hotel.sql`

---

## ⚙️ Configuración

### Conexión a Base de Datos

El archivo `src/java/com/hotel/util/Conexion.java` contiene la configuración:

```java
private static final String URL = "jdbc:mysql://localhost:3306/sistema_hotel?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
private static final String USER = "root";
private static final String PASSWORD = "";
```

**Para cambiar credenciales:**
1. Editar `Conexion.java`
2. Actualizar `URL`, `USER`, `PASSWORD`
3. Recompilar con `ant clean build`

### Sesiones HTTP

Timeout configurado en `web/WEB-INF/web.xml`:
```xml
<session-timeout>30</session-timeout>
```

(30 minutos)

---

## 🔐 Autenticación

### Credenciales por Defecto

Después de ejecutar el script SQL, dispone de usuarios de prueba. Consulte la tabla `proyecto_usuarios`.


### Métodos de Validación de Contraseña


### Roles y Permisos

- **Administrador**: Acceso completo

---

## 📱 Funcionalidades por Página

### Dashboard
- Estadísticas de habitaciones (total, disponibles, ocupadas)
- Total de clientes
- Total de reservas
- Ventas del día
- Navegación a todos los módulos

### Clientes
- Listado con búsqueda
- Crear nuevo cliente (nombre, apellido, documento, correo, teléfono, dirección)
- Editar información
- Eliminar cliente
- Ver historial de reservas

### Habitaciones
- Listado con estado actualizado
- Crear nueva habitación (tipo, capacidad, precio)
- Asignar cliente
- Cambiar estado (Disponible, Ocupada, Mantenimiento)
- Filtrar por estado

### Reservas
- Crear reserva (cliente, habitación, fechas)
- Cambiar estado
- Validación de fechas
- Ver información del cliente y cuarto

### Check-in
- Registrar entrada (habitación, cliente, transporte, motivo)
- Cálculo automático de noches
- Registrar acompañantes
- Check-out (marcar como finalizado)
- Historial de huéspedes

### Productos
- Gestión de catálogo (código, descripción, precios)
- Organización por categoría
- Control de inventario
- Cálculo de IVA

### Ventas
- Registrar venta (habitación, producto, cantidad)
- Cálculo de total
- Historial de transacciones
- Reporte de ingresos

### Perfil
- Ver información personal
- Cambiar contraseña
- Subir foto de perfil (se guarda en localStorage)
- Ver actividad reciente

---



## 🎨 Diseño y UX

- **Interfaz**: Tailwind CSS con tema Indigo/Blue
- **Responsivo**: Funciona en desktop, tablet y móvil
- **Iconografía**: Font Awesome 6.4.0
- **Animaciones**: Transiciones suaves y notificaciones toast
- **Fuente**: Poppins en headers, sistema por defecto en texto
- **Colores**: Gradientes modernos y colores consistentes

---

## 🐛 Troubleshooting

### Error: "No se encontró el driver de MySQL"

**Causa**: Falta el archivo JAR de MySQL Connector

**Solución**:
1. Descargar [MySQL Connector/J 8.0.33](https://dev.mysql.com/downloads/connector/j/)
2. Copiar JAR a `web/WEB-INF/lib/`
3. Recompilar el proyecto

### Error: "Conexión rechazada a localhost:3306"

**Causa**: MySQL no está corriendo

**Solución**:
```bash
# Windows
net start MySQL80

# macOS
brew services start mysql

# Linux
sudo service mysql start
```

### Error: "Base de datos 'sistema_hotel' no existe"

**Causa**: El script SQL no se ejecutó

**Solución**:
```bash
mysql -u root -p < database/sistema_hotel.sql
```

### Contraseña incorrecta al conectar

Verificar credenciales en `src/java/com/hotel/util/Conexion.java`:
```java
private static final String USER = "root";      // Cambiar si es necesario
private static final String PASSWORD = "";      // Agregar si existe
```


---

## 📥 JARs para el funcionamiento del proyecto y cómo cargarlos en NetBeans

enlaces directos y pasos claros para que NetBeans los use correctamente:

- Enlaces de descarga:
  - `gson-2.10.1.jar` (Maven Central):
    - Página: https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/
    - JAR directo: https://repo1.maven.org/maven2/com/google/code/gson/gson/2.10.1/gson-2.10.1.jar
  - `jbcrypt-0.4.jar` (Maven Central):
    - Página: https://repo1.maven.org/maven2/org/mindrot/jbcrypt/0.4/
    - JAR directo: https://repo1.maven.org/maven2/org/mindrot/jbcrypt/0.4/jbcrypt-0.4.jar


1. Abre el proyecto en NetBeans.
2. En `Projects`, clic derecho sobre el proyecto → `Properties`.
3. Selecciona `Libraries`.
4. Pulsa `Add JAR/Folder` y selecciona los JARs descargados.
5. Si NetBeans muestra una casilla para "Copy to Project" o similar, márcala para que los JARs queden dentro del proyecto. Si no aparece esa opción, copia manualmente los JARs a `web/WEB-INF/lib` (ver pasos anteriores).
6. Haz `Clean and Build` para verificar que el WAR resultante incluye los JARs en `WEB-INF/lib`.

Consejo: durante `File → New Project → Java with Ant → Web Application with Existing Sources`, NetBeans a veces detecta bibliotecas faltantes y ofrece localizarlas o copiarlas al proyecto. Si aparece una advertencia `Missing Libraries`, usa `Resolve Missing Libraries` o añade manualmente desde `Project Properties → Libraries`.

**Nota importante (ubicación correcta de los JARs)**

- La ruta donde deben colocarse los JARs para que el proyecto los incluya al generar el WAR es:
  - web/WEB-INF/lib/
- Al compilar/desplegar, cualquier JAR dentro de web/WEB-INF/lib se empaqueta en WEB-INF/lib del WAR y estará disponible en el classpath de la aplicación.
- Opciones:
  - Copiarlos directamente a web/WEB-INF/lib (recomendado si no usas Maven/Gradle).
  - O crear una carpeta lib/ en la raíz del repo y añadir los JARs desde NetBeans (Project Properties → Libraries → Add JAR/Folder → marcar "Copy to Project" si existe).

Comandos (PowerShell) para comprobar y copiar JARs:
```powershell
# listar JARs actualmente en web/WEB-INF/lib
Get-ChildItem -Path .\web\WEB-INF\lib -File -Name

# copiar un JAR descargado al proyecto (ajusta la ruta origen)
Copy-Item -Path "C:\Users\TuUsuario\Downloads\gson-2.10.1.jar" -Destination ".\web\WEB-INF\lib\"

# después: limpiar y compilar
ant clean
ant build
```

- En NetBeans: Proyecto → clic derecho → Properties → Libraries → Add JAR/Folder → seleccionar los JARs (si aparece opción "Copy to Project", marcarla para que queden dentro del proyecto).
- Si importas el proyecto y NetBeans muestra "Missing Libraries", usar "Resolve Missing Libraries" y apuntar a la carpeta con los JARs.



## ⚠️ Al bajar desde GitHub: archivos que suelen faltar y cómo resolverlo en NetBeans

Cuando clonas el repositorio desde GitHub muchas veces faltan archivos o recursos que NetBeans y el despliegue esperan. 

1. Clona el repo y entra en la carpeta:

```powershell
git clone https://github.com/andmen05/hotel-java-web.git
cd hotel-java-web
```

2. Descargar y copiar JARs esenciales a `web/WEB-INF/lib` (si no están): `gson-2.10.1.jar`, `mysql-connector-java-<versión>.jar`, `jbcrypt-0.4.jar` (opcional).

3. Abrir NetBeans → `File → Open Project` o `New Project → Web Application with Existing Sources` y seleccionar la carpeta.

4. Si NetBeans muestra `Missing Libraries`, usar `Resolve Missing Libraries` o `Project Properties → Libraries → Add JAR/Folder` y marcar "Copy to Project" si existe.

5. Configurar servidor y JDK en NetBeans si pide: `Tools → Servers` (añadir Tomcat) y `Tools → Java Platforms` (seleccionar JDK instalado). Luego en `Project Properties → Run` asignar el servidor.

6. Ejecutar `Clean and Build` y luego `Run` desde NetBeans. Verificar en `http://localhost:8080/<context>`.


## 📞 Soporte

Para reportar bugs, sugerencias o consultas:

📧 **Email:** andmen05dev@gmail.com

---

## 📄 Licencia

Este proyecto está disponible bajo una licencia de uso personal y educativo.

---

## 👨‍💻 Autor

**andmen05** - Desarrollador Full Stack

---

**Última actualización:** Noviembre 2025  
**Versión:** 1.0.0  
**Estado:** En desarrollo activo ✅

