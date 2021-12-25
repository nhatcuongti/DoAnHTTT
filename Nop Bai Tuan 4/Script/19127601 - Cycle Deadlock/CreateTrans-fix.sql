Use Nhom18_DoAnThucHanh_19HTT2_1
Go

ALTER PROC XoaChiNhanh
	@MaChiNhanh varchar(50),
    @MaDoanhNghiep varchar(50)
AS
BEGIN TRANSACTION
SET TRAN ISOLATION LEVEL READ COMMITTED
	BEGIN TRY
		--B1: Kiểm tra Chi nhánh có tồn tịa hay không
		IF NOT EXISTS (select * from ChiNhanh where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep)
		BEGIN
			   PRINT N'Chi nhánh này không tồn tại'
			   ROLLBACK TRANSACTION
			   RETURN
		END

		--B2: Lấy MaHD
		DECLARE @MaHD as varchar(50)
		Set @MaHD = (Select MAHOPDONG from ChiNhanh where @MaChiNhanh = MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep)


		--B3: Giảm số chi nhánh đăng kí trong hợp đồng
		Update HopDong
		Set SoChiNhanhDK = SoChiNhanhDK - 1
		where MaHD = @MaHD
		WAITFOR DELAY '00:00:10'

		--B4 : Xóa chi nhánh
		Delete ChiNhanh
		where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep
	
		

		print N'Chạy hết nhá'


	

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT N'Lỗi hệ thống'
		
	END CATCH

COMMIT TRANSACTION
GO

ALTER PROC XoaChiNhanhKhoiHopDong
	@MaChiNhanh varchar(50),
    @MaDoanhNghiep varchar(50)
AS
BEGIN TRANSACTION
SET TRAN ISOLATION LEVEL READ COMMITTED

		--B1: Kiểm tra Chi nhánh có tồn tịa hay không
		IF NOT EXISTS (select * from ChiNhanh where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep)
		BEGIN
			   PRINT N'Chi nhánh này không tồn tại'
			   ROLLBACK TRANSACTION
			   RETURN
		END


		--B2: Lấy MaHD
		DECLARE @MaHD as varchar(50)
		Set @MaHD = (Select MAHOPDONG from ChiNhanh where @MaChiNhanh = MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep)

		--B3 : Giảm đơn vị chi nhánh trong hợp đồng
		Update HopDong
		Set SoChiNhanhDK = SoChiNhanhDK - 1
		Where MaHD = @MaHD

		print N'Chạy ở B3'

		if not exists (SELECT * FROM ChiNhanh WHERE MaChiNhanh = @MaChiNhanh and @MaDoanhNghiep = MaDoanhNghiep )
		BEGIN
			PRINT N'Chi nhánh không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END		


		--B4 : Xóa chi nhánh khỏi hợp đồng
		Update  ChiNhanh
		Set MAHOPDONG = NULL
		Where MaChiNhanh = @MaChiNhanh and @MaDoanhNghiep = MaDoanhNghiep

		print N'Chạy ở B4'



COMMIT TRANSACTION
GO