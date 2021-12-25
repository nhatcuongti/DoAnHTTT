﻿--
-- Script was generated by Devart dbForge Studio 2019 for SQL Server, Version 5.8.127.0
-- Product Home Page: http://www.devart.com/dbforge/sql/studio
-- Script date 12/25/2021 10:09:54 AM
-- Target server version: 15.00.2080
-- Target connection string: Data Source=TRHUTRONG;Encrypt=False;Initial Catalog=QLHD;Integrated Security=True;User ID=TRHUTRONG\ADMIN
--



SET LANGUAGE 'English'
SET DATEFORMAT ymd
SET ARITHABORT, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER, ANSI_NULLS, NOCOUNT ON
SET NUMERIC_ROUNDABORT, IMPLICIT_TRANSACTIONS, XACT_ABORT OFF
GO

--
-- Backing up database Nhom18_DoAnThucHanh_19HTT2_1
--
--
-- Create backup folder
--
IF OBJECT_ID('xp_create_subdir') IS NOT NULL
  EXEC xp_create_subdir N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup'
--
-- Backup database to the file with the name: <database_name>_<yyyy>_<mm>_<dd>_<hh>_<mi>.bak
--
DECLARE @db_name SYSNAME
SET @db_name = N'Nhom18_DoAnThucHanh_19HTT2_1'

DECLARE @filepath NVARCHAR(4000)
SET @filepath =
/*define base part*/ N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\' + @db_name + '_' +
/*append date*/ REPLACE(CONVERT(NVARCHAR(10), GETDATE(), 102), '.', '_') + '_' +
/*append time*/ REPLACE(CONVERT(NVARCHAR(5), GETDATE(), 108), ':', '_') + '.bak'

DECLARE @SQL NVARCHAR(MAX)
SET @SQL = 
    N'BACKUP DATABASE ' + QUOTENAME(@db_name) + ' TO DISK = @filepath WITH INIT' + 
      CASE WHEN EXISTS(
                SELECT value
                FROM sys.configurations
                WHERE name = 'backup compression default'
          )
        THEN ', COMPRESSION'
        ELSE ''
      END

EXEC sys.sp_executesql @SQL, N'@filepath NVARCHAR(4000)', @filepath = @filepath
GO

USE Nhom18_DoAnThucHanh_19HTT2_1
GO

IF DB_NAME() <> N'Nhom18_DoAnThucHanh_19HTT2_1' SET NOEXEC ON
GO
--
-- Delete data from the table 'dbo.TX_DH'
--
TRUNCATE TABLE dbo.TX_DH
GO
--
-- Delete data from the table 'dbo.TKTAIXE'
--
TRUNCATE TABLE dbo.TKTAIXE
GO
--
-- Delete data from the table 'dbo.TKNHANVIEN'
--
TRUNCATE TABLE dbo.TKNHANVIEN
GO
--
-- Delete data from the table 'dbo.TKKhachHang'
--
TRUNCATE TABLE dbo.TKKhachHang
GO
--
-- Delete data from the table 'dbo.TKDoanhNghiep'
--
TRUNCATE TABLE dbo.TKDoanhNghiep
GO
--
-- Delete data from the table 'dbo.DONHANG_SP'
--
TRUNCATE TABLE dbo.DONHANG_SP
GO
--
-- Delete data from the table 'dbo.DH_KH'
--
TRUNCATE TABLE dbo.DH_KH
GO
--
-- Delete data from the table 'dbo.CHINHANH_SP'
--
TRUNCATE TABLE dbo.CHINHANH_SP
GO
--
-- Delete data from the table 'dbo.DonHang'
--
DELETE dbo.DonHang
GO
--
-- Delete data from the table 'dbo.ChiNhanh'
--
DELETE dbo.ChiNhanh
GO
--
-- Delete data from the table 'dbo.HopDong'
--
DELETE dbo.HopDong
GO
--
-- Delete data from the table 'dbo.TAIXE'
--
DELETE dbo.TAIXE
GO
--
-- Delete data from the table 'dbo.DoanhNghiep'
--
DELETE dbo.DoanhNghiep
GO
--
-- Delete data from the table 'dbo.SANPHAM'
--
DELETE dbo.SANPHAM
GO
--
-- Delete data from the table 'dbo.NHANVIEN'
--
DELETE dbo.NHANVIEN
GO
--
-- Delete data from the table 'dbo.LOAIHANG'
--
DELETE dbo.LOAIHANG
GO
--
-- Delete data from the table 'dbo.KhuVucHoatDong'
--
DELETE dbo.KhuVucHoatDong
GO
--
-- Delete data from the table 'dbo.KhachHang'
--
DELETE dbo.KhachHang
GO

--
-- Inserting data into table dbo.KhachHang
--
INSERT dbo.KhachHang(MaKH, HoTen, SDT, DiaChi, Email) VALUES (N'0', N'Bằng Sơn', '033-2693', 'Bến Lức', 'nubfsafr1@example.com')
INSERT dbo.KhachHang(MaKH, HoTen, SDT, DiaChi, Email) VALUES (N'9', N'Gia Ðức', '134-4990', 'Thủ Đức', 'Phan@example.com')
INSERT dbo.KhachHang(MaKH, HoTen, SDT, DiaChi, Email) VALUES (N'7', N'Bảo An', '582-1898', '10', 'ClarissaCraven65@example.com')
INSERT dbo.KhachHang(MaKH, HoTen, SDT, DiaChi, Email) VALUES (N'5', N'Gia Hiệp', '456-3913', '4', 'Reginald_Vanmeter@example.com')
INSERT dbo.KhachHang(MaKH, HoTen, SDT, DiaChi, Email) VALUES (N'6', N'Trà My', '436-5187', 'Tân Bình', 'czder3807@example.com')
INSERT dbo.KhachHang(MaKH, HoTen, SDT, DiaChi, Email) VALUES (N'3', N'Yên Sơn', '059-8668', '1', 'Lois.Counts@nowhere.com')
INSERT dbo.KhachHang(MaKH, HoTen, SDT, DiaChi, Email) VALUES (N'8', N'Thất Dũng', '858-1826', '9', 'Corrigan29@example.com')
INSERT dbo.KhachHang(MaKH, HoTen, SDT, DiaChi, Email) VALUES (N'1', N'Quỳnh Trang', '927-6368', '2', 'hwhe80@example.com')
INSERT dbo.KhachHang(MaKH, HoTen, SDT, DiaChi, Email) VALUES (N'2', N'Hà Mi', '485-8556', 'Bình Tân', 'qhmokvl19@nowhere.com')
GO

--
-- Inserting data into table dbo.KhuVucHoatDong
--
INSERT dbo.KhuVucHoatDong(MAKHUVUC, TENKHUVUC) VALUES (N'3', N'Nguyễn Trãi')
INSERT dbo.KhuVucHoatDong(MAKHUVUC, TENKHUVUC) VALUES (N'8', N'Lê Lai')
INSERT dbo.KhuVucHoatDong(MAKHUVUC, TENKHUVUC) VALUES (N'5', N'Lý Chính Thắng')
INSERT dbo.KhuVucHoatDong(MAKHUVUC, TENKHUVUC) VALUES (N'2', N'Hùng Vương')
INSERT dbo.KhuVucHoatDong(MAKHUVUC, TENKHUVUC) VALUES (N'1', N'Lê Lợi')
INSERT dbo.KhuVucHoatDong(MAKHUVUC, TENKHUVUC) VALUES (N'4', N'Nguyễn Thị Minh Khai')
INSERT dbo.KhuVucHoatDong(MAKHUVUC, TENKHUVUC) VALUES (N'7', N'Trần Hưng Đạo')
INSERT dbo.KhuVucHoatDong(MAKHUVUC, TENKHUVUC) VALUES (N'9', N'Trường Chinh')
INSERT dbo.KhuVucHoatDong(MAKHUVUC, TENKHUVUC) VALUES (N'6', N'Nguyễn Văn Cừ')
GO

--
-- Inserting data into table dbo.LOAIHANG
--
INSERT dbo.LOAIHANG(MALOAIHANG, TENLOAIHANG) VALUES (N'8', N'Accessories')
INSERT dbo.LOAIHANG(MALOAIHANG, TENLOAIHANG) VALUES (N'7', N'Electronics')
INSERT dbo.LOAIHANG(MALOAIHANG, TENLOAIHANG) VALUES (N'1', N'Beauty')
INSERT dbo.LOAIHANG(MALOAIHANG, TENLOAIHANG) VALUES (N'3', N'Automotive')
INSERT dbo.LOAIHANG(MALOAIHANG, TENLOAIHANG) VALUES (N'2', N'Automotive')
INSERT dbo.LOAIHANG(MALOAIHANG, TENLOAIHANG) VALUES (N'6', N'Clothing')
INSERT dbo.LOAIHANG(MALOAIHANG, TENLOAIHANG) VALUES (N'4', N'Health')
INSERT dbo.LOAIHANG(MALOAIHANG, TENLOAIHANG) VALUES (N'9', N'Tools')
INSERT dbo.LOAIHANG(MALOAIHANG, TENLOAIHANG) VALUES (N'5', N'Food')
GO

--
-- Inserting data into table dbo.NHANVIEN
--
INSERT dbo.NHANVIEN(MANV, HOTEN, DIACHI, EMAIL, SDT) VALUES (N'1', N'Hoài Vỹ', 'Lý Chính Thắng', 'Reinaldo_Goforth@nowhere.com', '03416761826')
INSERT dbo.NHANVIEN(MANV, HOTEN, DIACHI, EMAIL, SDT) VALUES (N'2', N'Minh Tuấn', 'Trường Chinh', 'Arden.Mcmillen@nowhere.com', '03304618012')
INSERT dbo.NHANVIEN(MANV, HOTEN, DIACHI, EMAIL, SDT) VALUES (N'7', N'Vĩnh Thọ', 'An Dương Vương', 'etadog2515@example.com', '03006932389')
INSERT dbo.NHANVIEN(MANV, HOTEN, DIACHI, EMAIL, SDT) VALUES (N'0', N'Lệ Hoa', 'Hùng Vương', 'JessHuntington@example.com', '03759737214')
INSERT dbo.NHANVIEN(MANV, HOTEN, DIACHI, EMAIL, SDT) VALUES (N'9', N'hương Châu', 'Cách Mạng Tháng 8', 'Knott@nowhere.com', '03478882778')
INSERT dbo.NHANVIEN(MANV, HOTEN, DIACHI, EMAIL, SDT) VALUES (N'4', N'Quỳnh Sa', 'Nguyễn Trãi', 'fmtskgwn_mpjfo@example.com', '03308602792')
INSERT dbo.NHANVIEN(MANV, HOTEN, DIACHI, EMAIL, SDT) VALUES (N'5', N'�ông Dương', 'Nguyễn Văn Cừ', 'Smoot14@nowhere.com', '03378839238')
INSERT dbo.NHANVIEN(MANV, HOTEN, DIACHI, EMAIL, SDT) VALUES (N'8', N'Tấn Tài', 'Cộng Hòa', 'RyanAnders7@example.com', '03745028257')
INSERT dbo.NHANVIEN(MANV, HOTEN, DIACHI, EMAIL, SDT) VALUES (N'6', N'Lệ Huyền', 'Âu Cơ', 'SungAlvarez@nowhere.com', '03747053445')
GO

--
-- Inserting data into table dbo.SANPHAM
--
INSERT dbo.SANPHAM(MASP, TENSP, GIA) VALUES (N'7', N'Bicordon', 657.7352)
INSERT dbo.SANPHAM(MASP, TENSP, GIA) VALUES (N'8', N'Suplictedger', 380.074)
INSERT dbo.SANPHAM(MASP, TENSP, GIA) VALUES (N'0', N'Stereotinator', 65.8295)
INSERT dbo.SANPHAM(MASP, TENSP, GIA) VALUES (N'6', N'Tabtopaquator', 648.3773)
INSERT dbo.SANPHAM(MASP, TENSP, GIA) VALUES (N'2', N'Conniedgphone', 68.369)
INSERT dbo.SANPHAM(MASP, TENSP, GIA) VALUES (N'3', N'Printculletor', 132.5854)
INSERT dbo.SANPHAM(MASP, TENSP, GIA) VALUES (N'4', N'Translifiimentor', 279.0508)
INSERT dbo.SANPHAM(MASP, TENSP, GIA) VALUES (N'1', N'Armtaicer', 983.6713)
INSERT dbo.SANPHAM(MASP, TENSP, GIA) VALUES (N'9', N'Amplifiicator', 161.1972)
GO

--
-- Inserting data into table dbo.DoanhNghiep
--
INSERT dbo.DoanhNghiep(MaSoThue, LoaiHang, DiaChiKinhDoanh, QUAN, TenDoanhNghiep, NguoiDaiDien, ThanhPho, SoDT, Email, SLDonHang) VALUES (N'43757', '5', N'Nguyễn Văn Cừ', N'3', N'Jamie', N'Quang Trọng', N'Hồ Chí Minh', '03364624545', 'Alexia_Dobbins8@example.com', 953)
INSERT dbo.DoanhNghiep(MaSoThue, LoaiHang, DiaChiKinhDoanh, QUAN, TenDoanhNghiep, NguoiDaiDien, ThanhPho, SoDT, Email, SLDonHang) VALUES (N'33847', '3', N'Trần Hưng Đạo', N'Thanh Xuân', N'Pedro', N'Lâm Tường', N'Hà Nội', '03029468595', 'vnlx5987@nowhere.com', 81)
INSERT dbo.DoanhNghiep(MaSoThue, LoaiHang, DiaChiKinhDoanh, QUAN, TenDoanhNghiep, NguoiDaiDien, ThanhPho, SoDT, Email, SLDonHang) VALUES (N'23248', '5', N'Lê Lợi', N'Thủ Đức', N'Toney', N'Quang Trung', N'Hồ Chí Minh', '03488852176', 'Allen@example.com', 578)
INSERT dbo.DoanhNghiep(MaSoThue, LoaiHang, DiaChiKinhDoanh, QUAN, TenDoanhNghiep, NguoiDaiDien, ThanhPho, SoDT, Email, SLDonHang) VALUES (N'03317', '1', N'Lê Lai', N'Cầu Giấy', N'Emil', N'Dã Lâm', N'Hà Nội', '03449437735', 'Bradbury@example.com', 219)
INSERT dbo.DoanhNghiep(MaSoThue, LoaiHang, DiaChiKinhDoanh, QUAN, TenDoanhNghiep, NguoiDaiDien, ThanhPho, SoDT, Email, SLDonHang) VALUES (N'38549', '7', N'Nguyễn Trãi', N'Phú Tài', N'Rolland', N'Lâm Viên', N'Phan Thiết', '03350132113', 'Marci_Peterson485@example.com', 861)
INSERT dbo.DoanhNghiep(MaSoThue, LoaiHang, DiaChiKinhDoanh, QUAN, TenDoanhNghiep, NguoiDaiDien, ThanhPho, SoDT, Email, SLDonHang) VALUES (N'88873', '3', N'An Dương Vương', N'Tam Hiệp', N'Lamar', N'Việt Hà', N'Biên Hòa', '03703208756', 'Tristan.Mcgregor65@example.com', 308)
INSERT dbo.DoanhNghiep(MaSoThue, LoaiHang, DiaChiKinhDoanh, QUAN, TenDoanhNghiep, NguoiDaiDien, ThanhPho, SoDT, Email, SLDonHang) VALUES (N'67586', '7', N'Nguyễn Thị Minh Khai', N'9', N'Amado', N'Thu Ngọc', N'Hồ Chí Minh', '03704647420', 'fjfn7678@nowhere.com', 764)
INSERT dbo.DoanhNghiep(MaSoThue, LoaiHang, DiaChiKinhDoanh, QUAN, TenDoanhNghiep, NguoiDaiDien, ThanhPho, SoDT, Email, SLDonHang) VALUES (N'49858', '3', N'Hùng Vương', N'7', N'Carey', N'Việt Hương', N'Hồ Chí Minh', '03758591266', 'Abrams@nowhere.com', 3)
INSERT dbo.DoanhNghiep(MaSoThue, LoaiHang, DiaChiKinhDoanh, QUAN, TenDoanhNghiep, NguoiDaiDien, ThanhPho, SoDT, Email, SLDonHang) VALUES (N'00216', '7', N'Trường Chinh', N'Đống Đa', N'Dario', N'Công Luật', N'Hà Nội', '03373239158', 'Arndt@example.com', 663)
GO

--
-- Inserting data into table dbo.TAIXE
--
INSERT dbo.TAIXE(MATX, HOTEN, DIACHI, EMAIL, BIENSOXE, TKNH, KHUVUCHD, SDT) VALUES (N'4', N'Huyền Thư', N'Nguyễn Thị Minh Khai', 'Jose_Reddick@example.com', 'BE-197765740-1', '3540219207330736', '3', '07624117050')
INSERT dbo.TAIXE(MATX, HOTEN, DIACHI, EMAIL, BIENSOXE, TKNH, KHUVUCHD, SDT) VALUES (N'1', N'Lâm Uyên', N'Nguyễn Văn Cừ', 'Falk284@example.com', 'JP-463857677-9', '3528921547883789', '1', '07624073914')
INSERT dbo.TAIXE(MATX, HOTEN, DIACHI, EMAIL, BIENSOXE, TKNH, KHUVUCHD, SDT) VALUES (N'7', N'Xuân Minh', N'Cách Mạng Tháng 8', 'SadyeForte@example.com', 'AT-552640768-3', '3550281595065677', '3', '07624356075')
INSERT dbo.TAIXE(MATX, HOTEN, DIACHI, EMAIL, BIENSOXE, TKNH, KHUVUCHD, SDT) VALUES (N'0', N'Quý Khánh', N'Âu Cơ', 'MelBoggs38@example.com', 'CH-108982650-2', '341223717495887', '9', '07624566616')
INSERT dbo.TAIXE(MATX, HOTEN, DIACHI, EMAIL, BIENSOXE, TKNH, KHUVUCHD, SDT) VALUES (N'8', N'Huyền Trang', N'Trường Chinh', 'Vance_Blocker229@nowhere.com', 'MX-297623707-4', '4175004286719623', '3', '07624702100')
INSERT dbo.TAIXE(MATX, HOTEN, DIACHI, EMAIL, BIENSOXE, TKNH, KHUVUCHD, SDT) VALUES (N'5', N'hi Phi', N'Hùng Vương', 'Terence.Robins@nowhere.com', 'FR-386406798-4', '5103891164619915', '5', '07504413953')
INSERT dbo.TAIXE(MATX, HOTEN, DIACHI, EMAIL, BIENSOXE, TKNH, KHUVUCHD, SDT) VALUES (N'2', N'Xuân Nam', N'Lê Lợi', 'Doughty583@example.com', 'UA-818905366-8', '5574170051600332', '3', '07624940194')
INSERT dbo.TAIXE(MATX, HOTEN, DIACHI, EMAIL, BIENSOXE, TKNH, KHUVUCHD, SDT) VALUES (N'9', N'Lê Quỳnh', N'Lý Chính Thắng', 'SylviaC_Leroy88@nowhere.com', 'AT-907688455-6', '6227829734683333', '6', '07624962227')
INSERT dbo.TAIXE(MATX, HOTEN, DIACHI, EMAIL, BIENSOXE, TKNH, KHUVUCHD, SDT) VALUES (N'6', N'Tố Nga', N'Cộng Hòa', 'SantosBerube@example.com', 'CH-197765741-5', '3578363739641676', '2', '07937846009')
GO

--
-- Inserting data into table dbo.HopDong
--
INSERT dbo.HopDong(MaHD, NguoiDaiDien, SoChiNhanhDK, HieuLuc, PhanTramHH, NgayBatDau, MaDoanhNghiep, DangGiaHan) VALUES (N'3', N'Bạch Trà', 4, 9, 0.55949, '2019-11-10', '38549', 1)
INSERT dbo.HopDong(MaHD, NguoiDaiDien, SoChiNhanhDK, HieuLuc, PhanTramHH, NgayBatDau, MaDoanhNghiep, DangGiaHan) VALUES (N'9', N'Nhật Dũng', 9, 7, 0.89624, '2019-11-23', '88873', 0)
INSERT dbo.HopDong(MaHD, NguoiDaiDien, SoChiNhanhDK, HieuLuc, PhanTramHH, NgayBatDau, MaDoanhNghiep, DangGiaHan) VALUES (N'6', N'Nguyên Thảo', 1, 3, 0.16601, '2018-06-05', '00216', 1)
INSERT dbo.HopDong(MaHD, NguoiDaiDien, SoChiNhanhDK, HieuLuc, PhanTramHH, NgayBatDau, MaDoanhNghiep, DangGiaHan) VALUES (N'2', N'Thành Vinh', 3, 12, 0.27854, '2021-07-25', '03317', 1)
INSERT dbo.HopDong(MaHD, NguoiDaiDien, SoChiNhanhDK, HieuLuc, PhanTramHH, NgayBatDau, MaDoanhNghiep, DangGiaHan) VALUES (N'7', N'hánh My', 0, 1, 0.50537, '2020-10-31', '03317', 1)
INSERT dbo.HopDong(MaHD, NguoiDaiDien, SoChiNhanhDK, HieuLuc, PhanTramHH, NgayBatDau, MaDoanhNghiep, DangGiaHan) VALUES (N'8', N'Yến Phượng', 8, 9, 0.24869, '2019-07-05', '00216', 1)
INSERT dbo.HopDong(MaHD, NguoiDaiDien, SoChiNhanhDK, HieuLuc, PhanTramHH, NgayBatDau, MaDoanhNghiep, DangGiaHan) VALUES (N'5', N'�ức Khang', 0, 12, 0.84326, '2019-09-16', '23248', 1)
INSERT dbo.HopDong(MaHD, NguoiDaiDien, SoChiNhanhDK, HieuLuc, PhanTramHH, NgayBatDau, MaDoanhNghiep, DangGiaHan) VALUES (N'4', N'Thụy Long', 4, 10, 0.66356, '2018-03-12', '00216', 0)
INSERT dbo.HopDong(MaHD, NguoiDaiDien, SoChiNhanhDK, HieuLuc, PhanTramHH, NgayBatDau, MaDoanhNghiep, DangGiaHan) VALUES (N'0', N'Nguyết Ánh', 5, 0, 0.20392, '2019-09-27', '23248', 1)
GO

--
-- Inserting data into table dbo.ChiNhanh
--
INSERT dbo.ChiNhanh(MACHINHANH, MaDoanhNghiep, DiaChi, DoanhSoBan, MAHOPDONG) VALUES (N'1', N'38549', '6', 2615845, '4')
INSERT dbo.ChiNhanh(MACHINHANH, MaDoanhNghiep, DiaChi, DoanhSoBan, MAHOPDONG) VALUES (N'8', N'43757', '2', 1280882, '8')
INSERT dbo.ChiNhanh(MACHINHANH, MaDoanhNghiep, DiaChi, DoanhSoBan, MAHOPDONG) VALUES (N'9', N'88873', '7', 2739020, '4')
INSERT dbo.ChiNhanh(MACHINHANH, MaDoanhNghiep, DiaChi, DoanhSoBan, MAHOPDONG) VALUES (N'0', N'33847', '9', 1020992, '3')
INSERT dbo.ChiNhanh(MACHINHANH, MaDoanhNghiep, DiaChi, DoanhSoBan, MAHOPDONG) VALUES (N'2', N'67586', '7', 1732447, '2')
INSERT dbo.ChiNhanh(MACHINHANH, MaDoanhNghiep, DiaChi, DoanhSoBan, MAHOPDONG) VALUES (N'4', N'23248', '4', 226077, '5')
INSERT dbo.ChiNhanh(MACHINHANH, MaDoanhNghiep, DiaChi, DoanhSoBan, MAHOPDONG) VALUES (N'7', N'49858', '1', 1197015, '0')
INSERT dbo.ChiNhanh(MACHINHANH, MaDoanhNghiep, DiaChi, DoanhSoBan, MAHOPDONG) VALUES (N'6', N'03317', '6', 741869, '5')
INSERT dbo.ChiNhanh(MACHINHANH, MaDoanhNghiep, DiaChi, DoanhSoBan, MAHOPDONG) VALUES (N'3', N'00216', '5', 1668533, '7')
GO

--
-- Inserting data into table dbo.DonHang
--
INSERT dbo.DonHang(MaDH, PhiVanChuyen, TinhTrang, HinhThucThanhToan, PhiSanPham, NgayDat, DiaChiGiao, MACHINHANH, MaDoanhNghiep, MaKH, MaTX) VALUES (N'2', 572.3856, 0, 0, 54.7872, '2020-01-01 01:51:14.000', 'An Dương Vương', '7', '49858', '0', '7')
INSERT dbo.DonHang(MaDH, PhiVanChuyen, TinhTrang, HinhThucThanhToan, PhiSanPham, NgayDat, DiaChiGiao, MACHINHANH, MaDoanhNghiep, MaKH, MaTX) VALUES (N'0', 48.6747, 1, 1, 905.6995, '2020-01-01 00:00:18.000', 'Cách Mạng Tháng 8', '6', '03317', '3', '0')
INSERT dbo.DonHang(MaDH, PhiVanChuyen, TinhTrang, HinhThucThanhToan, PhiSanPham, NgayDat, DiaChiGiao, MACHINHANH, MaDoanhNghiep, MaKH, MaTX) VALUES (N'8', 448.7348, 0, 1, 662.7319, '2021-07-20 10:09:28.000', 'Âu Cơ', '2', '67586', '9', '8')
INSERT dbo.DonHang(MaDH, PhiVanChuyen, TinhTrang, HinhThucThanhToan, PhiSanPham, NgayDat, DiaChiGiao, MACHINHANH, MaDoanhNghiep, MaKH, MaTX) VALUES (N'9', 889.0489, 1, 0, 462.9004, '2021-05-01 13:59:18.000', 'Lê Lợi', '9', '88873', '9', '4')
INSERT dbo.DonHang(MaDH, PhiVanChuyen, TinhTrang, HinhThucThanhToan, PhiSanPham, NgayDat, DiaChiGiao, MACHINHANH, MaDoanhNghiep, MaKH, MaTX) VALUES (N'3', 103.4875, 2, 1, 241.8506, '2020-04-22 16:37:05.000', 'Lý Chính Thắng', '1', '38549', '8', '8')
INSERT dbo.DonHang(MaDH, PhiVanChuyen, TinhTrang, HinhThucThanhToan, PhiSanPham, NgayDat, DiaChiGiao, MACHINHANH, MaDoanhNghiep, MaKH, MaTX) VALUES (N'1', 711.2494, 2, 1, 159.9552, '2021-12-06 09:23:51.000', 'Trần Hưng Đạo', '2', '67586', '6', '4')
INSERT dbo.DonHang(MaDH, PhiVanChuyen, TinhTrang, HinhThucThanhToan, PhiSanPham, NgayDat, DiaChiGiao, MACHINHANH, MaDoanhNghiep, MaKH, MaTX) VALUES (N'6', 966.3188, 0, 0, 890.5346, '2020-01-01 00:00:44.000', 'Nguyễn Văn Cừ', '4', '23248', '7', '4')
INSERT dbo.DonHang(MaDH, PhiVanChuyen, TinhTrang, HinhThucThanhToan, PhiSanPham, NgayDat, DiaChiGiao, MACHINHANH, MaDoanhNghiep, MaKH, MaTX) VALUES (N'7', 30.0782, 1, 1, 7.0535, '2020-02-13 17:40:14.000', 'Hùng Vương', '7', '49858', '6', '2')
INSERT dbo.DonHang(MaDH, PhiVanChuyen, TinhTrang, HinhThucThanhToan, PhiSanPham, NgayDat, DiaChiGiao, MACHINHANH, MaDoanhNghiep, MaKH, MaTX) VALUES (N'5', 277.3224, 1, 1, 516.7596, '2021-11-10 19:35:51.000', 'Nguyễn Trãi', '6', '03317', '3', '4')
GO

--
-- Inserting data into table dbo.CHINHANH_SP
--
INSERT dbo.CHINHANH_SP(MASP, MACHINHANH, MADOANHNGHIEP) VALUES (N'2', N'2', N'67586')
INSERT dbo.CHINHANH_SP(MASP, MACHINHANH, MADOANHNGHIEP) VALUES (N'7', N'1', N'38549')
INSERT dbo.CHINHANH_SP(MASP, MACHINHANH, MADOANHNGHIEP) VALUES (N'3', N'4', N'23248')
INSERT dbo.CHINHANH_SP(MASP, MACHINHANH, MADOANHNGHIEP) VALUES (N'8', N'8', N'43757')
INSERT dbo.CHINHANH_SP(MASP, MACHINHANH, MADOANHNGHIEP) VALUES (N'4', N'7', N'49858')
INSERT dbo.CHINHANH_SP(MASP, MACHINHANH, MADOANHNGHIEP) VALUES (N'0', N'9', N'88873')
INSERT dbo.CHINHANH_SP(MASP, MACHINHANH, MADOANHNGHIEP) VALUES (N'1', N'6', N'03317')
INSERT dbo.CHINHANH_SP(MASP, MACHINHANH, MADOANHNGHIEP) VALUES (N'6', N'0', N'33847')
INSERT dbo.CHINHANH_SP(MASP, MACHINHANH, MADOANHNGHIEP) VALUES (N'9', N'3', N'00216')
GO

--
-- Inserting data into table dbo.DH_KH
--
INSERT dbo.DH_KH(MaDH, MaKH) VALUES (N'3', N'6')
INSERT dbo.DH_KH(MaDH, MaKH) VALUES (N'2', N'0')
INSERT dbo.DH_KH(MaDH, MaKH) VALUES (N'1', N'3')
INSERT dbo.DH_KH(MaDH, MaKH) VALUES (N'0', N'9')
INSERT dbo.DH_KH(MaDH, MaKH) VALUES (N'6', N'8')
INSERT dbo.DH_KH(MaDH, MaKH) VALUES (N'8', N'7')
INSERT dbo.DH_KH(MaDH, MaKH) VALUES (N'7', N'1')
INSERT dbo.DH_KH(MaDH, MaKH) VALUES (N'9', N'5')
INSERT dbo.DH_KH(MaDH, MaKH) VALUES (N'5', N'2')
GO

--
-- Inserting data into table dbo.DONHANG_SP
--
INSERT dbo.DONHANG_SP(MASP, MADH, SLSP) VALUES (N'2', N'3', 1790730303)
INSERT dbo.DONHANG_SP(MASP, MADH, SLSP) VALUES (N'7', N'2', 135516053)
INSERT dbo.DONHANG_SP(MASP, MADH, SLSP) VALUES (N'3', N'1', 1494618929)
INSERT dbo.DONHANG_SP(MASP, MADH, SLSP) VALUES (N'8', N'0', 1280397189)
INSERT dbo.DONHANG_SP(MASP, MADH, SLSP) VALUES (N'4', N'6', 1249115919)
INSERT dbo.DONHANG_SP(MASP, MADH, SLSP) VALUES (N'0', N'8', 782998059)
INSERT dbo.DONHANG_SP(MASP, MADH, SLSP) VALUES (N'1', N'7', 1947595277)
INSERT dbo.DONHANG_SP(MASP, MADH, SLSP) VALUES (N'6', N'9', 320187511)
INSERT dbo.DONHANG_SP(MASP, MADH, SLSP) VALUES (N'9', N'5', 1231795845)
GO

--
-- Inserting data into table dbo.TKDoanhNghiep
--
INSERT dbo.TKDoanhNghiep(ID, mk, trangthai, MADOANHNGHIEP) VALUES (N'DN92939', '09339', 0, '88873')
INSERT dbo.TKDoanhNghiep(ID, mk, trangthai, MADOANHNGHIEP) VALUES (N'DN41888', '92245', 1, '38549')
INSERT dbo.TKDoanhNghiep(ID, mk, trangthai, MADOANHNGHIEP) VALUES (N'DN34515', '69058', 0, '88873')
INSERT dbo.TKDoanhNghiep(ID, mk, trangthai, MADOANHNGHIEP) VALUES (N'DN32098', '42320', 1, '88873')
INSERT dbo.TKDoanhNghiep(ID, mk, trangthai, MADOANHNGHIEP) VALUES (N'DN63118', '98492', 1, '03317')
INSERT dbo.TKDoanhNghiep(ID, mk, trangthai, MADOANHNGHIEP) VALUES (N'DN86271', '74721', 1, '03317')
INSERT dbo.TKDoanhNghiep(ID, mk, trangthai, MADOANHNGHIEP) VALUES (N'DN91892', '11599', 1, '38549')
INSERT dbo.TKDoanhNghiep(ID, mk, trangthai, MADOANHNGHIEP) VALUES (N'DN45289', '18927', 0, '33847')
INSERT dbo.TKDoanhNghiep(ID, mk, trangthai, MADOANHNGHIEP) VALUES (N'DN74818', '79582', 0, '33847')
GO

--
-- Inserting data into table dbo.TKKhachHang
--
INSERT dbo.TKKhachHang(ID, MK, TrangThai, MaKH) VALUES (N'KH79998', '48799', 0, '6')
INSERT dbo.TKKhachHang(ID, MK, TrangThai, MaKH) VALUES (N'KH36614', '34366', 0, '1')
INSERT dbo.TKKhachHang(ID, MK, TrangThai, MaKH) VALUES (N'KH79236', '14425', 1, '3')
INSERT dbo.TKKhachHang(ID, MK, TrangThai, MaKH) VALUES (N'KH62807', '22273', 1, '1')
INSERT dbo.TKKhachHang(ID, MK, TrangThai, MaKH) VALUES (N'KH11848', '90535', 1, '6')
INSERT dbo.TKKhachHang(ID, MK, TrangThai, MaKH) VALUES (N'KH33096', '59640', 1, '3')
INSERT dbo.TKKhachHang(ID, MK, TrangThai, MaKH) VALUES (N'KH74398', '58582', 0, '8')
INSERT dbo.TKKhachHang(ID, MK, TrangThai, MaKH) VALUES (N'KH21728', '83980', 1, '7')
INSERT dbo.TKKhachHang(ID, MK, TrangThai, MaKH) VALUES (N'KH02679', '63821', 0, '2')
GO

--
-- Inserting data into table dbo.TKNHANVIEN
--
INSERT dbo.TKNHANVIEN(ID, MK, TRANGTHAI, MANV) VALUES (N'NV15997', 'L88584PU918W', 1, '2')
INSERT dbo.TKNHANVIEN(ID, MK, TRANGTHAI, MANV) VALUES (N'NV81255', 'J9UJ56', 1, '4')
INSERT dbo.TKNHANVIEN(ID, MK, TRANGTHAI, MANV) VALUES (N'NV05951', 'KK1ABM63', 1, '9')
INSERT dbo.TKNHANVIEN(ID, MK, TRANGTHAI, MANV) VALUES (N'NV47635', '087P81WK0LL55QX', 0, '8')
INSERT dbo.TKNHANVIEN(ID, MK, TRANGTHAI, MANV) VALUES (N'NV15244', '812C8Y1M6HRA3OY5JVLUJB0D', 0, '5')
INSERT dbo.TKNHANVIEN(ID, MK, TRANGTHAI, MANV) VALUES (N'NV89072', '46B42VX385IN88SL0T4054T73HJB1T662967962FOY1QDLK276', 0, '2')
INSERT dbo.TKNHANVIEN(ID, MK, TRANGTHAI, MANV) VALUES (N'NV13649', 'L8T91V7723O13D', 0, '4')
INSERT dbo.TKNHANVIEN(ID, MK, TRANGTHAI, MANV) VALUES (N'NV76535', 'I1LPB', 0, '6')
INSERT dbo.TKNHANVIEN(ID, MK, TRANGTHAI, MANV) VALUES (N'NV45026', '5Z3922R3U5UXZA1N6WM48274A6F08', 1, '0')
GO

--
-- Inserting data into table dbo.TKTAIXE
--
INSERT dbo.TKTAIXE(ID, MK, TRANGTHAI, THIENTHECHAN, MATX) VALUES (N'TX64666', 'C03P0182WY9', 0, 1, '6')
INSERT dbo.TKTAIXE(ID, MK, TRANGTHAI, THIENTHECHAN, MATX) VALUES (N'TX38809', '5J5827BT799O7', 1, 1, '1')
INSERT dbo.TKTAIXE(ID, MK, TRANGTHAI, THIENTHECHAN, MATX) VALUES (N'TX18592', '1JD1L66', 0, 1, '2')
INSERT dbo.TKTAIXE(ID, MK, TRANGTHAI, THIENTHECHAN, MATX) VALUES (N'TX91003', '71VQ', 1, 1, '1')
INSERT dbo.TKTAIXE(ID, MK, TRANGTHAI, THIENTHECHAN, MATX) VALUES (N'TX98003', 'O0I0K4O', 1, 1, '1')
INSERT dbo.TKTAIXE(ID, MK, TRANGTHAI, THIENTHECHAN, MATX) VALUES (N'TX53088', 'HT003433UT783R5HIC408Z1', 1, 1, '5')
INSERT dbo.TKTAIXE(ID, MK, TRANGTHAI, THIENTHECHAN, MATX) VALUES (N'TX08621', '4I10A1K7LK3V61SC2C602638X6XW2G9FC3CNUXXXJMR0293994', 0, 0, '8')
INSERT dbo.TKTAIXE(ID, MK, TRANGTHAI, THIENTHECHAN, MATX) VALUES (N'TX08582', 'DC50F996IA02H2MXU53376PL62C73RUX642S870', 0, 1, '4')
INSERT dbo.TKTAIXE(ID, MK, TRANGTHAI, THIENTHECHAN, MATX) VALUES (N'TX55933', 'LA86RSKY1N', 1, 1, '1')
GO

--
-- Inserting data into table dbo.TX_DH
--
INSERT dbo.TX_DH(MaDH, MaTX) VALUES (N'3', N'8')
INSERT dbo.TX_DH(MaDH, MaTX) VALUES (N'2', N'4')
INSERT dbo.TX_DH(MaDH, MaTX) VALUES (N'1', N'5')
INSERT dbo.TX_DH(MaDH, MaTX) VALUES (N'0', N'1')
INSERT dbo.TX_DH(MaDH, MaTX) VALUES (N'6', N'2')
INSERT dbo.TX_DH(MaDH, MaTX) VALUES (N'8', N'7')
INSERT dbo.TX_DH(MaDH, MaTX) VALUES (N'7', N'9')
INSERT dbo.TX_DH(MaDH, MaTX) VALUES (N'9', N'0')
INSERT dbo.TX_DH(MaDH, MaTX) VALUES (N'5', N'6')
GO

--
-- Set NOEXEC to off
--

SET NOEXEC OFF
GO