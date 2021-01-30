/* 
Họ và tên: vương quang huy
lớp: 19a02*/
CREATE DATABASE BTLN09QuanLyKinhDoanhMayTinh
ON(
	NAME =BTLN09QuanLyKinhDoanhMayTinh,
	FILENAME = 'D:\could\googledriver\vqh2602@gmail.com\Fithou\BTL\hệ quản trị csdl\BTL_Nhom09_QuanLyKinhDoanhMayTinh\BTLN09QuanLyKinhDoanhMayTinh.mdf'
)
USE BTLN09QuanLyKinhDoanhMayTinh

-- Tạo Các Bảng
-- tblLoaiHang
 CREATE TABLE tblLoaiHang
 (
	sMaLoaiHang VARCHAR(20) PRIMARY KEY,
	sTenLoaiHang NVARCHAR(30)
 )

 --tblNhaCungCap
 CREATE TABLE tblNhaCungCap
 (
	iMaNCC INT PRIMARY KEY,
	sTenNhaCC NVARCHAR(30),
	sTenGiaoDich NVARCHAR(50),
	sDiaChi NVARCHAR(50),
	sDienThoai CHAR(10)
 )

 --tblMatHang
 CREATE TABLE tblMatHang
 (
	sMaHang VARCHAR(20) PRIMARY KEY,
	sTenHang NVARCHAR(30),
	iMaNCC INT REFERENCES dbo.tblNhaCungCap(iMaNCC),
	sMaLoaiHang VARCHAR(20) REFERENCES dbo.tblLoaiHang(sMaLoaiHang),
	fSoLuong FLOAT,
	fGiaHang FLOAT,
 )

 --tblKhachHang
 CREATE TABLE tblKhachHang
 (
	iMaKH INT PRIMARY KEY,
	sTenKH NVARCHAR(30),
	sDiaChi NVARCHAR(50),
	sDienThoai CHAR(10)
 )

 --tblNhanVien
 CREATE TABLE tblNhanVien
 (
	iMaNV INT PRIMARY KEY,
	sTenNV NVARCHAR(30),
	sDiaChi NVARCHAR(50),
	sDienThoai CHAR(10),
	dNgaySinh DATETIME CHECK(DATEDIFF(YEAR,dNgaySinh,GETDATE()) >=18),
	sGioiTinh NVARCHAR(5) CHECK(sGioiTinh = N'Nam' OR sGioiTinh = N'Nữ'),
	dNgayVaoLam DATETIME,
	fLuongCoBan FLOAT,
	fPhuCap FLOAT
 )

 --tblDonDatHang
 CREATE TABLE tblDonDatHang
 (
	iSoHD INT PRIMARY KEY,
	iMaNV INT REFERENCES dbo.tblNhanVien(iMaNV),
	iMaKH INT REFERENCES dbo.tblKhachHang(iMaKH),
	dNgayDatHang DATETIME,
	dNgayGiaoHang DATETIME,
	fTongTienHD FLOAT CHECK (fTongTienHD >0),
	CONSTRAINT ck_ngaydathang CHECK(DATEDIFF(DAY,dNgayDatHang,dNgayGiaoHang)>=0)
 )

 --tblChiTietDatHang
 CREATE TABLE tblChiTietDatHang
 (
	iSoHD INT REFERENCES dbo.tblDonDatHang(iSoHD),
	sMaHang VARCHAR(20) REFERENCES dbo.tblMatHang(sMaHang),
	fGiaBan FLOAT,
	iSoLuongMua INT,
	fMucGiamGia FLOAT,
	CONSTRAINT pk_chitietdathang PRIMARY KEY (iSoHD,sMaHang)
 )

 --tblDonNhapKho
CREATE TABLE tblDonNhapKho
(
	iSoNK INT PRIMARY KEY,
	iMaNV INT REFERENCES dbo.tblNhanVien(iMaNV),
	dNgayNhapHang DATETIME,
	fTongSoLuong FLOAT CHECK(fTongSoLuong >0)
)

-- tblChiTietNhapKho
CREATE TABLE tblChiTietNhapKho
(
	iSoNK INT REFERENCES dbo.tblDonNhapKho(iSoNK),
	sMaHang VARCHAR(20) REFERENCES dbo.tblMatHang(sMaHang),
	fGiaNhap FLOAT,
	fSoLuongNhap FLOAT CHECK (fSoLuongNhap >0),
	CONSTRAINT pk_chitietnhapkho PRIMARY KEY (iSoNK,sMaHang)
)


-- THEM DU LIEU
-- tblLoaiHang
INSERT INTO dbo.tblLoaiHang VALUES
	('LH01', N'LapTop'),
	('LH02', N'PC'),
	('LH03', N'Phụ Kiện')

--tblNhaCungCap
INSERT INTO dbo.tblNhaCungCap VALUES
	(101, N'ASUS', N'Nhập Hàng Asus', N'Hà Nội', '0334455667'), 
	(102, N'DELL', N'Nhập Hàng Dell', N'Đà Nẵng', '0334455668'),
	(103, N'APPLE', N'Nhập Hàng Apple', N'Hải Phòng', '0334455669'),
	(104, N'LENOVO', N'Nhập Hàng Lenovo', N'TP. Hồ Chí Minh', '0334455670'	)

--tblKhachHang
INSERT INTO dbo.tblKhachHang VALUES
	(111, N'Trần Anh Vũ', N'Giáp Nhị, Hà Nội', '0112233445'),
	(112, N'Trần Thanh Tâm', N'Hoàng Mai, Hà Nội', '0112233446'),
	(113, N'Nguyễn Minh Tú', N'Minh Khai, Hà Nội', '0112233447'),
	(114, N'Đỗ Thu Phương', N'Giáp Bát, Hà Nội', '0112233448'),
	(115, N'Lê Văn Tráng', N'Định Công, Hà Nội', '0112233449')
	
-- tblNhanVien
INSERT INTO dbo.tblNhanVien VALUES
	(1010,	N'Đỗ Thị Bích',	N'Giáp Bát, Hà Nội',	'0123456781',	'1997/01/01',	N'Nữ',	'2019/02/26',	7050000, 1000000),
	(1011,	N'Nguyễn Công Chính',	N'Pháp Vân, Hà Nội',	 '0123456782', '1989/12/21',	N'Nam',	'2016/11/22',	12100000,	2000000),
	(1012,	N'Vương Quang Huy',	N'Giải Phóng, Hà Nội', 	'0123456783',	'1999/03/12',	N'Nam',	'2020/04/02',	5500000, 450000),
	(1013,	N'Phạm Tiến Đạt',	N'Cầu Giấy, Hà Nội', 	'0123456784',	'2000/07/15',	N'Nam',	'2020/07/03',	5000000, 250000)

--tblMatHang
INSERT INTO dbo.tblMatHang VALUES
	('MH01', N'ASUS VivoBook 15 A512DA', 101, 'LH01', 400, 12290000),
	('MH02', N'ASUS Laptop 15 X509UA', 101, 'LH01', 350, 10700000),
	('MH03', N'Laptop Dell XPS 13', 102, 'LH01', 100, 40400000),
	('MH04', N'Laptop Dell Gaming G3', 102, 'LH01', 200, 21000000),
	('MH05', N'Laptop Lenovo Thinkpad X13', 104, 'LH01', 150, 34500000),
	('MH06', N'Apple MacBook Pro', 103, 'LH01', 250, 35500000),
	('MH07', N'PC Dell Vostro', 102, 'LH02', 300, 7050000),
	('MH08', N'PC Lenovo V50t', 104, 'LH02', 200, 9190000),
	('MH09', N'PC Lenovo Ideacentre AIO', 104, 'LH02', 500, 12000000),
	('MH10', N'PC Asus Pro D340MC', 101, 'LH02', 650, 7000000),
	('MH11', N'PC Apple iMac 2019', 103, 'LH02', 250, 47800000),
	('MH12', N'Tai nghe AirPods 2', 103, 'LH03', 200, 3990000),
	('MH13', N'Apple Magic Mouse 2', 103, 'LH03', 200, 2490000),
	('MH14', N'CPU AMD Ryzen 9', 101, 'LH03', 150, 19299000),
	('MH15', N'Card đồ họa RTX3060TI', 101, 'LH03', 200, 13149000),

--tblDonNhapKho
INSERT INTO dbo.tblDonNhapKho VALUES
	(511, 1010, '2019/01/23', 2110),
	(512, 1011, '2017/11/12', 1800),
	(513, 1012, '2020/04/25', 1660),
	(514, 1013, '2020/07/07', 800)

--tblChiTietNhapKho
INSERT INTO dbo.tblChiTietNhapKho VALUES
	(511, 'MH01', 10790000, 450),
	(511, 'MH12', 2490000, 400),
	(511, 'MH03', 38900000, 250),
	(511, 'MH11', 46300000, 560),
	(511, 'MH05', 33000000, 450),
	(512, 'MH06', 34000000, 350),
	(512, 'MH07', 5550000, 600),
	(512, 'MH15', 11649000, 500),
	(512, 'MH09', 10500000, 350),
	(513, 'MH10', 5500000, 450),
	(513, 'MH04', 19500000, 400),
	(513, 'MH02', 9200000, 250),
	(513, 'MH13', 990000, 560),
	(514, 'MH14', 17799000, 450),
	(514, 'MH08', 7690000, 350)

--tblDonDatHang
INSERT INTO dbo.tblDonDatHang VALUES
	(510, 1010, 111, '2020/01/14', '2020/01/17', 59690000),
	(520, 1011, 112, '2020/03/15', '2020/03/18', 109400000 ),
	(530, 1012, 113, '2019/05/16', '2019/05/19',  47800000 ),
	(540, 1013, 114, '2020/06/17', '2020/06/20',  148204000 ),
	(550, 1011, 115, '2017/11/18', '2017/11/21',  71000000 )

--tblChiTietDatHang
INSERT INTO dbo.tblChiTietDatHang VALUES
	(510, 'MH01', 12290000, 1, 0),
	(510, 'MH03', 40400000, 1, 0),
	(510, 'MH10', 7000000, 1, 0),
	(520, 'MH05', 34500000, 2, 0),
	(520, 'MH03', 40400000, 1, 0),
	(530, 'MH11', 47800000, 1, 0),
	(540, 'MH15', 13149000, 3, 0),
	(540, 'MH07', 7050000, 2, 0),
	(540, 'MH08', 9190000, 4, 0),
	(540, 'MH14', 19299000, 3, 0),
	(550, 'MH06', 35500000, 2, 0)


	-- in bảng
	SELECT * FROM dbo.tblLoaiHang
	SELECT * FROM dbo.tblMatHang
	SELECT * FROM dbo.tblNhaCungCap
	SELECT * FROM dbo.tblKhachHang
	SELECT * FROM dbo.tblNhanVien
	SELECT * FROM dbo.tblDonDatHang
	SELECT * FROM dbo.tblChiTietDatHang
	SELECT * FROM dbo.tblDonNhapKho
	SELECT * FROM dbo.tblChiTietNhapKho

	--Tạo View
	--1. Tạo‌ ‌view‌ ‌chứa‌ ‌danh‌ ‌sách‌ ‌nhân‌ ‌viên‌ ‌với‌ ‌các‌ ‌thông‌ ‌tin:‌ ‌Mã Nhân Viên,‌ ‌Tên Nhân Viên,‌ Lương Cơ Bản, Phụ Cấp
	CREATE VIEW vv_dsnhanvien
	AS
	SELECT iMaNV AS [Mã Nhân Viên],sTenNV AS [Họ & Tên], fLuongCoBan AS [Lương Cơ Bản], fPhuCap AS [Phụ Cấp]
	FROM dbo.tblNhanVien

	SELECT * FROM vv_dsnhanvien

	--2. Tạo view cho biết danh sách tên hàng đã bán trong tháng 6 năm 2010
	CREATE VIEW vv_dshangban2020
	AS
	SELECT dbo.tblMatHang.sMaHang,sTenHang,dNgayDatHang,dNgayGiaoHang
	FROM dbo.tblMatHang,dbo.tblDonDatHang,dbo.tblChiTietDatHang
	WHERE dbo.tblMatHang.sMaHang = dbo.tblChiTietDatHang.sMaHang
	AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
	AND YEAR(dbo.tblDonDatHang.dNgayDatHang) = 2020
	AND MONTH(dbo.tblDonDatHang.dNgayDatHang) =06

	SELECT * FROM vv_dshangban2020

	--3. Tạo view cho biết mặt hàng có số lượng lớn hơn 200
	CREATE VIEW vv_dshangbansoluong200
	AS
	SELECT sMaHang,sTenHang,fSoLuong
	FROM dbo.tblMatHang
	WHERE fSoLuong > 200 
	
	SELECT * FROM vv_dshangbansoluong200

	--4. Tạo view chứa danh sách nhân viên nam
	CREATE VIEW vv_dsnhanviennam
	AS
	SELECT *
	FROM dbo.tblNhanVien
	WHERE sGioiTinh = N'Nam'

	SELECT * FROM vv_dsnhanviennam

	--5. Tạo view chứa danh sách mặt hàng với các thông tin: Mã Hàng, Tên Hàng, Số Lượng, Giá Hàng
	CREATE VIEW vv_dsmathang
	AS
	SELECT  sMaHang AS [Mã Hàng],sTenHang AS [Tên Hàng], fSoLuong AS [Số Lượng], fGiaHang AS [Giá Hàng]
	FROM dbo.tblMatHang

	SELECT * FROM vv_dsmathang

	--6 Tạo view cho biết thông tin mặt hàng có mã hàng là MH11
	CREATE VIEW vv_dsmathangmahangmh11
	AS
	SELECT  *
	FROM dbo.tblMatHang
	WHERE sMaHang = 'MH11'

	SELECT * FROM vv_dsmathangmahangmh11

	--7 Tạo view cho biết thông tin sản phẩm đã mua của khách hàng có số hóa đơn là 510
	CREATE VIEW vv_dsthongtinsphd510
	AS
	SELECT dbo.tblDonDatHang.iSoHD,dbo.tblKhachHang.sTenKH,dbo.tblMatHang.sTenHang,dbo.tblChiTietDatHang.iSoLuongMua
	FROM dbo.tblMatHang,dbo.tblDonDatHang,dbo.tblChiTietDatHang,dbo.tblKhachHang
	WHERE dbo.tblDonDatHang.iSoHD = 510
	AND dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
	AND dbo.tblDonDatHang.iMaKH = dbo.tblKhachHang.iMaKH
	AND dbo.tblChiTietDatHang.sMaHang = dbo.tblMatHang.sMaHang

	SELECT * FROM vv_dsthongtinsphd510

	--8 Tạo view cho biết thông tin của nhân viên có tên là Đỗ Thị Bích
	CREATE VIEW vv_dsnhanviendothibich
	AS
	SELECT *
	FROM dbo.tblNhanVien
	WHERE sTenNV = N'Đỗ Thị Bích'

	SELECT * FROM vv_dsnhanviendothibich

	--9 Tạo view cho biết số mặt hàng của từng loại hàng
	CREATE VIEW vv_dssomathang
	AS
	SELECT tblLoaiHang.sMaLoaiHang,sTenLoaiHang, COUNT(dbo.tblMatHang.sMaLoaiHang) AS [Số lượng sản phẩm], SUM(fSoLuong) AS [Tổng số lượng]
	FROM dbo.tblLoaiHang,dbo.tblMatHang
	WHERE tblLoaiHang.sMaLoaiHang = dbo.tblMatHang.sMaLoaiHang
	GROUP BY tblLoaiHang.sMaLoaiHang, sTenLoaiHang

	SELECT * FROM vv_dssomathang

	--10 Tạo view cho xem khách hàng mua hàng tổng tiền nhiều nhất
	CREATE VIEW vv_khachhangmuanhieunhat
	AS
	SELECT tblKhachHang.iMaKH,sTenKH
	FROM dbo.tblKhachHang
	WHERE iMaKH =(
					SELECT TOP 1 iMaKH
					FROM dbo.tblDonDatHang
					GROUP BY iMaKH
					ORDER BY SUM(fTongTienHD) DESC
					)

	SELECT * FROM vv_khachhangmuanhieunhat
	--11 Tạo view cho biết tổng số tiền hàng thu được trong mỗi tháng của năm 2020
	CREATE VIEW vv_tongtienhangthang2020
	AS
	SELECT tblDonDatHang.iSoHD,MONTH(dNgayGiaoHang) AS [Tháng],SUM(iSoLuongMua*fGiaBan - iSoLuongMua*fGiaBan*fMucGiamGia) AS [Tổng tiền]
	FROM dbo.tblChiTietDatHang,dbo.tblDonDatHang
	WHERE dbo.tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
	AND YEAR(dNgayGiaoHang)=2020
	GROUP BY tblDonDatHang.iSoHD,MONTH(dNgayGiaoHang)

	SELECT * FROM vv_tongtienhangthang2020

	-- 12.Tạo view thống kê tên các sản phẩm không bán được trong năm 2019
	CREATE VIEW vv_sanphamkhongbanduoc2019
	AS
	SELECT dbo.tblMatHang.sMaHang, dbo.tblMatHang.sTenHang
	FROM dbo.tblMatHang, dbo.tblDonDatHang, dbo.tblChiTietDatHang
	WHERE NOT YEAR(dNgayGiaoHang)=2019
		  AND dbo.tblDonDatHang.iSoHD= dbo.tblChiTietDatHang.iSoHD
	      AND tblChiTietDatHang.sMaHang=tblMatHang.sMaHang
	GROUP BY  dbo.tblMatHang.sMaHang, dbo.tblMatHang.sTenHang

	SELECT * FROM vv_sanphamkhongbanduoc2019

	-- 13.Tạo view cho biết tổng số mặt hàng của từng nhà cung cấp
	CREATE VIEW vv_tongmathangcuatungnhacungcap
	AS
	SELECT  dbo.tblNhaCungCap.iMaNCC, dbo.tblNhaCungCap.sTenNhaCC, COUNT(dbo.tblMatHang.fSoLuong) AS [Tổng Số Mặt Hàng]
	FROM dbo.tblMatHang, dbo.tblNhaCungCap
	WHERE dbo.tblMatHang.iMaNCC=dbo.tblNhaCungCap.iMaNCC
	GROUP BY dbo.tblNhaCungCap.iMaNCC, dbo.tblNhaCungCap.sTenNhaCC

	SELECT * FROM vv_tongmathangcuatungnhacungcap

	-- 14.Tạo view cho biết tổng tiền hàng đã nhập trong mỗi tháng của năm 2020
	CREATE VIEW vv_tongtienhangdanhap2020
	AS
	SELECT tblDonNhapKho.iSoNK,MONTH(dNgayNhapHang) AS [Tháng],SUM(fSoLuongNhap*fGiaNhap) AS [Tổng tiền]
	FROM dbo.tblChiTietNhapKho,dbo.tblDonNhapKho
	WHERE dbo.tblDonNhapKho.iSoNK = dbo.tblChiTietNhapKho.iSoNK
	AND YEAR(dNgayNhapHang)=2020
	GROUP BY dbo.tblDonNhapKho.iSoNK,MONTH(dNgayNhapHang)

	SELECT * FROM vv_tongtienhangdanhap2020

	-- 15.Tạo view cho biết tổng số lượng nhập hàng trong năm 2019
	CREATE VIEW vv_tongSLnhaphang2019
	AS
    SELECT  dbo.tblMatHang.sTenHang,SUM(dbo.tblChiTietNhapKho.fSoLuongNhap) AS [Tổng số lượng]
	FROM dbo.tblDonNhapKho, dbo.tblChiTietNhapKho, dbo.tblMatHang
	WHERE dbo.tblDonNhapKho.iSoNK=dbo.tblChiTietNhapKho.iSoNK
		AND dbo.tblChiTietNhapKho.sMaHang=dbo.tblMatHang.sMaHang
		AND YEAR(dNgayNhapHang)=2019
	GROUP BY  dbo.tblMatHang.sTenHang

	SELECT * FROM vv_tongSLnhaphang2019

	-- 16.Tạo view tính lương của từng nhân viên
	CREATE VIEW vv_luongtungNV
	AS
    SELECT sTenNV, (fLuongCoBan+fPhuCap) AS [Tổng Lương]
	FROM dbo.tblNhanVien

	SELECT * FROM vv_luongtungNV

	-- 17. Tạo view đưa ra top 5 sản phẩm doanh thu cao nhất
	CREATE VIEW vv_top5sanphamcaonhat
	AS
    SELECT *
	FROM dbo.tblMatHang 
	WHERE sMaHang IN ( SELECT TOP 5 dbo.tblMatHang.sMaHang
					FROM dbo.tblDonDatHang,dbo.tblChiTietDatHang,dbo.tblMatHang
					WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD 
					AND dbo.tblChiTietDatHang.sMaHang = tblMatHang.sMaHang
					GROUP BY tblMatHang.sMaHang
					ORDER BY SUM(iSoLuongMua*fGiaBan - iSoLuongMua*fGiaBan*fMucGiamGia) DESC		
				)

	SELECT * FROM vv_top5sanphamcaonhat

	-- 18. Hóa đơn có tổng tiền cao nhất (đơn đặt hàng)
	CREATE VIEW vv_hoadonMAX
	AS
    SELECT TOP 1 tblDonDatHang.iSoHD,SUM(iSoLuongMua*fGiaBan - iSoLuongMua*fGiaBan*fMucGiamGia) AS [Tổng tiền Max]
	FROM dbo.tblDonDatHang,dbo.tblChiTietDatHang
	WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
	GROUP BY tblDonDatHang.iSoHD
	ORDER BY SUM(iSoLuongMua*fGiaBan-iSoLuongMua*fGiaBan*fMucGiamGia) DESC

	SELECT * FROM vv_hoadonMAX

	-- 19. Tạo view cho biết số lượng và tổng tiền đã bán của từng sản phẩm trong năm 2020
		CREATE VIEW vv_soluongvatongtiensp2020
	AS
    SELECT tblMatHang.sMaHang,SUM(iSoLuongMua) AS [Tổng số lượng],SUM(iSoLuongMua*fGiaBan - iSoLuongMua*fGiaBan*fMucGiamGia) AS [Tổng tiền Max]
	FROM dbo.tblDonDatHang,dbo.tblChiTietDatHang,dbo.tblMatHang
	WHERE dbo.tblDonDatHang.iSoHD = dbo.tblChiTietDatHang.iSoHD
	AND tblMatHang.sMaHang = tblChiTietDatHang.sMaHang
	GROUP BY tblMatHang.sMaHang

	SELECT * FROM vv_soluongvatongtiensp2020

	-- 20. Tạo view nhân viên làm việc trên 2 năm
	CREATE VIEW vv_nhanvienlamtren2nam
	AS
	SELECT *
	FROM dbo.tblNhanVien
	WHERE DATEDIFF(YEAR,dNgayVaoLam,GETDATE()) >=2

	SELECT * FROM vv_nhanvienlamtren2nam
