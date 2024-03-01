-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 08, 2024 at 07:58 PM
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
(10, 'Mała gierka', 'Gra na malej powierzchni', 'reakcje,sila,strzaly'),
(11, 'Schemat Y', 'Schemat strzalow z dystansu', 'strzaly,stale_fragmenty'),
(12, 'Gra w berka', 'Bereknietoperek', 'wytrzymalosc,sila,podania');

-- --------------------------------------------------------

--
-- Table structure for table `gotowy_plan`
--

CREATE TABLE `gotowy_plan` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gotowy_plan`
--

INSERT INTO `gotowy_plan` (`id`, `nazwa`) VALUES
(4, 'Plan Akcji hehe'),
(5, 'PlanB');

-- --------------------------------------------------------

--
-- Table structure for table `gotowy_plan_cwiczenie`
--

CREATE TABLE `gotowy_plan_cwiczenie` (
  `gotowy_plan_id` int(11) NOT NULL,
  `cwiczenie_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gotowy_plan_cwiczenie`
--

INSERT INTO `gotowy_plan_cwiczenie` (`gotowy_plan_id`, `cwiczenie_id`) VALUES
(4, 10),
(4, 11),
(5, 10),
(5, 12);

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
(2, '2008', 3);

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
(1, 2),
(2, 4);

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
(5, 4);

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
-- Table structure for table `trening_cwiczenie`
--

CREATE TABLE `trening_cwiczenie` (
  `trening_id` int(11) NOT NULL,
  `cwiczenie_id` int(11) NOT NULL
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
(1, 'storage/cwiczenia/10/hK4IUgUENS5oRuiGggSnCF5LyjuDwkIFeWOkhkgF.png', 'storage/cwiczenia/10/2gzHgKMYKjUpvJnILAYZxMQvSWNkm8UB7SgrHsmb.mp4', 10),
(2, 'storage/cwiczenia/11/p3OeH1dqolLINK1W7AkmVVUjRPRAHjaArZVbudx1.png', 'storage/cwiczenia/11/c92NLtLwEAmATYEcUlGlGA1H404fJd5ZSt0QinxW.mp4', 11),
(3, 'storage/cwiczenia/12/EhwLLG1qSdxOOMSVblOw2Mcdfsb38hTz5KzO8vrU.png', '', 12);

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
(1, 'marcelek04', 'precel2115', 'Marcel', 'Scigaj', 'marcel@gmail.com', '123456789', 'Trener', 'avatar_url', 1, '2024-02-08 18:41:39', '2024-02-08 18:41:39'),
(2, 'Baranek2115', '$2y$10$3WOJvJ4eoWc/0YrF8EHLPeKi26qVkcXebbknb.0Xc3f/wtU.sV/Zy', 'Bartosz', 'Zmarzly', 'baranek2115@wp.pl', NULL, 'dziecko', '/storage/avatars/1707237764.png', 0, '2024-02-06 14:30:49', '2024-02-06 15:42:44'),
(3, 'testowanie123', 'password', 'Rafał', 'Masny', 'rafal@example.com', '987654321', 'Trener', 'avatar_url', 1, '2024-02-08 18:41:39', '2024-02-08 18:41:39'),
(4, '8C6Er3oZec', '$2y$10$ZfrGW2kyBQxQ6u7wR5aNm.ja7iUPixQtPmpBC3CHoiL9DkbQrADuy', 'Bartek', 'Zbartek', NULL, NULL, 'dziecko', NULL, 0, '2024-02-08 17:51:58', '2024-02-08 17:51:58'),
(5, 'S6PEo2aYrx', '$2y$10$JPc/1E8Jw8wJVuapi821v.uFsCiZadwZmrwlaRkpiYjr3kvD/btoe', NULL, NULL, 'janekzbartek@wp.pl', NULL, 'rodzic', NULL, 0, '2024-02-08 17:51:58', '2024-02-08 17:51:58');

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
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gotowy_plan_cwiczenie`
--
ALTER TABLE `gotowy_plan_cwiczenie`
  ADD PRIMARY KEY (`gotowy_plan_id`,`cwiczenie_id`),
  ADD KEY `cwiczenie_id` (`cwiczenie_id`);

--
-- Indexes for table `grupa_treningowa`
--
ALTER TABLE `grupa_treningowa`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uzytkownik_id` (`uzytkownik_id`);

--
-- Indexes for table `grupa_treningowa_uzytkownik`
--
ALTER TABLE `grupa_treningowa_uzytkownik`
  ADD PRIMARY KEY (`grupa_treningowa_id`,`uzytkownik_id`),
  ADD KEY `uzytkownik_id` (`uzytkownik_id`);

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
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `trening_cwiczenie`
--
ALTER TABLE `trening_cwiczenie`
  ADD PRIMARY KEY (`trening_id`,`cwiczenie_id`),
  ADD KEY `cwiczenie_id` (`cwiczenie_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `gotowy_plan`
--
ALTER TABLE `gotowy_plan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `trening`
--
ALTER TABLE `trening`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutorial`
--
ALTER TABLE `tutorial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `uzytkownik`
--
ALTER TABLE `uzytkownik`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `wiadomosc`
--
ALTER TABLE `wiadomosc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `gotowy_plan_cwiczenie`
--
ALTER TABLE `gotowy_plan_cwiczenie`
  ADD CONSTRAINT `gotowy_plan_cwiczenie_ibfk_1` FOREIGN KEY (`gotowy_plan_id`) REFERENCES `gotowy_plan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `gotowy_plan_cwiczenie_ibfk_2` FOREIGN KEY (`cwiczenie_id`) REFERENCES `cwiczenie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `grupa_treningowa`
--
ALTER TABLE `grupa_treningowa`
  ADD CONSTRAINT `grupa_treningowa_ibfk_1` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `grupa_treningowa_uzytkownik`
--
ALTER TABLE `grupa_treningowa_uzytkownik`
  ADD CONSTRAINT `grupa_treningowa_uzytkownik_ibfk_1` FOREIGN KEY (`grupa_treningowa_id`) REFERENCES `grupa_treningowa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `grupa_treningowa_uzytkownik_ibfk_2` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `konwersacja`
--
ALTER TABLE `konwersacja`
  ADD CONSTRAINT `konwersacja_ibfk_1` FOREIGN KEY (`grupa_treningowa_id`) REFERENCES `grupa_treningowa` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `rodzic_dziecko`
--
ALTER TABLE `rodzic_dziecko`
  ADD CONSTRAINT `rodzic_dziecko_ibfk_1` FOREIGN KEY (`rodzic_id`) REFERENCES `uzytkownik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `rodzic_dziecko_ibfk_2` FOREIGN KEY (`dziecko_id`) REFERENCES `uzytkownik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `trening`
--
ALTER TABLE `trening`
  ADD CONSTRAINT `trening_ibfk_1` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `trening_ibfk_2` FOREIGN KEY (`grupa_treningowa_id`) REFERENCES `grupa_treningowa` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `trening_cwiczenie`
--
ALTER TABLE `trening_cwiczenie`
  ADD CONSTRAINT `trening_cwiczenie_ibfk_1` FOREIGN KEY (`trening_id`) REFERENCES `trening` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `trening_cwiczenie_ibfk_2` FOREIGN KEY (`cwiczenie_id`) REFERENCES `cwiczenie` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tutorial`
--
ALTER TABLE `tutorial`
  ADD CONSTRAINT `tutorial_ibfk_1` FOREIGN KEY (`cwiczenie_id`) REFERENCES `cwiczenie` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `uzytkownik_konwersacja`
--
ALTER TABLE `uzytkownik_konwersacja`
  ADD CONSTRAINT `uzytkownik_konwersacja_ibfk_1` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `uzytkownik_konwersacja_ibfk_2` FOREIGN KEY (`konwersacja_id`) REFERENCES `konwersacja` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `wiadomosc`
--
ALTER TABLE `wiadomosc`
  ADD CONSTRAINT `wiadomosc_ibfk_1` FOREIGN KEY (`konwersacja_id`) REFERENCES `konwersacja` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `wiadomosc_ibfk_2` FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
