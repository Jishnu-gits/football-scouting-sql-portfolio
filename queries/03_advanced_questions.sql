USE football_scouting;



-- Q19. Find players whose current market value is above the average player value.
SELECT player_id, name, position, market_value_in_eur
FROM players
WHERE market_value_in_eur >
      (SELECT AVG(market_value_in_eur) FROM players WHERE market_value_in_eur IS NOT NULL)
ORDER BY market_value_in_eur DESC;

-- Q20. Identify repeat movers: players with more than one transfer in this subset.
SELECT player_id, player_name,
       COUNT(*) AS transfer_count,
       ROUND(SUM(transfer_fee),0) AS total_transfer_fees_eur
FROM transfers
GROUP BY player_id, player_name
HAVING COUNT(*) > 1
ORDER BY transfer_count DESC, total_transfer_fees_eur DESC;

-- Q21. Compare each player's current value with their historical peak value.
SELECT player_id, name, market_value_in_eur, highest_market_value_in_eur,
       market_value_in_eur - highest_market_value_in_eur AS gap_to_peak_eur,
       ROUND(100 * market_value_in_eur / NULLIF(highest_market_value_in_eur,0), 1) AS pct_of_peak
FROM players
WHERE highest_market_value_in_eur IS NOT NULL
ORDER BY pct_of_peak DESC;


-- Q22. Monthly transfer-fee trend.
SELECT DATE_FORMAT(transfer_date,'%Y-%m') AS transfer_month,
       COUNT(*) AS transfer_count,
       ROUND(SUM(transfer_fee),0) AS total_fees_eur,
       ROUND(AVG(NULLIF(transfer_fee,0)),0) AS avg_non_zero_fee_eur
FROM transfers
GROUP BY DATE_FORMAT(transfer_date,'%Y-%m')
ORDER BY transfer_month;

-- Q22. Create a dashboard-ready monthly summary view.
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
