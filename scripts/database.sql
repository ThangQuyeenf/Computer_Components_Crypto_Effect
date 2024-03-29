USE [Computer_Components]
GO
/****** Object:  Table [dbo].[DIM_CPU_PROD]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_CPU_PROD](
	[Id] [int] NOT NULL PRIMARY KEY,
	[Manufacturer] [nvarchar](255) NULL,
	[Series] [nvarchar](255) NULL,
	[CPU_Name] [nvarchar](255) NULL,
	[Cores] [int] NULL,
	[Socket] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIM_CRYPTO_DATA]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_CRYPTO_DATA](
	[Id] [int] NOT NULL PRIMARY KEY,
	[Code] [nvarchar](255) NULL,
	[Currency_Name] [nvarchar](255) NULL,
	[Is_Mineable] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIM_GPU_PROD]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_GPU_PROD](
	[Id] [int] NOT NULL PRIMARY KEY,
	[Processor_Manufacturer] [nvarchar](255) NULL,
	[Processor] [nvarchar](255) NULL,
	[GPU_Manufacturer] [nvarchar](255) NULL,
	[Memory_Capacity] [float] NULL,
	[Memory_Type] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIM_MERCHANT]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_MERCHANT](
	[Id] [int] NOT NULL PRIMARY KEY,
	[Merchant] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIM_RAM_PROD]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_RAM_PROD](
	[Id] [int] NOT NULL PRIMARY KEY,
	[Manufacturer] [nvarchar](255) NULL,
	[RAM_Name] [nvarchar](255) NULL,
	[Memory_Type] [nvarchar](255) NULL,
	[Speed] [int] NULL,
	[Capacity] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIM_REGION]     PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_REGION](
	[Id] [int] NOT NULL PRIMARY KEY,
	[Code] [nvarchar](255) NULL,
	[Currency] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DIM_TIME]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DIM_TIME](
	[Id] [int] NOT NULL PRIMARY KEY,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[Day] [int] NULL,
	[Week] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FACT_CPU_PRICE]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FACT_CPU_PRICE](
	[ProdId] [int] NULL,
	[TimeId] [int] NULL,
	[RegionId] [int] NULL,
	[MerchantId] [int] NULL,
	[Price_USD] [float] NULL,
	[Price_Original] [float] NULL
) ON [PRIMARY]
GO
-- Thêm Foreign Key cho cột ProdId
ALTER TABLE [dbo].[FACT_CPU_PRICE]
ADD CONSTRAINT FK_FACT_CPU_PRICE_DIM_CPU_PROD
FOREIGN KEY (ProdId) REFERENCES [dbo].[DIM_CPU_PROD](Id);

-- Thêm Foreign Key cho cột TimeId
ALTER TABLE [dbo].[FACT_CPU_PRICE]
ADD CONSTRAINT FK_FACT_CPU_PRICE_DIM_TIME
FOREIGN KEY (TimeId) REFERENCES [dbo].[DIM_TIME](Id);

-- Thêm Foreign Key cho cột RegionId
ALTER TABLE [dbo].[FACT_CPU_PRICE]
ADD CONSTRAINT FK_FACT_CPU_PRICE_DIM_REGION
FOREIGN KEY (RegionId) REFERENCES [dbo].[DIM_REGION](Id);

-- Thêm Foreign Key cho cột MerchantId
ALTER TABLE [dbo].[FACT_CPU_PRICE]
ADD CONSTRAINT FK_FACT_CPU_PRICE_DIM_MERCHANT
FOREIGN KEY (MerchantId) REFERENCES [dbo].[DIM_MERCHANT](Id);
GO
/****** Object:  Table [dbo].[FACT_CRYPTO_RATE]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FACT_CRYPTO_RATE](
	[CodeId] [int] NULL,
	[TimeId] [int] NULL,
	[OpenPrice] [float] NULL,
	[ClosePrice] [float] NULL,
	[High] [float] NULL,
	[Low] [float] NULL
) ON [PRIMARY]
GO
-- Thêm Foreign Key cho cột CodeId
ALTER TABLE [dbo].[FACT_CRYPTO_RATE]
ADD CONSTRAINT FK_FACT_CRYPTO_RATE_CodeId
FOREIGN KEY (CodeId) REFERENCES [dbo].[DIM_CRYPTO_DATA](Id);

-- Thêm Foreign Key cho cột TimeId
ALTER TABLE [dbo].[FACT_CRYPTO_RATE]
ADD CONSTRAINT FK_FACT_CRYPTO_RATE_TimeId
FOREIGN KEY (TimeId) REFERENCES [dbo].[DIM_TIME](Id);

GO
/****** Object:  Table [dbo].[FACT_GPU_PRICE]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FACT_GPU_PRICE](
	[ProdId] [int] NULL,
	[TimeId] [int] NULL,
	[RegionId] [int] NULL,
	[MerchantId] [int] NULL,
	[Price_USD] [float] NULL,
	[Price_Original] [float] NULL
) ON [PRIMARY]
GO
-- Thêm Foreign Key cho cột ProdId
ALTER TABLE [dbo].[FACT_GPU_PRICE]
ADD CONSTRAINT FK_FACT_GPU_PRICE_DIM_GPU_PROD
FOREIGN KEY (ProdId) REFERENCES [dbo].[DIM_GPU_PROD](Id);

-- Thêm Foreign Key cho cột TimeId
ALTER TABLE [dbo].[FACT_GPU_PRICE]
ADD CONSTRAINT FK_FACT_GPU_PRICE_DIM_TIME
FOREIGN KEY (TimeId) REFERENCES [dbo].[DIM_TIME](Id);

-- Thêm Foreign Key cho cột RegionId
ALTER TABLE [dbo].[FACT_GPU_PRICE]
ADD CONSTRAINT FK_FACT_GPU_PRICE_DIM_REGION
FOREIGN KEY (RegionId) REFERENCES [dbo].[DIM_REGION](Id);

-- Thêm Foreign Key cho cột MerchantId
ALTER TABLE [dbo].[FACT_GPU_PRICE]
ADD CONSTRAINT FK_FACT_GPU_PRICE_DIM_MERCHANT
FOREIGN KEY (MerchantId) REFERENCES [dbo].[DIM_MERCHANT](Id);
GO
/****** Object:  Table [dbo].[FACT_RAM_PRICE]    ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FACT_RAM_PRICE](
	[ProdId] [int] NULL,
	[TimeId] [int] NULL,
	[RegionId] [int] NULL,
	[MerchantId] [int] NULL,
	[Price_USD] [float] NULL,
	[Price_Original] [float] NULL
) ON [PRIMARY]
GO
-- Thêm Foreign Key cho cột ProdId
ALTER TABLE [dbo].[FACT_RAM_PRICE]
ADD CONSTRAINT FK_FACT_RAM_PRICE_DIM_RAM_PROD
FOREIGN KEY (ProdId) REFERENCES [dbo].[DIM_RAM_PROD](Id);

-- Thêm Foreign Key cho cột TimeId
ALTER TABLE [dbo].[FACT_RAM_PRICE]
ADD CONSTRAINT FK_FACT_RAM_PRICE_DIM_TIME
FOREIGN KEY (TimeId) REFERENCES [dbo].[DIM_TIME](Id);

-- Thêm Foreign Key cho cột RegionId
ALTER TABLE [dbo].[FACT_RAM_PRICE]
ADD CONSTRAINT FK_FACT_RAM_PRICE_DIM_REGION
FOREIGN KEY (RegionId) REFERENCES [dbo].[DIM_REGION](Id);

-- Thêm Foreign Key cho cột MerchantId
ALTER TABLE [dbo].[FACT_RAM_PRICE]
ADD CONSTRAINT FK_FACT_RAM_PRICE_DIM_MERCHANT
FOREIGN KEY (MerchantId) REFERENCES [dbo].[DIM_MERCHANT](Id);
GO
