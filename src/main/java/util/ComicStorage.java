package util;

import jakarta.servlet.ServletContext;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/** Resolves the project's webapp comic_storage directory for local development. */
public final class ComicStorage {
    private ComicStorage() { }

    public static File root(ServletContext context) throws IOException {
        String configured = System.getProperty("manga.comic.storage");
        if (configured != null && !configured.trim().isEmpty()) {
            return new File(configured).getCanonicalFile();
        }

        List<File> searchFrom = new ArrayList<>();
        searchFrom.add(new File(System.getProperty("user.dir")));
        String deployedRoot = context.getRealPath("/");
        if (deployedRoot != null) searchFrom.add(new File(deployedRoot));

        for (File start : searchFrom) {
            File current = start.getCanonicalFile();
            for (int depth = 0; current != null && depth < 10; depth++, current = current.getParentFile()) {
                File webapp = new File(current, "src/main/webapp");
                if (webapp.isDirectory()) {
                    File storage = new File(webapp, "comic_storage");
                    if (!storage.exists() && !storage.mkdirs()) {
                        throw new IOException("Không tạo được thư mục comic_storage: " + storage);
                    }
                    return storage.getCanonicalFile();
                }
            }
        }

        throw new IOException("Không tìm thấy thư mục comic_storage trong project source. Hãy đặt -Dmanga.comic.storage=<đường dẫn Manga/src/main/webapp/comic_storage>.");
    }
}
