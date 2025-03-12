-- Kiem tra + xoa csdl neu co
use master
go

if exists (select * from sys.databases where name = 'QuanLyChuyenDe')
	begin
		drop database QuanLyChuyenDe
	end
go

-- Tao csdl QuanLyChuyenDe
create database QuanLyChuyenDe
-- Su dung csdl QuanLyChuyenDe 
use QuanLyChuyenDe
go



-- Table NganhHoc (1)
drop table if exists NganhHoc
go
create table NganhHoc (
	MaNganh varchar(10) not null Primary Key,
	TenNganh nvarchar(100) not null,
	SoCDBatBuoc int not null,
	TongSoSVTungHoc int default 0
);
go
-- Rang Buoc
alter table NganhHoc
add constraint CK_SoCDBatBuoc check (SoCDBatBuoc <= 8);

alter table NganhHoc
add constraint CK_MaNganh_Format check (MaNganh like '[A-Z][A-Z][A-Z]%' and len(MaNganh) between 3 and 10);	-- CNTT, KTMT, QTKD

alter table NganhHoc
add constraint UNQ_TenNganh unique (TenNganh);
go


-- Table ChuyenDe (2)
drop table if exists ChuyenDe
go
create table ChuyenDe (
	MaCD varchar(10) not null Primary Key,
	TenCD nvarchar(100) not null,
);
go
-- Rang Buoc
alter table ChuyenDe
add constraint CK_MaCD_Format check (MaCD like '[A-Z][A-Z][0-9][0-9]%'); --CN01, CN02, KT01, KT02

alter table ChuyenDe
add constraint UNQ_TenCD unique (TenCD);
go


-- Table SinhVien
drop table if exists SinhVien
go
create table SinhVien (
	MaSV varchar(10) not null Primary Key,
	HoSV varchar(10) not null,
	TenLotSV varchar(20) not null,
	TenSV varchar(10) not null,
	Phai varchar(3) not null,
	NgaySinh date not null,
	DiaChi nvarchar(100) not null,
	MaNganh varchar(10) not null,
	Foreign Key (MaNganh) references NganhHoc(MaNganh) on update cascade on delete no action -- (su dung trigger chuyen nganh khi nganh bi xoa)
);
go
-- Rang Buoc
alter table SinhVien
add constraint CK_MaSV_Format check (
	MaSV like '20[0-9][0-9][0-9][0-9][0-9][0-9]' or	-- 2002
	MaSV like '21[0-9][0-9][0-9][0-9][0-9][0-9]' or	-- 2003
	MaSV like '22[0-9][0-9][0-9][0-9][0-9][0-9]'	-- 2004
);
go

alter table SinhVien
add constraint CK_Phai check (Phai in ('Nam', 'Nu'));
go

alter table SinhVien
add constraint CK_NgaySinh check (NgaySinh <= getdate());
go


-- Table LopHoc
drop table if exists LopHoc
go
create table LopHoc (
	MaLop varchar(10) not null Primary Key,
	MaCD varchar(10) not null,
	HocKy varchar(10) not null,
	NamHoc varchar(10) not null,
	SoSVToiDa int not null,
	Foreign Key (MaCD) references ChuyenDe(MaCD) on update cascade on delete cascade
);
go
-- Rang Buoc
alter table LopHoc
add constraint CK_MaLop_Format check (MaLop like '[A-Z][A-Z][0-9][0-9]%'); --CN001, CN002, KT001, KT002
go

alter table LopHoc
add constraint CK_HocKy check (HocKy in ('HK1', 'HK2'));
go

alter table LopHoc
add constraint CK_SoSVToiDa check (SoSVToiDa <= 50);
go


-- Table DangKy
drop table if exists DangKy
go
create table DangKy (
	MaDK varchar(10) not null Primary Key,
	MaSV varchar(10) not null,
	MaLop varchar(10) not null,
	Foreign Key (MaSV) references SinhVien(MaSV) on update no action on delete no action,
	Foreign Key (MaLop) references LopHoc(MaLop) on update cascade on delete no action
);
go


-- Table NganhHoc_ChuyenDe
drop table if exists NganhHoc_ChuyenDe
go
create table NganhHoc_ChuyenDe (
	MaNganh varchar(10) not null,
	MaCD varchar(10) not null,
	Primary Key (MaNganh, MaCD),
	Foreign Key (MaNganh) references NganhHoc(MaNganh) on update cascade on delete cascade,
	Foreign Key (MaCD) references ChuyenDe(MaCD) on update cascade on delete cascade
);
go


-- (Options) Kiem tra cac bang da tao
select * from information_schema.tables where table_catalog = 'QuanLyChuyenDe'
go
-- (Options) Kiem tra cac khoa ngoai
select * from information_schema.table_constraints where constraint_type = 'FOREIGN KEY'
go
-- (Options) Kiem tra cac chi muc
select * from sys.indexes where object_id in (select object_id from sys.tables where name in ('NganhHoc', 'ChuyenDe', 'SinhVien', 'LopMo', 'DangKy', 'NganhHoc_ChuyenDe'))
go


-- Trigger: Cap nhat TongSoSVTungHoc cua NganhHoc (Bang DangKy - After Insert)
drop trigger if exists Update_TongSoSVTungHoc
go
create trigger Update_TongSoSVTungHoc
on DangKy
after insert
as
begin
	declare @MaSV varchar(10), @MaNganh varchar(10);
	-- Lay thong tin tu bang inserted
	select @MaSV = MaSV from inserted
	select @MaNganh = MaNganh from SinhVien where MaSV = @MaSV
	
	-- Neu SV chua tung dang ky truoc do
	if not exists(
		select 1 from DangKy
		join SinhVien on DangKy.MaSV = SinhVien.MaSV
		where SinhVien.MaSV = @MaSV and DangKy.MaDK != (select MaDK from inserted)
	)
	begin
		-- Cap nhat TongSoSVTungHoc cua NganhHoc
		update NganhHoc
		set TongSoSVTungHoc = TongSoSVTungHoc + 1
		where MaNganh = @MaNganh
	end
end;


-- Trigger: Kiem tra toi da 3 chuyen de moi hoc ky (Bang DangKy - After Insert)
drop trigger if exists Check_Max3_ChuyenDe
go
create trigger Check_Max3_ChuyenDe
on DangKy
after insert
as
begin
	declare @MaSV varchar(10), @MaLop varchar(10), @HocKy varchar(10), @NamHoc varchar(10), @Count int;
	-- Lay thong tin tu bang inserted
	select @MaSV = MaSV, @MaLop = MaLop from inserted
	select @HocKy = HocKy, @NamHoc = NamHoc from LopHoc where MaLop = @MaLop

	-- Dem so luong chuyen de SV da dang ky trong hoc ky nay
	select @Count = count(*) from DangKy
	join LopHoc on DangKy.MaLop = LopHoc.MaLop
	where DangKy.MaSV = @MaSV and LopHoc.HocKy = @HocKy and LopHoc.NamHoc = @NamHoc

	-- Neu SV da dang ky toi da 3 chuyen de trong hoc ky nay
	if @Count >= 3
	begin
		raiserror('Sinh vien khong duoc dang ky toi da 3 chuyen de trong hoc ky nay', 16, 1)
		rollback transaction
	end
end;


-- Trigger: Kiem tra chuyen de thuoc nganh cua SinhVien (Bang DangKy - After Insert)
drop trigger if exists Check_ChuyenDe_Nganh
go
create trigger Check_ChuyenDe_Nganh
on DangKy
after insert
as
begin
	declare @MaSV varchar(10), @MaLop varchar(10), @MaCD varchar(10), @MaNganh varchar(10);
	-- Lay thong tin tu bang inserted
	select @MaSV = MaSV, @MaLop = MaLop from inserted
	select @MaCD = MaCD from LopHoc where MaLop = @MaLop
	select @MaNganh = MaNganh from SinhVien where MaSV = @MaSV

	-- Neu chuyen de khong thuoc nganh cua SV
	if not exists(
		select 1 from NganhHoc_ChuyenDe
		where MaNganh = @MaNganh and MaCD = @MaCD
	)
	begin
		raiserror('Chuyen de khong thuoc nganh cua sinh vien', 16, 1)
		rollback transaction
	end
end;


-- Trigger: Kiem tra so luong sinh vien dang ky khong vuot qua so luong toi da cua lop (Bang DangKy - After Insert)
drop trigger if exists Check_SoLuongToiDa
go
create trigger Check_SoLuongToiDa
on DangKy
after insert
as
begin
	declare @MaLop varchar(10), @SoSVToiDa int, @SoLuongDK int
	-- Lay thong tin tu bang inserted
	select @MaLop = MaLop from inserted
	select @SoSVToiDa = SoSVToiDa from LopHoc where MaLop = @MaLop

	-- Dem so luong sinh vien dang ky cua lop
	select @SoLuongDK = count(*) from DangKy where MaLop = @MaLop

	-- Neu so luong sinh vien dang ky vuot qua so luong toi da cua lop
	if @SoLuongDK > @SoSVToiDa
	begin
		raiserror('So luong sinh vien dang ky vuot qua so luong toi da cua lop', 16, 1)
		rollback transaction
	end
end;


-- Trigger: Kiem tra toi da 8 chuyen de moi nganh (Bang NganhHoc_ChuyenDe - After Insert)
drop trigger if exists Check_Max8_NganhHoc_ChuyenDe
go
create trigger Check_Max8_NganhHoc_ChuyenDe
on NganhHoc_ChuyenDe
after insert
as
begin
	declare @MaNganh varchar(10), @Count int;
	-- Lay thong tin tu bang inserted
	select @MaNganh = MaNganh from inserted
	
	-- Dem so luong chuyen de thuoc nganh nay
	select @Count = count(*) from NganhHoc_ChuyenDe where MaNganh = @MaNganh

	-- Neu so luong chuyen de thuoc nganh nay vuot qua 8
	if @Count > 8
	begin
		raiserror('So luong chuyen de thuoc nganh nay vuot qua 8 chuyen de', 16, 1)
		rollback transaction
	end
end;


-- Trigger: Xoa nganh trong NganhHoc (Bang NganhHoc - Instead Of Delete)
drop trigger if exists Delete_NganhHoc
go
create trigger Delete_NganhHoc
on NganhHoc
instead of delete
as
begin
	declare @MaNganh varchar(10)
	select @MaNganh = MaNganh from deleted

	-- chuyen nganh cua sinh vien ve nganh khac (CNTT)
	update SinhVien
	set MaNganh = 'CNTT'
	where MaNganh = @MaNganh

	-- Xoa du lieu trong NganhHoc
	delete from NganhHoc_ChuyenDe where MaNganh = @MaNganh

	-- Xoa nganh
	delete from NganhHoc where MaNganh = @MaNganh
end;


-- Truy van du lieu Select: Xem thong tin sinh vien theo nganh hoc CNTT
select SinhVien.MaSV, SinhVien.HoSV + ' ' + SinhVien.TenLotSV + ' ' + SinhVien.TenSV as HoTen, SinhVien.Phai, SinhVien.NgaySinh, SinhVien.DiaChi, NganhHoc.TenNganh
from SinhVien
join NganhHoc on SinhVien.MaNganh = NganhHoc.MaNganh
where NganhHoc.MaNganh = 'CNTT';

-- Truy van du lieu Select: Lay danh sach lop hoc mo trong hoc ky 1 nam 2023-2024
select LopHoc.MaLop, ChuyenDe.TenCD, LopHoc.SoSVToiDa
from LopHoc
join ChuyenDe on LopHoc.MaCD = ChuyenDe.MaCD
where LopHoc.HocKy = 'HK1' and LopHoc.NamHoc = '2023-2024';

-- Truy van du lieu Select: Lay danh sach sinh vien dang ky chuyen de "Tri Tue Nhan Tao" (AI01)
select SinhVien.MaSV, SinhVien.HoSV + ' ' + SinhVien.TenLotSV + ' ' + SinhVien.TenSV as HoTen, NganhHoc.TenNganh, LopHoc.MaLop, ChuyenDe.TenCD
from SinhVien
join DangKy on SinhVien.MaSV = DangKy.MaSV
join LopHoc on DangKy.MaLop = LopHoc.MaLop
join ChuyenDe on LopHoc.MaCD = ChuyenDe.MaCD
join NganhHoc on SinhVien.MaNganh = NganhHoc.MaNganh
where ChuyenDe.MaCD = 'AI01';

-- Truy van du lieu Select: Lay danh sach chuyen de bat buoc cua nganh KHDL
select NganhHoc.TenNganh, ChuyenDe.TenCD
from NganhHoc
join NganhHoc_ChuyenDe on NganhHoc.MaNganh = NganhHoc_ChuyenDe.MaNganh
join ChuyenDe on NganhHoc_ChuyenDe.MaCD = ChuyenDe.MaCD
where NganhHoc.TenNganh = 'Khoa Hoc Du Lieu'


-- Truy van gom nhom Group By/Having: Dem so sinh vien theo tung nganh hoc
select NganhHoc.TenNganh, count(SinhVien.MaSV) as SoLuongSV
from NganhHoc
join SinhVien on NganhHoc.MaNganh = SinhVien.MaNganh
group by NganhHoc.TenNganh having count(SinhVien.MaSV) > 0;

-- Truy van du lieu dem so luong dang ky theo lop co tren 2 sinh vien
select LopHoc.MaLop, count(DangKy.MaDK) as SoLuongDK
from LopHoc
join ChuyenDe on LopHoc.MaCD = ChuyenDe.MaCD
join DangKy on LopHoc.MaLop = DangKy.MaLop
group by LopHoc.MaLop, ChuyenDe.TenCD having count(DangKy.MaDK) > 2;



-- Chuc nang cho toan bo phan he:
-- 1. Xem danh sach nganh hoc
create proc sp_XemDanhSachNganhHoc
as
begin
	select * from NganhHoc
	order by MaNganh
end;
go
exec sp_XemDanhSachNganhHoc;

-- 2. Xem danh sach chuyen de
create proc sp_XemDanhSachChuyenDe
as
begin
	select * from ChuyenDe
	order by MaCD
end;
go
exec sp_XemDanhSachChuyenDe;

-- 3. Xem danh sach lop hoc
create proc sp_XemDanhSachLopHoc
as
begin
	select * from LopHoc
	order by MaLop
end;
go
exec sp_XemDanhSachLopHoc;

-- 4. Xem danh sach sinh vien
create proc sp_XemDanhSachSinhVien
as
begin
	select * from SinhVien
	order by MaSV
end;
go
exec sp_XemDanhSachSinhVien;

-- 5. Xem danh sach dang ky
create proc sp_XemDanhSachDangKy
as
begin
	select * from DangKy
	order by MaDK
end;
go
exec sp_XemDanhSachDangKy;

-- 6. Xem danh sach nganh hoc - chuyen de
create proc sp_XemDanhSachNganhHoc_ChuyenDe
as
begin
	select * from NganhHoc_ChuyenDe
	order by MaNganh, MaCD
end;
go
exec sp_XemDanhSachNganhHoc_ChuyenDe;



-- Phan he quan tri vien (Admin):
-- 1. Them nganh hoc moi
create proc sp_ThemNganhHoc
	@MaNganh varchar(10),
	@TenNganh nvarchar(100),
	@SoCDBatBuoc int
as
begin
	begin try
		insert into NganhHoc (MaNganh, TenNganh, SoCDBatBuoc, TongSoSVTungHoc)
		values (@MaNganh, @TenNganh, @SoCDBatBuoc, 0)
		print N'Them nganh hoc thanh cong'
	end try
	begin catch
		print N'Them nganh hoc that bai'
	end catch
end;
go
exec sp_ThemNganhHoc 'TKVM', N'Thiet Ke Vi Mach', 7;

-- 2. Them chuyen de moi
create proc sp_ThemChuyenDe
	@MaCD varchar(10),
	@TenCD nvarchar(100)
as
begin
	begin try
		insert into ChuyenDe values (@MaCD, @TenCD)
		print N'Them chuyen de thanh cong'
	end try
	begin catch
		print N'Them chuyen de that bai'
	end catch
end;
go
exec sp_ThemChuyenDe 'MT01', N'Kien Truc May Tinh';

-- 3. Them lop hoc moi
create proc sp_ThemLopHoc
	@MaLop varchar(10),
	@MaCD varchar(10),
	@HocKy varchar(10),
	@NamHoc varchar(10),
	@SoSVToiDa int
as
begin
	begin try
		insert into LopHoc (MaLop, MaCD, HocKy, NamHoc, SoSVToiDa)
		values (@MaLop, @MaCD, @HocKy, @NamHoc, @SoSVToiDa)
		print N'Them lop hoc thanh cong'
	end try
	begin catch
		print N'Them lop hoc that bai'
	end catch
end;
go
exec sp_ThemLopHoc 'MT01', 'MT01', 'HK1', '2024-2025', 30;

-- 4. Thu tuc dang ky lop hoc
create proc sp_DangKyLopHoc
	@MaSV varchar(10),
	@MaLop varchar(10)
as
begin
	begin try
		declare @MaDK varchar(10)
		select @MaDK = max(MaDK) from DangKy
		
		if @MaDK is null
			set @MaDK = 'DK001'
		else
			set @MaDK = 'DK' + right('000' + cast(cast(right(@MaDK, 3) as int) + 1 as varchar(3)), 3)

		insert into DangKy (MaDK, MaSV, MaLop)
		values (@MaDK, @MaSV, @MaLop)
		print N'Dang ky lop hoc thanh cong'
	end try
	begin catch
		print N'Dang ky lop hoc that bai'
	end catch
end;
go
exec sp_DangKyLopHoc '21020001', 'CN02';


-- 5. Thu tuc thong ke so luong sinh vien theo nganh hoc
create proc sp_ThongKeSoLuongSinhVienTheoNganhHoc
as
begin
	select NganhHoc.TenNganh, count(SinhVien.MaSV) as SoLuongSV
	from NganhHoc
	join SinhVien on NganhHoc.MaNganh = SinhVien.MaNganh
	group by NganhHoc.TenNganh having count(SinhVien.MaSV) >= 0
end;
go
exec sp_ThongKeSoLuongSinhVienTheoNganhHoc;


-- 6. Thu tuc thong ke dang ky theo lop hoc
create proc sp_ThongKeDangKyTheoLopHoc
as
begin
	select LopHoc.MaLop, count(DangKy.MaDK) as SoLuongDK
	from LopHoc
	join DangKy on LopHoc.MaLop = DangKy.MaLop
	left join ChuyenDe on LopHoc.MaCD = ChuyenDe.MaCD
	group by LopHoc.MaLop, ChuyenDe.TenCD order by SoLuongDK desc
end;
go
exec sp_ThongKeDangKyTheoLopHoc;



-- Phan he sinh vien:
-- 1. Xem thong tin ca nhan
create proc sp_XemThongTinCaNhan
	@MaSV varchar(10)
as
begin
	select * from SinhVien
	join NganhHoc on SinhVien.MaNganh = NganhHoc.MaNganh
	where MaSV = @MaSV
end;
go
exec sp_XemThongTinCaNhan '21020001';

-- 2. Xem danh sach lop hoc kha dung
create proc sp_XemDanhSachLopHocKhaDung
	@MaSV varchar(10)
as
begin
	select LopHoc.MaLop, ChuyenDe.TenCD, LopHoc.HocKy, LopHoc.NamHoc, LopHoc.SoSVToiDa, count(DangKy.MaDK) as SoLuongDK, LopHoc.SoSVToiDa - count(DangKy.MaDK) as ConTrong
	
