--a6: Xây dựng các trigger
	--1. Giá bán phải lớn hơn hoặc bằng giá hàng
	CREATE TRIGGER tg_kiemTraGiaBan
	ON dbo.tblChiTietDatHang
	AFTER INSERT, UPDATE
	AS
	BEGIN
    DECLARE @giaBan FLOAT, @giaHang FLOAT, @maHang VARCHAR(20)

		SELECT @giaBan = fGiaBan, @maHang = sMaHang FROM Inserted
		SELECT @giaHang = fGiaHang FROM dbo.tblMatHang WHERE @maHang = sMaHang

		IF(@giaBan < @giaHang)
		BEGIN
		    PRINT N'Giá bán phải lớn hơn hoặc bằng giá hàng'
				ROLLBACK TRAN
		END
	END


	--2. kiẻm tra giới tính
	CREATE TRIGGER tg_kiemtragioitinh
	ON dbo.tblNhanVien
	AFTER INSERT, UPDATE 
	AS 
		BEGIN 
			DECLARE @gioitinh NVARCHAR(5)
			SELECT @gioitinh = sGioiTinh FROM inserted
			IF(@gioitinh != N'Nam' and @gioitinh != N'Nữ')
				BEGIN
					RAISERROR('Giới Tính Không Hợp Lệ!',16,10)
					ROLLBACK TRAN
				END
		END
GO 

 --3. Kiểm tra ngày nhập hàng đúng không
	CREATE TRIGGER tg_kiemTraNgayNhapHang
	ON tblDonNhapKho
	AFTER INSERT, UPDATE 
	AS 
	BEGIN
    DECLARE @ngayNhapHang DATETIME
		SELECT @ngayNhapHang = dNgayNhapHang FROM Inserted

		IF(@ngayNhapHang > GETDATE())
		BEGIN
		    PRINT N'Ngày nhập hàng không đc lớn hơn ngày hiện tại'
				ROLLBACK TRAN
		END
	END
	--4Kiểm tra ngày vào làm xem hợp lý không
	CREATE TRIGGER tg_kiemTraNgayVaoLam
	ON tblNhanVien
	AFTER INSERT, UPDATE 
	AS 
	BEGIN
    DECLARE @ngayVaoLam DATETIME
		SELECT @ngayVaoLam = dNgayVaoLam FROM Inserted

		IF(@ngayVaoLam > GETDATE())
		BEGIN
		    PRINT N'Ngày vào làm không đc lớn hơn ngày hiện tại'
				ROLLBACK TRAN
		END
	END



	--5. Đảm bảo số lượng hàng bán không vượt số hiện có và nếu bán thì số lượng hàng trong kho sẽ giảm
	CREATE TRIGGER tg_kiemtrahangban
	ON dbo.tblChiTietDatHang
	INSTEAD OF INSERT,UPDATE 
	AS 
		BEGIN 
			DECLARE @soluongmua FLOAT 
			DECLARE @smahang VARCHAR(20)
			DECLARE @soluongkho FLOAT
			SELECT @soluongmua = iSoLuongMua,@smahang = sMaHang FROM Inserted
			SELECT @soluongkho = (SELECT fSoLuong
									FROM dbo.tblMatHang
									WHERE @smahang = sMaHang
								 )
			IF(@soluongmua > @soluongkho)
				BEGIN
					PRINT('So Luong Mua Vuot Qua So Luong Trong Kho')
					ROLLBACK TRAN
				END
			ELSE
				BEGIN
					UPDATE dbo.tblMatHang
					SET fSoLuong = fSoLuong-@soluongmua
					WHERE sMaHang = @smahang
				END
			END 
GO 

 --6.Cập nhật lại số lượng hàng tồn kho khi khách hàng hủy đặt một mặt hàng
 	CREATE TRIGGER tg_xoachitietdathang
	ON dbo.tblChiTietDatHang
	AFTER DELETE
	AS 
		BEGIN 
			DECLARE @soluongmua FLOAT 
			DECLARE @smahang VARCHAR(20)
			DECLARE @soluongkho FLOAT
			SELECT @soluongmua = iSoLuongMua,@smahang = sMaHang FROM Deleted
			SELECT @soluongkho = (SELECT fSoLuong
									FROM dbo.tblMatHang
									WHERE @smahang = sMaHang
								 )
				BEGIN
					UPDATE dbo.tblMatHang
					SET fSoLuong = fSoLuong+@soluongmua
					WHERE sMaHang = @smahang
				END
			END 
GO 

 --7. Cập nhật số lượng hàng tồn kho khi nhập thêm mặt hàng
	CREATE TRIGGER tg_themChiTietDatHang
	ON dbo.tblChiTietDatHang
	AFTER INSERT 
	AS 
	BEGIN 
		DECLARE @soLuongMua FLOAT, @maHang VARCHAR(20), @soLuongKho FLOAT
		SELECT @soLuongMua = iSoLuongMua, @maHang = sMaHang FROM Inserted
		SELECT @soLuongKho = fSoLuong FROM dbo.tblMatHang WHERE @maHang = sMaHang
							
		BEGIN
		UPDATE dbo.tblMatHang
		SET fSoLuong = fSoLuong - @soLuongMua
		WHERE sMaHang = @maHang
		END
	END 
	--8 Cập nhật tổng tiền của hóa đơn khi đặt thêm hàng
	CREATE TRIGGER tg_tongTienHoaDon_insert
	ON tblChiTietDatHang
	AFTER INSERT 
	AS 
	BEGIN
		DECLARE @soHD INT, @giaMuaHang FLOAT
		SELECT 
			@giaMuaHang = (fGiaBan * iSoLuongMua * (1 - fMucGiamGia)), 
			@soHD = iSoHD FROM Inserted

		BEGIN
		    UPDATE dbo.tblDonDatHang
			SET fTongTienHD = fTongTienHD + @giaMuaHang
			WHERE @soHD = iSoHD
		END
	END


	--9.Cập nhật tổng tiền của hóa đơn khi khách hàng hủy đặt mặt hàng
	CREATE TRIGGER tg_tongtienhoadon_delete
	ON dbo.tblChiTietDatHang
	AFTER DELETE
	AS
		BEGIN
			DECLARE @iSohd INT
			DECLARE @giahangmua FLOAT
			SELECT @giahangmua = (fGiaBan * iSoLuongMua - fGiaBan * iSoLuongMua*fMucGiamGia),@iSohd = iSoHD FROM Deleted
			BEGIN
				UPDATE dbo.tblDonDatHang
				SET fTongTienHD = fTongTienHD-@giahangmua
				WHERE iSoHD = @iSohd
			END 
		END
go
		--10. Cập nhật số lượng hàng nhập của một hóa đơn nhập kho khi nhập mới
		CREATE TRIGGER tg_capnhatdonnhapkho_soluong
		ON dbo.tblChiTietNhapKho
		INSTEAD OF INSERT
		AS
			BEGIN
				DECLARE @slnhap FLOAT, @sonk INT 
				SELECT @slnhap = fSoLuongNhap,@sonk = iSoNK FROM Inserted
				BEGIN
					UPDATE dbo.tblDonNhapKho
					SET fTongSoLuong = fTongSoLuong + @slnhap
					WHERE @sonk = iSoNK
				END
			END
GO 
