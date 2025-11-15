package com.hotel.servlets;

import com.hotel.dao.CheckInDAO;
import com.hotel.modelo.CheckIn;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "CheckInServlet", urlPatterns = {"/checkin"})
public class CheckInServlet extends HttpServlet {
    private CheckInDAO checkInDAO = new CheckInDAO();
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
                List<CheckIn> checkIns = checkInDAO.listarTodos();
                out.print(gson.toJson(checkIns));
            } else if ("activos".equals(action)) {
                List<CheckIn> checkIns = checkInDAO.listarActivos();
                out.print(gson.toJson(checkIns));
            } else if ("buscar".equals(action) && idParam != null) {
                CheckIn checkIn = checkInDAO.buscarPorId(Integer.parseInt(idParam));
                out.print(gson.toJson(checkIn));
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
                CheckIn checkIn = new CheckIn();
                checkIn.setFechaIngresoCheckin(Timestamp.valueOf(request.getParameter("fechaIngreso").replace("T", " ") + ":00"));
                String fechaSalidaStr = request.getParameter("fechaSalida");
                if (fechaSalidaStr != null && !fechaSalidaStr.isEmpty()) {
                    checkIn.setFechaSalidaChecking(Timestamp.valueOf(fechaSalidaStr.replace("T", " ") + ":00"));
                }
                checkIn.setNoches(Integer.parseInt(request.getParameter("noches")));
                checkIn.setHabitacion(Integer.parseInt(request.getParameter("habitacion")));
                checkIn.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
                checkIn.setTransporte(request.getParameter("transporte"));
                checkIn.setMotivoViaje(request.getParameter("motivoViaje"));
                checkIn.setProcedencia(request.getParameter("procedencia"));
                checkIn.setAcompanantes(Integer.parseInt(request.getParameter("acompanantes")));
                checkIn.setEstado("Activo");

                boolean resultado = checkInDAO.insertar(checkIn);
                out.print("{\"success\":" + resultado + "}");
            } else if ("checkout".equals(action)) {
                int idCheckin = Integer.parseInt(request.getParameter("idCheckin"));
                Timestamp fechaSalida = Timestamp.valueOf(request.getParameter("fechaSalida").replace("T", " ") + ":00");
                boolean resultado = checkInDAO.hacerCheckOut(idCheckin, fechaSalida);
                out.print("{\"success\":" + resultado + "}");
            } else if ("actualizar".equals(action)) {
                CheckIn checkIn = new CheckIn();
                checkIn.setIdCheckin(Integer.parseInt(request.getParameter("idCheckin")));
                checkIn.setFechaIngresoCheckin(Timestamp.valueOf(request.getParameter("fechaIngreso").replace("T", " ") + ":00"));
                String fechaSalidaStr = request.getParameter("fechaSalida");
                if (fechaSalidaStr != null && !fechaSalidaStr.isEmpty()) {
                    checkIn.setFechaSalidaChecking(Timestamp.valueOf(fechaSalidaStr.replace("T", " ") + ":00"));
                }
                checkIn.setNoches(Integer.parseInt(request.getParameter("noches")));
                checkIn.setHabitacion(Integer.parseInt(request.getParameter("habitacion")));
                checkIn.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
                checkIn.setTransporte(request.getParameter("transporte"));
                checkIn.setMotivoViaje(request.getParameter("motivoViaje"));
                checkIn.setProcedencia(request.getParameter("procedencia"));
                checkIn.setAcompanantes(Integer.parseInt(request.getParameter("acompanantes")));
                checkIn.setEstado(request.getParameter("estado"));

                boolean resultado = checkInDAO.actualizar(checkIn);
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
                boolean resultado = checkInDAO.eliminar(Integer.parseInt(idParam));
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

