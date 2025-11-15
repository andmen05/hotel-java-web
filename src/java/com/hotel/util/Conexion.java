package com.hotel.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private static final String URL = "jdbc:mysql://localhost:3306/sistema_hotel?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    private static Connection conexion = null;

    public static Connection getConexion() {
        try {
            if (conexion == null || conexion.isClosed()) {
                // Intentar cargar el driver de MySQL
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                } catch (ClassNotFoundException e) {
                    System.err.println("ERROR: No se encontró el driver de MySQL.");
                    System.err.println("SOLUCIÓN: Agrega el JAR mysql-connector-java-8.0.33.jar a web/WEB-INF/lib/");
                    throw new RuntimeException("Driver de MySQL no encontrado. Verifica que el JAR esté en WEB-INF/lib/", e);
                }
                
                // Intentar conectar
                conexion = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("✓ Conexión a la base de datos establecida correctamente");
            }
        } catch (SQLException e) {
            System.err.println("ERROR al conectar a la base de datos:");
            System.err.println("  Mensaje: " + e.getMessage());
            System.err.println("  Código SQL: " + e.getSQLState());
            System.err.println("\nPOSIBLES SOLUCIONES:");
            System.err.println("  1. Verifica que MySQL esté corriendo");
            System.err.println("  2. Verifica que la base de datos 'sistema_hotel' exista");
            System.err.println("  3. Verifica usuario y contraseña en Conexion.java");
            System.err.println("  4. Ejecuta el script SQL: database/sistema_hotel.sql");
            e.printStackTrace();
            conexion = null; // Asegurar que sea null si falla
        }
        return conexion;
    }

    public static void cerrarConexion() {
        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
                conexion = null;
            }
        } catch (SQLException e) {
            System.err.println("Error al cerrar conexión: " + e.getMessage());
        }
    }
}

