-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for ci_penjualan
CREATE DATABASE IF NOT EXISTS `ci_penjualan` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ci_penjualan`;

-- Dumping structure for table ci_penjualan.barang_harga
CREATE TABLE IF NOT EXISTS `barang_harga` (
  `kode_barang` char(5) NOT NULL,
  `harga` int NOT NULL,
  `stok` int NOT NULL,
  `kode_cabang` char(3) NOT NULL,
  `kode_harga` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`kode_barang`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table ci_penjualan.barang_harga: 4 rows
/*!40000 ALTER TABLE `barang_harga` DISABLE KEYS */;
REPLACE INTO `barang_harga` (`kode_barang`, `harga`, `stok`, `kode_cabang`, `kode_harga`) VALUES
	('BR003', 29000, 93, 'B00', 'BR003B00'),
	('BR009', 100000, 5, 'B00', 'BR009B00'),
	('BR011', 89000, 4, 'T00', 'BR011T00'),
	('BR010', 140000, 35, 'T00', 'BR010T00');
/*!40000 ALTER TABLE `barang_harga` ENABLE KEYS */;

-- Dumping structure for table ci_penjualan.barang_master
CREATE TABLE IF NOT EXISTS `barang_master` (
  `kode_barang` varchar(5) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `satuan` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`kode_barang`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table ci_penjualan.barang_master: 5 rows
/*!40000 ALTER TABLE `barang_master` DISABLE KEYS */;
REPLACE INTO `barang_master` (`kode_barang`, `nama_barang`, `satuan`) VALUES
	('BR011', 'Slim Fit', 'pcs'),
	('BR010', 'Jeans', 'pcs'),
	('BR003', 'kaos', 'pcs'),
	('BR009', 'POLO Shirt', 'pcs'),
	('BR012', 'Jacket', 'pcs');
/*!40000 ALTER TABLE `barang_master` ENABLE KEYS */;

-- Dumping structure for table ci_penjualan.bulan
CREATE TABLE IF NOT EXISTS `bulan` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bulan` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table ci_penjualan.bulan: ~12 rows (approximately)
REPLACE INTO `bulan` (`id`, `bulan`) VALUES
	(1, 'Januari'),
	(2, 'Februari'),
	(3, 'Maret'),
	(4, 'April'),
	(5, 'Mei'),
	(6, 'Juni'),
	(7, 'Juli'),
	(8, 'Agustus'),
	(9, 'September'),
	(10, 'Oktober'),
	(11, 'November'),
	(12, 'Desember');

-- Dumping structure for table ci_penjualan.cabang
CREATE TABLE IF NOT EXISTS `cabang` (
  `kode_cabang` char(3) NOT NULL,
  `nama_cabang` varchar(50) NOT NULL,
  `alamat_cabang` varchar(255) DEFAULT NULL,
  `telepon` varbinary(13) DEFAULT NULL,
  PRIMARY KEY (`kode_cabang`),
  KEY `kode_cab_idx` (`kode_cabang`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table ci_penjualan.cabang: 2 rows
/*!40000 ALTER TABLE `cabang` DISABLE KEYS */;
REPLACE INTO `cabang` (`kode_cabang`, `nama_cabang`, `alamat_cabang`, `telepon`) VALUES
	('B00', 'Sakti Aparel', 'Indonesiaa', _binary 0x3038313133343537383439),
	('T00', 'Triadi Aparel', 'Dani,Karangpandan', _binary 0x303838333435353433343535);
/*!40000 ALTER TABLE `cabang` ENABLE KEYS */;

-- Dumping structure for table ci_penjualan.historibayar
CREATE TABLE IF NOT EXISTS `historibayar` (
  `nobukti` varchar(14) NOT NULL,
  `no_faktur` varchar(13) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `tglbayar` date NOT NULL,
  `bayar` int NOT NULL,
  `id_admin` smallint NOT NULL,
  `no_fak_penj` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `id_user` int DEFAULT NULL,
  PRIMARY KEY (`nobukti`),
  KEY `hb_tglbayar_jenis` (`tglbayar`),
  KEY `hb_nofaktur` (`no_faktur`) USING BTREE,
  KEY `no_fake` (`no_fak_penj`),
  KEY `id_user` (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table ci_penjualan.historibayar: 19 rows
/*!40000 ALTER TABLE `historibayar` DISABLE KEYS */;
REPLACE INTO `historibayar` (`nobukti`, `no_faktur`, `tglbayar`, `bayar`, `id_admin`, `no_fak_penj`, `id_user`) VALUES
	('24000001', 'PST11240002', '2024-11-23', 58000, 0, NULL, 1),
	('24000002', 'PST11240001', '2024-11-23', 29000, 0, NULL, 1),
	('24000003', 'PST11240003', '2024-11-24', 458000, 0, NULL, 1),
	('24000004', 'PST12240001', '2024-12-01', 200000, 0, NULL, 1),
	('24000005', 'PST12240002', '2024-12-01', 229000, 0, NULL, 1),
	('24000021', 'PST12240006', '2024-12-18', 794000, 0, NULL, 1),
	('24000007', 'PST12240008', '2024-12-16', 280000, 0, NULL, 1),
	('24000008', 'PST12240011', '2024-12-17', 445000, 0, NULL, 1),
	('24000009', 'PST12240012', '2024-12-17', 1400000, 0, NULL, 1),
	('24000010', 'PST12240013', '2024-12-17', 1000000, 0, NULL, 1),
	('24000011', 'PST12240014', '2024-12-17', 1400000, 0, NULL, 1),
	('24000012', 'PST12240015', '2024-12-17', 1400000, 0, NULL, 1),
	('24000013', 'PST12240015', '2024-12-17', 2800000, 0, NULL, 1),
	('24000014', 'PST12240017', '2024-12-17', 2800000, 0, NULL, 1),
	('24000015', 'PST12240018', '2024-12-17', 2000000, 0, NULL, 1),
	('24000016', 'PST12240001', '2024-12-18', 1500000, 0, NULL, 1),
	('24000018', 'PST12240003', '2024-12-18', 700000, 0, NULL, 1),
	('24000019', 'PST12240004', '2024-12-18', 338000, 0, NULL, 1),
	('24000020', 'PST12240005', '2024-12-18', 560000, 0, NULL, 1);
/*!40000 ALTER TABLE `historibayar` ENABLE KEYS */;

-- Dumping structure for table ci_penjualan.pelanggan
CREATE TABLE IF NOT EXISTS `pelanggan` (
  `kode_pelanggan` varchar(13) NOT NULL,
  `nama_pelanggan` varchar(100) NOT NULL,
  `alamat_pelanggan` varchar(200) NOT NULL,
  `no_hp` varchar(15) NOT NULL,
  `kode_cabang` char(3) NOT NULL,
  PRIMARY KEY (`kode_pelanggan`) USING BTREE,
  KEY `pel_nama` (`nama_pelanggan`),
  KEY `pel_kodecab` (`kode_cabang`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table ci_penjualan.pelanggan: 2 rows
/*!40000 ALTER TABLE `pelanggan` DISABLE KEYS */;
REPLACE INTO `pelanggan` (`kode_pelanggan`, `nama_pelanggan`, `alamat_pelanggan`, `no_hp`, `kode_cabang`) VALUES
	('CS0001', 'Caraka', 'Indonesiaa', '08113344334657', 'T00'),
	('CS0002', 'Saktii', 'Indonesiaa', '088345889776', 'B00');
/*!40000 ALTER TABLE `pelanggan` ENABLE KEYS */;

-- Dumping structure for table ci_penjualan.penjualan
CREATE TABLE IF NOT EXISTS `penjualan` (
  `no_faktur` varchar(13) NOT NULL,
  `tgltransaksi` date NOT NULL,
  `kode_pelanggan` varchar(13) NOT NULL,
  `jenistransaksi` varchar(6) NOT NULL,
  `jatuhtempo` date DEFAULT NULL,
  `id_user` int NOT NULL DEFAULT '0',
  `total_harga` decimal(10,2) DEFAULT NULL,
  `total_bayar` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`no_faktur`) USING BTREE,
  KEY `kode_pelanggan` (`kode_pelanggan`),
  KEY `tgltransaksi` (`tgltransaksi`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table ci_penjualan.penjualan: 3 rows
/*!40000 ALTER TABLE `penjualan` DISABLE KEYS */;
REPLACE INTO `penjualan` (`no_faktur`, `tgltransaksi`, `kode_pelanggan`, `jenistransaksi`, `jatuhtempo`, `id_user`, `total_harga`, `total_bayar`) VALUES
	('PST12240007', '2024-12-18', 'CS0002', 'cash', '2025-01-18', 1, NULL, NULL),
	('PST12240002', '2024-12-18', 'CS0001', 'cash', '2025-01-18', 1, 1400000.00, NULL),
	('PST12240003', '2024-12-18', 'CS0002', 'cash', '2025-01-18', 1, 700000.00, NULL),
	('PST12240004', '2024-12-18', 'CS0001', 'cash', '2025-01-18', 1, 338000.00, NULL),
	('PST12240006', '2024-12-18', 'CS0002', 'cash', '2025-01-18', 1, 794000.00, NULL),
	('PST12240005', '2024-12-18', 'CS0001', 'cash', '2025-01-18', 1, 560000.00, NULL);
/*!40000 ALTER TABLE `penjualan` ENABLE KEYS */;

-- Dumping structure for table ci_penjualan.penjualan_detail
CREATE TABLE IF NOT EXISTS `penjualan_detail` (
  `no_fak_penj` varchar(13) DEFAULT NULL,
  `kode_barang` varchar(8) DEFAULT NULL,
  `harga` int DEFAULT NULL,
  `qty` int DEFAULT NULL,
  `no_faktur` varchar(50) DEFAULT NULL,
  KEY `detailpenj_nofaktur` (`no_fak_penj`),
  KEY `detailpenj_kodebarang` (`kode_barang`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table ci_penjualan.penjualan_detail: 4 rows
/*!40000 ALTER TABLE `penjualan_detail` DISABLE KEYS */;
REPLACE INTO `penjualan_detail` (`no_fak_penj`, `kode_barang`, `harga`, `qty`, `no_faktur`) VALUES
	(NULL, 'BR010', 140000, 2, 'PST12240004'),
	(NULL, 'BR011', 89000, 1, 'PST12240006'),
	(NULL, 'BR010', 140000, 4, 'PST12240006'),
	(NULL, 'BR003', 29000, 5, 'PST12240006'),
	(NULL, 'BR010', 140000, 10, 'PST12240002'),
	(NULL, 'BR010', 140000, 5, 'PST12240003'),
	(NULL, 'BR003', 29000, 2, 'PST12240004'),
	(NULL, 'BR010', 140000, 4, 'PST12240005');
/*!40000 ALTER TABLE `penjualan_detail` ENABLE KEYS */;

-- Dumping structure for table ci_penjualan.penjualan_detail_temp
CREATE TABLE IF NOT EXISTS `penjualan_detail_temp` (
  `no_fak_penj` varchar(13) NOT NULL,
  `kode_barang` varchar(8) NOT NULL,
  `harga` int NOT NULL,
  `qty` int NOT NULL,
  `id_user` int NOT NULL DEFAULT '0',
  KEY `detailpenj_nofaktur` (`no_fak_penj`),
  KEY `detailpenj_kodebarang` (`kode_barang`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table ci_penjualan.penjualan_detail_temp: 0 rows
/*!40000 ALTER TABLE `penjualan_detail_temp` DISABLE KEYS */;
/*!40000 ALTER TABLE `penjualan_detail_temp` ENABLE KEYS */;

-- Dumping structure for table ci_penjualan.users
CREATE TABLE IF NOT EXISTS `users` (
  `id_user` char(6) NOT NULL,
  `nama_lengkap` varchar(50) NOT NULL,
  `no_hp` varchar(13) NOT NULL,
  `username` varchar(10) NOT NULL,
  `password` varchar(255) NOT NULL,
  `level` varchar(30) NOT NULL,
  `kode_cabang` char(3) NOT NULL,
  PRIMARY KEY (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table ci_penjualan.users: 3 rows
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
REPLACE INTO `users` (`id_user`, `nama_lengkap`, `no_hp`, `username`, `password`, `level`, `kode_cabang`) VALUES
	('1', 'sakti', '08989888', 'sakti', '123', 'administrator', 'PST'),
	('U0002', 'Caraka Sakti', '0883455434897', 'raka', '123', 'kasir', 'B00'),
	('U0003', 'Andaru', '081787451900', 'andaru', '123', 'kepala cabang', 'B00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- Dumping structure for view ci_penjualan.v_total_penjualan
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `v_total_penjualan` (
	`no_faktur` VARCHAR(13) NOT NULL COLLATE 'latin1_swedish_ci',
	`tgltransaksi` DATE NOT NULL,
	`kode_pelanggan` VARCHAR(13) NOT NULL COLLATE 'latin1_swedish_ci',
	`nama_pelanggan` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`jenistransaksi` VARCHAR(6) NOT NULL COLLATE 'latin1_swedish_ci',
	`jatuhtempo` DATE NULL,
	`id_user` INT(10) NOT NULL,
	`nama_lengkap` VARCHAR(50) NOT NULL COLLATE 'latin1_swedish_ci',
	`kode_cabang` CHAR(3) NOT NULL COLLATE 'latin1_swedish_ci',
	`total_jual` DECIMAL(10,2) NULL,
	`total_bayar` DECIMAL(10,2) NULL,
	`sisa` DECIMAL(11,2) NULL
) ENGINE=MyISAM;

-- Dumping structure for view ci_penjualan.v_total_penjualan
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `v_total_penjualan`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `v_total_penjualan` AS select `p`.`no_faktur` AS `no_faktur`,`p`.`tgltransaksi` AS `tgltransaksi`,`p`.`kode_pelanggan` AS `kode_pelanggan`,`pl`.`nama_pelanggan` AS `nama_pelanggan`,`p`.`jenistransaksi` AS `jenistransaksi`,`p`.`jatuhtempo` AS `jatuhtempo`,`p`.`id_user` AS `id_user`,`u`.`nama_lengkap` AS `nama_lengkap`,`u`.`kode_cabang` AS `kode_cabang`,`p`.`total_harga` AS `total_jual`,`p`.`total_bayar` AS `total_bayar`,(`p`.`total_harga` - `p`.`total_bayar`) AS `sisa` from ((`penjualan` `p` join `pelanggan` `pl` on((`p`.`kode_pelanggan` = `pl`.`kode_pelanggan`))) join `users` `u` on((`p`.`id_user` = `u`.`id_user`)));

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
