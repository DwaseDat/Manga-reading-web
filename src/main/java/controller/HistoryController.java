package controller;

import dao.InteractionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Comic;
import model.User;

@WebServlet(name = "HistoryController", urlPatterns = {"/history"})
public class HistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("loggedInUser");
            if (user == null) {
                user = (User) session.getAttribute("user");
            }
        }

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        InteractionDAO interactDao = new InteractionDAO();
        List<Comic> historyComics = interactDao.getReadingHistoryByUserId(user.getUserId());

        // Đẩy biến "historyComics" khớp 100% với thẻ <c:forEach var="c" items="${historyComics}"> trong JSP
        request.setAttribute("historyComics", historyComics);
        request.getRequestDispatcher("/WEB-INF/client/history-list.jsp").forward(request, response);
    }
}