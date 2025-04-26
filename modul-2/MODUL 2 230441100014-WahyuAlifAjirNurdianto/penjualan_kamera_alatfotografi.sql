CREATE DATABASE penjualan_kamera_fotografi;
USE penjualan_kamera_fotografi;


-- tabel master 
CREATE TABLE pelanggan (
  id_pelanggan INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(50) NOT NULL,
  no_hp VARCHAR(15),
  email VARCHAR(50),
  alamat TEXT
);

CREATE TABLE kategori_barang (
  id_kategori INT AUTO_INCREMENT PRIMARY KEY,
  nama_kategori VARCHAR(50) NOT NULL,
  deskripsi TEXT
);

CREATE TABLE barang (
  id_barang INT AUTO_INCREMENT PRIMARY KEY,
  nama_barang VARCHAR(100) NOT NULL,
  id_kategori INT,
  stok INT NOT NULL,
  harga_jual DECIMAL(12,2) NOT NULL,
  STATUS ENUM('Tersedia', 'Habis') DEFAULT 'Tersedia',
  FOREIGN KEY (id_kategori) REFERENCES kategori_barang(id_kategori)
    ON UPDATE CASCADE ON DELETE SET NULL
);

-- tabel transaksi
CREATE TABLE penjualan (
  id_penjualan INT AUTO_INCREMENT PRIMARY KEY,
  id_pelanggan INT NOT NULL,
  tanggal_penjualan DATE NOT NULL,
  total_harga DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE detail_penjualan (
  id_detail INT AUTO_INCREMENT PRIMARY KEY,
  id_penjualan INT NOT NULL,
  id_barang INT NOT NULL,
  jumlah INT NOT NULL,
  harga_satuan DECIMAL(12,2) NOT NULL,
  subtotal DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (id_penjualan) REFERENCES penjualan(id_penjualan)
  FOREIGN KEY (id_barang) REFERENCES barang(id_barang)
);

CREATE TABLE pembayaran (
  id_pembayaran INT AUTO_INCREMENT PRIMARY KEY,
  id_penjualan INT NOT NULL,
  tanggal_bayar DATE NOT NULL,
  jumlah_bayar DECIMAL(12,2) NOT NULL,
  metode ENUM('Cash', 'Transfer', 'QRIS') DEFAULT 'Cash',
  status_bayar ENUM('Lunas', 'Belum Lunas') DEFAULT 'Belum Lunas',
  FOREIGN KEY (id_penjualan) REFERENCES penjualan(id_penjualan)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE retur_penjualan (
  id_retur INT AUTO_INCREMENT PRIMARY KEY,
  id_penjualan INT NOT NULL,
  tanggal_retur DATE NOT NULL,
  alasan TEXT,
  total_retur DECIMAL(12,2),
  FOREIGN KEY (id_penjualan) REFERENCES penjualan(id_penjualan)
);

INSERT INTO pelanggan (nama, no_hp, email, alamat) VALUES
('Wahyu Nugroho', '081234567890', 'wahyu@example.com', 'Jl. Merpati No. 12'),
('Rina Santika', '081222333444', 'rina.santika@example.com', 'Jl. Kenanga 45'),
('Dimas Ardi', '089876543210', 'dimasardi@example.com', 'Jl. Cemara Raya'),
('Siti Aminah', '082345678910', 'siti@example.com', 'Jl. Mawar 3'),
('Fajar Prasetyo', '085679123456', 'fajar@example.com', 'Jl. Sakura Indah');

INSERT INTO kategori_barang (nama_kategori, deskripsi) VALUES
('Kamera DSLR', 'Digital Single-Lens Reflex Cameras'),
('Lensa', 'Berbagai jenis lensa untuk kamera profesional'),
('Aksesoris', 'Tripod, tas kamera, dan lainnya'),
('Drone', 'Drone untuk kebutuhan videografi dan fotografi'),
('Kamera Mirrorless', 'Kamera ringan dengan kualitas tinggi');

INSERT INTO barang (nama_barang, id_kategori, stok, harga_jual, STATUS) VALUES
('Canon EOS 90D', 1, 10, 13500000.00, 'Tersedia'),
('Sony Alpha a6400', 5, 7, 12500000.00, 'Tersedia'),
('Lensa Canon 50mm f/1.8', 2, 20, 1500000.00, 'Tersedia'),
('Tripod Takara ECO-193A', 3, 15, 350000.00, 'Tersedia'),
('DJI Mini 3 Pro', 4, 5, 14500000.00, 'Tersedia');

INSERT INTO penjualan (id_pelanggan, tanggal_penjualan, total_harga) VALUES
(1, '2025-04-10', 15000000.00),
(2, '2025-04-11', 12850000.00),
(3, '2025-04-12', 350000.00),
(4, '2025-04-12', 16000000.00),
(5, '2025-04-13', 1500000.00);

INSERT INTO detail_penjualan (id_penjualan, id_barang, jumlah, harga_satuan, subtotal) VALUES
(1, 1, 1, 13500000.00, 13500000.00),
(1, 3, 1, 1500000.00, 1500000.00),
(2, 2, 1, 12500000.00, 12500000.00),
(2, 4, 1, 350000.00, 350000.00),
(3, 4, 1, 350000.00, 350000.00),
(4, 5, 1, 14500000.00, 14500000.00),
(5, 3, 1, 1500000.00, 1500000.00);

INSERT INTO pembayaran (id_penjualan, tanggal_bayar, jumlah_bayar, metode, status_bayar) VALUES
(1, '2025-04-10', 15000000.00, 'Transfer', 'Lunas'),
(2, '2025-04-11', 6000000.00, 'Cash', 'Belum Lunas'),
(2, '2025-04-12', 6850000.00, 'Transfer', 'Lunas'),
(3, '2025-04-12', 350000.00, 'QRIS', 'Lunas'),
(4, '2025-04-13', 16000000.00, 'Cash', 'Lunas');

INSERT INTO retur_penjualan (id_penjualan, tanggal_retur, alasan, total_retur) VALUES
(1, '2025-04-14', 'Unit tidak sesuai deskripsi', 13500000.00),
(5, '2025-04-15', 'Lensa rusak saat diterima', 1500000.00);


-- soal 1
CREATE VIEW view_stok_barang_kategori AS
SELECT 
    b.id_barang,
    b.nama_barang,
    kb.nama_kategori,
    b.stok,
    b.status,
    b.harga_jual
FROM barang b
JOIN kategori_barang kb ON b.id_kategori = kb.id_kategori;

SELECT * FROM view_stok_barang_kategori;

-- soal 2
CREATE VIEW view_laporan_penjualan_lengkap AS
SELECT 
    p.id_penjualan,
    p.tanggal_penjualan,
    pl.nama AS nama_pelanggan,
    b.nama_barang,
    kb.nama_kategori,
    dp.jumlah,
    dp.harga_satuan,
    dp.subtotal
FROM penjualan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
JOIN detail_penjualan dp ON dp.id_penjualan = p.id_penjualan
JOIN barang b ON dp.id_barang = b.id_barang
JOIN kategori_barang kb ON b.id_kategori = kb.id_kategori;

SELECT * FROM view_laporan_penjualan_lengkap;

-- soal 3 

CREATE VIEW view_penjualan_belum_lunas AS
SELECT 
    p.id_penjualan,
    pl.nama AS nama_pelanggan,
    p.tanggal_penjualan,
    pm.jumlah_bayar,
    pm.status_bayar
FROM penjualan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
JOIN pembayaran pm ON p.id_penjualan = pm.id_penjualan
WHERE pm.status_bayar = 'Belum Lunas';

SELECT * FROM view_penjualan_belum_lunas;

-- soal 4
CREATE VIEW view_total_pembelian_pelanggan AS
SELECT 
    pl.id_pelanggan,
    pl.nama AS nama_pelanggan,
    COUNT(p.id_penjualan) AS jumlah_transaksi,
    SUM(p.total_harga) AS total_pengeluaran
FROM pelanggan pl
JOIN penjualan p ON pl.id_pelanggan = p.id_pelanggan
GROUP BY pl.id_pelanggan, pl.nama;

SELECT * FROM  view_total_pembelian_pelanggan;

--
CREATE VIEW view_harga_per_kategori AS
SELECT 
    k.nama_kategori,
    AVG(b.harga_jual) AS rata_rata_harga_jual
FROM barang b
JOIN kategori_barang k ON b.id_kategori = k.id_kategori
GROUP BY k.id_kategori, k.nama_kategori;

SELECT * FROM view_harga_per_kategori;

-- soal 5 
CREATE VIEW view_barang_dengan_harga_extreme AS
SELECT 
    MIN(harga_jual) AS harga_termurah,
    MAX(harga_jual) AS harga_termahal
FROM barang;

SELECT * FROM view_barang_dengan_harga_extreme;

--
CREATE VIEW view_total_penjualan_per_hari AS
SELECT 
    tanggal_penjualan,
    SUM(total_harga) AS total_penjualan_harian
FROM penjualan
GROUP BY tanggal_penjualan
ORDER BY tanggal_penjualan DESC;

SELECT * FROM view_total_penjualan_per_hari;

--

CREATE VIEW view_total_retur_per_pelanggan AS
SELECT 
    p.nama AS nama_pelanggan,
    COUNT(rp.id_retur) AS jumlah_retur,
    SUM(rp.total_retur) AS total_nilai_retur
FROM retur_penjualan rp
JOIN penjualan pj ON rp.id_penjualan = pj.id_penjualan
JOIN pelanggan p ON pj.id_pelanggan = p.id_pelanggan
GROUP BY p.id_pelanggan, p.nama;

SELECT * FROM view_total_retur_per_pelanggan;


SELECT * FROM barang;
SELECT * FROM detail_penjualan;
SELECT * FROM kategori_barang;
SELECT * FROM pelanggan;
SELECT * FROM pembayaran;
SELECT * FROM penjualan;
SELECT * FROM retur_penjualan;



