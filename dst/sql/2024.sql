CREATE TABLE IF NOT EXISTS `holiday` (`date` date NOT NULL, `description` text, PRIMARY KEY (date));
BEGIN;
DELETE FROM `holiday` WHERE `date` LIKE '2024-%';
REPLACE INTO `holiday` (`date`,`description`) VALUES 
('2024-01-01','元日'),
('2024-01-08','成人の日'),
('2024-02-11','建国記念の日'),
('2024-02-12','振替休日'),
('2024-02-23','天皇誕生日'),
('2024-03-20','春分の日(未確定)'),
('2024-04-29','昭和の日'),
('2024-05-03','憲法記念日'),
('2024-05-04','みどりの日'),
('2024-05-05','こどもの日'),
('2024-05-06','振替休日'),
('2024-07-15','海の日'),
('2024-08-11','山の日'),
('2024-08-12','振替休日'),
('2024-09-16','敬老の日'),
('2024-09-22','秋分の日(未確定)'),
('2024-09-23','振替休日'),
('2024-10-14','スポーツの日'),
('2024-11-03','文化の日'),
('2024-11-04','振替休日'),
('2024-11-23','勤労感謝の日');
COMMIT;
