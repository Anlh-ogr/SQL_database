use SmallWorks
go

-- 1. Tao cac kieu du lieu nguoi dung sau:
-- | name | schema | datatype | length | storage | allow null |
-- | Mota | dbo    | nvarchar | 40     | 50      | yes        |
-- | IDKH | dbo    | char     | 10     | 10      | no         |
-- | DT   | dbo    | char     | 12     | 12      | yes        |
create type dbo.Mota from nvarchar(40) null
create type dbo.IDKH from char(10) not null
create type dbo.DT from char(12) null

drop table Sales
create table Sales (
	Mota dbo.Mota,
	IDKH dbo.IDKH,
	DT dbo.DT)

-- 2. Tao cac bang theo cau truc sau:
-- | SanPham                   	  |					| HoaDon 					|
-- | -----------------------------|					| ------------------------- |
-- | Attribute name | Datatype 	  |					| Attribute name | Datatype |
-- | MaSp           | char(6)  	  |					| MaHD		     | char(10) |
-- | TenSp			| varchar(20) |					| NgayLap	     | date     |
-- | NgayNhap		| date	      |					| NgayGiao	     | date     |
-- | DVT			| char(10)	  |					| MaKH		     | IDKH		|
-- | SoLuongTon     | int		  |					| DienGiai	     | Mota		|
-- | DonGiaNhap     | money		  |
--													| ChiTietHD					|
-- | KhachHang                    |					| ------------------------- |
-- | ---------------------------- |					| Attribute name | Datatype |
-- | Attribute name | Datatype    |					| MaHD		     | char(10) |
-- | MaKH           | IDKH        |					| MaSp		     | char(6)  |
-- | TenKH          | nvarchar(30)|					| SoLuong	     | int		|
-- | DiaChi         | nvarchar(40)|
-- | DienThoai      | DT		  |
drop table SanPham
create table SanPham (
	MaSp char(6) not null,
	TenSp varchar(20),
	NgayNhap date,
	DVT char(10),
	SoLuongTon int,
	DonGiaNhap money)

drop table HoaDon
create table HoaDon (
	MaHD char(10) not null,
	NgayLap date,
	NgayGiao date,
	MaKH char(10) not null,
	DienGiai nvarchar(40))

drop table KhachHang
create table KhachHang (
	MaKH char(10) not null,
	TenKH nvarchar(30),
	DiaChi nvarchar(40),
	DienThoai char(12))

drop table ChiTietHD
create table ChiTietHD (
	MaHD char(10) not null,
	MaSp char(6) not null,
	SoLuong int)

-- 3. Trong Table HoaDon, sua cot DienGiai thanh nvarchar(100).
alter table HoaDon
alter column DienGiai nvarchar(100)
alter table Sales
alter column Mota nvarchar(100)

-- 4. Them vao bang SanPham cot TyLeHoaHong float
alter table SanPham
add TyLeHoaHong float

-- 5. Xoa cot NgayNhap trong bang SanPham
alter table SanPham
drop column NgayNhap

-- 6. Tao cac rang buoc khoa chinh va khoa ngoai cho cac bang tren
alter table Sales
add constraint PK_Sales_IDKH primary key (IDKH)
alter table Sales
add constraint UQ_Sales_Mota unique (Mota)

alter table SanPham
add constraint PK_SanPham_MaSp primary key (MaSp)

alter table HoaDon
add constraint PK_HoaDon_MaHD primary key (MaHD)
alter table HoaDon
add constraint FK_HoaDon_MaKH foreign key (MaKH) references Sales (IDKH)
alter table HoaDon
add constraint FK_HoaDon_DienGiai foreign key (DienGiai) references Sales (MoTa)

alter table KhachHang
add constraint PK_KhachHang_MaKH primary key (MaKH)
alter table KhachHang
add constraint FK_KhachHang_MaKh foreign key (MaKH) references Sales (IDKH)
alter table KhachHang
add constraint FK_KhachHang_DienThoai foreign key (DienThoai) references Sales (DT)

-- 7. Them vao bang HoaDon cac rang buoc sau:
-- -- NgayGiao >= NgayLap
-- -- MaHD gom 6 ky tu, 2 ky tu dau la chu, cac ky tu con lai la so
-- -- Gia tri mac dinh ban dau cho cot NgayLap luon luon la ngay hien hanh
alter table HoaDon
add constraint chk_NgayGiao_NgayLap check (NgayGiao >= NgayLap)
alter table HoaDon
add constraint chk_MaHD_Format check (MaHD like '[A-Z][A-Z][0-9][0-9][0-9][0-9]')
alter table HoaDon
add constraint df_NgayLap default (getdate()) for NgayLap

-- 8. Them vao Bang SanPham cac rang buoc sau:
-- -- SoLuongTon chi nhap tu 0 den 500
-- -- DonGiaNhap lon hon 0
-- -- Gia tri mac dinh cho NgayNhap la ngay hien hanh
-- -- DVT chi nhap vao cac gia tri 'KG', 'Thung', 'Hop', 'Cai'
alter table SanPham
add constraint chk_SoLuongTon check (SoLuongTon <=500)
alter table SanPham
add constraint chk_DonGiaNhap check (DonGiaNhap > 0)
alter table SanPham
add constraint df_NgayNhap default (getdate()) for NgayNhap
alter table SanPham
add constraint chk_DVT check (DVT IN ('KG', 'Thung', 'Hop', 'Cai'))

-- 9. Dung lenh T-SQL nhap du lieu vao 4 table tren, du lieu tuy y, chu y rang buoc
insert into SanPham (MaSp, TenSp, DVT, SoLuongTon, DonGiaNhap, TyLeHoaHong) values
('SP0001', 'Gao', 'KG', 100, 15000, 0.05),
('SP0002', 'Sua', 'Thung', 50, 120000, 0.10),
('SP0003', 'Banh', 'Hop', 200, 45000, 0.08),
('SP0004', 'Keo', 'Cai', 500, 2000, 0.02)

insert into KhachHang (MaKH, TenKH, DiaChi, DienThoai) values
('KH0001', 'Nguyen Van A', '123 Le Loi, Q1, TP.HCM', '0912345678'),
('KH0002', 'Tran Thi B', '456 Tran Hung Dao, Q5, TP.HCM', '0987654321'),
('KH0003', 'Le Van C', '789 Nguyen Trai, Q3, TP.HCM', '0932123456'),
('KH0004', 'Pham Thi D', '321 Hai Ba Trung, Q1, TP.HCM', '0909876543')

insert into HoaDon (MaHD, NgayLap, NgayGiao, MaKH, DienGiai) values
('HD0001', GETDATE(), DATEADD(DAY, 1, GETDATE()), 'KH0001', 'Khach le'),
('HD0002', GETDATE(), DATEADD(DAY, 2, GETDATE()), 'KH0002', 'Khach mua nhieu'),
('HD0003', GETDATE(), DATEADD(DAY, 3, GETDATE()), 'KH0003', 'Khach quen'),
('HD0004', GETDATE(), DATEADD(DAY, 4, GETDATE()), 'KH0004', 'Khach VIP')

insert into ChiTietHD (MaHD, MaSp, SoLuong) values
('HD0001', 'SP0001', 5), ('HD0001', 'SP0002', 2), ('HD0002', 'SP0003', 10),
('HD0002', 'SP0004', 15), ('HD0003', 'SP0001', 7), ('HD0003', 'SP0003', 3),
('HD0004', 'SP0002', 4), ('HD0004', 'SP0004', 8), ('HD0004', 'SP0001', 6)

-- 10. Xoa 1 hoa don bat ky trong bang HoaDon. Co xoa duoc khong? Tai sao? Neu van muon xoa thi dung cach nao?
delete from HoaDon where MaHD = 'HD0001'
-- Khong the xoa truc tiep duoc.
-- Do bi rang buoc khoa chinh-khoa ngoai voi bang ChiTietHD
-- Neu van muon xoa, truoc tien xoa du lieu lien quan truoc o Khoa ngoai
delete from ChiTietHD where MaHD = 'HD0001'
delete from HoaDon where MaHD = 'HD0001'

-- 11. Nhap 2 ban ghi moi vao bang ChiTietHD voi MaHD = 'HD999999999' va MaHD = '1234567890'. Co nhap duoc khong? Tai sao?
insert into ChiTietHD values
('HD999999999', 'SP0001', 5), ('1234567890', 'SP0002', 2)
-- Khong the nhap duoc 2 ban ghi nay.
-- Do co rang buoc voi bang HoaDon va 2 gia tri MaHD = 'HD999999999' va MaHD = '1234567890' khong ton tai
-- trong HoaDon, tu choi viec them du lieu vao. ChiTieTHD co kieu du lieu la char(10) va MaHD = 'HD999999999'
-- va MaHD = '1234567890' co do dai vuot qua 10 ky tu nen loi du lieu.

