-- Master database: Tạo Login
use master
go

-- Tạo Login Admin
if not exists (select * from sys.server_principals where name = 'Admin')
begin
    create login Admin with password = 'Admin@123',
        default_database = QuanLyChuyenDe
    print N'Login Admin created'
end
else
    print N'Login Admin already exists'
go

-- Tạo Login SinhVien (ví dụ: 21020001)
if not exists (select * from sys.server_principals where name = '21020001')
begin
    create login [21020001] with password = '21020001',
        default_database = QuanLyChuyenDe
    print N'Login SV 21020001 created'
end
else
    print N'Login SV 21020001 already exists'
go

-- QuanLyChuyenDe database: Tạo User và phân quyền
use QuanLyChuyenDe
go

-- Tạo User Admin và gán vai trò db_owner
if not exists (select * from sys.database_principals where name = 'Admin')
begin
    create user Admin for login Admin
    exec sp_addrolemember 'db_owner', 'Admin'
    print N'User Admin created and added to db_owner'
end
else
    print N'User Admin already exists'
go

-- Tạo Role SinhVien
if not exists (select * from sys.database_principals where name = 'SinhVien')
begin
    create role SinhVien
    print N'Role SinhVien created'
end
else
    print N'Role SinhVien already exists'
go

-- Tạo User SinhVien (21020001) và gán vào role SinhVien
if not exists (select * from sys.database_principals where name = '21020001')
begin
    create user [21020001] for login [21020001]
    exec sp_addrolemember 'SinhVien', '21020001'
    print N'User 21020001 created and added to SinhVien role'
end
else
    print N'User 21020001 already exists'
go

-- Phân quyền cho role SinhVien
-- Quyền xem thông tin cá nhân
grant execute on sp_XemThongTinCaNhan to SinhVien
grant execute on sp_XemDanhSachLopHocKhaDung to SinhVien
grant execute on sp_XemLichSuDangKy to SinhVien

-- Quyền đăng ký lớp học
grant execute on sp_DangKyLopHocMoi to SinhVien

-- Quyền xem dữ liệu bảng (chỉ đọc)
grant select on SinhVien to SinhVien
grant select on LopHoc to SinhVien
grant select on ChuyenDe to SinhVien
grant select on NganhHoc to SinhVien
grant select on DangKy to SinhVien

-- Từ chối quyền sửa đổi dữ liệu
deny insert, update, delete on SinhVien to SinhVien
deny insert, update, delete on LopHoc to SinhVien
deny insert, update, delete on ChuyenDe to SinhVien
deny insert, update, delete on NganhHoc to SinhVien
deny insert, update, delete on DangKy to SinhVien
go

-- Kiểm tra quyền của role SinhVien
select * from sys.database_permissions 
where grantee_principal_id = (select principal_id from sys.database_principals where name = 'SinhVien')
go