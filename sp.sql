CREATE PROCEDURE CursorLoaiGD
    @OutCrsr CURSOR VARYING OUTPUT, 
    @macp NCHAR( 7), @ngay NVARCHAR( 10),  @LoaiGD CHAR 
AS
SET DATEFORMAT DMY 
IF (@LoaiGD='M') 
    SET @OutCrsr=CURSOR KEYSET FOR 
    SELECT ngayDAT, SOLUONG, GIADAT, ID FROM LENHDAT 
    WHERE MACP=@macp 
        AND DAY(ngayDAT)=DAY(@ngay)AND MONTH(ngayDAT)= MONTH(@ngay) AND YEAR(ngayDAT)=YEAR(@ngay)  
        AND LOAIGD=@LoaiGD AND SOLUONG >0  
    ORDER BY GIADAT DESC, ngayDAT 
ELSE
    SET @OutCrsr=CURSOR KEYSET FOR 
    SELECT ngayDAT, SOLUONG, GIADAT, ID FROM LENHDAT 
    WHERE MACP=@macp 
        AND DAY(ngayDAT)=DAY(@ngay)AND MONTH(ngayDAT)= MONTH(@ngay) AND YEAR(ngayDAT)=YEAR(@ngay)  
        AND LOAIGD=@LoaiGD AND SOLUONG >0  
    ORDER BY GIADAT, ngayDAT 
OPEN @OutCrsr
GO


CREATE PROCEDURE CursorLenhKhop
    @OutCrsr CURSOR VARYING OUTPUT, 
    @macp NCHAR( 7), @ngay NVARCHAR( 10)
AS
    SET DATEFORMAT DMY 
    SET @OutCrsr=CURSOR KEYSET FOR 
    SELECT K.soluongkhop, K.giakhop 
    FROM LENHDAT D, LENHKHOP K
    WHERE D.ID = K.idlenhdat AND D.macp = @macp
        AND DAY(K.ngaykhop)=DAY(@ngay)AND MONTH(K.ngaykhop)= MONTH(@ngay) AND YEAR(K.ngaykhop)=YEAR(@ngay)  
    ORDER BY K.ngaykhop DESC
    OPEN @OutCrsr
GO


CREATE PROCEDURE SP_DUYETBAOCAO
AS
    DELETE FROM dbo.BAOCAO
    WHERE DAY(THOIGIAN) <> DAY(GETDATE()) OR MONTH(THOIGIAN) <> MONTH(GETDATE()) OR YEAR(THOIGIAN) <> YEAR(GETDATE())
GO


CREATE PROCEDURE SP_LAMSACHBAOCAO
    @macp NCHAR(7)
AS
    DELETE FROM dbo.BAOCAO WHERE macp = @macp
    INSERT INTO dbo.BAOCAO(macp) VALUES (@macp)
GO

CREATE PROCEDURE SP_CAPNHATTONGKL
    @macp NCHAR(7), @ngay NVARCHAR(10), @klban INT
AS
    SET DATEFORMAT DMY
    DECLARE @tongkl INT
    SET @tongkl = (SELECT SUM(K.soluongkhop)
                FROM LENHKHOP K, LENHDAT D
                WHERE D.ID = K.idlenhdat AND D.macp = @macp
                    AND DAY(K.ngaykhop)=DAY(@ngay)AND MONTH(K.ngaykhop)= MONTH(@ngay) AND YEAR(K.ngaykhop)=YEAR(@ngay) )
    
    IF(ISNULL(@tongkl, -1) <> -1 OR ISNULL(@klban, -1) <> -1)
    BEGIN
        UPDATE dbo.BAOCAO
        SET tongkl = ISNULL(@tongkl, 0) + ISNULL(@klban, 0)
        WHERE macp = @macp
    END
GO

CREATE PROCEDURE SP_THAYDOIBAOCAO
    @macp NCHAR(7)
AS
    DECLARE @ngay VARCHAR(10), @CrsrVar CURSOR, 
    @ngaydat NVARCHAR(10), @soluong INT, 
    @giadat FLOAT, @id INT, @STT INT,
    @muatran FLOAT, @muasan FLOAT, @muatb FLOAT,
    @bantran FLOAT, @bansan FLOAT, @bantb FLOAT,
    @dumua INT, @duban INT, @CrsrLK CURSOR, @CrsrMua CURSOR

    EXEC SP_DUYETBAOCAO
    EXEC SP_LAMSACHBAOCAO @macp

    SET DATEFORMAT DMY
    SET @ngay = (SELECT CONVERT(VARCHAR, GETDATE(), 105))
    SET @STT = 1

    -- XU LY LENH BAN

    -- XY LY CAC THUOC TINH: BAN TRAN, BAN SAN, DU BAN, GIABAN1, GIABAN2, GIABAN3, KLBAN1, KLBAN2, KLBAN3
    EXEC CursorLoaiGD  @CrsrVar OUTPUT, @macp, @ngay, 'B'
    FETCH NEXT FROM @CrsrVar INTO  @ngaydat , @soluong , @giadat, @id
    WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        IF(@STT = 1)
        BEGIN
            SET @bantran = @giadat
            SET @bansan = @giadat
            SET @duban = @soluong

            UPDATE dbo.BAOCAO
            SET giaban1 = @giadat, klban1 = @soluong
            WHERE macp = @macp
        END

        ELSE
        BEGIN
            IF(@bantran < @giadat)
                SET @bantran = @giadat
            
            SET @duban = @duban + @soluong

            IF(@STT = 2)
            BEGIN
                UPDATE dbo.BAOCAO
                SET giaban2 = @giadat, klban2 = @soluong
                WHERE macp = @macp
            END

            IF(@STT = 3)
            BEGIN
                UPDATE dbo.BAOCAO
                SET giaban3 = @giadat, klban3 = @soluong
                WHERE macp = @macp
            END
        END

        SET @STT = @STT + 1
        FETCH NEXT FROM @CrsrVar INTO  @ngaydat , @soluong , @giadat, @id
    END

    -- CAP NHAT DU BAN
    UPDATE dbo.BAOCAO
    SET duban = @duban
    WHERE macp = @macp

    -- GIAI PHONG DUNG LUONG CURSOR BAN
    CLOSE @CrsrVar
    DEALLOCATE @CrsrVar

    -- XY LY LENH MUA
    -- XY LY CAC THUOC TINH: MUA TRAN, MUA SAN, DU MUA, GIAMUA1, GIAMUA2, GIAMUA3, KLMUA1, KLMUA2, KLMUA3
    EXEC CursorLoaiGD  @CrsrMua OUTPUT, @macp, @ngay, 'M'
    SET @STT = 1
    FETCH NEXT FROM @CrsrMua INTO  @ngaydat , @soluong , @giadat, @id
    WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        IF(@STT = 1)
        BEGIN
            SET @muatran = @giadat
            SET @muasan = @giadat
            SET @dumua = @soluong

            UPDATE dbo.BAOCAO
            SET giamua1 = @giadat, klmua1 = @soluong
            WHERE macp = @macp
        END

        ELSE
        BEGIN
            IF(@muasan > @giadat)
                SET @muasan = @giadat
            
            SET @dumua = @dumua + @soluong

            IF(@STT = 2)
            BEGIN
                UPDATE dbo.BAOCAO
                SET giamua2 = @giadat, klmua2 = @soluong
                WHERE macp = @macp
            END

            IF(@STT = 3)
            BEGIN
                UPDATE dbo.BAOCAO
                SET giamua3 = @giadat, klmua3 = @soluong
                WHERE macp = @macp
            END
        END

        SET @STT = @STT + 1

        FETCH NEXT FROM @CrsrMua INTO  @ngaydat , @soluong , @giadat, @id
    END

    -- CAP NHAT DU MUA
    UPDATE dbo.BAOCAO
    SET dumua = @dumua
    WHERE macp = @macp

    -- GIAI PHONG DUNG LUONG CURSOR MUA
    CLOSE @CrsrMua
    DEALLOCATE @CrsrMua

    -- XU LY TINH TOAN TRUNG BINH, TRAN SAN, TONG KHOI LUONG, GIA KHOP LENH
    EXEC CursorLenhKhop  @CrsrLK OUTPUT, @macp, @ngay
    SET @STT = 1
    FETCH NEXT FROM @CrsrLK INTO  @soluong , @giadat
    WHILE (@@FETCH_STATUS <> -1)
    BEGIN
        IF(@STT = 1)
        BEGIN
            UPDATE dbo.BAOCAO
            SET giakhoplenh = @giadat, klkhoplenh = @giadat
            WHERE macp = @macp
        END

        IF(@muatran < @giadat)
            SET @muatran = @giadat
        
        IF(@muasan > @giadat)
            SET @muasan = @giadat

        IF(@bansan > @giadat)
            SET @bansan = @giadat

        IF(@bantran < @giadat)
            SET @bantran = @giadat

        SET @STT = @STT + 1

        FETCH NEXT FROM @CrsrLK INTO  @soluong , @giadat
    END

    -- GIAI PHONG DUNG LUONG CURSOR KHOP LENH
    CLOSE @CrsrLK
    DEALLOCATE @CrsrLK

    -- UPDATE TRONG BANG BAO CAO
    IF(ISNULL(@muatran, -1) <> -1)
    BEGIN
        UPDATE dbo.BAOCAO
        SET tc = ((@muasan + @muatran) / 2), [tran] = @muatran, san = @muasan
        WHERE macp = @macp
    END

    IF(ISNULL(@bantran, -1) <> -1)
    BEGIN
        UPDATE dbo.BAOCAO
        SET tb = ((@bansan + @bantran) / 2), cao = @bantran, thap = @bansan
        WHERE macp = @macp
    END
    EXEC SP_CAPNHATTONGKL @macp, @ngay, @duban
GO




CREATE PROC SP_KHOPLENH_LO
    @macp NCHAR( 7), @ngay NVARCHAR( 10),  @LoaiGD CHAR, 
    @soluongMB INT, @giadatMB FLOAT, @idhientai INT 
AS
SET DATEFORMAT DMY
DECLARE @CrsrVar CURSOR , @ngaydat NVARCHAR( 10), @soluong INT, @giadat FLOAT,  @soluongkhop INT, @giakhop FLOAT, @id INT
IF (@LoaiGD='B')
    EXEC CursorLoaiGD  @CrsrVar OUTPUT, @macp,@ngay, 'M'
ELSE 
    EXEC CursorLoaiGD  @CrsrVar OUTPUT, @macp,@ngay, 'B'
  
FETCH NEXT FROM @CrsrVar  INTO  @ngaydat , @soluong , @giadat, @id
--SELECT @ngaydat , @soluong , @giadat, @id
WHILE (@@FETCH_STATUS <> -1 AND @soluongMB >0)
BEGIN
    IF  (@LoaiGD='B' )
    -- GIA BAN NHO HON HOAC BANG GIA MUA
    -- BAN CO PHIEU VOI GIA BANG GIA MUA
    BEGIN
        IF  (@giadatMB <= @giadat)
        BEGIN
        -- NEU SO LUONG BAN NHIEU HON SO LUONG MUA
        -- SE DUYET TIEP
            IF @soluongMB > @soluong
            BEGIN
                SET @soluongkhop = @soluong
                SET @giakhop = @giadat
                SET @soluongMB = @soluongMB - @soluong
                SET @soluong = 0

                UPDATE dbo.LENHDAT  
                SET SOLUONG = 0
                WHERE CURRENT OF @CrsrVar

                INSERT INTO dbo.LENHKHOP (soluongkhop, giakhop, idlenhdat)
                VALUES (@soluongkhop, @giakhop, @id)

            END

            IF @soluongMB <= @soluong AND @soluong > 0
            BEGIN
                SET @soluongkhop = @soluongMB
                SET @giakhop = @giadat
        
                UPDATE dbo.LENHDAT  
                SET SOLUONG = SOLUONG - @soluongMB
                WHERE CURRENT OF @CrsrVar
                SET @soluongMB = 0

                INSERT INTO dbo.LENHKHOP (soluongkhop, giakhop, idlenhdat)
                VALUES (@soluongkhop, @giakhop, @id)
            END
        END

        ELSE
            GOTO THOAT
    END

    -- LOAI GD MUA
    IF  (@LoaiGD='M' )
    BEGIN
        IF  (@giadatMB >= @giadat)
        BEGIN
            IF @soluongMB > @soluong
            BEGIN
                SET @soluongkhop = @soluong
                SET @giakhop = @giadat
                SET @soluongMB = @soluongMB - @soluong
                SET @soluong = 0

                UPDATE dbo.LENHDAT  
                SET SOLUONG = 0
                WHERE CURRENT OF @CrsrVar

                INSERT INTO dbo.LENHKHOP (soluongkhop, giakhop, idlenhdat)
                VALUES (@soluongkhop, @giakhop, @id)

            END

            IF @soluongMB <= @soluong AND @soluong > 0
            BEGIN
                SET @soluongkhop = @soluongMB
                SET @giakhop = @giadat
        
                UPDATE dbo.LENHDAT  
                SET SOLUONG = SOLUONG - @soluongkhop
                WHERE CURRENT OF @CrsrVar
                SET @soluongMB = 0

                INSERT INTO dbo.LENHKHOP (soluongkhop, giakhop, idlenhdat)
                VALUES (@soluongkhop, @giakhop, @id)
            END
        END

        ELSE 
            GOTO THOAT
    END

    FETCH NEXT FROM @CrsrVar INTO  @ngaydat , @soluong , @giadat, @id

END
THOAT: 
    CLOSE @CrsrVar
    DEALLOCATE @CrsrVar

    UPDATE dbo.LENHDAT
    SET soluong = @soluongMB
    WHERE id = @idhientai

GO

CREATE TRIGGER TRG_DATLENH on LENHDAT
AFTER INSERT
AS
BEGIN
    DECLARE @macp NCHAR(7), @ngay VARCHAR(10), @LoaiGD CHAR, @soluongMB INT, @giadatMB FLOAT 
    SELECT @macp = macp, @ngay = CONVERT(VARCHAR, ngaydat, 105), @LoaiGD = loaigd, @soluongMB = soluong, @giadatMB = giadat
    FROM inserted
    EXEC SP_KHOPLENH_LO @macp, @ngay, @LoaiGD, @soluongMB, @giadatMB
    EXEC SP_THAYDOIBAOCAO @macp
END