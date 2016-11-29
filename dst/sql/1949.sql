CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1949-01-01','元日'),
('1949-01-15','成人の日'),
('1949-04-29','天皇誕生日'),
('1949-05-03','憲法記念日'),
('1949-05-05','こどもの日'),
('1949-11-03','文化の日'),
('1949-11-23','勤労感謝の日');
