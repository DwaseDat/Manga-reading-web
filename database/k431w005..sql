USE [master];
GO

-- ==============================================================================
-- 1. TẠO CƠ SỞ DỮ LIỆU NẾU CHƯA TỒN TẠI
-- ==============================================================================
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ComicDB')
BEGIN
    CREATE DATABASE [ComicDB];
END
GO

USE [ComicDB];
GO

-- ==============================================================================
-- 2. TẠO TOÀN BỘ CẤU TRÚC 10 BẢNG (NẾU CHƯA CÓ)
-- ==============================================================================

-- Bảng 1: Users
IF OBJECT_ID(N'[dbo].[Users]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Users] (
        [user_id] INT IDENTITY(1,1) NOT NULL,
        [username] VARCHAR(50) UNIQUE NOT NULL,
        [password] VARCHAR(50) NOT NULL,
        [role] VARCHAR(20) DEFAULT ('CUSTOMER'),
        PRIMARY KEY CLUSTERED ([user_id] ASC)
    );
END
GO

-- Bảng 2: Categories (Thể loại)
IF OBJECT_ID(N'[dbo].[Categories]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Categories] (
        [category_id] INT IDENTITY(1,1) NOT NULL,
        [category_name] NVARCHAR(100) NOT NULL,
        PRIMARY KEY CLUSTERED ([category_id] ASC)
    );
END
GO

-- Bảng 3: Comics (Truyện tranh)
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

-- Bảng 4: Comic_Categories (Liên kết nhiều - nhiều)
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

-- Bảng 5: Chapters (Chương / Tập truyện)
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

-- Bảng 6: Chapter_Pages (Ảnh từng trang của từng chapter)
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

-- Bảng 7: Favorites (Danh sách theo dõi / bookmark)
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

-- Bảng 8: Reading_History (Lịch sử và tiến trình đọc dở)
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

-- Bảng 9: Ratings (Đánh giá từ 1 đến 5 sao)
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

-- Bảng 10: Comments (Bình luận & Reply)
IF OBJECT_ID(N'[dbo].[Comments]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[Comments] (
        [comment_id] INT IDENTITY(1,1) NOT NULL,
        [comic_id] INT NOT NULL,
        [user_id] INT NOT NULL,
        [parent_id] INT NULL,
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
-- 3. NẾU ĐÃ CÓ DATABASE SẴN: DỌN SẠCH DỮ LIỆU CŨ THEO ĐÚNG THỨ TỰ BẢNG CON TRƯỚC
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
GO

-- ==============================================================================
-- 4. NẠP DỮ LIỆU MẪU CHUẨN XÁC VỚI IDENTITY_INSERT (KHÔNG BAO GIỜ BỊ LỆCH KHÓA NGOẠI)
-- ==============================================================================

-- A. Dữ liệu Categories
SET IDENTITY_INSERT [dbo].[Categories] ON;
INSERT INTO [dbo].[Categories] ([category_id], [category_name]) VALUES 
(1, N'Romantic'), 
(2, N'Action'), 
(3, N'Horror'), 
(4, N'Comedy'), 
(5, N'Gay'), 
(6, N'Les');
SET IDENTITY_INSERT [dbo].[Categories] OFF;
GO

-- B. Dữ liệu Users
SET IDENTITY_INSERT [dbo].[Users] ON;
INSERT INTO [dbo].[Users] ([user_id], [username], [password], [role]) VALUES 
(1, 'admin', '123', 'ADMIN'),
(2, 'user1', '123', 'CUSTOMER'),
(3, 'user2', '123', 'CUSTOMER');
SET IDENTITY_INSERT [dbo].[Users] OFF;
GO

-- C. Dữ liệu Truyện mẫu (Chỉ định ép buộc comic_id = 1 và 2)
SET IDENTITY_INSERT [dbo].[Comics] ON;
INSERT INTO [dbo].[Comics] ([comic_id], [title], [author], [cover_image], [description], [status], [views]) VALUES 
(1, N'Thợ Săn Solo (Solo Leveling)', N'Chugong', N'/comic_storage/covers/cover_solo.jpg', N'Thế giới xuất hiện các hầm ngục và thợ săn...', N'Đã full', 99999),
(2, N'Record of Ragnarok (Đại Chiến Người Và Thần)', N'Shinya Umemura & Takumi Fukui', N'/comic_storage/covers/cover_ror.jpg', N'Cuộc đối đầu đỉnh cao giữa 13 vị thần mạnh nhất và 13 con người vĩ đại nhất để định đoạt sự tồn vong của nhân loại.', N'Đang tiến hành', 50000);
SET IDENTITY_INSERT [dbo].[Comics] OFF;
GO

-- Gán thể loại cho truyện
INSERT INTO [dbo].[Comic_Categories] ([comic_id], [category_id]) VALUES 
(1, 2), -- Solo Leveling -> Action
(2, 2); -- Record of Ragnarok -> Action
GO

-- D. Dữ liệu Chapters (Chỉ định ép buộc chapter_id = 1 và 2)
SET IDENTITY_INSERT [dbo].[Chapters] ON;
INSERT INTO [dbo].[Chapters] ([chapter_id], [comic_id], [chapter_number], [title]) VALUES 
(1, 1, 1, N'Khởi đầu trong hầm ngục kép'),
(2, 2, 1, N'Khởi đầu Ragnarok');
SET IDENTITY_INSERT [dbo].[Chapters] OFF;
GO

-- E. Dữ liệu Trang truyện (Khớp chính xác với chapter_id = 1 và 2)
SET IDENTITY_INSERT [dbo].[Chapter_Pages] ON;
-- 6 trang của Chapter 1 (Solo Leveling)
INSERT INTO [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES 
(1, 1, 1, N'/comic_storage/chapters/solo_leveling/chap_1/1.jpg'),
(2, 1, 2, N'/comic_storage/chapters/solo_leveling/chap_1/2.jpg'),
(3, 1, 3, N'/comic_storage/chapters/solo_leveling/chap_1/3.jpg'),
(4, 1, 4, N'/comic_storage/chapters/solo_leveling/chap_1/4.jpg'),
(5, 1, 5, N'/comic_storage/chapters/solo_leveling/chap_1/5.jpg'),
(6, 1, 6, N'/comic_storage/chapters/solo_leveling/chap_1/6.jpg');

-- 6 trang của Chapter 1 (Record of Ragnarok)
INSERT INTO [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES 
(7, 2, 1, N'/comic_storage/chapters/ror/chap_1/1.jpg'),
(8, 2, 2, N'/comic_storage/chapters/ror/chap_1/2.jpg'),
(9, 2, 3, N'/comic_storage/chapters/ror/chap_1/3.jpg'),
(10, 2, 4, N'/comic_storage/chapters/ror/chap_1/4.jpg'),
(11, 2, 5, N'/comic_storage/chapters/ror/chap_1/5.jpg'),
(12, 2, 6, N'/comic_storage/chapters/ror/chap_1/6.jpg');
SET IDENTITY_INSERT [dbo].[Chapter_Pages] OFF;
GO

-- F. Dữ liệu đánh giá và bình luận mẫu
INSERT INTO [dbo].[Ratings] ([user_id], [comic_id], [star]) VALUES 
(2, 1, 5);

INSERT INTO [dbo].[Comments] ([comic_id], [user_id], [content]) VALUES 
(1, 2, N'Truyện hay quá tác giả ơi!');

INSERT INTO [dbo].[Comments] ([comic_id], [user_id], [parent_id], [content]) VALUES 
(1, 1, 1, N'Cảm ơn bạn đã ủng hộ truyện!');
GO

-- ==============================================================================
-- 5. TRUY VẤN KIỂM TRA LẠI KẾT QUẢ
-- ==============================================================================
SELECT comic_id, title, author, cover_image, status, views FROM [dbo].[Comics];
SELECT chapter_id, comic_id, chapter_number, title FROM [dbo].[Chapters];
SELECT page_id, chapter_id, page_number, image_url FROM [dbo].[Chapter_Pages];
GO