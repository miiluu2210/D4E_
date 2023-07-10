--Solution for HW
--Lesson 5
SELECT DISTINCT DepID, DepName
FROM NHANVIEN

--Quest 1: 
CREATE VIEW vHeadOffice AS (
    SELECT * 
    FROM NHANVIEN 
    WHERE DepID = 1
)

CREATE VIEW vFinance AS (
    SELECT * 
    FROM NHANVIEN 
    WHERE DepID = 2
)

CREATE VIEW vOperation AS (
    SELECT * 
    FROM NHANVIEN 
    WHERE DepID = 3
)

CREATE VIEW vData AS (
    SELECT * 
    FROM NHANVIEN 
    WHERE DepID = 4
)

CREATE VIEW vAccounting_Sales AS (
    SELECT * 
    FROM NHANVIEN 
    WHERE DepID = 5
)

--Quest 2: 
WITH TotalSale AS (
    SELECT 
    SalesID, 
    SUM(TotalLine) AS 'Total Sales'
FROM (
    SELECT *
    FROM HOADON
    UNION ALL 
    SELECT * 
    FROM HOADON_MOI
    ) AS X
GROUP BY SalesID
)
SELECT 
    SalesID,
    [Total Sales] as 'Max/Min Sales',
    (SELECT AVG([Total Sales])
     FROM TotalSale) AS 'AVERAGE Sales', 
    [Total Sales] - (SELECT AVG([Total Sales])
                    FROM TotalSale) AS 'Range'
FROM TotalSale
WHERE [Total Sales] = (SELECT MAX([Total Sales]) FROM TotalSale)
    OR [Total Sales] = (SELECT MIN([Total Sales]) FROM TotalSale)


--Quest 3: 
--Như bên trên 

--Quest 4: 
WITH TT AS (
SELECT 
    ProductID,
    CusID, 
    SUM(QTY) as 'Total Orders'
FROM (
    SELECT *
    FROM HOADON
    UNION ALL 
    SELECT * 
    FROM HOADON_MOI
    ) AS X
GROUP BY 
         ProductID,
         CusID
) 
SELECT T1.ProductID, 
       CusID,
       [Total Orders]
FROM TT T1,
     (SELECT ProductID, MAX([Total Orders]) as 'Max Order'
      FROM TT 
      GROUP BY ProductID) AS T2
WHERE T1.[ProductID] = T2.ProductID 
      AND T1.[Total Orders] = T2.[Max Order]

--Quest 5:
WITH TT AS ( 
SELECT 
    ProductCategoryID, 
    X.ProductID,
    SUM(TotalLine) AS 'Total Sales'
FROM 
    (
        SELECT * 
        FROM HOADON 
        UNION ALL 
        SELECT * 
        FROM HOADON_MOI 
    ) AS X JOIN SANPHAM 
    ON X.ProductID = SANPHAM.ProductID
GROUP BY ProductCategoryID, X.ProductID
) 
SELECT ProductCategoryID, MAX([Total Sales]) - MIN([Total Sales]) AS 'Range'
FROM TT
GROUP BY ProductCategoryID
