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
                Reserva reserva = new Reserva();
                reserva.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
                reserva.setHabitacion(Integer.parseInt(request.getParameter("habitacion")));
                reserva.setFechaEntrada(Date.valueOf(request.getParameter("fechaEntrada")));
                reserva.setFechaSalida(Date.valueOf(request.getParameter("fechaSalida")));
                reserva.setTipoReserva(request.getParameter("tipoReserva"));
                reserva.setEstado(request.getParameter("estado"));

                boolean resultado = reservaDAO.insertar(reserva);
                out.print("{\"success\":" + resultado + "}");
            } else if ("actualizar".equals(action)) {
                Reserva reserva = new Reserva();
                reserva.setId(Integer.parseInt(request.getParameter("id")));
                reserva.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
                reserva.setHabitacion(Integer.parseInt(request.getParameter("habitacion")));
                reserva.setFechaEntrada(Date.valueOf(request.getParameter("fechaEntrada")));
                reserva.setFechaSalida(Date.valueOf(request.getParameter("fechaSalida")));
                reserva.setTipoReserva(request.getParameter("tipoReserva"));
                reserva.setEstado(request.getParameter("estado"));

                boolean resultado = reservaDAO.actualizar(reserva);
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

