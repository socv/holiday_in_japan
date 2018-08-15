CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1982-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1982-01-01','元日'),
('1982-01-15','成人の日'),
('1982-02-11','建国記念の日'),
('1982-03-22','振替休日'),
('1982-04-29','天皇誕生日'),
('1982-05-03','憲法記念日'),
('1982-05-05','こどもの日'),
('1982-09-15','敬老の日'),
('1982-10-10','体育の日'),
('1982-10-11','振替休日'),
('1982-11-03','文化の日'),
('1982-11-23','勤労感謝の日');
COMMIT;
