Use TMP
go

CREATE TABLE SANPHAM(
	MASP VARCHAR(50) NOT NULL,
	TENSP VARCHAR(100) NOT NULL,
	GIA SMALLMONEY NOT NULL,
	CONSTRAINT PK_SANPHAM PRIMARY KEY(MASP)
);
GO


CREATE TABLE CHINHANH_SP(
	MASP VARCHAR(50) NOT NULL,
	MACHINHANH VARCHAR(5) NOT NULL,
	MADOANHNGHIEP VARCHAR(50) NOT NULL,
	CONSTRAINT PK_CHINHANH_SP PRIMARY KEY(MASP, MACHINHANH, MADOANHNGHIEP)
);
GO					

CREATE TABLE DONHANG_SP(
	MASP VARCHAR(50) NOT NULL,
	MADH VARCHAR(50) NOT NULL,
	CONSTRAINT PK_DONHANG_SP PRIMARY KEY(MASP, MADH)
);
GO

CREATE TABLE TKTAIXE(
	ID VARCHAR(50) NOT NULL,
	MK VARCHAR(50) NOT NULL,
	TRANGTHAI INT CHECK (TRANGTHAI IN (0, 1)),
	CONSTRAINT PK_TKTAIXE PRIMARY KEY(ID)
);
GO

CREATE TABLE TAIXE(
	MATK VARCHAR(50) NOT NULL,
	HOTEN VARCHAR(100) NOT NULL,
	DIACHI VARCHAR(50)NOT NULL,
	EMAIL VARCHAR(50) NOT NULL,
	BIENSOXE VARCHAR(50) NOT NULL,
	TKNH VARCHAR(50) NOT NULL,
	KHUVUCHD VARCHAR(50) NOT NULL,
	CONSTRAINT PK_TAIXE PRIMARY KEY(MATK)
);
GO