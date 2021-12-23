﻿
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