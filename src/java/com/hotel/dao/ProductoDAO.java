package com.hotel.dao;

import com.hotel.modelo.Producto;
import com.hotel.util.Conexion;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {
    private Connection conexion;

    public ProductoDAO() {
        conexion = Conexion.getConexion();
    }

    public boolean insertar(Producto producto) {
        String sql = "INSERT INTO proyecto_productos (codigo, descripcion, precioVenta, precioCompra, iva, existencia, id_usuario, cod_categoria, vencimiento) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, producto.getCodigo());
            ps.setString(2, producto.getDescripcion());
            ps.setDouble(3, producto.getPrecioVenta());
            ps.setDouble(4, producto.getPrecioCompra());
            ps.setInt(5, producto.getIva());
            ps.setInt(6, producto.getExistencia());
            ps.setLong(7, producto.getIdUsuario());
            ps.setInt(8, producto.getCodCategoria());
            ps.setDate(9, producto.getVencimiento());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar producto: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizar(Producto producto) {
        String sql = "UPDATE proyecto_productos SET codigo=?, descripcion=?, precioVenta=?, precioCompra=?, iva=?, existencia=?, id_usuario=?, cod_categoria=?, vencimiento=? WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, producto.getCodigo());
            ps.setString(2, producto.getDescripcion());
            ps.setDouble(3, producto.getPrecioVenta());
            ps.setDouble(4, producto.getPrecioCompra());
            ps.setInt(5, producto.getIva());
            ps.setInt(6, producto.getExistencia());
            ps.setLong(7, producto.getIdUsuario());
            ps.setInt(8, producto.getCodCategoria());
            ps.setDate(9, producto.getVencimiento());
            ps.setLong(10, producto.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar producto: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminar(long id) {
        String sql = "DELETE FROM proyecto_productos WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al eliminar producto: " + e.getMessage());
            return false;
        }
    }

    public Producto buscarPorId(long id) {
        String sql = "SELECT * FROM proyecto_productos WHERE id=?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapearProducto(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar producto: " + e.getMessage());
        }
        return null;
    }

    public List<Producto> listarTodos() {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_productos ORDER BY descripcion";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                productos.add(mapearProducto(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar productos: " + e.getMessage());
        }
        return productos;
    }

    public List<Producto> listarDisponibles() {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_productos WHERE existencia > 0 ORDER BY descripcion";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                productos.add(mapearProducto(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar productos disponibles: " + e.getMessage());
        }
        return productos;
    }

    private Producto mapearProducto(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setId(rs.getLong("id"));
        p.setCodigo(rs.getString("codigo"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecioVenta(rs.getDouble("precioVenta"));
        p.setPrecioCompra(rs.getDouble("precioCompra"));
        p.setIva(rs.getInt("iva"));
        p.setExistencia(rs.getInt("existencia"));
        p.setIdUsuario(rs.getLong("id_usuario"));
        p.setCodCategoria(rs.getInt("cod_categoria"));
        p.setVencimiento(rs.getDate("vencimiento"));
        return p;
    }
}

