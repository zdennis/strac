-- MySQL dump 10.10
--
-- Host: localhost    Database: strac_development
-- ------------------------------------------------------
-- Server version	5.0.27-standard

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
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'MHS'),(2,'Fusionary');
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (6,'Developer'),(7,'Customer');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `groups_privileges`
--

LOCK TABLES `groups_privileges` WRITE;
/*!40000 ALTER TABLE `groups_privileges` DISABLE KEYS */;
INSERT INTO `groups_privileges` VALUES (1,1,1),(2,4,10),(3,4,8),(4,5,10),(5,5,9),(6,6,13),(7,6,11),(8,7,13),(9,7,12);
/*!40000 ALTER TABLE `groups_privileges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `iterations`
--

LOCK TABLES `iterations` WRITE;
/*!40000 ALTER TABLE `iterations` DISABLE KEYS */;
INSERT INTO `iterations` VALUES (1,'2007-02-05','2007-02-11',1),(2,'2007-02-12','2007-02-18',1),(3,'2007-02-19','2007-02-25',1),(4,'2007-02-26','2007-03-02',2),(5,'2007-03-05','2007-03-11',1);
/*!40000 ALTER TABLE `iterations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `privileges`
--

LOCK TABLES `privileges` WRITE;
/*!40000 ALTER TABLE `privileges` DISABLE KEYS */;
INSERT INTO `privileges` VALUES (11,'developer'),(12,'customer'),(13,'user');
/*!40000 ALTER TABLE `privileges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (1,'strac'),(2,'JoeCartoon');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `schema_info`
--

LOCK TABLES `schema_info` WRITE;
/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
INSERT INTO `schema_info` VALUES (14),(14),(14),(14),(14);
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `statuses`
--

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
INSERT INTO `statuses` VALUES (1,'defined'),(2,'in progress'),(3,'complete'),(4,'rejected'),(5,'blocked');
/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `stories`
--

LOCK TABLES `stories` WRITE;
/*!40000 ALTER TABLE `stories` DISABLE KEYS */;
INSERT INTO `stories` VALUES (5,'CRUD Stories','Users should be able CRUD Stories.\n\nh3. Attributes:\n\n* summary, string\n* description, text\n* points, integer\n* position, integer\n* complete, boolean',2,0,1,1,1,'User',3),(6,'drag/drop reordering of stories','Stories should be able to be reordered by a drag/drop interface',2,1,1,1,1,'User',3),(7,'inplace editing of story point values','Users should be able to update the point value of a story in place in the listing page.',2,0,2,1,1,'User',3),(8,'CRUD Iterations','Users should be able to create iterations.\nIterations have start date, end date, and a name. \n\nQuestion: Should iterations be allowed to overlap?',2,2,2,1,1,'User',3),(9,'Link Stories/Iterations','Stories should be able to be assi\ngned to iterations. This should be optional.',1,3,2,1,1,'User',3),(10,'Textarea input should allow formatting','Some type of formatting should be added to text areas. This could be either a WYSIWYG or some type of formatting language like textile.\n\nh3. Sample Textile\n\n* item1\n* item2\n* item3\n\nWe have chosen textile.',1,5,2,1,2,'User',3),(11,'Add/edit/view stories from listing page','User should be able to add/edit/view stories from the listing page, rather than\nhaving to go to a separate page.',4,0,5,1,1,'User',3),(12,'Add filtering to story listing','The story listing should be able to be filtered by iteration (any, none, specific)',2,0,NULL,1,NULL,NULL,NULL),(13,'Add sorting/grouping on story listing','The story listing should be storted/grouped by iteration. \n\nThis will also involve updating the the drag/drop reordering interface to allow\n drag/drop between iterations. \n* update the positions AND iteration_id of the stories.\n* Stories should be updated to be positioned within their iteration',2,1,NULL,1,NULL,NULL,NULL),(15,'Allow marking stories complete from listing','As a user, I would like to be able to click a check box from the listing page to mark a story complete.',1,1,2,1,1,'User',3),(16,'CRUD Projects','h3. Attributes:\n\n* name',2,0,3,1,1,'User',3),(17,'Link Projects/Iterations','',2,1,3,1,1,'User',3),(18,'Link Projects/Stories','Stories currently can belong to iterations. Stories should also belong to a project so that stories which are not yet placed into an iteration can be diaplayed',3,2,3,1,1,'User',3),(19,'CRUD Users','',2,3,3,1,1,'User',3),(20,'CRUD Companies','',2,1,5,1,1,'User',3),(21,'Link Users/Companies','',1,2,5,1,1,'User',3),(22,'Setup authentication','use lwt authentication system',2,4,3,1,1,'User',3),(23,'Allow stories to be assigned a responsibly party','This can be a company or a user.',3,3,5,1,1,'User',3),(24,'Add comments to stories','Stories should be able to have comments',3,2,NULL,1,NULL,NULL,NULL),(25,'CRUD files','Files should be able to be uploaded to a project. These should be versioned',3,4,NULL,1,NULL,NULL,NULL),(26,'Look into UJS','The story listing page is already looking cluttered with javascript. UJS should be seriously looked into. This would allow much cleaner html pages, as well as possible speed benefits from have lighterweight pages.',4,5,NULL,1,NULL,NULL,NULL),(27,'Allow stories to be tagged','Stroies should be able to be assigned tags. These should who up in the list page after the summary.',2,4,2,1,2,'User',3),(30,'Tag text fields should be auto completers','When typing in a tag text field, it should auto complete with tags that already exist in the system.',3,4,5,1,1,'User',3),(31,'Allow reordering of multiple items','It would be nice to be able to use ctl/shift to select multiple items to be dragged in a list',8,6,NULL,1,NULL,NULL,NULL),(32,'Setup customer/developer permissions','Permissions should be setup in the following manner:\n\n * Users of the system should be given access on a per project basis.\n * Companies can be given access to a project (all users then have access)\n * 2 privileges should exist: developer, customer\n * customers should not be able to change points or create projects',6,7,NULL,1,1,'User',NULL),(33,'Add time tracking','',8,3,NULL,1,NULL,NULL,NULL),(34,'CRUD Channels','An administrator should be able to CRUD channels.\n\nh4. Attributes\n* name\n* button (swf)\n* position',2,1,4,2,NULL,NULL,3),(35,'Add static Categories','An administrator would like the static categories to include the following:\n\n* videos\n* cartoons',1,0,4,2,NULL,NULL,3),(50,'Update format of story listing','The story listing page should visually indicate whether a story is complete or incomplete.\n\nPoints should be displayed in a uniform location.\n\nImprove visual relationship between the story summary and the Show/Edit/Destroy links',3,2,1,1,1,'User',3),(51,'Display responsible party in story listing','As a developer I want to see the responsible party in the main story listing so I can quickly glance down the list and see how stories are assigned.',2,5,5,1,1,'User',3),(52,'Add status to stories','Stories should be able to have a status (defined, in progress, complete, rejected, blocked). This could replace the current \"complete\" attribute.',4,7,5,1,NULL,NULL,3),(53,'CRUD Videos','An administrator should be able to crud videos.',4,2,4,2,NULL,NULL,3),(56,'When opening a card (edit/show) scroll the page','',3,9,5,1,NULL,NULL,NULL),(58,'Remove delete functionality.','',1,6,5,1,NULL,NULL,3),(59,'Add priority categories','* High\n* Medium\n* Low',NULL,8,5,1,NULL,NULL,NULL),(60,'Project Overview Activities List','A user should be able to see a project overview summary which lists today\'s and yesterday\'s happenings so that they can quickly identify what has recently occurred on the project.\n\nh4. Acceptance Tests:\n\n* A user should should log into the site and click \"Projects\" and be presented with a project overview which contains the latest happenings in a listed in descending order based on date/time. \n\n',NULL,8,NULL,1,NULL,NULL,NULL),(61,'Project Activity Creation For Stories','A story should create a project activity record when a user takes the following actions so that the activities can be gathered and displayed on the the Project Overview page.\n\nh5. Activities\n\n* Story creation. Example: \"Mark has created a new story, \'story title\' \n* Story update. Example: \"Mark has updated the story, \'story title\'\n* Story status updates. Example(s):\n** Mark has taken the story, \'story title\'.\n** Mark has completed the story, \'story title\'.\n** Mark has rejected the story, \'story title\'.\n** Mark has blocked the story, \'story title\'.\n _(where \'story title\' is a link to the story in the above examples)_\n\nh4. Acceptance Tests\n\n* AT\'s handled by _Project Overview Activities List_\n',NULL,9,NULL,1,NULL,NULL,NULL),(62,'Assign Story IDs','As a user I should be able to enter the Story ID into a story description and have it turn into a hyperlink of that story\'s summary when it is displayed so that I can easily navigate between stories.\n\nh4. Acceptance Tests\n\n* A user should be able to login, create or update a story and enter another story\'s id into it\'s description. Upon saving/updating the story and viewing it again they should see the story id turned into a hyperlink to the story it references.\n\n* A user should be able to login and create a story. Upon editing the story they should be able to see but not change the story id.',NULL,10,NULL,1,NULL,NULL,NULL),(63,'Current Iteration Current','As a user I should be able to see the current iteration, future iterations and the story backlog so that I can see my current workload, as well as future and unassigned workload on one page.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and navigated to the \"Current Iteration\" I should see the current iteration stories if there are no future iterations defined and there are no stories in the backlog.\n\n* Given that I\'ve logged in, chosen a project and navigated to the \"Current Iteration\" I should see the current iteration stories followed by the backlog, if there are no future iterations defined.\n\n* Given that I\'ve logged in, chosen a project and navigated to the \"Current Iteration\" I should see the current iteration stories followed by the future iteration stories, then followed the backlog if there are future iterationsdefined.',NULL,11,NULL,1,NULL,NULL,NULL),(64,'Story Preview','As a user I should be able to preview the html version of a description before creating the story.\n\nh4. Acceptance Tests\n\nGiven that I\'ve logged in, chosen a project and navigated to the create (or editing of a) story I should be able to click on a preview button which allows me to see a html preview of my story description. ',NULL,12,NULL,1,NULL,NULL,NULL),(65,'Expand/Collapse Story Descriptions','As a user I want to be able to expand or collapse story description for a given iteration.\n\nh4. Acceptance Tests\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing I should be able to click on a \"Expand Stories\" link which expands every stories descriptions. The \"Expand Stories\" link should turn into \"Collapse Stories\".\n\n* Given that I\'ve logged in, chosen a project and am viewing an iteration listing and I\'ve selected the \"Expand Stories\" link I should be able to click on the \"Collapse Stories\" link to collapse all of the current story descriptions.  The \"Collapse Stories\" link should turn into \"Expand Stories\" ',NULL,13,NULL,1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `stories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
INSERT INTO `taggings` VALUES (1,1,26,'Story'),(2,2,27,'Story'),(4,4,5,'Story'),(6,6,6,'Story'),(8,2,30,'Story'),(11,7,7,'Story'),(12,9,33,'Story'),(13,11,34,'Story'),(14,12,35,'Story'),(16,14,51,'Story'),(17,14,23,'Story'),(18,5,50,'Story'),(19,15,8,'Story'),(20,15,9,'Story'),(21,5,10,'Story'),(23,5,5,'Story');
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'javascript'),(2,'tags'),(3,'crud stories'),(4,'crud'),(5,'stories'),(6,'priority'),(7,'points'),(8,'ppp'),(9,'time tracking'),(10,'planning'),(11,'channels'),(12,'categories'),(13,'hey'),(14,'responsible party'),(15,'iterations'),(16,'storie');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'mvanholstyn','3426c19b17768f5e5c3d5a4c53952395','Mark','Van Holstyn','mvanholstyn@mutuallyhuman.com',6,1),(2,'zdennis','5f4dcc3b5aa765d61d8327deb882cf99','Zach','Dennis','zdennis@mutuallyhuman.com',6,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2007-03-11  7:06:06
