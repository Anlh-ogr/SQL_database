use QuanLyChuyenDe
go

-- Nhap du lieu vao table NganhHoc
insert into NganhHoc values ('CNTT', 'Cong Nghe Thong Tin', 7, 0);
insert into NganhHoc values ('ATTT', 'An Toan Thong Tin', 6, 0);
insert into NganhHoc values ('KHMT', 'Khoa Hoc May Tinh', 8, 0);
insert into NganhHoc values ('KTPM', 'Ky Thuat Phan Mem', 7, 0);
insert into NganhHoc values ('HTTT', 'He Thong Thong Tin', 6, 0);
insert into NganhHoc values ('TTNT', 'Tri Tue Nhan Tao', 8, 0);
insert into NganhHoc values ('KHDL', 'Khoa Hoc Du Lieu', 8, 0);

select * from NganhHoc;

-- Nhap du lieu vao table ChuyenDe
-- Nhập dữ liệu môn chính
insert into ChuyenDe values ('CN01', 'Lap Trinh Co Ban');
insert into ChuyenDe values ('CN02', 'Cau Truc Du Lieu');
insert into ChuyenDe values ('CN03', 'Thuat Toan va Giai Thuat');
insert into ChuyenDe values ('CN04', 'Lap Trinh Huong Doi Tuong');
insert into ChuyenDe values ('CN05', 'Lap Trinh Web Co Ban');
insert into ChuyenDe values ('CN06', 'He Dieu Hanh');
insert into ChuyenDe values ('CN07', 'Co So Du Lieu');
insert into ChuyenDe values ('CN08', 'Thiet Ke va Phan Tich He Thong');
insert into ChuyenDe values ('CN09', 'Mang May Tinh');
insert into ChuyenDe values ('CN10', 'Lap Trinh Python');

insert into ChuyenDe values ('AI01', 'Tri Tue Nhan Tao');
insert into ChuyenDe values ('AI02', 'Hoc May');
insert into ChuyenDe values ('AI03', 'Xu Ly Ngon Ngu Tu Nhien');
insert into ChuyenDe values ('AI04', 'Thi Giac May Tinh');
insert into ChuyenDe values ('AI05', 'Phan Tich va Khai Thac Du Lieu');

insert into ChuyenDe values ('DS01', 'Phan Tich Du Lieu');
insert into ChuyenDe values ('DS02', 'Truc Quan Hoa Du Lieu');
insert into ChuyenDe values ('DS03', 'Khoa Hoc Du Lieu');
insert into ChuyenDe values ('DS04', 'Du Lieu Lon (Big Data)');
insert into ChuyenDe values ('DS05', 'Kho Du Lieu va OLAP');

insert into ChuyenDe values ('AT01', 'An Toan Mang');
insert into ChuyenDe values ('AT02', 'Ma Hoa va Bao Mat');
insert into ChuyenDe values ('AT03', 'Kiem Tra va Danh Gia An Toan He Thong');
insert into ChuyenDe values ('AT04', 'Quan Ly Rui Ro Thong Tin');

insert into ChuyenDe values ('KT01', 'Ky Thuat Lap Trinh');
insert into ChuyenDe values ('KT02', 'Toan Roi Rac');
insert into ChuyenDe values ('KT03', 'Tinh Toan Song Song');
insert into ChuyenDe values ('KT04', 'Cong Nghe Phan Mem');

insert into ChuyenDe values ('HT01', 'He Thong Nhung');
insert into ChuyenDe values ('HT02', 'IoT (Internet of Things)');

-- Nhập dữ liệu môn phụ
insert into ChuyenDe values ('PH01', 'Triet Hoc Mac - Lenin');
insert into ChuyenDe values ('PH02', 'Lich Su Dang Cong San Viet Nam');
insert into ChuyenDe values ('PH03', 'Tu Tuong Ho Chi Minh');
insert into ChuyenDe values ('PH04', 'Giao Duc Quoc Phong');
insert into ChuyenDe values ('PH05', 'Ky Nang Mem');
insert into ChuyenDe values ('PH06', 'Ngoai Ngu (Tieng Anh/Trung/Nhat)');
insert into ChuyenDe values ('PH07', 'Giao Duc The Chat');
insert into ChuyenDe values ('PH08', 'Ky Nang Lam Viec Nhom');
insert into ChuyenDe values ('PH09', 'Ky Nang Lanh Dao');
insert into ChuyenDe values ('PH10', 'Dao Duc Nghe Nghiep');

select * from ChuyenDe;

-- Nhap du lieu vao table NganhHoc_ChuyenDe
-- CNTT: 7 chính + 1 phụ
insert into NganhHoc_ChuyenDe values ('CNTT', 'CN01'); -- Lap Trinh Co Ban
insert into NganhHoc_ChuyenDe values ('CNTT', 'CN02'); -- Cau Truc Du Lieu
insert into NganhHoc_ChuyenDe values ('CNTT', 'CN03'); -- Thuat Toan va Giai Thuat
insert into NganhHoc_ChuyenDe values ('CNTT', 'CN04'); -- Lap Trinh Huong Doi Tuong
insert into NganhHoc_ChuyenDe values ('CNTT', 'CN05'); -- Lap Trinh Web Co Ban
insert into NganhHoc_ChuyenDe values ('CNTT', 'CN07'); -- Co So Du Lieu
insert into NganhHoc_ChuyenDe values ('CNTT', 'CN09'); -- Mang May Tinh
insert into NganhHoc_ChuyenDe values ('CNTT', 'PH01'); -- Triet Hoc Mac - Lenin

-- ATTT: 4 chính + 4 phụ
insert into NganhHoc_ChuyenDe values ('ATTT', 'AT01'); -- An Toan Mang
insert into NganhHoc_ChuyenDe values ('ATTT', 'AT02'); -- Ma Hoa va Bao Mat
insert into NganhHoc_ChuyenDe values ('ATTT', 'AT03'); -- Kiem Tra va Danh Gia An Toan He Thong
insert into NganhHoc_ChuyenDe values ('ATTT', 'AT04'); -- Quan Ly Rui Ro Thong Tin
insert into NganhHoc_ChuyenDe values ('ATTT', 'PH01'); -- Triet Hoc Mac - Lenin
insert into NganhHoc_ChuyenDe values ('ATTT', 'PH02'); -- Lich Su Dang
insert into NganhHoc_ChuyenDe values ('ATTT', 'PH03'); -- Tu Tuong Ho Chi Minh
insert into NganhHoc_ChuyenDe values ('ATTT', 'PH04'); -- Giao Duc Quoc Phong

-- KHMT: 5 chính + 3 phụ
insert into NganhHoc_ChuyenDe values ('KHMT', 'CN02'); -- Cau Truc Du Lieu
insert into NganhHoc_ChuyenDe values ('KHMT', 'CN03'); -- Thuat Toan va Giai Thuat
insert into NganhHoc_ChuyenDe values ('KHMT', 'KT02'); -- Toan Roi Rac
insert into NganhHoc_ChuyenDe values ('KHMT', 'KT03'); -- Tinh Toan Song Song
insert into NganhHoc_ChuyenDe values ('KHMT', 'CN07'); -- Co So Du Lieu
insert into NganhHoc_ChuyenDe values ('KHMT', 'PH01'); -- Triet Hoc Mac - Lenin
insert into NganhHoc_ChuyenDe values ('KHMT', 'PH02'); -- Lich Su Dang
insert into NganhHoc_ChuyenDe values ('KHMT', 'PH03'); -- Tu Tuong Ho Chi Minh

-- KTPM: 4 chính + 3 phụ
insert into NganhHoc_ChuyenDe values ('KTPM', 'KT01'); -- Ky Thuat Lap Trinh
insert into NganhHoc_ChuyenDe values ('KTPM', 'KT04'); -- Cong Nghe Phan Mem
insert into NganhHoc_ChuyenDe values ('KTPM', 'CN04'); -- Lap Trinh Huong Doi Tuong
insert into NganhHoc_ChuyenDe values ('KTPM', 'CN05'); -- Lap Trinh Web Co Ban
insert into NganhHoc_ChuyenDe values ('KTPM', 'PH01'); -- Triet Hoc Mac - Lenin
insert into NganhHoc_ChuyenDe values ('KTPM', 'PH02'); -- Lich Su Dang
insert into NganhHoc_ChuyenDe values ('KTPM', 'PH03'); -- Tu Tuong Ho Chi Minh

-- HTTT: 3 chính + 3 phụ
insert into NganhHoc_ChuyenDe values ('HTTT', 'HT01'); -- He Thong Nhung
insert into NganhHoc_ChuyenDe values ('HTTT', 'HT02'); -- IoT (Internet of Things)
insert into NganhHoc_ChuyenDe values ('HTTT', 'CN08'); -- Thiet Ke va Phan Tich He Thong
insert into NganhHoc_ChuyenDe values ('HTTT', 'PH01'); -- Triet Hoc Mac - Lenin
insert into NganhHoc_ChuyenDe values ('HTTT', 'PH02'); -- Lich Su Dang
insert into NganhHoc_ChuyenDe values ('HTTT', 'PH03'); -- Tu Tuong Ho Chi Minh

-- TTNT: 5 chính + 3 phụ
insert into NganhHoc_ChuyenDe values ('TTNT', 'AI01'); -- Tri Tue Nhan Tao
insert into NganhHoc_ChuyenDe values ('TTNT', 'AI02'); -- Hoc May
insert into NganhHoc_ChuyenDe values ('TTNT', 'AI03'); -- Xu Ly Ngon Ngu Tu Nhien
insert into NganhHoc_ChuyenDe values ('TTNT', 'AI04'); -- Thi Giac May Tinh
insert into NganhHoc_ChuyenDe values ('TTNT', 'AI05'); -- Phan Tich va Khai Thac Du Lieu
insert into NganhHoc_ChuyenDe values ('TTNT', 'PH01'); -- Triet Hoc Mac - Lenin
insert into NganhHoc_ChuyenDe values ('TTNT', 'PH02'); -- Lich Su Dang
insert into NganhHoc_ChuyenDe values ('TTNT', 'PH03'); -- Tu Tuong Ho Chi Minh

-- KHDL: 5 chính + 3 phụ
insert into NganhHoc_ChuyenDe values ('KHDL', 'DS01'); -- Phan Tich Du Lieu
insert into NganhHoc_ChuyenDe values ('KHDL', 'DS02'); -- Truc Quan Hoa Du Lieu
insert into NganhHoc_ChuyenDe values ('KHDL', 'DS03'); -- Khoa Hoc Du Lieu
insert into NganhHoc_ChuyenDe values ('KHDL', 'DS04'); -- Du Lieu Lon (Big Data)
insert into NganhHoc_ChuyenDe values ('KHDL', 'DS05'); -- Kho Du Lieu va OLAP
insert into NganhHoc_ChuyenDe values ('KHDL', 'PH01'); -- Triet Hoc Mac - Lenin
insert into NganhHoc_ChuyenDe values ('KHDL', 'PH02'); -- Lich Su Dang
insert into NganhHoc_ChuyenDe values ('KHDL', 'PH03'); -- Tu Tuong Ho Chi Minh

select * from NganhHoc_ChuyenDe;



-- Nhap du lieu vao table SinhVien
insert into SinhVien values ('21020001', 'Tran', 'Thi Ngoc' ,'Anh', 'Nu', convert(date, '14/07/2003', 103), 'TPHCM', 'CNTT');
insert into SinhVien values ('20074582', 'Bui', 'Van', 'Bao', 'Nam', convert(date, '22/08/2002', 103), 'Da Nang', 'KTPM');
insert into SinhVien values ('21019234', 'Dang', 'Thi', 'Cam', 'Nu', convert(date, '09/05/2003', 103), 'Hue', 'ATTT');
insert into SinhVien values ('20067891', 'Bui', 'Van', 'Danh', 'Nam', convert(date, '04/10/2002', 103), 'Thanh Hoa', 'KHMT');
insert into SinhVien values ('21036789', 'Dang', 'Van', 'Duc', 'Nam', convert(date, '17/11/2003', 103), 'Can Tho', 'KHMT');
insert into SinhVien values ('21045678', 'Nguyen', 'Van', 'Dung', 'Nam', convert(date, '29/08/2003', 103), 'Lam Dong', 'KTPM');
insert into SinhVien values ('22058412', 'Do', 'Thi', 'Giang', 'Nu', convert(date, '30/01/2004', 103), 'Hai Phong', 'TTNT');
insert into SinhVien values ('22071945', 'Do', 'Van', 'Hao', 'Nam', convert(date, '12/06/2004', 103), 'Vinh', 'HTTT');
insert into SinhVien values ('22089123', 'Pham', 'Van', 'Hieu', 'Nam', convert(date, '13/09/2004', 103), 'Ben Tre', 'KHMT');
insert into SinhVien values ('20089123', 'Le', 'Thi', 'Hoa', 'Nu', convert(date, '12/03/2002', 103), 'Nghe An', 'TTNT');
insert into SinhVien values ('21091234', 'Nguyen', 'Van', 'Hung', 'Nam', convert(date, '19/06/2003', 103), 'Ha Tinh', 'HTTT');
insert into SinhVien values ('20012345', 'Tran', 'Thi Ngoc', 'Huong', 'Nu', convert(date, '11/02/2002', 103), 'Vung Tau', 'TTNT');
insert into SinhVien values ('20034567', 'Tran', 'Van', 'Kien', 'Nam', convert(date, '20/06/2002', 103), 'An Giang', 'HTTT');
insert into SinhVien values ('20043156', 'Hoang', 'Van', 'Khanh', 'Nam', convert(date, '03/12/2002', 103), 'Nha Trang', 'CNTT');
insert into SinhVien values ('21034567', 'Vu', 'Van', 'Khanh', 'Nam', convert(date, '14/12/2003', 103), 'Ca Mau', 'KTPM');
insert into SinhVien values ('22039871', 'Luong', 'Van', 'Khoa', 'Nam', convert(date, '19/07/2004', 103), 'Tien Giang', 'TTNT');
insert into SinhVien values ('21067234', 'Le', 'Thi Ngoc', 'Lan', 'Nu', convert(date, '18/04/2003', 103), 'Dong Nai', 'KTPM');
insert into SinhVien values ('21056789', 'Tran', 'Thi', 'Lan', 'Nu', convert(date, '07/01/2003', 103), 'Tay Ninh', 'KHDL');
insert into SinhVien values ('20014567', 'Tran', 'Thi', 'Linh', 'Nu', convert(date, '06/07/2002', 103), 'Binh Thuan', 'CNTT');
insert into SinhVien values ('22023456', 'Pham', 'Van', 'Loc', 'Nam', convert(date, '28/11/2004', 103), 'Quang Ngai', 'KHDL');
insert into SinhVien values ('21078912', 'Tran', 'Van', 'Long', 'Nam', convert(date, '15/05/2003', 103), 'Bac Ninh', 'CNTT');
insert into SinhVien values ('22013456', 'Luong', 'Thi', 'Mai', 'Nu', convert(date, '14/02/2004', 103), 'Long An', 'KHMT');
insert into SinhVien values ('22091234', 'Vu', 'Thi', 'Mai', 'Nu', convert(date, '23/02/2004', 103), 'Hai Duong', 'KTPM');
insert into SinhVien values ('20029813', 'Hoang', 'Thi', 'Mai', 'Nu', convert(date, '25/09/2002', 103), 'Quang Ninh', 'KHDL');
insert into SinhVien values ('21084512', 'Le', 'Van', 'Minh', 'Nam', convert(date, '27/10/2003', 103), 'Binh Duong', 'ATTT');
insert into SinhVien values ('22014567', 'Vu', 'Van', 'Minh', 'Nam', convert(date, '31/07/2004', 103), 'Hung Yen', 'ATTT');
insert into SinhVien values ('20056723', 'Nguyen', 'Thi', 'Minh', 'Nu', convert(date, '08/01/2002', 103), 'Bac Giang', 'HTTT');
insert into SinhVien values ('20078912', 'Nguyen', 'Van', 'Minh', 'Nam', convert(date, '16/05/2002', 103), 'Thai Nguyen', 'KHDL');
insert into SinhVien values ('21023456', 'Nguyen', 'Thi Ngoc', 'Minh', 'Nu', convert(date, '21/03/2003', 103), 'Quang Nam', 'CNTT');
insert into SinhVien values ('22067891', 'Pham', 'Thi Ngoc', 'Minh', 'Nu', convert(date, '05/04/2004', 103), 'Phu Yen', 'ATTT');
insert into SinhVien values ('20091234', 'Ngo', 'Thi', 'Ngoc', 'Nu', convert(date, '17/02/2002', 103), 'Ha Giang', 'CNTT');
insert into SinhVien values ('21014567', 'Ngo', 'Van', 'Nam', 'Nam', convert(date, '25/06/2003', 103), 'Lao Cai', 'KTPM');
insert into SinhVien values ('22036789', 'Phan', 'Thi Ngoc', 'Phuong', 'Nu', convert(date, '03/08/2004', 103), 'Yen Bai', 'ATTT');
insert into SinhVien values ('20058912', 'Phan', 'Van', 'Phong', 'Nam', convert(date, '11/11/2002', 103), 'Tuyen Quang', 'KHMT');
insert into SinhVien values ('21072345', 'Pham', 'Van', 'Quang', 'Nam', convert(date, '19/03/2003', 103), 'Lai Chau', 'TTNT');
insert into SinhVien values ('22094567', 'Pham', 'Thi', 'Quyen', 'Nu', convert(date, '27/05/2004', 103), 'Dien Bien', 'HTTT');
insert into SinhVien values ('20016789', 'Trinh', 'Van', 'Son', 'Nam', convert(date, '04/01/2002', 103), 'Son La', 'KHDL');
insert into SinhVien values ('21038912', 'Trinh', 'Thi Ngoc', 'Suong', 'Nu', convert(date, '12/07/2003', 103), 'Hoa Binh', 'CNTT');
insert into SinhVien values ('22051234', 'Nguyen', 'Van', 'Tam', 'Nam', convert(date, '20/09/2004', 103), 'Bac Kan', 'KTPM');
insert into SinhVien values ('20073456', 'Nguyen', 'Thi', 'Thao', 'Nu', convert(date, '28/12/2002', 103), 'Cao Bang', 'ATTT');
insert into SinhVien values ('21095678', 'Le', 'Van', 'Thang', 'Nam', convert(date, '06/02/2003', 103), 'Lang Son', 'KHMT');
insert into SinhVien values ('22017890', 'Le', 'Thi Ngoc', 'Thuy', 'Nu', convert(date, '14/04/2004', 103), 'Thai Binh', 'TTNT');
insert into SinhVien values ('20029012', 'Hoang', 'Van', 'Tuan', 'Nam', convert(date, '22/06/2002', 103), 'Nam Dinh', 'HTTT');
insert into SinhVien values ('21041234', 'Hoang', 'Thi', 'Tuyet', 'Nu', convert(date, '30/08/2003', 103), 'Ninh Binh', 'KHDL');
insert into SinhVien values ('22063456', 'Vu', 'Van', 'Uyen', 'Nam', convert(date, '08/10/2004', 103), 'Phu Tho', 'CNTT');
insert into SinhVien values ('20085678', 'Vu', 'Thi Ngoc', 'Uy', 'Nu', convert(date, '16/03/2002', 103), 'Vinh Phuc', 'KTPM');
insert into SinhVien values ('21007890', 'Bui', 'Van', 'Viet', 'Nam', convert(date, '24/05/2003', 103), 'Bac Lieu', 'ATTT');
insert into SinhVien values ('22029012', 'Bui', 'Thi', 'Vy', 'Nu', convert(date, '01/07/2004', 103), 'Kien Giang', 'KHMT');
insert into SinhVien values ('20041234', 'Tran', 'Van', 'Xuong', 'Nam', convert(date, '09/09/2002', 103), 'Soc Trang', 'TTNT');
insert into SinhVien values ('21063456', 'Tran', 'Thi Ngoc', 'Yen', 'Nu', convert(date, '17/11/2003', 103), 'Tra Vinh', 'HTTT');

select * from SinhVien;

-- Nhap du lieu vao LopHoc
insert into LopHoc values ('CN01', 'CN01', 'HK1', '2023-2024', 40); -- Lap Trinh Co Ban
insert into LopHoc values ('CN02', 'CN02', 'HK2', '2023-2024', 35); -- Cau Truc Du Lieu
insert into LopHoc values ('AI01', 'AI01', 'HK1', '2024-2025', 30); -- Tri Tue Nhan Tao
insert into LopHoc values ('DS01', 'DS01', 'HK2', '2024-2025', 45); -- Phan Tich Du Lieu
insert into LopHoc values ('AT01', 'AT01', 'HK1', '2023-2024', 25); -- An Toan Mang
insert into LopHoc values ('KT01', 'KT01', 'HK2', '2023-2024', 50); -- Ky Thuat Lap Trinh
insert into LopHoc values ('HT01', 'HT01', 'HK1', '2024-2025', 20); -- He Thong Nhung
insert into LopHoc values ('PH01', 'PH01', 'HK1', '2023-2024', 50); -- Triet Hoc Mac - Lenin
insert into LopHoc values ('PH06', 'PH06', 'HK2', '2023-2024', 40); -- Ngoai Ngu
insert into LopHoc values ('CN07', 'CN07', 'HK1', '2024-2025', 35); -- Co So Du Lieu


select * from LopHoc;


-- Nhap du lieu vao table DangKy
insert into DangKy values ('DK001', '21020001', 'CN01'); -- Tran Thi Ngoc Anh (CNTT) -> Lap Trinh Co Ban
insert into DangKy values ('DK002', '20074582', 'KT01'); -- Bui Van Bao (KTPM) -> Ky Thuat Lap Trinh
insert into DangKy values ('DK003', '21019234', 'AT01'); -- Dang Thi Cam (ATTT) -> An Toan Mang
insert into DangKy values ('DK004', '20067891', 'CN02'); -- Bui Van Danh (KHMT) -> Cau Truc Du Lieu
insert into DangKy values ('DK005', '21036789', 'CN02'); -- Dang Van Duc (KHMT) -> Cau Truc Du Lieu
insert into DangKy values ('DK006', '21045678', 'KT01'); -- Nguyen Van Dung (KTPM) -> Ky Thuat Lap Trinh
insert into DangKy values ('DK007', '22058412', 'AI01'); -- Do Thi Giang (TTNT) -> Tri Tue Nhan Tao
insert into DangKy values ('DK008', '22071945', 'HT01'); -- Do Van Hao (HTTT) -> He Thong Nhung
insert into DangKy values ('DK009', '20012345', 'AI01'); -- Tran Thi Ngoc Huong (TTNT) -> Tri Tue Nhan Tao
insert into DangKy values ('DK010', '20034567', 'HT01'); -- Tran Van Kien (HTTT) -> He Thong Nhung
insert into DangKy values ('DK011', '21067234', 'KT01'); -- Le Thi Ngoc Lan (KTPM) -> Ky Thuat Lap Trinh
insert into DangKy values ('DK012', '22023456', 'DS01'); -- Pham Van Loc (KHDL) -> Phan Tich Du Lieu
insert into DangKy values ('DK013', '21078912', 'CN07'); -- Tran Van Long (CNTT) -> Co So Du Lieu
insert into DangKy values ('DK014', '22013456', 'CN02'); -- Luong Thi Mai (KHMT) -> Cau Truc Du Lieu
insert into DangKy values ('DK015', '21084512', 'AT01'); -- Le Van Minh (ATTT) -> An Toan Mang
insert into DangKy values ('DK016', '20091234', 'CN01'); -- Ngo Thi Ngoc (CNTT) -> Lap Trinh Co Ban
insert into DangKy values ('DK017', '21072345', 'AI01'); -- Pham Van Quang (TTNT) -> Tri Tue Nhan Tao
insert into DangKy values ('DK018', '22094567', 'HT01'); -- Pham Thi Quyen (HTTT) -> He Thong Nhung
insert into DangKy values ('DK019', '20016789', 'DS01'); -- Trinh Van Son (KHDL) -> Phan Tich Du Lieu
insert into DangKy values ('DK020', '21038912', 'CN07'); -- Trinh Thi Ngoc Suong (CNTT) -> Co So Du Lieu

select * from DangKy;



-- kiem tra
select MaCD from LopHoc where MaLop = 'CN01';
select MaNganh from SinhVien where MaSV = '21020001';
select * from NganhHoc_ChuyenDe where MaNganh = 'CNTT' and MaCD = 'CN02';


-- test trigger Update_TongSoSVTungHoc
insert into SinhVien values ('22099999', 'Nguyen', 'Van', 'Test', 'Nam', '2004-01-01', 'Hanoi', 'CNTT');
exec sp_DangKyLopHocMoi '22099999', 'CN01';
select TongSoSVTungHoc from NganhHoc where MaNganh = 'CNTT';

-- test trigger Check_Max_ChuyenDe
-- Thêm 2 bản ghi giả định
insert into DangKy values ('DK021', '21020001', 'PH01'); -- HK1, 2023-2024
insert into DangKy values ('DK022', '21020001', 'AT01'); -- HK1, 2023-2024
-- Cố gắng đăng ký lớp thứ 4
exec sp_DangKyLopHocMoi '21020001', 'CN07'; -- giả sử thêm CN07 là HK1 2023-2024)


-- test trigger Check_ChuyenDe_Nganh
exec sp_DangKyLopHocMoi '21020001', 'AI01';

-- test trigger Check_SoLuongToiDa
declare @idx int = 1;
while @idx <= 18
begin
    insert into DangKy values ('DKO' + cast(22 + @idx as varchar), '21020001', 'HT01');
    set @idx = @idx + 1;
end
exec sp_DangKyLopHocMoi '21020001', 'HT01';
select count(*) from DangKy where MaCD = 'HT01';

-- test trigger Check_Max8_NganhHoc_ChuyenDe
insert into NganhHoc_ChuyenDe values ('CNTT', 'CN06');


-- test trigger Delete_NganhHoc
-- Kiểm tra trước khi xóa
select * from SinhVien where MaNganh = 'ATTT';
select TongSoSVTungHoc from NganhHoc where MaNganh = 'CNTT';
-- Xóa ngành
delete from NganhHoc where MaNganh = 'ATTT';
-- Kiểm tra sau khi xóa
select * from SinhVien where MaNganh = 'ATTT';
select * from SinhVien where MaNganh = 'CNTT';
select TongSoSVTungHoc from NganhHoc where MaNganh = 'CNTT';