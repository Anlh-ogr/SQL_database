use CTY
go

-- hien thi thong tin sach
create proc GetAllSah as
begin
    select * from Sah
end
exec GetAllSah

-- them sach moi
create proc AddSah
    @masach int,
    @tensach nvarchar(100),
    @matacgia int,
    @namxuatban int,
    @giaban float
as
begin
    insert into Sah (MaSach,TenSach,MaTacGia,NamXuatBan,GiaBan)
    values (@masach,@tensach,@matacgia,@namxuatban,@giaban)
end
exec AddSah 5, 'Giai Thuat', 102, 2022, 200000

-- cap nhat thong tin sach
create proc UpdateSah
    @masach int,
    @tensach nvarchar(100),
    @matacgia int,
    @namxuatban int,
    @giaban float
as
begin
    update Sah
    set TenSach = @tensach,
        MaTacGia = @matacgia,
        NamXuatBan = @namxuatban,
        GiaBan = @giaban
    where MaSach = @masach
end
exec UpdateSah 2, 'Lap Trinh Python Nang Cao', 102, 2022, 250000)

-- xoa sach theo ma
create proc DeleteSah
    @masach int
as
begin
    delete from Sah
    where MaSach = @masach
end
exec DeleteSah 3

-- hien thi sach moi xuat ban sau mot nam
create proc GetSahMoi
    @namxuatban int
as
begin
    select *
    from Sah
    where Sah.NamXuatBan > @namxuatban
end
exec GetSahMoi 2020

-- tong so sach theo tung tac gia
create proc GetTongSachTheoTacGia
as
begin
    select Tgia.TenTacGia, count(Sah.MaSach) as tongsosah
    from Tgia
    join Sah on Tgia.MaTacGia = Sah.MaTacGia
    group by Tgia.TenTacGia
end
exec GetTongSachTheoTacGia

-- hien thi sach kem ten tgia
create proc GetSachVaTacGia
as
begin
    select Sah.TenSach, Tgia.TenTacGia
    from Sah
    join Tgia on Sah.MaTacGia = Tgia.MaTacGia
end
exec GetSachVaTacGia

-- loc sach theo gia ban va sap xep
create proc GetSachTheoGia
    @giamin money,
    @giamax money
as
begin
    select Sah.TenSach, Sah.GiaBan
    from Sah
    where Sah.GiaBan between @giamin and @giamax
    order by Sah.GiaBan desc
end
exec GetSachTheoGia 50000, 200000

-- phan loai sach theo nam xuat ban
create proc PhanLoaiSach as
begin
    select Sah.tensach,
    case
        when Sah.NamXuatBan >= 2020 then 'new'
        else 'old'
    end as PhanLoai
    from Sah
end
exec PhanLoaiSach

-- lay danh sah, them sah moi, cap nhat gia sah
create proc ManageSach
    @status varchar(10),
    @masach int,
    @tensach nvarchar(100),
    @matacgia int,
    @namxuatban int,
    @giaban float
as
begin
    if @status = 'get'
    begin
        select * from Sah
    end
    
    else if @status = 'add'
    begin
        insert into Sah (MaSach,TenSach,MaTacGia,NamXuatBan,GiaBan)
        values (@masach,@tensach,@matacgia,@namxuatban,@giaban)
    end

    else if @status = 'update'
    begin
        update Sah
        set TenSach = @tensach
            GiaBan = @giaban
        where Sah.MaSach = @masach
    end

    else if @status = 'delete'
    begin
        delete from Sah
        where Sah.MaSach = @masach
    end
end
exec ManageSach