USE football_scouting;

-- 9. What is the total recorded transfer-fee value?
SELECT SUM(transfer_fee) AS total_transfer_fees_eur
FROM transfers
WHERE transfer_fee IS NOT NULL;

-- 10. Which players have the most goals in the sample?
SELECT player_name, SUM(goals) AS total_goals, SUM(assists) AS total_assists,
       SUM(minutes_played) AS total_minutes
FROM appearances
GROUP BY player_id, player_name
ORDER BY total_goals DESC, total_assists DESC
LIMIT 10;

-- 11. Which players have the most assists?
SELECT player_name, SUM(assists) AS total_assists, SUM(goals) AS total_goals
FROM appearances
GROUP BY player_id, player_name
ORDER BY total_assists DESC, total_goals DESC
LIMIT 10;

-- 12. Which players have at least 900 minutes and the best goals-per-90 rate?
SELECT player_name,
       SUM(goals) AS goals,
       SUM(minutes_played) AS minutes,
       ROUND(SUM(goals) * 90.0 / NULLIF(SUM(minutes_played),0), 2) AS goals_per_90
FROM appearances
GROUP BY player_id, player_name
HAVING SUM(minutes_played) >= 900
ORDER BY goals_per_90 DESC
LIMIT 10;

-- 13. What is the average market value by playing position?
SELECT position,
       COUNT(*) AS players,
       ROUND(AVG(market_value_in_eur),0) AS avg_market_value_eur
FROM players
WHERE market_value_in_eur IS NOT NULL
GROUP BY position
ORDER BY avg_market_value_eur DESC;

-- 14. Which destination clubs have received the most transfer activity?
SELECT to_club_name,
       COUNT(*) AS transfers_received,
       ROUND(SUM(transfer_fee),0) AS total_fees_eur,
       ROUND(AVG(NULLIF(transfer_fee,0)),0) AS avg_non_zero_fee_eur
FROM transfers
GROUP BY to_club_name
ORDER BY transfers_received DESC, total_fees_eur DESC
LIMIT 10;

-- 15. Which destination clubs have spent the most?
SELECT to_club_name,
       ROUND(SUM(transfer_fee),0) AS transfer_spend_eur
FROM transfers
GROUP BY to_club_name
ORDER BY transfer_spend_eur DESC
LIMIT 10;

-- 16. Which selling clubs have generated the most recorded transfer income?
SELECT from_club_name,
       ROUND(SUM(transfer_fee),0) AS transfer_income_eur
FROM transfers
GROUP BY from_club_name
ORDER BY transfer_income_eur DESC
LIMIT 10;

-- 17. What is the average order/value analogue: average transfer fee by season?
SELECT transfer_season,
       COUNT(*) AS transfer_count,
       ROUND(AVG(transfer_fee),0) AS avg_transfer_fee_eur,
       ROUND(SUM(transfer_fee),0) AS total_transfer_fees_eur
FROM transfers
GROUP BY transfer_season
ORDER BY transfer_season DESC;

-- 18. Which players have the highest combined goals + assists?
SELECT player_name,
       SUM(goals) AS goals,
       SUM(assists) AS assists,
       SUM(goals + assists) AS goal_contributions
FROM appearances
GROUP BY player_id, player_name
HAVING SUM(goals + assists) > 0
ORDER BY goal_contributions DESC
LIMIT 10;

