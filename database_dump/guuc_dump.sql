-- MySQL dump 10.13  Distrib 5.6.28, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: stud_contest
-- ------------------------------------------------------
-- Server version	5.6.28-0ubuntu0.15.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `FirstStep`
--

DROP TABLE IF EXISTS `FirstStep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FirstStep` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `task` int(11) NOT NULL,
  `time` float NOT NULL,
  `htmlCode` text,
  `cssCode` text,
  `path` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `task` (`task`),
  CONSTRAINT `FirstStep_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FirstStep_ibfk_4` FOREIGN KEY (`task`) REFERENCES `Tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=448 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FirstStep`
--

LOCK TABLES `FirstStep` WRITE;
/*!40000 ALTER TABLE `FirstStep` DISABLE KEYS */;
/*!40000 ALTER TABLE `FirstStep` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Marks`
--

DROP TABLE IF EXISTS `Marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Marks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `mark` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `task_id` (`task_id`),
  CONSTRAINT `Marks_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Marks_ibfk_5` FOREIGN KEY (`task_id`) REFERENCES `Tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Marks`
--

LOCK TABLES `Marks` WRITE;
/*!40000 ALTER TABLE `Marks` DISABLE KEYS */;
INSERT INTO `Marks` VALUES (31,106,12,3),(32,107,12,7),(33,108,12,5),(34,109,12,5),(35,110,12,3),(36,111,12,7);
/*!40000 ALTER TABLE `Marks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Quiz`
--

DROP TABLE IF EXISTS `Quiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Quiz` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stud_id` int(11) NOT NULL,
  `task` int(11) NOT NULL,
  `time` float DEFAULT NULL,
  `selector` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stud_id` (`stud_id`),
  KEY `task` (`task`),
  CONSTRAINT `Quiz_ibfk_3` FOREIGN KEY (`stud_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Quiz_ibfk_4` FOREIGN KEY (`task`) REFERENCES `Tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=781 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Quiz`
--

LOCK TABLES `Quiz` WRITE;
/*!40000 ALTER TABLE `Quiz` DISABLE KEYS */;
/*!40000 ALTER TABLE `Quiz` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Roles`
--

DROP TABLE IF EXISTS `Roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Roles`
--

LOCK TABLES `Roles` WRITE;
/*!40000 ALTER TABLE `Roles` DISABLE KEYS */;
INSERT INTO `Roles` VALUES (1,'admin'),(2,'student');
/*!40000 ALTER TABLE `Roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Steps`
--

DROP TABLE IF EXISTS `Steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Steps`
--

LOCK TABLES `Steps` WRITE;
/*!40000 ALTER TABLE `Steps` DISABLE KEYS */;
INSERT INTO `Steps` VALUES (1,'BugsStep'),(2,'QuizStep'),(3,'HomeStep');
/*!40000 ALTER TABLE `Steps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tasks`
--

DROP TABLE IF EXISTS `Tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `displayNumber` int(11) NOT NULL,
  `weight` int(11) DEFAULT NULL,
  `step_id` int(11) DEFAULT NULL,
  `htmlCode` text,
  `cssCode` text,
  `toDo` text,
  `answares` varchar(50) DEFAULT NULL,
  `deprecatedSelectors` varchar(50) DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `step_id` (`step_id`),
  CONSTRAINT `Tasks_ibfk_1` FOREIGN KEY (`step_id`) REFERENCES `Steps` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tasks`
--

LOCK TABLES `Tasks` WRITE;
/*!40000 ALTER TABLE `Tasks` DISABLE KEYS */;
INSERT INTO `Tasks` VALUES (4,'task 5',5,5,1,'','','You should create a form which has to contain two text fields and submit button. Name of the first text field should be \"firstName\" and name of  the second should be \"lastName\". Action of the form is \"/pass\". After that you put your first name and last name in appropriate fields and submit the form. ',NULL,NULL,1),(5,'task 4',4,4,2,'<div class=\"wrapper\">\n	<a href=\"http://google.com\">google.com</a>\n	<a href=\"http://image.jpg\">image</a>\n	<a href=\"http://another.com\">Anything</a>\n</div>',NULL,NULL,'2',': *',1),(12,'Home task',-1,NULL,3,NULL,NULL,NULL,NULL,NULL,1),(13,'task 1',1,1,2,'<div class=\"info\">\n	<div>Task</div>\n</div>',NULL,NULL,'1','* :',1),(14,'task 2',2,2,2,'<a href=\"http://google.com\" id=\"link1\" class=\"link\">Google</a>\n<a href=\"http://vk.com\" id=\"link2\" class=\"link\">Vk</a>\n<a href=\"http://yandex.ru\" id=\"link3\" class=\"link\">Yandex</a>',NULL,NULL,'2',': *',1),(15,'task3',3,3,2,'<div></div>\n<span></span>\n<p></p>',NULL,NULL,'0,1,2,3','',1),(16,'task 5',5,5,2,'<input type=\"text\">\n<div></div>\n<div></div>\n<span></span>',NULL,NULL,'1,2,3','',1),(17,'task 6',6,6,2,'<input type=\"checkbox\" name=\"show\">\n<input type=\"checkbox\" name=\"show\" checked>\n<input type=\"checkbox\" name=\"show\">',NULL,NULL,'1',': *',1),(18,'task 7',7,7,2,'<div class=\"info\"></div>\n<div class=\"card\"></div>\n<div class=\"card\"></div>\n<div class=\"card\"></div>',NULL,NULL,'1',': *',1),(19,'task 8',8,8,2,'<div class=\"card card1\">\n	<div class=\"card1\"></div>\n</div>\n<div class=\"card\"></div>',NULL,NULL,'0',':',1),(20,'task 9',9,9,2,'<div>\n	<div class=\"task\"></div>\n</div>\n<div>\n	<div class=\"task\"></div>\n	<div class=\"task\"></div>\n</div>',NULL,NULL,'1','',1),(21,'task 10',10,10,2,'<ul>\n	<li>Item 1</li>\n	<li>Item 2</li>\n	<li>Item 3</li>\n</ul>',NULL,NULL,'3','',1),(22,'task 11',11,11,2,'<table>\n	<thead>\n		<tr>\n			<th>Name</th>\n			<th>Surname</th>\n		</tr>\n	</thead>\n	<tbody>\n		<tr>\n			<td><a href=\"\">Ivan</a></td>\n			<td>Ivanov</td>\n		</tr>\n		<tr>\n			<td>Gleb</td>\n			<td>Glebov</td>\n		</tr>\n		<tr>\n			<td>Alex</td>\n			<td>Alexovich</td>\n		</tr>\n	</tbody>\n</table>',NULL,NULL,'8,16','',1),(23,'task 12',12,12,2,'<ul class=\"list\">\n	<li>Item 1</li>\n	<li>Item 2</li>\n	<li>\n		Item 3\n		<ul>\n			<li>Item 3.1</li>\n			<li>Item 3.2</li>\n			<li>\n				Item 3.3\n				<ul>\n					<li>Item 3.3.1</li>\n					<li>Item 3.3.2</li>\n				</ul>\n			</li>\n		</ul>\n	</li>\n</ul>',NULL,NULL,'2','',1),(25,'task 1',1,1,1,'<ol>\n  <li>\n    Item 1\n    <ul>\n      <li>Item 1.1</li>\n      <li>Item 1.2</li>\n      <li>Item 1.3</li>\n    </ul>\n  </li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n</ol>','ul {\n  list-style: none; \n}\nli {\n  font-size: 1.5em;\n  font-family: sans serif;\n}','1. All items should have the same size of font.<br>\n2. Unordered list should have black square before each item.<br>\n3. Color of text should be #7F993A.',NULL,NULL,1),(26,'task 2',2,2,1,'<table>\n	<thead>\n		<tr>\n					<th>Name</th>\n		<th>Adress</th>\n		</tr>\n	</thead>\n	<tbody>\n		<tr>\n			<td>\n				Ivan Ivanov\n			</td>\n			<td>\n			 	Chargoggagoggmanchauggagoggchaubunagungamaugg\n			</td>\n		</tr>\n		<tr>\n			<td>\n				Serhei Wolfeschlegelsteinhausehausenbergerdorff\n			</td>\n			<td>\n				Long road street 12\n			</td>\n		</tr>\n	</tbody>\n</table>','td, th {\n	border: 1px solid black;\n}\n\ntable {\n	width: 100%;\n	table-layout: fixed;\n}','1. The table has to fill the entire width of the results window without scroll.<br>\n2. Font should be Helvetica or Arial.<br>\n3. If text is longer then a table cell then it should be cut with three dots at the end.<br>\n5. Word wrap shouldn\'t be in the cells.<br>\n4. The cells should have single border without any space between them.',NULL,NULL,1),(27,'task 3',3,3,1,'<div class=\"info infobox\">\n	<ul class=\"menu\">\n		<li>Competition</li>\n		<li>Results</li>\n		<li>About us</li>\n	</ul>\n	Welcom to the first Gomel UXD competition\n</div>','ul {\n	list-style: none;\n	padding: 0;\n	margin: 0;\n	float: right;\n}\n\nul>li {\n	font-family: Helvetica, Arial;\n	width: 200px;\n	padding: 20px 0;\n	text-align: center;\n	color: white;\n	background-color: #7F993A;\n	cursor: pointer;\n}\n\ndiv {\n	background-color: #1A9CB0;\n	color: white;\n	border: 2px solid gray;\n}\n','1. The parent element (class=\"info\") should have the same height as his child (menu), i.e the info block shouldn\'t collapse.<br>\n2.  Font in the info block has to be the same as in the menu.<br>\n3. When an item in the menu is hovered, background color should be #1A9CB0. ',NULL,NULL,1),(28,'task 4',4,4,1,'<div class=\"overlay\">\n	<div class=\"popup\"></div>\n</div>','.overlay {\n	position: fixed;\n	top: 0;\n	bottom: 0;\n	left: 0;\n	right: 0;\n	background-color: rgba(0, 0, 0, 0.5);\n}\n\n.popup {\n	height: 200px;\n	width: 200px;\n	background-color: #FFF;\n}','Popup should be at the center of the window',NULL,NULL,1);
/*!40000 ALTER TABLE `Tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `firstName` varchar(50) DEFAULT NULL,
  `lastName` varchar(50) DEFAULT NULL,
  `role` int(11) NOT NULL,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `role` (`role`),
  CONSTRAINT `Users_ibfk_1` FOREIGN KEY (`role`) REFERENCES `Roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (3,'admin','d033e22ae348aeb5660fc2140aec35850c4da997','Admin','Adminych',1,1),(106,'Aleksandr_Kolymago','7339c402b568c1600ca9e7fb7f349020ce948ad8','Aleksandr','Kolymago',2,1),(107,'Aleksandr_Simonok','3bd4fd632f34bc28a5de9f9ac816eef1ad094cbd','Aleksandr','Simonok',2,1),(108,'Nikolay_Demidovets','12d0f2863bf7fefaf9345072d4be24b2c204b57b','Nikolay','Demidovets',2,1),(109,'Nikolay_Suglob','26386346e546123b7ac37422499b7089a6491763','Nikolay','Suglob',2,1),(110,'Pavel_Drozdov','05a5c8a1a3caa491253ed77ead7988b4db671bea','Pavel','Drozdov',2,1),(111,'Yan_Yunitskiy','aba564628e4d4745798139bcf058f2e4d1f470ad','Yan','Yunitskiy',2,1);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-04-15 18:22:47
