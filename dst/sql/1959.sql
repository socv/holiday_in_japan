CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1959-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1959-01-01','元日'),
('1959-01-15','成人の日'),
('1959-04-10','皇太子・明仁親王の結婚の儀'),
('1959-04-29','天皇誕生日'),
('1959-05-03','憲法記念日'),
('1959-05-05','こどもの日'),
('1959-11-03','文化の日'),
('1959-11-23','勤労感謝の日');
COMMIT;
