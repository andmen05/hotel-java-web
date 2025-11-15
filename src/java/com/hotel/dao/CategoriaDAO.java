package com.hotel.dao;

import com.hotel.modelo.Categoria;
import com.hotel.util.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {
    private Connection conexion;

    public CategoriaDAO() {
        conexion = Conexion.getConexion();
    }

    public List<Categoria> listarTodas() {
        List<Categoria> categorias = new ArrayList<>();
        String sql = "SELECT * FROM proyecto_categoria ORDER BY detalle";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Categoria c = new Categoria();
                c.setCodCategoria(rs.getInt("cod_categoria"));
                c.setDetalle(rs.getString("detalle"));
                categorias.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar categorías: " + e.getMessage());
        }
        return categorias;
    }
}

