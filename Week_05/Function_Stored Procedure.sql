-- 21130601 - Nguyen Long Hoang An

--C. BÀI TẠP STORED PROCEDURE
use QLHocVien
--1. Cho biết danh sách các giáo viên được phân công giảng dạy môn “Khai thác dữ liệu”.
create proc DS_giaovien
as begin
	select distinct dbo.GIAOVIEN.TenGV, dbo.GIAOVIEN.MaGV from dbo.GIAOVIEN
	join dbo.PHANCONG on dbo.GIAOVIEN.MaGV = dbo.PHANCONG.MaGV
	join dbo.MONHOC on dbo.MONHOC.MaMonHoc = dbo.PHANCONG.MaMH
	where dbo.MONHOC.TenMonHoc = N'Khai thác dữ liệu';
end
exec DS_giaovien

drop proc DS_giaovien


--2. Nhận vào họ tên một giáo viên, cho biết danh sách tên các môn học mà giáo viên này đã được phân công giảng dạy.
create proc DS_monhoc @TenGV nvarchar(255)
as begin
	select distinct dbo.MONHOC.TenMonHoc from dbo.GIAOVIEN
	join dbo.PHANCONG on dbo.GIAOVIEN.MaGV = dbo.PHANCONG.MaGV
	join dbo.MONHOC on dbo.MONHOC.MaMonHoc = dbo.PHANCONG.MaMH
	where dbo.GIAOVIEN.TenGV = @TenGV;
end
exec DS_monhoc N'Trần Anh Dũng'

drop proc DS_monhoc


--3. Nhận vào họ tên một giáo viên, đếm số môn mà giáo viên này có khả năng giảng dạy. Xuất ra dưới dạng tham số output và in ra kết quả.
create proc DS_soluongmonhoc @TenGV nvarchar(255), @soluongMH int output
as begin
	select @soluongMH = count(distinct dbo.MONHOC.MaMonHoc) from dbo.GIAOVIEN
	join dbo.PHANCONG on dbo.GIAOVIEN.MaGV = dbo.PHANCONG.MaGV
	join dbo.MONHOC on dbo.MONHOC.MaMonHoc = dbo.PHANCONG.MaMH
	where dbo.GIAOVIEN.TenGV = @TenGV;
end

declare @soluongmonhoc int;
exec DS_soluongmonhoc N'Trần Anh Dũng', @soluongMH = @soluongmonhoc output;
print @soluongmonhoc;

drop proc DS_soluongmonhoc

--4. Nhận vào một tên môn học, cho biết có bao nhiêu học viên đã từng thi đậu môn này. Xuất ra dưới dạng tham số output và in ra kết quả.
create proc DS_thidau @TenMH nvarchar(255), @soluongHV int output
as begin
	select @soluongHV = count(distinct dbo.KETQUA.MaHV) from dbo.KETQUA
	join dbo.MONHOC on dbo.MONHOC.MaMonHoc = dbo.KETQUA.MaMonHoc
	where dbo.MONHOC.TenMonHoc = @TenMH and dbo.KETQUA.Diem >= 5.0;
end

declare @soluonghocvien int;
exec DS_thidau N'Phân tích thiết kế hệ thống thông tin', @soluongHV = @soluonghocvien output;
print @soluonghocvien;

drop proc DS_thidau


--D. BÀI TẬP FUNCTION
use QLHocVien
--1. Nhập vào tên một học viên cho biết số môn học viên này đã từng thi rớt.
create function SoMonThiRot (@TenHV nvarchar(255))
returns int 
as begin
	declare @SoMonHoc int;

	-- Tinh so mon thi rot
	select @SoMonHoc = count(distinct dbo.KETQUA.MaMonHoc) from dbo.KETQUA
	join dbo.HOCVIEN on dbo.KETQUA.MaHV = dbo.HOCVIEN.MaHocVien
	where dbo.HOCVIEN.TenHocVien = @TenHV and dbo.KETQUA.Diem <= 4.0;
	
	return @SoMonHoc
end
select dbo.SoMonThiRot(N'Trần Trung Chính') as SoMonThiRot;

drop function SoMonThiRot


--2. Nhập vào một mã lớp, một tên giáo viên. Cho biết số môn mà giáo viên từng dạy cho lớp này.
create function SoMonDayHoc (@MaLop nvarchar(255), @TenGV nvarchar(255))
returns int
as begin
	declare @SoMonDay int;

	-- Tinh so mon day hoc
	select @SoMonDay = count(distinct dbo.PHANCONG.MaLop) from dbo.PHANCONG
	join dbo.LOPHOC on dbo.LOPHOC.MaLop = dbo.PHANCONG.MaLop
	join dbo.GIAOVIEN on dbo.GIAOVIEN.MaGV = dbo.PHANCONG.MaGV
	where dbo.GIAOVIEN.TenGV = @TenGV and dbo.LOPHOC.MaLop = @MaLop
	return @SoMonDay
end
select dbo.SoMonDayHoc (N'LH000004', N'Trương Tường Vi')

drop function SoMonDayHoc


--3. Nhập vào một mã học viên, cho biết điểm trung bình của học viên.
create function DiemTrungBinh (@MaHV nvarchar(255))
returns float
as begin
	declare @DiemTB float

	-- diem trung binh
	select @DiemTB = avg(dbo.KETQUA.Diem) from dbo.KETQUA
	join dbo.HOCVIEN on dbo.HOCVIEN.MaHocVien = dbo.KETQUA.MaHV
	where dbo.HOCVIEN.MaHocVien = @MaHV
	return @DiemTB
end

select dbo.DiemTrungBinh (N'HV000003')

drop function DiemTrungBinh

--4. Nhập vào một tên môn học, cho biết danh sách các học viên (mã học viên, tên học viên, ngày sinh) đã đậu môn này. Học viên đậu khi điểm lần thi sau cùng >= 5.
create function DanhSachHocVienDau (@TenMH nvarchar(255))
returns @DS table(MaHV nvarchar(255), HoTen nvarchar(255), NgaySinh date)
as begin
	insert into @DS select dbo.HOCVIEN.MaHocVien, dbo.HOCVIEN.TenHocVien, dbo.HOCVIEN.NgaySinh from dbo.HOCVIEN
	join dbo.KETQUA on dbo.HOCVIEN.MaHocVien = dbo.KETQUA.MaHV
	join dbo.MONHOC on dbo.MONHOC.MaMonHoc = dbo.KETQUA.MaMonHoc
	where dbo.MONHOC.TenMonHoc = @TenMH and dbo.KETQUA.Diem >= 5.0
	return
end
select * from dbo.DanhSachHocVienDau (N'Phân tích thiết kế hệ thống thông tin')

drop function DanhSachHocVienDau