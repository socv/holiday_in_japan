CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1974-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1974-01-01','元日'),
('1974-01-15','成人の日'),
('1974-02-11','建国記念の日'),
('1974-04-29','天皇誕生日'),
('1974-05-03','憲法記念日'),
('1974-05-05','こどもの日'),
('1974-05-06','振替休日'),
('1974-09-15','敬老の日'),
('1974-09-16','振替休日'),
('1974-10-10','体育の日'),
('1974-11-03','文化の日'),
('1974-11-04','振替休日'),
('1974-11-23','勤労感謝の日');
COMMIT;
