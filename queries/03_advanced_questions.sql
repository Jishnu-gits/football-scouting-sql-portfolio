USE football_scouting;

-- Q19. Rank players by total goals within each position.
WITH player_output AS (
    SELECT p.player_id, p.name, p.position,
           SUM(a.goals) AS goals,
           SUM(a.assists) AS assists
    FROM players p
    JOIN appearances a ON p.player_id = a.player_id
    GROUP BY p.player_id, p.name, p.position
)
SELECT *,
       DENSE_RANK() OVER (PARTITION BY position ORDER BY goals DESC, assists DESC) AS position_rank
FROM player_output
ORDER BY position, position_rank;

-- Q20. Find players whose current market value is above the average player value.
SELECT player_id, name, position, market_value_in_eur
FROM players
WHERE market_value_in_eur >
      (SELECT AVG(market_value_in_eur) FROM players WHERE market_value_in_eur IS NOT NULL)
ORDER BY market_value_in_eur DESC;

-- Q21. Identify repeat movers: players with more than one transfer in this subset.
SELECT player_id, player_name,
       COUNT(*) AS transfer_count,
       ROUND(SUM(transfer_fee),0) AS total_transfer_fees_eur
FROM transfers
GROUP BY player_id, player_name
HAVING COUNT(*) > 1
ORDER BY transfer_count DESC, total_transfer_fees_eur DESC;

-- Q22. Compare each player's current value with their historical peak value.
SELECT player_id, name, market_value_in_eur, highest_market_value_in_eur,
       market_value_in_eur - highest_market_value_in_eur AS gap_to_peak_eur,
       ROUND(100 * market_value_in_eur / NULLIF(highest_market_value_in_eur,0), 1) AS pct_of_peak
FROM players
WHERE highest_market_value_in_eur IS NOT NULL
ORDER BY pct_of_peak DESC;

-- Q23. Use LAG to compare each player's transfer fee with their previous transfer.
WITH ordered_transfers AS (
    SELECT player_id, player_name, transfer_date, from_club_name, to_club_name, transfer_fee,
           LAG(transfer_fee) OVER (PARTITION BY player_id ORDER BY transfer_date) AS previous_fee
    FROM transfers
)
SELECT *,
       transfer_fee - previous_fee AS fee_change_eur
FROM ordered_transfers
ORDER BY player_id, transfer_date;

-- Q24. Rank the top 3 players by market value within each position.
WITH ranked AS (
    SELECT player_id, name, position, market_value_in_eur,
           DENSE_RANK() OVER (PARTITION BY position ORDER BY market_value_in_eur DESC) AS value_rank
    FROM players
    WHERE market_value_in_eur IS NOT NULL
)
SELECT *
FROM ranked
WHERE value_rank <= 3
ORDER BY position, value_rank;

-- Q25. Demo scouting score combining attacking output, minutes and discipline.
WITH metrics AS (
    SELECT player_id,
           SUM(goals) AS goals,
           SUM(assists) AS assists,
           SUM(minutes_played) AS minutes,
           SUM(yellow_cards) AS yellows,
           SUM(red_cards) AS reds
    FROM appearances
    GROUP BY player_id
)
SELECT p.name, p.position, p.market_value_in_eur,
       m.goals, m.assists, m.minutes, m.yellows, m.reds,
       ROUND(
         (m.goals * 5) +
         (m.assists * 3) +
         (m.minutes / 90.0) -
         (m.yellows * 0.5) -
         (m.reds * 2), 2
       ) AS scouting_score
FROM metrics m
JOIN players p ON p.player_id = m.player_id
ORDER BY scouting_score DESC
LIMIT 20;

-- Q26. Potential value-efficiency screen: high output relative to market value.
WITH metrics AS (
    SELECT player_id,
           SUM(goals) AS goals,
           SUM(assists) AS assists,
           SUM(minutes_played) AS minutes
    FROM appearances
    GROUP BY player_id
)
SELECT p.name, p.position, p.market_value_in_eur,
       m.goals, m.assists, m.minutes,
       ROUND((m.goals + m.assists) * 1000000.0 / NULLIF(p.market_value_in_eur,0), 2)
          AS contributions_per_million_eur
FROM metrics m
JOIN players p ON p.player_id = m.player_id
WHERE m.minutes >= 900
  AND p.market_value_in_eur > 0
ORDER BY contributions_per_million_eur DESC
LIMIT 20;

-- Q27. Rank destination clubs by net transfer spending (incoming fees paid minus outgoing fees received).
WITH spending AS (
    SELECT to_club_name AS club_name, SUM(transfer_fee) AS amount
    FROM transfers GROUP BY to_club_name
),
income AS (
    SELECT from_club_name AS club_name, SUM(transfer_fee) AS amount
    FROM transfers GROUP BY from_club_name
)
SELECT COALESCE(s.club_name, i.club_name) AS club_name,
       COALESCE(s.amount,0) - COALESCE(i.amount,0) AS net_spend_eur
FROM spending s
LEFT JOIN income i ON s.club_name = i.club_name
UNION
SELECT i.club_name,
       COALESCE(s.amount,0) - COALESCE(i.amount,0)
FROM income i
LEFT JOIN spending s ON s.club_name = i.club_name
WHERE s.club_name IS NULL
ORDER BY net_spend_eur DESC;

-- Q28. Monthly transfer-fee trend.
SELECT DATE_FORMAT(transfer_date,'%Y-%m') AS transfer_month,
       COUNT(*) AS transfer_count,
       ROUND(SUM(transfer_fee),0) AS total_fees_eur,
       ROUND(AVG(NULLIF(transfer_fee,0)),0) AS avg_non_zero_fee_eur
FROM transfers
GROUP BY DATE_FORMAT(transfer_date,'%Y-%m')
ORDER BY transfer_month;

-- Q29. Create a dashboard-ready monthly summary view.
DROP VIEW IF EXISTS monthly_transfer_summary;
CREATE VIEW monthly_transfer_summary AS
SELECT DATE_FORMAT(transfer_date,'%Y-%m') AS transfer_month,
       COUNT(*) AS transfer_count,
       SUM(transfer_fee) AS total_transfer_fees_eur,
       AVG(NULLIF(transfer_fee,0)) AS avg_non_zero_transfer_fee_eur
FROM transfers
GROUP BY DATE_FORMAT(transfer_date,'%Y-%m');

-- Q30. Read the dashboard-ready view.
SELECT * FROM monthly_transfer_summary
ORDER BY transfer_month;

-- Q31. Stored procedure: return a player's profile, performance and transfer history.
DROP PROCEDURE IF EXISTS get_player_scouting_report;
DELIMITER //
CREATE PROCEDURE get_player_scouting_report(IN p_player_id INT)
BEGIN
    SELECT player_id, name, position, sub_position, current_club_name,
           country_of_citizenship, market_value_in_eur, highest_market_value_in_eur
    FROM players
    WHERE player_id = p_player_id;

    SELECT player_name,
           SUM(goals) AS goals,
           SUM(assists) AS assists,
           SUM(minutes_played) AS minutes,
           SUM(yellow_cards) AS yellow_cards,
           SUM(red_cards) AS red_cards
    FROM appearances
    WHERE player_id = p_player_id
    GROUP BY player_id, player_name;

    SELECT transfer_date, from_club_name, to_club_name, transfer_fee, market_value_in_eur
    FROM transfers
    WHERE player_id = p_player_id
    ORDER BY transfer_date DESC;
END //
DELIMITER ;

-- Example: replace with any real player_id from the players table.
-- CALL get_player_scouting_report(342229);
