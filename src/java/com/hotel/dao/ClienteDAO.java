package com.hotel.dao;

import com.hotel.modelo.Cliente;
import com.hotel.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {
    private Connection conexion;

    public ClienteDAO() {
        conexion = Conexion.getConexion();
    }

    public boolean insertar(Cliente cliente) {
        String sql = "INSERT INTO proyecto_clientes (nombre, apellido, documento, correo, telefono, direccion) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, cliente.getNombre());
            ps.setString(2, cliente.getApellido());
            ps.setInt(3, cliente.getDocumento());
            ps.setString(4, cliente.getCorreo());
            ps.setString(5, cliente.getTelefono());
            ps.setString(6, cliente.getDireccion());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar cliente: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Cliente cliente) {
        String sql = "UPDATE proyecto_clientes SET nombre=?, apellido=?, documento=?, correo=?, telefono=?, direccion=? WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, cliente.getNombre());
            ps.setString(2, cliente.getApellido());
            ps.setInt(3, cliente.getDocumento());
            ps.setString(4, cliente.getCorreo());
            ps.setString(5, cliente.getTelefono());
            ps.setString(6, cliente.getDireccion());
            ps.setInt(7, cliente.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar cliente: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM proyecto_clientes WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar cliente: " + e.getMessage());
            return false;
        }
    }

    public Cliente buscarPorId(int id) {
        String sql = "SELECT * FROM proyecto_clientes WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearCliente(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar cliente: " + e.getMessage());
        }
        return null;
    }

    public List<Cliente> listarTodos() {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_clientes ORDER BY apellido, nombre";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                clientes.add(mapearCliente(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar clientes: " + e.getMessage());
        }
        return clientes;
    }

    public List<Cliente> buscarPorDocumento(int documento) {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_clientes WHERE documento LIKE ?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, "%" + documento + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                clientes.add(mapearCliente(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar cliente por documento: " + e.getMessage());
        }
        return clientes;
    }

    public int getTotalClientes() {
        String sql = "SELECT COUNT(*) as total FROM proyecto_clientes";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener total de clientes: " + e.getMessage());
        }
        return 0;
    }

    private Cliente mapearCliente(ResultSet rs) throws SQLException {
        Cliente c = new Cliente();
        c.setId(rs.getInt("id"));
        c.setNombre(rs.getString("nombre"));
        c.setApellido(rs.getString("apellido"));
        c.setDocumento(rs.getInt("documento"));
        c.setCorreo(rs.getString("correo"));
        c.setTelefono(rs.getString("telefono"));
        c.setDireccion(rs.getString("direccion"));
        return c;
    }
}

