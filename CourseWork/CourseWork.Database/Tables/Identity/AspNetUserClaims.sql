CREATE TABLE [dbo].[AspNetUserClaims]
(
	[Id] INT NOT NULL IDENTITY(1,1),
	[UserId] NVARCHAR(450) NOT NULL,
	[ClaimType] NVARCHAR(450) NULL,
	[ClaimValue] NVARCHAR(450) NULL,
	CONSTRAINT pk_AspNetUserClaims PRIMARY KEY ([Id])
)
