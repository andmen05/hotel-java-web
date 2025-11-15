package com.hotel.servlets;

import com.hotel.dao.HabitacionDAO;
import com.hotel.modelo.Habitacion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;
import java.util.List;

@WebServlet(name = "HabitacionServlet", urlPatterns = {"/habitaciones"})
public class HabitacionServlet extends HttpServlet {
    private HabitacionDAO habitacionDAO = new HabitacionDAO();
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
                List<Habitacion> habitaciones = habitacionDAO.listarTodas();
                out.print(gson.toJson(habitaciones));
            } else if ("disponibles".equals(action)) {
                List<Habitacion> habitaciones = habitacionDAO.listarDisponibles();
                out.print(gson.toJson(habitaciones));
            } else if ("buscar".equals(action) && idParam != null) {
                Habitacion habitacion = habitacionDAO.buscarPorId(Integer.parseInt(idParam));
                out.print(gson.toJson(habitacion));
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
                Habitacion habitacion = new Habitacion();
                habitacion.setIdHabitacion(request.getParameter("idHabitacion"));
                habitacion.setEstado(request.getParameter("estado"));
                String idClienteStr = request.getParameter("idCliente");
                habitacion.setIdCliente(idClienteStr != null && !idClienteStr.isEmpty() ? Integer.parseInt(idClienteStr) : null);
                habitacion.setTipoHabitacion(request.getParameter("tipoHabitacion"));
                habitacion.setPrecioNoche(Double.parseDouble(request.getParameter("precioNoche")));
                habitacion.setCapacidad(Integer.parseInt(request.getParameter("capacidad")));

                boolean resultado = habitacionDAO.insertar(habitacion);
                out.print("{\"success\":" + resultado + "}");
            } else if ("actualizar".equals(action)) {
                Habitacion habitacion = new Habitacion();
                habitacion.setId(Integer.parseInt(request.getParameter("id")));
                habitacion.setIdHabitacion(request.getParameter("idHabitacion"));
                habitacion.setEstado(request.getParameter("estado"));
                String idClienteStr = request.getParameter("idCliente");
                habitacion.setIdCliente(idClienteStr != null && !idClienteStr.isEmpty() ? Integer.parseInt(idClienteStr) : null);
                habitacion.setTipoHabitacion(request.getParameter("tipoHabitacion"));
                habitacion.setPrecioNoche(Double.parseDouble(request.getParameter("precioNoche")));
                habitacion.setCapacidad(Integer.parseInt(request.getParameter("capacidad")));

                boolean resultado = habitacionDAO.actualizar(habitacion);
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
                boolean resultado = habitacionDAO.eliminar(Integer.parseInt(idParam));
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

