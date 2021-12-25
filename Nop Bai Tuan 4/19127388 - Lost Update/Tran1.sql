USE Nhom18_DoAnThucHanh
GO

select * from ChiNhanh
SELECT * FROM HopDong





UPDATE CHINHANH
SET MAHOPDONG = NULL
WHERE MACHINHANH = 1 AND MaDoanhNghiep = '33847'

INSERT INTO ChiNhanh 
VALUES('1', '33847', 9, 10, NULL)

EXEC  insertNewBranchToContract '1' , '33847', '10' 

SELECT * FROM SANPHAM