package com.hotel.dao;

import com.hotel.modelo.CheckIn;
import com.hotel.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class CheckInDAO {
    private Connection conexion;

    public CheckInDAO() {
        conexion = Conexion.getConexion();
    }

    public boolean insertar(CheckIn checkIn) {
        String sql = "INSERT INTO proyecto_checkin (fecha_ingreso_chekin, fecha_salida_cheking, noches, habitacion, id_cliente, transporte, motivo_viaje, procedencia, acompanantes, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setTimestamp(1, checkIn.getFechaIngresoCheckin());
            ps.setTimestamp(2, checkIn.getFechaSalidaChecking());
            ps.setInt(3, checkIn.getNoches());
            ps.setInt(4, checkIn.getHabitacion());
            ps.setInt(5, checkIn.getIdCliente());
            ps.setString(6, checkIn.getTransporte());
            ps.setString(7, checkIn.getMotivoViaje());
            ps.setString(8, checkIn.getProcedencia());
            ps.setInt(9, checkIn.getAcompanantes());
            ps.setString(10, checkIn.getEstado());
            
            boolean resultado = ps.executeUpdate() > 0;
            
            // IMPORTANTE: Actualizar estado de habitación a OCUPADA
            if (resultado) {
                actualizarEstadoHabitacion(checkIn.getHabitacion(), "Ocupada", checkIn.getIdCliente());
                System.out.println("✓ Check-in registrado - Habitación " + checkIn.getHabitacion() + " marcada como OCUPADA");
            }
            
            return resultado;
        } catch (SQLException e) {
            System.err.println("Error al insertar check-in: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(CheckIn checkIn) {
        String sql = "UPDATE proyecto_checkin SET fecha_ingreso_chekin=?, fecha_salida_cheking=?, noches=?, habitacion=?, id_cliente=?, transporte=?, motivo_viaje=?, procedencia=?, acompanantes=?, estado=? WHERE id_checkin=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setTimestamp(1, checkIn.getFechaIngresoCheckin());
            ps.setTimestamp(2, checkIn.getFechaSalidaChecking());
            ps.setInt(3, checkIn.getNoches());
            ps.setInt(4, checkIn.getHabitacion());
            ps.setInt(5, checkIn.getIdCliente());
            ps.setString(6, checkIn.getTransporte());
            ps.setString(7, checkIn.getMotivoViaje());
            ps.setString(8, checkIn.getProcedencia());
            ps.setInt(9, checkIn.getAcompanantes());
            ps.setString(10, checkIn.getEstado());
            ps.setInt(11, checkIn.getIdCheckin());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar check-in: " + e.getMessage());
            return false;
        }
    }

    public boolean hacerCheckOut(int idCheckin, Timestamp fechaSalida) {
        String sql = "UPDATE proyecto_checkin SET fecha_salida_cheking=?, estado='Finalizado' WHERE id_checkin=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setTimestamp(1, fechaSalida);
            ps.setInt(2, idCheckin);
            
            boolean resultado = ps.executeUpdate() > 0;
            
            // IMPORTANTE: Obtener habitación del check-in y marcarla como DISPONIBLE
            if (resultado) {
                CheckIn checkIn = buscarPorId(idCheckin);
                if (checkIn != null) {
                    actualizarEstadoHabitacion(checkIn.getHabitacion(), "Disponible", null);
                    System.out.println("✓ Check-out realizado - Habitación " + checkIn.getHabitacion() + " marcada como DISPONIBLE");
                }
            }
            
            return resultado;
        } catch (SQLException e) {
            System.err.println("Error al hacer check-out: " + e.getMessage());
            return false;
        }
    }
    
    private boolean actualizarEstadoHabitacion(int habitacionId, String nuevoEstado, Integer idCliente) {
        String sql = "UPDATE proyecto_habitaciones SET estado=?, id_cliente=? WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setObject(2, idCliente);
            ps.setInt(3, habitacionId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar estado de habitación: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM proyecto_checkin WHERE id_checkin=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar check-in: " + e.getMessage());
            return false;
        }
    }

    public CheckIn buscarPorId(int id) {
        String sql = "SELECT * FROM proyecto_checkin WHERE id_checkin=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearCheckIn(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar check-in: " + e.getMessage());
        }
        return null;
    }

    public List<CheckIn> listarTodos() {
        List<CheckIn> checkIns = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_checkin ORDER BY fecha_ingreso_chekin DESC";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                checkIns.add(mapearCheckIn(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar check-ins: " + e.getMessage());
        }
        return checkIns;
    }

    public List<CheckIn> listarActivos() {
        List<CheckIn> checkIns = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_checkin WHERE estado = 'Activo' ORDER BY fecha_ingreso_chekin DESC";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                checkIns.add(mapearCheckIn(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar check-ins activos: " + e.getMessage());
        }
        return checkIns;
    }

    private CheckIn mapearCheckIn(ResultSet rs) throws SQLException {
        CheckIn ci = new CheckIn();
        ci.setIdCheckin(rs.getInt("id_checkin"));
        ci.setFechaIngresoCheckin(rs.getTimestamp("fecha_ingreso_chekin"));
        ci.setFechaSalidaChecking(rs.getTimestamp("fecha_salida_cheking"));
        ci.setNoches(rs.getInt("noches"));
        ci.setHabitacion(rs.getInt("habitacion"));
        ci.setIdCliente(rs.getInt("id_cliente"));
        ci.setTransporte(rs.getString("transporte"));
        ci.setMotivoViaje(rs.getString("motivo_viaje"));
        ci.setProcedencia(rs.getString("procedencia"));
        ci.setAcompanantes(rs.getInt("acompanantes"));
        ci.setEstado(rs.getString("estado"));
        return ci;
    }
}

