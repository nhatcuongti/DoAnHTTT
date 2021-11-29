USE Nhom18_DoAnThucHanh
GO

Select * from TKNHANVIEN
select * from NHANVIEN

Insert into TKNHANVIEN
values('NV01', N'Bùi nguyễn Nhật Hào', N'Lộc Ninh', 'nhatcuongti@gmail.com', '0987783897')

insert into NHANVIEN
values('nhatcuongti', '123456', 1, 'NV01')



--Đổi mật khẩu
alter PROC DoiMatKhau
	@ID varchar(50),
	@MKMoi varchar(50)
AS
BEGIN TRANSACTION
SET TRAN ISOLATION LEVEL REPEATABLE READ
	BEGIN TRY
		--B1: Kiểm tra ID có tồn tại hay không
		IF NOT EXISTS (select * from TKNHANVIEN  where ID = @ID)
		BEGIN
			   PRINT N'Tài khoản này không tồn tại'
			   ROLLBACK TRANSACTION
			   RETURN
		END
		WAITFOR DELAY '00:00:10'


		--B2: Cập nhật mật khẩu
		Update TKNHANVIEN
		SET MK = @MKMoi
		WHERE ID = @ID

	

	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT N'Lỗi hệ thống'
		
	END CATCH

COMMIT TRANSACTION
GO


--Cập nhật trạng thái nhân viên
ALTER PROC CapNhatTrangThaiNV
	@ID varchar(50),
	@TrangThai int
AS
SET TRAN ISOLATION LEVEL REPEATABLE READ
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra @ID có tồn tại hay không ?
		IF NOT EXISTS (SELECT * FROM TKNHANVIEN WHERE ID = @ID)
		BEGIN
			   PRINT N'Tài khoản này không tồn tại'
			   ROLLBACK TRANSACTION
			   RETURN 
		END


		--Cập nhật trạng thái của nhân viên
		Update TKNHANVIEN
		set TRANGTHAI = @TrangThai
		where ID = @ID


	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH

COMMIT TRANSACTION
GO