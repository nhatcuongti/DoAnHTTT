﻿CREATE TABLE DoanhNghiep(
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
