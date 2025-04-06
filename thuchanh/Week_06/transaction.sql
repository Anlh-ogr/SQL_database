use AdventureWorks2008R2
go
-- 1 Them vao bang Department mot dong du lieu tuy y bang cau lenh insert... values... :
insert into HumanResources.Department
values ('Software', 'Research and Development', '2002-06-01 00:00:00.000')
-- -- a. Thuc hien lenh chem them vao bang Department mot dong du lieu tuy y bang cach thuc hien lenh begin tran va rollback, dung cau lenh select * from Department de xem ket qua.
begin tran
    insert into HumanResources.Department
    values ('IT', 'Research and Development', '2002-06-01 00:00:00.000')
rollback tran
select * from HumanResources.Department

-- -- b. Thuc hien cau lenh tren voi lenh commit va kiem tra ket qua.
begin tran
    insert into HumanResources.Department
    values ('IT', 'Research and Development', '2002-06-01 00:00:00.000')
commit tran
select * from HumanResources.Department

-- 2. Tat che do autocommit cua SQL Server (set implicit_transactions on). Tao doan batch gom cac thao tac:
-- -- Them mot dong vao bang Department.
-- -- Tao mot bang Test(ID int, Name nvarchar(10)).
-- -- Them mot dong vao Test.
-- -- Rollback.
-- -- Xem du lieu o bang Department va Test de kiem tra du lieu, giai thich ket qua.
set implicit_transactions on
-- batch
begin tran
    insert into HumanResources.Department
    values ('Bing', 'Sales and Marketing', '2002-06-01 00:00:00.000')
    create table Test (
        ID int,
        Name nvarchar(10)
    )

    insert into Test
    values (1, 'Example A')
rollback tran
select * from HumanResources.Department
select * from Test
-- Vi lenh set implicit_transactions on da duoc thuc thi, SQL Server se tu dong bat dau giao dich moi khi thuc thi lenh insert, create table, va lenh rollback se khong lam thay doi du lieu trong bang Department.
-- Nen ket qua tra ve tu bang Department cho thay du lieu khong co thay doi, bang Test se khong duoc tao ra vi lenh rollback da duoc thuc thi.

-- 3. Viet doan batch thuc hien cac thao tac sau (luu y thuc hien lenh set xact_abort on: neu cau lenh T-SQL lam phat sinh loi run-time, toan boj giao dich duoc cham dut va Rollback).
-- -- Cau lenh select voi phep chia 0:select 1/0 as Dummy.
-- -- Cap nhat mot dong tren bang Department voi DepartmentID='9' (id nay khong ton tai)
-- -- Xoa mot dong khong ton tai tren bang Department (DepartmentID='66').
-- -- Them mot dong bat ky vao bang Department.
-- -- Commit.
-- thuc thi doan batch, quan sat key qua va cac thong bao loi va giai thich ket qua.
set xact_abort on
begin tran
    select 1/0 as Dummy
    -- update DepartmentID = 9
    update HumanResources.Department
    set Name = 'Human'
    where DepartmentID = 9
    -- delete DepartmentID = 66
    delete from HumanResources.Department
    where DepartmentID = 66
    -- insert DepartmentID = 17
    insert into HumanResources.Department
    values ('SayHello', 'Sales and Marketing', '2002-06-01 00:00:00.000')
commit tran

-- Error: Divide by zero error encountered.
-- Giai thich: Vi lenh select 1/0 se phat sinh loi chia cho 0, va do lenh set xact_abort on da duoc thuc thi, toan bo giao dich se bi cham dut va rollback.
--             Nen cac lenh update, delete, va insert se khong duoc thuc thi va du lieu trong bang Department se khong bi thay doi.

-- 4. Thuc hien lenh set xact_abort off (nhung cau lenh loi se rollback, transaction van tiep tuc) sau do thuc thi lai cac thao tac cua doan batch o cau 3. Quan sat ket qua va giai thich.
set xact_abort off
begin tran
    select 1/0 as Dummy
    -- update DepartmentID = 9
    update HumanResources.Department
    set Name = 'Human'
    where DepartmentID = 9
    -- delete DepartmentID = 66
    delete from HumanResources.Department
    where DepartmentID = 66
    -- insert DepartmentID = 17
    insert into HumanResources.Department
    values ('SayHello', 'Sales and Marketing', '2002-06-01 00:00:00.000')
commit tran

-- Error: Divide by zero error encountered.
-- Giai thich: Vi lenh select 1/0 se phat sinh loi chia cho 0, va do lenh set xact_abort off da duoc thuc thi, giao dich se khong bi cham dut va cac lenh update, delete, va insert se van duoc thuc thi.
--             Tuy nhien, do lenh update va delete khong tim thay du lieu de thuc thi, nen cac lenh nay se khong thay doi du lieu trong bang Department.