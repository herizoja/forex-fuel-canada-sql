CREATE VIEW monthly_avg_forex AS
SELECT
    DATE_TRUNC('month', date) AS month,
    ROUND(AVG(usd_cad), 4) AS avg_usd_cad,
    ROUND(AVG(cny_cad), 4) AS avg_cny_cad
FROM forex_rates
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;

SELECT * FROM monthly_avg_forex ORDER BY month LIMIT 5;

CREATE VIEW fuel_forex_combined AS
SELECT
    fp.month,
    fp.province,
    fp.avg_price,
    maf.avg_usd_cad,
    maf.avg_cny_cad
FROM fuel_prices fp
JOIN monthly_avg_forex maf ON fp.month = maf.month
ORDER BY fp.month, fp.province;

SELECT * FROM fuel_forex_combined
ORDER BY month, province
LIMIT 10;

SELECT 
    province, 
    ROUND(AVG(avg_price), 2) AS avg_fuel_price
FROM fuel_forex_combined
GROUP BY province
ORDER BY avg_fuel_price DESC;

SELECT 
    month, 
    ROUND(AVG(avg_price), 2) AS avg_fuel_price,
    ROUND(AVG(avg_usd_cad), 4) AS avg_usd_cad
FROM fuel_forex_combined
GROUP BY month
ORDER BY month;

SELECT 
    province,
    CORR(avg_price, avg_usd_cad) AS corr_usd,
    CORR(avg_price, avg_cny_cad) AS corr_cny
FROM fuel_forex_combined
GROUP BY province
ORDER BY corr_usd DESC;



