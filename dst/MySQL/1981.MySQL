CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1981-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1981-01-01','元日'),
('1981-01-15','成人の日'),
('1981-02-11','建国記念の日'),
('1981-04-29','天皇誕生日'),
('1981-05-03','憲法記念日'),
('1981-05-04','振替休日'),
('1981-05-05','こどもの日'),
('1981-09-15','敬老の日'),
('1981-10-10','体育の日'),
('1981-11-03','文化の日'),
('1981-11-23','勤労感謝の日');
COMMIT;
