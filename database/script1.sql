USE [ComicDB]
GO

-- =============================================
-- 1. DROP TẤT CẢ FOREIGN KEYS ĐỂ TRÁNH LỖI KHI DROP TABLE
-- =============================================
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
            + N' DROP CONSTRAINT ' + QUOTENAME(name) + N';' + CHAR(13)
FROM sys.foreign_keys;

EXEC sp_executesql @sql;
GO

-- =============================================
-- 2. DROP CÁC BẢNG HIỆN CÓ
-- =============================================
IF OBJECT_ID('dbo.Reading_History', 'U') IS NOT NULL DROP TABLE dbo.Reading_History;
IF OBJECT_ID('dbo.Ratings', 'U') IS NOT NULL DROP TABLE dbo.Ratings;
IF OBJECT_ID('dbo.Favorites', 'U') IS NOT NULL DROP TABLE dbo.Favorites;
IF OBJECT_ID('dbo.Comments', 'U') IS NOT NULL DROP TABLE dbo.Comments;
IF OBJECT_ID('dbo.Comic_Categories', 'U') IS NOT NULL DROP TABLE dbo.Comic_Categories;
IF OBJECT_ID('dbo.Chapter_Pages', 'U') IS NOT NULL DROP TABLE dbo.Chapter_Pages;
IF OBJECT_ID('dbo.Chapters', 'U') IS NOT NULL DROP TABLE dbo.Chapters;
IF OBJECT_ID('dbo.Comics', 'U') IS NOT NULL DROP TABLE dbo.Comics;
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL DROP TABLE dbo.Categories;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
GO

-- =============================================
-- 3. TẠO LẠI CÁC BẢNG
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED ([category_id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Chapter_Pages](
	[page_id] [int] IDENTITY(1,1) NOT NULL,
	[chapter_id] [int] NULL,
	[page_number] [int] NULL,
	[image_url] [nvarchar](500) NOT NULL,
PRIMARY KEY CLUSTERED ([page_id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Chapters](
	[chapter_id] [int] IDENTITY(1,1) NOT NULL,
	[comic_id] [int] NULL,
	[chapter_number] [int] NOT NULL,
	[title] [nvarchar](150) NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED ([chapter_id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Comic_Categories](
	[comic_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED ([comic_id] ASC, [category_id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Comics](
	[comic_id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](255) NOT NULL,
	[author] [nvarchar](100) NULL,
	[cover_image] [nvarchar](500) NULL,
	[description] [nvarchar](max) NULL,
	[status] [nvarchar](50) NULL,
	[views] [int] NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED ([comic_id] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Comments](
	[comment_id] [int] IDENTITY(1,1) NOT NULL,
	[comic_id] [int] NULL,
	[user_id] [int] NULL,
	[parent_id] [int] NULL,
	[content] [nvarchar](max) NOT NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED ([comment_id] ASC)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Favorites](
	[user_id] [int] NOT NULL,
	[comic_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED ([user_id] ASC, [comic_id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Ratings](
	[user_id] [int] NOT NULL,
	[comic_id] [int] NOT NULL,
	[star] [int] NULL,
PRIMARY KEY CLUSTERED ([user_id] ASC, [comic_id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Reading_History](
	[user_id] [int] NOT NULL,
	[comic_id] [int] NOT NULL,
	[last_chapter_id] [int] NULL,
	[updated_at] [datetime] NULL,
PRIMARY KEY CLUSTERED ([user_id] ASC, [comic_id] ASC)
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
	[role] [varchar](20) NULL,
PRIMARY KEY CLUSTERED ([user_id] ASC)
) ON [PRIMARY]
GO

-- =============================================
-- 4. INSERT TOÀN BỘ DATA GỐC
-- =============================================
SET IDENTITY_INSERT [dbo].[Categories] ON;
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (1, N'Romantic');
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (2, N'Action');
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (3, N'Horror');
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (4, N'Comedy');
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (5, N'Gay');
INSERT [dbo].[Categories] ([category_id], [category_name]) VALUES (6, N'Les');
SET IDENTITY_INSERT [dbo].[Categories] OFF;
GO

SET IDENTITY_INSERT [dbo].[Chapter_Pages] ON;
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (1, 1, 1, N'/comic_storage/chapters/solo_leveling/chap_1/1.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (2, 1, 2, N'/comic_storage/chapters/solo_leveling/chap_1/2.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (3, 1, 3, N'/comic_storage/chapters/solo_leveling/chap_1/3.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (4, 1, 4, N'/comic_storage/chapters/solo_leveling/chap_1/4.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (5, 1, 5, N'/comic_storage/chapters/solo_leveling/chap_1/5.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (6, 1, 6, N'/comic_storage/chapters/solo_leveling/chap_1/6.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (7, 2, 1, N'/comic_storage/chapters/ror/chap_1/1.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (8, 2, 2, N'/comic_storage/chapters/ror/chap_1/2.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (9, 2, 3, N'/comic_storage/chapters/ror/chap_1/3.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (10, 2, 4, N'/comic_storage/chapters/ror/chap_1/4.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (11, 2, 5, N'/comic_storage/chapters/ror/chap_1/5.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (12, 2, 6, N'/comic_storage/chapters/ror/chap_1/6.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (13, 3, 1, N'/comic_storage/chapters/ror/chap_2/1.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (14, 3, 2, N'/comic_storage/chapters/ror/chap_2/2.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (15, 3, 3, N'/comic_storage/chapters/ror/chap_2/3.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (16, 3, 4, N'/comic_storage/chapters/ror/chap_2/4.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (17, 3, 5, N'/comic_storage/chapters/ror/chap_2/5.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (18, 3, 6, N'/comic_storage/chapters/ror/chap_2/6.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (19, 3, 7, N'/comic_storage/chapters/ror/chap_2/7.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (20, 3, 8, N'/comic_storage/chapters/ror/chap_2/8.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (21, 3, 9, N'/comic_storage/chapters/ror/chap_2/9.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (22, 3, 10, N'/comic_storage/chapters/ror/chap_2/10.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (23, 3, 11, N'/comic_storage/chapters/ror/chap_2/11.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (24, 3, 12, N'/comic_storage/chapters/ror/chap_2/12.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (25, 3, 13, N'/comic_storage/chapters/ror/chap_2/13.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (26, 3, 14, N'/comic_storage/chapters/ror/chap_2/14.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (27, 3, 15, N'/comic_storage/chapters/ror/chap_2/15.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (28, 3, 16, N'/comic_storage/chapters/ror/chap_2/16.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (29, 3, 17, N'/comic_storage/chapters/ror/chap_2/17.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (30, 3, 18, N'/comic_storage/chapters/ror/chap_2/18.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (31, 3, 19, N'/comic_storage/chapters/ror/chap_2/19.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (32, 3, 20, N'/comic_storage/chapters/ror/chap_2/20.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (33, 3, 21, N'/comic_storage/chapters/ror/chap_2/21.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (34, 3, 22, N'/comic_storage/chapters/ror/chap_2/22.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (35, 3, 23, N'/comic_storage/chapters/ror/chap_2/23.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (36, 3, 24, N'/comic_storage/chapters/ror/chap_2/24.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (37, 3, 25, N'/comic_storage/chapters/ror/chap_2/25.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (38, 3, 26, N'/comic_storage/chapters/ror/chap_2/26.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (39, 3, 27, N'/comic_storage/chapters/ror/chap_2/27.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (40, 3, 28, N'/comic_storage/chapters/ror/chap_2/28.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (41, 3, 29, N'/comic_storage/chapters/ror/chap_2/29.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (42, 3, 30, N'/comic_storage/chapters/ror/chap_2/30.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (43, 3, 31, N'/comic_storage/chapters/ror/chap_2/31.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (44, 3, 32, N'/comic_storage/chapters/ror/chap_2/32.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (45, 4, 1, N'/comic_storage/chapters/ror/chap_3/1.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (46, 4, 2, N'/comic_storage/chapters/ror/chap_3/2.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (47, 4, 3, N'/comic_storage/chapters/ror/chap_3/3.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (48, 4, 4, N'/comic_storage/chapters/ror/chap_3/4.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (49, 4, 5, N'/comic_storage/chapters/ror/chap_3/5.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (50, 4, 6, N'/comic_storage/chapters/ror/chap_3/6.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (51, 4, 7, N'/comic_storage/chapters/ror/chap_3/7.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (52, 4, 8, N'/comic_storage/chapters/ror/chap_3/8.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (53, 4, 9, N'/comic_storage/chapters/ror/chap_3/9.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (54, 4, 10, N'/comic_storage/chapters/ror/chap_3/10.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (55, 4, 11, N'/comic_storage/chapters/ror/chap_3/11.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (56, 4, 12, N'/comic_storage/chapters/ror/chap_3/12.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (57, 4, 13, N'/comic_storage/chapters/ror/chap_3/13.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (58, 4, 14, N'/comic_storage/chapters/ror/chap_3/14.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (59, 4, 15, N'/comic_storage/chapters/ror/chap_3/15.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (60, 4, 16, N'/comic_storage/chapters/ror/chap_3/16.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (61, 4, 17, N'/comic_storage/chapters/ror/chap_3/17.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (62, 4, 18, N'/comic_storage/chapters/ror/chap_3/18.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (63, 4, 19, N'/comic_storage/chapters/ror/chap_3/19.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (64, 4, 20, N'/comic_storage/chapters/ror/chap_3/20.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (65, 4, 21, N'/comic_storage/chapters/ror/chap_3/21.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (66, 4, 22, N'/comic_storage/chapters/ror/chap_3/22.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (67, 4, 23, N'/comic_storage/chapters/ror/chap_3/23.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (68, 4, 24, N'/comic_storage/chapters/ror/chap_3/24.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (69, 4, 25, N'/comic_storage/chapters/ror/chap_3/25.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (70, 4, 26, N'/comic_storage/chapters/ror/chap_3/26.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (71, 4, 27, N'/comic_storage/chapters/ror/chap_3/27.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (72, 4, 28, N'/comic_storage/chapters/ror/chap_3/28.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (73, 4, 29, N'/comic_storage/chapters/ror/chap_3/29.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (74, 4, 30, N'/comic_storage/chapters/ror/chap_3/30.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (75, 4, 31, N'/comic_storage/chapters/ror/chap_3/31.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (76, 4, 32, N'/comic_storage/chapters/ror/chap_3/32.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (77, 4, 33, N'/comic_storage/chapters/ror/chap_3/33.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (78, 4, 34, N'/comic_storage/chapters/ror/chap_3/34.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (79, 4, 35, N'/comic_storage/chapters/ror/chap_3/35.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (80, 4, 36, N'/comic_storage/chapters/ror/chap_3/36.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (81, 4, 37, N'/comic_storage/chapters/ror/chap_3/37.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (82, 5, 1, N'/comic_storage/chapters/ror/chap_4/1.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (83, 5, 2, N'/comic_storage/chapters/ror/chap_4/2.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (84, 5, 3, N'/comic_storage/chapters/ror/chap_4/3.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (85, 5, 4, N'/comic_storage/chapters/ror/chap_4/4.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (86, 5, 5, N'/comic_storage/chapters/ror/chap_4/5.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (87, 5, 6, N'/comic_storage/chapters/ror/chap_4/6.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (88, 5, 7, N'/comic_storage/chapters/ror/chap_4/7.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (89, 5, 8, N'/comic_storage/chapters/ror/chap_4/8.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (90, 5, 9, N'/comic_storage/chapters/ror/chap_4/9.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (91, 5, 10, N'/comic_storage/chapters/ror/chap_4/10.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (92, 5, 11, N'/comic_storage/chapters/ror/chap_4/11.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (93, 5, 12, N'/comic_storage/chapters/ror/chap_4/12.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (94, 5, 13, N'/comic_storage/chapters/ror/chap_4/13.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (95, 5, 14, N'/comic_storage/chapters/ror/chap_4/14.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (96, 5, 15, N'/comic_storage/chapters/ror/chap_4/15.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (97, 5, 16, N'/comic_storage/chapters/ror/chap_4/16.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (98, 5, 17, N'/comic_storage/chapters/ror/chap_4/17.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (99, 5, 18, N'/comic_storage/chapters/ror/chap_4/18.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (100, 5, 19, N'/comic_storage/chapters/ror/chap_4/19.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (101, 5, 20, N'/comic_storage/chapters/ror/chap_4/20.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (102, 5, 21, N'/comic_storage/chapters/ror/chap_4/21.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (103, 5, 22, N'/comic_storage/chapters/ror/chap_4/22.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (104, 5, 23, N'/comic_storage/chapters/ror/chap_4/23.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (105, 5, 24, N'/comic_storage/chapters/ror/chap_4/24.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (106, 5, 25, N'/comic_storage/chapters/ror/chap_4/25.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (107, 5, 26, N'/comic_storage/chapters/ror/chap_4/26.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (108, 5, 27, N'/comic_storage/chapters/ror/chap_4/27.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (109, 5, 28, N'/comic_storage/chapters/ror/chap_4/28.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (110, 5, 29, N'/comic_storage/chapters/ror/chap_4/29.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (111, 5, 30, N'/comic_storage/chapters/ror/chap_4/30.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (112, 6, 1, N'/comic_storage/chapters/ror/chap_6/1.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (113, 6, 2, N'/comic_storage/chapters/ror/chap_6/2.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (114, 6, 3, N'/comic_storage/chapters/ror/chap_6/3.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (115, 6, 4, N'/comic_storage/chapters/ror/chap_6/4.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (116, 6, 5, N'/comic_storage/chapters/ror/chap_6/5.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (117, 6, 6, N'/comic_storage/chapters/ror/chap_6/6.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (118, 6, 7, N'/comic_storage/chapters/ror/chap_6/7.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (119, 6, 8, N'/comic_storage/chapters/ror/chap_6/8.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (120, 6, 9, N'/comic_storage/chapters/ror/chap_6/9.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (121, 6, 10, N'/comic_storage/chapters/ror/chap_6/10.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (122, 6, 11, N'/comic_storage/chapters/ror/chap_6/11.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (123, 6, 12, N'/comic_storage/chapters/ror/chap_6/12.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (124, 6, 13, N'/comic_storage/chapters/ror/chap_6/13.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (125, 6, 14, N'/comic_storage/chapters/ror/chap_6/14.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (126, 6, 15, N'/comic_storage/chapters/ror/chap_6/15.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (127, 6, 16, N'/comic_storage/chapters/ror/chap_6/16.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (128, 6, 17, N'/comic_storage/chapters/ror/chap_6/17.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (129, 6, 18, N'/comic_storage/chapters/ror/chap_6/18.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (130, 6, 19, N'/comic_storage/chapters/ror/chap_6/19.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (131, 6, 20, N'/comic_storage/chapters/ror/chap_6/20.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (132, 6, 21, N'/comic_storage/chapters/ror/chap_6/21.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (133, 6, 22, N'/comic_storage/chapters/ror/chap_6/22.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (134, 6, 23, N'/comic_storage/chapters/ror/chap_6/23.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (135, 6, 24, N'/comic_storage/chapters/ror/chap_6/24.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (136, 6, 25, N'/comic_storage/chapters/ror/chap_6/25.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (137, 6, 26, N'/comic_storage/chapters/ror/chap_6/26.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (138, 6, 27, N'/comic_storage/chapters/ror/chap_6/27.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (139, 6, 28, N'/comic_storage/chapters/ror/chap_6/28.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (140, 6, 29, N'/comic_storage/chapters/ror/chap_6/29.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (141, 6, 30, N'/comic_storage/chapters/ror/chap_6/30.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (142, 6, 31, N'/comic_storage/chapters/ror/chap_6/31.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (143, 6, 32, N'/comic_storage/chapters/ror/chap_6/32.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (144, 6, 33, N'/comic_storage/chapters/ror/chap_6/33.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (145, 6, 34, N'/comic_storage/chapters/ror/chap_6/34.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (146, 6, 35, N'/comic_storage/chapters/ror/chap_6/35.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (147, 6, 36, N'/comic_storage/chapters/ror/chap_6/36.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (148, 7, 1, N'/comic_storage/chapters/ror/chap_5/1.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (149, 7, 2, N'/comic_storage/chapters/ror/chap_5/2.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (150, 7, 3, N'/comic_storage/chapters/ror/chap_5/3.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (151, 7, 4, N'/comic_storage/chapters/ror/chap_5/4.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (152, 7, 5, N'/comic_storage/chapters/ror/chap_5/5.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (153, 7, 6, N'/comic_storage/chapters/ror/chap_5/6.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (154, 7, 7, N'/comic_storage/chapters/ror/chap_5/7.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (155, 7, 8, N'/comic_storage/chapters/ror/chap_5/8.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (156, 7, 9, N'/comic_storage/chapters/ror/chap_5/9.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (157, 7, 10, N'/comic_storage/chapters/ror/chap_5/10.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (158, 7, 11, N'/comic_storage/chapters/ror/chap_5/11.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (159, 7, 12, N'/comic_storage/chapters/ror/chap_5/12.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (160, 7, 13, N'/comic_storage/chapters/ror/chap_5/13.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (161, 7, 14, N'/comic_storage/chapters/ror/chap_5/14.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (162, 7, 15, N'/comic_storage/chapters/ror/chap_5/15.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (163, 7, 16, N'/comic_storage/chapters/ror/chap_5/16.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (164, 7, 17, N'/comic_storage/chapters/ror/chap_5/17.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (165, 7, 18, N'/comic_storage/chapters/ror/chap_5/18.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (166, 7, 19, N'/comic_storage/chapters/ror/chap_5/19.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (167, 7, 20, N'/comic_storage/chapters/ror/chap_5/20.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (168, 7, 21, N'/comic_storage/chapters/ror/chap_5/21.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (169, 7, 22, N'/comic_storage/chapters/ror/chap_5/22.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (170, 7, 23, N'/comic_storage/chapters/ror/chap_5/23.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (171, 7, 24, N'/comic_storage/chapters/ror/chap_5/24.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (172, 7, 25, N'/comic_storage/chapters/ror/chap_5/25.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (173, 7, 26, N'/comic_storage/chapters/ror/chap_5/26.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (174, 7, 27, N'/comic_storage/chapters/ror/chap_5/27.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (175, 7, 28, N'/comic_storage/chapters/ror/chap_5/28.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (176, 7, 29, N'/comic_storage/chapters/ror/chap_5/29.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (177, 7, 30, N'/comic_storage/chapters/ror/chap_5/30.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (178, 7, 31, N'/comic_storage/chapters/ror/chap_5/31.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (179, 8, 1, N'/comic_storage/chapters/ror/chap_7/1.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (180, 8, 2, N'/comic_storage/chapters/ror/chap_7/2.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (181, 8, 3, N'/comic_storage/chapters/ror/chap_7/3.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (182, 8, 4, N'/comic_storage/chapters/ror/chap_7/4.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (183, 8, 5, N'/comic_storage/chapters/ror/chap_7/5.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (184, 8, 6, N'/comic_storage/chapters/ror/chap_7/6.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (185, 8, 7, N'/comic_storage/chapters/ror/chap_7/7.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (186, 8, 8, N'/comic_storage/chapters/ror/chap_7/8.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (187, 8, 9, N'/comic_storage/chapters/ror/chap_7/9.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (188, 8, 10, N'/comic_storage/chapters/ror/chap_7/10.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (189, 8, 11, N'/comic_storage/chapters/ror/chap_7/11.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (190, 8, 12, N'/comic_storage/chapters/ror/chap_7/12.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (191, 8, 13, N'/comic_storage/chapters/ror/chap_7/13.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (192, 8, 14, N'/comic_storage/chapters/ror/chap_7/14.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (193, 8, 15, N'/comic_storage/chapters/ror/chap_7/15.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (194, 8, 16, N'/comic_storage/chapters/ror/chap_7/16.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (195, 8, 17, N'/comic_storage/chapters/ror/chap_7/17.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (196, 8, 18, N'/comic_storage/chapters/ror/chap_7/18.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (197, 8, 19, N'/comic_storage/chapters/ror/chap_7/19.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (198, 8, 20, N'/comic_storage/chapters/ror/chap_7/20.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (199, 8, 21, N'/comic_storage/chapters/ror/chap_7/21.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (200, 8, 22, N'/comic_storage/chapters/ror/chap_7/22.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (201, 8, 23, N'/comic_storage/chapters/ror/chap_7/23.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (202, 8, 24, N'/comic_storage/chapters/ror/chap_7/24.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (203, 8, 25, N'/comic_storage/chapters/ror/chap_7/25.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (204, 8, 26, N'/comic_storage/chapters/ror/chap_7/26.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (205, 8, 27, N'/comic_storage/chapters/ror/chap_7/27.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (206, 8, 28, N'/comic_storage/chapters/ror/chap_7/28.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (207, 8, 29, N'/comic_storage/chapters/ror/chap_7/29.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (208, 8, 30, N'/comic_storage/chapters/ror/chap_7/30.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (209, 8, 31, N'/comic_storage/chapters/ror/chap_7/31.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (210, 8, 32, N'/comic_storage/chapters/ror/chap_7/32.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (211, 8, 33, N'/comic_storage/chapters/ror/chap_7/33.jpg');
INSERT [dbo].[Chapter_Pages] ([page_id], [chapter_id], [page_number], [image_url]) VALUES (212, 8, 34, N'/comic_storage/chapters/ror/chap_7/34.jpg');
SET IDENTITY_INSERT [dbo].[Chapter_Pages] OFF;
GO

SET IDENTITY_INSERT [dbo].[Chapters] ON;
INSERT [dbo].[Chapters] ([chapter_id], [comic_id], [chapter_number], [title], [created_at]) VALUES (1, 1, 1, N'Khởi đầu trong hầm ngục kép', CAST(N'2026-10-16T14:25:10.580' AS DateTime));
INSERT [dbo].[Chapters] ([chapter_id], [comic_id], [chapter_number], [title], [created_at]) VALUES (2, 2, 1, N'Khởi đầu Ragnarok', CAST(N'2026-10-16T14:25:10.580' AS DateTime));
INSERT [dbo].[Chapters] ([chapter_id], [comic_id], [chapter_number], [title], [created_at]) VALUES (3, 2, 2, N'Lựa chọn sinh tử', CAST(N'2026-10-19T08:31:17.290' AS DateTime));
INSERT [dbo].[Chapters] ([chapter_id], [comic_id], [chapter_number], [title], [created_at]) VALUES (4, 2, 3, N'Chapter 3', CAST(N'2026-10-27T19:30:43.590' AS DateTime));
INSERT [dbo].[Chapters] ([chapter_id], [comic_id], [chapter_number], [title], [created_at]) VALUES (5, 2, 4, N'Chap 4', CAST(N'2026-10-27T19:36:26.853' AS DateTime));
INSERT [dbo].[Chapters] ([chapter_id], [comic_id], [chapter_number], [title], [created_at]) VALUES (6, 2, 6, N'Chapter 6', CAST(N'2026-10-27T19:43:20.180' AS DateTime));
INSERT [dbo].[Chapters] ([chapter_id], [comic_id], [chapter_number], [title], [created_at]) VALUES (7, 2, 5, N'Chapter 5', CAST(N'2026-10-27T19:44:39.450' AS DateTime));
INSERT [dbo].[Chapters] ([chapter_id], [comic_id], [chapter_number], [title], [created_at]) VALUES (8, 2, 7, N'Chapter 7', CAST(N'2026-10-27T20:08:55.047' AS DateTime));
SET IDENTITY_INSERT [dbo].[Chapters] OFF;
GO

INSERT [dbo].[Comic_Categories] ([comic_id], [category_id]) VALUES (2, 2);
GO

SET IDENTITY_INSERT [dbo].[Comics] ON;
INSERT [dbo].[Comics] ([comic_id], [title], [author], [cover_image], [description], [status], [views], [created_at]) VALUES (1, N'Thợ Săn Solo (Solo Leveling)', N'Chugong', N'/comic_storage/covers/cover_solo.jpg', N'Thế giới xuất hiện các hầm ngục và thợ săn...', N'Đã full', 2, CAST(N'2026-10-16T14:25:10.580' AS DateTime));
INSERT [dbo].[Comics] ([comic_id], [title], [author], [cover_image], [description], [status], [views], [created_at]) VALUES (2, N'Record of Ragnarok (Đại Chiến Người Và Thần)', N'Shinya Umemura & Takumi Fukui', N'/comic_storage/covers/cover_ror.jpg', N'Cuộc đối đầu đỉnh cao giữa 13 vị thần mạnh nhất và 13 con người vĩ đại nhất để định đoạt sự tồn vong của nhân loại.', N'Đang tiến hành', 4, CAST(N'2026-10-16T14:25:10.580' AS DateTime));
INSERT [dbo].[Comics] ([comic_id], [title], [author], [cover_image], [description], [status], [views], [created_at]) VALUES (4, N'Manga 4', N'', N'', N'', N'Đang tiến hành', 2, CAST(N'2026-10-27T18:13:43.180' AS DateTime));
INSERT [dbo].[Comics] ([comic_id], [title], [author], [cover_image], [description], [status], [views], [created_at]) VALUES (5, N'Manga 5', N'', N'', N'', N'Đang tiến hành', 0, CAST(N'2026-10-27T18:14:02.613' AS DateTime));
SET IDENTITY_INSERT [dbo].[Comics] OFF;
GO

INSERT [dbo].[Favorites] ([user_id], [comic_id]) VALUES (2, 1);
INSERT [dbo].[Favorites] ([user_id], [comic_id]) VALUES (2, 2);
GO

INSERT [dbo].[Reading_History] ([user_id], [comic_id], [last_chapter_id], [updated_at]) VALUES (1, 2, 8, CAST(N'2026-10-27T20:09:01.610' AS DateTime));
INSERT [dbo].[Reading_History] ([user_id], [comic_id], [last_chapter_id], [updated_at]) VALUES (2, 1, 1, CAST(N'2026-10-26T21:27:08.400' AS DateTime));
INSERT [dbo].[Reading_History] ([user_id], [comic_id], [last_chapter_id], [updated_at]) VALUES (2, 2, 2, CAST(N'2026-10-26T21:26:40.447' AS DateTime));
INSERT [dbo].[Reading_History] ([user_id], [comic_id], [last_chapter_id], [updated_at]) VALUES (5, 2, 2, CAST(N'2026-10-27T19:21:56.353' AS DateTime));
GO

SET IDENTITY_INSERT [dbo].[Users] ON;
INSERT [dbo].[Users] ([user_id], [username], [password], [role]) VALUES (1, N'admin', N'202cb962ac59075b964b07152d234b70', N'ADMIN');
INSERT [dbo].[Users] ([user_id], [username], [password], [role]) VALUES (2, N'user1', N'123', N'CUSTOMER');
INSERT [dbo].[Users] ([user_id], [username], [password], [role]) VALUES (3, N'user2', N'123', N'CUSTOMER');
INSERT [dbo].[Users] ([user_id], [username], [password], [role]) VALUES (4, N'user3', N'202cb962ac59075b964b07152d234b70', N'CUSTOMER');
INSERT [dbo].[Users] ([user_id], [username], [password], [role]) VALUES (5, N'user4', N'e10adc3949ba59abbe56e057f20f883e', N'CUSTOMER');
INSERT [dbo].[Users] ([user_id], [username], [password], [role]) VALUES (6, N'user5', N'e10adc3949ba59abbe56e057f20f883e', N'CUSTOMER');
SET IDENTITY_INSERT [dbo].[Users] OFF;
GO

-- =============================================
-- 5. THIẾT LẬP RÀNG BUỘC (INDEX, DEFAULT, CHECK, FOREIGN KEY)
-- =============================================
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED ([username] ASC);
GO

ALTER TABLE [dbo].[Chapters] ADD DEFAULT (getdate()) FOR [created_at];
GO
ALTER TABLE [dbo].[Comics] ADD DEFAULT (N'Chưa full') FOR [status];
GO
ALTER TABLE [dbo].[Comics] ADD DEFAULT ((0)) FOR [views];
GO
ALTER TABLE [dbo].[Comics] ADD DEFAULT (getdate()) FOR [created_at];
GO
ALTER TABLE [dbo].[Comments] ADD DEFAULT (getdate()) FOR [created_at];
GO
ALTER TABLE [dbo].[Reading_History] ADD DEFAULT (getdate()) FOR [updated_at];
GO
ALTER TABLE [dbo].[Users] ADD DEFAULT ('CUSTOMER') FOR [role];
GO

ALTER TABLE [dbo].[Chapter_Pages] WITH CHECK ADD CONSTRAINT [FK_Chapter_Pages_Chapters] FOREIGN KEY([chapter_id])
REFERENCES [dbo].[Chapters] ([chapter_id]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Chapter_Pages] CHECK CONSTRAINT [FK_Chapter_Pages_Chapters];
GO

ALTER TABLE [dbo].[Chapters] WITH CHECK ADD CONSTRAINT [FK_Chapters_Comics] FOREIGN KEY([comic_id])
REFERENCES [dbo].[Comics] ([comic_id]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Chapters] CHECK CONSTRAINT [FK_Chapters_Comics];
GO

ALTER TABLE [dbo].[Comic_Categories] WITH CHECK ADD CONSTRAINT [FK_Comic_Categories_Categories] FOREIGN KEY([category_id])
REFERENCES [dbo].[Categories] ([category_id]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Comic_Categories] CHECK CONSTRAINT [FK_Comic_Categories_Categories];
GO

ALTER TABLE [dbo].[Comic_Categories] WITH CHECK ADD CONSTRAINT [FK_Comic_Categories_Comics] FOREIGN KEY([comic_id])
REFERENCES [dbo].[Comics] ([comic_id]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Comic_Categories] CHECK CONSTRAINT [FK_Comic_Categories_Comics];
GO

ALTER TABLE [dbo].[Comments] WITH CHECK ADD CONSTRAINT [FK_Comments_Comics] FOREIGN KEY([comic_id])
REFERENCES [dbo].[Comics] ([comic_id]);
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Comics];
GO

ALTER TABLE [dbo].[Comments] WITH CHECK ADD CONSTRAINT [FK_Comments_Comments] FOREIGN KEY([parent_id])
REFERENCES [dbo].[Comments] ([comment_id]);
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Comments];
GO

ALTER TABLE [dbo].[Comments] WITH CHECK ADD CONSTRAINT [FK_Comments_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id]);
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Users];
GO

ALTER TABLE [dbo].[Favorites] WITH CHECK ADD CONSTRAINT [FK_Favorites_Comics] FOREIGN KEY([comic_id])
REFERENCES [dbo].[Comics] ([comic_id]);
GO
ALTER TABLE [dbo].[Favorites] CHECK CONSTRAINT [FK_Favorites_Comics];
GO

ALTER TABLE [dbo].[Favorites] WITH CHECK ADD CONSTRAINT [FK_Favorites_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id]);
GO
ALTER TABLE [dbo].[Favorites] CHECK CONSTRAINT [FK_Favorites_Users];
GO

ALTER TABLE [dbo].[Ratings] WITH CHECK ADD CONSTRAINT [FK_Ratings_Comics] FOREIGN KEY([comic_id])
REFERENCES [dbo].[Comics] ([comic_id]);
GO
ALTER TABLE [dbo].[Ratings] CHECK CONSTRAINT [FK_Ratings_Comics];
GO
ALTER TABLE [dbo].[Ratings] WITH CHECK ADD CONSTRAINT [FK_Ratings_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id]);
GO
ALTER TABLE [dbo].[Ratings] CHECK CONSTRAINT [FK_Ratings_Users];
GO

ALTER TABLE [dbo].[Reading_History] WITH CHECK ADD CONSTRAINT [FK_Reading_History_Chapters] FOREIGN KEY([last_chapter_id])
REFERENCES [dbo].[Chapters] ([chapter_id]);
GO
ALTER TABLE [dbo].[Reading_History] CHECK CONSTRAINT [FK_Reading_History_Chapters];
GO

ALTER TABLE [dbo].[Reading_History] WITH CHECK ADD CONSTRAINT [FK_Reading_History_Comics] FOREIGN KEY([comic_id])
REFERENCES [dbo].[Comics] ([comic_id]);
GO
ALTER TABLE [dbo].[Reading_History] CHECK CONSTRAINT [FK_Reading_History_Comics];
GO

ALTER TABLE [dbo].[Reading_History] WITH CHECK ADD CONSTRAINT [FK_Reading_History_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([user_id]);
GO
ALTER TABLE [dbo].[Reading_History] CHECK CONSTRAINT [FK_Reading_History_Users];
GO

ALTER TABLE [dbo].[Ratings] WITH CHECK ADD CHECK (([star]>=(1) AND [star]<=(5)));
GO