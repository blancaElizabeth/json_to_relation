CREATE DATABASE IF NOT EXISTS Edx;
CREATE DATABASE IF NOT EXISTS EdxPrivate;
USE Edx;
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
DROP TABLE IF EXISTS EdxTrackEvent, Answer, InputState, CorrectMap, State, Account, EdxPrivate.Account, LoadInfo;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS Answer (
    answer_id VARCHAR(40) NOT NULL PRIMARY KEY,
    problem_id TEXT NOT NULL,
    answer TEXT NOT NULL,
    course_id TEXT NOT NULL
    );
CREATE TABLE IF NOT EXISTS CorrectMap (
    correct_map_id VARCHAR(40) NOT NULL PRIMARY KEY,
    answer_identifier TEXT NOT NULL,
    correctness TINYTEXT NOT NULL,
    npoints INT NOT NULL,
    msg TEXT NOT NULL,
    hint TEXT NOT NULL,
    hintmode TINYTEXT NOT NULL,
    queuestate TEXT NOT NULL
    );
CREATE TABLE IF NOT EXISTS InputState (
    input_state_id VARCHAR(40) NOT NULL PRIMARY KEY,
    problem_id TEXT NOT NULL,
    state TEXT NOT NULL
    );
CREATE TABLE IF NOT EXISTS State (
    state_id VARCHAR(40) NOT NULL PRIMARY KEY,
    seed TINYINT NOT NULL,
    done TINYTEXT NOT NULL,
    problem_id TEXT NOT NULL,
    student_answer VARCHAR(40) NOT NULL,
    correct_map VARCHAR(40) NOT NULL,
    input_state VARCHAR(40) NOT NULL,
    FOREIGN KEY(student_answer) REFERENCES Answer(answer_id) ON DELETE CASCADE,
    FOREIGN KEY(correct_map) REFERENCES CorrectMap(correct_map_id) ON DELETE CASCADE,
    FOREIGN KEY(input_state) REFERENCES InputState(input_state_id) ON DELETE CASCADE
    );
CREATE TABLE IF NOT EXISTS Account (
    account_id VARCHAR(40) NOT NULL PRIMARY KEY,
    screen_name TEXT NOT NULL,
    name TEXT NOT NULL,
    anon_screen_name TEXT NOT NULL,
    mailing_address TEXT NOT NULL,
    zipcode TINYTEXT NOT NULL,
    country TINYTEXT NOT NULL,
    gender TINYTEXT NOT NULL,
    year_of_birth TINYINT NOT NULL,
    level_of_education TINYTEXT NOT NULL,
    goals TEXT NOT NULL,
    honor_code TINYINT NOT NULL,
    terms_of_service TINYINT NOT NULL,
    course_id TEXT NOT NULL,
    enrollment_action TINYTEXT NOT NULL,
    email TEXT NOT NULL,
    receive_emails TINYTEXT NOT NULL
    );
CREATE TABLE IF NOT EXISTS EdxPrivate.Account (
    account_id VARCHAR(40) NOT NULL PRIMARY KEY,
    screen_name TEXT NOT NULL,
    name TEXT NOT NULL,
    anon_screen_name TEXT NOT NULL,
    mailing_address TEXT NOT NULL,
    zipcode TINYTEXT NOT NULL,
    country TINYTEXT NOT NULL,
    gender TINYTEXT NOT NULL,
    year_of_birth TINYINT NOT NULL,
    level_of_education TINYTEXT NOT NULL,
    goals TEXT NOT NULL,
    honor_code TINYINT NOT NULL,
    terms_of_service TINYINT NOT NULL,
    course_id TEXT NOT NULL,
    enrollment_action TINYTEXT NOT NULL,
    email TEXT NOT NULL,
    receive_emails TINYTEXT NOT NULL
    );
CREATE TABLE IF NOT EXISTS LoadInfo (
    load_info_id VARCHAR(40) NOT NULL PRIMARY KEY,
    load_date_time DATETIME NOT NULL,
    load_file TEXT NOT NULL
    );
CREATE TABLE IF NOT EXISTS EdxTrackEvent (
    _id VARCHAR(40) NOT NULL PRIMARY KEY,
    event_id VARCHAR(40) NOT NULL,
    agent TEXT NOT NULL,
    event_source TINYTEXT NOT NULL,
    event_type TEXT NOT NULL,
    ip TINYTEXT NOT NULL,
    page TEXT NOT NULL,
    session TEXT NOT NULL,
    time DATETIME NOT NULL,
    anon_screen_name TEXT NOT NULL,
    downtime_for DATETIME NOT NULL,
    student_id TEXT NOT NULL,
    instructor_id TEXT NOT NULL,
    course_id TEXT NOT NULL,
    sequence_id TEXT NOT NULL,
    goto_from INT NOT NULL,
    goto_dest INT NOT NULL,
    problem_id TEXT NOT NULL,
    problem_choice TEXT NOT NULL,
    question_location TEXT NOT NULL,
    submission_id TEXT NOT NULL,
    attempts INT NOT NULL,
    long_answer TEXT NOT NULL,
    student_file TEXT NOT NULL,
    can_upload_file TINYTEXT NOT NULL,
    feedback TEXT NOT NULL,
    feedback_response_selected TINYINT NOT NULL,
    transcript_id TEXT NOT NULL,
    transcript_code TINYTEXT NOT NULL,
    rubric_selection INT NOT NULL,
    rubric_category INT NOT NULL,
    video_id TEXT NOT NULL,
    video_code TEXT NOT NULL,
    video_current_time TINYTEXT NOT NULL,
    video_speed TINYTEXT NOT NULL,
    video_old_time TINYTEXT NOT NULL,
    video_new_time TINYTEXT NOT NULL,
    video_seek_type TINYTEXT NOT NULL,
    video_new_speed TINYTEXT NOT NULL,
    video_old_speed TINYTEXT NOT NULL,
    book_interaction_type TINYTEXT NOT NULL,
    success TINYTEXT NOT NULL,
    answer_id TEXT NOT NULL,
    hint TEXT NOT NULL,
    hintmode TINYTEXT NOT NULL,
    correctness TINYTEXT NOT NULL,
    msg TEXT NOT NULL,
    npoints TINYINT NOT NULL,
    queuestate TEXT NOT NULL,
    orig_score INT NOT NULL,
    new_score INT NOT NULL,
    orig_total INT NOT NULL,
    new_total INT NOT NULL,
    event_name TINYTEXT NOT NULL,
    group_user TINYTEXT NOT NULL,
    group_action TINYTEXT NOT NULL,
    position INT NOT NULL,
    badly_formatted TEXT NOT NULL,
    correctMap_fk VARCHAR(40) NOT NULL,
    answer_fk VARCHAR(40) NOT NULL,
    state_fk VARCHAR(40) NOT NULL,
    load_info_fk INT NOT NULL,
    FOREIGN KEY(correctMap_fk) REFERENCES CorrectMap(correct_map_id) ON DELETE CASCADE,
    FOREIGN KEY(answer_fk) REFERENCES Answer(answer_id) ON DELETE CASCADE,
    FOREIGN KEY(state_fk) REFERENCES State(state_id) ON DELETE CASCADE,
    FOREIGN KEY(load_info_fk) REFERENCES LoadInfo(load_info_id) ON DELETE CASCADE
    );
LOCK TABLES `EdxTrackEvent` WRITE, `State` WRITE, `InputState` WRITE, `Answer` WRITE, `CorrectMap` WRITE, `LoadInfo` WRITE, `Account` WRITE;
/*!40000 ALTER TABLE `EdxTrackEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `State` DISABLE KEYS */;
/*!40000 ALTER TABLE `InputState` DISABLE KEYS */;
/*!40000 ALTER TABLE `Answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `CorrectMap` DISABLE KEYS */;
/*!40000 ALTER TABLE `LoadInfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `Account` DISABLE KEYS */;
INSERT INTO LoadInfo (load_info_id,load_date_time,load_file) VALUES 
    ('1a349d06_cae6_4674_891d_232469686f6f','2013112718511385607065','file:///home/paepcke/EclipseWorkspaces/json_to_relation/json_to_relation/test/data/problem_checkEventFldOnly.json');
INSERT INTO Answer (answer_id,problem_id,answer,course_id) VALUES 
    ('59ba35ac_4f4e_4666_ab8c_37cdada48fb5','i4x-Medicine-HRP258-problem-4cd4e0bb39af4d36ba54b1a677e350b4_4_1','choice_1','Medicine-HRP258'),
    ('344fa0f5_1a96_48cc_99c7_56c3d452e99b','i4x-Medicine-HRP258-problem-4cd4e0bb39af4d36ba54b1a677e350b4_3_1','choice_4','Medicine-HRP258'),
    ('4882050e_e245_4556_a678_d01543f7297a','i4x-Medicine-HRP258-problem-4cd4e0bb39af4d36ba54b1a677e350b4_2_1','choice_2','Medicine-HRP258');
INSERT INTO InputState (input_state_id,problem_id,state) VALUES 
    ('3d3e29b1_b786_4269_9eba_e4b0fdbc6320','i4x-Medicine-HRP258-problem-4cd4e0bb39af4d36ba54b1a677e350b4_4_1',''),
    ('630a1c49_d6a7_4725_b32b_cde475fb39c1','i4x-Medicine-HRP258-problem-4cd4e0bb39af4d36ba54b1a677e350b4_3_1',''),
    ('52e270ca_7a8e_4af2_b82f_da71fe166d3e','i4x-Medicine-HRP258-problem-4cd4e0bb39af4d36ba54b1a677e350b4_2_1','');
INSERT INTO State (state_id,seed,done,problem_id,student_answer,correct_map,input_state) VALUES 
    ('5aa17de2_9793_4399_8ac0_249297e631f9',1,'None','','','','3d3e29b1_b786_4269_9eba_e4b0fdbc6320'),
    ('90be3834_1fb5_4d76_ba03_27f0cffa092f',1,'None','','','','630a1c49_d6a7_4725_b32b_cde475fb39c1'),
    ('be99ae69_a65d_4235_8903_cd73ccadfa21',1,'None','','','','52e270ca_7a8e_4af2_b82f_da71fe166d3e');
INSERT INTO EdxTrackEvent (_id,event_id,agent,event_source,event_type,ip,page,session,time,anon_screen_name,downtime_for,student_id,instructor_id,course_id,sequence_id,goto_from,goto_dest,problem_id,problem_choice,question_location,submission_id,attempts,long_answer,student_file,can_upload_file,feedback,feedback_response_selected,transcript_id,transcript_code,rubric_selection,rubric_category,video_id,video_code,video_current_time,video_speed,video_old_time,video_new_time,video_seek_type,video_new_speed,video_old_speed,book_interaction_type,success,answer_id,hint,hintmode,correctness,msg,npoints,queuestate,orig_score,new_score,orig_total,new_total,event_name,group_user,group_action,position,badly_formatted,correctMap_fk,answer_fk,state_fk,load_info_fk) VALUES 
    ('24958f8d_8771_4870_b24c_b7f343245483','ac103519_de9e_47e6_8f56_9682d047224e','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36','server','save_problem_check','190.23.170.224','x_module','','2013-06-18T03:48:38.240193+00:00','a3b412c81b5ac4a3dcc911655c225a37675ce1c337acba69ee2733d4','0:00:00','','','Medicine-HRP258','',-1,-1,'i4x-Medicine-HRP258-problem-4cd4e0bb39af4d36ba54b1a677e350b4_4_1','','','',-1,'','','','',-1,'','',-1,-1,'','','','','','','','','','','correct','','','','','',-1,'',-1,-1,-1,-1,'','','',-1,'','','59ba35ac_4f4e_4666_ab8c_37cdada48fb5','5aa17de2_9793_4399_8ac0_249297e631f9','1a349d06_cae6_4674_891d_232469686f6f'),
    ('11b3a9eb_90f5_4b99_985d_608bb2a3558d','ac103519_de9e_47e6_8f56_9682d047224e','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36','server','save_problem_check','190.23.170.224','x_module','','2013-06-18T03:48:38.240193+00:00','a3b412c81b5ac4a3dcc911655c225a37675ce1c337acba69ee2733d4','0:00:00','','','Medicine-HRP258','',-1,-1,'i4x-Medicine-HRP258-problem-4cd4e0bb39af4d36ba54b1a677e350b4_3_1','','','',-1,'','','','',-1,'','',-1,-1,'','','','','','','','','','','correct','','','','','',-1,'',-1,-1,-1,-1,'','','',-1,'','','344fa0f5_1a96_48cc_99c7_56c3d452e99b','90be3834_1fb5_4d76_ba03_27f0cffa092f','1a349d06_cae6_4674_891d_232469686f6f'),
    ('64f68d00_15dc_4285_ae61_1dde061cd080','ac103519_de9e_47e6_8f56_9682d047224e','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36','server','save_problem_check','190.23.170.224','x_module','','2013-06-18T03:48:38.240193+00:00','a3b412c81b5ac4a3dcc911655c225a37675ce1c337acba69ee2733d4','0:00:00','','','Medicine-HRP258','',-1,-1,'i4x-Medicine-HRP258-problem-4cd4e0bb39af4d36ba54b1a677e350b4_2_1','','','',-1,'','','','',-1,'','',-1,-1,'','','','','','','','','','','correct','','','','','',-1,'',-1,-1,-1,-1,'','','',-1,'','','4882050e_e245_4556_a678_d01543f7297a','be99ae69_a65d_4235_8903_cd73ccadfa21','1a349d06_cae6_4674_891d_232469686f6f');
/*!40000 ALTER TABLE `EdxTrackEvent` ENABLE KEYS */;
/*!40000 ALTER TABLE `State` ENABLE KEYS */;
/*!40000 ALTER TABLE `InputState` ENABLE KEYS */;
/*!40000 ALTER TABLE `Answer` ENABLE KEYS */;
/*!40000 ALTER TABLE `CorrectMap` ENABLE KEYS */;
/*!40000 ALTER TABLE `LoadInfo` ENABLE KEYS */;
/*!40000 ALTER TABLE `Account` ENABLE KEYS */;
UNLOCK TABLES;
INSERT INTO EdxPrivate.Account (account_id,screen_name,name,anon_screen_name,mailing_address,zipcode,country,gender,year_of_birth,level_of_education,goals,honor_code,terms_of_service,course_id,enrollment_action,email,receive_emails) SELECT account_id,screen_name,name,anon_screen_name,mailing_address,zipcode,country,gender,year_of_birth,level_of_education,goals,honor_code,terms_of_service,course_id,enrollment_action,email,receive_emails FROM Edx.Account;
DROP TABLE Edx.Account;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
