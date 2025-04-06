use AdventureWorks2008R2
go

--1) Tạo view dbo.vw_Products hiển thị danh sách các sản phẩm từ bảng
--Production.Product và bảng Production.ProductCostHistory. Thông tin bao gồm
--ProductID, Name, Color, Size, Style, StandardCost, EndDate, StartDate
create view vw_Products
as
	select Production.Product.ProductID, Production.Product.Name, Color, Size, Style, Production.ProductCostHistory.StandardCost, EndDate, StartDate
	from Production.Product join Production.ProductCostHistory
	on Production.Product.ProductID = Production.ProductCostHistory.ProductID


--2) Tạo view List_Product_View chứa danh sách các sản phẩm có trên 500 đơn đặt
--hàng trong quí 1 năm 2008 và có tổng trị giá >10000, thông tin gồm ProductID,
--Product_Name, CountOfOrderID và SubTotal.
create view List_Product_View
as
	select Production.Product.ProductID, Production.Product.Name as Product_Name, count(Sales.SalesOrderDetail.SalesOrderID) as CountOfOderID, sum(SubTotal) as SubTotal
	from Production.Product
	join Sales.SalesOrderDetail on Production.Product.ProductID = Sales.SalesOrderDetail.ProductID 
	join Sales.SalesOrderHeader on Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
	where year(orderdate) = '2008' and month(orderdate) in (1,3)
	group by Production.Product.ProductID, Production.Product.Name having count (Sales.SalesOrderDetail.SalesOrderID) > 500 and sum(subTotal) > 10000


--3) Tạo view dbo.vw_CustomerTotals hiển thị tổng tiền bán được (total sales) từ cột
--TotalDue của mỗi khách hàng (customer) theo tháng và theo năm. Thông tin gồm
--CustomerID, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS
--OrderMonth, SUM(TotalDue).
create view vw_CustomerTotals
as
	select Sales.Customer.CustomerID, year(orderdate) as OrderYear, month(orderdate) as OrderMonth, sum(TotalDue) as TotalDue
	from Sales.Customer join Sales.SalesOrderHeader
	on Sales.Customer.CustomerID = Sales.SalesOrderHeader.SalesOrderID
	group by Sales.Customer.CustomerID, year(orderdate), month(orderdate)


--4) Tạo view trả về tổng số lượng sản phẩm (Total Quantity) bán được của mỗi nhân
--viên theo từng năm. Thông tin gồm SalesPersonID, OrderYear, sumOfOrderQty
create view Total_Quantity
as
	select Sales.SalesOrderHeader.SalesPersonID, year(orderdate) as OrderYear, sum(OrderQty) as sumOfOrderQty
	from Sales.SalesOrderHeader join Sales.SalesOrderDetail
	on Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
	group by Sales.SalesOrderHeader.SalesPersonID, year(orderdate)


--5) Tạo view ListCustomer_view chứa danh sách các khách hàng có trên 25 hóa đơn
--đặt hàng từ năm 2007 đến 2008, thông tin gồm mã khách (PersonID) , họ tên
--(FirstName +' '+ LastName as FullName), Số hóa đơn (CountOfOrders).
create view ListCustomer_view
as
	select sales.Customer.PersonID, Person.Person.FirstName + ' ' + Person.Person.LastName as fullname, count(Sales.SalesOrderHeader.SalesOrderID) as CountOfOrders
	from Sales.Customer 
	join Person.Person on Sales.Customer.PersonID = Person.Person.BusinessEntityID
	join Sales.SalesOrderHeader on Sales.SalesOrderHeader.CustomerID = Sales.Customer.CustomerID
	where year(orderdate) in (2007, 2008)
	group by Sales.Customer.PersonID, Person.Person.FirstName + ' ' + Person.Person.LastName having count(Sales.SalesOrderHeader.SalesOrderID) > 25
	

--6) Tạo view ListProduct_view chứa danh sách những sản phẩm có tên bắt đầu với
--‘Bike’ và ‘Sport’ có tổng số lượng bán trong mỗi năm trên 50 sản phẩm, thông
--tin gồm ProductID, Name, SumOfOrderQty, Year. (dữ liệu lấy từ các bảng
--Sales.SalesOrderHeader, Sales.SalesOrderDetail, và Production.Product)
create view ListProduct_view
as
	select Production.Product.ProductID, Production.Product.Name, sum(Sales.SalesOrderDetail.OrderQty) as SumOfOrderQty, year(orderdate) as OrderYear
	from Sales.SalesOrderDetail
	join Sales.SalesOrderHeader on Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
	join Production.Product on Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
	where Production.Product.Name like 'Bike%' or Production.Product.Name like 'Sport%'
	group by Production.Product.ProductID, Production.Product.Name, year(orderdate) having sum(Sales.SalesOrderDetail.OrderQty) > 50


--7) Tạo view List_department_View chứa danh sách các phòng ban có lương (Rate:
--lương theo giờ) trung bình >30, thông tin gồm Mã phòng ban (DepartmentID),
--tên phòng ban (Name), Lương trung bình (AvgOfRate). Dữ liệu từ các bảng
--[HumanResources].[Department],
--[HumanResources].[EmployeeDepartmentHistory],
--[HumanResources].[EmployeePayHistory].
create List_department_View
as
	select HumanResources.Department.DepartmentID, Name, AvgOfRate = avg(HumanResources.EmployeePayHistory.Rate)
	from HumanResources.EmployeeDepartmentHistory
	join HumanResources.Department on HumanResources.Department.DepartmentID = HumanResources.EmployeeDepartmentHistory.DepartmentID
	join HumanResources.EmployeePayHistory on HumanResources.EmployeePayHistory.BusinessEntityID = HumanResources.EmployeeDepartmentHistory.BusinessEntityID
	group by HumanResources.Department.DepartmentID, name having avg(HumanResources.EmployeePayHistory.Rate) > 30


--8) Tạo view Sales.vw_OrderSummary với từ khóa WITH ENCRYPTION gồm
--OrderYear (năm của ngày lập), OrderMonth (tháng của ngày lập), OrderTotal
--(tổng tiền). Sau đó xem thông tin và trợ giúp về mã lệnh của view này
create view vw_OrderSummary
with encryption
as
	select year(orderdate) as OrderYear, month(orderdate) as OrderMonth, sum(Sales.SalesOrderHeader.TotalDue) as OrderTotal
	from Sales.SalesOrderHeader
	group by year(orderdate), month(orderdate)
	

--9) Tạo view Production.vwProducts với từ khóa WITH SCHEMABINDING
--gồm ProductID, Name, StartDate,EndDate,ListPrice của bảng Product và bảng
--ProductCostHistory. Xem thông tin của View. Xóa cột ListPrice của bảng
--Product. Có xóa được không? Vì sao?
create view vwProducts
with schemabinding
as
	select Production.Product.ProductID, Name, StartDate,EndDate,ListPrice
	from Production.Product join Production.ProductCostHistory
	on Production.Product.ProductID = Production.ProductCostHistory.ProductID

--
select *
from vwProducts
--
alter table Production.Product
drop column ListPrice

-- Khong the xoa cot ListPrice khoi table vi co doi tuong phu thuoc o cot nay.
-- View vwProducts dang phu thuoc vao cot ListPrice.
-- Constraint 'CK_Product_ListPrice' (rang buoc kiem tra) dang phuc thuoc vao cot ListPrice.


--10) Tạo view view_Department với từ khóa WITH CHECK OPTION chỉ chứa các
--phòng thuộc nhóm có tên (GroupName) là “Manufacturing” và “Quality
--Assurance”, thông tin gồm: DepartmentID, Name, GroupName.
create view view_Department
as
	select HumanResources.Department.DepartmentID, name, HumanResources.Department.GroupName
	from HumanResources.Department
	where GroupName = 'Manufacturing' or GroupName = 'Quality Assurance'
	with check option
--a. Chèn thêm một phòng ban mới thuộc nhóm không thuộc hai nhóm
--“Manufacturing” và “Quality Assurance” thông qua view vừa tạo. Có
--chèn được không? Giải thích.
insert into view_Department
values ('Staff','a')

-- Khong chen duoc.
-- Khi thuc hien thao tac insert/update tren 1 view co tuy chon "with check option" nhung cac du lieu
-- moi chen vao khong dap ung duoc cac dieu kien duoc dinh nghia trong view. Muon thoa duoc dieu kien 
-- thi phai cho gia tri moi thuoc 1 trong 2 nhom “Manufacturing” hoac “Quality Assurance”.


--b. Chèn thêm một phòng mới thuộc nhóm “Manufacturing” và một
--phòng thuộc nhóm “Quality Assurance”.
insert into view_Department
values ('Stall', 'Manufacturing')

--c. Dùng câu lệnh Select xem kết quả trong bảng Department.
select *
from HumanResources.Department