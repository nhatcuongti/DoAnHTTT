+﻿--Them Chi Nhanh ; Rang Buoc :2
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

--DELETE ChINHANH TRANSACTION , Ràng buộc :  2

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
  --
create proc insertDoanhNghiep
	@MaSoThue varchar(50),
	@LoaiHang varchar(100),
	@DiaChiKinhDoanh varchar(500),
	@Quan varchar(50),
	@ThanhPho varchar(50),
	@TenDoanhNghiep varchar(100),
	@SoDT varchar(15),
	@Email varchar(50),
	@SLDonHang int
as
begin transaction
	begin try
		if @SLDonHang != 0
		begin 
			print 'Don hang phai bang 0'
			rollback transaction
			return
		end
	END TRY
	BEGIN CATCH
		print 'Loi insert Doanh nghiep'
		rollback transaction
	END CATCH
	INSERT INTO DoanhNghiep(MaSoThue,LoaiHang,DiaChiKinhDoanh,QUAN,ThanhPho,TenDoanhNghiep,SoDT,Email,SLDonHang)
	VALUES (@MaSoThue,@LoaiHang,@DiaChiKinhDoanh,@QUAN,@ThanhPho,@TenDoanhNghiep,@SoDT,@Email,@SLDonHang);
	COMMIT TRANSACTION
GO

--Update DoanhNghiep_SLDonHang(newDonHang)
--		RB:1
create proc updateSLDonHangDoanhNghiep
	@MaSoThue varchar(50) ,
	@SLDonHang int
as
begin transaction
	begin try
		if not exists (select * from DoanhNghiep dn where dn.MaSoThue = @MaSoThue)
		begin
			print 'khong ton tai doanh nghiep tren'
			rollback transaction
			return
		end
		if (select count(*) from hopdong hd join ChiNhanh cn on hd.MaHD = cn.MAHOPDONG 
			join DonHang dh on dh.MaChiNhanh = cn.MaChiNhanh and cn.MADOANHNGHIEP = dh.MADOANHNGHIEP) != @SLDonHang
		begin 
			print 'So luong don hang cua doanh nghiep khac tong so luong don hang'
			rollback transaction
			return
		end
	END TRY
	BEGIN CATCH
		print 'Loi insert Doanh nghiep'
		rollback transaction
	END CATCH
	UPDATE DoanhNghiep
	SET SLDonHang = @SLDonHang
	WHERE MaSoThue = @MaSoThue;
	COMMIT TRANSACTION
GO

--Insert DonHang()
--	RB:1, 3,6,7,8
CREATE proc insertDonHang
	@MaDH varchar(50) ,
	@PhiVanChuyen  smallmoney,
	@TinhTrang  int,
	@HinhThucThanhToan  int ,
	@PhiSanPham  smallmoney,
	@NgayDat Datetime,
	@DiaChiGiao nvarchar(50),
	@MaChiNhanh varchar(5) ,
	@MaDoanhNghiep varchar(50) ,
	@MaKhachHang varchar(50) ,
	@MaTX varchar(50)
as
begin transaction
	begin try
		if not exists (select * from ChiNhanh cn where cn.MaChiNhanh = @MaChiNhanh and cn.MaDoanhNghiep = @MaDoanhNghiep)
		begin 
			print 'khong ton tai ma chi nhanh tren trong ma doanh nghiep tren'
			rollback transaction
			return
		end
		if not exists (select * from KhachHang kh where @MaKhachHang = kh.MaKH)
		begin 
			print 'khong ton tai ma khach hang tren'
			rollback transaction
			return
		end
		if not exists (select * from TAIXE tx where @MaTX = tx.MATX)
		begin 
			print 'khong ton tai ma tai xe tren'
			rollback transaction
			return
		end
		if (select tx.KHUVUCHD from TAIXE tx where tx.MATX = @MaTX) != (select cn.DiaChi from ChiNhanh Cn where cn.MaChiNhanh = @MaChiNhanh And cn.MaDoanhNghiep = @MaDoanhNghiep)
		begin 
			print 'Dia chi chi nhanh trong don hang va khu vuc hoat dong tai xe khong khop'
			rollback transaction
			return
		end
		if not exists (select *  from ChiNhanh Cn where cn.MaChiNhanh = @MaChiNhanh And cn.MaDoanhNghiep = @MaDoanhNghiep and cn.MAHOPDONG Is not null)
		begin 
			print 'Dia chi chi nhanh chua duong dang ky dich vu'
			rollback transaction
			return
		end
		
	END TRY
	BEGIN CATCH
		print 'Loi insert Don Hang'
		rollback transaction
	END CATCH
	INSERT INTO donhang
	VALUES (@MaDH,@PhiVanChuyen,@TinhTrang,@HinhThucThanhToan,@PhiSanPham,@NgayDat, @DiaChiGiao, @MaChiNhanh,@MaDoanhNghiep,@MaKhachHang,@MaTX);

	UPDATE DoanhNghiep
	SET SLDonHang = SLDonHang + 1
	WHERE MaSoThue = @MaDoanhNghiep;

	UPDATE ChiNhanh
	SET DoanhSoBan = DoanhSoBan + @PhiSanPham
	WHERE MaDoanhNghiep = @MaDoanhNghiep and MaChiNhanh = @MaChiNhanh ;

	COMMIT TRANSACTION
GO
SELECT * FROM DonHang
SELECT * FROM ChiNhanh
SELECT * FROM TAIXE
EXEC insertDonHang '2', 1000, 0, 0, 50000, '2021-05-03', N'Ha Noi', '1', '232132', '1', '1'
--Delete DonHang()
--		RB 1, 3
create proc deleteDonHang
	@MaDH varchar(50)
as
begin transaction
	begin try	
		if not exists (select * from donhang dh where dh.MaDH = @MaDH)
		begin 
			print 'khong ton tai don hang tren'
			rollback transaction
			return
		end
	END TRY
	BEGIN CATCH
		print 'Loi delete Don Hang'
		rollback transaction
	END CATCH
	declare @phisanpham smallmoney;
	set @phisanpham = (select dh.PhiSanPham from donhang dh where dh.MaDH = @MaDH)

	declare @MaSoThue varchar(50);
	Set @MaSoThue = (select dh.MaDoanhNghiep from DonHang Dh where dh.MaDH = @MaDH)

	declare @machinhanh varchar(5);
	Set @machinhanh = (select dh.MaChiNhanh from DonHang Dh where dh.MaDH = @MaDH)

	UPDATE ChiNhanh
	SET DoanhSoBan = DoanhSoBan - @phisanpham
	WHERE MaDoanhNghiep = @MaSoThue and MaChiNhanh = @machinhanh;

	DELETE FROM DonHang WHERE madh = @MaDH;

	COMMIT TRANSACTION
go

--Update DonHang_MaChiNhanh(new MaChiNhanh)
--		RB:3,7,8
create proc updateDonHangMaChiNhanh
	@MaDH varchar(50),
	@MaChiNhanhMoi varchar(5) 
as
begin transaction
	begin try
		if not exists (select * from donhang dh where dh.MaDH = @MaDH)
		begin 
			print 'khong ton tai don hang tren'
			rollback transaction
			return
		end
	END TRY
	BEGIN CATCH
		print 'Loi update Don Hang Ma Chi Nhanh'
		rollback transaction
	END CATCH
	declare @MaDoanhNghiepCu varchar(50)
	declare @MaChiNhanhCu varchar(5)
	declare @phisanpham smallmoney

	set @MaChiNhanhCu = (select dh.MaChiNhanh from DonHang Dh where dh.MaDH = @MaDH)
	set @MaDoanhNghiepCu = (select dh.MaDoanhNghiep from DonHang Dh where dh.MaDH = @MaDH)
	set @phisanpham = (select dh.PhiSanPham from DonHang Dh where dh.MaDH = @MaDH)

	if not exists (select * from ChiNhanh cn where cn.MaChiNhanh = @MaChiNhanhMoi and cn.MaDoanhNghiep = @MaDoanhNghiepCu)
		begin 
			print 'khong ton tai ma chi nhanh cua doanh nghiep tren tren tren'
			rollback transaction
			return
		end

	if (select tx.KHUVUCHD from TAIXE tx join DonHang Dh on dh.matx = tx.MATX where dh.MaDH = @MaDH) != (select cn.DiaChi from ChiNhanh Cn where cn.MaChiNhanh = @MaChiNhanhMoi And cn.MaDoanhNghiep = @MaDoanhNghiepCu)
	begin 
		print 'Dia chi chi nhanh trong don hang va khu vuc hoat dong tai xe khong khop'
		rollback transaction
		return
	end

	if not exists (select *  from ChiNhanh Cn where cn.MaChiNhanh = @MaChiNhanhMoi And cn.MaDoanhNghiep = @MaDoanhNghiepCu and cn.MAHOPDONG Is not null)
	begin 
		print 'Chinh nhanh chua duoc dang ky dich vu'
		rollback transaction
		return
	end
	-- update chi nhanh cu
	UPDATE ChiNhanh
	SET DoanhSoBan = DoanhSoBan - @phisanpham
	WHERE MaChiNhanh = @MaChiNhanhCu and MaDoanhNghiep = @MaDoanhNghiepCu;
	-- update chi nhanh moi
	UPDATE ChiNhanh
	SET DoanhSoBan = DoanhSoBan - @phisanpham
	WHERE MaChiNhanh = @MaChiNhanhMoi and MaDoanhNghiep = @MaDoanhNghiepCu;

	UPDATE DonHang
	SET MaChiNhanh = @MaChiNhanhMoi
	WHERE madh = @madh;
	COMMIT TRANSACTION
GO

---Update DonHang_MaDoanhNghiep(New MaDoanhNghiep)
--		RB:3,7,8

create proc updateDonHangMaDoanhNghiep
	@MaDH varchar(50),
	@MaDoanhNghiepMoi varchar(50) 
as
begin transaction
	begin try
		if not exists (select * from donhang dh where dh.MaDH = @MaDH)
		begin 
			print 'khong ton tai don hang tren'
			rollback transaction
			return
		end
	END TRY
	BEGIN CATCH
		print 'Loi update Don hang Ma Doanh Nghiep'
		rollback transaction
	END CATCH
	declare @MaDoanhNghiepCu varchar(50)
	declare @MaChiNhanhCu varchar(5)
	declare @phisanpham smallmoney

	set @MaChiNhanhCu = (select dh.MaChiNhanh from DonHang Dh where dh.MaDH = @MaDH)
	set @MaDoanhNghiepCu = (select dh.MaDoanhNghiep from DonHang Dh where dh.MaDH = @MaDH)
	set @phisanpham = (select dh.PhiSanPham from DonHang Dh where dh.MaDH = @MaDH)

	if not exists (select * from ChiNhanh cn where cn.MaChiNhanh = @MaChiNhanhCu and cn.MaDoanhNghiep = @MaDoanhNghiepMoi)
		begin 
			print 'khong ton tai ma chi nhanh cua doanh nghiep tren tren tren'
			rollback transaction
			return
		end

	if (select tx.KHUVUCHD from TAIXE tx join DonHang Dh on dh.matx = tx.MATX where dh.MaDH = @MaDH) != (select cn.DiaChi from ChiNhanh Cn 
	where cn.MaChiNhanh = @MaChiNhanhCu And cn.MaDoanhNghiep = @MaDoanhNghiepMoi)
	begin 
		print 'Dia chi chi nhanh trong don hang va khu vuc hoat dong tai xe khong khop'
		rollback transaction
		return
	end

	if not exists (select *  from ChiNhanh Cn where cn.MaChiNhanh = @MaChiNhanhCu 
	And cn.MaDoanhNghiep = @MaDoanhNghiepMoi and cn.MAHOPDONG Is not null)
	begin 
		print 'Chinh nhanh chua duoc dang ky dich vu'
		rollback transaction
		return
	end
	-- update chi nhanh cu doanh nghiep cu
	UPDATE ChiNhanh
	SET DoanhSoBan = DoanhSoBan - @phisanpham
	WHERE MaChiNhanh = @MaChiNhanhCu and MaDoanhNghiep = @MaDoanhNghiepCu;
	-- update chi nhanh cu doanh nghiep moi
	UPDATE ChiNhanh
	SET DoanhSoBan = DoanhSoBan - @phisanpham
	WHERE MaChiNhanh = @MaChiNhanhCu and MaDoanhNghiep = @MaDoanhNghiepMoi;

	-- update sl don hang doanh nghiep cu
	UPDATE DoanhNghiep
	SET SLDonHang = SLDonHang - 1
	WHERE MaSoThue = @MaDoanhNghiepCu;

	-- update sl don hang doanh nghiep moi
	UPDATE DoanhNghiep
	SET SLDonHang = SLDonHang + 1
	WHERE MaSoThue = @MaDoanhNghiepMoi;
	
	UPDATE DonHang
	SET MaDoanhNghiep = @MaDoanhNghiepMoi
	WHERE madh = @madh;
	COMMIT TRANSACTION
GO

--Updata DonHang_PhiSP(newPhiSP)
--		RB: 3,6
create proc updateDonHangPhiSanPham
	@MaDH varchar(50) ,
	@PhiSanPhamMoi smallmoney
as
begin transaction
	begin try
		if not exists (select * from donhang dh where dh.MaDH = @MaDH)
		begin 
			print 'khong ton tai don hang tren'
			rollback transaction
			return
		end

		--------
		--------- kiem tra tong bill = Tong gia chi tiet san pham !!!
		--------
	END TRY
	BEGIN CATCH
		print 'Loi update Don Hang Phi San Pham'
		rollback transaction
	END CATCH
	declare @MaDoanhNghiep varchar(50)
	declare @MaChiNhanh varchar(5)
	declare @PhiSanPhamCu smallmoney

	set @MaChiNhanh = (select dh.MaChiNhanh from DonHang Dh where dh.MaDH = @MaDH)
	set @MaDoanhNghiep= (select dh.MaDoanhNghiep from DonHang Dh where dh.MaDH = @MaDH)
	set @PhiSanPhamCu = (select dh.PhiSanPham from DonHang Dh where dh.MaDH = @MaDH)

	-- update chi nhanh cu doanh nghiep cu
	UPDATE ChiNhanh
	SET DoanhSoBan = DoanhSoBan - @PhiSanPhamCu + @PhiSanPhamMoi
	WHERE MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @MaDoanhNghiep;
	
	UPDATE DonHang
	SET PhiSanPham = @PhiSanPhamMoi
	WHERE madh = @madh;
	COMMIT TRANSACTION
GO

--Update DonHang_MaTX(newMaTX)
--	RB:7 

create proc updateDonHangMaTaiXe
	@MaDH varchar(50) ,
	@maTXMoi varchar(50)
as
begin transaction
	begin try
		if not exists (select * from donhang dh where dh.MaDH = @MaDH)
		begin 
			print 'khong ton tai don hang tren'
			rollback transaction
			return
		end
		if not exists (select * from TAIXE tx where tx.MATX = @maTXMoi)
		begin 
			print 'khong ton tai tai xe tren'
			rollback transaction
			return
		end
		if (select tx.KHUVUCHD from TAIXE Tx where tx.MATX = @maTXMoi) != 
		(select cn.DiaChi from DonHang Dh join ChiNhanh cn on cn.MaChiNhanh = dh.MaChiNhanh And cn.MaDoanhNghiep = dh.MaDoanhNghiep 
		where dh.MaDH = @MaDH)
		begin 
			print 'khu vuc hoat dong cua tai xe khong khop voi dia chi cua chi nhanh'
			rollback transaction
			return
		end
	END TRY
	BEGIN CATCH
		print 'Loi insert don hang ma tai xe'
		rollback transaction
	END CATCH

	UPDATE DonHang
	SET MaTX = @maTXMoi
	WHERE madh = @madh;
	COMMIT TRANSACTION
GO

--Update DoanhSoBan o table ChiNhanh

create proc Update_ChiNhanh_DoanhSoBan
	@MaChiNhanh varchar(5),
	@maDoanhNghiep varchar(50),
	@DoanhSoBan money
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra chi nhánh có tồn tại hay không
		if (not exists(select * from ChiNhanh where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @maDoanhNghiep))
		BEGIN
			print N'Chi nhánh không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END	

		--Kiểm tra Doanh số bán có phải là số dương
		if (@DoanhSoBan < 0)
		BEGIN
			print N'Doanh số bán âm'
			ROLLBACK TRANSACTION
			RETURN
		END			

		--Kiểm tra DoanhSoBan có bằng với DoanhSoBan hiện tại ?
		if (not exists(select * from ChiNhanh where MaChiNhanh = @MaChiNhanh and MaDoanhNghiep = @maDoanhNghiep and @DoanhSoBan = DoanhSoBan))
		BEGIN
			print N'Doanh số bán được cập nhật không hợp lí'
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

create PROC INSERT_HOPDONG
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
		
		INSERT INTO HOPDONG
		VALUES(@MAHD, @NGUOIDAIDIEN, @SOCHINHANHDK, @HIEULUC, @PHANTRAMHH, @NGAYBATDAU, @MADOANHNGHIEP)
	END TRY			
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH	
COMMIT TRANSACTION
GO

--Update SoChiNhanhDK của HOPDONG xử lí ràng buộc 2
CREATE PROC Update_HopDong_SoChiNhanhDK
	@mahd varchar(50),
	@SoChiNhanhDK int
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra mahd có tồn tại hay không
		if (not exists(select * from HopDong where MaHD = @mahd))
		BEGIN
			PRINT N'Hợp đồng không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END			
		
		--Kiểm tra sochinhanhdk trong hợp đồng có thay đổi hay không
		if (not exists(select * from HopDong where MaHD = @mahd and @SoChiNhanhDK = SoChiNhanhDK))
		BEGIN
			PRINT N'Không thể update số chi nhánh!!'
			ROLLBACK TRANSACTION
			RETURN
		END		
			
	END TRy
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH		
COMMIT TRANSACTION
GO				

--DELETE table chinhanh_sp ; RB:4, 5
CREATE PROC DELETE_CHINHANH_SP
	@MASP VARCHAR(50),
	@MACHINHANH VARCHAR(5),
	@MADOANHNGHIEP VARCHAR(50)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--kiểm tra xem có tồn tại chinhanh_sp
		if (not exists(select * from CHINHANH_SP 
		where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP and 
		@MASP = MASP))
		begin
			PRINT N'Không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		end	

		--Xử lí ràng buộc 4 : Nếu chi nhánh đó chỉ có một sản phẩm thì không xóa
		if ((select count(*) from CHINHANH_SP WHERE
		 @MADOANHNGHIEP = MADOANHNGHIEP AND @MACHINHANH = MACHINHANH) = 1)
		 BEGIN
			PRINT N'Chi nhánh này chỉ còn 1 sản phẩm nên không thể xóa'
			ROLLBACK TRANSACTION
			RETURN
		 END		

		--Xử lí ràng buộc 5
		if ((select count(*) from CHINHANH_SP WHERE @MASP = MASP) = 1)
		 BEGIN
			PRINT N'Sản phẩm này chỉ thuộc về 1 chi nhánh nên không thể xóa'
			ROLLBACK TRANSACTION
			RETURN
		 END	

		 delete CHINHANH_SP
		 where @MASP = MASP and @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP
	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH
COMMIT TRANSACTION
GO	


CREATE PROC Update_ChiNhanh_SP_MaChiNhanh
	@MASP VARCHAR(50),
	@MACHINHANH VARCHAR(5),
	@MADOANHNGHIEP VARCHAR(50),
	@NEWMACHINHANH VARCHAR(5)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--kiểm tra xem có tồn tại chinhanh_sp
		if (not exists(select * from CHINHANH_SP 
		where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP and 
		@MASP = MASP))
		begin
			PRINT N'Không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		end	

		--Kiểm tra xem @NewMaChiNhanh có tồn tại
		if (not exists(select * from ChiNhanh where @NEWMACHINHANH = MaChiNhanh 
						and @MADOANHNGHIEP = MaDoanhNghiep))
		BEGIN
			PRINT N'Không tồn tại chi nhánh mới'
			ROLLBACK TRANSACTION
			RETURN
		END	

		--xỬ LÍ RÀNG BUỘC 4 :Một ChiNhanh phải có ít nhất một sản phẩm
		if (1 = (select count(*) from CHINHANH_SP 
		where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP))
		BEGIN
			PRINT N'Mỗi chi nhánh phải có ít nhất một sản phẩm'
			ROLLBACK TRANSACTION
			RETURN
		END		

		UPDATE CHINHANH_SP
		SET MACHINHANH = @NEWMACHINHANH
		WHERE @MACHINHANH = MACHINHANH


	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH
COMMIT TRANSACTION
GO	

--Update masp của dh_sp
create proc Update_DonHang_SP_SLSP
	@MASP VARCHAR(50),
	@MADH VARCHAR(50),
	@SLSP int
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra dh_sp có tồn tại
		if (not exists(select * from DONHANG_SP where @MASP = MASP and @MADH = MADH))
		BEGIN
			PRINT N'DH_SP này không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END	

		--Kiểm tra slsp có > 0
		if (@SLSP <= 0)
		BEGIN
			PRINT N'Số lượng sản phẩm phải lớn hơn 0'
			ROLLBACK TRANSACTION
			RETURN	
		END		

		--Xử lí RB 6 : Thay đổi phí sản phẩm ở DonHang 3 * MN 5 * MN
		UPDATE DONHANG
		SET PhiSanPham = PHISANPHAM +  (SELECT (@SLSP - SLSP) FROM DONHANG_SP 
			WHERE @MASP = MASP AND @MADH = MADH) * (SELECT GIA FROM SANPHAM WHERE MASP = @MASP)
		WHERE  MADH = @MADH

		UPDATE DONHANG_SP 
		SET SLSP = @SLSP
		WHERE MASP = @MASP AND MADH = @MADH

	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH		
COMMIT TRANSACTION
GO		

create proc Update_DonHang_SP_MADH
	@MASP VARCHAR(50),
	@MADH VARCHAR(50),
	@NEWMADH VARCHAR(50)
AS
BEGIN TRANSACTION
	BEGIN TRY
		--Kiểm tra dh_sp có tồn tại
		if (not exists(select * from DONHANG_SP where @MASP = MASP and @MADH = MADH))
		BEGIN
			PRINT N'DH_SP này không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END	

		--Kiểm tra đơn hàng mới có tồn tại hay không
		if (not exists(select * from donhang where @NEWMADH = MADH))
		BEGIN
			PRINT N'Đơn hàng mới không tồn tại'
			ROLLBACK TRANSACTION
			RETURN
		END		



		--Xử lí RB 6 : Update đơn hàng cũ và đơn hàng mới
		--Đơn hàng cũ : PHISP = PHISP - (GIA TIEN @MASP) * SLSP
		UPDATE DONHANG
		SET PhiSanPham = PHISANPHAM - (select slsp from DONHANG_SP where @masp = masp and @MADH = MaDH) * 
									(SELECT GIA FROM SANPHAM WHERE @MASP = MASP)
		WHERE MADH = @MADH
		--Đơn hàng mới : PhiSP = PhiSP + (Gia Tien @MaSP) * SLSP
		UPDATE DONHANG
		SET PhiSanPham = PHISANPHAM + (select slsp from DONHANG_SP where @masp = masp and @MADH = MaDH) * 
									(SELECT GIA FROM SANPHAM WHERE @MASP = MASP)
		WHERE MADH = @NEWMADH


		UPDATE DONHANG_SP 
		SET MADH = @NEWMADH
		WHERE MASP = @MASP AND MADH = @MADH

	END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH		
COMMIT TRANSACTION
GO		

-- 18 updateChiNhanh_SP_MaDoanhNghiep_4
CREATE PROC Update_ChiNhanh_SP_MaDoanhNghiep
    @MASP VARCHAR(50),
    @MACHINHANH VARCHAR(5),
    @MADOANHNGHIEP VARCHAR(50),
    @MADOANHNGHIEP_NEW VARCHAR(50)
AS
BEGIN TRANSACTION
    BEGIN TRY
        --kiem tra xem co ton tai chinhanh_sp
        if (not exists(select * from CHINHANH_SP 
        where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP and 
        @MASP = MASP))
        begin
            PRINT N'Không tồn tại'
            ROLLBACK TRANSACTION
            RETURN
        end    

        if (not exists(select * from ChiNhanh where @MADOANHNGHIEP_NEW = MaDoanhNghiep))
        BEGIN
            PRINT N'Không tồn tại doanh nghiệp mới'
            ROLLBACK TRANSACTION
            RETURN
        END    


        if (1 = (select count(*) from CHINHANH_SP 
        where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP))
        BEGIN
            PRINT N'Mỗi chi nhánh phải có ít nhất 1 sản phẩm'
            ROLLBACK TRANSACTION
            RETURN
        END        

        UPDATE CHINHANH_SP
        SET MADOANHNGHIEP = @MADOANHNGHIEP_NEW
        WHERE @MADOANHNGHIEP = MADOANHNGHIEP

    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
    END CATCH
COMMIT TRANSACTION


--19 Update ChiNhanh_SP_MaSanPham(newMaSanPham) 5
CREATE PROC ChiNhanh_SP_MaSanPham
    @MASP VARCHAR(50),
    @MACHINHANH VARCHAR(5),
    @MADOANHNGHIEP VARCHAR(50),
  @MASP_new VARCHAR(50)
AS
BEGIN TRANSACTION
    BEGIN TRY
        --kiem tra xem co ton tai chinhanh_sp
        if (not exists(select * from CHINHANH_SP 
        where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP and 
        @MASP = MASP))
        begin
            PRINT N'Không tồn tại'
            ROLLBACK TRANSACTION
            RETURN
        end    

        if (not exists(select * from SANPHAM s where @MASP_new = s.MASP))
        BEGIN
            PRINT N'Không tồn tại sản phẩm mới'
            ROLLBACK TRANSACTION
            RETURN
        END    

        if (1 = (select count(*) from CHINHANH_SP 
        where @MACHINHANH = MACHINHANH and @MADOANHNGHIEP = MADOANHNGHIEP))
        BEGIN
            PRINT N'Mỗi sản phẩm phải thuộc ít nhất 1 chi nhánh'
            ROLLBACK TRANSACTION
            RETURN
        END

        UPDATE CHINHANH_SP
        SET MASP = @MASP_new
        WHERE @MASP = MASP

    END TRY
    BEGIN CATCH
        PRINT N'Lỗi hệ thống'
        ROLLBACK TRANSACTION
    END CATCH
COMMIT TRANSACTION


--20 Update SanPham_Gia(NewGia) 6
CREATE PROC update_sanpham_gia
@MaSP varchar(50),
@Gia_old SMALLMONEY,
@Gia_new SMALLMONEY
AS
BEGIN TRANSACTION
BEGIN TRY

  IF NOT EXISTS(SELECT *
  FROM SANPHAM sp
  WHERE sp.MASP = @MaSP )
    BEGIN
      PRINT N'Mã sản phẩm không tồn tại'
      ROLLBACK TRANSACTION
      RETURN
    END
  IF NOT EXISTS(SELECT *
  FROM SANPHAM sp
  WHERE sp.GIA = @Gia_old AND sp.MASP = @MaSP)
    BEGIN
      PRINT N'Thông tin sản phẩm sai'
      ROLLBACK TRANSACTION
      RETURN
    END
  if (@Gia_new IS NOT null)
		Begin
			update SANPHAM 
			SET GIA = @Gia_new 
			WHERE GIA = @Gia_old AND MASP = @MaSP
		End	
END TRY
BEGIN CATCH
PRINT N'Lỗi hệ thống' 
ROLLBACK TRANSACTION
END CATCH
PRINT N'Update successfully'
COMMIT TRANSACTION

--25 Update TaiXe_KhuVucHD(newKhuVucHD)7
CREATE PROC update_taixe_khuvuchd
@MaTX varchar(50),
@KhuVucHD_old VARCHAR(50),
@KhuVucHD_new VARCHAR(50)
AS
BEGIN TRANSACTION
BEGIN TRY

  IF NOT EXISTS(SELECT *
  FROM TAIXE  tx  
  WHERE tx.MATX = @MaTX )
    BEGIN
      PRINT N'Mã tài xế không tồn tại'
      ROLLBACK TRANSACTION
      RETURN
    END
  IF NOT EXISTS(SELECT *
  FROM TAIXE tx
  WHERE tx.KHUVUCHD = @KhuVucHD_old )
    BEGIN
      PRINT N'Thông tin khu vực hoạt động  sai'
      ROLLBACK TRANSACTION
      RETURN
    END
    IF EXISTS(SELECT *
  FROM TAIXE tx, ChiNhanh cn
  WHERE @KhuVucHD_new <> cn.DiaChi )
     BEGIN
      PRINT N'Thông tin khu vực hoạt động sai'
      ROLLBACK TRANSACTION
      RETURN
    END

  if (@KhuVucHD_new <> @KhuVucHD_old)
		Begin
			update TAIXE
			SET KHUVUCHD = @KhuVucHD_new 
			WHERE MATX = @MaTX AND KHUVUCHD = @KhuVucHD_old
		End	
END TRY
BEGIN CATCH
PRINT N'Lỗi khu vực' 
ROLLBACK TRANSACTION
END CATCH
PRINT N'Update successfully'
COMMIT TRANSACTION

--21 Insert DH_SP() 6
CREATE PROC Insert_DH_SP
@SLSP INT,
@MaSP VARCHAR(50),
@MaDH VARCHAR(50)
AS
BEGIN TRANSACTION
BEGIN TRY

  IF NOT EXISTS(SELECT *
  FROM DONHANG_SP ds  
  WHERE @MaSP = ds.MASP AND @MaDH = ds.MADH)
    BEGIN
      PRINT N'Mã don hàng không tồn tại'
      ROLLBACK TRANSACTION
      RETURN
    END
  -- Check SLSP
  if (@SLSP = 0)
		Begin
			Print N'Số lượng sản phẩm lớn hơn 0'
			ROLLBACK TRANSACTION
			RETURN
		End
  
    IF (select SUM(DHSP.SLSP*SP.GIA)
from DONHANG_SP DHSP JOIN SANPHAM SP ON DHSP.MASP = SP.MASP) != (SELECT SUM(@SLSP*SP.GIA)  FROM  DONHANG_SP DHSP JOIN SANPHAM SP ON DHSP.MASP = SP.MASP)
  BEGIN 
    PRINT N'Lỗi phí sản phẩm'
  ROLLBACK TRANSACTION
  RETURN
  END

  INSERT INTO DONHANG_SP
  VALUEs (@SLSP,@MaSP,@MaDH)

  END TRY
	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH

COMMIT TRANSACTION

      
--27 Delete DH_SP() 6

CREATE PROC delete_DH_SP
@SLSP INT,
@MaDH VARCHAR(50),
@MaSP VARCHAR(50)
as
BEGIN TRANSACTION
  BEGIN TRY
    IF NOT EXISTS(SELECT *
                  FROM DONHANG_SP ds 
                  WHERE ds.MASP = @MaSP AND ds.MADH = @MaDH)
      BEGIN
        PRINT N'Đơn hàng không tồn tại'
        ROLLBACK TRANSACTION
      END
    
  DELETE DONHANG_SP 
  WHERE MASP = @MaSP AND MaDH = @MaDH
  END TRY
  	BEGIN CATCH
		PRINT N'Lỗi hệ thống'
		ROLLBACK TRANSACTION
	END CATCH
COMMIT TRANSACTION



SELECT * FROM DONHANG_SP

INSERT INTO DONHANG_SP VALUES('2', '1', 3)

