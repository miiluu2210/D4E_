/* 
1. Dựa vào bảng SalesOrderHeader, bạn hãy tìm ra những khách hàng mua hàng nhiều nhất. 

2. Dựa vào bảng SalesOrderDetail, bạn hãy tìm ra những item nào được mua nhiều nhất. 

3. Dựa vào bảng ProductCostHistory, tìm ra những sản phẩm nào có nhiều lần thay đổi giá bán nhất? 

4. Tìm tổng doanh số của các sản phẩm bị thay đổi giá bán nhiều nhất?

5. Tìm ra subcategory có tổng doanh số lớn nhất.

*/ 
--1. 
SELECT 
    CustomerID, 
    COUNT(SalesOrderID) AS 'Number Orders'
FROM SalesOrderHeader 
GROUP BY CustomerID 
HAVING COUNT(SalesOrderID) >=  ALL(SELECT 
                                    COUNT(SalesOrderID) AS 'Number Orders'
                                    FROM SalesOrderHeader 
                                    GROUP BY CustomerID
                                )


--2. 
SELECT ProductID,
       SUM(OrderQty) AS 'Total Orders'
FROM SalesOrderDetails 
GROUP BY ProductID 
HAVING SUM(OrderQty) >= ALL(SELECT SUM(OrderQty)
                            FROM SalesOrderDetails
                            GROUP BY ProductID)

--3. Dựa vào bảng ProductCostHistory, tìm ra những sản phẩm nào có nhiều 
--   lần thay đổi giá bán nhất? 
SELECT ProductID,
        COUNT(StandardCost) - 1  AS 'Number change cost'
FROM Production.ProductCostHistory
GROUP BY ProductID 
HAVING COUNT(StandardCost) - 1 >= ALL(SELECT 
                                        COUNT(StandardCost) - 1 
                                        FROM Production.ProductCostHistory
                                        GROUP BY ProductID )


--4. Tìm tổng doanh số của các sản phẩm bị thay đổi giá bán nhiều nhất?
WITH X AS (
    SELECT ProductID,
        COUNT(StandardCost) - 1  AS 'Number change cost'
    FROM Production.ProductCostHistory
    GROUP BY ProductID 
    HAVING COUNT(StandardCost) - 1 >= ALL(SELECT 
                                            COUNT(StandardCost) - 1 
                                            FROM Production.ProductCostHistory
                                            GROUP BY ProductID )
)
SELECT 
    X.[ProductID], 
    SUM(LineTotal) as 'Sum Sales'
FROM X  LEFT JOIN SalesOrderDetails SSOD 
    ON X.ProductID = SSOD.ProductID
GROUP BY X.ProductID

--5. Tìm ra subcategory có tổng doanh số lớn nhất. 
SELECT 
    ProductSubcategoryID, 
    SUM(LineTotal) AS 'Sum Sales'
FROM Production.Product PP 
     JOIN SalesOrderDetails SSOD 
     ON PP.ProductID = SSOD.ProductID 
GROUP BY ProductSubcategoryID
HAVING SUM(LineTotal) >= ALL( SELECT SUM(LineTotal)
                              FROM Production.Product PP 
                                    JOIN SalesOrderDetails SSOD 
                                    ON PP.ProductID = SSOD.ProductID 
                                GROUP BY ProductSubcategoryID)

/*
Xây dựng VIEW vCustomerInfo, tìm ra thông tin của các khách hàng 
gồm mã khách hàng, họ tên, khu vực mà họ đăng ký mua hàng, biết rằng, 
khách hàng sẽ có persontype trong bảng Person là IN
*/
CREATE VIEW vCustomerInfo AS (
    SELECT 
        CustomerID,
        FirstName,
        MiddleName,
        LastName,
        StoreID,
        TerritoryID
    FROM Person JOIN Customer ON Person.BusinessEntityID = Customer.PersonID
    WHERE PersonType = 'IN'
)

SELECT * 
FROM vCustomerInfo