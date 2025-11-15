package com.hotel.dao;

import com.hotel.modelo.Venta;
import com.hotel.modelo.ProductoVendido;
import com.hotel.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class VentaDAO {
    private Connection conexion;

    public VentaDAO() {
        conexion = Conexion.getConexion();
    }

    public long insertarVentaConProductos(Venta venta, List<ProductoVendido> productos) {
        Connection conn = null;
        try {
            conn = Conexion.getConexion();
            conn.setAutoCommit(false);

            // Insertar venta
            String sqlVenta = "INSERT INTO proyecto_ventas (fecha, total, iva5, iva19, exento, tipo_pago, id_cliente, id_habitacion, tipo_venta) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            long idVenta = 0;
            try (PreparedStatement ps = conn.prepareStatement(sqlVenta, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setTimestamp(1, venta.getFecha() != null ? venta.getFecha() : new Timestamp(System.currentTimeMillis()));
                ps.setDouble(2, venta.getTotal());
                ps.setDouble(3, venta.getIva5());
                ps.setDouble(4, venta.getIva19());
                ps.setDouble(5, venta.getExento());
                ps.setString(6, venta.getTipoPago());
                ps.setObject(7, venta.getIdCliente());
                ps.setObject(8, venta.getIdHabitacion());
                ps.setString(9, venta.getTipoVenta());
                ps.executeUpdate();
                
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    idVenta = rs.getLong(1);
                }
            }

            // Insertar productos vendidos y actualizar existencia
            String sqlProductoVendido = "INSERT INTO proyecto_productos_vendidos (id_producto, cantidad, id_venta, precio_unitario) VALUES (?, ?, ?, ?)";
            String sqlActualizarExistencia = "UPDATE proyecto_productos SET existencia = existencia - ? WHERE id = ?";
            
            for (ProductoVendido pv : productos) {
                // Insertar producto vendido
                try (PreparedStatement ps = conn.prepareStatement(sqlProductoVendido)) {
                    ps.setLong(1, pv.getIdProducto());
                    ps.setLong(2, pv.getCantidad());
                    ps.setLong(3, idVenta);
                    ps.setDouble(4, pv.getPrecioUnitario());
                    ps.executeUpdate();
                }

                // Actualizar existencia
                try (PreparedStatement ps = conn.prepareStatement(sqlActualizarExistencia)) {
                    ps.setLong(1, pv.getCantidad());
                    ps.setLong(2, pv.getIdProducto());
                    ps.executeUpdate();
                }
            }

            conn.commit();
            return idVenta;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                System.err.println("Error al hacer rollback: " + ex.getMessage());
            }
            System.err.println("Error al insertar venta: " + e.getMessage());
            return 0;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                System.err.println("Error al restaurar autocommit: " + e.getMessage());
            }
        }
    }

    public List<Venta> listarTodas() {
        List<Venta> ventas = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_ventas ORDER BY fecha DESC";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ventas.add(mapearVenta(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar ventas: " + e.getMessage());
        }
        return ventas;
    }

    public List<Venta> listarPorHabitacion(int idHabitacion) {
        List<Venta> ventas = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_ventas WHERE id_habitacion = ? ORDER BY fecha DESC";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, idHabitacion);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ventas.add(mapearVenta(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar ventas por habitación: " + e.getMessage());
        }
        return ventas;
    }

    public List<ProductoVendido> obtenerProductosVendidos(long idVenta) {
        List<ProductoVendido> productos = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_productos_vendidos WHERE id_venta = ?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setLong(1, idVenta);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductoVendido pv = new ProductoVendido();
                pv.setId(rs.getLong("id"));
                pv.setIdProducto(rs.getLong("id_producto"));
                pv.setCantidad(rs.getLong("cantidad"));
                pv.setIdVenta(rs.getLong("id_venta"));
                pv.setPrecioUnitario(rs.getDouble("precio_unitario"));
                productos.add(pv);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener productos vendidos: " + e.getMessage());
        }
        return productos;
    }

    public double getTotalVentasHoy() {
        String sql = "SELECT COALESCE(SUM(total), 0) as total FROM proyecto_ventas WHERE DATE(fecha) = CURDATE()";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener total de ventas hoy: " + e.getMessage());
        }
        return 0;
    }

    private Venta mapearVenta(ResultSet rs) throws SQLException {
        Venta v = new Venta();
        v.setId(rs.getLong("id"));
        v.setFecha(rs.getTimestamp("fecha"));
        v.setTotal(rs.getDouble("total"));
        v.setIva5(rs.getDouble("iva5"));
        v.setIva19(rs.getDouble("iva19"));
        v.setExento(rs.getDouble("exento"));
        v.setTipoPago(rs.getString("tipo_pago"));
        Integer idCliente = rs.getObject("id_cliente") != null ? rs.getInt("id_cliente") : null;
        v.setIdCliente(idCliente);
        Integer idHabitacion = rs.getObject("id_habitacion") != null ? rs.getInt("id_habitacion") : null;
        v.setIdHabitacion(idHabitacion);
        v.setTipoVenta(rs.getString("tipo_venta"));
        return v;
    }
}

