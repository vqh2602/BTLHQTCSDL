--a7: phân quyền và bảo mật dữ liệu
	--1. Tài Khoản Quản Lý
	CREATE LOGIN Quanli WITH PASSWORD = '123456'
	CREATE USER quanli01 FOR LOGIN Quanli

	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblNhanVien TO quanli01
	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblMatHang TO quanli01
	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblNhaCungCap TO quanli01
	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblKhachHang TO quanli01

	GRANT EXECUTE ON dbo.sptimnhanvien_tennhanvien TO quanli01
	GRANT EXECUTE ON dbo.spluongnhanvien_maNV TO quanli01
	GRANT EXECUTE ON dbo.sptangluongcoban_nhanvien TO quanli01
	GRANT EXECUTE ON dbo.spthongkesanpham_nhacungcap TO quanli01
	GRANT EXECUTE ON dbo.spgiohang_khachhang TO quanli01
	GRANT EXECUTE ON dbo.sp_tongtiennhaphang1nam TO quanli01
	GRANT EXECUTE ON dbo.sptienhang1nam TO quanli01
	GRANT EXECUTE ON dbo.spdoanhso1mathang1nam TO quanli01
	GRANT EXECUTE ON dbo.dskhongduocban2020 TO quanli01
	GRANT EXECUTE ON dbo.sptongtienhangban_thang TO quanli01

	GO
    	--2. Tài Khoản Nhân viên Nhập Kho
	CREATE LOGIN NhanvienNK WITH PASSWORD = '123456'
	CREATE USER nhanvienNK FOR LOGIN NhanvienNK

	DENY UPDATE,SELECT,INSERT,DELETE ON dbo.tblNhanVien TO nhanvienNK
	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblMatHang TO nhanvienNK
	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblDonNhapKho TO nhanvienNK
	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblChiTietNhapKho TO nhanvienNK

	GRANT EXECUTE ON dbo.spthemHD TO nhanvienNK
	GRANT EXECUTE ON dbo.spthongkenhapkho_nhanvien TO nhanvienNK

	    	--2. Tài Khoản Nhân viên Bán Hàng
	CREATE LOGIN NhanvienBH WITH PASSWORD = '123456'
	CREATE USER nhanvienBH FOR LOGIN NhanvienBH

	DENY UPDATE,SELECT,INSERT,DELETE ON dbo.tblNhanVien TO nhanvienBH
	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblMatHang TO nhanvienBH
	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblDonDatHang TO nhanvienBH
	GRANT UPDATE,SELECT,INSERT,DELETE ON dbo.tblChiTietDatHang TO nhanvienBH

	GRANT EXECUTE ON dbo.spmucgiamgia_dondathang TO nhanvienBH
	GRANT EXECUTE ON dbo.spthongkebanhang_nhanvien TO nhanvienBH
	GRANT EXECUTE ON dbo.sptongtienhangban_thang TO nhanvienBH

	--3. Tài Khoản Khách Hàng
	CREATE LOGIN KhachHang WITH PASSWORD = '123456'
	CREATE USER khachhang FOR LOGIN KhachHang
	GRANT UPDATE,SELECT,INSERT ON dbo.tblKhachHang TO khachhang
	GRANT EXECUTE ON dbo.spgiohang_khachhang TO khachhang
