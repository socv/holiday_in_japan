CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1979-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1979-01-01','元日'),
('1979-01-15','成人の日'),
('1979-02-11','建国記念の日'),
('1979-02-12','振替休日'),
('1979-04-29','天皇誕生日'),
('1979-04-30','振替休日'),
('1979-05-03','憲法記念日'),
('1979-05-05','こどもの日'),
('1979-09-15','敬老の日'),
('1979-10-10','体育の日'),
('1979-11-03','文化の日'),
('1979-11-23','勤労感謝の日');
COMMIT;
