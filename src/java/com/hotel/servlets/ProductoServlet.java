package com.hotel.servlets;

import com.hotel.dao.ProductoDAO;
import com.hotel.dao.CategoriaDAO;
import com.hotel.modelo.Producto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "ProductoServlet", urlPatterns = {"/productos"})
public class ProductoServlet extends HttpServlet {
    private ProductoDAO productoDAO = new ProductoDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        try {
            if ("listar".equals(action)) {
                List<Producto> productos = productoDAO.listarTodos();
                out.print(gson.toJson(productos));
            } else if ("disponibles".equals(action)) {
                List<Producto> productos = productoDAO.listarDisponibles();
                out.print(gson.toJson(productos));
            } else if ("categorias".equals(action)) {
                out.print(gson.toJson(categoriaDAO.listarTodas()));
            } else if ("buscar".equals(action) && idParam != null) {
                Producto producto = productoDAO.buscarPorId(Long.parseLong(idParam));
                out.print(gson.toJson(producto));
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
                Producto producto = new Producto();
                producto.setCodigo(request.getParameter("codigo"));
                producto.setDescripcion(request.getParameter("descripcion"));
                producto.setPrecioVenta(Double.parseDouble(request.getParameter("precioVenta")));
                producto.setPrecioCompra(Double.parseDouble(request.getParameter("precioCompra")));
                producto.setIva(Integer.parseInt(request.getParameter("iva")));
                producto.setExistencia(Integer.parseInt(request.getParameter("existencia")));
                producto.setIdUsuario(Long.parseLong(request.getParameter("idUsuario")));
                producto.setCodCategoria(Integer.parseInt(request.getParameter("codCategoria")));
                String vencimientoStr = request.getParameter("vencimiento");
                if (vencimientoStr != null && !vencimientoStr.trim().isEmpty()) {
                    try {
                        producto.setVencimiento(Date.valueOf(vencimientoStr));
                    } catch (IllegalArgumentException e) {
                        System.err.println("Error al parsear fecha de vencimiento: " + vencimientoStr);
                        producto.setVencimiento(null);
                    }
                } else {
                    producto.setVencimiento(null);
                }

                boolean resultado = productoDAO.insertar(producto);
                out.print("{\"success\":" + resultado + "}");
            } else if ("actualizar".equals(action)) {
                Producto producto = new Producto();
                producto.setId(Long.parseLong(request.getParameter("id")));
                producto.setCodigo(request.getParameter("codigo"));
                producto.setDescripcion(request.getParameter("descripcion"));
                producto.setPrecioVenta(Double.parseDouble(request.getParameter("precioVenta")));
                producto.setPrecioCompra(Double.parseDouble(request.getParameter("precioCompra")));
                producto.setIva(Integer.parseInt(request.getParameter("iva")));
                producto.setExistencia(Integer.parseInt(request.getParameter("existencia")));
                producto.setIdUsuario(Long.parseLong(request.getParameter("idUsuario")));
                producto.setCodCategoria(Integer.parseInt(request.getParameter("codCategoria")));
                String vencimientoStr = request.getParameter("vencimiento");
                if (vencimientoStr != null && !vencimientoStr.trim().isEmpty()) {
                    try {
                        producto.setVencimiento(Date.valueOf(vencimientoStr));
                    } catch (IllegalArgumentException e) {
                        System.err.println("Error al parsear fecha de vencimiento: " + vencimientoStr);
                        producto.setVencimiento(null);
                    }
                } else {
                    producto.setVencimiento(null);
                }

                boolean resultado = productoDAO.actualizar(producto);
                out.print("{\"success\":" + resultado + "}");
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
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String idParam = request.getParameter("id");

        try {
            if (idParam != null) {
                boolean resultado = productoDAO.eliminar(Long.parseLong(idParam));
                out.print("{\"success\":" + resultado + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"ID requerido\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
        out.flush();
    }
}

