package com.hotel.dao;

import com.hotel.modelo.Usuario;
import com.hotel.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

public class UsuarioDAO {
    private Connection conexion;
    private boolean usarBCrypt = false;

    public UsuarioDAO() {
        conexion = Conexion.getConexion();
        // Intentar cargar BCrypt, si está disponible se usará
        try {
            Class.forName("org.mindrot.jbcrypt.BCrypt");
            usarBCrypt = true;
        } catch (ClassNotFoundException e) {
            // BCrypt no disponible, usar hash simple
            usarBCrypt = false;
        }
    }

    public Usuario validarUsuario(String usuario, String password) {
        // Validar que la conexión no sea null
        if (conexion == null) {
            System.err.println("ERROR: La conexión a la base de datos es null.");
            System.err.println("Verifica:");
            System.err.println("  1. Que MySQL esté corriendo");
            System.err.println("  2. Que la base de datos 'sistema_hotel' exista");
            System.err.println("  3. Que el driver MySQL esté en WEB-INF/lib/");
            return null;
        }
        
        String sql = "SELECT * FROM proyecto_usuarios WHERE usuario = ? AND activo = 1";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, usuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashPassword = rs.getString("password");
                boolean passwordValido = false;
                
                if (usarBCrypt) {
                    // Usar BCrypt si está disponible
                    try {
                        passwordValido = org.mindrot.jbcrypt.BCrypt.checkpw(password, hashPassword);
                    } catch (Exception e) {
                        // Si falla BCrypt, intentar con hash simple
                        passwordValido = validarPasswordSimple(password, hashPassword);
                    }
                } else {
                    // Usar validación simple (para desarrollo)
                    passwordValido = validarPasswordSimple(password, hashPassword);
                }
                
                if (passwordValido) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setUsuario(rs.getString("usuario"));
                    u.setNombre(rs.getString("nombre"));
                    u.setRol(rs.getString("rol"));
                    u.setActivo(rs.getBoolean("activo"));
                    return u;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al validar usuario: " + e.getMessage());
        }
        return null;
    }
    
    private boolean validarPasswordSimple(String password, String hashAlmacenado) {
        // Para desarrollo: comparación simple
        // En producción, usar BCrypt o SHA-256
        return password.equals(hashAlmacenado);
    }
    
    // Método para generar hash SHA-256 (opcional, más seguro que comparación directa)
    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            return password; // Fallback a texto plano si falla
        }
    }
}

