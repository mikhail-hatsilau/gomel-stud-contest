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
) ENGINE=InnoDB AUTO_INCREMENT=478 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FirstStep`
--

LOCK TABLES `FirstStep` WRITE;
/*!40000 ALTER TABLE `FirstStep` DISABLE KEYS */;
INSERT INTO `FirstStep` VALUES (448,111,25,458,'<ol>\n  <li>\n    Item 1\n    <ul>\n      <li>Item 1.1</li>\n      <li>Item 1.2</li>\n      <li>Item 1.3</li>\n    </ul>\n  </li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n</ol>','ol {\n	color: #7F993A;\n	border-radius: 5px;\n	border: 1px solid #ccc;\n	background: #efefef;\n	padding-right: 25px;\n}\nul {\n	list-style-type: square;\n  border: 1px solid #d0d0d0;\n  border-radius: 5px;\n  background: #e0e0e0;\n}\nli {\n  font-size: 1.5em;\n  font-family: sans serif;\n}\nul li {\n	font-size: 100%;\n}','/results/111_Yan_Yunitskiy/task_25.html'),(449,106,25,471,'<ol>\n  <li>\n    Item 1\n    <ul>\n      <li><span>Item 1.1</span></li>\n      <li><span>Item 1.2</span></li>\n      <li><span>Item 1.3</span></li>\n    </ul>\n  </li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n</ol>','ol>li {\n	font-size: 1.5em;\n	color: #7F993A;\n}\nul {\n  list-style: square; \n}\nli {\n  font-family: sans serif;\n  color: black;\n}\n\nli span {\n	color: #7F993A;\n}','/results/106_Aleksandr_Kolymago/task_25.html'),(450,107,25,463,'<ol>\n  <li>\n    Item 1\n    <ul>\n      <li>Item 1.1</li>\n      <li>Item 1.2</li>\n      <li>Item 1.3</li>\n    </ul>\n  </li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n</ol>','ul{\n  list-style: none; \n  font-size:1em;\n}\nol{\n	font-size: 1.5em;\n}\nli {\n	font-size:1em;\n  font-family: sans serif;\n  color:#7F993A;\n}\nul li{\n	position:relative;\n	\n}\nul li:before{\n	content:\'\';\n	position:absolute;\n	right:100%;\n	top:.5em;\n	display:inline-block;\n	width:0.25em;\n	height:0.25em;\n	background:#000;\n	margin-right:10px;\n}','/results/107_Aleksandr_Simonok/task_25.html'),(451,108,25,754,'<ol>\n  <li>\n    Item 1\n    <ul>\n      <li>Item 1.1</li>\n      <li>Item 1.2</li>\n      <li>Item 1.3</li>\n    </ul>\n  </li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n</ol>','ul {\n  list-style: none;\n}\nli {\n  font-size: 20px;\n  font-family: sans serif;\n  color: #7F993A;\n}\nul li:before {\n	content: \"\";\n	display: inline-block;\n	width: 8px;\n	height: 8px;\n	background: #000;\n	margin: 0 5px 2px 0;\n}','/results/108_Nikolay_Demidovets/task_25.html'),(452,107,26,291,'<table>\n	<thead>\n		<tr>\n					<th>Name</th>\n		<th>Adress</th>\n		</tr>\n	</thead>\n	<tbody>\n		<tr>\n			<td>\n				Ivan Ivanov\n			</td>\n			<td>\n			 	Chargoggagoggmanchauggagoggchaubunagungamaugg\n			</td>\n		</tr>\n		<tr>\n			<td>\n				Serhei Wolfeschlegelsteinhausehausenbergerdorff\n			</td>\n			<td>\n				Long road street 12\n			</td>\n		</tr>\n	</tbody>\n</table>','td, th {\n	border: 1px solid black;\n	text-overflow: ellipsis;\n	line-height:120%;\n	white-space: nowrap;\n	overflow:hidden;\n}\n\ntable {\n	width: 100%;\n	table-layout: fixed;\n	font-family: Arial;\n	border-spacing:0px;\n	border-collapse: collapse;\n}','/results/107_Aleksandr_Simonok/task_26.html'),(453,110,25,807,'<ol>\n  <li>\n   <span> Item 1</span>\n    <ul>\n      <li><span>Item 1.1</span></li>\n      <li><span>Item 1.2</span></li>\n      <li><span>Item 1.3</span></li>\n    </ul>\n  </li>\n  <li><span>Item 2</span></li>\n  <li><span>Item 3</span></li>\n</ol>','ul,0l{\n	font-size: 1em;\n}\nli {\n  font-family: sans serif;\n}\nul li{\n list-style:square outside;\n}\nspan{\n	  color:#7F993A;\n}','/results/110_Pavel_Drozdov/task_25.html'),(454,107,27,140,'<div class=\"info infobox\">\n	<ul class=\"menu\">\n		<li>Competition</li>\n		<li>Results</li>\n		<li>About us</li>\n	</ul>\n	Welcom to the first Gomel UXD competition\n</div>','ul {\n	list-style: none;\n	padding: 0;\n	margin: 0;\n	float: right;\n}\n\nul>li {\n	width: 200px;\n	padding: 20px 0;\n	text-align: center;\n	color: white;\n	background-color: #7F993A;\n	cursor: pointer;\n	transition:background .3s ease;\n}\nul li:hover{\n	background:#1A9CB0;\n}\n\ndiv {\n	background-color: #1A9CB0;\n	color: white;\n	border: 2px solid gray;\n	overflow:hidden;\n	font-family: Helvetica, Arial;\n	\n}\n','/results/107_Aleksandr_Simonok/task_27.html'),(455,107,28,30,'<div class=\"overlay\">\n	<div class=\"popup\"></div>\n</div>','.overlay {\n	position: fixed;\n	top: 0;\n	bottom: 0;\n	left: 0;\n	right: 0;\n	background-color: rgba(0, 0, 0, 0.5);\n}\n\n.popup {\n	height: 200px;\n	width: 200px;\n	background-color: #FFF;\n	position:absolute;\n	left:50%;\n	top:50%;\n	margin:-100px 0 0 -100px;\n}','/results/107_Aleksandr_Simonok/task_28.html'),(456,106,26,557,'<table>\n	<thead>\n		<tr>\n					<th>Name</th>\n		<th>Adress</th>\n		</tr>\n	</thead>\n	<tbody>\n		<tr>\n			<td>\n				Ivan Ivanov\n			</td>\n			<td>\n			 	<p>Chargoggagoggmanchauggagoggchaubunagungamaugg</p>\n			</td>\n		</tr>\n		<tr>\n			<td>\n				<p>Serhei Wolfeschlegelsteinhausehausenbergerdorff</p>\n			</td>\n			<td>\n				Long road street 12\n			</td>\n		</tr>\n	</tbody>\n</table>','* {\n	font-family: \'Helvetica\';\n} \ntable {\n	width: 100%;\n	border: 4px double black;\n	border-collapse: collapse;\n	table-layout: fixed;\n}\nth { \n    text-align: left; \n    background: #ccc; \n    padding: 5px; \n    border: 1px solid black; \n}\n   \ntd { \n    padding: 5px; \n    border: 1px solid black;\n }\n\ntd p {\n	width: 100%;\n	word-wrap: nowrap;\n	overflow: hidden;\n	text-overflow: ellipsis;\n}\n','/results/106_Aleksandr_Kolymago/task_26.html'),(457,111,26,706,'<table>\n	<thead>\n		<tr>\n					<th>Name</th>\n		<th>Adress</th>\n		</tr>\n	</thead>\n	<tbody>\n		<tr>\n			<td>\n				Ivan Ivanov\n			</td>\n			<td>\n			 	Chargoggagoggmanchauggagoggchaubunagungamaugg\n			</td>\n		</tr>\n		<tr>\n			<td>\n				Serhei Wolfeschlegelsteinhausehausenbergerdorff\n			</td>\n			<td>\n				Long road street 12\n			</td>\n		</tr>\n	</tbody>\n</table>','td, th {\n	border: 1px solid #ccc;\n	overflow: hidden;\n	text-overflow: ellipsis;\n	border-bottom: none;\n}\n\ntd:last-child, th:last-child {\n	border-left: none;\n}\ntr:last-child td {\n	border-bottom: 1px solid #ccc;\n}\n\ntable {\n	width: 100%;\n	table-layout: fixed;\n	font-family: Helvetica, Arial, sans-serif;\n	border-spacing: 0;\n	background: #efefef;\n}','/results/111_Yan_Yunitskiy/task_26.html'),(458,109,25,1231,'<ol>\n  <li>\n    Item 1\n    <ul>\n      <li>Item 1.1</li>\n      <li>Item 1.2</li>\n      <li>Item 1.3</li>\n    </ul>\n  </li>\n  <li>Item 2</li>\n  <li>Item 3</li>\n</ol>','ul {\n	font-size: 1.5em;\n  list-style: square; \n  font-family: serif;\n  color: #7F993A;\n}\nli{\n  font-size: 1.5em;\n  font-family: serif;\n  color: #7F993A;\n}\n','/results/109_Nikolay_Suglob/task_25.html'),(459,107,4,314,'<form action=\"/pass\" class=\"form-reg\">\n	<input type=\"text\" name=\"firstName\" placeholder=\"First name\">\n	<input type=\"text\" name=\"lastName\" placeholder=\"Last name\">\n	<button>?????????</button>\n</form>','.form-reg{\n	border:1px solid #f2f2f2;\n	border-radius:5px;\n	display:inline-block;\n	padding:10px;\n}\n.form-reg input[type=text]{\n	display:block;\n	width:200px;\n	margin-bottom:10px;\n	border:1px solid #cccc;\n	color:#111111;\n}\n.form-reg button{\n	cursor:pointer;\n	display:block;\n	width:100%;\n	outline:none;\n	text-align:center;\n	padding:5px 10px;\n	background:#;\n}','/results/107_Aleksandr_Simonok/task_4.html'),(460,109,26,133,'<table>\n	<thead>\n		<tr>\n					<th>Name</th>\n		<th>Adress</th>\n		</tr>\n	</thead>\n	<tbody>\n		<tr>\n			<td>\n				Ivan Ivanov\n			</td>\n			<td>\n			 	Chargoggagoggmanchauggagoggchaubunagungamaugg\n			</td>\n		</tr>\n		<tr>\n			<td>\n				Serhei Wolfeschlegelsteinhausehausenbergerdorff\n			</td>\n			<td>\n				Long road street 12\n			</td>\n		</tr>\n	</tbody>\n</table>','td, th {\n	border: 1px solid black;\n	\n}\n\ntable {\n	width: 100%;\n	table-layout: fixed;\n}','/results/109_Nikolay_Suglob/task_26.html'),(461,110,26,565,'<table>\n	<thead>\n		<tr>\n					<th>Name</th>\n		<th>Adress</th>\n		</tr>\n	</thead>\n	<tbody>\n		<tr>\n			<td>\n				Ivan Ivanov\n			</td>\n			<td>\n			 	Chargoggagoggmanchauggagoggchaubunagungamaugg\n			</td>\n		</tr>\n		<tr>\n			<td>\n				Serhei Wolfeschlegelsteinhausehausenbergerdorff\n			</td>\n			<td>\n				Long road street 12\n			</td>\n		</tr>\n	</tbody>\n</table>','td, th {\n	border: 1px solid black;\n}\ntable {\n	width: 100%;\n	table-layout: fixed;\n	border-spacing: 0px;\n	border-collapse:collapse;\n	font-family:Helvetica,Arial,san-serif;\n}\ntd{\n	text-overflow: ellipsis;\n	white-space: nowrap;\n  overflow: hidden; \n  padding: 5px; \n}','/results/110_Pavel_Drozdov/task_26.html'),(462,106,27,374,'<div class=\"info infobox\">\n	<ul class=\"menu\">\n		<li>Competition</li>\n		<li>Results</li>\n		<li>About us</li>\n	</ul>\n	Welcom to the first Gomel UXD competition\n</div>','* {\n	font-family: Helvetica, Arial;\n}\ndiv.info {\n	background-color: #1A9CB0;\n	color: white;\n	border: 2px solid gray;\n	height: 174px;\n}\n\nul {\n	list-style: none;\n	padding: 0;\n	margin: 0;\n	float: right;\n}\n\nul>li {\n	width: 200px;\n	padding: 20px 0;\n	text-align: center;\n	color: white;\n	background-color: #7F993A;\n	cursor: pointer;\n}\n\nul>li:hover {\n	background-color: #1A9CB0;\n}\n\n\n','/results/106_Aleksandr_Kolymago/task_27.html'),(463,106,28,172,'<div class=\"overlay\">\n	<div class=\"popup\"></div>\n</div>','.overlay {\n	position: fixed;\n	top: 0;\n	bottom: 0;\n	left: 0;\n	right: 0;\n	background-color: rgba(0, 0, 0, 0.5);\n}\n\n.popup {\n	position: absolute;\n	top: 0;\n	bottom: 0;\n	left: 0;\n	right: 0;\n	height: 200px;\n	width: 200px;\n	margin: auto;\n	background-color: #FFF;\n}','/results/106_Aleksandr_Kolymago/task_28.html'),(464,108,26,843,'<table>\n	<thead>\n		<tr>\n					<th>Name</th>\n		<th>Adress</th>\n		</tr>\n	</thead>\n	<tbody>\n		<tr>\n			<td>\n				Ivan Ivanov\n			</td>\n			<td>\n			 	Chargoggagoggmanchauggagoggchaubunagungamaugg\n			</td>\n		</tr>\n		<tr>\n			<td>\n				Serhei Wolfeschlegelsteinhausehausenbergerdorff\n			</td>\n			<td>\n				Long road street 12\n			</td>\n		</tr>\n	</tbody>\n</table>','td, th {\n	border: 1px solid black;\n	overflow: hidden;\n}\n\ntable {\n	width: 100%;\n	table-layout: fixed;\n	font: Helvetica, Arial, sans-serif;\n	border-collapse: collapse;\n}','/results/108_Nikolay_Demidovets/task_26.html'),(465,110,27,442,'<div class=\"info infobox\">\n	<ul class=\"menu\">\n		<li>Competition</li>\n		<li>Results</li>\n		<li>About us</li>\n	</ul>\n	Welcom to the first Gomel UXD competition\n</div>','ul {\n	list-style: none;\n	padding: 0;\n	margin: 0;\n	float: right;\n}\nul>li {\n	width: 200px;\n	padding: 20px 0;\n	text-align: center;\n	color: white;\n	background-color: #7F993A;\n	cursor: pointer;\n}\n.info ,.menu{\n		font-family: Helvetica, Arial\n}\ndiv{\n	background-color: #1A9CB0;\n	color: white;\n	border: 2px solid gray;\n  overflow: auto\n}\nli:hover{\n	background-color:#1A9CB0;\n}\n','/results/110_Pavel_Drozdov/task_27.html'),(466,108,27,352,'<div class=\"info infobox\">\n	<ul class=\"menu\">\n		<li>Competition</li>\n		<li>Results</li>\n		<li>About us</li>\n	</ul>\n	Welcom to the first Gomel UXD competition\n</div>','ul {\n	list-style: none;\n	padding: 0;\n	margin: 0;\n	float: right;\n}\n\nul>li {\n	font-family: Helvetica, Arial;\n	width: 200px;\n	padding: 20px 0;\n	text-align: center;\n	color: white;\n	background-color: #7F993A;\n	cursor: pointer;\n}\n\ndiv {\n	background-color: #1A9CB0;\n	color: white;\n	border: 2px solid gray;\n	font-family: Helvetica, Arial;\n	text-align: center;\n}\nli:hover {\n	background-color: #1A9CB0;\n}\n','/results/108_Nikolay_Demidovets/task_27.html'),(467,111,27,818,'<div class=\"info infobox\">\n	<ul class=\"menu\">\n		<li>Competition</li>\n		<li>Results</li>\n		<li>About us</li>\n	</ul>\n	Welcom to the first Gomel UXD competition\n</div>','ul {\n	list-style: none;\n	padding: 0;\n	margin: 0;\n	float: right;\n}\n\nul>li {\n	font-family: inherit;\n	width: 200px;\n	padding: 20px 0;\n	text-align: center;\n	color: white;\n	background-color: #7F993A;\n	cursor: pointer;\n}\nul > li:hover {\n	background: #1A9CB0;\n}\n\ndiv {\n	background-color: #1A9CB0;\n	color: white;\n	border: 2px solid gray;\n}','/results/111_Yan_Yunitskiy/task_27.html'),(468,106,4,529,'<div>\n	<form method=\"post\" action=\"/pass\">\n		<input name=\"firstName\" type=\"text\"/></br>\n		<input name=\"lastName\" type=\"text\" /></br>\n		<input type=\"submit\"/>\n	</form>\n</div>','div {\n	width: 175px;\n}\ninput {\n	padding: 5px 0;\n	margin: 5px 0;\n}\n\ninput[type=\"submit\"] {\n	float: right;\n	border: none;\n	padding: 5px;\n	background-color: #A3C644;\n	color: white;\n	border-radius: 4px;\n}\n\ninput[type=\"submit\"]:hover {\n	background-color: #b3e231;\n	transition: 0.5s;\n}','/results/106_Aleksandr_Kolymago/task_4.html'),(469,106,4,529,'<div>\n	<form method=\"post\" action=\"/pass\">\n		<input name=\"firstName\" type=\"text\"/></br>\n		<input name=\"lastName\" type=\"text\" /></br>\n		<input type=\"submit\"/>\n	</form>\n</div>','div {\n	width: 175px;\n}\ninput {\n	padding: 5px 0;\n	margin: 5px 0;\n}\n\ninput[type=\"submit\"] {\n	float: right;\n	border: none;\n	padding: 5px;\n	background-color: #A3C644;\n	color: white;\n	border-radius: 4px;\n}\n\ninput[type=\"submit\"]:hover {\n	background-color: #b3e231;\n	transition: 0.5s;\n}','/results/106_Aleksandr_Kolymago/task_4.html'),(470,111,28,151,'<div class=\"overlay\">\n	<div class=\"popup\"></div>\n</div>','.overlay {\n	position: absolute;\n	top: 0;\n	bottom: 0;\n	left: 0;\n	right: 0;\n	background-color: rgba(0, 0, 0, 0.5);\n}\n\n.popup {\n	position: absolute;\n	top: 50%;\n	left: 50%;\n	height: 200px;\n	width: 200px;\n	margin-top: -100px;\n	margin-left: -100px;\n	background-color: #FFF;\n}','/results/111_Yan_Yunitskiy/task_28.html'),(471,106,4,529,'<div>\n	<form method=\"post\" action=\"/pass\">\n		<input name=\"firstName\" type=\"text\"/><br>\n		<input name=\"lastName\" type=\"text\" /><br>\n		<input type=\"submit\"/>\n	</form>\n</div>','div {\n	width: 175px;\n}\ninput {\n	padding: 5px 0;\n	margin: 5px 0;\n}\n\ninput[type=\"submit\"] {\n	float: right;\n	border: none;\n	padding: 5px;\n	background-color: #A3C644;\n	color: white;\n	border-radius: 4px;\n}\n\ninput[type=\"submit\"]:hover {\n	background-color: #b3e231;\n	transition: 0.5s;\n}','/results/106_Aleksandr_Kolymago/task_4.html'),(472,108,28,184,'<div class=\"overlay\">\n	<div class=\"popup\"></div>\n</div>','.overlay {\n	position: fixed;\n	top: 0;\n	bottom: 0;\n	left: 0;\n	right: 0;\n	background-color: rgba(0, 0, 0, 0.5);\n}\n\n.popup {\n	height: 200px;\n	width: 200px;\n	background-color: #FFF;\n	margin: 45% auto;\n}','/results/108_Nikolay_Demidovets/task_28.html'),(473,110,28,329,'<div class=\"overlay\">\n	<div class=\"popup\"></div>\n</div>','.overlay {\n	position: absolute;\n  top: 50%;\n  left: 50%;\n  margin: -100px 0 0 -100px;\n	background-color: rgba(0, 0, 0, 0.5);\n	height: 200px;\n	width: 200px;\n}\n\n.popup {\n	height: 200px;\n	width: 200px;\n}','/results/110_Pavel_Drozdov/task_28.html'),(474,108,4,229,'<form action=\"/pass\">\n	<input type=\"text\" name=\"firstName\">\n	<input type=\"text\" name=\"lastName\">\n	<input type=\"submit\">\n</form>','','/results/108_Nikolay_Demidovets/task_4.html'),(475,109,27,1009,'<div class=\"info infobox\">\n	<ul class=\"menu\">\n		<li>Competition</li>\n		<li>Results</li>\n		<li>About us</li>\n	</ul>\n	Welcom to the first Gomel UXD competition\n</div>','ul {\n	list-style: none;\n	padding: 0;\n	margin: 0;\n	float: right;\n	font-family: Arial;\n}\n\nul>li {\n	font-family: Helvetica;\n	width: 200px;\n	padding: 20px 0;\n	text-align: center;\n	color: white;\n	background-color: #7F993A;\n	cursor: pointer;\n}\n\ndiv {\n	background-color: #7F993A;\n	color: white;\n	border: 0px solid gray;\n	height: 180px;\n}\n','/results/109_Nikolay_Suglob/task_27.html'),(476,111,4,316,'<form action=\"/pass\" method=\"post\">\n	<input type=\"text\" name=\"firstName\" placeholder=\"First Name\">\n	<input type=\"text\" name=\"lastName\" placeholder=\"Last Name\">\n	<input type=\"submit\">\n</form>','input[type=\"submit\"] {\n	margin-top: 10px;\n	border: 1px solid #ccc;\n	padding: 5px;\n	display: block;\n	border-radius: 5px;\n}','/results/111_Yan_Yunitskiy/task_4.html'),(477,110,4,547,'<form type=\"submit\"> \n	<input name=\"firstName\" placeholder=\"firstName\" /><br/>\n	<input name=\"lastName\" placeholder=\"lastName\"/><br/>\n	<button>?????????</button><br/>\n</form>','input{\n	margin-bottom:5px;\n	padding:5px;\n	border-radius: 5px;\n}','/results/110_Pavel_Drozdov/task_4.html');
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
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Marks`
--

LOCK TABLES `Marks` WRITE;
/*!40000 ALTER TABLE `Marks` DISABLE KEYS */;
INSERT INTO `Marks` VALUES (31,106,12,4),(32,107,12,9),(33,108,12,6),(34,109,12,5),(35,110,12,4),(36,111,12,7),(37,106,25,7),(38,107,25,6),(39,108,25,5),(40,109,25,4),(41,110,25,6),(42,111,25,7),(43,106,26,8),(44,107,26,9),(45,108,26,5),(46,110,26,9),(47,111,26,8),(48,106,27,5),(49,107,27,9),(50,108,27,5),(51,109,27,3),(52,110,27,9),(53,111,27,5),(54,106,28,9),(55,107,28,9),(56,108,28,6),(57,109,28,1),(58,110,28,3),(59,111,28,9),(60,106,4,6),(61,107,4,9),(62,108,4,6),(63,109,4,1),(64,110,4,4),(65,111,4,6),(66,111,23,10),(67,107,23,9),(68,108,23,7),(69,110,23,4),(70,106,23,5),(71,109,23,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=859 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Quiz`
--

LOCK TABLES `Quiz` WRITE;
/*!40000 ALTER TABLE `Quiz` DISABLE KEYS */;
INSERT INTO `Quiz` VALUES (787,111,13,7.928,'.info div'),(788,106,13,9.818,'div >'),(789,107,13,11.943,'.info >'),(790,110,13,13.806,'.info div'),(791,108,13,111.066,'.info div   '),(792,109,13,120,''),(793,108,14,9.169,'#link3'),(794,111,14,12.643,'#link3'),(795,106,14,51.565,'a[id=\"link3\"]'),(796,107,14,57.425,'#link3'),(797,110,14,61.889,'a[id = link3]'),(798,109,14,120,''),(799,107,15,2.139,'*'),(800,108,15,3.969,'*'),(801,106,15,4.926,'*'),(802,111,15,5.364,'div, span, p'),(803,110,15,10.761,'*'),(804,109,15,17.139,'>'),(805,111,5,28.573,'.wrapper a[href$=\".jpg\"]'),(806,106,5,66.924,'a[href$=\".jpg\"]'),(807,107,5,90.256,'a[href$=jpg]'),(808,109,5,120,''),(809,110,5,120,''),(810,108,5,120,''),(811,107,16,3.555,'input ~'),(812,111,16,4.74,'div, span'),(813,108,16,6.606,'input ~'),(814,110,16,8.334,'div,span'),(815,106,16,10.036,'div, span'),(816,109,16,120,''),(817,107,17,7.039,'input[checked]'),(818,111,17,22.048,'input[checked]'),(819,108,17,28.775,'input[checked]'),(820,109,17,120,''),(821,110,17,120,''),(822,106,17,120,''),(823,108,18,9.956,'.info +'),(824,111,18,14.608,'.info +'),(825,110,18,22.384,'.info + .card'),(826,107,18,22.794,'.info +'),(827,109,18,120,''),(828,106,18,120,''),(829,111,19,6.194,'.card.card1'),(830,108,19,8.085,'.card.card1'),(831,107,19,11.044,'div.card.card1'),(832,106,19,11.5,'.card.card1'),(833,110,19,17.709,'.card.card1'),(834,109,19,120,''),(835,106,20,14.78,'div>:first'),(836,108,20,17.933,'.task:first'),(837,107,20,24.287,'.task:first'),(838,111,20,29.931,'.task:first'),(839,110,20,40.987,'div .task:first'),(840,109,20,120,''),(841,107,21,5.901,'li:last'),(842,111,21,9.843,'li:last'),(843,108,21,20.949,'li:last'),(844,110,21,27.701,':nth-child(3)'),(845,106,21,44.085,'li:nth-child(3)'),(846,109,21,47.241,'li:nth-child(3)'),(847,107,22,18.626,'tbody> tr:nth-child(odd)'),(848,111,22,21.639,'tbody tr:first, tbody tr:last'),(849,106,22,118.029,'tbody>tr:nth-child(2n-1)'),(850,109,22,120,''),(851,108,22,118.02,'tbody tr:nth-child(2n+1)'),(852,110,22,120,''),(853,107,23,17.336,'.list>li:nth-child(2)'),(854,111,23,21.743,'ul:first > li:nth-child(2)'),(855,108,23,37.418,'.list > li:nth-child(2)'),(856,106,23,115.828,'.list>li:nth-child(2)'),(857,109,23,120,''),(858,110,23,120,'');
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
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=latin1;
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

-- Dump completed on 2016-04-19  9:13:17
