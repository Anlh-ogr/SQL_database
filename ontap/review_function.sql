use CTY
go

-- them moi sach
create function AddSachFunction (
    @masach int,
    @tensach nvarchar (100),
    @matacgia int,
    @namxuatban int,
    @giaban money
)
returns table
as
return (
    select
        @masach as Sah.MaSach
        @tensach as Sah.TenSach
        @matacgia as Sah.MaTacGia
        @namxuatban as Sah.NamXuatBan
        @giaban as Sah.GiaBan
)
select * from dbo.AddSachFunction(5, 'Lap trinh Javascript', 102, 2022, 210000)

-- kiem tra gia tri ton tai
create function IsSachExists (
    @masach int
)
returns bit
as
begin
    declare @exists bit
    if exists (select 1 from Sah where Sah.MaSach = @masach)
        set @exists = 1
    else
        set @exists = 0
    return @exists
end
select dbo.IsSachExists(1)

-- tra ve thong tin sach
create function GetSachById (
    @masach
)
returns table
as
return (
    select * from Sah
    where Sah.MaSach = @masach
)
select * from dbo.GetSachById(2)

-- tinh gia sach sau chiet khau
create function TinhGiaSauChietKhau (
    @masach int,
    @chietkhau float
)
returns money
as
begin
    declare @giaban money
    select @giaban = Sah.GiaBan
    from Sah
    where Sah.MaSach = @masach

    return @giaban * (1 - @chietkhau)
end
select dbo.TinhGiaSauChietKhau (2, 0.1)

-- tinh tong gia tri sah
create function GetTongGiaSach ()
returns money
as
begin
    declare @tonggia money
    select @tonggia = sum(Sah.GiaBan)
    from Sah

    return @tonggia
end
select dbo.GetTongGiaSach()