package com.hotel.servlets;

import com.hotel.dao.UsuarioDAO;
import com.hotel.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario u = usuarioDAO.validarUsuario(usuario, password);

        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", u);
            session.setAttribute("nombre", u.getNombre());
            session.setAttribute("rol", u.getRol());
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            response.sendRedirect("dashboard.jsp");
        } else {
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}

