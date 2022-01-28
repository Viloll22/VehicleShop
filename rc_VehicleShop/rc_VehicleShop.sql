

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


CREATE TABLE IF NOT EXISTS `rc_vehicleshop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `car` varchar(250) NOT NULL,
  `genre` varchar(250) NOT NULL,
  `label` varchar(250) NOT NULL,
  `price` int(100) NOT NULL,
  `img` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;




INSERT INTO `rc_vehicleshop` (`id`, `car`, `genre`, `label`, `price`, `img`) VALUES
(1, 'adder', 'car', 'Adder', 500000, 'https://i.imgur.com/azOor2s.png'),
(2, 'mule', 'truck', 'Mule', 55000, 'https://wiki.rage.mp/images/e/e7/Mule.png'),
(3, 'bati', 'bike', 'Bati', 10000, 'https://i.imgur.com/hXJJL7c.png');


/*!40000 ALTER TABLE `rc_vehicleshop` DISABLE KEYS */;
/*!40000 ALTER TABLE `rc_vehicleshop` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
