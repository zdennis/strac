-- MySQL dump 10.10
--
-- Host: localhost    Database: strac_development
-- ------------------------------------------------------
-- Server version	5.0.24a-Debian_9-log

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
-- Dumping data for table `groups`
--


/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
LOCK TABLES `groups` WRITE;
INSERT INTO `groups` VALUES (1,'user');
UNLOCK TABLES;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;

--
-- Dumping data for table `groups_privileges`
--


/*!40000 ALTER TABLE `groups_privileges` DISABLE KEYS */;
LOCK TABLES `groups_privileges` WRITE;
INSERT INTO `groups_privileges` VALUES (1,1,1);
UNLOCK TABLES;
/*!40000 ALTER TABLE `groups_privileges` ENABLE KEYS */;

--
-- Dumping data for table `iterations`
--


/*!40000 ALTER TABLE `iterations` DISABLE KEYS */;
LOCK TABLES `iterations` WRITE;
INSERT INTO `iterations` VALUES (1,'2007-02-05','2007-02-09',1),(2,'2007-02-12','2007-02-16',1),(3,'2007-02-19','2007-02-23',1),(4,'2007-02-26','2007-03-02',2);
UNLOCK TABLES;
/*!40000 ALTER TABLE `iterations` ENABLE KEYS */;

--
-- Dumping data for table `privileges`
--


/*!40000 ALTER TABLE `privileges` DISABLE KEYS */;
LOCK TABLES `privileges` WRITE;
INSERT INTO `privileges` VALUES (1,'user');
UNLOCK TABLES;
/*!40000 ALTER TABLE `privileges` ENABLE KEYS */;

--
-- Dumping data for table `projects`
--


/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
LOCK TABLES `projects` WRITE;
INSERT INTO `projects` VALUES (1,'strac'),(2,'JoeCartoon');
UNLOCK TABLES;
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;

--
-- Dumping data for table `schema_info`
--


/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
LOCK TABLES `schema_info` WRITE;
INSERT INTO `schema_info` VALUES (9),(9),(9),(9);
UNLOCK TABLES;
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;

--
-- Dumping data for table `stories`
--


/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
LOCK TABLES `stories` WRITE;
INSERT INTO `stories` VALUES (5,'CRUD Stories','Users should be able CRUD Stories.\n\nh2. Attributes:\n\n* summary, string\n* description, text\n* points, integer\n* position, integer\n* complete, boolean',2,0,1,1,1),(6,'drag/drop reordering of stories','Stories should be able to be reordered by a drag/drop interface',2,1,1,1,1),(7,'inplace editing of story point values','Users should be able to update the point value of a story in place in the listing page.',2,0,1,2,1),(8,'CRUD Iterations','Users should be able to create iterations.\r\nIterations have start date, end date, and a name. \r\n\r\nQuestion: Should iterations be allowed to overlap?',2,2,1,2,1),(9,'Link Stories/Iterations','Stories should be able to be assi\ngned to iterations. This should be optional.',1,3,1,2,1),(10,'Textarea input should allow formatting','Some type of formatting should be added to text areas. This could be either a WYS\r\nIWYG or some type of formatting language like textile.\r\n\r\nh3. Sample Textile\r\n\r\n* item1\r\n* item2\r\n* item3',1,5,1,2,1),(11,'Add/edit/view stories from listing page','User should be able to add/edit/view stories from the listing page, rather than\nhaving to go to a separate page.',4,9,0,3,1),(12,'Add filtering to story listing','The story listing should be able to be filtered by iteration (any, none, specific)',2,3,0,NULL,1),(13,'Add sorting/grouping on story listing','The story listing should be storted/grouped by iteration. \r\n\r\nThis will also involve updating the the drag/drop reordering interface to allow\n drag/drop between iterations. \r\n * update the positions AND iteration_id of the stories.\r\n * Stories should be updated to be positioned within their iteration',2,4,0,NULL,1),(14,'Update format of story listing','The story listing page should visually indicate whether a story is complete or incomplete.\r\n\r\nPoints should be displayed in a uniform location.\r\nn\r\nImprove visual relationship between the story summary and the Show/Edit/Destroy links',3,2,1,1,1),(15,'Allow marking stories complete from listing','As a user, I would like to be able to click a check box from the listing page to mark a story complete.',1,1,1,2,1),(16,'CRUD Projects','h3. Attributes:\n\n* name',2,0,1,3,1),(17,'Link Projects/Iterations','',2,1,1,3,1),(18,'Link Projects/Stories','Stories currently can belong to iterations. Stories should also belong to a project so that stories which are not yet placed into an iteration can be diaplayed',3,2,1,3,1),(19,'CRUD Users','',2,3,1,3,1),(20,'CRUD Companies','',2,5,0,3,1),(21,'Link Users/Companies','',1,6,0,3,1),(22,'Setup authentication','use lwt authentication system',2,4,1,3,1),(23,'Allow stories to be assigned a responsibly party','This can be a company or a user',3,7,0,3,1),(24,'Add comments to stories','Stories should be able to have comments',3,1,0,NULL,1),(25,'CRUD files','Files should be able to be uploaded to a project. These should be versioned',3,5,0,NULL,1),(26,'Look into UJS','The story listing page is already looking cluttered with javascript. UJS should be seriously looked into. This would allow much cleaner html pages, as well as possible speed benefits from have lighterweight pages.',4,6,0,NULL,1),(27,'Allow stories to be tagged','Stroies should be able to be assigned tags. These should who up in the list page after the summary.',2,4,1,2,1),(30,'Tag text fields should be auto completers','When typing in a tag text field, it should auto complete with tags that already exist in the system',3,0,0,NULL,1),(31,'Allow reordering of multiple items','It would be nice to be able to use ctl/shift to select multiple items to be dragged in a list',8,2,NULL,NULL,1),(32,'Setup customer/developer permissions','Permissions should be setup in the following manner:\r\n\r\n * Users of the system should be given access on a per project basis.\r\n * Companies can be given access to a project (all users then have access)\r\n * 2 privileges should exist: developer, customer\r\n * customers should not be able to change points or create projects',6,8,NULL,3,1),(33,'Add time tracking','',8,10,NULL,3,1),(34,'Plan with Jack','',6,1,NULL,4,2);
UNLOCK TABLES;
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;

--
-- Dumping data for table `taggings`
--


/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
LOCK TABLES `taggings` WRITE;
INSERT INTO `taggings` VALUES (1,1,26,'Story'),(2,2,27,'Story'),(4,4,5,'Story'),(5,5,5,'Story'),(6,6,6,'Story'),(8,2,30,'Story'),(11,7,7,'Story'),(12,9,33,'Story'),(13,10,34,'Story');
UNLOCK TABLES;
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;

--
-- Dumping data for table `tags`
--


/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
LOCK TABLES `tags` WRITE;
INSERT INTO `tags` VALUES (1,'javascript'),(2,'tags'),(3,'crud stories'),(4,'crud'),(5,'stories'),(6,'priority'),(7,'points'),(8,'ppp'),(9,'time tracking'),(10,'planning');
UNLOCK TABLES;
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;

--
-- Dumping data for table `users`
--


/*!40000 ALTER TABLE `users` DISABLE KEYS */;
LOCK TABLES `users` WRITE;
INSERT INTO `users` VALUES (1,'mvanholstyn','3426c19b17768f5e5c3d5a4c53952395','Mark','Van Holstyn','mvanholstyn@mutuallyhuman.com',1);
UNLOCK TABLES;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

