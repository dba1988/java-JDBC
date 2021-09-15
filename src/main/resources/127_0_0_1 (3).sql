-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 15, 2021 at 06:26 PM
-- Server version: 10.4.10-MariaDB
-- PHP Version: 7.3.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lobotickets`
--
DROP DATABASE IF EXISTS `lobotickets`;
CREATE DATABASE IF NOT EXISTS `lobotickets` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `lobotickets`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `GetActs`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetActs` ()  NO SQL
    DETERMINISTIC
select acts.name, acts.recordlabel
    from acts
    where acts.recordlabel IS NOT NULL
    order by acts.name$$

DROP PROCEDURE IF EXISTS `GetAllProducts`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllProducts` ()  BEGIN
	SELECT *  FROM venues;
END$$

DROP PROCEDURE IF EXISTS `GetTotalSales`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotalSales` (OUT `sales` DECIMAL(8,2))  NO SQL
select sum(currentvalue) 'totalsales' from
        (select ticketssold, price, ticketssold*price 'currentvalue'
         from gigs) salestable
    into sales$$

DROP PROCEDURE IF EXISTS `GigReport`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GigReport` (IN `startdate` DATE, IN `enddate` DATE)  READS SQL DATA
select gigs.date, acts.name 'Act', acts.recordlabel, venues.name 'Venue', ticketssold, venues.capacity
    from gigs
             join acts on acts.id = gigs.actid
             join venues on venues.id = gigs.venueid
    where date >= startdate
      and date <= enddate
    order by gigs.date$$

DROP PROCEDURE IF EXISTS `SetNewPrice`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SetNewPrice` (IN `gigid` INT, IN `percentage` DECIMAL(8,2), INOUT `maxprice` DECIMAL(8,2))  NO SQL
begin
    declare gigprice decimal(8,2) default 0.0;
    declare proposedprice decimal(8,2);


    set gigprice = (select max(price) from gigs where id = gigid);

    set proposedprice = gigprice + (gigprice * percentage);

    if (proposedprice < maxPrice)
    then
        set maxprice = proposedprice;
        update gigs set price = proposedprice where id = gigid;
    else
        set maxprice = gigprice;
    end if;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `acts`
--

DROP TABLE IF EXISTS `acts`;
CREATE TABLE IF NOT EXISTS `acts` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `RecordLabel` varchar(100) DEFAULT '',
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `acts`
--

INSERT INTO `acts` (`Id`, `Name`, `RecordLabel`) VALUES
(1, 'Foo Feathers', 'Copitol'),
(2, 'The Bottles', 'Banana'),
(3, 'BAAB', ''),
(4, 'Alede', ''),
(5, 'Dana Lead Rey', ''),
(6, 'Led Balloon', ''),
(7, 'Sheryl Rook', ''),
(8, 'mohammed', NULL),
(9, 'mohammed', NULL),
(10, 'mohammed', NULL),
(11, 'mohammed', NULL),
(12, 'mohammed', NULL),
(13, 'mohammed', NULL),
(14, 'mohammed', NULL),
(15, 'mohammed', NULL),
(16, 'mohammed', NULL),
(17, 'mohammed', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `gigs`
--

DROP TABLE IF EXISTS `gigs`;
CREATE TABLE IF NOT EXISTS `gigs` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `VenueId` int(11) NOT NULL,
  `ActId` int(11) NOT NULL,
  `TicketsSold` int(11) NOT NULL,
  `Price` decimal(4,2) NOT NULL,
  `Date` date NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `VenueId` (`VenueId`),
  KEY `ActId` (`ActId`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `gigs`
--

INSERT INTO `gigs` (`Id`, `VenueId`, `ActId`, `TicketsSold`, `Price`, `Date`) VALUES
(1, 1, 1, 90, '11.55', '2022-11-04'),
(2, 2, 1, 110, '10.50', '2022-11-05'),
(3, 3, 1, 170, '10.50', '2022-11-06'),
(4, 4, 1, 20, '10.50', '2022-11-08'),
(5, 1, 2, 91, '12.99', '2022-11-05'),
(6, 2, 2, 113, '12.99', '2022-11-04'),
(7, 3, 3, 153, '4.99', '2022-11-07'),
(8, 4, 4, 10, '4.99', '2022-11-04'),
(9, 1, 5, 153, '14.99', '2022-11-06'),
(10, 2, 5, 101, '14.99', '2022-11-10'),
(11, 1, 6, 153, '14.99', '2022-11-07'),
(12, 2, 6, 101, '14.99', '2022-11-09'),
(13, 4, 6, 20, '9.99', '2022-11-05'),
(14, 2, 7, 150, '15.99', '2022-11-08'),
(15, 3, 7, 101, '15.50', '2022-11-04');

-- --------------------------------------------------------

--
-- Table structure for table `venues`
--

DROP TABLE IF EXISTS `venues`;
CREATE TABLE IF NOT EXISTS `venues` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Capacity` int(11) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `venues`
--

INSERT INTO `venues` (`Id`, `Name`, `Capacity`) VALUES
(1, 'The Arena', 100),
(2, 'The Bowl', 150),
(3, 'The Garage', 200),
(4, 'The Yard', 20),
(15, 'mohammed', 200),
(13, 'mohammed', 200),
(11, 'mohammed', 200),
(17, 'mohammed', 200),
(19, 'mohammed', 200),
(21, 'mohammed', 200),
(23, 'mohammed', 200),
(25, 'mohammed', 200),
(27, 'mohammed', 200),
(29, 'mohammed', 200),
(31, 'mohammed', 200),
(33, 'mohammed', 200),
(35, 'mohammed', 200),
(37, 'mohammed', 200),
(39, 'mohammed', 200),
(41, 'mohammed', 200),
(43, 'mohammed', 200),
(45, 'mohammed', 200),
(47, 'mohammed', 200);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
