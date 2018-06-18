CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1995-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1995-01-01','元日'),
('1995-01-02','振替休日'),
('1995-01-15','成人の日'),
('1995-01-16','振替休日'),
('1995-02-11','建国記念の日'),
('1995-04-29','みどりの日'),
('1995-05-03','憲法記念日'),
('1995-05-04','国民の休日'),
('1995-05-05','こどもの日'),
('1995-09-15','敬老の日'),
('1995-10-10','体育の日'),
('1995-11-03','文化の日'),
('1995-11-23','勤労感謝の日'),
('1995-12-23','天皇誕生日');
COMMIT;
