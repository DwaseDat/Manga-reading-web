USE [ComicDB];
GO

IF OBJECT_ID(N'[dbo].[User_Read_Chapters]', N'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[User_Read_Chapters] (
        [user_id] INT NOT NULL,
        [comic_id] INT NOT NULL,
        [chapter_id] INT NOT NULL,
        [read_at] DATETIME NOT NULL CONSTRAINT [DF_User_Read_Chapters_read_at] DEFAULT (GETDATE()),
        CONSTRAINT [PK_User_Read_Chapters] PRIMARY KEY ([user_id], [chapter_id])
    );
END
GO
