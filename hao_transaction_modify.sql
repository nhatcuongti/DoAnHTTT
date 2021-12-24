
--Hiển thị danh sách company
  --Insert dữ liệu
	SELECT * FROM DoanhNghiep
	INSERT INTO DoanhNghiep
	VALUES('232132', N'ĐIỆN THOẠI', N'THÀNH PHỐ HỒ CHÍ MINH', '', 'FPT', 'NGUYỄN VĂN A', '', '0909845284', 'NHATCUONGTI@GMAIL.COM', 0)

  --Lấy danh sách company	

	SELECT MASOTHUE AS id, TenDoanhNghiep AS Name, LoaiHang AS typeProduct
	FROM DoanhNghiep
--Hiển thị sản phẩm của company đó
    --INSERT DỮ LIỆU HỢP ĐỒNG
	SELECT * FROM HopDong
	INSERT INTO HopDong
	VALUES('1', N'Nguyễn Văn A', 0, 3, 0.1, '2020-05-27', '232132')
	--INSERT DỮ LIỆU CHI NHÁNH
	SELECT * FROM ChiNhanh
	INSERT INTO ChiNhanh
	VALUES('1', '232132', N'Thành Phố Hồ Chí Minh, Quận 10', 0, '1')
	--INSERT SẢN PHẨM CHI NHÁNH
	SELECT * FROM SANPHAM
	INSERT INTO SANPHAM
	VALUES('1', N'Khẩu Trang', 20000),
	      ('2', N'Bánh Mì SandWidth', 100000),
		  ('3', N'Xe đạp', 20000),
		  ('4', N'IPhone 13', 30000)
	--Insert chi nhánh sản phẩm
	SELECT * FROM CHINHANH_SP
	SELECT * FROM DoanhNghiep
	SELECT * FROM SANPHAM
	INSERT INTO CHINHANH_SP
	VALUES('1', '1', '232132'),
		  ('2', '1', '232132'),
		  ('3', '1', '232132'),
		  ('4', '1', '232132')

	--Tạo transaction tìm sản phẩm
	CREATE PROC viewProductOfCompany
	@MADOANHNGHIEP VARCHAR(50),
	@MACHINHANH VARCHAR(50)
	AS
	BEGIN TRANSACTION
		BEGIN TRY
			SELECT SP.MASP AS idProduct, DN.MaSoThue AS idCompany, SP.TENSP AS name, SP.GIA AS price
			FROM DoanhNghiep DN JOIN ChiNhanh CN ON DN.MaSoThue = CN.MaDoanhNghiep
								JOIN CHINHANH_SP CNSP ON (CNSP.MACHINHANH = CN.MaChiNhanh AND CNSP.MADOANHNGHIEP = DN.MaSoThue)
								JOIN SANPHAM SP ON SP.MASP = CNSP.MASP
			WHERE DN.MaSoThue = @MADOANHNGHIEP AND CN.MaChiNhanh = @MACHINHANH
		END TRY
		BEGIN CATCH
			PRINT N'Lỗi hệ thống'
			ROLLBACK TRANSACTION
		END CATCH

	COMMIT TRANSACTION
	GO

	EXEC viewProductOfCompany '232132', '1'

	select * from DONHANG

--Hiển thị danh sách order CỦA MỘT KHÁCH HÀNG
    --Insert KhachHang
	SELECT * FROM KhachHang
	INSERT INTO KhachHang 
	VALUES('1', N'Bùi Nguyễn Nhật Hào', '0909845284', N'Bình Phước, Lộc Ninh', 'nhatcuongti@gmail.com')
	--Insert TaiXe
	select * from TAIXE

	insert into TAIXE
	values('1', N'Nguyễn Văn A', N'Hà Nội', 'nhatcuongti@gmail.com','59C-1432', '3231242', N'Đà Nẵng', '0987783897')
	--Insert order
	SELECT * FROM DonHang
	INSERT INTO DONHANG
	VALUES('1', 2000, 0, 0, 100000, '2021-08-23', N'Bình Phước, Lộc Ninh', '1', '232132', '1', '1')
	--View order with ID
	SELECT MADH AS id, NgayDat AS purchaseDate, HinhThucThanhToan AS typePurchase,PhiVanChuyen AS shipPrice, PhiSanPham AS productPrice, TinhTrang AS status
	FROM DonHang 
	WHERE MADH = '1'
	--Create transaction find order with ID
	CREATE PROC viewOrderWithIDUser
	@idUser varchar(50)
	AS
	BEGIN TRANSACTION
		BEGIN TRY
			SELECT MADH AS id, NgayDat AS purchaseDate, HinhThucThanhToan AS typePurchase,PhiVanChuyen AS shipPrice, PhiSanPham AS productPrice, TinhTrang AS status
			FROM DonHang 
			WHERE MaKH = @idUser
		END TRY
		BEGIN CATCH
			PRINT N'Lỗi hệ thống'
			ROLLBACK TRANSACTION
		END CATCH

	COMMIT TRANSACTION
	GO

	EXEC viewOrderWithIDUser '1'
--Hiển thị tất cả sản phẩm của order đó
  --Insert value to donhang_sp
  SELECT * FROM DONHANG_SP
  SELECT * FROM SANPHAM
  SELECT * FROM DonHang
  INSERT INTO DONHANG_SP
  VALUES('1', '1', 2),
		('2', '1', 2),
		('3', '1', 2),
		('4', '1', 2)
  --Select Product with idOrder
  SELECT SP.MASP AS idProduct, DN.MaSoThue AS idCompany, DHSP.SLSP AS number, SP.TENSP AS name, SP.GIA AS price 
  FROM DONHANG_SP DHSP JOIN SANPHAM SP ON DHSP.MASP = SP.MASP 
					   JOIN DonHang DH ON DH.MaDH = DHSP.MADH
					   JOIN DoanhNghiep DN ON DN.MaSoThue = DH.MaDoanhNghiep	
  WHERE DH.MaDH = '1'
  --Create transaction find product with id order
	CREATE PROC viewProductWithOrderID
	@idOrder varchar(50)
	AS
	BEGIN TRANSACTION
		BEGIN TRY
			 SELECT SP.MASP AS idProduct, DN.MaSoThue AS idCompany, DHSP.SLSP AS number, SP.TENSP AS name, SP.GIA AS price 
			 FROM DONHANG_SP DHSP JOIN SANPHAM SP ON DHSP.MASP = SP.MASP 
					   JOIN DonHang DH ON DH.MaDH = DHSP.MADH
					   JOIN DoanhNghiep DN ON DN.MaSoThue = DH.MaDoanhNghiep	
			 WHERE DH.MaDH = @idOrder
		END TRY
		BEGIN CATCH
			PRINT N'Lỗi hệ thống'
			ROLLBACK TRANSACTION
		END CATCH

	COMMIT TRANSACTION
	GO

	EXEC viewProductWithOrderID '1'
--Hiển thị ra thông tin doanh nghiệp của sản phẩm đó
  --Mã số thuế của doanh nghiệp bán order đó
  --Tên doanh nghiệp
  --Số đt doanh nghiệp đó
  --Email doanh nghiệp đó
  --Địa chỉ doanh nghiệp
  --Địa chỉ chi nhánh
  --Tên tài xế
  --Số điện thoại
  --Biển số xe



  CREATE PROC viewDetailOrder
	@idOrder varchar(50)
	AS
	BEGIN TRANSACTION
		BEGIN TRY
			SELECT DN.MaSoThue AS taxCode, DN.TenDoanhNghiep AS companyName, DN.SoDT AS phoneNumberCompany, DN.Email AS email, 
			DN.DiaChiKinhDoanh AS companyAddress, CN.DiaChi AS branchAddress, TX.HOTEN AS driverName, TX.SDT AS phoneNumberDriver, TX.BIENSOXE AS licensePlates
			FROM DonHang DH JOIN DoanhNghiep DN ON DH.MaDoanhNghiep = DN.MaSoThue
							JOIN ChiNhanh CN ON CN.MaDoanhNghiep = DN.MaSoThue
							JOIN TAIXE TX ON TX.MATX = DH.MaTX
			WHERE DH.MaDH = '1'
		END TRY
		BEGIN CATCH
			PRINT N'Lỗi hệ thống'
			ROLLBACK TRANSACTION
		END CATCH

	COMMIT TRANSACTION
	GO

	EXEC viewDetailOrder '1'

	--Insert order
	Select * from ChiNhanh
	SELECT * FROM DONHANG_SP
	SELECT * FROM DonHang

--24/12/2021
USE Nhom18_DoAnThucHanh_19HTT2_1
GO

--getAllContract (company.model.js line 89)
SELECT HD.MaHD, DN.TenDoanhNghiep, HD.NgayBatDau, HD.HieuLuc, HD.DangGiaHan
FROM HOPDONG HD JOIN DOANHNGHIEP DN ON HD.MaDoanhNghiep = DN.MaSoThue

--updateDangGiaHanContract(company.model.js line 169)
UPDATE HopDong 
Set DangGiaHan= 'false'
where MaHD = 'HD000'

--getContractWithID (company.model.js line 116)
SELECT MAHD, TenDoanhNghiep, HD.NguoiDaiDien, NgayBatDau, HieuLuc, SoChiNhanhDK
FROM HopDong HD JOIN DoanhNghiep DN ON HD.MaDoanhNghiep = DN.MaSoThue
WHERE MaHD='HD000'

--getBranchWithIDContract (company.model.js line 110)
--MaChiNhanh : '1',
--DiaChi : 'Bình Phước, Lộc Ninh'
SELECT MACHINHANH as MaChiNhanh, DiaChi
FROM ChiNhanh
WHERE MAHOPDONG='HD001'

select * from DonHang

--getOrderDetailWithID_Driver(order.model.js line 145)
--MaDH : '1',
--TenKH : 'Bùi Nguyễn Nhật Hào',
--SDT_KH: '0909845284',
--DC_KH : 'Bình Phước, Lộc Ninh',
--TenDN : 'FPT',
--DC_CN : 'Hà Nội',
--SDT_CN : '0987783897' 
SELECT MaDH, KH.HoTen AS TenKH, KH.SDT AS SDT_KH, DH.DiaChiGiao AS DC_KH, DN.TenDoanhNghiep AS TenDN, CN.DiaChi as DC_CN, DN.SoDT AS SDT_CN
FROM DonHang DH JOIN KhachHang KH ON DH.MaKH = KH.MaKH
				JOIN ChiNhanh CN ON (DH.MaDoanhNghiep = CN.MaDoanhNghiep AND DH.MACHINHANH = CN.MACHINHANH)
				JOIN DoanhNghiep DN ON (DN.MaSoThue = DH.MaDoanhNghiep)
WHERE MADH = 'DH000'

--getOrderDetail_Driver() (order.model.js line 164)
--MaDH : '1',
--DiaChi_ChiNhanh : 'Hà Nội',
--PhiVanChuyen : 20000,
--HoTen : 'Bùi Nguyễn Nhật Hào',
--DiaChi_KhachHang : 'Sài Gòn',
--SDT : '0909845284',
--status : 0

SELECT MaDH, CN.DiaChi AS DiaChi_ChiNhanh, DH.PhiVanChuyen, KH.HoTen, DH.DiaChiGiao as DiaChi_KhachHang, KH.SDT, DH.TinhTrang			
FROM DonHang DH JOIN ChiNhanh CN ON DH.MACHINHANH = CN.MACHINHANH 
				JOIN KhachHang KH ON DH.MaKH = KH.MaKH

--updateStatusOrder(orderID, newStatus) (order.model.js line 209)
UPDATE DonHang 
Set TinhTrang = 1
where MaDH = 'DH000'
				
SELECT * FROM DonHang
--insertTypeProduct() (product.model.js line 43)
INSERT INTO LOAIHANG
VALUES('1', 'OTO')

--insertPlace() (product.model.js line 52)
INSERT INTO KhuVucHoatDong
VALUES('1', 'Bình Phước')

--getAllDriver() (account.model.js line 183)
SELECT TX.MATX, HOTEN, EMAIL, SDT, TRANGTHAI
FROM TAIXE TX JOIN TKTAIXE TKTX ON TX.MATX = TKTX.MATX


--updateAccountStatus(driverID, statusChoice) (account.model.js line 208)
SELECT * FROM TKTAIXE
UPDATE TKTAIXE SET TRANGTHAI = 1 WHERE ID='TX04165'

--getAllUser() (account.model.js line 230)
SELECT KH.MaKH, HOTEN, SDT, EMAIL, TrangThai
FROM KHACHHANG KH JOIN TKKhachHang TKKH ON KH.MaKH = TKKH.MaKH

SELECT MaSoThue, TenDoanhNghiep, DiaChiKinhDoanh, TENLOAIHANG, trangthai
FROM DOANHNGHIEP DN JOIN TKDoanhNghiep TKDN ON DN.MaSoThue = TKDN.MADOANHNGHIEP	
					JOIN LOAIHANG LH ON LH.MALOAIHANG = DN.LoaiHang


SELECT NV.MANV, NV.HOTEN, NV.SDT, TKNV.TRANGTHAI
FROM NHANVIEN NV JOIN TKNHANVIEN TKNV ON NV.MANV = TKNV.MANV

