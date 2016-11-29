CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1955-01-01','元日'),
('1955-01-15','成人の日'),
('1955-04-29','天皇誕生日'),
('1955-05-03','憲法記念日'),
('1955-05-05','こどもの日'),
('1955-11-03','文化の日'),
('1955-11-23','勤労感謝の日');
