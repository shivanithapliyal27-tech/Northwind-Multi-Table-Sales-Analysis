USE NorthwindAnalysis;

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
GO

SELECT COUNT(*) AS OrdersRows
FROM dbo.orders;

SELECT COUNT(*) AS CustomersRows
FROM dbo.customers;

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

SELECT TOP 20
    c.CustomerID,
    c.CompanyName,
    o.OrderID,
    o.OrderDate,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    od.Discount,
    CAST(
        od.Quantity * od.UnitPrice * (1 - od.Discount)
        AS DECIMAL(12,2)
    ) AS SalesAmount
FROM dbo.customers AS c
INNER JOIN dbo.orders AS o
    ON c.CustomerID = o.CustomerID
INNER JOIN dbo.[order-details] AS od
    ON o.OrderID = od.OrderID
INNER JOIN dbo.products AS p
    ON od.ProductID = p.ProductID
ORDER BY o.OrderDate;

SELECT
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COUNT(DISTINCT o.CustomerID) AS TotalCustomers,
    SUM(
        od.Quantity * od.UnitPrice * (1 - od.Discount)
    ) AS TotalSales,
    SUM(od.Quantity) AS TotalUnitsSold
FROM dbo.orders AS o
INNER JOIN dbo.[order-details] AS od
    ON o.OrderID = od.OrderID;


SELECT TOP 10
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantitySold,
    CAST(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))
        AS DECIMAL(12,2)
    ) AS TotalSales
FROM dbo.products AS p
INNER JOIN dbo.[order-details] AS od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalSales DESC;

SELECT
    YEAR(o.OrderDate) AS SalesYear,
    MONTH(o.OrderDate) AS SalesMonth,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    CAST(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))
        AS DECIMAL(12,2)
    ) AS MonthlySales
FROM dbo.orders AS o
INNER JOIN dbo.[order-details] AS od
    ON o.OrderID = od.OrderID
GROUP BY
    YEAR(o.OrderDate),
    MONTH(o.OrderDate)
ORDER BY
    SalesYear,
    SalesMonth;


SELECT TOP 10
    c.CustomerID,
    c.CompanyName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    CAST(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))
        AS DECIMAL(12,2)
    ) AS TotalSales
FROM dbo.customers AS c
INNER JOIN dbo.orders AS o
    ON c.CustomerID = o.CustomerID
INNER JOIN dbo.[order-details] AS od
    ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID,
    c.CompanyName
ORDER BY TotalSales DESC;

SELECT
    p.CategoryID,
    COUNT(DISTINCT p.ProductID) AS TotalProducts,
    SUM(od.Quantity) AS TotalUnitsSold,
    CAST(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))
        AS DECIMAL(12,2)
    ) AS TotalSales
FROM dbo.products AS p
INNER JOIN dbo.[order-details] AS od
    ON p.ProductID = od.ProductID
GROUP BY p.CategoryID
ORDER BY TotalSales DESC;

SELECT
    COUNT(*) AS TotalOrders,
    SUM(CASE
        WHEN ShippedDate IS NULL THEN 1
        ELSE 0
    END) AS NotYetShipped,
    AVG(CAST(
        DATEDIFF(DAY, OrderDate, ShippedDate)
        AS FLOAT
    )) AS AvgShippingDays
FROM dbo.orders;