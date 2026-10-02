-- Praktikum Basis Data - Semester 3
-- p01_lingkungan_25430080.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.

CREATE DATABASE kopma_080
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'mhs_080'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_080.* TO 'mhs_080'@'localhost';
