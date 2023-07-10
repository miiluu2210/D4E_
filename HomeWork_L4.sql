--Solution for homework 
--Lesson 4 
-- Quest 1: 
SELECT *, 
       CASE 
            WHEN Price >= 50 THEN N'giá trị cao'
            ELSE N'giá trị thấp'
        END AS 'Product Type'
FROM SANPHAM

--Quest 2: Bạn hãy tìm ra tổng doanh số và tổng số sản phẩm bán được của từng ProductCategoryID
SELECT 
    ProductCategoryID, 
    SUM(QTY) as 'Total Order'
FROM HOADON JOIN SANPHAM
    ON HOADON.ProductID = SANPHAM.ProductId
GROUP BY ProductCategoryID
UNION ALL
SELECT 
    ProductCategoryID, 
    SUM(QTY) as 'Total Order'
FROM HOADON_MOI JOIN SANPHAM
    ON HOADON_MOI.ProductID = SANPHAM.ProductId
GROUP BY ProductCategoryID
-- Option 2: 

SELECT * 
INTO tmp_HOADON
FROM HOADON 
UNION ALL 
SELECT *
FROM HOADON_MOI

SELECT ProductCategoryID, 
        SUM(QTY) AS 'Total Order'
FROM tmp_HOADON JOIN SANPHAM 
     ON tmp_HOADON.ProductID = SANPHAM.ProductId
GROUP BY ProductCategoryID
--Quest 3: 
SELECT * 
INTO tmp_HOADON
FROM HOADON 
UNION ALL 
SELECT *
FROM HOADON_MOI 

SELECT 
    SalesID, 
    SUM(TotalLine) as 'Sum Sales',
    CASE 
        WHEN SUM(TotalLine) > 350 THEN 'Excellent Staff'
        ELSE 'Normal Staff'
    END AS 'sale_type'
FROM tmp_HOADON 
GROUP BY SalesID

--Quest 4: 
SELECT 
    ProductCategoryID,
    SUM(QTY) as 'Order M3'
INTO tmp_order_m3
FROM HOADON JOIN SANPHAM 
     ON HOADON.ProductID = SANPHAM.ProductId
GROUP BY ProductCategoryID

SELECT 
    ProductCategoryID,
    SUM(QTY) as 'Order M5'
INTO tmp_order_m5
FROM HOADON_MOI JOIN SANPHAM 
     ON HOADON_MOI.ProductID = SANPHAM.ProductId
GROUP BY ProductCategoryID


SELECT tmp_order_m3.ProductCategoryID,
       [Order M3],
       [Order M5],
       CASE 
        WHEN CAST([Order M5] AS float) /CAST([Order M3] AS float) > 1 THEN CONCAT(N'Tăng ', CAST([Order M5] AS float) /CAST([Order M3] AS float))
        WHEN CAST([Order M5] AS float) / CAST([Order M3] AS float) = 1 THEN N'Không thay đổi'
        ELSE CONCAT(N'Giảm ', CAST([Order M5] AS float) / CAST([Order M3] AS float) )
       END AS N'Tăng/Giảm'
FROM tmp_order_m3, tmp_order_m5 
WHERE tmp_order_m3.ProductCategoryID = tmp_order_m5.ProductCategoryID


