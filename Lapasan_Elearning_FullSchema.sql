/*M!999999\- enable the sandbox mode */ 

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `lapasan_elearning` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `lapasan_elearning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_setting` (
  `academic_setting_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `school_year_id` int(10) unsigned NOT NULL,
  `passing_policy` decimal(5,2) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`academic_setting_id`),
  UNIQUE KEY `uq_academic_setting_school_year` (`school_year_id`),
  CONSTRAINT `fk_setting_school_year` FOREIGN KEY (`school_year_id`) REFERENCES `school_year` (`school_year_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `academic_setting` WRITE;
/*!40000 ALTER TABLE `academic_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_setting` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `action` (
  `action_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `action_code` varchar(50) NOT NULL COMMENT 'Machine-readable, used by the application',
  `action_name` varchar(100) NOT NULL COMMENT 'Human-readable label',
  `category` varchar(30) NOT NULL COMMENT 'AUTH, ACCOUNT, CONTENT, ACTIVITY, GRADING, AI, ADMIN',
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`action_id`),
  UNIQUE KEY `uq_action_code` (`action_code`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `action` WRITE;
/*!40000 ALTER TABLE `action` DISABLE KEYS */;
INSERT INTO `action` VALUES
(1,'LOGIN','User logged in','AUTH','Successful sign-in',1),
(2,'LOGOUT','User logged out','AUTH','User ended their session',1),
(3,'LOGIN_FAILED','Failed login attempt','AUTH','Wrong username or password',1),
(4,'PASSWORD_CHANGE','Password changed','ACCOUNT','User or admin changed a password',1),
(5,'PASSWORD_RESET','Password reset','ACCOUNT','Password reset by administrator',1),
(6,'ACCOUNT_CREATE','Account created','ACCOUNT','New user account added',1),
(7,'ACCOUNT_UPDATE','Account updated','ACCOUNT','User profile or role changed',1),
(8,'ACCOUNT_DEACTIVATE','Account deactivated','ACCOUNT','User account disabled',1),
(9,'CLASS_CREATE','Class created','ADMIN','New class/section created',1),
(10,'STUDENT_ASSIGN','Student assigned to class','ADMIN','Student enrolled in a class',1),
(11,'LESSON_CREATE','Lesson created','CONTENT','Teacher created a lesson',1),
(12,'LESSON_UPDATE','Lesson updated','CONTENT','Teacher edited a lesson',1),
(13,'LESSON_PUBLISH','Lesson published to class','CONTENT','Lesson made visible to a class',1),
(14,'LESSON_DELETE','Lesson deleted','CONTENT','Lesson removed',1),
(15,'FILE_UPLOAD','File uploaded','CONTENT','Lesson or submission file uploaded',1),
(16,'FILE_DOWNLOAD','File downloaded','CONTENT','Lesson or submission file downloaded',1),
(17,'AI_REQUEST','AI generation requested','AI','Teacher asked the AI to generate material',1),
(18,'AI_COMPLETE','AI generation completed','AI','AI finished generating material',1),
(19,'AI_FAILED','AI generation failed','AI','AI request ended in an error',1),
(20,'ACTIVITY_APPROVE','Activity approved','ACTIVITY','Teacher approved AI-generated activity',1),
(21,'ACTIVITY_REJECT','Activity rejected','ACTIVITY','Teacher rejected AI-generated activity',1),
(22,'ACTIVITY_PUBLISH','Activity published','ACTIVITY','Activity released to students',1),
(23,'ACTIVITY_UPDATE','Activity edited','ACTIVITY','Teacher edited an activity',1),
(24,'SUBMISSION_CREATE','Activity submitted','ACTIVITY','Student submitted an activity',1),
(25,'SUBMISSION_SCORE','Submission scored','GRADING','Submission scored or checked',1),
(26,'GRADE_POST','Grade posted','GRADING','Final grade released',1),
(27,'GRADE_UPDATE','Grade updated','GRADING','Posted grade was changed',1),
(28,'SETTING_UPDATE','Academic setting updated','ADMIN','School year/grading policy changed',1);
/*!40000 ALTER TABLE `action` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_log` (
  `log_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `action_id` smallint(5) unsigned NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`),
  KEY `fk_log_user` (`user_id`),
  KEY `fk_log_action` (`action_id`),
  CONSTRAINT `fk_log_action` FOREIGN KEY (`action_id`) REFERENCES `action` (`action_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_setting` (
  `activity_id` int(10) unsigned NOT NULL,
  `time_limit_minutes` smallint(5) unsigned DEFAULT NULL,
  `max_attempts` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `show_score_immediately` tinyint(1) NOT NULL DEFAULT 0,
  `randomize_questions` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`activity_id`),
  CONSTRAINT `fk_activity_setting` FOREIGN KEY (`activity_id`) REFERENCES `learning_activity` (`activity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `activity_setting` WRITE;
/*!40000 ALTER TABLE `activity_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_setting` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_type` (
  `activity_type_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `type_code` varchar(20) NOT NULL,
  `type_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `uses_questions` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = built from question/question_option rows',
  `is_auto_gradable` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = objective items can be scored by the system',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`activity_type_id`),
  UNIQUE KEY `uq_activity_type_code` (`type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `activity_type` WRITE;
/*!40000 ALTER TABLE `activity_type` DISABLE KEYS */;
INSERT INTO `activity_type` VALUES
(1,'QUIZ','Quiz','Short graded set of questions',1,1,1),
(2,'ASSIGNMENT','Assignment','Take-home task, answered by text and/or file upload',0,0,1),
(3,'SEATWORK','Seatwork','In-class practice exercise',1,1,1),
(4,'EXAM','Exam','Periodical or long test',1,1,1),
(5,'WRITING_TASK','Writing Task','Essay, paragraph or other written output',0,0,1),
(6,'PERFORMANCE_TASK','Performance Task','Speaking, listening or project-based task',0,0,1);
/*!40000 ALTER TABLE `activity_type` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_generation_request` (
  `request_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `teacher_id` int(10) unsigned NOT NULL,
  `source_lesson_id` int(10) unsigned NOT NULL,
  `requested_material_type` varchar(20) NOT NULL,
  `learning_objective` text NOT NULL,
  `difficulty_id` tinyint(3) unsigned NOT NULL,
  `question_count` smallint(5) unsigned DEFAULT NULL,
  `request_status_id` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `error_message` varchar(255) DEFAULT NULL,
  `requested_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`request_id`),
  KEY `fk_ai_teacher` (`teacher_id`),
  KEY `fk_ai_lesson` (`source_lesson_id`),
  KEY `fk_ai_difficulty` (`difficulty_id`),
  KEY `fk_ai_request_status` (`request_status_id`),
  CONSTRAINT `fk_ai_difficulty` FOREIGN KEY (`difficulty_id`) REFERENCES `difficulty` (`difficulty_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_lesson` FOREIGN KEY (`source_lesson_id`) REFERENCES `lesson` (`lesson_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_request_status` FOREIGN KEY (`request_status_id`) REFERENCES `request_status` (`request_status_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ai_generation_request` WRITE;
/*!40000 ALTER TABLE `ai_generation_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_generation_request` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `class_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `teacher_id` int(10) unsigned NOT NULL,
  `academic_setting_id` int(10) unsigned NOT NULL,
  `grade_level_id` tinyint(3) unsigned NOT NULL,
  `section_name` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`class_id`),
  UNIQUE KEY `uq_class` (`academic_setting_id`,`grade_level_id`,`section_name`),
  KEY `fk_class_teacher` (`teacher_id`),
  KEY `fk_class_setting` (`academic_setting_id`),
  KEY `fk_class_grade_level` (`grade_level_id`),
  CONSTRAINT `fk_class_grade_level` FOREIGN KEY (`grade_level_id`) REFERENCES `grade_level` (`grade_level_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_class_setting` FOREIGN KEY (`academic_setting_id`) REFERENCES `academic_setting` (`academic_setting_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_class_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_student` (
  `class_student_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_id` int(10) unsigned NOT NULL,
  `student_id` int(10) unsigned NOT NULL,
  `assigned_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`class_student_id`),
  UNIQUE KEY `uq_class_student` (`class_id`,`student_id`),
  KEY `fk_cs_student` (`student_id`),
  CONSTRAINT `fk_cs_class` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cs_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `class_student` WRITE;
/*!40000 ALTER TABLE `class_student` DISABLE KEYS */;
/*!40000 ALTER TABLE `class_student` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `difficulty` (
  `difficulty_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `difficulty_code` varchar(20) NOT NULL,
  `difficulty_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL COMMENT 'Guidance given to the AI for this level',
  `display_order` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`difficulty_id`),
  UNIQUE KEY `uq_difficulty_code` (`difficulty_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `difficulty` WRITE;
/*!40000 ALTER TABLE `difficulty` DISABLE KEYS */;
INSERT INTO `difficulty` VALUES
(1,'EASY','Easy','Recall and basic understanding; straightforward items',1,1),
(2,'MEDIUM','Medium','Application and analysis; moderately challenging items',2,1),
(3,'HARD','Hard','Evaluation and higher-order thinking; challenging items',3,1);
/*!40000 ALTER TABLE `difficulty` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `file_type` (
  `file_type_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL COMMENT 'e.g. PDF Document',
  `extension` varchar(10) NOT NULL COMMENT 'lowercase, no dot',
  `mime_type` varchar(100) NOT NULL,
  `category` varchar(20) NOT NULL COMMENT 'DOCUMENT, PRESENTATION, SPREADSHEET, IMAGE, AUDIO, VIDEO, ARCHIVE, OTHER',
  `max_file_size_kb` int(10) unsigned NOT NULL DEFAULT 10240 COMMENT 'Upload limit for this type (KB)',
  `allowed_for_lesson` tinyint(1) NOT NULL DEFAULT 1,
  `allowed_for_submission` tinyint(1) NOT NULL DEFAULT 1,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`file_type_id`),
  UNIQUE KEY `uq_file_type_extension` (`extension`),
  KEY `idx_file_type_mime` (`mime_type`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `file_type` WRITE;
/*!40000 ALTER TABLE `file_type` DISABLE KEYS */;
INSERT INTO `file_type` VALUES
(1,'PDF Document','pdf','application/pdf','DOCUMENT',20480,1,1,1),
(2,'Word Document','docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document','DOCUMENT',10240,1,1,1),
(3,'Word Document (legacy)','doc','application/msword','DOCUMENT',10240,1,1,1),
(4,'PowerPoint Presentation','pptx','application/vnd.openxmlformats-officedocument.presentationml.presentation','PRESENTATION',30720,1,1,1),
(5,'PowerPoint (legacy)','ppt','application/vnd.ms-powerpoint','PRESENTATION',30720,1,1,1),
(6,'Excel Spreadsheet','xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','SPREADSHEET',10240,1,1,1),
(7,'Excel (legacy)','xls','application/vnd.ms-excel','SPREADSHEET',10240,1,1,1),
(8,'Plain Text','txt','text/plain','DOCUMENT',2048,1,1,1),
(9,'JPEG Image','jpg','image/jpeg','IMAGE',5120,1,1,1),
(10,'JPEG Image (jpeg)','jpeg','image/jpeg','IMAGE',5120,1,1,1),
(11,'PNG Image','png','image/png','IMAGE',5120,1,1,1),
(12,'GIF Image','gif','image/gif','IMAGE',5120,1,0,1),
(13,'MP3 Audio','mp3','audio/mpeg','AUDIO',20480,1,1,1),
(14,'MP4 Video','mp4','video/mp4','VIDEO',51200,1,1,1),
(15,'ZIP Archive','zip','application/zip','ARCHIVE',51200,1,0,1),
(99,'Other','bin','application/octet-stream','OTHER',5120,0,0,1);
/*!40000 ALTER TABLE `file_type` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `grade` (
  `grade_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class_student_id` int(10) unsigned NOT NULL,
  `grading_period_id` int(10) unsigned NOT NULL,
  `grade_value` decimal(5,2) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `posted_at` datetime DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`grade_id`),
  UNIQUE KEY `uq_grade` (`class_student_id`,`grading_period_id`),
  KEY `fk_grade_period` (`grading_period_id`),
  CONSTRAINT `fk_grade_cs` FOREIGN KEY (`class_student_id`) REFERENCES `class_student` (`class_student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_grade_period` FOREIGN KEY (`grading_period_id`) REFERENCES `grading_period` (`grading_period_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `grade` WRITE;
/*!40000 ALTER TABLE `grade` DISABLE KEYS */;
/*!40000 ALTER TABLE `grade` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `grade_level` (
  `grade_level_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `grade_level_no` tinyint(3) unsigned NOT NULL COMMENT 'Numeric grade: 7 or 8',
  `grade_level_name` varchar(30) NOT NULL COMMENT 'e.g. Grade 7',
  `description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`grade_level_id`),
  UNIQUE KEY `uq_grade_level_no` (`grade_level_no`),
  UNIQUE KEY `uq_grade_level_name` (`grade_level_name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `grade_level` WRITE;
/*!40000 ALTER TABLE `grade_level` DISABLE KEYS */;
INSERT INTO `grade_level` VALUES
(1,7,'Grade 7','Junior High School - Grade 7',1),
(2,8,'Grade 8','Junior High School - Grade 8',1);
/*!40000 ALTER TABLE `grade_level` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `grading_period` (
  `grading_period_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `academic_setting_id` int(10) unsigned NOT NULL,
  `period_no` tinyint(3) unsigned NOT NULL,
  `period_name` varchar(50) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`grading_period_id`),
  UNIQUE KEY `uq_grading_period` (`academic_setting_id`,`period_no`),
  CONSTRAINT `fk_period_setting` FOREIGN KEY (`academic_setting_id`) REFERENCES `academic_setting` (`academic_setting_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `grading_period` WRITE;
/*!40000 ALTER TABLE `grading_period` DISABLE KEYS */;
/*!40000 ALTER TABLE `grading_period` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `learning_activity` (
  `activity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ai_request_id` int(10) unsigned NOT NULL,
  `class_id` int(10) unsigned NOT NULL,
  `title` varchar(150) NOT NULL,
  `content` longtext DEFAULT NULL,
  `activity_type_id` tinyint(3) unsigned NOT NULL,
  `learning_objective` text NOT NULL,
  `difficulty` varchar(20) NOT NULL,
  `number_of_items` smallint(5) unsigned DEFAULT NULL,
  `learning_activity_status_id` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `due_date` datetime DEFAULT NULL,
  `max_score` decimal(5,2) DEFAULT NULL,
  `approved_by` int(10) unsigned DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`activity_id`),
  UNIQUE KEY `ai_request_id` (`ai_request_id`),
  KEY `fk_activity_class` (`class_id`),
  KEY `fk_activity_approver` (`approved_by`),
  KEY `fk_activity_type` (`activity_type_id`),
  KEY `fk_activity_status` (`learning_activity_status_id`),
  CONSTRAINT `fk_activity_approver` FOREIGN KEY (`approved_by`) REFERENCES `teacher` (`teacher_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_class` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_request` FOREIGN KEY (`ai_request_id`) REFERENCES `ai_generation_request` (`request_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_status` FOREIGN KEY (`learning_activity_status_id`) REFERENCES `learning_activity_status` (`learning_activity_status_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_type` FOREIGN KEY (`activity_type_id`) REFERENCES `activity_type` (`activity_type_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `learning_activity` WRITE;
/*!40000 ALTER TABLE `learning_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `learning_activity` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `learning_activity_status` (
  `learning_activity_status_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `status_code` varchar(20) NOT NULL,
  `status_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_visible_to_students` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = students can see activities in this status',
  `allows_submission` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = students can still submit answers',
  `display_order` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`learning_activity_status_id`),
  UNIQUE KEY `uq_learning_activity_status_code` (`status_code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `learning_activity_status` WRITE;
/*!40000 ALTER TABLE `learning_activity_status` DISABLE KEYS */;
INSERT INTO `learning_activity_status` VALUES
(1,'PENDING_APPROVAL','Pending approval','AI-generated; waiting for teacher review',0,0,1,1),
(2,'APPROVED','Approved','Approved by teacher; not yet released to students',0,0,2,1),
(3,'REJECTED','Rejected','Teacher rejected the generated activity',0,0,3,1),
(4,'PUBLISHED','Published','Released to students; accepting submissions',1,1,4,1),
(5,'CLOSED','Closed','Visible to students but no longer accepting work',1,0,5,1),
(6,'ARCHIVED','Archived','Hidden from students; kept for records',0,0,6,1);
/*!40000 ALTER TABLE `learning_activity_status` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lesson` (
  `lesson_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `teacher_id` int(10) unsigned NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`lesson_id`),
  KEY `fk_lesson_teacher` (`teacher_id`),
  CONSTRAINT `fk_lesson_teacher` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `lesson` WRITE;
/*!40000 ALTER TABLE `lesson` DISABLE KEYS */;
/*!40000 ALTER TABLE `lesson` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lesson_class` (
  `lesson_class_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lesson_id` int(10) unsigned NOT NULL,
  `class_id` int(10) unsigned NOT NULL,
  `published_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`lesson_class_id`),
  UNIQUE KEY `uq_lesson_class` (`lesson_id`,`class_id`),
  KEY `fk_lc_class` (`class_id`),
  CONSTRAINT `fk_lc_class` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lc_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`lesson_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `lesson_class` WRITE;
/*!40000 ALTER TABLE `lesson_class` DISABLE KEYS */;
/*!40000 ALTER TABLE `lesson_class` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lesson_file` (
  `file_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lesson_id` int(10) unsigned NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_type_id` smallint(5) unsigned NOT NULL,
  `file_size` int(10) unsigned DEFAULT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`file_id`),
  KEY `fk_lesson_file` (`lesson_id`),
  KEY `fk_lesson_file_type` (`file_type_id`),
  CONSTRAINT `fk_lesson_file` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`lesson_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lesson_file_type` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`file_type_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `lesson_file` WRITE;
/*!40000 ALTER TABLE `lesson_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `lesson_file` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `notification_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `lesson_id` int(10) unsigned DEFAULT NULL,
  `activity_id` int(10) unsigned DEFAULT NULL,
  `grade_id` int(10) unsigned DEFAULT NULL,
  `notification_type_id` smallint(5) unsigned NOT NULL,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`notification_id`),
  KEY `fk_notification_user` (`user_id`),
  KEY `fk_notification_lesson` (`lesson_id`),
  KEY `fk_notification_activity` (`activity_id`),
  KEY `fk_notification_grade` (`grade_id`),
  KEY `fk_notification_type` (`notification_type_id`),
  CONSTRAINT `fk_notification_activity` FOREIGN KEY (`activity_id`) REFERENCES `learning_activity` (`activity_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_grade` FOREIGN KEY (`grade_id`) REFERENCES `grade` (`grade_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`lesson_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_type` FOREIGN KEY (`notification_type_id`) REFERENCES `notification_type` (`notification_type_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_type` (
  `notification_type_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `type_code` varchar(30) NOT NULL COMMENT 'Machine-readable, used by the application',
  `type_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `message_template` varchar(255) DEFAULT NULL COMMENT 'Default text; {placeholders} filled by the app',
  `target_role_id` tinyint(3) unsigned DEFAULT NULL COMMENT 'Who normally receives it; NULL = any role',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`notification_type_id`),
  UNIQUE KEY `uq_notification_type_code` (`type_code`),
  KEY `fk_ntype_role` (`target_role_id`),
  CONSTRAINT `fk_ntype_role` FOREIGN KEY (`target_role_id`) REFERENCES `role` (`role_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `notification_type` WRITE;
/*!40000 ALTER TABLE `notification_type` DISABLE KEYS */;
INSERT INTO `notification_type` VALUES
(1,'NEW_LESSON','New lesson','A lesson was published to the student\'s class','New lesson posted: {lesson_title}',3,1),
(2,'NEW_ACTIVITY','New activity','An activity was published to the student\'s class','New activity available: {activity_title}',3,1),
(3,'ACTIVITY_DUE_SOON','Activity due soon','Reminder before an activity deadline','{activity_title} is due on {due_date}',3,1),
(4,'ACTIVITY_OVERDUE','Activity overdue','Deadline passed without a submission','{activity_title} is past its due date',3,1),
(5,'SUBMISSION_SCORED','Submission scored','A submission was checked and scored','Your score for {activity_title} is ready',3,1),
(6,'SUBMISSION_RETURNED','Submission returned','Teacher returned a submission for revision','{activity_title} was returned for revision',3,1),
(7,'GRADE_POSTED','Grade posted','A grading period grade was released','Your grade for {period_name} has been posted',3,1),
(8,'CLASS_ASSIGNED','Added to class','Student was assigned to a class','You were added to {class_name}',3,1),
(9,'SUBMISSION_RECEIVED','Submission received','A student submitted an activity','{student_name} submitted {activity_title}',2,1),
(10,'APPROVAL_REQUIRED','Activity awaiting approval','AI-generated activity needs teacher review','{activity_title} is waiting for your approval',2,1),
(11,'AI_COMPLETED','AI generation completed','AI finished generating material','Your AI-generated {material_type} is ready for review',2,1),
(12,'AI_FAILED','AI generation failed','AI request ended in an error','AI generation failed. Please try again',2,1),
(13,'ACCOUNT_NOTICE','Account notice','Account or security related notice','{message}',NULL,1),
(14,'ANNOUNCEMENT','Announcement','General announcement from teacher or admin','{message}',NULL,1);
/*!40000 ALTER TABLE `notification_type` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `question_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` int(10) unsigned NOT NULL,
  `question_text` text NOT NULL,
  `question_type` varchar(20) NOT NULL,
  `points` decimal(5,2) NOT NULL,
  `sequence_no` smallint(5) unsigned NOT NULL,
  `correct_answer` varchar(255) DEFAULT NULL,
  `skill_area_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  UNIQUE KEY `uq_question_sequence` (`activity_id`,`sequence_no`),
  KEY `fk_question_skill_area` (`skill_area_id`),
  CONSTRAINT `fk_question_activity` FOREIGN KEY (`activity_id`) REFERENCES `learning_activity` (`activity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_question_skill_area` FOREIGN KEY (`skill_area_id`) REFERENCES `skill_area` (`skill_area_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_option` (
  `option_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `question_id` int(10) unsigned NOT NULL,
  `option_text` varchar(500) NOT NULL,
  `is_correct` tinyint(1) NOT NULL DEFAULT 0,
  `match_text` text DEFAULT NULL,
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `uq_question_option` (`question_id`,`option_id`),
  CONSTRAINT `fk_option_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `question_option` WRITE;
/*!40000 ALTER TABLE `question_option` DISABLE KEYS */;
/*!40000 ALTER TABLE `question_option` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `request_status` (
  `request_status_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `status_code` varchar(20) NOT NULL,
  `status_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_final` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = request is finished, no more changes expected',
  `display_order` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`request_status_id`),
  UNIQUE KEY `uq_request_status_code` (`status_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `request_status` WRITE;
/*!40000 ALTER TABLE `request_status` DISABLE KEYS */;
INSERT INTO `request_status` VALUES
(1,'PENDING','Pending','Request saved and waiting to be sent to the AI',0,1,1),
(2,'PROCESSING','Processing','AI is generating the material',0,2,1),
(3,'COMPLETED','Completed','Material generated successfully',1,3,1),
(4,'FAILED','Failed','Generation failed; see error_message',1,4,1),
(5,'CANCELLED','Cancelled','Teacher cancelled the request',1,5,1);
/*!40000 ALTER TABLE `request_status` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `role_name` varchar(30) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES
(1,'Administrator'),
(3,'Student'),
(2,'Teacher/Adviser');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `school_year` (
  `school_year_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `year_label` varchar(9) NOT NULL COMMENT 'e.g. 2026-2027',
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`school_year_id`),
  UNIQUE KEY `uq_school_year_label` (`year_label`),
  CONSTRAINT `chk_school_year_dates` CHECK (`end_date` > `start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `school_year` WRITE;
/*!40000 ALTER TABLE `school_year` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_year` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `skill_area` (
  `skill_area_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`skill_area_id`),
  UNIQUE KEY `uk_skill_area_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `skill_area` WRITE;
/*!40000 ALTER TABLE `skill_area` DISABLE KEYS */;
INSERT INTO `skill_area` VALUES
(10,'Critical Reading'),
(5,'Grammar'),
(3,'Listening'),
(9,'Literary Analysis'),
(8,'Punctuation and Mechanics'),
(1,'Reading Comprehension'),
(4,'Speaking'),
(7,'Spelling'),
(6,'Vocabulary'),
(2,'Writing');
/*!40000 ALTER TABLE `skill_area` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `student_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `lrn` char(12) NOT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `lrn` (`lrn`),
  CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission` (
  `submission_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `activity_id` int(10) unsigned NOT NULL,
  `class_student_id` int(10) unsigned NOT NULL,
  `attempt_no` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `submission_text` longtext DEFAULT NULL,
  `submitted_at` datetime NOT NULL DEFAULT current_timestamp(),
  `submission_status_id` tinyint(3) unsigned NOT NULL DEFAULT 2,
  `score` decimal(5,2) DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `scored_at` datetime DEFAULT NULL,
  PRIMARY KEY (`submission_id`),
  UNIQUE KEY `uq_submission_attempt` (`activity_id`,`class_student_id`,`attempt_no`),
  KEY `fk_submission_cs` (`class_student_id`),
  KEY `fk_submission_status` (`submission_status_id`),
  CONSTRAINT `fk_submission_activity` FOREIGN KEY (`activity_id`) REFERENCES `learning_activity` (`activity_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submission_cs` FOREIGN KEY (`class_student_id`) REFERENCES `class_student` (`class_student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submission_status` FOREIGN KEY (`submission_status_id`) REFERENCES `submission_status` (`submission_status_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `submission` WRITE;
/*!40000 ALTER TABLE `submission` DISABLE KEYS */;
/*!40000 ALTER TABLE `submission` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission_answer` (
  `answer_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `submission_id` int(10) unsigned NOT NULL,
  `question_id` int(10) unsigned NOT NULL,
  `selected_option_id` int(10) unsigned DEFAULT NULL,
  `answer_text` longtext DEFAULT NULL,
  `points_awarded` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`answer_id`),
  UNIQUE KEY `uq_submission_question` (`submission_id`,`question_id`),
  KEY `fk_answer_option` (`question_id`,`selected_option_id`),
  CONSTRAINT `fk_answer_option` FOREIGN KEY (`question_id`, `selected_option_id`) REFERENCES `question_option` (`question_id`, `option_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_question` FOREIGN KEY (`question_id`) REFERENCES `question` (`question_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_answer_submission` FOREIGN KEY (`submission_id`) REFERENCES `submission` (`submission_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `submission_answer` WRITE;
/*!40000 ALTER TABLE `submission_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `submission_answer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission_file` (
  `file_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `submission_id` int(10) unsigned NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_type_id` smallint(5) unsigned NOT NULL,
  `file_size` int(10) unsigned DEFAULT NULL,
  `uploaded_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`file_id`),
  KEY `fk_submission_file` (`submission_id`),
  KEY `fk_submission_file_type` (`file_type_id`),
  CONSTRAINT `fk_submission_file` FOREIGN KEY (`submission_id`) REFERENCES `submission` (`submission_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_submission_file_type` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`file_type_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `submission_file` WRITE;
/*!40000 ALTER TABLE `submission_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `submission_file` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `submission_status` (
  `submission_status_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `status_code` varchar(20) NOT NULL,
  `status_name` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_scored` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = score is final/visible for this status',
  `display_order` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`submission_status_id`),
  UNIQUE KEY `uq_submission_status_code` (`status_code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `submission_status` WRITE;
/*!40000 ALTER TABLE `submission_status` DISABLE KEYS */;
INSERT INTO `submission_status` VALUES
(1,'IN_PROGRESS','In progress','Student started but has not submitted yet',0,1,1),
(2,'SUBMITTED','Submitted','Submitted on time, waiting to be checked',0,2,1),
(3,'LATE_SUBMITTED','Submitted (late)','Submitted after the due date',0,3,1),
(4,'UNDER_REVIEW','Under review','Teacher is checking the submission',0,4,1),
(5,'GRADED','Graded','Scored; the score and feedback are available',1,5,1),
(6,'RETURNED','Returned','Sent back to the student for revision',0,6,1);
/*!40000 ALTER TABLE `submission_status` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher` (
  `teacher_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `employee_no` varchar(20) NOT NULL,
  PRIMARY KEY (`teacher_id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `employee_no` (`employee_no`),
  CONSTRAINT `fk_teacher_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `teacher` WRITE;
/*!40000 ALTER TABLE `teacher` DISABLE KEYS */;
/*!40000 ALTER TABLE `teacher` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_account` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` tinyint(3) unsigned NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_user_role` (`role_id`),
  CONSTRAINT `fk_user_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `user_account` WRITE;
/*!40000 ALTER TABLE `user_account` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_account` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

