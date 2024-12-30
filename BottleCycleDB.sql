-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 30, 2024 at 05:59 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bottlecycle-ctu`
--

-- --------------------------------------------------------

--
-- Table structure for table `bin_status`
--

CREATE TABLE `bin_status` (
  `id` int(11) NOT NULL,
  `bin_id` varchar(255) NOT NULL,
  `is_full` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bin_status`
--

INSERT INTO `bin_status` (`id`, `bin_id`, `is_full`, `timestamp`) VALUES
(1, 'BIN002', 2, '2024-12-09 06:13:07'),
(2, 'BIN002', 0, '2024-12-09 06:13:10'),
(3, 'BIN002', 1, '2024-12-09 06:13:24'),
(4, 'BIN002', 2, '2024-12-09 06:13:31'),
(5, 'BIN002', 3, '2024-12-09 06:14:41'),
(6, 'BIN002', 1, '2024-12-09 06:15:19'),
(7, 'BIN001', 0, '2024-12-09 06:21:22'),
(8, 'BIN001', 3, '2024-12-09 06:22:28'),
(9, 'JomartBins', 1, '2024-12-21 04:32:54'),
(10, 'JomartBins', 0, '2024-12-21 04:33:49'),
(11, 'JomartBins0', 0, '2024-12-21 04:41:08');

--
-- Triggers `bin_status`
--
DELIMITER $$
CREATE TRIGGER `after_bin_status_update` AFTER INSERT ON `bin_status` FOR EACH ROW BEGIN
    DECLARE totalSmall INT;
    DECLARE totalMedium INT;
    DECLARE totalLarge INT;
    DECLARE totalBottles INT;

    -- Check if `is_full` is 3
    IF NEW.is_full = 3 THEN
        -- Verify if a matching `bin_code` exists in bin_summary
        IF EXISTS (SELECT 1 FROM bin_summary WHERE bin_code = NEW.bin_id) THEN
            -- Retrieve the current values from bin_summary
            SELECT total_small, total_medium, total_large, total_bottles
            INTO totalSmall, totalMedium, totalLarge, totalBottles
            FROM bin_summary
            WHERE bin_code = NEW.bin_id;

            -- Insert the retrieved data into bottles_collected
            INSERT INTO bottles_collected (bin_code, total_small, total_medium, total_large, total_bottles, timestamp)
            VALUES (NEW.bin_id, totalSmall, totalMedium, totalLarge, totalBottles, CURRENT_TIMESTAMP());

            -- Reset the size fields in bin_summary for the matched bin_code
           UPDATE bin_summary
SET total_small = 0, total_medium = 0, total_large = 0, total_bottles = 0
WHERE TRIM(bin_code) = TRIM(NEW.bin_id);
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bin_summary`
--

CREATE TABLE `bin_summary` (
  `id` int(11) NOT NULL,
  `bin_code` varchar(255) NOT NULL,
  `total_small` int(11) NOT NULL DEFAULT 0,
  `total_medium` int(11) NOT NULL DEFAULT 0,
  `total_large` int(11) NOT NULL DEFAULT 0,
  `total_bottles` int(11) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bin_summary`
--

INSERT INTO `bin_summary` (`id`, `bin_code`, `total_small`, `total_medium`, `total_large`, `total_bottles`, `timestamp`) VALUES
(1, 'BIN002', 0, 0, 0, 0, '2024-12-09 06:11:46'),
(2, 'BIN001', 0, 0, 0, 0, '2024-12-09 06:19:36'),
(3, 'JomartBins', 0, 0, 10, 10, '2024-12-21 04:32:54');

-- --------------------------------------------------------

--
-- Table structure for table `bottles_collected`
--

CREATE TABLE `bottles_collected` (
  `id` int(11) NOT NULL,
  `bin_code` varchar(255) NOT NULL,
  `total_small` int(11) NOT NULL DEFAULT 0,
  `total_medium` int(11) NOT NULL DEFAULT 0,
  `total_large` int(11) NOT NULL DEFAULT 0,
  `total_bottles` int(11) NOT NULL DEFAULT 0,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bottles_collected`
--

INSERT INTO `bottles_collected` (`id`, `bin_code`, `total_small`, `total_medium`, `total_large`, `total_bottles`, `timestamp`) VALUES
(1, 'BIN002', 1, 1, 0, 2, '2024-12-09 06:14:41'),
(2, 'BIN001', 1, 2, 1, 4, '2024-12-09 06:22:28');

-- --------------------------------------------------------

--
-- Table structure for table `bottle_bins`
--

CREATE TABLE `bottle_bins` (
  `id` int(11) NOT NULL,
  `bin_code` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bottle_bins`
--

INSERT INTO `bottle_bins` (`id`, `bin_code`, `address`, `latitude`, `longitude`, `created_at`) VALUES
(1, 'BIN001', '1 Tabotabo Street Barangay V, Tuburan, Cebu, Philippines', 10.72750366, 123.82537995, '2024-12-09 06:10:08'),
(2, 'BIN002', 'Rizal Street Barangay VIII, Tuburan, Cebu, Philippines', 10.72206097, 123.82243693, '2024-12-09 06:13:55'),
(3, 'Jomart Bins', 'L. Gabuya Street Basak San Nicolas, Cebu City, Philippines', 10.28654794, 123.87082728, '2024-12-21 04:31:43'),
(4, 'Jomart Bins', 'L. Gabuya Street Basak San Nicolas, Cebu City, Philippines', 10.28654794, 123.87082728, '2024-12-21 04:31:45'),
(5, 'JomartBins', 'L. Gabuya Street Basak San Nicolas, Cebu City, Philippines', 10.28654794, 123.87082728, '2024-12-21 04:31:48');

-- --------------------------------------------------------

--
-- Table structure for table `bottle_bin_data`
--

CREATE TABLE `bottle_bin_data` (
  `id` int(11) NOT NULL,
  `bin_id` varchar(255) NOT NULL,
  `size_type` enum('large','medium','small') NOT NULL,
  `quantity` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bottle_bin_data`
--

INSERT INTO `bottle_bin_data` (`id`, `bin_id`, `size_type`, `quantity`, `timestamp`) VALUES
(1, 'BIN002', 'small', 1, '2024-12-09 06:11:45'),
(2, 'BIN002', 'medium', 1, '2024-12-09 06:11:46'),
(3, 'BIN001', 'small', 1, '2024-12-09 06:19:29'),
(4, 'BIN001', 'medium', 1, '2024-12-09 06:19:31'),
(5, 'BIN001', 'large', 1, '2024-12-09 06:19:34'),
(6, 'BIN001', 'medium', 1, '2024-12-09 06:19:36'),
(7, 'JomartBins', 'large', 10, '2024-12-21 04:32:54');

--
-- Triggers `bottle_bin_data`
--
DELIMITER $$
CREATE TRIGGER `after_insert_bottle_bin_data` AFTER INSERT ON `bottle_bin_data` FOR EACH ROW BEGIN
    -- Declare variables to store the summed quantities
    DECLARE total_small INT;
    DECLARE total_medium INT;
    DECLARE total_large INT;
    DECLARE total_bottles INT;

    -- Calculate the summed quantities for this bin_id and date
    SELECT 
        SUM(CASE WHEN size_type = 'small' THEN quantity ELSE 0 END),
        SUM(CASE WHEN size_type = 'medium' THEN quantity ELSE 0 END),
        SUM(CASE WHEN size_type = 'large' THEN quantity ELSE 0 END)
    INTO total_small, total_medium, total_large
    FROM bottle_bin_data
    WHERE bin_id = NEW.bin_id AND DATE(timestamp) = CURDATE();

    -- Calculate total bottles
    SET total_bottles = total_small + total_medium + total_large;

    -- Check if a record already exists for the bin_id and date
    IF EXISTS (SELECT 1 FROM bin_summary WHERE bin_code = NEW.bin_id AND DATE(timestamp) = CURDATE()) THEN
        -- If it exists, update the record
        UPDATE bin_summary
        SET 
            total_small = total_small, 
            total_medium = total_medium,
            total_large = total_large,
            total_bottles = total_bottles,
            timestamp = CURRENT_TIMESTAMP
        WHERE bin_code = NEW.bin_id AND DATE(timestamp) = CURDATE();
    ELSE
        -- If no record exists, insert a new one
        INSERT INTO bin_summary (bin_code, total_small, total_medium, total_large, total_bottles, timestamp)
        VALUES (NEW.bin_id, total_small, total_medium, total_large, total_bottles, CURRENT_TIMESTAMP);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bottle_counts`
--

CREATE TABLE `bottle_counts` (
  `id` int(11) NOT NULL,
  `bin_id` varchar(50) NOT NULL,
  `small_count` int(11) NOT NULL,
  `medium_count` int(11) NOT NULL,
  `large_count` int(11) NOT NULL,
  `is_full` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jomartbins`
--

CREATE TABLE `jomartbins` (
  `id` int(11) NOT NULL,
  `small_bottle_counts` int(11) DEFAULT NULL,
  `medium_bottle_counts` int(11) DEFAULT NULL,
  `large_bottle_counts` int(11) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `large_bottle_counts`
--

CREATE TABLE `large_bottle_counts` (
  `id` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `large_bottle_counts`
--

INSERT INTO `large_bottle_counts` (`id`, `count`, `timestamp`) VALUES
(1, 0, '2024-11-10 11:57:55'),
(2, 1, '2024-11-10 11:58:20'),
(3, 2, '2024-11-10 11:58:28'),
(4, 3, '2024-11-10 11:58:35'),
(5, 4, '2024-11-10 11:59:15'),
(6, 5, '2024-11-10 12:12:16'),
(7, 6, '2024-11-10 12:12:17'),
(8, 7, '2024-11-10 12:12:18'),
(9, 8, '2024-11-10 12:12:18'),
(10, 9, '2024-11-10 12:12:19'),
(11, 10, '2024-11-10 12:12:21'),
(12, 11, '2024-11-10 12:12:22'),
(13, 12, '2024-11-10 12:12:25'),
(14, 13, '2024-11-10 14:16:22'),
(15, 14, '2024-11-10 14:16:27'),
(16, 15, '2024-11-10 15:34:18'),
(17, 16, '2024-11-10 15:34:21'),
(18, 17, '2024-11-10 15:34:23'),
(19, 18, '2024-11-10 15:34:24'),
(20, 19, '2024-11-10 15:34:25'),
(21, 20, '2024-11-10 15:34:26'),
(22, 21, '2024-11-10 15:34:28'),
(23, 22, '2024-11-10 15:34:30'),
(24, 0, '2024-11-18 15:17:06'),
(25, 1, '2024-11-18 15:22:06'),
(26, 2, '2024-11-18 15:22:45'),
(27, 3, '2024-11-18 15:27:46'),
(28, 4, '2024-11-18 15:37:11');

-- --------------------------------------------------------

--
-- Table structure for table `medium_bottle_counts`
--

CREATE TABLE `medium_bottle_counts` (
  `id` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medium_bottle_counts`
--

INSERT INTO `medium_bottle_counts` (`id`, `count`, `timestamp`) VALUES
(1, 0, '2024-11-10 11:57:55'),
(2, 1, '2024-11-10 11:58:19'),
(3, 2, '2024-11-10 11:58:21'),
(4, 3, '2024-11-10 11:58:22'),
(5, 4, '2024-11-10 11:58:23'),
(6, 5, '2024-11-10 11:58:24'),
(7, 6, '2024-11-10 11:58:25'),
(8, 7, '2024-11-10 11:58:26'),
(9, 8, '2024-11-10 11:58:27'),
(10, 9, '2024-11-10 11:58:29'),
(11, 10, '2024-11-10 11:58:31'),
(12, 11, '2024-11-10 11:58:32'),
(13, 12, '2024-11-10 11:58:35'),
(14, 13, '2024-11-10 11:58:36'),
(15, 14, '2024-11-10 11:59:15'),
(16, 15, '2024-11-10 11:59:16'),
(17, 16, '2024-11-10 12:12:16'),
(18, 17, '2024-11-10 12:12:20'),
(19, 18, '2024-11-10 12:12:21'),
(20, 19, '2024-11-10 12:12:23'),
(21, 20, '2024-11-10 12:12:25'),
(22, 21, '2024-11-10 12:12:26'),
(23, 22, '2024-11-10 12:12:27'),
(24, 23, '2024-11-10 15:34:21'),
(25, 24, '2024-11-10 15:34:22'),
(26, 25, '2024-11-10 15:34:23'),
(27, 26, '2024-11-10 15:34:25'),
(28, 27, '2024-11-10 15:34:26'),
(29, 28, '2024-11-10 15:34:27'),
(30, 29, '2024-11-10 15:34:28'),
(31, 30, '2024-11-10 15:34:29'),
(32, 31, '2024-11-10 15:34:30'),
(33, 0, '2024-11-18 15:17:06'),
(34, 1, '2024-11-18 15:18:04'),
(35, 0, '2024-11-18 15:22:06'),
(36, 1, '2024-11-18 15:28:04');

-- --------------------------------------------------------

--
-- Table structure for table `small_bottle_counts`
--

CREATE TABLE `small_bottle_counts` (
  `id` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `small_bottle_counts`
--

INSERT INTO `small_bottle_counts` (`id`, `count`, `timestamp`) VALUES
(1, 1, '2024-11-10 11:57:55'),
(2, 2, '2024-11-10 11:58:09'),
(3, 3, '2024-11-10 11:58:19'),
(4, 4, '2024-11-10 11:58:20'),
(5, 5, '2024-11-10 11:58:22'),
(6, 6, '2024-11-10 11:58:24'),
(7, 7, '2024-11-10 11:58:26'),
(8, 8, '2024-11-10 11:58:27'),
(9, 9, '2024-11-10 11:58:28'),
(10, 10, '2024-11-10 11:58:29'),
(11, 11, '2024-11-10 11:58:29'),
(12, 12, '2024-11-10 11:58:30'),
(13, 13, '2024-11-10 11:58:35'),
(14, 14, '2024-11-10 11:58:36'),
(15, 15, '2024-11-10 11:59:13'),
(16, 16, '2024-11-10 11:59:14'),
(17, 17, '2024-11-10 11:59:15'),
(18, 18, '2024-11-10 11:59:16'),
(19, 19, '2024-11-10 12:12:19'),
(20, 20, '2024-11-10 12:12:20'),
(21, 21, '2024-11-10 12:12:20'),
(22, 22, '2024-11-10 12:12:22'),
(23, 23, '2024-11-10 12:12:24'),
(24, 24, '2024-11-10 12:12:25'),
(25, 25, '2024-11-10 14:12:00'),
(26, 26, '2024-11-10 14:32:34'),
(27, 25, '2024-11-10 14:32:50'),
(28, 26, '2024-11-10 14:32:58'),
(29, 27, '2024-11-10 15:34:17'),
(30, 28, '2024-11-10 15:34:23'),
(31, 29, '2024-11-10 15:34:24'),
(32, 30, '2024-11-10 15:34:26'),
(33, 31, '2024-11-10 15:34:27'),
(34, 32, '2024-11-10 15:34:28'),
(35, 33, '2024-11-10 15:34:29'),
(36, 34, '2024-11-10 15:34:29'),
(37, 0, '2024-11-18 15:17:06'),
(38, 1, '2024-11-18 15:19:26'),
(39, 0, '2024-11-18 15:22:06'),
(40, 1, '2024-11-18 15:27:54');

-- --------------------------------------------------------

--
-- Table structure for table `trigger_log`
--

CREATE TABLE `trigger_log` (
  `id` int(11) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trigger_log`
--

INSERT INTO `trigger_log` (`id`, `message`, `timestamp`) VALUES
(1, 'Trigger activated for bin_id: BIN008', '2024-12-08 08:01:02'),
(2, 'Trigger activated for bin_id: BIN009', '2024-12-08 08:01:07'),
(3, 'Trigger activated for bin_id: BIN009', '2024-12-08 08:01:24'),
(4, 'is_full = 3 check passed for bin_id: BIN009', '2024-12-08 08:01:24'),
(5, 'Matching bin_code found for bin_id: BIN009', '2024-12-08 08:01:24'),
(6, 'Reset fields completed for bin_code: BIN009', '2024-12-08 08:01:24'),
(7, 'Trigger activated for bin_id: BIN0010', '2024-12-08 08:10:47'),
(8, 'Trigger activated for bin_id: BIN0011', '2024-12-08 08:10:52'),
(9, 'Trigger activated for bin_id: BIN0011', '2024-12-08 08:11:04'),
(10, 'is_full = 3 check passed for bin_id: BIN0011', '2024-12-08 08:11:04'),
(11, 'Matching bin_code found for bin_id: BIN0011', '2024-12-08 08:11:04'),
(12, 'Reset fields completed for bin_code: BIN0011', '2024-12-08 08:11:04');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `created_at`) VALUES
(2, 'gdurano.shs@gmail.com', '$2y$10$O5MB5kFTMKdQt5Qp6XCi2eZOY5kyh750v/MpGtf.k2H.XmO3xIHxK', '2024-10-18 08:53:37'),
(3, 'NoeGwapo@gmail.com', '$2y$10$sQhKjeimfkB0bIPdmY/Jh.4bd8mO2rP.k2N2tR5QBzIZs32OFMN/2', '2024-10-18 09:10:47'),
(4, 'noe1@gmail.com', '$2y$10$VH.Shbsp/dLT02D55DI9/eUYq6BIEj1lZ6LrgdSB9Hp3BTr4fBzY.', '2024-10-18 09:33:01'),
(5, 'zajk@gmail.com', '$2y$10$9sl8UG4u7sCdS1zHYsm1u..hNgdYtMePQ0xse4aEvbBF5whilu9nq', '2024-10-18 10:56:11'),
(6, 'NoeJohnTheGreat@gmail.com', '$2y$10$WsjL5brMTnupqolMq93bzeDp.J2rYuTx0.OlfU/M7IVMcLTIE56cu', '2024-10-18 11:21:54'),
(7, 'noe11@gmail.com', '$2y$10$kNrFFVy723VwmTxdMFPG5uaRUOJmd2mhp.jg0yQoGzl211LP85k4u', '2024-10-18 11:23:18'),
(8, 'npe123@gmail.com', '$2y$10$4mCQUSOpDLvIFgoFupTa0.HkZEx8yjN.VcxPpcw2sxFgIp2wKBGXq', '2024-10-18 11:23:44'),
(9, 'noe121@gmail.com', '$2y$10$O29s.CxAulcI4NzYgW4w/.4bOP.aaZwkREh4FbFyWS/AlUzTCvP6K', '2024-10-18 11:24:23'),
(10, 'noe1211@gmail.com', '$2y$10$r/aD1MeI6aXdwoVTt3Z/k.sp12PALbReEZn/6SdgatT4ksWO1f/wm', '2024-10-18 11:24:42'),
(11, 'lawskie@gmail.com', '$2y$10$VGB6DlnZ0z4jHx6l/P0AX.u8FoXViZAG5CMzf4gRDZFDclW/RkB1y', '2024-10-18 11:26:09'),
(12, 'andoy@gmail.com', '$2y$10$6OGXlo75tEvlq3JZvlmHU..i7B/y/HBkMsuFOpYjF0.Mi/UoRvrSq', '2024-10-18 11:30:51'),
(13, 'nicolastesla@gmail.com', '$2y$10$O.LWwiIH0L6zBoIak5r3RO1ocMhAVglNQ7rIYAHH/w9hznp5Ev3W2', '2024-10-18 11:37:15'),
(14, 'sean@gmail.com', '$2y$10$DhQI2ZTyUIropmq/SJNCr.rNScjJjkDTShppFopTlIOGxwo2LEyMu', '2024-10-18 11:56:42'),
(15, 'noejohngwapo@gmail.com', '$2y$10$l1TtpD13MZQAjRoWSnzDBeUAtHxslRp3Owgvt6T0Bk3POTBi6ZI1q', '2024-10-18 12:29:07'),
(16, 'noe24@gmail.com', '$2y$10$cqlxjgoeaHlVaM2C4bqr.OnGgvFj2RHTtHNQD21nn3VZFR2SD4dbC', '2024-10-20 05:39:39'),
(17, 'purisima@gmail.com', '$2y$10$UXMx2EsszMKmyB35nRRDguVmpDpn6jwmj80nj3BgmBLbAJUlPhjwG', '2024-10-20 14:26:02'),
(18, 'gd@gmial.com', '$2y$10$HJIHzdQBUd9J.7ulP4oFv.l0g5nDGMyu6fz8Ag0NRPBtqF.zHvsQS', '2024-10-26 16:20:55'),
(19, 'gong@gmail.com', '$2y$10$Ubxdc5wDJmrSdj1BA7KpE.n89C2O4zheNEpXaPmT1aNVUngdQLw22', '2024-10-29 15:54:17'),
(20, 'gdurano.shs1@gmail.com', '$2y$10$.oGH8VesleVlDreQcQW1n.fjoLAWO/yx0RArSFq4KPuHiETJiZ1mq', '2024-10-30 18:38:57'),
(21, 'noe21@gmail.com', '$2y$10$EC/uECm0/bwtiSNsbd6TZOLVyXn86NwJ/0z/GhzKKpRU8W64vc6.u', '2024-10-30 18:43:05'),
(22, 'noe12@gmail.com', '$2y$10$kGZe7Njdg2l6pH8J5A6NtuyAfq146RX3dTons7dEZYnJT/5P70rwy', '2024-10-30 18:49:20'),
(23, 'gerald@gmail.com', '$2y$10$oRnhMYdXYmqS66VQ6AA0MecgjyBraSE.pF5aqPy9PvY.k.W7rOPTS', '2024-10-30 18:49:53'),
(24, 'ger@gmail.com', '$2y$10$jubSP8udx6vxwH01pMODuuPBl1FCdqQlnQOXYxkW4F2ORK8Ss44IW', '2024-10-30 18:50:37'),
(25, 'vv@gmail.com', '$2y$10$BKDKLE8FqHLtjCFYS7DqseXhx8Y9dT.fwmMPH4HM/WrFvFCwJUUBG', '2024-10-30 18:53:18'),
(26, 'jm@gmail.com', '$2y$10$FYXGUg0Nt0Y6WuD0IRP5au7mkIgrldYO6yfjLvnu3gB27INI4Ppuq', '2024-10-31 16:08:07'),
(27, '123@gmail.com', '$2y$10$eRbsEnrvmrC1sPmyKdUxquuuVPVc7LcDchSV/ehhHFizEttzNupBC', '2024-10-31 19:31:38'),
(28, 'ger1@gmail.com', '$2y$10$093IDo2XhazRl2Nwff/i3.us4859L41QxOpTIT0T52onbqlmQ6X5K', '2024-11-01 07:15:30'),
(29, 'MelodyCutie@gmail.com', '$2y$10$iWK5NnOjrRXRUsvWO08MVeO./IVSovKNjELDs8zUrc6JqvfgUZ.uq', '2024-11-05 14:03:06'),
(30, 'nicolasbuhia@gmail.com', '$2y$10$LQWy3L6p3Tsl.pf3Rr0Je.BTqlM.Aq3hGxcX11ZKFzEyj4g99a0mK', '2024-11-07 10:52:18'),
(31, 'james@gmail.com', '$2y$10$FE/DsHcCwpOKQ0OwtO6PiuqyCpb9IpYwtJfB3JlDPCvDUKaPPoNHe', '2024-11-08 02:50:43');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bin_status`
--
ALTER TABLE `bin_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bin_summary`
--
ALTER TABLE `bin_summary`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bottles_collected`
--
ALTER TABLE `bottles_collected`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bottle_bins`
--
ALTER TABLE `bottle_bins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bottle_bin_data`
--
ALTER TABLE `bottle_bin_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bottle_counts`
--
ALTER TABLE `bottle_counts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jomartbins`
--
ALTER TABLE `jomartbins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `large_bottle_counts`
--
ALTER TABLE `large_bottle_counts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `medium_bottle_counts`
--
ALTER TABLE `medium_bottle_counts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `small_bottle_counts`
--
ALTER TABLE `small_bottle_counts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trigger_log`
--
ALTER TABLE `trigger_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bin_status`
--
ALTER TABLE `bin_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `bin_summary`
--
ALTER TABLE `bin_summary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `bottles_collected`
--
ALTER TABLE `bottles_collected`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `bottle_bins`
--
ALTER TABLE `bottle_bins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `bottle_bin_data`
--
ALTER TABLE `bottle_bin_data`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `bottle_counts`
--
ALTER TABLE `bottle_counts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jomartbins`
--
ALTER TABLE `jomartbins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `large_bottle_counts`
--
ALTER TABLE `large_bottle_counts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `medium_bottle_counts`
--
ALTER TABLE `medium_bottle_counts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `small_bottle_counts`
--
ALTER TABLE `small_bottle_counts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `trigger_log`
--
ALTER TABLE `trigger_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
