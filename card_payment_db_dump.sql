-- MySQL dump 10.13  Distrib 9.7.0, for Win64 (x86_64)
--
-- Host: localhost    Database: card_payment_db
-- ------------------------------------------------------
-- Server version	9.7.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `card_payment_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `card_payment_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `card_payment_db`;

--
-- Table structure for table `admin_logs`
--

DROP TABLE IF EXISTS `admin_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `action` varchar(50) NOT NULL,
  `target` varchar(100) NOT NULL,
  `details` longtext NOT NULL,
  `ip_address` char(39) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `admin_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_logs_admin_id_f4e1f6a6_fk_users_id` (`admin_id`),
  CONSTRAINT `admin_logs_admin_id_f4e1f6a6_fk_users_id` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_logs`
--

LOCK TABLES `admin_logs` WRITE;
/*!40000 ALTER TABLE `admin_logs` DISABLE KEYS */;
INSERT INTO `admin_logs` VALUES (1,'CREATE','user:2','','127.0.0.1','2026-10-09 10:14:25.456706',1),(2,'EXPORT_CSV','transactions','3 rows exported from admin panel','127.0.0.1','2026-10-09 10:36:41.300093',1);
/*!40000 ALTER TABLE `admin_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add Blacklisted Token',6,'add_blacklistedtoken'),(22,'Can change Blacklisted Token',6,'change_blacklistedtoken'),(23,'Can delete Blacklisted Token',6,'delete_blacklistedtoken'),(24,'Can view Blacklisted Token',6,'view_blacklistedtoken'),(25,'Can add Outstanding Token',7,'add_outstandingtoken'),(26,'Can change Outstanding Token',7,'change_outstandingtoken'),(27,'Can delete Outstanding Token',7,'delete_outstandingtoken'),(28,'Can view Outstanding Token',7,'view_outstandingtoken'),(29,'Can add user',8,'add_user'),(30,'Can change user',8,'change_user'),(31,'Can delete user',8,'delete_user'),(32,'Can view user',8,'view_user'),(33,'Can add card',9,'add_card'),(34,'Can change card',9,'change_card'),(35,'Can delete card',9,'delete_card'),(36,'Can view card',9,'view_card'),(37,'Can add transaction',10,'add_transaction'),(38,'Can change transaction',10,'change_transaction'),(39,'Can delete transaction',10,'delete_transaction'),(40,'Can view transaction',10,'view_transaction'),(41,'Can add Daily payment summary',11,'add_dailysummary'),(42,'Can change Daily payment summary',11,'change_dailysummary'),(43,'Can delete Daily payment summary',11,'delete_dailysummary'),(44,'Can view Daily payment summary',11,'view_dailysummary'),(45,'Can add admin log',12,'add_adminlog'),(46,'Can change admin log',12,'change_adminlog'),(47,'Can delete admin log',12,'delete_adminlog'),(48,'Can view admin log',12,'view_adminlog');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cards`
--

DROP TABLE IF EXISTS `cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cards` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cardholder_name` varchar(100) NOT NULL,
  `card_type` varchar(10) NOT NULL,
  `brand` varchar(20) NOT NULL,
  `masked_number` varchar(25) NOT NULL,
  `last4` varchar(4) NOT NULL,
  `expiry_month` smallint unsigned NOT NULL,
  `expiry_year` smallint unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cards_user_id_8fb8d426_fk_users_id` (`user_id`),
  CONSTRAINT `cards_user_id_8fb8d426_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `cards_chk_1` CHECK ((`expiry_month` >= 0)),
  CONSTRAINT `cards_chk_2` CHECK ((`expiry_year` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards`
--

LOCK TABLES `cards` WRITE;
/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
INSERT INTO `cards` VALUES (1,'Shaik','CREDIT','Visa','**** **** **** 1111','1111',12,2030,'2026-10-09 10:18:07.197339',2);
/*!40000 ALTER TABLE `cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_users_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-10-09 10:14:25.458143','2','zunaid123@gmail.com',1,'[{\"added\": {}}]',8,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (8,'accounts','user'),(1,'admin','logentry'),(12,'adminpanel','adminlog'),(11,'adminpanel','dailysummary'),(3,'auth','group'),(2,'auth','permission'),(9,'cards','card'),(4,'contenttypes','contenttype'),(5,'sessions','session'),(6,'token_blacklist','blacklistedtoken'),(7,'token_blacklist','outstandingtoken'),(10,'transactions','transaction');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-10-09 09:50:35.246882'),(2,'contenttypes','0002_remove_content_type_name','2026-10-09 09:50:35.795772'),(3,'auth','0001_initial','2026-10-09 09:50:36.157012'),(4,'auth','0002_alter_permission_name_max_length','2026-10-09 09:50:36.215765'),(5,'auth','0003_alter_user_email_max_length','2026-10-09 09:50:36.240751'),(6,'auth','0004_alter_user_username_opts','2026-10-09 09:50:36.267693'),(7,'auth','0005_alter_user_last_login_null','2026-10-09 09:50:36.275191'),(8,'auth','0006_require_contenttypes_0002','2026-10-09 09:50:36.290868'),(9,'auth','0007_alter_validators_add_error_messages','2026-10-09 09:50:36.302853'),(10,'auth','0008_alter_user_username_max_length','2026-10-09 09:50:36.358225'),(11,'auth','0009_alter_user_last_name_max_length','2026-10-09 09:50:36.422202'),(12,'auth','0010_alter_group_name_max_length','2026-10-09 09:50:36.443538'),(13,'auth','0011_update_proxy_permissions','2026-10-09 09:50:36.451007'),(14,'auth','0012_alter_user_first_name_max_length','2026-10-09 09:50:36.463599'),(15,'accounts','0001_initial','2026-10-09 09:50:36.798812'),(16,'admin','0001_initial','2026-10-09 09:50:37.018433'),(17,'admin','0002_logentry_remove_auto_add','2026-10-09 09:50:37.035601'),(18,'admin','0003_logentry_add_action_flag_choices','2026-10-09 09:50:37.048650'),(19,'cards','0001_initial','2026-10-09 09:50:37.129378'),(20,'transactions','0001_initial','2026-10-09 09:50:37.294464'),(21,'adminpanel','0001_initial','2026-10-09 09:50:37.365439'),(22,'sessions','0001_initial','2026-10-09 09:50:37.400197'),(23,'token_blacklist','0001_initial','2026-10-09 09:50:37.577113'),(24,'token_blacklist','0002_outstandingtoken_jti_hex','2026-10-09 09:50:37.728550'),(25,'token_blacklist','0003_auto_20171017_2007','2026-10-09 09:50:37.765635'),(26,'token_blacklist','0004_auto_20171017_2013','2026-10-09 09:50:37.896495'),(27,'token_blacklist','0005_remove_outstandingtoken_jti','2026-10-09 09:50:38.029907'),(28,'token_blacklist','0006_auto_20171017_2113','2026-10-09 09:50:38.060354'),(29,'token_blacklist','0007_auto_20171017_2214','2026-10-09 09:50:38.254009'),(30,'token_blacklist','0008_migrate_to_bigautofield','2026-10-09 09:50:38.752370'),(31,'token_blacklist','0010_fix_migrate_to_bigautofield','2026-10-09 09:50:38.782403'),(32,'token_blacklist','0011_linearizes_history','2026-10-09 09:50:38.809801'),(33,'token_blacklist','0012_alter_outstandingtoken_user','2026-10-09 09:50:38.824894'),(34,'token_blacklist','0013_alter_blacklistedtoken_options_and_more','2026-10-09 09:50:38.843376');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('myddecqxo7ddtqgngel8jf8vfzvl16cm','.eJxVjDEOgzAMAP_iuYriNJDA2J03IMd2GtoKJAJT1b9XSAztene6N4y0b2Xcq67jJNADwuWXJeKnzoeQB833xfAyb-uUzJGY01YzLKKv29n-DQrVAj14dh7Zp2ypC46sZBUKLIiaA4rLsVHF1Kq0QYSdZ8TorQ82N10MV_h8AQiWOFo:1xF7Rl:yAJcjUIvb8L7Php_K61YLpIYlK2gaNfInVl3vx2UIpg','2026-10-23 10:03:25.365472');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_blacklistedtoken`
--

DROP TABLE IF EXISTS `token_blacklist_blacklistedtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_blacklistedtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blacklisted_at` datetime(6) NOT NULL,
  `token_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_id` (`token_id`),
  CONSTRAINT `token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk` FOREIGN KEY (`token_id`) REFERENCES `token_blacklist_outstandingtoken` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_blacklistedtoken`
--

LOCK TABLES `token_blacklist_blacklistedtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `token_blacklist_blacklistedtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token_blacklist_outstandingtoken`
--

DROP TABLE IF EXISTS `token_blacklist_outstandingtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token_blacklist_outstandingtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `expires_at` datetime(6) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `jti` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq` (`jti`),
  KEY `token_blacklist_outstandingtoken_user_id_83bc629a_fk_users_id` (`user_id`),
  CONSTRAINT `token_blacklist_outstandingtoken_user_id_83bc629a_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token_blacklist_outstandingtoken`
--

LOCK TABLES `token_blacklist_outstandingtoken` WRITE;
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` DISABLE KEYS */;
INSERT INTO `token_blacklist_outstandingtoken` VALUES (1,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc5MTYyNzM4MCwiaWF0IjoxNzkxNTQwOTgwLCJqdGkiOiI3MDM1YTNlM2NjNTA0ZjFhOWM1NDI1ZWRjZjcwNmVkYyIsInVzZXJfaWQiOiIyIn0.d459ZfqEYSiVRfZQ8Cc0S2IAMDuc7SBIsFpnrtUsY9w','2026-10-09 10:16:20.765586','2026-10-10 10:16:20.000000',2,'7035a3e3cc504f1a9c5425edcf706edc'),(2,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc5MTYzMDE4NCwiaWF0IjoxNzkxNTQzNzg0LCJqdGkiOiJmZTk0ZDIwOGMyM2M0ZjEyYmU4YjZiZDk3NzBkMDAyYSIsInVzZXJfaWQiOiIyIn0.8IWJVHFyhA9r7LVB8RUrt2kyMFS1-rPjiepJKv5P3wk','2026-10-09 11:03:04.548536','2026-10-10 11:03:04.000000',2,'fe94d208c23c4f12be8b6bd9770d002a'),(3,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc5MTYzMzA0MiwiaWF0IjoxNzkxNTQ2NjQyLCJqdGkiOiI3MGM0ZTk4MjBlYjI0MDNiYWRmMDBmNTVjODIxOTQ2NSIsInVzZXJfaWQiOiIyIn0.Q2tcmqqsE98ZH4Wh3O5hT6vgOGsLbKPYmOPgzLqAioo','2026-10-09 11:50:42.002665','2026-10-10 11:50:42.000000',2,'70c4e9820eb2403badf00f55c8219465');
/*!40000 ALTER TABLE `token_blacklist_outstandingtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `reference` varchar(36) NOT NULL,
  `card_last4` varchar(4) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(3) NOT NULL,
  `description` varchar(255) NOT NULL,
  `status` varchar(10) NOT NULL,
  `failure_reason` varchar(255) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `card_id` bigint DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reference` (`reference`),
  KEY `transactions_card_id_f8e89ea3_fk_cards_id` (`card_id`),
  KEY `transactions_user_id_766cc893_fk_users_id` (`user_id`),
  KEY `transactions_status_d4cdfa27` (`status`),
  KEY `transactions_created_at_3143a260` (`created_at`),
  CONSTRAINT `transactions_card_id_f8e89ea3_fk_cards_id` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`),
  CONSTRAINT `transactions_user_id_766cc893_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,'2a796e9b-4602-4b3e-95a5-4d8091fa46aa','1111',499.50,'INR','Test order','SUCCESS','','2026-10-09 10:21:26.433090','2026-10-09 10:21:26.451906',1,2),(2,'6c5d7d46-84b8-41ba-9ad3-55b508e93ba8','1111',499.50,'INR','Test order','SUCCESS','','2026-10-09 10:32:22.406000','2026-10-09 10:32:22.416763',1,2),(3,'c87286a1-afdf-4275-b928-f2a462e580e8','1111',799.00,'INR','Online shopping payment','SUCCESS','','2026-10-09 10:32:49.730569','2026-10-09 10:32:49.743796',1,2),(4,'16922462-0cae-4a83-9ffc-18de6311844a','1111',799.00,'INR','Online shopping payment','SUCCESS','','2026-10-09 10:37:58.830846','2026-10-09 10:37:58.843325',1,2),(5,'15be6a8c-5c63-4b95-ae4d-6ce9a7bafac4','1111',799.00,'INR','Online shopping payment','SUCCESS','','2026-10-09 10:38:02.050316','2026-10-09 10:38:02.075384',1,2),(6,'7938f874-d3a9-4022-b12b-bd2405e58b0e','1111',789.00,'INR','Online shopping payment','SUCCESS','','2026-10-09 10:38:49.515549','2026-10-09 10:38:49.529274',1,2),(7,'93996c4b-f310-4f46-a2de-81bd4ac1657e','1111',896.00,'INR','Online shopping payment','SUCCESS','','2026-10-09 10:38:58.476279','2026-10-09 10:38:58.488580',1,2),(8,'8920e108-08e0-4dd4-823d-da81c561ed8b','1111',1000.00,'INR','Online shopping payment','SUCCESS','','2026-10-09 10:39:05.841002','2026-10-09 10:39:05.852161',1,2),(9,'e8bcf58e-00e2-4094-9c74-13ea05fa7f4a','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:41:29.866100','2026-10-09 10:41:29.881734',1,2),(10,'48ec98de-e484-44e6-8fe7-621556506295','1111',250.00,'INR','','FAILED','Card declined by the bank','2026-10-09 10:42:47.133706','2026-10-09 10:42:47.148374',1,2),(11,'3a17c358-2c62-4d1e-83b4-178d8e5fe7a0','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:50.872618','2026-10-09 10:42:50.885668',1,2),(12,'345f4b39-7b6d-40a7-af1e-1bc4a165809b','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:51.867537','2026-10-09 10:42:51.882134',1,2),(13,'28842949-c09a-4830-ba43-a63ae84b09f8','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:52.509067','2026-10-09 10:42:52.526283',1,2),(14,'c4db6744-9032-4030-9a77-2c322664d0b3','1111',250.00,'INR','','FAILED','Card declined by the bank','2026-10-09 10:42:53.330144','2026-10-09 10:42:53.345385',1,2),(15,'b3ffe4cd-5534-4d9f-8615-4e94460103d5','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:53.868972','2026-10-09 10:42:53.881515',1,2),(16,'54c229be-ace7-4f19-a65e-9b448c24b0dc','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:55.001913','2026-10-09 10:42:55.018795',1,2),(17,'f6302a29-b347-4246-a591-040066c2f012','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:55.499361','2026-10-09 10:42:55.516787',1,2),(18,'63ee1139-3da3-48d9-8e17-44f39c10161e','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:55.973053','2026-10-09 10:42:55.987932',1,2),(19,'56ecff71-fde9-4274-95b6-3b8ae2ba147b','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:56.418759','2026-10-09 10:42:56.434886',1,2),(20,'de4e9264-87d1-4259-84b7-4faafe00433d','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:56.847063','2026-10-09 10:42:56.863188',1,2),(21,'815c17b0-2b34-4de3-868f-1a02ad6da0eb','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:57.639379','2026-10-09 10:42:57.654449',1,2),(22,'48f1826e-6fc1-468b-8bfc-629d535b11ee','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:58.083038','2026-10-09 10:42:58.102595',1,2),(23,'39b84c40-15d8-4f48-a3c8-38003a8b1f40','1111',250.00,'INR','','FAILED','Suspected fraud, payment blocked','2026-10-09 10:42:58.439028','2026-10-09 10:42:58.451369',1,2),(24,'cb5ab724-dddf-41a1-9dde-52fc35d6e8e6','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:58.826839','2026-10-09 10:42:58.842833',1,2),(25,'c491c790-14be-483e-b6df-3ec17f07b427','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:59.174102','2026-10-09 10:42:59.189979',1,2),(26,'8e06020e-1dd8-4b72-ab52-f671c50afaf3','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:42:59.545480','2026-10-09 10:42:59.559161',1,2),(27,'d3e1405e-4fcc-4a22-b901-8b87a4882975','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:00.006804','2026-10-09 10:43:00.023577',1,2),(28,'7dc05a63-8dab-46d8-a9a9-33ad7dd9b4f1','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:00.320634','2026-10-09 10:43:00.335114',1,2),(29,'8f2302ee-059d-4140-91e1-c65e223c23a4','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:00.689805','2026-10-09 10:43:00.703705',1,2),(30,'778e25ea-9570-46e4-aea1-6107e1330ab5','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:01.327428','2026-10-09 10:43:01.343727',1,2),(31,'f252e2a2-f9d6-40c6-88f5-077c74f9aa5c','1111',250.00,'INR','','FAILED','Card declined by the bank','2026-10-09 10:43:01.723133','2026-10-09 10:43:01.732639',1,2),(32,'796c78fc-5097-444e-ad39-4116bcb849fd','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:02.089170','2026-10-09 10:43:02.100819',1,2),(33,'6b68e867-b28a-4eac-b753-6f6be149869e','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:02.405280','2026-10-09 10:43:02.419682',1,2),(34,'d2348783-f87e-4b59-9484-aea850bf0df7','1111',250.00,'INR','','FAILED','Suspected fraud, payment blocked','2026-10-09 10:43:02.887925','2026-10-09 10:43:02.902466',1,2),(35,'8cdfcebb-31b7-4aae-b0ed-280bfea50705','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:03.139227','2026-10-09 10:43:03.154720',1,2),(36,'88174179-5bf4-4349-8266-1606aad57284','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:03.420781','2026-10-09 10:43:03.435917',1,2),(37,'ce8ed469-70aa-473d-8645-a15bfb9f54b6','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:03.641996','2026-10-09 10:43:03.657364',1,2),(38,'ff95b612-a420-42d3-be02-b6df852ed8ea','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:03.831128','2026-10-09 10:43:03.846568',1,2),(39,'fa70e16e-55e7-45c9-aec1-235acada4f10','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:04.017862','2026-10-09 10:43:04.033033',1,2),(40,'f4cd6891-287b-4692-992c-2688d0aaede4','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:04.363955','2026-10-09 10:43:04.377911',1,2),(41,'83083c53-3e92-4f91-972b-f9afbf1f485b','1111',250.00,'INR','','FAILED','Payment gateway timeout','2026-10-09 10:43:04.517163','2026-10-09 10:43:04.529775',1,2),(42,'b9685eab-6374-4588-b06e-0373a08184c7','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:04.708010','2026-10-09 10:43:04.718779',1,2),(43,'683ca184-df06-4424-9fb2-7c3d96205947','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:04.841531','2026-10-09 10:43:04.853173',1,2),(44,'16b84a3e-eb4b-48bd-975e-d8b5f3732b2a','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:05.030954','2026-10-09 10:43:05.045387',1,2),(45,'004a8ea3-5082-4430-9216-a55610805add','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:05.379737','2026-10-09 10:43:05.393776',1,2),(46,'7a2efc4c-2809-493f-b826-02b68388c4d0','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:05.576456','2026-10-09 10:43:05.593036',1,2),(47,'bcbe91a9-a870-4548-b7a2-8f6373cfdc95','1111',250.00,'INR','','FAILED','Payment gateway timeout','2026-10-09 10:43:05.777708','2026-10-09 10:43:05.791911',1,2),(48,'fc87d42e-27a0-4a31-965b-67ecdfcb2420','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:05.934010','2026-10-09 10:43:05.946579',1,2),(49,'d7699b1a-ff0b-46cd-b5ae-4d8426e3545d','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:06.095153','2026-10-09 10:43:06.107709',1,2),(50,'b678be4a-ff94-4d2b-a5cd-153223d6c7bd','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:06.409398','2026-10-09 10:43:06.425087',1,2),(51,'a0bb3ac1-db6e-4064-901e-18a8428af129','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:06.567109','2026-10-09 10:43:06.583190',1,2),(52,'d09929c7-6aac-4302-a728-6e58e310aacc','1111',250.00,'INR','','FAILED','Suspected fraud, payment blocked','2026-10-09 10:43:06.765194','2026-10-09 10:43:06.776875',1,2),(53,'467ba65e-76ce-4612-b84d-cb2782986051','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:06.901453','2026-10-09 10:43:06.915062',1,2),(54,'19ea2b1d-441d-4d51-afde-f33911117d7b','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:07.127982','2026-10-09 10:43:07.139497',1,2),(55,'e8c165de-c580-487e-9753-c4426b3c3319','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:07.416134','2026-10-09 10:43:07.431189',1,2),(56,'e284f9c3-2482-4d56-84fd-5aa8451c1e78','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:07.584335','2026-10-09 10:43:07.598032',1,2),(57,'5d1e8cb9-2484-408f-b32d-28951fe33127','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:07.823004','2026-10-09 10:43:07.837082',1,2),(58,'d0f8c9d2-bf99-44c7-acc5-f88bfcfd9413','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:08.058276','2026-10-09 10:43:08.072402',1,2),(59,'f515f469-3f22-4b2c-a765-ec2cce9eb3e2','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:08.256429','2026-10-09 10:43:08.269808',1,2),(60,'c64d8a61-0e90-4740-977d-ed587c9f3dad','1111',250.00,'INR','','SUCCESS','','2026-10-09 10:43:08.603423','2026-10-09 10:43:08.617302',1,2),(61,'b270bfd1-8e5f-41a9-9ff8-b6755e9719a7','1111',250.00,'INR','','FAILED','Insufficient funds','2026-10-09 11:03:40.186268','2026-10-09 11:03:40.207172',1,2),(62,'b014faa0-77d8-4efa-8704-10ac876dad8f','1111',250.00,'INR','','FAILED','Insufficient funds','2026-10-09 11:04:50.647999','2026-10-09 11:04:50.655115',1,2),(63,'ca5f8c2b-8698-4d1e-a4d1-f1a7bafa6232','1111',250.00,'INR','','FAILED','Suspected fraud, payment blocked','2026-10-09 11:04:51.217747','2026-10-09 11:04:51.227883',1,2),(64,'35c4a630-dfe0-40cb-b8ae-9f5a59c14a94','1111',250.00,'INR','','FAILED','Suspected fraud, payment blocked','2026-10-09 11:04:51.923851','2026-10-09 11:04:51.934009',1,2),(65,'2200ac08-b32e-4f38-a96f-933cd630754e','1111',250.00,'INR','','FAILED','Card declined by the bank','2026-10-09 11:04:52.138266','2026-10-09 11:04:52.147539',1,2),(66,'2d8fcaa7-ff5f-42ea-bb3b-b7f6bae6ea67','1111',250.00,'INR','','FAILED','Payment gateway timeout','2026-10-09 11:04:52.316886','2026-10-09 11:04:52.325712',1,2),(67,'d7d069d6-b5a7-4ee5-8dd9-86d0e65ea75f','1111',250.00,'INR','','FAILED','Payment gateway timeout','2026-10-09 11:04:52.510285','2026-10-09 11:04:52.519948',1,2),(68,'313fbc73-92ef-4ac3-9649-930842826a5d','1111',250.00,'INR','','FAILED','Insufficient funds','2026-10-09 11:04:52.641597','2026-10-09 11:04:52.650381',1,2),(69,'2321eeff-c174-4c0f-acf0-fdbb593733aa','1111',250.00,'INR','','FAILED','Suspected fraud, payment blocked','2026-10-09 11:04:52.810311','2026-10-09 11:04:52.820447',1,2),(70,'07f4c58f-5b47-410a-b4d3-7c145e36be00','1111',250.00,'INR','','FAILED','Payment gateway timeout','2026-10-09 11:04:52.978124','2026-10-09 11:04:52.988825',1,2),(71,'c42eedc7-d07a-47e3-a439-4fe3e8623045','1111',499.00,'INR','','FAILED','Suspected fraud, payment blocked','2026-10-09 11:51:33.039358','2026-10-09 11:51:33.057005',1,2);
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `email` varchar(254) NOT NULL,
  `phone` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'pbkdf2_sha256$1000000$kZkO8BfQIM7A8tH3fZBpaY$cXtYz/Y7MYmzFlJVWx/cMvS3YYJgJanOoYTAcGZ4/3M=','2026-10-09 10:03:25.360367',1,'admin','','',1,1,'2026-10-09 09:53:41.730798','admin1234@gmail.com',''),(2,'pbkdf2_sha256$1000000$fpBQRbLHQfKAaqrmb6gpqu$gLNAaFtYYq9x7kbPSXQeMQEy3WBZBfBYq7sN4G7Z5nE=',NULL,0,'zunaid123@gmail.com','','',0,1,'2026-10-09 10:14:24.775483','zunaid123@gmail.com','');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_groups`
--

DROP TABLE IF EXISTS `users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_groups_user_id_group_id_fc7788e8_uniq` (`user_id`,`group_id`),
  KEY `users_groups_group_id_2f3517aa_fk_auth_group_id` (`group_id`),
  CONSTRAINT `users_groups_group_id_2f3517aa_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `users_groups_user_id_f500bee5_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_groups`
--

LOCK TABLES `users_groups` WRITE;
/*!40000 ALTER TABLE `users_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_user_permissions`
--

DROP TABLE IF EXISTS `users_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_user_permissions_user_id_permission_id_3b86cbdf_uniq` (`user_id`,`permission_id`),
  KEY `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` (`permission_id`),
  CONSTRAINT `users_user_permissio_permission_id_6d08dcd2_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `users_user_permissions_user_id_92473840_fk_users_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_user_permissions`
--

LOCK TABLES `users_user_permissions` WRITE;
/*!40000 ALTER TABLE `users_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-10 21:02:06
