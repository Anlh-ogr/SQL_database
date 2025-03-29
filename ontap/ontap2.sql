CREATE DATABASE QL_KINHDOANH
GO
USE QL_KINHDOANH
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
    TongSLBan INT DEFAULT 0
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
    MaKH CHAR(5) REFERENCES KHACHHANG(MaKH)
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
INSERT INTO NHACUNGCAP VALUES (1, N'Cong ty Phuc Long', N'34 Ly Thuong Kiet, HCM')
INSERT INTO NHACUNGCAP VALUES (2, N'Cong ty Trung Nguyen', N'56 Nguyen Du, HN')

INSERT INTO SANPHAM (MaSP, TenSP, MaNCC, DonViTinh, GiaBan) 
VALUES (1, N'Ca Phe', 1, N'Goi', 50000)
INSERT INTO SANPHAM (MaSP, TenSP, MaNCC, DonViTinh, GiaBan) 
VALUES (2, N'Tra Sua', 1, N'Ly', 30000)
INSERT INTO SANPHAM (MaSP, TenSP, MaNCC, DonViTinh, GiaBan) 
VALUES (3, N'Banh Mi', 2, N'Cai', 20000)

INSERT INTO KHACHHANG VALUES ('KH001', N'Nguyen Thi Lan', N'12 Tran Hung Dao, HCM')
INSERT INTO KHACHHANG VALUES ('KH002', N'Tran Van Nam', N'78 Le Loi, HN')

INSERT INTO HOADON (MaHD, NgayLapHD, MaKH) VALUES (1, '2025-05-10', 'KH001')
INSERT INTO HOADON (MaHD, NgayLapHD, MaKH) VALUES (2, '2025-05-15', 'KH002')
INSERT INTO HOADON (MaHD, NgayLapHD, MaKH) VALUES (3, '2025-06-01', 'KH001')

INSERT INTO CT_HOADON VALUES (1, 1, 10, 50000)
INSERT INTO CT_HOADON VALUES (1, 2, 5, 30000)
INSERT INTO CT_HOADON VALUES (2, 3, 15, 20000)
INSERT INTO CT_HOADON VALUES (3, 1, 8, 50000)


-- 1.Viết Function trả về tổng số lượng sản phẩm đã bán (Soluong) của một nhà cung cấp 
-- (MaNCC) trong một năm được truyền vào từ tham số.
create function tongsoluongsanphamdaban (
    @mancc int, @nam int
)
returns int
as
begin
    declare @tongsl int
    select @tongsl = sum(Soluong)
    from CT_HOADON
    join SANPHAM on CT_HOADON.MaSP = SANPHAM.MaSP
    join HOADON on CT_HOADON.MaHD = HOADON.MaHD
    where MaNCC = @mancc and year(NgayLapHD) = @nam
    return @tongsl
end
select dbo.tongsoluongsanphamdaban(1, 2025)

-- 2.Viết Stored Procedure cập nhật cột TongSLBan trong bảng SANPHAM, biết rằng TongSLBan
-- là tổng Soluong từ bảng CT_HOADON tương ứng với mỗi sản phẩm.
create proc capnhattongsl
as
begin
    update SANPHAM
    set tongsl = (
        select sum(Soluong)
        from CT_HOADON
        where SANPHAM.MaSP = CT_HOADON.MaSP
    )
end
exec capnhattongsl


-- 3.Viết Inline Table-Valued Function trả về danh sách gồm MaHD, TenNCC, TenSP, Soluong, 
-- TongTienSP, trong đó TongTienSP = Soluong * Dongia.
create function danhsachchitiet()
returns table
as
return (
    select MaHD, TenNCC, TenSP, Soluong, Soluong*Dongia as TongTienSP
    from CT_HOADON
    join HOADON on CT_HOADON.MaHD = HOADON.MaHD
    join SANPHAM on CT_HOADON.MaSP = SANPHAM.MaSP
    join NHACUNGCAP on SANPHAM.MaNCC = NHACUNGCAP.MaNCC
)
end
select * from danhsachchitiet()


-- 4.Viết Multi-statement Table-Valued Function liệt kê danh sách khách hàng (MaKH, TenKH)
-- cùng với tổng số hóa đơn đã lập (SoLuongHD) tương ứng.
create function danhsachkhachhang()
returns @result table(@makh int, @tenkh nvarchar(50), @soluonghd int)
as
begin
    insert into @result
    select MaKH, TenKH, count(SoLuongHD) as tongHD
    from KHACHHANG
    left join HOADON on KHACHHANG.MaKH = HOADON.MaKH
    group by MaKH, TenKH
    return
end
select * from danhsachkhachhang()


-- 5.Viết Stored Procedure tìm sản phẩm (MaSP, TenSP) có tổng số lượng bán (Soluong) lớn 
-- nhất trong một tháng và năm được truyền vào từ tham số.
create proc timsanpham (@thang int, @nam int)
as
begin
    with tongsoluong as (
        select MaSP, TenSP, sum(Soluong) as tongsl
        from SANPHAM
        join CT_HOADON on SANPHAM.MaSP = CT_HOADON.MaSP
        join HOADON on HOADON.MaHD = CT_HOADON.MaHD
        where month(NgayLapHD) = @thang and year(NgayLapHD) = @nam
        group by MaSP, TenSP
    )
    select MaSP, TenSP, sum(Soluong) as tongsl
    from tongsoluong
    where tongsl = (select(max(Soluong)) from tongsoluong)
end
exec timsanpham 5, 2025