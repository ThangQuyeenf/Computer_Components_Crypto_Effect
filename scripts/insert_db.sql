USE [Computer_Components]
GO
/****** Object:  Table [dbo].[DIM_CPU_PROD]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[DIM_CPU_PROD]
FROM 'G:\Source\effect-data\data\DIM_CPU_PROD.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[DIM_CRYPTO_DATA]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[DIM_CRYPTO_DATA]
FROM 'G:\Source\effect-data\data\DIM_CRYPTO_DATA.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[DIM_GPU_PROD]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[DIM_GPU_PROD]
FROM 'G:\Source\effect-data\data\DIM_GPU_PROD.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[DIM_MERCHANT]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[DIM_MERCHANT]
FROM 'G:\Source\effect-data\data\DIM_MERCHANT.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[DIM_RAM_PROD]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[DIM_RAM_PROD]
FROM 'G:\Source\effect-data\data\DIM_RAM_PROD.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[DIM_REGION]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[DIM_REGION]
FROM 'G:\Source\effect-data\data\DIM_REGION.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[DIM_TIME]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[DIM_TIME]
FROM 'G:\Source\effect-data\data\DIM_TIME.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[FACT_CPU_PRICE]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[FACT_CPU_PRICE]
FROM 'G:\Source\effect-data\data\FACT_CPU_PRICE.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[FACT_CRYPTO_RATE]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[FACT_CRYPTO_RATE]
FROM 'G:\Source\effect-data\data\FACT_CRYPTO_RATE.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[FACT_GPU_PRICE]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[FACT_GPU_PRICE]
FROM 'G:\Source\effect-data\data\FACT_GPU_PRICE.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO

/****** Object:  Table [dbo].[FACT_RAM_PRICE]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
BULK INSERT [dbo].[FACT_RAM_PRICE]
FROM 'G:\Source\effect-data\data\FACT_RAM_PRICE.csv'
WITH (
	FORMAT='CSV',
	FIRSTROW=2,
	FIELDTERMINATOR=',',
	ROWTERMINATOR='0x0a'
)
GO
