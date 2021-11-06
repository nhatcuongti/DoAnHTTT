--Them Chi Nhanh ; Rang Buoc :2
create PROC INSERT_CHINHANH
	@MACHINHANH VARCHAR(5),
	@MADOANHNGHIEP VARCHAR(50),
	@DIACHI NVARCHAR(200),
	@DOANHSOBAN MONEY,
	@MAHOPDONG VARCHAR(50)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra @MaDoanhNghiep có tồn tại hay không ?
		if (NOT EXISTS(Select * from DoanhNghiep dn where @MADOANHNGHIEP = dn.MaSoThue ))
		Begin
			Print N'Không tồn tại mã doanh nghiệp'
			ROLLBACK TRANSACTION
			RETURN
		End	

		--Kiểm tra @DOANHSOBAN != 0 hay không ?
		if (@DOANHSOBAN != 0)
		Begin
			Print N'Doanh số bán phải nhập liệu là 0 !!'
			ROLLBACK TRANSACTION
			RETURN
		End	

		--Xử lí ràng buộc 2 . Nếu @MaHopDong != NULL thì tăng SoChiNhanhDK lên 1 
		if (@MAHOPDONG IS NOT NULL)
		Begin
			update HopDong 
			SET SoChiNhanhDK = SoChiNhanhDK + 1
			WHERE MAHD = @MAHOPDONG 
		End	

	INSERT INTO CHINHANH
	VALUES(@MACHINHANH, @MADOANHNGHIEP, @DIACHI, @DOANHSOBAN, @MAHOPDONG);

		
	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH

COMMIT TRANSACTION
GO

--DELETE CINHANH TRANSACTION , Ràng buộc :  2

create PROC DELETE_CHINHANH
	@MACHINHANH VARCHAR(5),
	@MADOANHNGHIEP VARCHAR(50)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra chi nhánh có tồn tại hay không
		if (not exists(select * from ChiNhanh cn where cn.MaChiNhanh = @MACHINHANH and cn.MaDoanhNghiep = @MADOANHNGHIEP))
		BEGIN
			print N'Chi nhánh không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END		
		
		--Xử lí ràng buộc 
		UPDATE HOPDONG
		SET SoChiNhanhDK = SoChiNhanhDK - 1
		WHERE MaHD = (SELECT MAHOPDONG FROM CHINHANH CN WHERE CN.MaDoanhNghiep = @MADOANHNGHIEP AND CN.MaChiNhanh = @MACHINHANH) 

		DELETE ChiNhanh
		WHERE MaChiNhanh = @MACHINHANH AND @MADOANHNGHIEP = MaDoanhNghiep
		
	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH

COMMIT TRANSACTION
GO

--Update DoanhSoBan o table ChiNhanh

create proc Update_ChiNhanh_DoanhSoBan
	@MaChiNhanh varchar(5),
	@maDoanhNghiep varchar(50),
	@DoanhSoBan money
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra chi nhánh có tồn tại hay không
		if (not exists(select * from ChiNhanh where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @maDoanhNghiep))
		BEGIN
			print N'Chi nhánh không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END	

		--Kiểm tra Doanh số bán có phải là số dương
		if (@DoanhSoBan < 0)
		BEGIN
			print N'Doanh số bán âm'
			ROLLBACK TRANSACTION
			RETURN
		END			

		--Kiểm tra DoanhSoBan có bằng với DoanhSoBan hiện tại ?
		if (not exists(select * from ChiNhanh where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @maDoanhNghiep and @DoanhSoBan = DoanhSoBan))
		BEGIN
			print N'Doanh số bán được cập nhật không hợp lí'
			ROLLBACK TRANSACTION
			RETURN
		END		
	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH	
COMMIT TRANSACTION
GO

create PROC INSERT_HOPDONG
	@MAHD VARCHAR(50),
	@NGUOIDAIDIEN NVARCHAR(50),
	@SOCHINHANHDK INT,
	@HIEULUC INT,
	@PHANTRAMHH FLOAT,
	@NGAYBATDAU DATE,
	@MADOANHNGHIEP VARCHAR(50)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra MaHD đã tồn tại chưa
		if (exists(select * from hopdong where @mahd = MaHD))
		begin
			print N'Mã hợp đồng đã tồn tại !'
			ROLLBACK TRANSACTION
			RETURN
		end		

		--Kiểm tra Số Chi Nhánh DK có khác 0 hay không
		if (@SOCHINHANHDK != 0)
		begin
			print N'Số chi nhánh khác 0 !'
			ROLLBACK TRANSACTION
			RETURN
		end	

		--PHANTRAMHH CÓ NẰM TRONG KHOẢNG (0, 1) HAY KHÔNG
		if (@PHANTRAMHH > 1 or @PHANTRAMHH < 0)
		begin
			print N'Phần trăm HH không nằm trong khoảng quy định'
			ROLLBACK TRANSACTION
			RETURN
		end	

		--Kiểm tra HIỆU LỰC CÓ KHÁC 0 HAY KHÔNG
		if (@HIEULUC = 0)
		begin
			print N'Hiệu lực không thể bằng 0'
			rollback transaction
			return
		end	

		--Kiểm tra ngaybatdau và hieuluc có hợp lí hay không
		if (DATEDIFF(MONTH, GETDATE(), @NGAYBATDAU) > @HIEULUC)
		BEGIN
			PRINT N'Ngày bắt đầu và hiệu lực không hợp lí'
			ROLLBACK TRANSACTION
			RETURN
		END

		--Kiểm tra doanh nghiệp có tồn tại
		if (not exists(select * from DoanhNghiep where MaSoThue = @MADOANHNGHIEP))
		BEGIN
			PRINT N'Doanh nghiệp không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END		
		
		INSERT INTO HOPDONG
		VALUES(@MAHD, @NGUOIDAIDIEN, @SOCHINHANHDK, @HIEULUC, @PHANTRAMHH, @NGAYBATDAU, @MADOANHNGHIEP)
	END TRY			
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH	
COMMIT TRANSACTION
GO

--Update SoChiNhanhDK của HOPDONG xử lí ràng buộc 2
CREATE PROC Update_HopDong_SoChiNhanhDK
	@mahd varchar(50),
	@SoChiNhanhDK int
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra mahd có tồn tại hay không
		if (not exists(select * from HopDong where MaHD = @mahd))
		BEGIN
			PRINT N'Hợp đồng không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END			
		
		--Kiểm tra sochinhanhdk trong hợp đồng có thay đổi hay không
		if (not exists(select * from HopDong where MaHD = @mahd and @SoChiNhanhDK = SoChiNhanhDK))
		BEGIN
			PRINT N'Không thể update số chi nhánh!!'
			ROLLBACK TRANSACTION
			RETURN
		END		
			
	END TRy
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH		
COMMIT TRANSACTION
GO				

--DELETE table chinhanh_sp ; RB:4, 5
CREATE PROC DELETE_CHINHANH_SP
	@MASP VARCHAR(50),
	@MACHINHANH VARCHAR(5),
	@MADOANHNGHIEP VARCHAR(50)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--kiểm tra xem có tồn tại chinhanh_sp
		if (not exists(select * from CHINHANH_SP 
		where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP and 
		@MASP = MASP))
		begin
			PRINT N'Không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		end	

		--Xử lí ràng buộc 4 : Nếu chi nhánh đó chỉ có một sản phẩm thì không xóa
		if ((select count(*) from CHINHANH_SP WHERE
		 @MADOANHNGHIEP = MADOANHNGHIEP AND @MACHINHANH = MACHINHANH) = 1)
		 BEGIN
			PRINT N'Chi nhánh này chỉ còn 1 sản phẩm nên không thể xóa'
			ROLLBACK TRANSACTION
			RETURN
		 END		

		--Xử lí ràng buộc 5
		if ((select count(*) from CHINHANH_SP WHERE @MASP = MASP) = 1)
		 BEGIN
			PRINT N'Sản phẩm này chỉ thuộc về 1 chi nhánh nên không thể xóa'
			ROLLBACK TRANSACTION
			RETURN
		 END	

		 delete CHINHANH_SP
		 where @MASP = MASP and @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP
	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH
COMMIT TRANSACTION
GO	


CREATE PROC Update_ChiNhanh_SP_MaChiNhanh
	@MASP VARCHAR(50),
	@MACHINHANH VARCHAR(5),
	@MADOANHNGHIEP VARCHAR(50),
	@NEWMACHINHANH VARCHAR(5)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--kiểm tra xem có tồn tại chinhanh_sp
		if (not exists(select * from CHINHANH_SP 
		where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP and 
		@MASP = MASP))
		begin
			PRINT N'Không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		end	

		--Kiểm tra xem @NewMaChiNhanh có tồn tại
		if (not exists(select * from ChiNhanh where @NEWMACHINHANH = MaChiNhanh 
						and @MADOANHNGHIEP = MaDoanhNghiep))
		BEGIN
			PRINT N'Không tồn tại chi nhánh mới'
			ROLLBACK TRANSACTION
			RETURN
		END	

		--xỬ LÍ RÀNG BUỘC 4 :Một ChiNhanh phải có ít nhất một sản phẩm
		if (1 = (select count(*) from CHINHANH_SP 
		where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP))
		BEGIN
			PRINT N'Mỗi chi nhánh phải có ít nhất một sản phẩm'
			ROLLBACK TRANSACTION
			RETURN
		END		

		UPDATE CHINHANH_SP
		SET MACHINHANH = @NEWMACHINHANH
		WHERE @MACHINHANH = MACHINHANH


	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH
COMMIT TRANSACTION
GO	

--Update masp của dh_sp
create proc Update_DonHang_SP_SLSP
	@MASP VARCHAR(50),
	@MADH VARCHAR(50),
	@SLSP int
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra dh_sp có tồn tại
		if (not exists(select * from DONHANG_SP where @MASP = MASP and @MADH = MADH))
		BEGIN
			PRINT N'DH_SP này không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END	

		--Kiểm tra slsp có > 0
		if (@SLSP <= 0)
		BEGIN
			PRINT N'Số lượng sản phẩm phải lớn hơn 0'
			ROLLBACK TRANSACTION
			RETURN	
		END		

		--Xử lí RB 6 : Thay đổi phí sản phẩm ở DonHang 3 * MN 5 * MN
		UPDATE DONHANG
		SET PhiSanPham = PHISANPHAM +  (SELECT (@SLSP - SLSP) FROM DONHANG_SP 
			WHERE @MASP = MASP AND @MADH = MADH) * (SELECT GIA FROM SANPHAM WHERE MASP = @MASP)
		WHERE  MADH = @MADH

		UPDATE DONHANG_SP 
		SET SLSP = @SLSP
		WHERE MASP = @MASP AND MADH = @MADH

	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH		
COMMIT TRANSACTION
GO		

create proc Update_DonHang_SP_MADH
	@MASP VARCHAR(50),
	@MADH VARCHAR(50),
	@NEWMADH VARCHAR(50)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra dh_sp có tồn tại
		if (not exists(select * from DONHANG_SP where @MASP = MASP and @MADH = MADH))
		BEGIN
			PRINT N'DH_SP này không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END	

		--Kiểm tra đơn hàng mới có tồn tại hay không
		if (not exists(select * from donhang where @NEWMADH = MADH))
		BEGIN
			PRINT N'Đơn hàng mới không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END		



		--Xử lí RB 6 : Update đơn hàng cũ và đơn hàng mới
		--Đơn hàng cũ : PHISP = PHISP - (GIA TIEN @MASP) * SLSP
		UPDATE DONHANG
		SET PhiSanPham = PHISANPHAM - (select slsp from DONHANG_SP where @masp = masp and @MADH = MaDH) * 
									(SELECT GIA FROM SANPHAM WHERE @MASP = MASP)
		WHERE MADH = @MADH
		--Đơn hàng mới : PhiSP = PhiSP + (Gia Tien @MaSP) * SLSP
		UPDATE DONHANG
		SET PhiSanPham = PHISANPHAM + (select slsp from DONHANG_SP where @masp = masp and @MADH = MaDH) * 
									(SELECT GIA FROM SANPHAM WHERE @MASP = MASP)
		WHERE MADH = @NEWMADH


		UPDATE DONHANG_SP 
		SET MADH = @NEWMADH
		WHERE MASP = @MASP AND MADH = @MADH

	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH		
COMMIT TRANSACTION
GO		



	