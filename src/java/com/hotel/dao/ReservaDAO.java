package com.hotel.dao;

import com.hotel.modelo.Reserva;
import com.hotel.util.Conexion;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReservaDAO {
    private Connection conexion;

    public ReservaDAO() {
        conexion = Conexion.getConexion();
    }

    public boolean insertar(Reserva reserva) {
        String sql = "INSERT INTO proyecto_reservas (id_cliente, habitacion, fecha_entrada, fecha_salida, tipo_reserva, estado) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, reserva.getIdCliente());
            ps.setInt(2, reserva.getHabitacion());
            ps.setDate(3, reserva.getFechaEntrada());
            ps.setDate(4, reserva.getFechaSalida());
            ps.setString(5, reserva.getTipoReserva());
            ps.setString(6, reserva.getEstado());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar reserva: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Reserva reserva) {
        String sql = "UPDATE proyecto_reservas SET id_cliente=?, habitacion=?, fecha_entrada=?, fecha_salida=?, tipo_reserva=?, estado=? WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, reserva.getIdCliente());
            ps.setInt(2, reserva.getHabitacion());
            ps.setDate(3, reserva.getFechaEntrada());
            ps.setDate(4, reserva.getFechaSalida());
            ps.setString(5, reserva.getTipoReserva());
            ps.setString(6, reserva.getEstado());
            ps.setInt(7, reserva.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar reserva: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM proyecto_reservas WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar reserva: " + e.getMessage());
            return false;
        }
    }

    public Reserva buscarPorId(int id) {
        String sql = "SELECT * FROM proyecto_reservas WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearReserva(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar reserva: " + e.getMessage());
        }
        return null;
    }

    public List<Reserva> listarTodas() {
        List<Reserva> reservas = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_reservas ORDER BY fecha_entrada DESC";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                reservas.add(mapearReserva(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar reservas: " + e.getMessage());
        }
        return reservas;
    }

    public int getTotalReservas() {
        String sql = "SELECT COUNT(*) as total FROM proyecto_reservas";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener total de reservas: " + e.getMessage());
        }
        return 0;
    }

    private Reserva mapearReserva(ResultSet rs) throws SQLException {
        Reserva r = new Reserva();
        r.setId(rs.getInt("id"));
        r.setIdCliente(rs.getInt("id_cliente"));
        r.setHabitacion(rs.getInt("habitacion"));
        r.setFechaEntrada(rs.getDate("fecha_entrada"));
        r.setFechaSalida(rs.getDate("fecha_salida"));
        r.setTipoReserva(rs.getString("tipo_reserva"));
        r.setEstado(rs.getString("estado"));
        return r;
    }
}

