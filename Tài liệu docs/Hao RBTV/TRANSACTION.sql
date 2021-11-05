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

