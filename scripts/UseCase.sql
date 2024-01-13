/***Hiển thị các sản phẩm GPU có giá cao nhất trong mỗi khu vực: ***/
;
WITH RankedGPU AS (
    SELECT
        GPU.*,
		Price.[RegionId],
		Region.[Currency],
		Price.[Price_USD],
        RANK() OVER (PARTITION BY Price.[RegionId] ORDER BY Price.[Price_USD] DESC) AS Rank
    FROM
        [dbo].[DIM_GPU_PROD] AS GPU
    JOIN
        [dbo].[FACT_GPU_PRICE] AS Price ON GPU.[Id] = Price.[ProdId]
	JOIN
        [dbo].[DIM_REGION] AS Region ON Price.[RegionId] = Region.[Id]
)
SELECT
    *
FROM
    RankedGPU
WHERE
    Rank = 1;


/***Thống kê tổng doanh thu từ bán RAM theo tháng trong một khu vực cụ thể***/	
SELECT
    T.[Month],
    SUM(Price.[Price_USD]) AS TotalRevenue
FROM
    [dbo].[FACT_RAM_PRICE] AS Price
JOIN
    [dbo].[DIM_TIME] AS T ON Price.[TimeId] = T.[Id]
WHERE
    Price.[RegionId] = 2
GROUP BY
    T.[Month];


/***Danh sách các sản phẩm CPU có thể khai thác mỏ (Is_Mineable = 1) và thông tin giá tương ứng***/
SELECT
    CPU.[CPU_Name],
    CPU.[Manufacturer],
    Price.[Price_USD]
FROM
    [dbo].[DIM_CPU_PROD] AS CPU
JOIN
    [dbo].[FACT_CPU_PRICE] AS Price ON CPU.[Id] = Price.[ProdId]
JOIN
    [dbo].[DIM_CRYPTO_DATA] AS Crypto ON CPU.[Id] = Crypto.[Id]
WHERE
    Crypto.[Is_Mineable] = 1;


	/***Danh sách các sản phẩm GPU có thể khai thác mỏ (Is_Mineable = 1) và thông tin giá tương ứng***/
SELECT
    GPU.[Processor],
    GPU.[GPU_Manufacturer],
    Price.[Price_USD]
FROM
    [dbo].[DIM_GPU_PROD] AS GPU
JOIN
    [dbo].[FACT_GPU_PRICE] AS Price ON GPU.[Id] = Price.[ProdId]
JOIN
    [dbo].[DIM_CRYPTO_DATA] AS Crypto ON GPU.[Id] = Crypto.[Id]
WHERE
    Crypto.[Is_Mineable] = 1;


-- Hiển thị các khu vực có tổng giá của CPU vượt quá một ngưỡng cụ thể
SELECT
    Region.[Id] AS RegionId,
    Region.[Currency],
    SUM(Price.[Price_USD]) AS TotalPrice
FROM
    [dbo].[FACT_CPU_PRICE] AS Price
JOIN
    [dbo].[DIM_REGION] AS Region ON Price.[RegionId] = Region.[Id]
GROUP BY
    Region.[Id], Region.[Currency]
HAVING
    SUM(Price.[Price_USD]) > 5000000;


-- Tạo trigger để cập nhật thông tin thay đổi vào bảng log khi có giá mới của GPU
CREATE TRIGGER trg_UpdateGPUInfo
ON [dbo].[FACT_GPU_PRICE]
AFTER INSERT
AS
BEGIN
    INSERT INTO [dbo].[GPU_Log]
    SELECT
        [ProdId],
        [TimeId],
        [RegionId],
        [MerchantId],
        [Price_USD],
        [Price_Original],
        GETDATE() AS LogDate
    FROM
        inserted;
END;

INSERT INTO [dbo].[FACT_GPU_PRICE] (ProdId, TimeId, RegionId, MerchantId, Price_USD, Price_Original)
VALUES (997158, 1, 20140914, 2, 31, 651.7384130657);

SELECT * FROM sys.triggers WHERE parent_id = OBJECT_ID('[dbo].[FACT_GPU_PRICE]');

SELECT * FROM [dbo].[GPU_Log];

-- Tạo view để hiển thị thông tin chi tiết về giá và thông số kỹ thuật của CPU
CREATE VIEW vw_CPU_Details AS
SELECT
    CPU.[CPU_Name],
    CPU.[Cores],
    CPU.[Socket],
    Price.[Price_USD]
FROM
    [dbo].[DIM_CPU_PROD] AS CPU
JOIN
    [dbo].[FACT_CPU_PRICE] AS Price ON CPU.[Id] = Price.[ProdId];


-- Tạo stored procedure để lấy thông tin giá của RAM theo khu vực và thời gian
CREATE PROCEDURE sp_GetRAMPrice
    @RegionId INT,
    @TimeId INT
AS
BEGIN
    SELECT
        RAM.[RAM_Name],
        RAM.[Memory_Type],
        Price.[Price_USD]
    FROM
        [dbo].[DIM_RAM_PROD] AS RAM
    JOIN
        [dbo].[FACT_RAM_PRICE] AS Price ON RAM.[Id] = Price.[ProdId]
    WHERE
        Price.[RegionId] = @RegionId
        AND Price.[TimeId] = @TimeId;
END;

EXECUTE sp_GetRAMPrice  
	@RegionId = 4,
	@TimeId= 20130322;

-- Bắt đầu một giao dịch và thực hiện cập nhật giá mới cho CPU và GPU
BEGIN TRANSACTION;

UPDATE [dbo].[FACT_CPU_PRICE] SET [Price_USD] = 1200 WHERE [ProdId] = 1 AND [RegionId] = 1;
UPDATE [dbo].[FACT_GPU_PRICE] SET [Price_USD] = 800 WHERE [ProdId] = 3 AND [RegionId] = 2;

-- Kết thúc giao dịch, commit nếu thành công, rollback nếu có lỗi
COMMIT;
-- hoặc
ROLLBACK;


--- Highest CPU price all time 
WITH RankedPrices AS (
    SELECT
        Price.[ProdId],
        Price.[TimeId],
        Price.[Price_USD],
        ROW_NUMBER() OVER (PARTITION BY Price.[ProdId] ORDER BY Price.[Price_USD] DESC) AS PriceRank
    FROM
        [dbo].[FACT_CPU_PRICE] AS Price
)
SELECT
    CPU.*,
    Prices.[TimeId] AS HighestPriceTimeId,
    Prices.[Price_USD] AS HighestPrice
FROM
    [dbo].[DIM_CPU_PROD] AS CPU
JOIN
    RankedPrices AS Prices ON CPU.[Id] = Prices.[ProdId]
WHERE
    Prices.[PriceRank] = 1;

-- GPU and RAM
WITH RankedGPUPrices AS (
    SELECT
        GPU.[Id] AS ProdId,
        Price.[TimeId],
        Price.[Price_USD],
        ROW_NUMBER() OVER (PARTITION BY GPU.[Id] ORDER BY Price.[Price_USD] DESC) AS PriceRank
    FROM
        [dbo].[DIM_GPU_PROD] AS GPU
    JOIN
        [dbo].[FACT_GPU_PRICE] AS Price ON GPU.[Id] = Price.[ProdId]
),
RankedRAMPrices AS (
    SELECT
        RAM.[Id] AS ProdId,
        Price.[TimeId],
        Price.[Price_USD],
        ROW_NUMBER() OVER (PARTITION BY RAM.[Id] ORDER BY Price.[Price_USD] DESC) AS PriceRank
    FROM
        [dbo].[DIM_RAM_PROD] AS RAM
    JOIN
        [dbo].[FACT_RAM_PRICE] AS Price ON RAM.[Id] = Price.[ProdId]
)
SELECT
    'GPU' AS ProductType,
    GPU.*,
    GPUPrices.[TimeId] AS HighestPriceTimeId,
    GPUPrices.[Price_USD] AS HighestPrice
FROM
    [dbo].[DIM_GPU_PROD] AS GPU
JOIN
    RankedGPUPrices AS GPUPrices ON GPU.[Id] = GPUPrices.[ProdId]
WHERE
    GPUPrices.[PriceRank] = 1
UNION
SELECT
    'RAM' AS ProductType,
    RAM.*,
    RAMPrices.[TimeId] AS HighestPriceTimeId,
    RAMPrices.[Price_USD] AS HighestPrice
FROM
    [dbo].[DIM_RAM_PROD] AS RAM
JOIN
    RankedRAMPrices AS RAMPrices ON RAM.[Id] = RAMPrices.[ProdId]
WHERE
    RAMPrices.[PriceRank] = 1;
