CREATE TABLE [dbo].[Tag]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[CollectionItemId] INT NOT NULL,
	CONSTRAINT pk_Tag PRIMARY KEY([Id]),
	CONSTRAINT un_Tag UNIQUE([Name])
)
