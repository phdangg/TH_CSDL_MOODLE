USE QLDeTai

--Q35
SELECT MAX(LUONG) AS LUONGLONNHAT
FROM GIAOVIEN GV

--Q36
SELECT HOTEN AS GV_LUONGCAONHAT
FROM GIAOVIEN
WHERE LUONG = (SELECT MAX(LUONG)
				FROM GIAOVIEN GV)
				
--Q37
SELECT MAX(T.LUONG) AS LUONGCAONHAT_HTTT
FROM (SELECT HOTEN,LUONG
		FROM GIAOVIEN
		WHERE MABM = 'HTTT') AS T
	
--Q38
SELECT HOTEN
FROM GIAOVIEN
WHERE YEAR(NGAYSINH) = (SELECT MIN(YEAR(NGAYSINH)) 
						FROM GIAOVIEN)

--Q39
SELECT HOTEN
FROM GIAOVIEN
WHERE YEAR(NGAYSINH) = (SELECT MIN(YEAR(GV.NGAYSINH)) 
						FROM GIAOVIEN GV,BOMON BM,KHOA KH
						WHERE GV.MABM = BM.MABM AND BM.MAKHOA = KH.MAKHOA 
							AND KH.TENKHOA = N'Công nghệ thông tin')
							
--Q40
SELECT T.HOTEN, T.TENKHOA 
FROM (SELECT  GV.HOTEN,KH.TENKHOA,GV.LUONG
		FROM GIAOVIEN GV,BOMON BM,KHOA KH
		WHERE GV.MABM = BM.MABM AND BM.MAKHOA = KH.MAKHOA) AS T
WHERE T.LUONG = (SELECT MAX(LUONG)
				FROM GIAOVIEN GV)
				
--Q41
SELECT BM.TENBM, GV.HOTEN AS GV_LUONGCAONHAT
FROM GIAOVIEN GV, BOMON BM
WHERE GV.MABM = BM.MABM AND 
	GV.LUONG >= ALL(SELECT MAX(GV2.LUONG)
				FROM BOMON BM2, GIAOVIEN GV2
				WHERE GV2.MABM = GV.MABM)
				
				
--Q42
SELECT DT.TENDT AS TENDT_GVKHONGTG
FROM DETAI DT
WHERE DT.MADT NOT IN (SELECT TG.MADT
						FROM THAMGIADT TG, GIAOVIEN GV
						WHERE TG.MAGV = GV.MAGV AND GV.HOTEN = N'Nguyễn Hoài An')				
--Q43
SELECT DT.TENDT AS TENDT_GVKHONGTG, GV.HOTEN AS CHUNHIEM_DETAI
FROM DETAI DT, GIAOVIEN GV
WHERE GV.MAGV = DT.GVCNDT AND DT.MADT NOT IN (SELECT TG.MADT
						FROM THAMGIADT TG, GIAOVIEN GV
						WHERE TG.MAGV = GV.MAGV AND GV.HOTEN = N'Nguyễn Hoài An')

--Q44
SELECT GVCNTT.MAGV,GVCNTT.HOTEN AS GV_KHOACNTT
FROM (SELECT GV.MAGV, GV.HOTEN
		FROM GIAOVIEN GV,BOMON BM,KHOA KH
		WHERE GV.MABM = BM.MABM AND BM.MAKHOA = KH.MAKHOA 
							AND KH.TENKHOA = N'Công nghệ thông tin') AS GVCNTT
WHERE GVCNTT.MAGV NOT IN (SELECT DISTINCT TG.MAGV
						FROM THAMGIADT TG)

--Q45
SELECT GV.MAGV, GV.HOTEN AS GV_KHONGTGDT
FROM GIAOVIEN GV
WHERE GV.MAGV NOT IN (SELECT DISTINCT MAGV
						FROM THAMGIADT)
						
--Q46
SELECT HOTEN AS GV_LUONGLONHON
FROM GIAOVIEN
WHERE LUONG > (SELECT LUONG
				FROM GIAOVIEN
				WHERE HOTEN = N'Nguyễn Hoài An')
				
--Q47
SELECT GV.MAGV, GV.HOTEN AS GV_TRUONGBM
FROM GIAOVIEN GV,BOMON BM
WHERE GV.MAGV = BM.TRUONGBM AND BM.TRUONGBM IN (SELECT DISTINCT MAGV
						FROM THAMGIADT)

--Q48
SELECT GV1.HOTEN AS GV_CUNGTENTRONGBM
 FROM GIAOVIEN GV1, GIAOVIEN GV2
 WHERE GV1.HOTEN = GV2.HOTEN AND GV2.PHAI = GV1.PHAI  AND GV1.MAGV != GV2.MAGV AND GV1.MABM = GV2.MABM
 
 --Q49
SELECT GV.HOTEN
FROM GIAOVIEN GV
WHERE GV.LUONG > (SELECT MIN(GV2.LUONG)
					FROM GIAOVIEN GV2, BOMON BM
					WHERE GV2.MABM = BM.MABM AND BM.TENBM = N'Công nghệ phần mềm')

--Q50
SELECT GV.HOTEN
FROM GIAOVIEN GV,BOMON BM
WHERE GV.MABM = BM.MABM AND BM.TENBM != N'Hệ thống thông tin' AND 
		GV.LUONG >= ALL (SELECT GV1.LUONG
       FROM GIAOVIEN GV1, BOMON BM
       WHERE GV1.MABM = BM.MABM AND BM.TENBM = N'Hệ thống thông tin')
	
	
--Q51
SELECT KH.TENKHOA AS KHOA_DONGNHAT, COUNT(*) AS SLGV
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
	JOIN KHOA KH ON BM.MAKHOA = KH.MAKHOA
GROUP BY KH.TENKHOA
HAVING COUNT(*) >= ALL 
				(SELECT COUNT(*)
				FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
					JOIN KHOA KH ON BM.MAKHOA = KH.MAKHOA
				GROUP BY KH.TENKHOA)
				
--Q52
SELECT GV.HOTEN AS GVCNDT_NHIEUNHAT, COUNT(*) AS SLDT
FROM GIAOVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
GROUP BY GV.MAGV,GV.HOTEN
HAVING COUNT(*) >= ALL
					(SELECT COUNT(*)
					FROM DETAI DT
					GROUP BY DT.GVCNDT)

--Q53
SELECT MABM
FROM GIAOVIEN
GROUP BY MABM
HAVING COUNT(*) >= ALL ( SELECT COUNT(*)
						FROM GIAOVIEN GV
						GROUP BY GV.MABM)
--Q54
SELECT GV.HOTEN, BM.TENBM, COUNT(*) AS SLDT_THAMGIA
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV,BOMON BM
WHERE BM.MABM = GV.MABM
GROUP BY GV.HOTEN,BM.TENBM
HAVING COUNT(*) >= ALL
					(SELECT COUNT(*)
					FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
					GROUP BY GV.MAGV)

--Q55
SELECT GV.HOTEN, BM.TENBM, COUNT(*) AS SLDT_THAMGIA
FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV,BOMON BM
WHERE BM.MABM = GV.MABM AND BM.MABM = 'HTTT'
GROUP BY GV.HOTEN,BM.TENBM
HAVING COUNT(*) >= ALL
					(SELECT COUNT(*)
					FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
						JOIN BOMON BM ON GV.MABM = BM.MABM
					WHERE BM.MABM = 'HTTT'
					GROUP BY GV.MAGV)

--Q56
SELECT GV.MAGV, GV.HOTEN, BM.TENBM,COUNT(*) SL_NGUOITHAN
FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
	JOIN NGUOITHAN NT ON NT.MAGV = GV.MAGV
GROUP BY GV.MAGV,GV.HOTEN,BM.TENBM
HAVING COUNT(*) >= ALL
				(SELECT COUNT(*)
				FROM GIAOVIEN GV JOIN BOMON BM ON GV.MABM = BM.MABM
					JOIN NGUOITHAN NT ON NT.MAGV = GV.MAGV
				GROUP BY GV.MAGV,GV.HOTEN,BM.TENBM)

--Q57
SELECT GV.MAGV,GV.HOTEN AS TRUONGBM_CNDT_NHIEUNHAT, COUNT(*) AS SLDT
FROM GIAOVIEN GV JOIN DETAI DT ON GV.MAGV = DT.GVCNDT
	JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
GROUP BY GV.MAGV,GV.HOTEN
HAVING COUNT(*) >= ALL
					(SELECT COUNT(*)
					FROM DETAI DT JOIN BOMON BM ON DT.GVCNDT = BM.TRUONGBM
					GROUP BY DT.GVCNDT)