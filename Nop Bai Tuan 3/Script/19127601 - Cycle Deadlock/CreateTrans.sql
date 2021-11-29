Use Nhom18_DoAnThucHanh
Go

	Select * from DoanhNghiep
	Select * from HopDong
	Select * from ChiNhanh

Insert into DoanhNghiep
values('MST01', 'Dien Thoai', N'Bình Phước', 'Quan 5', 'FPT', N'Nguyễn Văn B', N'Đồng Xoài', '0909845284', 'nhatcuongti@gmail.com', 50)
go

Insert into HopDong
values('HD01', N'Nhật Hào', 0, 6, 0.3, '2021-05-27', 'MST01')
go

Insert into ChiNhanh
values('CN01', 'MST01', 'Bình phước', 0, 'HD01')
go

ALTER PROC XoaChiNhanh
	@MaChiNhanh varchar(50),
    @MaDoanhNghiep varchar(50)
AS
BEGIN TRANSACTION
SET TRAN ISOLATION LEVEL REPEATABLE READ
	BEGIN TRY
		--B1: Kiểm tra Chi nhánh có tồn tịa hay không
		IF NOT EXISTS (select * from ChiNhanh where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep)
		BEGIN
			   PRINT N'Chi nhánh này không tồn tại'
			   ROLLBACK TRANSACTION
			   RETURN
		END


		--B2: Giảm số chi nhánh đăng kí trong hợp đồng
		Update HopDong
		Set SoChiNhanhDK = SoChiNhanhDK - 1
		where MaHD = (Select MaHD from ChiNhanh where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep)
		WAITFOR DELAY '00:00:10'

		--B3 : Xóa chi nhánh
		Delete ChiNhanh
		where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep
	

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
SET TRAN ISOLATION LEVEL REPEATABLE READ
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


		--B3 : Xóa chi nhánh khỏi hợp đồng
		Update  ChiNhanh
		Set MAHOPDONG = NULL
		Where MaChiNhanh = @MaChiNhanh and @MaDoanhNghiep = MaDoanhNghiep

		--B4 : Giảm đơn vị chi nhánh trong hợp đồng
		Update HopDong
		Set SoChiNhanhDK = SoChiNhanhDK - 1
		Where MaHD = @MaHD

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT N'Lỗi hệ thống'
		
	END CATCH

COMMIT TRANSACTION
GO