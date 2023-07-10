--Solution for homework 
-- lesson 3
--Quest 1: 
SELECT HOADON.*
FROM HOADON JOIN SANPHAM 
    ON HOADON.ProductID = SANPHAM.ProductId
WHERE 
    CategoryName ='Chip'

--Quest 2: 
SELECT HOADON.* 
FROM HOADON JOIN NHANVIEN 
    ON HOADON.SalesID = NHANVIEN.EmID 
WHERE 
    EmName LIKE '%Linh'

--Quest 3: 
SELECT *
INTO tmp_HOADON
FROM HOADON 
UNION ALL 
SELECT * 
FROM HOADON_MOI 

--Cau 1 with 2 bảng
SELECT tmp_HOADON.*
FROM tmp_HOADON JOIN SANPHAM 
    ON tmp_HOADON.ProductID = SANPHAM.ProductId
WHERE 
    CategoryName ='Chip'

--Cau 2 with 2 bảng: 
SELECT tmp_HOADON.*
FROM tmp_HOADON JOIN NHANVIEN
    ON tmp_HOADON.SalesID = NHANVIEN.EmID
WHERE 
    EmName LIKE '%Linh'

--Quest 4: 
SELECT DISTINCT DATEDIFF(D, OrderDate, DateCreate) as 'Number Date'
FROM tmp_HOADON