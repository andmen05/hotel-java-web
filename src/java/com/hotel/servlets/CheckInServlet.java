package com.hotel.servlets;

import com.hotel.dao.CheckInDAO;
import com.hotel.dao.VentaDAO;
import com.hotel.modelo.CheckIn;
import com.hotel.modelo.Venta;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CheckInServlet", urlPatterns = {"/checkin"})
public class CheckInServlet extends HttpServlet {
    private CheckInDAO checkInDAO = new CheckInDAO();
    private VentaDAO ventaDAO = new VentaDAO();
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
                String fechaSalidaStr = request.getParameter("fechaSalida");
                Timestamp fechaSalida = null;
                
                try {
                    // Formatear fecha: "2025-11-16T14:30" -> "2025-11-16 14:30:00"
                    if (fechaSalidaStr != null && !fechaSalidaStr.isEmpty()) {
                        fechaSalidaStr = fechaSalidaStr.replace("T", " ");
                        if (!fechaSalidaStr.contains(":")) {
                            fechaSalidaStr += ":00:00";
                        } else if (fechaSalidaStr.split(":").length == 2) {
                            fechaSalidaStr += ":00";
                        }
                        fechaSalida = Timestamp.valueOf(fechaSalidaStr);
                    }
                } catch (IllegalArgumentException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"Formato de fecha inválido: " + fechaSalidaStr + "\"}");
                    out.flush();
                    return;
                }
                
                boolean resultado = checkInDAO.hacerCheckOut(idCheckin, fechaSalida);
                
                // Obtener check-in para saber la habitación
                CheckIn checkIn = checkInDAO.buscarPorId(idCheckin);
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", resultado);
                
                if (resultado && checkIn != null) {
                    try {
                        // Obtener ventas de la habitación FILTRADAS por cliente actual
                        List<Venta> ventasHabitacion = ventaDAO.listarPorHabitacion(checkIn.getHabitacion());
                        // Filtrar solo las ventas del cliente actual
                        List<Venta> ventas = new ArrayList<>();
                        for (Venta v : ventasHabitacion) {
                            if (v.getIdCliente() != null && v.getIdCliente().equals(checkIn.getIdCliente())) {
                                ventas.add(v);
                            }
                        }
                        responseData.put("ventas", ventas);
                        responseData.put("checkIn", checkIn);
                    } catch (Exception e) {
                        System.err.println("Error al obtener ventas: " + e.getMessage());
                        e.printStackTrace();
                        // Continuar sin ventas si hay error
                        responseData.put("ventas", new ArrayList<>());
                        responseData.put("checkIn", checkIn);
                    }
                }
                
                out.print(gson.toJson(responseData));
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

