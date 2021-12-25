use Nhom18_DoAnThucHanh_19HTT2_1
go

--Thêm dữ iệu để test
INSERT INTO NHANVIEN(MANV, hoten, DIACHI, EMAIL,SDT)
VALUES ('NV01', 'Nguyen Van Hao', 'BinhPhuoc', 'hao@', '0123123123');
INSERT INTO TKNHANVIEN(ID, MK, TRANGTHAI, MANV)
VALUES ('nvhao', '123',1, 'NV01');
go


--ERR07: unrepeatable read
--T1 (User = admin): thực hiện khoá tài khoản của nhân viên đó
--T2 (User = Nhân viên): thực hiện đăng nhập.

--T1

alter proc sp_KhoaTaiKhoanNhanVien

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
		print 'Loi he thong khoa tai khoan nhan vien'
		rollback transaction
	END CATCH

	UPDATE TKNhanVien
	SET trangthai =  0
	WHERE id = @taikhoan;

	print 'Khoa tai khoan nhan vien thanh cong'
	COMMIT TRANSACTION
GO


--T2
alter proc sp_DangNhapNhanVien

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

	SELECT ID, MK, TRANGTHAI FROM TKNHANVIEN
	WHERE ID = @taikhoan

	COMMIT TRANSACTION
GO



select * from TKNHANVIEN