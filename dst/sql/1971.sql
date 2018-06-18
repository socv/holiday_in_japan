CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1971-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1971-01-01','元日'),
('1971-01-15','成人の日'),
('1971-02-11','建国記念の日'),
('1971-04-29','天皇誕生日'),
('1971-05-03','憲法記念日'),
('1971-05-05','こどもの日'),
('1971-09-15','敬老の日'),
('1971-10-10','体育の日'),
('1971-11-03','文化の日'),
('1971-11-23','勤労感謝の日');
COMMIT;
