package com.hotel.dao;

import com.hotel.modelo.Habitacion;
import com.hotel.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class HabitacionDAO {
    private Connection conexion;

    public HabitacionDAO() {
        conexion = Conexion.getConexion();
    }

    public boolean insertar(Habitacion habitacion) {
        String sql = "INSERT INTO proyecto_habitaciones (id_habitacion, estado, id_cliente, tipo_habitacion, precio_noche, capacidad) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, habitacion.getIdHabitacion());
            ps.setString(2, habitacion.getEstado());
            ps.setObject(3, habitacion.getIdCliente());
            ps.setString(4, habitacion.getTipoHabitacion());
            ps.setDouble(5, habitacion.getPrecioNoche());
            ps.setInt(6, habitacion.getCapacidad());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar habitación: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Habitacion habitacion) {
        String sql = "UPDATE proyecto_habitaciones SET id_habitacion=?, estado=?, id_cliente=?, tipo_habitacion=?, precio_noche=?, capacidad=? WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, habitacion.getIdHabitacion());
            ps.setString(2, habitacion.getEstado());
            ps.setObject(3, habitacion.getIdCliente());
            ps.setString(4, habitacion.getTipoHabitacion());
            ps.setDouble(5, habitacion.getPrecioNoche());
            ps.setInt(6, habitacion.getCapacidad());
            ps.setInt(7, habitacion.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar habitación: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM proyecto_habitaciones WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar habitación: " + e.getMessage());
            return false;
        }
    }

    public Habitacion buscarPorId(int id) {
        String sql = "SELECT * FROM proyecto_habitaciones WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearHabitacion(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar habitación: " + e.getMessage());
        }
        return null;
    }

    public List<Habitacion> listarTodas() {
        List<Habitacion> habitaciones = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_habitaciones ORDER BY id_habitacion";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                habitaciones.add(mapearHabitacion(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar habitaciones: " + e.getMessage());
        }
        return habitaciones;
    }

    public List<Habitacion> listarDisponibles() {
        List<Habitacion> habitaciones = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_habitaciones WHERE estado = 'Disponible' ORDER BY id_habitacion";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                habitaciones.add(mapearHabitacion(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar habitaciones disponibles: " + e.getMessage());
        }
        return habitaciones;
    }

    public int getTotalHabitaciones() {
        String sql = "SELECT COUNT(*) as total FROM proyecto_habitaciones";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener total de habitaciones: " + e.getMessage());
        }
        return 0;
    }

    public int getHabitacionesDisponibles() {
        String sql = "SELECT COUNT(*) as total FROM proyecto_habitaciones WHERE estado = 'Disponible'";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener habitaciones disponibles: " + e.getMessage());
        }
        return 0;
    }

    private Habitacion mapearHabitacion(ResultSet rs) throws SQLException {
        Habitacion h = new Habitacion();
        h.setId(rs.getInt("id"));
        h.setIdHabitacion(rs.getString("id_habitacion"));
        h.setEstado(rs.getString("estado"));
        Integer idCliente = rs.getObject("id_cliente") != null ? rs.getInt("id_cliente") : null;
        h.setIdCliente(idCliente);
        h.setTipoHabitacion(rs.getString("tipo_habitacion"));
        h.setPrecioNoche(rs.getDouble("precio_noche"));
        h.setCapacidad(rs.getInt("capacidad"));
        return h;
    }
}

