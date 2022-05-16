﻿CREATE TABLE [dbo].[TextField]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[CollectionItemId] INT NOT NULL,
	[Name] NVARCHAR(100) NOT NULL,
	[Value] NVARCHAR(MAX) NOT NULL,
	CONSTRAINT pk_TextField PRIMARY KEY([Id])
)