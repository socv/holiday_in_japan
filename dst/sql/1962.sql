CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1962-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1962-01-01','元日'),
('1962-01-15','成人の日'),
('1962-04-29','天皇誕生日'),
('1962-05-03','憲法記念日'),
('1962-05-05','こどもの日'),
('1962-11-03','文化の日'),
('1962-11-23','勤労感謝の日');
COMMIT;
