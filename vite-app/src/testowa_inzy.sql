-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 06, 2024 at 03:00 PM
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
  `wskazowki` text DEFAULT NULL,
  `rodzaj` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gotowy_plan`
--

CREATE TABLE `gotowy_plan` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) DEFAULT NULL,
  `opis` text DEFAULT NULL,
  `trening_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gotowy_plan_cwiczenie`
--

CREATE TABLE `gotowy_plan_cwiczenie` (
  `id` int(11) NOT NULL,
  `gotowy_plan_id` int(11) NOT NULL,
  `cwiczenie_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grupa_treningowa`
--

CREATE TABLE `grupa_treningowa` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) DEFAULT NULL,
  `uzytkownik_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grupa_treningowa`
--

INSERT INTO `grupa_treningowa` (`id`, `nazwa`, `uzytkownik_id`) VALUES
(1, '2015', NULL);

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

-- --------------------------------------------------------

--
-- Table structure for table `rodzic_dziecko`
--

CREATE TABLE `rodzic_dziecko` (
  `rodzic_id` int(11) NOT NULL,
  `dziecko_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trening`
--

CREATE TABLE `trening` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) DEFAULT NULL,
  `opis` text DEFAULT NULL,
  `uzytkownik_id` int(11) DEFAULT NULL,
  `grupa_treningowa_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutorial`
--

CREATE TABLE `tutorial` (
  `id` int(11) NOT NULL,
  `sciezka` varchar(255) DEFAULT NULL,
  `opis` text DEFAULT NULL,
  `cwiczenie_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 'marcelek04', 'kajtus321', 'Marcel', 'Scigaj', 'marcel.nieznajomy@wp.pl', NULL, 'Trener', NULL, 0, '2024-01-29 16:41:26', '2024-01-29 16:41:26');

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `gotowy_plan_id` (`gotowy_plan_id`),
  ADD KEY `cwiczenie_id` (`cwiczenie_id`);

--
-- Indexes for table `grupa_treningowa`
--
ALTER TABLE `grupa_treningowa`
  ADD PRIMARY KEY (`id`),
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gotowy_plan`
--
ALTER TABLE `gotowy_plan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gotowy_plan_cwiczenie`
--
ALTER TABLE `gotowy_plan_cwiczenie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grupa_treningowa`
--
ALTER TABLE `grupa_treningowa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `konwersacja`
--
ALTER TABLE `konwersacja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trening`
--
ALTER TABLE `trening`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tutorial`
--
ALTER TABLE `tutorial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `uzytkownik`
--
ALTER TABLE `uzytkownik`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
