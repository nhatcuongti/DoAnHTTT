SELECT * FROM DonHang


CREATE proc insertDonHang
	@MaDH varchar(50) ,
	@PhiVanChuyen  smallmoney,
	@TinhTrang  int,
	@HinhThucThanhToan  int ,
	@PhiSanPham  smallmoney,
	@DiaChiGiao nvarchar(50),
	@MaChiNhanh varchar(5) ,
	@MaDoanhNghiep varchar(50) ,
	@MaKhachHang varchar(50)
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
	VALUES (@MaDH,@PhiVanChuyen,@TinhTrang,@HinhThucThanhToan,@PhiSanPham, GETDATE(), @DiaChiGiao, @MaChiNhanh,@MaDoanhNghiep,@MaKhachHang,NULL);



	UPDATE DoanhNghiep
	SET SLDonHang = SLDonHang + 1
	WHERE MaSoThue = @MaDoanhNghiep;

	UPDATE ChiNhanh
	SET DoanhSoBan = DoanhSoBan + @PhiSanPham
	WHERE MaDoanhNghiep = @MaDoanhNghiep and MaChiNhanh = @MaChiNhanh ;

	COMMIT TRANSACTION
GO
