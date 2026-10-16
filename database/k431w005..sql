USE [master];
GO

-- 1. TẠO CƠ SỞ DỮ LIỆU NẾU CHƯA CÓ
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ComicDB')
BEGIN
    CREATE DATABASE [ComicDB];
END
GO

USE [ComicDB];
GO

-- 2. TẠO BẢNG: USERS (Admin & Customer)
IF OBJECT_ID(N'[dbo].[Users]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Users] (
        [user_id] INT IDENTITY(1,1) NOT NULL,
        [username] VARCHAR(50) UNIQUE NOT NULL,
        [password] VARCHAR(50) NOT NULL,
        [role] VARCHAR(20) DEFAULT ('CUSTOMER'), -- 'ADMIN' hoặc 'CUSTOMER'
        PRIMARY KEY CLUSTERED ([user_id] ASC)
    );
END
GO

-- 3. TẠO BẢNG: CATEGORIES (Thể loại)
IF OBJECT_ID(N'[dbo].[Categories]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Categories] (
        [category_id] INT IDENTITY(1,1) NOT NULL,
        [category_name] NVARCHAR(100) NOT NULL,
        PRIMARY KEY CLUSTERED ([category_id] ASC)
    );
END
GO

-- 4. TẠO BẢNG: COMICS (Truyện)
IF OBJECT_ID(N'[dbo].[Comics]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Comics] (
        [comic_id] INT IDENTITY(1,1) NOT NULL,
        [title] NVARCHAR(255) NOT NULL,
        [author] NVARCHAR(100) NULL,
        [cover_image] NVARCHAR(500) NULL,
        [description] NVARCHAR(MAX) NULL,
        [status] NVARCHAR(50) DEFAULT (N'Chưa full'),
        [views] INT DEFAULT (0),
        [created_at] DATETIME DEFAULT (GETDATE()),
        PRIMARY KEY CLUSTERED ([comic_id] ASC)
    );
END
GO

-- 5. TẠO BẢNG: COMIC_CATEGORIES (Quan hệ nhiều - nhiều giữa Truyện và Thể loại)
IF OBJECT_ID(N'[dbo].[Comic_Categories]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Comic_Categories] (
        [comic_id] INT NOT NULL,
        [category_id] INT NOT NULL,
        PRIMARY KEY CLUSTERED ([comic_id] ASC, [category_id] ASC),
        FOREIGN KEY ([comic_id]) REFERENCES [dbo].[Comics] ([comic_id]) ON DELETE CASCADE,
        FOREIGN KEY ([category_id]) REFERENCES [dbo].[Categories] ([category_id]) ON DELETE CASCADE
    );
END
GO

-- 6. TẠO BẢNG: CHAPTERS (Tập / Chương)
IF OBJECT_ID(N'[dbo].[Chapters]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Chapters] (
        [chapter_id] INT IDENTITY(1,1) NOT NULL,
        [comic_id] INT NOT NULL,
        [chapter_number] INT NOT NULL,
        [title] NVARCHAR(150) NULL,
        [created_at] DATETIME DEFAULT (GETDATE()),
        PRIMARY KEY CLUSTERED ([chapter_id] ASC),
        FOREIGN KEY ([comic_id]) REFERENCES [dbo].[Comics] ([comic_id]) ON DELETE CASCADE
    );
END
GO

-- 7. TẠO BẢNG: CHAPTER_PAGES (Trang tranh của từng chapter)
IF OBJECT_ID(N'[dbo].[Chapter_Pages]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Chapter_Pages] (
        [page_id] INT IDENTITY(1,1) NOT NULL,
        [chapter_id] INT NOT NULL,
        [page_number] INT NOT NULL,
        [image_url] NVARCHAR(500) NOT NULL,
        PRIMARY KEY CLUSTERED ([page_id] ASC),
        FOREIGN KEY ([chapter_id]) REFERENCES [dbo].[Chapters] ([chapter_id]) ON DELETE CASCADE
    );
END
GO

-- 8. TẠO BẢNG: FAVORITES (Danh sách yêu thích / Bookmark)
IF OBJECT_ID(N'[dbo].[Favorites]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Favorites] (
        [user_id] INT NOT NULL,
        [comic_id] INT NOT NULL,
        PRIMARY KEY CLUSTERED ([user_id] ASC, [comic_id] ASC),
        FOREIGN KEY ([user_id]) REFERENCES [dbo].[Users] ([user_id]) ON DELETE CASCADE,
        FOREIGN KEY ([comic_id]) REFERENCES [dbo].[Comics] ([comic_id]) ON DELETE CASCADE
    );
END
GO

-- 9. TẠO BẢNG: READING_HISTORY (Tiến trình và lịch sử đọc)
IF OBJECT_ID(N'[dbo].[Reading_History]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Reading_History] (
        [user_id] INT NOT NULL,
        [comic_id] INT NOT NULL,
        [last_chapter_id] INT NULL,
        [updated_at] DATETIME DEFAULT (GETDATE()),
        PRIMARY KEY CLUSTERED ([user_id] ASC, [comic_id] ASC),
        FOREIGN KEY ([user_id]) REFERENCES [dbo].[Users] ([user_id]) ON DELETE CASCADE,
        FOREIGN KEY ([comic_id]) REFERENCES [dbo].[Comics] ([comic_id]) ON DELETE CASCADE,
        FOREIGN KEY ([last_chapter_id]) REFERENCES [dbo].[Chapters] ([chapter_id])
    );
END
GO

-- 10. TẠO BẢNG: RATINGS (Đánh giá 1 - 5 sao)
IF OBJECT_ID(N'[dbo].[Ratings]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Ratings] (
        [user_id] INT NOT NULL,
        [comic_id] INT NOT NULL,
        [star] INT CHECK ([star] >= 1 AND [star] <= 5),
        PRIMARY KEY CLUSTERED ([user_id] ASC, [comic_id] ASC),
        FOREIGN KEY ([user_id]) REFERENCES [dbo].[Users] ([user_id]) ON DELETE CASCADE,
        FOREIGN KEY ([comic_id]) REFERENCES [dbo].[Comics] ([comic_id]) ON DELETE CASCADE
    );
END
GO

-- 11. TẠO BẢNG: COMMENTS (Bình luận & Reply comment qua parent_id)
IF OBJECT_ID(N'[dbo].[Comments]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Comments] (
        [comment_id] INT IDENTITY(1,1) NOT NULL,
        [comic_id] INT NOT NULL,
        [user_id] INT NOT NULL,
        [parent_id] INT NULL, -- NULL nếu là comment gốc, có số nếu là reply
        [content] NVARCHAR(MAX) NOT NULL,
        [created_at] DATETIME DEFAULT (GETDATE()),
        PRIMARY KEY CLUSTERED ([comment_id] ASC),
        FOREIGN KEY ([comic_id]) REFERENCES [dbo].[Comics] ([comic_id]) ON DELETE CASCADE,
        FOREIGN KEY ([user_id]) REFERENCES [dbo].[Users] ([user_id]) ON DELETE CASCADE,
        FOREIGN KEY ([parent_id]) REFERENCES [dbo].[Comments] ([comment_id])
    );
END
GO

-- ==============================================================================
-- 12. DỌN SẠCH DỮ LIỆU CŨ & RESET BỘ ĐẾM ID (Tránh xung đột Foreign Key)
-- ==============================================================================
DELETE FROM [dbo].[Comments];
DELETE FROM [dbo].[Ratings];
DELETE FROM [dbo].[Reading_History];
DELETE FROM [dbo].[Favorites];
DELETE FROM [dbo].[Chapter_Pages];
DELETE FROM [dbo].[Chapters];
DELETE FROM [dbo].[Comic_Categories];
DELETE FROM [dbo].[Comics];
DELETE FROM [dbo].[Categories];
DELETE FROM [dbo].[Users];

DBCC CHECKIDENT ('[dbo].[Users]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[Categories]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[Comics]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[Chapters]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[Chapter_Pages]', RESEED, 0);
DBCC CHECKIDENT ('[dbo].[Comments]', RESEED, 0);
GO

-- ==============================================================================
-- 13. NẠP DỮ LIỆU MẪU ĐỂ CHẠY THỬ NGHIỆM WEB
-- ==============================================================================

-- A. Dữ liệu Users
INSERT INTO [dbo].[Users] ([username], [password], [role]) VALUES 
('admin', '123', 'ADMIN'),
('user1', '123', 'CUSTOMER'),
('user2', '123', 'CUSTOMER');

-- B. Dữ liệu Thể loại
INSERT INTO [dbo].[Categories] ([category_name]) VALUES 
(N'Romantic'), (N'Action'), (N'Horror'), (N'Comedy'), (N'Gay'), (N'Les');

-- C. Dữ liệu Truyện mẫu (Đường dẫn ảnh tương đối trong project webapp)
INSERT INTO [dbo].[Comics] ([title], [author], [cover_image], [description], [status], [views]) VALUES 
(N'Thợ Săn Solo (Solo Leveling)', N'Chugong', N'/comic_storage/covers/cover_solo.jpg', N'Thế giới xuất hiện các hầm ngục và thợ săn...', N'Đã full', 99999),
(N'Record of Ragnarok (Đại Chiến Người Và Thần)', N'Shinya Umemura & Takumi Fukui', N'/comic_storage/covers/cover_ror.jpg', N'Cuộc đối đầu đỉnh cao giữa 13 vị thần mạnh nhất và 13 con người vĩ đại nhất để định đoạt sự tồn vong của nhân loại.', N'Đang tiến hành', 50000);

-- Gán thể loại cho truyện
INSERT INTO [dbo].[Comic_Categories] ([comic_id], [category_id]) VALUES 
(1, 2), -- Solo Leveling -> Action
(2, 2); -- Record of Ragnarok -> Action

-- D. Dữ liệu Chapter
-- Solo Leveling: 2 chapters (chapter_id: 1, 2)
INSERT INTO [dbo].[Chapters] ([comic_id], [chapter_number], [title]) VALUES 
(1, 1, N'Khởi đầu trong hầm ngục kép'),
(1, 2, N'Lựa chọn sinh tử');

-- Record of Ragnarok: 1 chapter (chapter_id: 3)
INSERT INTO [dbo].[Chapters] ([comic_id], [chapter_number], [title]) VALUES 
(2, 1, N'Khởi đầu Ragnarok');

-- E. Dữ liệu Trang tranh (Chapter_Pages)
-- Chapter 1 của Solo Leveling (chapter_id = 1)
INSERT INTO [dbo].[Chapter_Pages] ([chapter_id], [page_number], [image_url]) VALUES 
(1, 1, N'/comic_storage/chapters/solo_leveling/chap_1/1.jpg'),
(1, 2, N'/comic_storage/chapters/solo_leveling/chap_1/2.jpg'),
(1, 3, N'/comic_storage/chapters/solo_leveling/chap_1/3.jpg'),
(1, 4, N'/comic_storage/chapters/solo_leveling/chap_1/4.jpg'),
(1, 5, N'/comic_storage/chapters/solo_leveling/chap_1/5.jpg'),
(1, 6, N'/comic_storage/chapters/solo_leveling/chap_1/6.jpg');

-- Chapter 2 của Solo Leveling (chapter_id = 2)
INSERT INTO [dbo].[Chapter_Pages] ([chapter_id], [page_number], [image_url]) VALUES 
(2, 1, N'/comic_storage/chapters/solo_leveling/chap_2/1.jpg'),
(2, 2, N'/comic_storage/chapters/solo_leveling/chap_2/2.jpg'),
(2, 3, N'/comic_storage/chapters/solo_leveling/chap_2/3.jpg'),
(2, 4, N'/comic_storage/chapters/solo_leveling/chap_2/4.jpg'),
(2, 5, N'/comic_storage/chapters/solo_leveling/chap_2/5.jpg'),
(2, 6, N'/comic_storage/chapters/solo_leveling/chap_2/6.jpg');

-- Chapter 1 của Record of Ragnarok (chapter_id = 3)
INSERT INTO [dbo].[Chapter_Pages] ([chapter_id], [page_number], [image_url]) VALUES 
(3, 1, N'/comic_storage/chapters/ror/chap_1/1.jpg'),
(3, 2, N'/comic_storage/chapters/ror/chap_1/2.jpg'),
(3, 3, N'/comic_storage/chapters/ror/chap_1/3.jpg'),
(3, 4, N'/comic_storage/chapters/ror/chap_1/4.jpg'),
(3, 5, N'/comic_storage/chapters/ror/chap_1/5.jpg'),
(3, 6, N'/comic_storage/chapters/ror/chap_1/6.jpg');

-- F. Dữ liệu đánh giá và bình luận mẫu
INSERT INTO [dbo].[Ratings] ([user_id], [comic_id], [star]) VALUES 
(2, 1, 5);

INSERT INTO [dbo].[Comments] ([comic_id], [user_id], [content]) VALUES 
(1, 2, N'Truyện hay quá tác giả ơi!');

INSERT INTO [dbo].[Comments] ([comic_id], [user_id], [parent_id], [content]) VALUES 
(1, 1, 1, N'Cảm ơn bạn đã ủng hộ truyện!');
GO