package com.hotel.servlets;

import com.hotel.dao.ClienteDAO;
import com.hotel.modelo.Cliente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.google.gson.Gson;
import java.util.List;

@WebServlet(name = "ClienteServlet", urlPatterns = {"/clientes"})
public class ClienteServlet extends HttpServlet {
    private ClienteDAO clienteDAO = new ClienteDAO();
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
                List<Cliente> clientes = clienteDAO.listarTodos();
                out.print(gson.toJson(clientes));
            } else if ("buscar".equals(action) && idParam != null) {
                Cliente cliente = clienteDAO.buscarPorId(Integer.parseInt(idParam));
                out.print(gson.toJson(cliente));
            } else if ("buscarDocumento".equals(action)) {
                String documento = request.getParameter("documento");
                List<Cliente> clientes = clienteDAO.buscarPorDocumento(Integer.parseInt(documento));
                out.print(gson.toJson(clientes));
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
        System.out.println("=== ClienteServlet POST ===");
        System.out.println("Action: " + action);

        try {
            if ("insertar".equals(action)) {
                String nombre = request.getParameter("nombre");
                String apellido = request.getParameter("apellido");
                String documento = request.getParameter("documento");
                String correo = request.getParameter("correo");
                String telefono = request.getParameter("telefono");
                String direccion = request.getParameter("direccion");
                
                // Validaciones
                if (nombre == null || nombre.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"El nombre del cliente es requerido\"}");
                    out.flush();
                    return;
                }
                
                if (apellido == null || apellido.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"El apellido del cliente es requerido\"}");
                    out.flush();
                    return;
                }
                
                if (documento == null || documento.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"El documento del cliente es requerido\"}");
                    out.flush();
                    return;
                }
                
                int docNum = Integer.parseInt(documento);
                if (docNum <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"El documento debe ser un número mayor a 0\"}");
                    out.flush();
                    return;
                }
                
                // Validar que el documento no esté duplicado
                List<Cliente> clientesExistentes = clienteDAO.buscarPorDocumento(docNum);
                if (clientesExistentes != null && !clientesExistentes.isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"El documento ya existe en el sistema\"}");
                    out.flush();
                    return;
                }
                
                System.out.println("Insertando cliente: " + nombre + " " + apellido + " - " + documento);
                
                Cliente cliente = new Cliente();
                cliente.setNombre(nombre);
                cliente.setApellido(apellido);
                cliente.setDocumento(docNum);
                cliente.setCorreo(correo);
                cliente.setTelefono(telefono);
                cliente.setDireccion(direccion);

                boolean resultado = clienteDAO.insertar(cliente);
                System.out.println("Resultado inserción: " + resultado);
                out.print("{\"success\":" + resultado + "}");
            } else if ("actualizar".equals(action)) {
                String id = request.getParameter("id");
                String nombre = request.getParameter("nombre");
                String apellido = request.getParameter("apellido");
                String documento = request.getParameter("documento");
                String correo = request.getParameter("correo");
                String telefono = request.getParameter("telefono");
                String direccion = request.getParameter("direccion");
                
                // Validaciones
                if (nombre == null || nombre.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"El nombre del cliente es requerido\"}");
                    out.flush();
                    return;
                }
                
                if (apellido == null || apellido.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"El apellido del cliente es requerido\"}");
                    out.flush();
                    return;
                }
                
                if (documento == null || documento.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"El documento del cliente es requerido\"}");
                    out.flush();
                    return;
                }
                
                int docNum = Integer.parseInt(documento);
                if (docNum <= 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"El documento debe ser un número mayor a 0\"}");
                    out.flush();
                    return;
                }
                
                System.out.println("Actualizando cliente ID: " + id);
                
                Cliente cliente = new Cliente();
                cliente.setId(Integer.parseInt(id));
                cliente.setNombre(nombre);
                cliente.setApellido(apellido);
                cliente.setDocumento(docNum);
                cliente.setCorreo(correo);
                cliente.setTelefono(telefono);
                cliente.setDireccion(direccion);

                boolean resultado = clienteDAO.actualizar(cliente);
                System.out.println("Resultado actualización: " + resultado);
                out.print("{\"success\":" + resultado + "}");
            } else if ("eliminar".equals(action)) {
                String idParam = request.getParameter("id");
                
                if (idParam == null || idParam.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"success\":false, \"error\":\"ID del cliente es requerido\"}");
                    out.flush();
                    return;
                }
                
                boolean resultado = clienteDAO.eliminar(Integer.parseInt(idParam));
                out.print("{\"success\":" + resultado + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Acción no válida\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false, \"error\":\"Formato de datos inválido: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            System.err.println("Error en ClienteServlet: " + e.getMessage());
            e.printStackTrace();
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
                boolean resultado = clienteDAO.eliminar(Integer.parseInt(idParam));
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

