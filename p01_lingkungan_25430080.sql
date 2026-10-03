-- Praktikum Basis Data-Semester 3
-- p01_lingkungan_25430080.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.

-- Database Utama

CREATE DATABASE IF NOT EXISTS kopma_080
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

--Membuat user mhs_080

CREATE USER IF NOT EXISTS 'mhs_080'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_080.* TO 'mhs_080'@'localhost';

--Membuat user tamu_080

CREATE USER IF NOT EXISTS 'tamu_080'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT SELECT ON kopma_080.*TO 'tamu_080'@'localhost';

--Membuat user dev_080

CREATE USER IF NOT EXISTS 'dev_080'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT SELECT ON kopma_080.*TO 'dev_080'@'localhost';

FLUSH PRIVILEGES;


