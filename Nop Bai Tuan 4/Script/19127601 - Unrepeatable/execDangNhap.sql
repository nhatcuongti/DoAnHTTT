use Nhom18_DoAnThucHanh_19HTT2_1
Go
-- Tài khoản bị khoá (banned): 0
-- Tài khoản không bị khoá: 1

-- Khi tài khoản bị khoá trước đó (không đồng thời với giao tác đăng nhập) 
-- thì tài khoản sẽ không đăng nhập thành công 

-- Khi tài khoản không bị khoá thì sẽ đăng nhập thành công và hiển thị trạng thái là 1

SELECT * FROM TKNHANVIEN
UPDATE TKNHANVIEN
SET TRANGTHAI = 1


exec sp_DangNhapNhanVien 'NV81255', 'J9UJ56'
Go