CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1988-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1988-01-01','元日'),
('1988-01-15','成人の日'),
('1988-02-11','建国記念の日'),
('1988-03-21','振替休日'),
('1988-04-29','天皇誕生日'),
('1988-05-03','憲法記念日'),
('1988-05-04','国民の休日'),
('1988-05-05','こどもの日'),
('1988-09-15','敬老の日'),
('1988-10-10','体育の日'),
('1988-11-03','文化の日'),
('1988-11-23','勤労感謝の日');
COMMIT;
