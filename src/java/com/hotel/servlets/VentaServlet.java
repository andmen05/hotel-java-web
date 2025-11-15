package com.hotel.servlets;

import com.hotel.dao.VentaDAO;
import com.hotel.modelo.Venta;
import com.hotel.modelo.ProductoVendido;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "VentaServlet", urlPatterns = {"/ventas"})
public class VentaServlet extends HttpServlet {
    private VentaDAO ventaDAO = new VentaDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        String habitacionParam = request.getParameter("habitacion");

        try {
            if ("listar".equals(action)) {
                List<Venta> ventas = ventaDAO.listarTodas();
                out.print(gson.toJson(ventas));
            } else if ("porHabitacion".equals(action) && habitacionParam != null) {
                List<Venta> ventas = ventaDAO.listarPorHabitacion(Integer.parseInt(habitacionParam));
                out.print(gson.toJson(ventas));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Acción no válida\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");

        try {
            if ("insertar".equals(action)) {
                Venta venta = new Venta();
                venta.setFecha(new Timestamp(System.currentTimeMillis()));
                venta.setTotal(Double.parseDouble(request.getParameter("total")));
                venta.setIva5(Double.parseDouble(request.getParameter("iva5")));
                venta.setIva19(Double.parseDouble(request.getParameter("iva19")));
                venta.setExento(Double.parseDouble(request.getParameter("exento")));
                venta.setTipoPago(request.getParameter("tipoPago"));
                String idClienteStr = request.getParameter("idCliente");
                venta.setIdCliente(idClienteStr != null && !idClienteStr.isEmpty() ? Integer.parseInt(idClienteStr) : null);
                String idHabitacionStr = request.getParameter("idHabitacion");
                venta.setIdHabitacion(idHabitacionStr != null && !idHabitacionStr.isEmpty() ? Integer.parseInt(idHabitacionStr) : null);
                venta.setTipoVenta(request.getParameter("tipoVenta"));

                // Obtener productos vendidos desde JSON
                String productosJson = request.getParameter("productos");
                List<ProductoVendido> productos = gson.fromJson(productosJson, new TypeToken<List<ProductoVendido>>(){}.getType());

                long idVenta = ventaDAO.insertarVentaConProductos(venta, productos);
                if (idVenta > 0) {
                    out.print("{\"success\":true, \"idVenta\":" + idVenta + "}");
                } else {
                    out.print("{\"success\":false, \"error\":\"Error al insertar venta\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Acción no válida\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
        out.flush();
    }
}

