-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 08, 2024 at 06:06 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `testowa_inzy`
/*NA TEJ PRACOWALEM DOTYCHCZAS */
--

-- --------------------------------------------------------

--
-- Table structure for table `cwiczenie`
--

CREATE TABLE `cwiczenie` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) DEFAULT NULL,
  `opis` text DEFAULT NULL,
  `rodzaj` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cwiczenie`
--

INSERT INTO `cwiczenie` (`id`, `nazwa`, `opis`, `rodzaj`) VALUES
(1, 'Mała gierka', 'Gra na malej powierzchni 5 na 5', 'sila,reakcje,podania'),
(3, 'Schemat Y', 'Rozegranie z pierwszej piłki oraz strzał. Ustawiony przed polem kartynm na znak litery Y', 'strzaly,podania'),
(4, 'Gra w berka', 'Prosta gra w berka, obszar to połowa boiska orlikowego', 'reakcje'),
(5, 'Testowablabla', 'Oby zadziallo bo sie poplacze', 'wytrzymalosc,strzaly,sila'),
(6, '512512576w457457', 'ou4gv1208412no4', 'sila,reakcje,podania'),
(7, 'kolejne tefas1412', 'hahahahha', 'reakcje,sila,podania'),
(8, 'kolejne testy', 'hahhauybaba', 'wytrzymalosc,strzaly,stale_fragmenty'),
(9, 'Dalsza walka', 'Walka na gole piesci', 'sila,wytrzymalosc,strzaly');

-- --------------------------------------------------------

--
-- Table structure for table `gotowy_plan`
--

CREATE TABLE `gotowy_plan` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) DEFAULT NULL,
  `trening_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gotowy_plan`
--

INSERT INTO `gotowy_plan` (`id`, `nazwa`, `trening_id`) VALUES
(1, 'Testowanie', NULL),
(2, 'Gra w berka', NULL),
(3, 'Trening Podania', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `gotowy_plan_cwiczenie`
--

CREATE TABLE `gotowy_plan_cwiczenie` (
  `id` int(11) NOT NULL,
  `gotowy_plan_id` int(11) NOT NULL,
  `cwiczenie_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gotowy_plan_cwiczenie`
--

INSERT INTO `gotowy_plan_cwiczenie` (`id`, `gotowy_plan_id`, `cwiczenie_id`) VALUES
(1, 1, 3),
(2, 1, 7),
(3, 1, 9),
(4, 2, 9),
(5, 2, 4),
(6, 2, 1),
(7, 3, 3),
(8, 3, 5),
(9, 3, 8),
(10, 3, 7);

-- --------------------------------------------------------

--
-- Table structure for table `grupa_treningowa`
--

CREATE TABLE `grupa_treningowa` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) DEFAULT NULL,
  `uzytkownik_id` int(11) DEFAULT NULL COMMENT 'JAKI TRENER PRZYPISANY DO GRUPY'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grupa_treningowa`
--

INSERT INTO `grupa_treningowa` (`id`, `nazwa`, `uzytkownik_id`) VALUES
(1, '2015', 1),
(2, '2008', 9);

-- --------------------------------------------------------

--
-- Table structure for table `grupa_treningowa_uzytkownik`
--

CREATE TABLE `grupa_treningowa_uzytkownik` (
  `grupa_treningowa_id` int(11) NOT NULL,
  `uzytkownik_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grupa_treningowa_uzytkownik`
--

INSERT INTO `grupa_treningowa_uzytkownik` (`grupa_treningowa_id`, `uzytkownik_id`) VALUES
(1, 10),
(2, 12),
(2, 19);

-- --------------------------------------------------------

--
-- Table structure for table `konwersacja`
--

CREATE TABLE `konwersacja` (
  `id` int(11) NOT NULL,
  `typ` enum('prywatna','grupowa') DEFAULT NULL,
  `grupa_treningowa_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` int(11) NOT NULL,
  `tokenable_type` varchar(255) DEFAULT NULL,
  `tokenable_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`, `expires_at`) VALUES
(11, 'App\\Models\\User', 10, 'authToken', '6639a0237e12232203250930120af0c2c8b2cb8e2d80bda4ccfc5ef271c9ca47', '[\"*\"]', '2024-02-08 16:03:09', '2024-02-07 20:51:24', '2024-02-08 16:03:09', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `rodzic_dziecko`
--

CREATE TABLE `rodzic_dziecko` (
  `rodzic_id` int(11) NOT NULL,
  `dziecko_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rodzic_dziecko`
--

INSERT INTO `rodzic_dziecko` (`rodzic_id`, `dziecko_id`) VALUES
(13, 12),
(20, 19);

-- --------------------------------------------------------

--
-- Table structure for table `trening`
--

CREATE TABLE `trening` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) DEFAULT NULL,
  `opis` text DEFAULT NULL,
  `uzytkownik_id` int(11) DEFAULT NULL,
  `grupa_treningowa_id` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `godzina` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutorial`
--

CREATE TABLE `tutorial` (
  `id` int(11) NOT NULL,
  `sciezka_zdjecie` varchar(255) DEFAULT NULL,
  `sciezka_film` varchar(255) NOT NULL,
  `cwiczenie_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tutorial`
--

INSERT INTO `tutorial` (`id`, `sciezka_zdjecie`, `sciezka_film`, `cwiczenie_id`) VALUES
(1, 'storage/cwiczenia/1/xyDoEPgsypreKmvscDVLNYHWOdg95OgOaS3hZxeu.jpg', 'storage/cwiczenia/1/Z9LVyPWrIR76nToVbR4kn4tMgMeHCmXArPFEQDOu.mp4', 1),
(3, 'storage/cwiczenia/4/1XIxCrJodu9fsoAOJAm2vESMOjUYW1bO35E8VbQn.jpg', 'storage/cwiczenia/4/QzPIboI5UNWhKecU4JvJ7xB6NQOItPWCsd3DdZ7R.mp4', 4),
(4, 'storage/cwiczenia/5/P1BCmUJ1VHtK4YpoKMsOanYl6Gzqwd8DFUlJNiV5.png', 'storage/cwiczenia/5/IYIJKmSPxcnSyshKCNynvfRiePN3aAJ5mrAgHZS5.mp4', 5),
(5, 'storage/cwiczenia/6/D8Jn3eZqZM757VcCjLVqvWVgmL5IdU80tqnNPBWb.png', 'storage/cwiczenia/6/AMrOX99rJuKOmgoA4wCHjqTBlAx8yint2OTOVYYB.mp4', 6),
(6, 'storage/cwiczenia/7/kEWEIK84KQ33ebVO2OL7xwHvgYSoJ7mRujm2LGsQ.png', 'storage/cwiczenia/7/Zgys6dnkl937Vf5m55MAMrfvtZSC77tw1D5E6eIy.mp4', 7),
(7, 'storage/cwiczenia/8/GcHEYFtZqkMvR4MuZ6jJ6poSBV97TA7mqddzDlhp.png', 'storage/cwiczenia/8/NGHHbYjGe13JgGpjGshktGG36SclS5LKDdJaV8MW.mp4', 8),
(8, '', 'storage/cwiczenia/9/0iCH0DiGk1bAQDCt9i8BplQDw17o1TwsYjGjt32H.mp4', 9);

-- --------------------------------------------------------

--
-- Table structure for table `uzytkownik`
--

CREATE TABLE `uzytkownik` (
  `id` int(11) NOT NULL,
  `login` varchar(50) NOT NULL,
  `haslo` varchar(255) NOT NULL,
  `imie` varchar(255) DEFAULT NULL,
  `nazwisko` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `telefon` varchar(255) DEFAULT NULL,
  `rola` varchar(255) DEFAULT NULL,
  `avatarUrl` varchar(255) DEFAULT NULL,
  `aktywowane` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `uzytkownik`
--

INSERT INTO `uzytkownik` (`id`, `login`, `haslo`, `imie`, `nazwisko`, `email`, `telefon`, `rola`, `avatarUrl`, `aktywowane`, `created_at`, `updated_at`) VALUES
(1, 'marcelek04', 'kajtus321', 'Marcel', 'Scigaj', 'marcel.nieznajomy@wp.pl', NULL, 'Trener', NULL, 0, '2024-01-29 16:41:26', '2024-01-29 16:41:26'),
(9, 'testowanie123', 'blabla12551', 'Rafał', 'Masny', 'rafalmasny@wp.pl', '126823734', 'Trener', NULL, 1, '2024-02-06 15:27:20', '2024-02-06 15:27:20'),
(10, 'Baranek2115', '$2y$10$3WOJvJ4eoWc/0YrF8EHLPeKi26qVkcXebbknb.0Xc3f/wtU.sV/Zy', 'Bartosz', 'Zmarzly', 'baranek2115@wp.pl', NULL, 'dziecko', '/storage/avatars/1707237764.png', 0, '2024-02-06 14:30:49', '2024-02-06 15:42:44'),
(11, 'IdVBva1zsY', '$2y$10$tC8ePF9684XcBeLubSU9r.S4nP2/.T16yxsrVOaOxatepFx0iB/9S', NULL, NULL, 'bartekjaktek@wp.pl', NULL, 'rodzic', NULL, 0, '2024-02-06 14:30:50', '2024-02-06 14:30:50'),
(12, 'uUDyiu8a34', '$2y$10$kiEYDwA5x/PDWqUD4DZ0M.zqSkk60Oe8u3SGJjm67w0xDye/6l6fi', 'Dorian', 'Chwalczyk', NULL, NULL, 'dziecko', NULL, 0, '2024-02-06 15:27:11', '2024-02-06 15:27:11'),
(13, 'ghOVvSF2NT', '$2y$10$YKz5wN371JZh04yTxW5GjONpvBL7mmqSmoBAfKuf/Z5lvwGUq/iUC', NULL, NULL, 'adianmucha@wp.pl', NULL, 'rodzic', NULL, 0, '2024-02-06 15:27:11', '2024-02-06 15:27:11'),
(19, 'rdEKDdpG2t', '$2y$10$yj2aGqNw1f3pfNgBY5CpfemrH/fuGiELL5q1.NNowA2St6odvGyD.', 'patryk', 'Stefańczyk', NULL, NULL, 'dziecko', NULL, 0, '2024-02-08 15:40:59', '2024-02-08 15:40:59'),
(20, 'WVgIYULRgc', '$2y$10$jxC2ZTx103PbHLygy5vv4OGWaEwsV/bTQMpBHPjmRuAy7S71DGXR6', NULL, NULL, 'marta_stefanczyk@gmail.com', NULL, 'rodzic', NULL, 0, '2024-02-08 15:40:59', '2024-02-08 15:40:59'),
(22, 'UQsYcuEi4e', '$2y$10$LVorCIMO31wG.qFy2zSQjO7LP0SpwCzEk5WlGHiLBJFqwGrxPBDpi', 'Radek', 'Majdanek', 'radzio@wp.pl', NULL, 'trener', NULL, 0, '2024-02-08 15:50:12', '2024-02-08 15:50:12');

-- --------------------------------------------------------

--
-- Table structure for table `uzytkownik_konwersacja`
--

CREATE TABLE `uzytkownik_konwersacja` (
  `uzytkownik_id` int(11) NOT NULL,
  `konwersacja_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wiadomosc`
--

CREATE TABLE `wiadomosc` (
  `id` int(11) NOT NULL,
  `tresc` text DEFAULT NULL,
  `dataWyslania` datetime DEFAULT NULL,
  `konwersacja_id` int(11) DEFAULT NULL,
  `uzytkownik_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cwiczenie`
--
ALTER TABLE `cwiczenie`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gotowy_plan`
--
ALTER TABLE `gotowy_plan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `gotowy_plan_ibfk_1` (`trening_id`);

--
-- Indexes for table `gotowy_plan_cwiczenie`
--
ALTER TABLE `gotowy_plan_cwiczenie`
  ADD PRIMARY KEY (`id`),
  ADD KEY `gotowy_plan_id` (`gotowy_plan_id`),
  ADD KEY `cwiczenie_id` (`cwiczenie_id`);

--
-- Indexes for table `grupa_treningowa`
--
ALTER TABLE `grupa_treningowa`
  ADD PRIMARY KEY (`id`),
  ADD KEY `grupa_treningowa_ibfk_1` (`uzytkownik_id`);

--
-- Indexes for table `grupa_treningowa_uzytkownik`
--
ALTER TABLE `grupa_treningowa_uzytkownik`
  ADD PRIMARY KEY (`grupa_treningowa_id`,`uzytkownik_id`),
  ADD KEY `grupa_treningowa_uzytkownik_ibfk_2` (`uzytkownik_id`);

--
-- Indexes for table `konwersacja`
--
ALTER TABLE `konwersacja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `grupa_treningowa_id` (`grupa_treningowa_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `token` (`token`);

--
-- Indexes for table `rodzic_dziecko`
--
ALTER TABLE `rodzic_dziecko`
  ADD PRIMARY KEY (`rodzic_id`,`dziecko_id`),
  ADD KEY `dziecko_id` (`dziecko_id`);

--
-- Indexes for table `trening`
--
ALTER TABLE `trening`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uzytkownik_id` (`uzytkownik_id`),
  ADD KEY `grupa_treningowa_id` (`grupa_treningowa_id`);

--
-- Indexes for table `tutorial`
--
ALTER TABLE `tutorial`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cwiczenie_id` (`cwiczenie_id`);

--
-- Indexes for table `uzytkownik`
--
ALTER TABLE `uzytkownik`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `uzytkownik_konwersacja`
--
ALTER TABLE `uzytkownik_konwersacja`
  ADD PRIMARY KEY (`uzytkownik_id`,`konwersacja_id`),
  ADD KEY `konwersacja_id` (`konwersacja_id`);

--
-- Indexes for table `wiadomosc`
--
ALTER TABLE `wiadomosc`
  ADD PRIMARY KEY (`id`),
  ADD KEY `konwersacja_id` (`konwersacja_id`),
  ADD KEY `uzytkownik_id` (`uzytkownik_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cwiczenie`
--
ALTER TABLE `cwiczenie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `gotowy_plan`
--
ALTER TABLE `gotowy_plan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `gotowy_plan_cwiczenie`
--
ALTER TABLE `gotowy_plan_cwiczenie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `grupa_treningowa`
--
ALTER TABLE `grupa_treningowa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `konwersacja`
--
ALTER TABLE `konwersacja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `trening`
--
ALTER TABLE `trening`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutorial`
--
ALTER TABLE `tutorial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `uzytkownik`
--
ALTER TABLE `uzytkownik`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `wiadomosc`
--
ALTER TABLE `wiadomosc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `gotowy_plan`
--
ALTER TABLE `gotowy_plan`
  ADD CONSTRAINT `gotowy_plan_ibfk_1` FOREIGN KEY (`trening_id`) REFERENCES `trening` (`id`);

--
-- Constraints for table `gotowy_plan_cwiczenie`
--
ALTER TABLE `gotowy_plan_cwiczenie`
  ADD CONSTRAINT `gotowy_plan_cwiczenie_ibfk_1` FOREIGN KEY (`gotowy_plan_id`) REFERENCES `gotowy_plan` (`id`),
  ADD CONSTRAINT `gotowy_plan_cwiczenie_ibfk_2` FOREIGN KEY (`cwiczenie_id`) REFERENCES `cwiczenie` (`id`);

--
-- Constraints for table `grupa_treningowa`
--
ALTER TABLE `grupa_treningowa`
  ADD CONSTRAINT `grupa_treningowa_ibfk_1` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`);

--
-- Constraints for table `grupa_treningowa_uzytkownik`
--
ALTER TABLE `grupa_treningowa_uzytkownik`
  ADD CONSTRAINT `grupa_treningowa_uzytkownik_ibfk_1` FOREIGN KEY (`grupa_treningowa_id`) REFERENCES `grupa_treningowa` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grupa_treningowa_uzytkownik_ibfk_2` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `konwersacja`
--
ALTER TABLE `konwersacja`
  ADD CONSTRAINT `konwersacja_ibfk_1` FOREIGN KEY (`grupa_treningowa_id`) REFERENCES `grupa_treningowa` (`id`);

--
-- Constraints for table `rodzic_dziecko`
--
ALTER TABLE `rodzic_dziecko`
  ADD CONSTRAINT `rodzic_dziecko_ibfk_1` FOREIGN KEY (`rodzic_id`) REFERENCES `uzytkownik` (`id`),
  ADD CONSTRAINT `rodzic_dziecko_ibfk_2` FOREIGN KEY (`dziecko_id`) REFERENCES `uzytkownik` (`id`);

--
-- Constraints for table `trening`
--
ALTER TABLE `trening`
  ADD CONSTRAINT `trening_ibfk_1` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`),
  ADD CONSTRAINT `trening_ibfk_2` FOREIGN KEY (`grupa_treningowa_id`) REFERENCES `grupa_treningowa` (`id`);

--
-- Constraints for table `tutorial`
--
ALTER TABLE `tutorial`
  ADD CONSTRAINT `tutorial_ibfk_1` FOREIGN KEY (`cwiczenie_id`) REFERENCES `cwiczenie` (`id`);

--
-- Constraints for table `uzytkownik_konwersacja`
--
ALTER TABLE `uzytkownik_konwersacja`
  ADD CONSTRAINT `uzytkownik_konwersacja_ibfk_1` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`),
  ADD CONSTRAINT `uzytkownik_konwersacja_ibfk_2` FOREIGN KEY (`konwersacja_id`) REFERENCES `konwersacja` (`id`);

--
-- Constraints for table `wiadomosc`
--
ALTER TABLE `wiadomosc`
  ADD CONSTRAINT `wiadomosc_ibfk_1` FOREIGN KEY (`konwersacja_id`) REFERENCES `konwersacja` (`id`),
  ADD CONSTRAINT `wiadomosc_ibfk_2` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
