CREATE DATABASE QL_BANHANG
GO
USE QL_BANHANG
GO

-- Bang NHACUNGCAP
CREATE TABLE NHACUNGCAP
(
    MaNCC INT PRIMARY KEY,
    TenNCC NVARCHAR(50),
    DiaChi NVARCHAR(100)
)
GO

-- Bang SANPHAM
CREATE TABLE SANPHAM
(
    MaSP INT PRIMARY KEY,
    TenSP NVARCHAR(50),
    MaNCC INT REFERENCES NHACUNGCAP(MaNCC),
    DonViTinh NVARCHAR(20),
    GiaBan MONEY CHECK (GiaBan > 0),
    SLTON INT CHECK (SLTON >= 0)
)
GO

-- Bang KHACHHANG
CREATE TABLE KHACHHANG
(
    MaKH CHAR(5) PRIMARY KEY,
    TenKH NVARCHAR(50),
    DiaChi NVARCHAR(100)
)
GO

-- Bang HOADON
CREATE TABLE HOADON
(
    MaHD INT PRIMARY KEY,
    NgayLapHD DATETIME DEFAULT GETDATE(),
    MaKH CHAR(5) REFERENCES KHACHHANG(MaKH),
    TongTienHD MONEY
)
GO

-- Bang CT_HOADON
CREATE TABLE CT_HOADON
(
    MaHD INT REFERENCES HOADON(MaHD),
    MaSP INT REFERENCES SANPHAM(MaSP),
    Soluong INT CHECK (Soluong > 0),
    Dongia MONEY,
    PRIMARY KEY (MaHD, MaSP)
)
GO

-- Chen du lieu mau
INSERT INTO NHACUNGCAP VALUES (1, N'Cong ty Minh Phat', N'12 Tran Phu, HCM')
INSERT INTO NHACUNGCAP VALUES (2, N'Cong ty Hoa Sen', N'45 Le Loi, HN')

INSERT INTO SANPHAM VALUES (1, N'Tivi', 1, N'Cai', 8000000, 40)
INSERT INTO SANPHAM VALUES (2, N'May Giat', 1, N'Cai', 6000000, 25)
INSERT INTO SANPHAM VALUES (3, N'Noi Com Dien', 2, N'Cai', 1500000, 60)

INSERT INTO KHACHHANG VALUES ('KH001', N'Le Van Tam', N'78 Nguyen Hue, HCM')
INSERT INTO KHACHHANG VALUES ('KH002', N'Pham Thi Hoa', N'23 Vo Thi Sau, HN')

INSERT INTO HOADON (MaHD, NgayLapHD, MaKH) VALUES (1, '2025-03-01', 'KH001')
INSERT INTO HOADON (MaHD, NgayLapHD, MaKH) VALUES (2, '2025-03-15', 'KH002')
INSERT INTO HOADON (MaHD, NgayLapHD, MaKH) VALUES (3, '2025-04-10', 'KH001')

INSERT INTO CT_HOADON VALUES (1, 1, 2, 8000000)
INSERT INTO CT_HOADON VALUES (1, 2, 1, 6000000)
INSERT INTO CT_HOADON VALUES (2, 3, 3, 1500000)
INSERT INTO CT_HOADON VALUES (3, 1, 1, 8000000)


-- 1. Viết một Function trả về tổng số tiền bán được (dựa trên Soluong * Dongia) của một
-- sản phẩm (MaSP) trong một tháng và năm được truyền vào từ tham số.
create function tongtienbanduoc (
    @masp int, @thang int, @nam int
)
returns money
as
begin
    declare @tongtien money
    select @tongtien = sum(Soluong * Dongia)
    from CT_HOADON
    join HOADON on CT_HOADON.MaHD = SANPHAM.MaHD
    where MaSP = @masp and month(NgayLapHD) = @thang and year(NgayLapHD) = @nam
    return @tongtien
end
select dbo.tongtienbanduoc(1, 3, 2025)

-- 2: Viết Stored Procedure cập nhật cột TongTienHD trong bảng HOADON, biết rằng TongTienHD
-- là tổng của Soluong * Dongia từ bảng CT_HOADON tương ứng với mỗi hóa đơn.
create proc capnhatdulieu
as
begin
    update HOADON
    set TongTien = (
        sum(Soluong * Dongia)
        from CT_HOADON
        where HOADON.MaHD = CT_HOADON.MaHD
    )
end

-- 3. Viết Inline Table-Valued Function trả về danh sách gồm MaHD, TenKH, TenSP, Soluong,
-- ThanhTien, trong đó ThanhTien = Soluong * Dongia.
create function DanhSachChiTietHoaDon ()
returns table
as
return (
    select MaHD, TenKH, TenSP, SoLuong, SoLuong*DonGia as ThanhTien
    from HOADON
    join CT_HOADON on CT_HOADON.MaHD = HOADON.MaHD
    join KHACHHANG on HOADON.MaKH = HOADON.MaKH
    join SANPHAM on CT_HOADON.MaSP = SANPHAM.MaSP
)

-- 4. Viết Multi-statement Table-Valued Function liệt kê danh sách nhà cung cấp (MaNCC, TenNCC)
-- cùng với tổng số lượng sản phẩm tồn kho (SLTON) tương ứng.
create function DanhSachNhaCungCap ()
return @result table (@mancc int, @tenncc nvarchar(50), @slton int)
as
begin
    insert into @result
    select MaNCC, TenNCC, sum(SLTON) as tongslton
    from NHACUNGCAP
    join SANPHAM on NHACUNGCAP.MaNCC = SANPHAM.MaNCC
    group by MaNCC, TenNCC
    return
end
go

-- 5. Viết Stored Procedure tìm khách hàng (MaKH, TenKH) có tổng số tiền mua hàng (TongTienHD) lớn 
-- nhất trong một năm được truyền vào từ tham số.
create proc KhachHangGiau (
    @nam int
)
as
begin
    with tongtien as(
        select MaKH, TenKH, sum(TongTienHD) as tongtienmua
        from KHACHHANG
        join HOADON on KHACHHANG.MaKH = HOADON.MaKH
        where year(NgayLapHD) = @nam
        group by MaKH, TenKH
    )
    select MaKH, TenKH, tongtienmua
    from tongtien
    where tongtienmua = (select max(tongtienmua) from tongtien)
end