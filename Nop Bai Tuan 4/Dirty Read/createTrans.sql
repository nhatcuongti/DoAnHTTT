CREATE PROC INSERT_HOPDONG
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
		INSERT INTO HOPDONG
		VALUES(@MAHD, @NGUOIDAIDIEN, @SOCHINHANHDK, @HIEULUC, @PHANTRAMHH, @NGAYBATDAU, @MADOANHNGHIEP, 1)

		WAITFOR DELAY '00:00:05'


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
		
	END TRY			
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH	
COMMIT TRANSACTION
GO

CREATE PROC viewAllContract
AS
BEGIN TRANSACTION
	BEGIN TRY
		SELECT HD.MaHD, DN.TenDoanhNghiep, HD.NgayBatDau, HD.HieuLuc, HD.DangGiaHan FROM HOPDONG HD JOIN DOANHNGHIEP DN ON HD.MaDoanhNghiep = DN.MaSoThue
		WAITFOR DELAY '00:00:05'
	END TRY			
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH	
COMMIT TRANSACTION
GO



select * from HopDong

UPDATE HopDong
SET HieuLuc = -1
WHERE MaHD = '0'