CREATE DATABASE IF NOT EXISTS football_scouting;
USE football_scouting;

DROP TABLE IF EXISTS transfers;
DROP TABLE IF EXISTS appearances;
DROP TABLE IF EXISTS players;

CREATE TABLE players (
    player_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    last_season INT,
    current_club_id INT,
    current_club_name VARCHAR(150),
    country_of_citizenship VARCHAR(100),
    date_of_birth DATE,
    position VARCHAR(50),
    sub_position VARCHAR(80),
    foot VARCHAR(20),
    height_in_cm INT,
    market_value_in_eur DECIMAL(15,2),
    highest_market_value_in_eur DECIMAL(15,2),
    contract_expiration_date DATE,
    INDEX idx_players_position (position),
    INDEX idx_players_value (market_value_in_eur),
    INDEX idx_players_club (current_club_id)
);

CREATE TABLE appearances (
    appearance_id VARCHAR(40) PRIMARY KEY,
    game_id INT NOT NULL,
    player_id INT NOT NULL,
    player_club_id INT,
    player_current_club_id INT,
    date DATE NOT NULL,
    player_name VARCHAR(150),
    competition_id VARCHAR(20),
    yellow_cards INT DEFAULT 0,
    red_cards INT DEFAULT 0,
    goals INT DEFAULT 0,
    assists INT DEFAULT 0,
    minutes_played INT DEFAULT 0,
    CONSTRAINT fk_appearances_player
        FOREIGN KEY (player_id) REFERENCES players(player_id),
    INDEX idx_appearances_player_date (player_id, date),
    INDEX idx_appearances_date (date),
    INDEX idx_appearances_club (player_club_id)
);

CREATE TABLE transfers (
    transfer_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    transfer_date DATE NOT NULL,
    transfer_season VARCHAR(20),
    from_club_id INT,
    to_club_id INT,
    from_club_name VARCHAR(150),
    to_club_name VARCHAR(150),
    transfer_fee DECIMAL(15,2),
    market_value_in_eur DECIMAL(15,2),
    player_name VARCHAR(150),
    CONSTRAINT fk_transfers_player
        FOREIGN KEY (player_id) REFERENCES players(player_id),
    INDEX idx_transfers_player_date (player_id, transfer_date),
    INDEX idx_transfers_date (transfer_date),
    INDEX idx_transfers_to_club (to_club_id),
    INDEX idx_transfers_fee (transfer_fee)
);
USE football_scouting;

LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/football-scouting-sql-portfolio-complete/data/sample_players.csv'
INTO TABLE players
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

SELECT COUNT(*) AS total_players
FROM players;

LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/football-scouting-sql-portfolio-complete/data/sample_appearances.csv'
INTO TABLE appearances
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS total_appearances
FROM appearances;

LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/football-scouting-sql-portfolio-complete/data/sample_transfers.csv'
INTO TABLE transfers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS total_transfers
FROM transfers;

SELECT 'players' AS table_name, COUNT(*) AS total_rows FROM players
UNION ALL
SELECT 'appearances', COUNT(*) FROM appearances
UNION ALL
SELECT 'transfers', COUNT(*) FROM transfers;

LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/football-scouting-sql-portfolio-complete/data/sample_transfers.csv'
INTO TABLE transfers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SHOW WARNINGS;

SHOW CREATE TABLE transfers;
SELECT
    ORDINAL_POSITION,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'football_scouting'
  AND TABLE_NAME = 'transfers'
ORDER BY ORDINAL_POSITION;

LOAD DATA LOCAL INFILE 'C:/Users/HP/Downloads/football-scouting-sql-portfolio-complete/data/sample_transfers.csv'
INTO TABLE transfers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @player_id,
    @player_name,
    @transfer_date,
    @transfer_season,
    @from_club_id,
    @to_club_id,
    @from_club_name,
    @to_club_name,
    @transfer_fee,
    @market_value_in_eur
)
SET
    player_id = NULLIF(@player_id, ''),
    transfer_date = NULLIF(@transfer_date, ''),
    transfer_season = NULLIF(@transfer_season, ''),
    from_club_id = NULLIF(@from_club_id, ''),
    to_club_id = NULLIF(@to_club_id, ''),
    from_club_name = NULLIF(@from_club_name, ''),
    to_club_name = NULLIF(@to_club_name, ''),
    transfer_fee = NULLIF(@transfer_fee, ''),
    market_value_in_eur = NULLIF(@market_value_in_eur, '');
    
    SELECT COUNT(*) AS total_transfers
FROM transfers;

SELECT 'players' AS table_name, COUNT(*) AS total_rows FROM players
UNION ALL
SELECT 'appearances', COUNT(*) FROM appearances
UNION ALL
SELECT 'transfers', COUNT(*) FROM transfers;