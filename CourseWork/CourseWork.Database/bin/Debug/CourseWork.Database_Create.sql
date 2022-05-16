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
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

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
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Идет создание базы данных $(DatabaseName)…'
GO
CREATE DATABASE [$(DatabaseName)] COLLATE SQL_Latin1_General_CP1_CI_AS
GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Параметры базы данных изменить нельзя. Применить эти параметры может только пользователь SysAdmin.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


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
PRINT N'Идет создание Индекс [dbo].[AspNetUsers].[UserNameIndex]…';


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[AspNetUsers]([NormalizedUserName] ASC) WHERE [NormalizedUserName] IS NOT NULL;


GO
PRINT N'Идет создание Индекс [dbo].[AspNetUsers].[EmailIndex]…';


GO
CREATE NONCLUSTERED INDEX [EmailIndex]
    ON [dbo].[AspNetUsers]([NormalizedEmail] ASC);


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
PRINT N'Идет создание Таблица [dbo].[UserLike]…';


GO
CREATE TABLE [dbo].[UserLike] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    [UserId]           NVARCHAR (450) NOT NULL,
    CONSTRAINT [pk_UserLike] PRIMARY KEY CLUSTERED ([Id] ASC)
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
PRINT N'Идет создание Таблица [dbo].[CollectionTheme]…';


GO
CREATE TABLE [dbo].[CollectionTheme] (
    [Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Theme] NVARCHAR (100) NOT NULL,
    CONSTRAINT [pk_CollectionTheme] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [un_CollectionTheme] UNIQUE NONCLUSTERED ([Theme] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[CollectionItem]…';


GO
CREATE TABLE [dbo].[CollectionItem] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [CollectionId] INT            NOT NULL,
    [Name]         NVARCHAR (100) NOT NULL,
    CONSTRAINT [pk_CollectionItem] PRIMARY KEY CLUSTERED ([Id] ASC)
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
    [Id]               INT IDENTITY (1, 1) NOT NULL,
    [CollectionItemId] INT NOT NULL,
    [TagId]            INT NOT NULL,
    CONSTRAINT [pk_CollectionItemTag] PRIMARY KEY CLUSTERED ([Id] ASC)
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
PRINT N'Идет создание Таблица [dbo].[ImageSize]…';


GO
CREATE TABLE [dbo].[ImageSize] (
    [Id]           INT IDENTITY (1, 1) NOT NULL,
    [CollectionId] INT NOT NULL,
    [Height]       INT NOT NULL,
    [Width]        INT NOT NULL,
    CONSTRAINT [pk_ImageSize] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[Tag]…';


GO
CREATE TABLE [dbo].[Tag] (
    [Id]               INT            IDENTITY (1, 1) NOT NULL,
    [Name]             NVARCHAR (100) NOT NULL,
    [CollectionItemId] INT            NOT NULL,
    CONSTRAINT [pk_Tag] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [un_Tag] UNIQUE NONCLUSTERED ([Name] ASC)
);


GO
PRINT N'Идет создание Таблица [dbo].[CollectionRequiredFields]…';


GO
CREATE TABLE [dbo].[CollectionRequiredFields] (
    [Id]                    INT            IDENTITY (1, 1) NOT NULL,
    [CollectionId]          INT            NOT NULL,
    [Boolean1FieldRequired] BIT            NOT NULL,
    [Boolean1FieldName]     NVARCHAR (100) NOT NULL,
    [Boolean2FieldRequired] BIT            NOT NULL,
    [Boolean2FieldName]     NVARCHAR (100) NOT NULL,
    [Boolean3FieldRequired] BIT            NOT NULL,
    [Boolean3FieldName]     NVARCHAR (100) NOT NULL,
    [Date1FieldRequired]    BIT            NOT NULL,
    [Date1FieldName]        NVARCHAR (100) NOT NULL,
    [Date2FieldRequired]    BIT            NOT NULL,
    [Date2FieldName]        NVARCHAR (100) NOT NULL,
    [Date3FieldRequired]    BIT            NOT NULL,
    [Date3FieldName]        NVARCHAR (100) NOT NULL,
    [Int1FieldRequired]     BIT            NOT NULL,
    [Int1FieldName]         NVARCHAR (100) NOT NULL,
    [Int2FieldRequired]     BIT            NOT NULL,
    [Int2FieldName]         NVARCHAR (100) NOT NULL,
    [Int3FieldRequired]     BIT            NOT NULL,
    [Int3FieldName]         NVARCHAR (100) NOT NULL,
    [String1FieldRequired]  BIT            NOT NULL,
    [String1FieldName]      NVARCHAR (100) NOT NULL,
    [String2FieldRequired]  BIT            NOT NULL,
    [String2FieldName]      NVARCHAR (100) NOT NULL,
    [String3FieldRequired]  BIT            NOT NULL,
    [String3FieldName]      NVARCHAR (100) NOT NULL,
    [Text1FieldRequired]    BIT            NOT NULL,
    [Text1FieldName]        NVARCHAR (100) NOT NULL,
    [Text2FieldRequired]    BIT            NOT NULL,
    [Text2FieldName]        NVARCHAR (100) NOT NULL,
    [Text3FieldRequired]    BIT            NOT NULL,
    [Text3FieldName]        NVARCHAR (100) NOT NULL,
    CONSTRAINT [pk_CollectionRequiredFields] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserTokens_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[AspNetUserTokens]
    ADD CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserRoles_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[AspNetUserRoles]
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserRoles_AspNetRoles_RoleId]…';


GO
ALTER TABLE [dbo].[AspNetUserRoles]
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserLogins_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[AspNetUserLogins]
    ADD CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetUserClaims_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[AspNetUserClaims]
    ADD CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_AspNetRoleClaims_AspNetRoles_RoleId]…';


GO
ALTER TABLE [dbo].[AspNetRoleClaims]
    ADD CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_UserLike_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[UserLike]
    ADD CONSTRAINT [FK_UserLike_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_UserLike_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[UserLike]
    ADD CONSTRAINT [FK_UserLike_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_UserComment_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[UserComment]
    ADD CONSTRAINT [FK_UserComment_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_UserComment_AspNetUsers_UserId]…';


GO
ALTER TABLE [dbo].[UserComment]
    ADD CONSTRAINT [FK_UserComment_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_CollectionItem_Collection_CollectionId]…';


GO
ALTER TABLE [dbo].[CollectionItem]
    ADD CONSTRAINT [FK_CollectionItem_Collection_CollectionId] FOREIGN KEY ([CollectionId]) REFERENCES [dbo].[Collection] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_TextField_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[TextField]
    ADD CONSTRAINT [FK_TextField_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_StringField_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[StringField]
    ADD CONSTRAINT [FK_StringField_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_DateField_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[DateField]
    ADD CONSTRAINT [FK_DateField_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_BooleanField_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[BooleanField]
    ADD CONSTRAINT [FK_BooleanField_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_Collection_CollectionTheme_CollectionThemeId]…';


GO
ALTER TABLE [dbo].[Collection]
    ADD CONSTRAINT [FK_Collection_CollectionTheme_CollectionThemeId] FOREIGN KEY ([CollectionThemeId]) REFERENCES [dbo].[CollectionTheme] ([Id]);


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_IntField_ColletionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[IntField]
    ADD CONSTRAINT [FK_IntField_ColletionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_ImageSize_Collection_CollectionId]…';


GO
ALTER TABLE [dbo].[ImageSize]
    ADD CONSTRAINT [FK_ImageSize_Collection_CollectionId] FOREIGN KEY ([CollectionId]) REFERENCES [dbo].[Collection] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_Tag_CollectionItem_CollectionItemId]…';


GO
ALTER TABLE [dbo].[Tag]
    ADD CONSTRAINT [FK_Tag_CollectionItem_CollectionItemId] FOREIGN KEY ([CollectionItemId]) REFERENCES [dbo].[CollectionItem] ([Id]) ON DELETE CASCADE;


GO
PRINT N'Идет создание Внешний ключ [dbo].[FK_CollectionRequiredFields_Collection_CollectionId]…';


GO
ALTER TABLE [dbo].[CollectionRequiredFields]
    ADD CONSTRAINT [FK_CollectionRequiredFields_Collection_CollectionId] FOREIGN KEY ([CollectionId]) REFERENCES [dbo].[Collection] ([Id]) ON DELETE CASCADE;


GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET MULTI_USER 
    WITH ROLLBACK IMMEDIATE;


GO
PRINT N'Обновление завершено.';


GO
