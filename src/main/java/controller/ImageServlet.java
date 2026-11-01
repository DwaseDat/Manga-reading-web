package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import util.ComicStorage;

@WebServlet(name = "ImageServlet", urlPatterns = {"/images/*"})
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String relativePath = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        File storageRoot;
        try {
            storageRoot = ComicStorage.root(getServletContext());
        } catch (IOException ex) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        File file = new File(storageRoot, relativePath).getCanonicalFile();
        if (!file.toPath().startsWith(storageRoot.getCanonicalFile().toPath()) || !file.exists() || file.isDirectory()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        response.setContentType(mimeType);
        response.setContentLengthLong(file.length());

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
