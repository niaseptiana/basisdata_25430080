-- Praktikum Basis Data - Semester 3
-- p01_lingkungan_25430080.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.

CREATE DATABASE kopma_123
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'mhs_80'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_80.* TO 'mhs_80'@'localhost';

git init
git add README.md p01_lingkungan_2301010123.sql
git commit -m "p01: inisialisasi repositori dan skrip lingkungan"
git remote add origin https://github.com/niaseptiana/basisdata_25430080.git
git push -u origin main
