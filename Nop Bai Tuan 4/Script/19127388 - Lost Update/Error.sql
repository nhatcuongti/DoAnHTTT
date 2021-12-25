USE Nhom18_DoAnThucHanh_19HTT2_1
GO


--Tăng giá sản phẩm
create PROC insertNewBranchToContract
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
		DECLARE @MAHOPDONG varchar(50)
		set @MAHOPDONG = (SELECT cn.MAHOPDONG from ChiNhanh cn where cn.MaDoanhNghiep = @MADOANHNGHIEP and cn.MACHINHANH = @MACHINHANH )
		set @SoChiNhanhDK = (Select SoChiNhanhDK from HopDong where MaHD = @MAHOPDONG )
		
		waitfor delay '00:00:10' --2 

		PRINT @SoChiNhanhDK

		--Giảm số chi nhánh đăng kí
		UPDATE HOPDONG
		SET SoChiNhanhDK = @SoChiNhanhDK - 1
		WHERE MaHD = @MAHOPDONG

		PRINT N'UPDATE1 SUCCESS'

		SELECT * FROM ChiNhanh

		-- giảm số lượng
		DELETE ChiNhanh
		WHERE MaChiNhanh = @MACHINHANH AND @MADOANHNGHIEP = MaDoanhNghiep
		PRINT N'UPDATE2 SUCCESS'

				
	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH

COMMIT TRANSACTION
GO



