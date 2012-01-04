--
-- Table structure for table `imetadata`
--

DROP TABLE IF EXISTS `imetadata`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `imetadata` (
  `imageid` int(10) unsigned NOT NULL default '0',
  `tag` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`imageid`,`tag`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ixpages`
--

DROP TABLE IF EXISTS `ixpages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ixpages` (
  `eventid` int(10) unsigned NOT NULL default '0',
  `pageid` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`eventid`,`pageid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `mxpages`
--

DROP TABLE IF EXISTS `mxpages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `mxpages` (
  `pageid` int(10) unsigned NOT NULL auto_increment,
  `metadata` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`pageid`,`metadata`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `mxphotos`
--

DROP TABLE IF EXISTS `mxphotos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `mxphotos` (
  `photoid` int(10) unsigned NOT NULL auto_increment,
  `metadata` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`photoid`,`metadata`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pages`
--

DROP TABLE IF EXISTS `pages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `pages` (
  `pageid` int(11) NOT NULL auto_increment,
  `parent` int(11) default '0',
  `area` int(11) NOT NULL default '0',
  `title` varchar(64) default NULL,
  `year` int(4) NOT NULL default '0',
  `month` int(4) NOT NULL default '0',
  `orderno` int(4) default '0',
  `hide` int(1) default '0',
  `path` varchar(64) NOT NULL default '',
  `summary` blob,
  PRIMARY KEY  (`pageid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

INSERT INTO pages (pageid,title) VALUES (1,'Archive');

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `photos` (
  `photoid` int(11) NOT NULL auto_increment,
  `pageid` int(11) NOT NULL default '0',
  `orderno` int(11) NOT NULL default '0',
  `thumb` varchar(255) default NULL,
  `image` varchar(255) default NULL,
  `tagline` varchar(255) default NULL,
  `hide` tinyint(4) NOT NULL default '0',
  `dimensions` varchar(32) default NULL,
  PRIMARY KEY  (`photoid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `updates`
--

DROP TABLE IF EXISTS `updates`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `updates` (
  `upid` int(11) NOT NULL auto_increment,
  `area` varchar(8) default '',
  `pageid` int(11) default NULL,
  `now` int(11) default NULL,
  `pagets` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`upid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;
