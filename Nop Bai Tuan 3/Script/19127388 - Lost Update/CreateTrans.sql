USE Nhom18_DoAnThucHanh
GO

INSERT INTO SANPHAM
VALUES('SP01', N'Bánh mì', 10000)

--Tăng giá sản phẩm
CREATE PROC TangGiaSanPham
	@MaSP varchar(50),
	@SoTienTang smallmoney
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra sản phẩm có tồn tại hay không
		IF NOT EXISTS (Select * from SanPham sp where sp.MaSP = @MaSP)
		BEGIN
				PRINT N'Sản phẩm không tồn tại'
				ROLLBACK TRANSACTION;
				Return ;
		END

		--Kiểm tra giá có hợp lệ hay không
		IF (@SoTienTang <= 0)
		BEGIN
			PRINT N'Giá tiền tăng nhỏ hơn 0'
			ROLLBACK TRANSACTION;
			RETURN;
		END		

		--Lấy biến giá tiền
		DECLARE @Gia INT
		Set @Gia = (Select GIA from  SANPHAM where MASP = @MaSP)
		WAITFOR DELAY '00:00:05'


		--Tăng giá tiền lên một đơn vị
		UPDATE SANPHAM
		SET GIA = @Gia + @SoTienTang
		WHERE MASP = @MaSP
		
		


	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
		RETURN
	END CATCH

COMMIT TRANSACTION
GO

--Giảm giá sản phẩm
CREATE PROC GiamGiaSanPham
	@MaSP varchar(50),
	@SoTienGiam smallmoney
AS
SET TRAN ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra sản phẩm có tồn tại hay không
		IF NOT EXISTS (Select * from SanPham sp where sp.MaSP = @MaSP)
		BEGIN
				PRINT N'Sản phẩm không tồn tại'
				ROLLBACK TRANSACTION;
				Return ;
		END

		--Kiểm tra giá có hợp lệ hay không
		IF (@SoTienGiam <= 0)
		BEGIN
			PRINT N'Giá tiền tăng nhỏ hơn 0'
			ROLLBACK TRANSACTION;
			RETURN;
		END		

		--Lấy biến giá tiền
		DECLARE @Gia INT
		Set @Gia = (Select GIA from SANPHAM where MASP = @MaSP)
		WAITFOR DELAY '00:00:10'

		--Tăng giá tiền lên một đơn vị
		UPDATE SANPHAM
		SET GIA = @Gia - @SoTienGiam
		WHERE MASP = @MaSP


	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
		RETURN
	END CATCH

COMMIT TRANSACTION
GO

