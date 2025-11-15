package com.hotel.servlets;

import com.hotel.dao.VentaDAO;
import com.hotel.dao.CheckInDAO;
import com.hotel.dao.ReservaDAO;
import com.hotel.dao.HabitacionDAO;
import com.hotel.modelo.Venta;
import com.hotel.modelo.CheckIn;
import com.hotel.modelo.Reserva;
import com.hotel.modelo.Habitacion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@WebServlet(name = "ReporteServlet", urlPatterns = {"/reportes"})
public class ReporteServlet extends HttpServlet {
    private VentaDAO ventaDAO = new VentaDAO();
    private CheckInDAO checkInDAO = new CheckInDAO();
    private ReservaDAO reservaDAO = new ReservaDAO();
    private HabitacionDAO habitacionDAO = new HabitacionDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String tipo = request.getParameter("tipo");

        try {
            Map<String, Object> reporte = new HashMap<>();
            
            System.out.println("ReporteServlet - Tipo: " + tipo);
            
            switch (tipo) {
                case "ocupacion":
                    List<Habitacion> habitaciones = habitacionDAO.listarTodas();
                    int disponibles = (int) habitaciones.stream().filter(h -> "Disponible".equals(h.getEstado())).count();
                    int ocupadas = (int) habitaciones.stream().filter(h -> "Ocupada".equals(h.getEstado())).count();
                    int mantenimiento = (int) habitaciones.stream().filter(h -> "Mantenimiento".equals(h.getEstado())).count();
                    int total = habitaciones.size();
                    double porcentajeOcupacion = total > 0 ? (ocupadas * 100.0) / total : 0;
                    
                    reporte.put("disponibles", disponibles);
                    reporte.put("ocupadas", ocupadas);
                    reporte.put("mantenimiento", mantenimiento);
                    reporte.put("total", total);
                    reporte.put("porcentajeOcupacion", Math.round(porcentajeOcupacion * 100.0) / 100.0);
                    System.out.println("Ocupación: " + disponibles + " disponibles, " + ocupadas + " ocupadas");
                    break;
                case "ingresos":
                    List<Venta> ventasIngresos = ventaDAO.listarTodas();
                    double totalIngresos = ventasIngresos.stream().mapToDouble(Venta::getTotal).sum();
                    double ventasHoy = ventasIngresos.stream()
                        .filter(v -> esHoy(v.getFecha()))
                        .mapToDouble(Venta::getTotal)
                        .sum();
                    double promedioVenta = ventasIngresos.size() > 0 ? totalIngresos / ventasIngresos.size() : 0;
                    
                    reporte.put("totalIngresos", totalIngresos);
                    reporte.put("ventasHoy", ventasHoy);
                    reporte.put("promedioVenta", promedioVenta);
                    reporte.put("cantidadVentas", ventasIngresos.size());
                    System.out.println("Ingresos: $" + totalIngresos + ", Hoy: $" + ventasHoy);
                    break;
                case "ventas":
                    List<Venta> ventas = ventaDAO.listarTodas();
                    double totalVentas = ventas.stream().mapToDouble(Venta::getTotal).sum();
                    reporte.put("ventas", ventas);
                    reporte.put("total", totalVentas);
                    reporte.put("cantidad", ventas.size());
                    break;
                case "checkins":
                    List<CheckIn> checkIns = checkInDAO.listarTodos();
                    reporte.put("checkins", checkIns);
                    reporte.put("cantidad", checkIns.size());
                    break;
                case "reservas":
                    List<Reserva> reservas = reservaDAO.listarTodas();
                    reporte.put("reservas", reservas);
                    reporte.put("cantidad", reservas.size());
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\":\"Tipo de reporte no válido: " + tipo + "\"}");
                    return;
            }
            
            out.print(gson.toJson(reporte));
        } catch (Exception e) {
            System.err.println("Error en ReporteServlet: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
        out.flush();
    }
    
    private boolean esHoy(java.util.Date fecha) {
        if (fecha == null) return false;
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String fechaStr = sdf.format(fecha);
        String hoyStr = sdf.format(new java.util.Date());
        return fechaStr.equals(hoyStr);
    }
}

