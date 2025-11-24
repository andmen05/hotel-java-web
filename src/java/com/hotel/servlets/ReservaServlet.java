package com.hotel.servlets;

import com.hotel.dao.ReservaDAO;
import com.hotel.modelo.Reserva;
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

@WebServlet(name = "ReservaServlet", urlPatterns = {"/reservas"})
public class ReservaServlet extends HttpServlet {
    private ReservaDAO reservaDAO = new ReservaDAO();
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
                List<Reserva> reservas = reservaDAO.listarTodas();
                out.print(gson.toJson(reservas));
            } else if ("buscar".equals(action) && idParam != null) {
                Reserva reserva = reservaDAO.buscarPorId(Integer.parseInt(idParam));
                out.print(gson.toJson(reserva));
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
                // Validar parámetros requeridos
                String idClienteStr = request.getParameter("idCliente");
                String habitacionStr = request.getParameter("habitacion");
                String fechaEntradaStr = request.getParameter("fechaEntrada");
                String fechaSalidaStr = request.getParameter("fechaSalida");
                String tipoReserva = request.getParameter("tipoReserva");
                String estado = request.getParameter("estado");
                
                if (idClienteStr == null || habitacionStr == null || fechaEntradaStr == null || 
                    fechaSalidaStr == null || tipoReserva == null || estado == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"Parámetros requeridos faltantes\"}");
                    out.flush();
                    return;
                }
                
                Date fechaEntrada = Date.valueOf(fechaEntradaStr);
                Date fechaSalida = Date.valueOf(fechaSalidaStr);
                
                // Validar que fechaSalida > fechaEntrada
                if (!fechaSalida.after(fechaEntrada)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"La fecha de salida debe ser posterior a la fecha de entrada\"}");
                    out.flush();
                    return;
                }
                
                Reserva reserva = new Reserva();
                reserva.setIdCliente(Integer.parseInt(idClienteStr));
                reserva.setHabitacion(Integer.parseInt(habitacionStr));
                reserva.setFechaEntrada(fechaEntrada);
                reserva.setFechaSalida(fechaSalida);
                reserva.setTipoReserva(tipoReserva);
                reserva.setEstado(estado);

                boolean resultado = reservaDAO.insertar(reserva);
                out.print("{\"success\":" + resultado + "}");
            } else if ("actualizar".equals(action)) {
                // Validar parámetros requeridos
                String idStr = request.getParameter("id");
                String idClienteStr = request.getParameter("idCliente");
                String habitacionStr = request.getParameter("habitacion");
                String fechaEntradaStr = request.getParameter("fechaEntrada");
                String fechaSalidaStr = request.getParameter("fechaSalida");
                String tipoReserva = request.getParameter("tipoReserva");
                String estado = request.getParameter("estado");
                
                if (idStr == null || idClienteStr == null || habitacionStr == null || fechaEntradaStr == null || 
                    fechaSalidaStr == null || tipoReserva == null || estado == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"Parámetros requeridos faltantes\"}");
                    out.flush();
                    return;
                }
                
                Date fechaEntrada = Date.valueOf(fechaEntradaStr);
                Date fechaSalida = Date.valueOf(fechaSalidaStr);
                
                // Validar que fechaSalida > fechaEntrada
                if (!fechaSalida.after(fechaEntrada)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"La fecha de salida debe ser posterior a la fecha de entrada\"}");
                    out.flush();
                    return;
                }
                
                Reserva reserva = new Reserva();
                reserva.setId(Integer.parseInt(idStr));
                reserva.setIdCliente(Integer.parseInt(idClienteStr));
                reserva.setHabitacion(Integer.parseInt(habitacionStr));
                reserva.setFechaEntrada(fechaEntrada);
                reserva.setFechaSalida(fechaSalida);
                reserva.setTipoReserva(tipoReserva);
                reserva.setEstado(estado);

                boolean resultado = reservaDAO.actualizar(reserva);
                out.print("{\"success\":" + resultado + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Acción no válida\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false, \"error\":\"Formato de datos inválido: " + e.getMessage() + "\"}");
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false, \"error\":\"Formato de fecha inválido. Use YYYY-MM-DD\"}");
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
                boolean resultado = reservaDAO.eliminar(Integer.parseInt(idParam));
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

