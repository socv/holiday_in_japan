CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '1998-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('1998-01-01','元日'),
('1998-01-15','成人の日'),
('1998-02-11','建国記念の日'),
('1998-04-29','みどりの日'),
('1998-05-03','憲法記念日'),
('1998-05-04','振替休日'),
('1998-05-05','こどもの日'),
('1998-07-20','海の日'),
('1998-09-15','敬老の日'),
('1998-10-10','体育の日'),
('1998-11-03','文化の日'),
('1998-11-23','勤労感謝の日'),
('1998-12-23','天皇誕生日');
COMMIT;
