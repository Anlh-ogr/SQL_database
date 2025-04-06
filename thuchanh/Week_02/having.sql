use AdventureWorks2008R2
go

-- 1. Liet ke danh sach cac hoa don (SalesOrderID) lap trong thang 6 nam 2008
-- co tong tien > 70000, thong tin gom SalesOrderID, Orderdate, SubTotal, trong
-- do SubTotal = sum(OrderQty * UnitPrice)
select Sales.SalesOrderHeader.SalesOrderID, OrderDate, sum(OrderQty * UnitPrice) as SubTotal, year(Sales.SalesOrderHeader.OrderDate) as chk_year, month(Sales.SalesOrderHeader.OrderDate) as chk_month 
from  Sales.SalesOrderHeader
join Sales.SalesOrderDetail on Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
where year(Sales.SalesOrderHeader.OrderDate) = 2008 and month(Sales.SalesOrderHeader.OrderDate) = 6
group by Sales.SalesOrderHeader.SalesOrderID, OrderDate having sum(OrderQty * UnitPrice) > 70000

-- 2. Dem tong so khach hang va tong tien cua nhung khach hang thuoc cac quoc
-- gia co ma vung la US (lay thong tin tu cac bang Sales.SalesTerritory, 
-- Sales.Customer, Sales.SalesOrderHeader, Sales.SalesOrderDetail). Thong tin
-- bao gom TerritoryID, tong so khach hang (CountOfCust), tong tien (SubTotal)
-- voi SubTotal = sum(OrderQty * UnitPrice)
select Sales.SalesTerritory.TerritoryID, CountryRegionCode, count(distinct Sales.Customer.CustomerID) as CountOfCust, sum(OrderQty * UnitPrice) as SubTotal
from Sales.SalesTerritory
join Sales.SalesOrderHeader on Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID
join Sales.SalesOrderDetail on Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
join Sales.Customer on Sales.SalesOrderHeader.CustomerID = Sales.Customer.CustomerID
where Sales.SalesTerritory.CountryRegionCode = 'US'
group by Sales.SalesTerritory.TerritoryID, CountryRegionCode having count(distinct Sales.Customer.CustomerID) > 0 and sum(OrderQty * UnitPrice) > 0
