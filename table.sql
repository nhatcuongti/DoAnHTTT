CREATE TABLE DoanhNghiep(
  MaSoThue VARCHAR(50) NOT NULL,
  LoaiHang VARCHAR(100) NOT NULL,
  DiaChiKinhDoanh VARCHAR(500) NOT NULL,
  TenDoiTac VARCHAR(200) NOT NULL,
  NguoiDaiDien VARCHAR(50) NOT NULL,
  ThanhPho VARCHAR(50) NOT NULL,
  SoDT VARCHAR(15) NOT NULL,
  Email VARCHAR(50) NOT NULL,
  SLDonHang INT CHECK(SLDonHang >=0)
  PRIMARY KEY (MaSoThue)
  )

GO
CREATE TABLE HopDong(
  MaHD VARCHAR(50) NOT NULL,
  NguoiDaiDien VARCHAR(50) NOT NULL,
  SoChiNhanhDK INT CHECK (SoChiNhanhDK >=0) NOT NULL,
  HieuLuc INT CHECK(HieuLuc >=0) NOT NULL,
  PhanTramHH FLOAT CHECK (0 <PhanTramHH< 1 ) NOT NULL,
  NgayBatDau DATE NOT NULL,
  MaDoanhNghiep VARCHAR(50) NOT NULL
  PRIMARY KEY(MaHD)
  )

GO
CREATE TABLE TKDoanhNghiep(
  ID VARCHAR(50) NOT NULL,
  mk VARCHAR(50) NOT NULL,
  trangthai INT CHECK(0< trangthai< 2) NOT NULL,
  PRIMARY KEY(ID)
  )

GO
CREATE TABLE ChiNhanh(
  MaChiNhanh VARCHAR(5) NOT NULL,
  MaDoanhNghiep VARCHAR(50) NOT NULL,
  DiaChi VARCHAR(200) NOT NULL,
  DoanhSoBan MONEY,
  PRIMARY KEY(MaChiNhanh, MaDoanhNghiep)
  )
  create table KhachHang 
(
	MaKH 	varchar(50) not null,
	HoTen 	nvarchar(100),
	SDT 	varchar(10),
	DiaChi 	varchar(50),
	Email 	datetime,
	primary key (MaKH)	
)

create table TKKhachHang
(
	ID 	varchar(50) NOT NULL,
	MK nvarchar(30) NOT NULL,
	TrangThai int,
	MaKH varchar(50),
	primary key (ID)
)
create table DH_KH
(
	MaDH varchar(50) not null,
	MaKH varchar(50) not null,
	primary key (MaDH, MaKH)
)
create table TX_DH
(
	MaTX varchar(50) not null,
	MaDH varchar(50) not null,
	primary key (MaDH, MaTX)
)

create table DonHang
(
	MaDH varchar(50) not null,
	PhiVanChuyen  float,
	TinhTrang  int,
	HinhThucThanhToan  int,
	PhiSanPham  float,
	NgayDat Datetime,
	MaChiNhanh varchar(5) not NULL,
	MaDoanhNghiep varchar(50) not NULL,
	primary key(MaDH)
)
  
