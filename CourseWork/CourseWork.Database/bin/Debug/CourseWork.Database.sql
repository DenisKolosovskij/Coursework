/*
Скрипт развертывания для CourseWork.Database

Этот код был создан программным средством.
Изменения, внесенные в этот файл, могут привести к неверному выполнению кода и будут потеряны
в случае его повторного формирования.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "CourseWork.Database"
:setvar DefaultFilePrefix "CourseWork.Database"
:setvar DefaultDataPath "C:\Users\verov\AppData\Local\Microsoft\VisualStudio\SSDT\CourseWork"
:setvar DefaultLogPath "C:\Users\verov\AppData\Local\Microsoft\VisualStudio\SSDT\CourseWork"

GO
:on error exit
GO
/*
Проверьте режим SQLCMD и отключите выполнение скрипта, если режим SQLCMD не поддерживается.
Чтобы повторно включить скрипт после включения режима SQLCMD выполните следующую инструкцию:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Для успешного выполнения этого скрипта должен быть включен режим SQLCMD.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
Необходимо добавить столбец [dbo].[CollectionItem].[CollectionId] таблицы [dbo].[CollectionItem], но он не содержит значения по умолчанию и не допускает значения NULL. Если таблица содержит данные, скрипт ALTER окажется неработоспособным. Чтобы избежать возникновения этой проблемы, необходимо выполнить одно из следующих действий: добавить в столбец значение по умолчанию, пометить его как допускающий значения NULL или разрешить формирование интеллектуальных умолчаний в параметрах развертывания.

Необходимо добавить столбец [dbo].[CollectionItem].[Name] таблицы [dbo].[CollectionItem], но он не содержит значения по умолчанию и не допускает значения NULL. Если таблица содержит данные, скрипт ALTER окажется неработоспособным. Чтобы избежать возникновения этой проблемы, необходимо выполнить одно из следующих действий: добавить в столбец значение по умолчанию, пометить его как допускающий значения NULL или разрешить формирование интеллектуальных умолчаний в параметрах развертывания.
*/

IF EXISTS (select top 1 1 from [dbo].[CollectionItem])
    RAISERROR (N'Обнаружены строки. Обновление схемы завершено из-за возможной потери данных.', 16, 127) WITH NOWAIT

GO
PRINT N'Идет изменение Таблица [dbo].[CollectionItem]…';


GO
ALTER TABLE [dbo].[CollectionItem]
    ADD [CollectionId] INT            NOT NULL,
        [Name]         NVARCHAR (100) NOT NULL;


GO
PRINT N'Идет создание Таблица [dbo].[AspNetRoleClaims]…';


GO
CREATE TABLE [dbo].[AspNetRoleClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [RoleId]     NVARCHAR (450) NOT NULL,
    [ClaimType]  NVARCHAR (MAX) NULL,
    [ClaimValue] NVARCHAR (MAX) NULL,
    CONSTRAINT [pk_AspNetRoleClaims] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[AspNetRoleClaims].[IX_AspNetRoleClaims_RoleId]…';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId]
    ON [dbo].[AspNetRoleClaims]([RoleId] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[AspNetRoles]…';


GO
CREATE TABLE [dbo].[AspNetRoles] (
    [Id]               NVARCHAR (450) NOT NULL,
    [Name]             NVARCHAR (256) NULL,
    [NormalizedName]   NVARCHAR (256) NULL,
    [ConcurrencyStamp] NVARCHAR (MAX) NULL,
    CONSTRAINT [pk_AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[AspNetRoles].[RoleNameIndex]…';


GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
    ON [dbo].[AspNetRoles]([NormalizedName] ASC) WHERE [NormalizedName] IS NOT NULL;


GO
PRINT N'Идет создание Таблица [dbo].[AspNetUserClaims]…';


GO
CREATE TABLE [dbo].[AspNetUserClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [UserId]     NVARCHAR (450) NOT NULL,
    [ClaimType]  NVARCHAR (450) NULL,
    [ClaimValue] NVARCHAR (450) NULL,
    CONSTRAINT [pk_AspNetUserClaims] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[AspNetUserClaims].[IX_AspNetUserClaims_UserId]…';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId]
    ON [dbo].[AspNetUserClaims]([UserId] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[AspNetUserLogins]…';


GO
CREATE TABLE [dbo].[AspNetUserLogins] (
    [LoginProvider]       NVARCHAR (450) NOT NULL,
    [ProviderKey]         NVARCHAR (450) NOT NULL,
    [ProviderDisplayName] NVARCHAR (MAX) NULL,
    [UserId]              NVARCHAR (450) NOT NULL,
    CONSTRAINT [pk_AspNetUserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[AspNetUserLogins].[IX_AspNetUserLogins_UserId]…';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId]
    ON [dbo].[AspNetUserLogins]([UserId] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[AspNetUserRoles]…';


GO
CREATE TABLE [dbo].[AspNetUserRoles] (
    [UserId] NVARCHAR (450) NOT NULL,
    [RoleId] NVARCHAR (450) NOT NULL,
    CONSTRAINT [pk_AspNetUserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[AspNetUserRoles].[IX_AspNetUserRoles_RoleId]…';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId]
    ON [dbo].[AspNetUserRoles]([RoleId] ASC);


GO
PRINT N'Идет создание Таблица [dbo].[AspNetUsers]…';


GO
CREATE TABLE [dbo].[AspNetUsers] (
    [Id]                   NVARCHAR (450)     NOT NULL,
    [FirstName]            NVARCHAR (MAX)     NULL,
    [SecondName]           NVARCHAR (MAX)     NULL,
    [UserName]             NVARCHAR (256)     NULL,
    [NormalizedUserName]   NVARCHAR (256)     NULL,
    [Email]                NVARCHAR (256)     NULL,
    [NormalizedEmail]      NVARCHAR (256)     NULL,
    [EmailConfirmed]       BIT                NOT NULL,
    [PasswordHash]         NVARCHAR (MAX)     NULL,
    [SecurityStamp]        NVARCHAR (MAX)     NULL,
    [ConcurrencyStamp]     NVARCHAR (MAX)     NULL,
    [PhoneNumber]          NVARCHAR (MAX)     NULL,
    [PhoneNumberConfirmed] BIT                NOT NULL,
    [TwoFactorEnabled]     BIT                NOT NULL,
    [LockoutEnd]           DATETIMEOFFSET (7) NULL,
    [LockoutEnabled]       BIT                NOT NULL,
    [AccessFailedCount]    INT                NOT NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Индекс [dbo].[AspNetUsers].[EmailIndex]…';


GO
CREATE NONCLUSTERED INDEX [EmailIndex]
    ON [dbo].[AspNetUsers]([NormalizedEmail] ASC);


GO
PRINT N'Идет создание Индекс [dbo].[AspNetUsers].[UserNameIndex]…';


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[AspNetUsers]([NormalizedUserName] ASC) WHERE [NormalizedUserName] IS NOT NULL;


GO
PRINT N'Идет создание Таблица [dbo].[AspNetUserTokens]…';


GO
CREATE TABLE [dbo].[AspNetUserTokens] (
    [UserId]        NVARCHAR (450) NOT NULL,
    [LoginProvider] NVARCHAR (450) NOT NULL,
    [Name]          NVARCHAR (450) NOT NULL,
    [Value]         NVARCHAR (450) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED ([UserId] ASC, [LoginProvider] ASC, [Name] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[BooleanField]…';


GO
CREATE TABLE [dbo].[BooleanField] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    [Value]            BIT            NOT NULL,
    CONSTRAINT [pk_BooleanField] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[Collection]…';


GO
CREATE TABLE [dbo].[Collection] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [UserId]            NVARCHAR (450) NOT NULL,
    [Title]             NVARCHAR (100) NOT NULL,
    [Description]       NVARCHAR (500) NOT NULL,
    [CollectionThemeId] INT            NOT NULL,
    [Image]             NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [pk_Collection] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[CollectionItemTag]…';


GO
CREATE TABLE [dbo].[CollectionItemTag] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    CONSTRAINT [pk_CollectionItemTag] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [un_CollectionItemTag] UNIQUE NONCLUSTERED ([CollectionItemId] ASC, [Name] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[CollectionTheme]…';


GO
CREATE TABLE [dbo].[CollectionTheme] (
    [Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Theme] NVARCHAR (100) NOT NULL,
    CONSTRAINT [pk_CollectionTheme] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [un_COllectionTheme] UNIQUE NONCLUSTERED ([Theme] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[DateField]…';


GO
CREATE TABLE [dbo].[DateField] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    [Value]            DATETIME       NOT NULL,
    CONSTRAINT [pk_DateField] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[IntField]…';


GO
CREATE TABLE [dbo].[IntField] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    [Value]            INT            NOT NULL,
    CONSTRAINT [pk_IntField] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[StringField]…';


GO
CREATE TABLE [dbo].[StringField] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    [Value]            NVARCHAR (300) NOT NULL,
    CONSTRAINT [pk_StringField] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[TextField]…';


GO
CREATE TABLE [dbo].[TextField] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    [Value]            NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [pk_TextField] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[UserComment]…';


GO
CREATE TABLE [dbo].[UserComment] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    [UserId]           NVARCHAR (450) NOT NULL,
    [Text]             NVARCHAR (MAX) NOT NULL,
    [Date]             DATETIME       NOT NULL,
    CONSTRAINT [pk_UserComment] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[UserLike]…';


GO
CREATE TABLE [dbo].[UserLike] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    [UserId]           NVARCHAR (450) NOT NULL,
    CONSTRAINT [pk_UserLike] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetRoleClaims_AspNetRoles_RoleId]…';


GO
ALTER TABLE [dbo].[AspNetRoleClaims] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserClaims_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[AspNetUserClaims] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserLogins_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[AspNetUserLogins] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserRoles_AspNetRoles_RoleId]…';


GO
ALTER TABLE [dbo].[AspNetUserRoles] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserRoles_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[AspNetUserRoles] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserTokens_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[AspNetUserTokens] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_BooleanField_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[BooleanField] WITH NOCHECK
    ADD CONSTRAINT [FK_BooleanField_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_Collection_CollectionTheme_CollectionThemeId]…';


GO
ALTER TABLE [dbo].[Collection] WITH NOCHECK
    ADD CONSTRAINT [FK_Collection_CollectionTheme_CollectionThemeId] FOREIGN KEY ([CollectionThemeId]) REFERENCES [dbo].[CollectionTheme] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_CollectionItemTag_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[CollectionItemTag] WITH NOCHECK
    ADD CONSTRAINT [FK_CollectionItemTag_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_DateField_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[DateField] WITH NOCHECK
    ADD CONSTRAINT [FK_DateField_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_StringField_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[StringField] WITH NOCHECK
    ADD CONSTRAINT [FK_StringField_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_TextField_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[TextField] WITH NOCHECK
    ADD CONSTRAINT [FK_TextField_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_UserComment_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[UserComment] WITH NOCHECK
    ADD CONSTRAINT [FK_UserComment_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_UserComment_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[UserComment] WITH NOCHECK
    ADD CONSTRAINT [FK_UserComment_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_UserLike_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[UserLike] WITH NOCHECK
    ADD CONSTRAINT [FK_UserLike_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_UserLike_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[UserLike] WITH NOCHECK
    ADD CONSTRAINT [FK_UserLike_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_CollectionItem_Collection_CollectionId]…';


GO
ALTER TABLE [dbo].[CollectionItem] WITH NOCHECK
    ADD CONSTRAINT [FK_CollectionItem_Collection_CollectionId] FOREIGN KEY ([CollectionId]) REFERENCES [dbo].[Collection] ([Id]);


GO
PRINT N'Существующие данные проверяются относительно вновь созданных ограничений';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[AspNetRoleClaims] WITH CHECK CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId];

ALTER TABLE [dbo].[AspNetUserClaims] WITH CHECK CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId];

ALTER TABLE [dbo].[AspNetUserLogins] WITH CHECK CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId];

ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId];

ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId];

ALTER TABLE [dbo].[AspNetUserTokens] WITH CHECK CHECK CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId];

ALTER TABLE [dbo].[BooleanField] WITH CHECK CHECK CONSTRAINT [FK_BooleanField_CollectionItem_CollectionItemId];

ALTER TABLE [dbo].[Collection] WITH CHECK CHECK CONSTRAINT [FK_Collection_CollectionTheme_CollectionThemeId];

ALTER TABLE [dbo].[CollectionItemTag] WITH CHECK CHECK CONSTRAINT [FK_CollectionItemTag_CollectionItem_CollectionItemId];

ALTER TABLE [dbo].[DateField] WITH CHECK CHECK CONSTRAINT [FK_DateField_CollectionItem_CollectionItemId];

ALTER TABLE [dbo].[StringField] WITH CHECK CHECK CONSTRAINT [FK_StringField_CollectionItem_CollectionItemId];

ALTER TABLE [dbo].[TextField] WITH CHECK CHECK CONSTRAINT [FK_TextField_CollectionItem_CollectionItemId];

ALTER TABLE [dbo].[UserComment] WITH CHECK CHECK CONSTRAINT [FK_UserComment_CollectionItem_CollectionItemId];

ALTER TABLE [dbo].[UserComment] WITH CHECK CHECK CONSTRAINT [FK_UserComment_AspNetUsers_UserId];

ALTER TABLE [dbo].[UserLike] WITH CHECK CHECK CONSTRAINT [FK_UserLike_CollectionItem_CollectionItemId];

ALTER TABLE [dbo].[UserLike] WITH CHECK CHECK CONSTRAINT [FK_UserLike_AspNetUsers_UserId];

ALTER TABLE [dbo].[CollectionItem] WITH CHECK CHECK CONSTRAINT [FK_CollectionItem_Collection_CollectionId];


GO
PRINT N'Обновление завершено.';


GO
