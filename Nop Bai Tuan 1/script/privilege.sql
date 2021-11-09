use master
go

use Nhom18_DoAnThucHanh_19HTT2
GO

CREATE ROLE roleKH
CREATE ROLE roleDT
CREATE ROLE roleNV
CREATE ROLE roleTX
CREATE ROLE roleAD

--Tạo tài khoản đăng nhập vào database
create login nv with password='nv'
create login dt with password='dt'
create login kh with password='kh'
create login tx with password='tx'
create login ad with password='ad'

--Tạo các user tương ứng cho tài khoản đăng nhập
create user userNV for login nv
create user userDT for login dt
create user userKH for login kh
create user userTX for login tx
create user userAD for login ad

--Phân quyền
--Phân quyền cho role DT
grant select on TKdoanhnghiep to roleDT
grant select on DoanhNghiep to roleDT
grant select on HopDong to roleDT
grant select, insert, delete, update on SanPham to roleDT
grant select, insert, delete, update on CHINHANH_SP to roleDT
grant select on CHINHANH to roleDT
grant select, update on DonHang to roleDT

--Phân quyền cho role KH
grant select on KhachHang to roleKH
grant select on DoanhNghiep to roleKH
grant select on SanPham to roleKH
grant select on ChiNhanh_SP to roleKH
grant select, insert on DonHang to roleKH
grant select on DOANHNGHIEP(LOAIHANG, DIACHIKINHDOANH, TENDOANHNGHIEP, EMAIL) TO roleKH

--Phân quyền cho role TX
grant select on TaiXe to roleTX
grant select on DonHang to roleTX
grant select on CHINHANH to roleTX
grant update on DonHang(TinhTrang) to roleTX

--Phân quyền cho role NV
grant select on HopDong to roleNV
grant select on NhanVien to roleNV
grant select on TKNhanVien to roleNV
grant update on TKNhanVien(mk) to roleNV


--Add các role vào user 
EXEC SP_ADDROLEMEMBER 'roleKH' ,'userKH'
EXEC SP_ADDROLEMEMBER 'roleNV' ,'userNV'
EXEC SP_ADDROLEMEMBER 'roleDT' ,'userDT'
EXEC SP_ADDROLEMEMBER 'roleTX' ,'userTX'
EXEC SP_ADDROLEMEMBER 'Db_owner' ,'userAD' -- cap quyen so huu db cho userAD
