/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CommentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "CommentController", urlPatterns = {"/comment"})
public class CommentController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("loggedInUser");
        if (user == null && session != null) user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int comicId;
        try {
            comicId = Integer.parseInt(request.getParameter("comicId"));
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        String content = request.getParameter("content");
        if (content == null || content.trim().isEmpty() || content.trim().length() > 2000) {
            response.sendRedirect(request.getContextPath() + "/comic?id=" + comicId + "&commentError=1#comments");
            return;
        }

        boolean added = new CommentDAO().addComment(comicId, user.getUserId(), content.trim());
        response.sendRedirect(request.getContextPath() + "/comic?id=" + comicId
                + (added ? "&commented=1" : "&commentError=1") + "#comments");
    }
}
