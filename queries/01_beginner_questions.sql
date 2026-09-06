USE football_scouting;

-- 1. List all players in a specific position.
SELECT player_id, name, position, current_club_name, market_value_in_eur
FROM players
WHERE position = 'Attack'
ORDER BY market_value_in_eur DESC;

-- 2. Show the 10 most valuable players.
SELECT player_id, name, position, market_value_in_eur
FROM players
ORDER BY market_value_in_eur DESC
LIMIT 10;

-- 3. Show appearances from the most recent 30 days in this sample.
SELECT *
FROM appearances
WHERE date >= (SELECT MAX(date) FROM appearances) - INTERVAL 30 DAY
ORDER BY date DESC;

-- 4. List appearances where the player scored at least one goal.
SELECT player_name, date, competition_id, goals, assists, minutes_played
FROM appearances
WHERE goals > 0
ORDER BY goals DESC, date DESC;

-- 5. Find players born from 2000 onward.
SELECT player_id, name, date_of_birth, position
FROM players
WHERE date_of_birth >= '2000-01-01'
ORDER BY date_of_birth;

-- 6. Find players valued above €50 million.
SELECT name, position, current_club_name, market_value_in_eur
FROM players
WHERE market_value_in_eur > 50000000
ORDER BY market_value_in_eur DESC;

-- 7. Show the 10 most recent transfers.
SELECT player_name, transfer_date, from_club_name, to_club_name, transfer_fee
FROM transfers
ORDER BY transfer_date DESC
LIMIT 10;

-- 8. List midfielders with a recorded market value.
SELECT name, sub_position, current_club_name, market_value_in_eur
FROM players
WHERE position = 'Midfield'
  AND market_value_in_eur IS NOT NULL
ORDER BY market_value_in_eur DESC;

