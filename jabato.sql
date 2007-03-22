-- MySQL dump 10.10
--
-- Host: localhost    Database: jabato
-- ------------------------------------------------------
-- Server version	5.0.11-beta-Debian_3-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cmds`
--

DROP TABLE IF EXISTS `cmds`;
CREATE TABLE `cmds` (
  `idcmd` int(11) NOT NULL auto_increment,
  `cmd` text NOT NULL,
  PRIMARY KEY  (`idcmd`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `ds`
--

DROP TABLE IF EXISTS `ds`;
CREATE TABLE `ds` (
  `idds` int(11) NOT NULL auto_increment,
  `dsname` char(80) default '',
  `dsc` char(255) default '',
  `url` char(255) default 'rnd://1000:300',
  `value` int(11) default '0',
  `step` int(11) default '300',
  `dstype` char(80) default 'GAUGE',
  `gtype` char(80) default 'AVERAGE',
  `ptype` char(80) default 'LINE1',
  `msg` char(255) default '',
  PRIMARY KEY  (`idds`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `nodes`
--

DROP TABLE IF EXISTS `nodes`;
CREATE TABLE `nodes` (
  `idnode` int(11) NOT NULL auto_increment,
  `nodename` char(80) NOT NULL default '',
  `nodetype` char(80) NOT NULL default '',
  `parent` int(11) NOT NULL default '0',
  PRIMARY KEY  (`idnode`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `targets`
--

DROP TABLE IF EXISTS `targets`;
CREATE TABLE `targets` (
  `tname` char(80) NOT NULL default '',
  `idds` char(80) NOT NULL default '',
  PRIMARY KEY  (`tname`,`idds`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `actions`;
CREATE TABLE `actions` (
  `idaction` int(11) NOT NULL auto_increment,
  `action` char(80) NOT NULL default '',
  PRIMARY KEY  (`idaction`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `hosts`;
CREATE TABLE `hosts` (
  `idhost` int(11) NOT NULL auto_increment,
  `hosts` char(80) NOT NULL default '',
  PRIMARY KEY  (`idhost`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `execs`;
CREATE TABLE `execs` (
  `idhost` int(11) NOT NULL,
  `idaction` int(11) NOT NULL,
  `enabled` boolean  not null,
  `hosts` char(80) NOT NULL default '',
  PRIMARY KEY  (`idhost`,`idaction`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `execsparms`;
CREATE TABLE `execsparms` (
  `idhost` int(11) NOT NULL,
  `idaction` int(11) NOT NULL,
  `parmname` char(80) NOT NULL default '',
  `parmvalue` char(80) NOT NULL default '',
  PRIMARY KEY  (`idhost`,`idaction`,`parmname`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

