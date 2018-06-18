CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1992-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1992-01-01','元日'),
('1992-01-15','成人の日'),
('1992-02-11','建国記念の日'),
('1992-04-29','みどりの日'),
('1992-05-03','憲法記念日'),
('1992-05-04','振替休日'),
('1992-05-05','こどもの日'),
('1992-09-15','敬老の日'),
('1992-10-10','体育の日'),
('1992-11-03','文化の日'),
('1992-11-23','勤労感謝の日'),
('1992-12-23','天皇誕生日');
COMMIT;
