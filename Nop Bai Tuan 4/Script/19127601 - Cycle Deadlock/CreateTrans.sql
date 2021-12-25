Use Nhom18_DoAnThucHanh_19HTT2_1
Go

Insert into ChiNhanh
values('CN01', '33847', '9', 0, '10')
go

ALTER PROC XoaChiNhanh
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

		print 'hello'

		--B3: Giảm số chi nhánh đăng kí trong hợp đồng
		Update HopDong
		Set SoChiNhanhDK = SoChiNhanhDK - 1
		where MaHD = @MaHD
		WAITFOR DELAY '00:00:10'

		
		--3 : Xóa chi nhánh
		Delete ChiNhanh
		where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep
		PRINT N'KHÔNG CẦN ĐỢI AI LUÔN'
	
COMMIT TRANSACTION
GO

ALTER PROC XoaChiNhanhKhoiHopDong
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
		Set @MaHD = (Select MAHOPDONG from ChiNhanh WITH (NOLOCK) where @MaChiNhanh = MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep)
		PRINT N'READ MAHD'


		--B3 : Xóa chi nhánh khỏi hợp đồng
		Update  ChiNhanh
		Set MAHOPDONG = NULL
		Where MaChiNhanh = @MaChiNhanh and @MaDoanhNghiep = MaDoanhNghiep

		PRINT N'cOMPLETE UPDATE CHINHANH'

		--B4 : Giảm đơn vị chi nhánh trong hợp đồng
		Update HopDong
		Set SoChiNhanhDK = SoChiNhanhDK - 1
		Where MaHD = @MaHD

		PRINT N'ĐỢI Ở ĐÂY'

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT N'Lỗi hệ thống'
		
	END CATCH

COMMIT TRANSACTION
GO

SELECT * FROM TKDoanhNghiep