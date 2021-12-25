use Nhom18_DoAnThucHanh_19HTT2_1
go

--
INSERT INTO NHANVIEN(MANV, hoten, DIACHI, EMAIL,SDT)
VALUES ('NV01', 'Nguyen Van Hao', 'BinhPhuoc', 'hao@', '0123123123');
INSERT INTO TKNHANVIEN(ID, MK, TRANGTHAI, MANV)
VALUES ('nvhao', '123',1, 'NV01');
go
--ERR05: Phantom Read
--T1 (User = Admin): thực hiện xoá tài khoản của nhân viên.
--T2 (User = Nhân viên): đăng nhập vào tài khoản của mình


--T1
create proc sp_XoaTaiKhoanNhanVien
	@taikhoan varchar(50)
as
begin transaction
	begin try
		IF NOT EXISTS (SELECT * FROM TKNhanVien tknv WHERE tknv.id = @taikhoan)
		BEGIN
				print 'khong ton tai tai khoan nay'
				Rollback transaction
				Return
		END
	END TRY
	BEGIN CATCH
		print 'Loi he thong xoa tai khoan nhan vien'
		rollback transaction
	END CATCH

	DELETE FROM TKNhanVien WHERE id = @taikhoan

	print 'xoa thanh cong'
	COMMIT TRANSACTION
GO

--T2
create proc sp_DangNhapNhanVien

	@taikhoan varchar(50),
	@matkhau varchar(50)
as
begin transaction
	begin try
		IF NOT EXISTS (SELECT * FROM TKNhanVien tknv WHERE tknv.id = @taikhoan)
		BEGIN
				print 'khong ton tai tai khoan nay'
				Rollback transaction
				Return
		END
		IF 0 = (SELECT tknv.trangthai FROM TKNhanVien tknv WHERE tknv.id = @taikhoan)
		BEGIN
				print 'tai khoan nay bi khoa'
				Rollback transaction
				Return
		END


		IF @matkhau != (SELECT tknv.mk FROM TKNhanVien tknv WHERE tknv.id = @taikhoan)
		BEGIN
				print 'sai mat khau'
				Rollback transaction
				 Return
		END
		WAITFOR DELAY '0:0:10'
	END TRY
	BEGIN CATCH
		print 'Loi he thong dang nhap nhan vien'
		rollback transaction
	END CATCH
	print '-------Dang nhap thanh cong-------'
	print '-Thong tin user'
	Declare @tk varchar(50) 
	Declare @mk varchar(50)
	Declare @tt int
	Set @tk = (SELECT tknv.id FROM TKNhanVien tknv WHERE tknv.id = @taikhoan)
	Set @mk = (SELECT tknv.mk FROM TKNhanVien tknv WHERE tknv.id = @taikhoan)
	Set @tt = (SELECT tknv.TRANGTHAI FROM TKNhanVien tknv WHERE tknv.id = @taikhoan)
	Print '-- Tai Khoan: ' + @tk 
	Print '-- Mat khau: ' + @mk 
	Print '-- Trang thai: ' + cast(@tt as varchar(10))
	COMMIT TRANSACTION
GO



