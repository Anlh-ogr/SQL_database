use CTY
go

create table Tgia (
    MaTacGia int primary key,
    TenTacGia nvarchar(100)
)

create table Sah (
    MaSach int primary key,
    TenSach nvarchar (100),
    MaTacGia int,
    NamXuatBan int,
    GiaBan money,
    Foreign key (MaTacGia) references Tgia(MaTacGia)
)

insert into Tgia
values (101, 'Mai Hien'), (102, 'Truc Pham'), (103, 'Hai Van')

insert into Sah
values (1, 'Lap Trinh C', 101, 2018, 100000), 
       (2, 'Lap Trinh Python', 102, 2021, 150000),
       (3, 'Hoc SQL Co Ban', 101, 2019, 120000),
       (4, 'Giai tich toan hoc', 103, 2020, 170000)


--
create view TTCB_Sah as
select Sah.TenSach, Tgia.TenTacGia, Sah.NamXuatBan, Sah.GiaBan
from Sah
join Tgia on Sah.MaTacGia = Tgia.MaTacGia

select * from TTCB_Sah


--
create view Sah_Sau2000 as
select Sah.TenSach, Sah.NamXuatBan
from Sah
where Sah.NamXuatBan > 2020

select * from Sah_Sau2000


--
create view TongSah_TG as
select Tgia.TenTacGia, sum(Sah.MaSach) as TotalSah
from Tgia
join Sah on Sah.MaTacGia = Tgia.MaTacGia
group by Tgia.TenTacGia having sum(Sah.MaSach)


--
create view DS_TG as
select Sah.TenSach, Tgia.TacGia
from Sah
join Tgia on Sah.MaTacGia = Tgia.MaTacGia

select * from DS_TG



--
create view SapXep_GiaBan as
select top 100 percent Sah.TenSach, Sah.GiaBan
from Sah
order by Sah.GiaBan desc

select * from SapXep_GiaBan


--
create view PLTN_XB2020 as
select Sah.TenSach,
	case
		when Sah.NamXuatBan >= 2020 then 'New'
		else 'Old'
	end as PhanLoai
from Sah

select * from PLTN_XB2020