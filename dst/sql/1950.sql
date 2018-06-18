CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1950-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1950-01-01','元日'),
('1950-01-15','成人の日'),
('1950-04-29','天皇誕生日'),
('1950-05-03','憲法記念日'),
('1950-05-05','こどもの日'),
('1950-11-03','文化の日'),
('1950-11-23','勤労感謝の日');
COMMIT;
