USE Nhom18_DoAnThucHanh
GO

SELECT * FROM SANPHAM

INSERT INTO SANPHAM 
VALUES('SP02', 'Kẹo', 2000);

create PROC CapNhatGiaSanPham
	@MaSP varchar(50),
	@GiaMoi smallmoney
AS
BEGIN TRANSACTION
	BEGIN TRY
		--B1: Kiểm tra Mã sản phẩm có tồn tại hay không
		IF NOT EXISTS (SELECT * from sanpham where MASP = @masp)
		BEGIN
			   PRINT N'Mã sản phẩm này không tồn tại'
			   ROLLBACK TRANSACTION
			   RETURN
		END


		--B2: Cập nhật giá sản phẩm
		Update SANPHAM
		SET GIA = @GIAMOI
		WHERE MASP = @MASP
		WAITFOR DELAY '00:00:05'


		--B3 : Kiểm tra Gia moi
		IF @GiaMoi < 0
		BEGIN
			PRINT N'Giá mới này không hợp lệ'
			ROLLBACK TRANSACTION
			RETURN
		END		
	

	END TRY
	BEGIN CATCH
		WAITFOR DELAY '00:00:05'
		ROLLBACK TRANSACTION
		PRINT N'Lỗi hệ thống'
		
	END CATCH

COMMIT TRANSACTION
GO


--Xem thông tin doanh nghiệp
create PROC XemThongTinSanPham
	@MASP varchar(50)
AS
SET TRAN ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra @MaDoanhNghiep có tồn tại hay không ?
		IF NOT EXISTS (SELECT * FROM SANPHAM WHERE MASP = @MaSP)
		BEGIN
			   PRINT N'Mã Sản phẩm này không tồn tại'
			   ROLLBACK TRANSACTION
			   RETURN 
		END


		--Xem thông tin sản phẩm
		Select * from SANPHAM
		where masp = @MASP


	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH

COMMIT TRANSACTION
GO

SELECT * FROM TKDoanhNghiep