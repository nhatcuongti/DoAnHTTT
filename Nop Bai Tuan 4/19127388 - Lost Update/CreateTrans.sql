USE Nhom18_DoAnThucHanh
GO

INSERT INTO SANPHAM
VALUES('SP01', N'Bánh mì', 10000)

SELECT * FROM ChiNhanh

--Tăng giá sản phẩm
ALTER PROC insertNewBranchToContract
	@MACHINHANH varchar(50),
	@MADOANHNGHIEP varchar(50),
	@MAHOPDONG VARCHAR(50)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Tăng số lượng SoChiNhanhDK trong hợp đồng lên 1
		UPDATE HOPDONG 
		SET SoChiNhanhDK = SoChiNhanhDK + 1
		WHERE MaHD = @MAHOPDONG


		--Kiểm tra giá có hợp lệ hay không
		UPDATE CHINHANH
		SET MAHOPDONG = @MAHOPDONG
		WHERE MACHINHANH = @MACHINHANH AND MaDoanhNghiep = @MADOANHNGHIEP


	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
		RETURN
	END CATCH

COMMIT TRANSACTION
GO

--Giảm giá sản phẩm
alter PROC DELETE_CHINHANH
	@MACHINHANH VARCHAR(5),
	@MADOANHNGHIEP VARCHAR(50)
AS
BEGIN TRANSACTION
	BEGIN TRY
		DECLARE @SoChiNhanhDK int
		set @SoChiNhanhDK = (Select SoChiNhanhDK from HopDong where MaDoanhNghiep = @MADOANHNGHIEP )
		WAITFOR DELAY '00:00:05'

		--Giảm số chi nhánh đăng kí
		UPDATE HOPDONG
		SET SoChiNhanhDK = @SoChiNhanhDK - 1
		WHERE MaHD = (SELECT MAHOPDONG FROM CHINHANH CN WHERE CN.MaDoanhNghiep = @MADOANHNGHIEP AND CN.MaChiNhanh = @MACHINHANH) 

		PRINT N'UPDATE1 SUCCESS'


		DELETE ChiNhanh
		WHERE MaChiNhanh = @MACHINHANH AND @MADOANHNGHIEP = MaDoanhNghiep
		PRINT N'UPDATE2 SUCCESS'

		--Kiểm tra chi nhánh có tồn tại hay không
		if (not exists(select * from ChiNhanh cn where cn.MaChiNhanh = @MACHINHANH and cn.MaDoanhNghiep = @MADOANHNGHIEP))
		BEGIN
			print N'Chi nhánh không tồn tại'
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
