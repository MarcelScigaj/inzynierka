/*WERSJA OSTATECZNA???*/

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
--

CREATE DATABASE IF NOT EXISTS `testowa_inzy` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `testowa_inzy`;

-- --------------------------------------------------------


CREATE TABLE `uzytkownik` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `haslo` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `imie` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nazwisko` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefon` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rola` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `avatarUrl` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `aktywowane` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


INSERT INTO `uzytkownik` (`id`, `login`, `haslo`, `imie`, `nazwisko`, `email`, `telefon`, `rola`, `avatarUrl`, `aktywowane`, `created_at`, `updated_at`) VALUES
(1, 'marcelek04', 'precel2115', 'Marcel', 'Scigaj', 'marcel@gmail.com', '123456789', 'Trener', 'avatar_url', 1, NOW(), NOW()),
(2, 'Baranek2115', '$2y$10$3WOJvJ4eoWc/0YrF8EHLPeKi26qVkcXebbknb.0Xc3f/wtU.sV/Zy', 'Bartosz', 'Zmarzly', 'baranek2115@wp.pl', NULL, 'dziecko', '/storage/avatars/1707237764.png', 0, '2024-02-06 14:30:49', '2024-02-06 15:42:44'),
(3, 'testowanie123', 'password', 'Rafał', 'Masny', 'rafal@example.com', '987654321', 'Trener', 'avatar_url', 1, NOW(), NOW());



--
-- Table structure for table `cwiczenie`
--

CREATE TABLE `cwiczenie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `opis` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `rodzaj` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gotowy_plan`
--

INSERT INTO `gotowy_plan` (`id`, `nazwa`) VALUES
(1, 'Testowanie'),
(2, 'Gra w berka'),
(3, 'Trening Podania');

-- --------------------------------------------------------

--
-- Table structure for table `gotowy_plan_cwiczenie`
--

CREATE TABLE `gotowy_plan_cwiczenie` (
  `gotowy_plan_id` int(11) NOT NULL,
  `cwiczenie_id` int(11) NOT NULL,
  PRIMARY KEY (`gotowy_plan_id`,`cwiczenie_id`),
  FOREIGN KEY (`gotowy_plan_id`) REFERENCES `gotowy_plan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`cwiczenie_id`) REFERENCES `cwiczenie` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gotowy_plan_cwiczenie`
--

INSERT INTO `gotowy_plan_cwiczenie` (`gotowy_plan_id`, `cwiczenie_id`) VALUES
(1, 3),
(1, 7),
(1, 9),
(2, 9),
(2, 4),
(2, 1),
(3, 3),
(3, 5),
(3, 8),
(3, 7);

-- --------------------------------------------------------

--
-- Table structure for table `grupa_treningowa`
--

CREATE TABLE `grupa_treningowa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uzytkownik_id` int(11) DEFAULT NULL COMMENT 'JAKI TRENER PRZYPISANY DO GRUPY',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grupa_treningowa`
--

INSERT INTO `grupa_treningowa` (`id`, `nazwa`, `uzytkownik_id`) VALUES
(1, '2015',1 ),
(2, '2008',3);

-- --------------------------------------------------------

--
-- Table structure for table `grupa_treningowa_uzytkownik`
--

CREATE TABLE `grupa_treningowa_uzytkownik` (
  `grupa_treningowa_id` int(11) NOT NULL,
  `uzytkownik_id` int(11) NOT NULL,
  PRIMARY KEY (`grupa_treningowa_id`,`uzytkownik_id`),
  FOREIGN KEY (`grupa_treningowa_id`) REFERENCES `grupa_treningowa` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grupa_treningowa_uzytkownik`
--

INSERT INTO `grupa_treningowa_uzytkownik` (`grupa_treningowa_id`, `uzytkownik_id`) VALUES
(1, 2);


-- --------------------------------------------------------

--
-- Table structure for table `konwersacja`
--

CREATE TABLE `konwersacja` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typ` enum('prywatna','grupowa') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `grupa_treningowa_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`grupa_treningowa_id`) REFERENCES `grupa_treningowa` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tokenable_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `token` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `abilities` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_used_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rodzic_dziecko`
--

CREATE TABLE `rodzic_dziecko` (
  `rodzic_id` int(11) NOT NULL,
  `dziecko_id` int(11) NOT NULL,
  PRIMARY KEY (`rodzic_id`, `dziecko_id`),
  FOREIGN KEY (`rodzic_id`) REFERENCES `uzytkownik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`dziecko_id`) REFERENCES `uzytkownik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trening`
--

CREATE TABLE `trening` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `opis` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uzytkownik_id` int(11) DEFAULT NULL,
  `grupa_treningowa_id` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `godzina` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (`grupa_treningowa_id`) REFERENCES `grupa_treningowa` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tutorial`
--

CREATE TABLE `tutorial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sciezka_zdjecie` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sciezka_film` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `cwiczenie_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`cwiczenie_id`) REFERENCES `cwiczenie` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `uzytkownik`
--


-- --------------------------------------------------------

--
-- Table structure for table `uzytkownik_konwersacja`
--

CREATE TABLE `uzytkownik_konwersacja` (
  `uzytkownik_id` int(11) NOT NULL,
  `konwersacja_id` int(11) NOT NULL,
  PRIMARY KEY (`uzytkownik_id`,`konwersacja_id`),
  FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`konwersacja_id`) REFERENCES `konwersacja` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wiadomosc`
--

CREATE TABLE `wiadomosc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tresc` text COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dataWyslania` datetime DEFAULT NULL,
  `konwersacja_id` int(11) DEFAULT NULL,
  `uzytkownik_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`konwersacja_id`) REFERENCES `konwersacja` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (`uzytkownik_id`) REFERENCES `uzytkownik` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
