CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '2050-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('2050-01-01','元日'),
('2050-01-10','成人の日'),
('2050-02-11','建国記念の日'),
('2050-02-23','天皇誕生日'),
('2050-03-21','振替休日'),
('2050-04-29','昭和の日'),
('2050-05-03','憲法記念日'),
('2050-05-04','みどりの日'),
('2050-05-05','こどもの日'),
('2050-07-18','海の日'),
('2050-08-11','山の日'),
('2050-09-19','敬老の日'),
('2050-10-10','スポーツの日'),
('2050-11-03','文化の日'),
('2050-11-23','勤労感謝の日');
COMMIT;
