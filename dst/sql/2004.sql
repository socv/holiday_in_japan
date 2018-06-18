CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '2004-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('2004-01-01','元日'),
('2004-01-12','成人の日'),
('2004-02-11','建国記念の日'),
('2004-03-20','春分の日'),
('2004-04-29','みどりの日'),
('2004-05-03','憲法記念日'),
('2004-05-04','国民の休日'),
('2004-05-05','こどもの日'),
('2004-07-19','海の日'),
('2004-09-20','敬老の日'),
('2004-09-23','秋分の日'),
('2004-10-11','体育の日'),
('2004-11-03','文化の日'),
('2004-11-23','勤労感謝の日'),
('2004-12-23','天皇誕生日');
COMMIT;
