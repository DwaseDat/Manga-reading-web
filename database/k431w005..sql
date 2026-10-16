USE [ComicDB];
GO

-- 1. Xóa sạch dữ liệu ở tất cả các bảng con trước
DELETE FROM Chapter_Pages;
DELETE FROM Chapters;
DELETE FROM Comic_Categories;
DELETE FROM Comments;
DELETE FROM Favorites;
DELETE FROM Ratings;
DELETE FROM Reading_History;
DELETE FROM Comics;
DELETE FROM Categories;
DELETE FROM Users;
GO

-- 2. Reset lại bộ đếm tự tăng IDENTITY về đúng 0 để khi INSERT sẽ bắt đầu từ 1
DBCC CHECKIDENT ('Comics', RESEED, 0);
DBCC CHECKIDENT ('Chapters', RESEED, 0);
DBCC CHECKIDENT ('Chapter_Pages', RESEED, 0);
DBCC CHECKIDENT ('Categories', RESEED, 0);
DBCC CHECKIDENT ('Users', RESEED, 0);
GO

-- 3. Thêm Thể loại (nhận category_id từ 1 đến 6)
INSERT [dbo].[Categories] ([category_name]) VALUES 
(N'Romantic'), (N'Action'), (N'Horror'), (N'Comedy'), (N'Gay'), (N'Les');

-- 4. Thêm Users (nhận user_id từ 1 đến 3)
INSERT [dbo].[Users] ([username], [password], [role]) VALUES 
(N'admin', N'123', N'ADMIN'),
(N'user1', N'123', N'CUSTOMER'),
(N'user2', N'123', N'CUSTOMER');

-- 5. Thêm Truyện (Lúc này chắc chắn sẽ nhận comic_id = 1 và comic_id = 2)
INSERT [dbo].[Comics] ([title], [author], [cover_image], [description], [status], [views]) VALUES 
(N'Thợ Săn Solo (Solo Leveling)', N'Chugong', N'/comic_storage/covers/cover_solo.jpg', N'Thế giới xuất hiện các hầm ngục và thợ săn...', N'Đã full', 99999),
(N'Record of Ragnarok (Đại Chiến Người Và Thần)', N'Shinya Umemura & Takumi Fukui', N'/comic_storage/covers/cover_ror.jpg', N'Cuộc đối đầu đỉnh cao giữa 13 vị thần mạnh nhất và 13 con người vĩ đại nhất để định đoạt sự tồn vong của nhân loại.', N'Đang tiến hành', 50000);

-- 6. Thêm Chapters (Khớp đúng comic_id = 1 và comic_id = 2, sinh ra chapter_id = 1 và 2)
INSERT [dbo].[Chapters] ([comic_id], [chapter_number], [title]) VALUES 
(1, 1, N'Khởi đầu trong hầm ngục kép'),
(2, 1, N'Khởi đầu Ragnarok');

-- 7. Thêm Chapter_Pages (Khớp đúng chapter_id = 1 và chapter_id = 2)
-- Solo Leveling (chapter_id = 1)
INSERT [dbo].[Chapter_Pages] ([chapter_id], [page_number], [image_url]) VALUES 
(1, 1, N'/comic_storage/chapters/solo_leveling/chap_1/1.jpg'),
(1, 2, N'/comic_storage/chapters/solo_leveling/chap_1/2.jpg'),
(1, 3, N'/comic_storage/chapters/solo_leveling/chap_1/3.jpg'),
(1, 4, N'/comic_storage/chapters/solo_leveling/chap_1/4.jpg'),
(1, 5, N'/comic_storage/chapters/solo_leveling/chap_1/5.jpg'),
(1, 6, N'/comic_storage/chapters/solo_leveling/chap_1/6.jpg');

-- Record of Ragnarok (chapter_id = 2)
INSERT [dbo].[Chapter_Pages] ([chapter_id], [page_number], [image_url]) VALUES 
(2, 1, N'/comic_storage/chapters/ror/chap_1/1.jpg'),
(2, 2, N'/comic_storage/chapters/ror/chap_1/2.jpg'),
(2, 3, N'/comic_storage/chapters/ror/chap_1/3.jpg'),
(2, 4, N'/comic_storage/chapters/ror/chap_1/4.jpg'),
(2, 5, N'/comic_storage/chapters/ror/chap_1/5.jpg'),
(2, 6, N'/comic_storage/chapters/ror/chap_1/6.jpg');
GO