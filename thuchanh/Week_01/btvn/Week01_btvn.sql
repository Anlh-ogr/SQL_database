----Sử dụng T-SQL tạo một cơ sở dữ liệu mới tên  SmallWorks, với 2 file group tên
----SWUserData1 và SWUserData2, lưu theo đường dẫn.

create database SmallWorks
on primary
(
	name='SmallWorksPrimary',
	filename='D:\SmallWorks.mdf',
	size=10mb,
	filegrowth=20%,
	maxsize=50mb
),

filegroup SWUserData1
(
	name='SmallWorksData1',
	filename='D:\SmallWorksData1.ndf',
	size=10mb,
	filegrowth=20%,
	maxsize=50mb
),

filegroup SWUserData2
(
	name='SmallWorksData2',
	filename='D:\SmallWorksData2.ndf',
	size=10mb,
	filegrowth=20%,
	maxsize=50mb
)

log on
(
	name='SmallWorks_log',
	filename='D:\SmallWorks_log.ldf',
	size=10mb,
	filegrowth=10%,
	maxsize=20mb
)

use SmallWorks;

--4.  Dùng T-SQL tạo thêm một filegroup tên Test1FG1 trong SmallWorks, sau đó add 
--thêm 2 file filedat1.ndf và filedat2.ndf dung lượng 5MB vào filegroup Test1FG1. 
--Dùng SSMS xem kết  quả.
alter database SmallWorks
add filegroup Test1FG1

alter database SmallWorks
add file (name='filedat1', filename='D:\filedat1.ndf',size=5mb) to filegroup Test1FG1

alter database SmallWorks
add file (name='filedat2', filename='D:\filedat2.ndf', size=5mb) to filegroup Test1FG1


--5.  Dùng T-SQL tạo thêm một một file thứ cấp  filedat3.ndf  dung lượng 3MB trong 
--filegroup Test1FG1. Sau đó sửa kích thước tập tin này lên 5MB. Dùng SSMS xem 
--kết quả. Dùng T-SQL xóa file thứ cấp filedat3.ndf. Dùng SSMS xem kết  quả
alter database SmallWorks
add file (name='filedat3', filename='D:\filedat3.ndf', size=3mb) to filegroup Test1FG1

alter database SmallWorks
modify file (name='filedat3', size=5mb)

--6.  Xóa  filegroup  Test1FG1?  Bạn  có  xóa  được  không?  Nếu  không  giải  thích?  Muốn  xóa 
--được bạn phải làm  gì?
alter database SmallWorks
remove filegroup Test1FG1
-- Khong xoa duoc filegroup Test1FG1 do muon xoa duoc thi filegroup Test1FG1 phai rong.
alter database SmallWorks remove file filedat1
alter database SmallWorks remove file filedat2
alter database SmallWorks remove file filedat3

--7.  Xem  lại  thuộc  tính  (properties)  của  CSDL  SmallWorks  bằng  cửa  sổ  thuộc  tính 
--properties  và  bằng  thủ  tục  hệ  thống  sp_helpDb,  sp_spaceUsed,  sp_helpFile. 
--Quan sát và cho biết các trang thể hiện thông tin  gì?.
sp_helpDb SmallWorks
sp_spaceused
sp_helpFile


--8.  Tại cửa sổ properties của CSDL SmallWorks, chọn thuộc tính ReadOnly, sau đó 
--đóng  cửa  sổ  properties.  Quan  sát  màu  sắc  của  CSDL.  Dùng  lệnh  T-SQL  gỡ  bỏ
--thuộc  tính  ReadOnly  và  đặt  thuộc  tính  cho  phép  nhiều  người  sử  dụng  CSDL
--SmallWorks.
alter database SmallWorks
set read_only

alter database SmallWorks
set read_write

--9.  Trong CSDL SmallWorks, tạo 2 bảng mới theo cấu trúc như  sau:
---  6-CREATE TABLE dbo.Person 
--(
--PersonID int NOT NULL, 
--FirstName varchar(50) NOT NULL, 
--MiddleName varchar(50) NULL, 
--LastName varchar(50) NOT NULL, 
--EmailAddress nvarchar(50) NULL
--) ON SWUserData1
--------------------------CREATE TABLE dbo.Product 
--(
--ProductID int NOT NULL, 
--ProductName varchar(75) NOT NULL,
--ProductNumber nvarchar(25) NOT NULL, 
--StandardCost money NOT NULL, 
--ListPrice money NOT NULL
--) ON SWUserData2
use SmallWorks
create table dbo.Person
(
	PersonID int not null,
	FirstName varchar(50) not null,
	MiddleName varchar(50) null,
	LastName varchar(50) not null,
	EmailAddress nvarchar(50) null
) on SWUserData1

create table dbo.Product
(
	ProductID int not null,
	ProductName varchar(75) not null,
	ProductNumber nvarchar(25) not null,
	StandardCost money not null,
	ListPrice money not null
)on SWUserData2


--10.  Chèn dữ liệu vào 2 bảng trên, lấy dữ liệu từ bảng  Person  và bảng  Product  trong 
--AdventureWorks2008  (lưu  ý:  chỉ  rõ  tên  cơ  sở  dữ  liệu  và  lược  đồ),  dùng  lệnh 
--Insert…Select...  Dùng  lệnh  Select *  để  xem  dữ  liệu  trong  2  bảng  Person  và  bảng
--Product  trong SmallWorks.
use [AdventureWorks2008R2];

insert into SmallWorks.dbo.Person (PersonID, FirstName, MiddleName, LastName, EmailAddress)
select [BusinessEntityID], [FirstName], [MiddleName], [LastName], [EmailPromotion]
from [Person].[Person]

insert into SmallWorks.dbo.Product (ProductID, ProductName, ProductNumber, StandardCost, ListPrice)
select [ProductID], [Name], [ProductNumber], [StandardCost], [ListPrice]
from [Production].[Product]

select * from SmallWorks.dbo.Person
select * from SmallWorks.dbo.Product
--11.  Dùng SSMS, Detach cơ sở dữ liệu SmallWorks ra khỏi phiên làm việc của  SQL.



--12.  Dùng SSMS, Attach cơ sở dữ liệu SmallWorks vào  SQL