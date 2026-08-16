create database medgini;
use medgini;

SELECT * FROM MEDGINI_SQL_READY_DATASET;
alter TABLE MEDGINI_SQL_READY_DATASET RENAME TO MEDGINI;
SELECT * FROM MEDGINI;
ALTER TABLE MEDGINI
CHANGE COLUMN `ï»¿Survey_ID` Survey_ID INT PRIMARY KEY;
-- 1.Find the total number of survey responses collected.
-- 2.Display all distinct cities where surveys were conducted.
-- 3.Find the number of medical stores covered in the survey.
-- 4.Display all distinct brands requested by customers.
-- 5.Find the total number of customers from each city.

SELECT COUNT(*) FROM MEDGINI;
SELECT DISTINCT CITY FROM MEDGINI;
SELECT DISTINCT OUTLET FROM MEDGINI;
SELECT DISTINCT REQUESTED_BRAND FROM MEDGINI;
SELECT CITY, COUNT(SURVEY_ID) FROM MEDGINI GROUP BY CITY;


-- 6. Count the number of male, female, and other customers.
-- 7. Find the number of customers in each age group.
-- 8. Count the number of surveys conducted at each outlet.
-- 9. Find the total quantity of cough syrup bottles sold.
-- 10. Find the average quantity purchased per customer.

SELECT GENDER, COUNT(GENDER) FROM MEDGINI GROUP BY GENDER;
SELECT AGE_GROUP, COUNT(AGE_GROUP ) FROM MEDGINI GROUP BY AGE_GROUP ORDER BY 1 ;
SELECT OUTLET, COUNT(OUTLET) FROM MEDGINI GROUP BY 1;
SELECT SUM(QUANTITY) FROM MEDGINI ;
SELECT SUM(QUANTITY)/COUNT(QUANTITY) FROM MEDGINI;
-- OR 
SELECT AVG(QUANTITY) FROM MEDGINI;


-- 11. List the top 5 most requested brands.
-- 12. Find the number of customers requesting Corex.
-- 13. Find how many customers purchased each final brand.
-- 14. Display all customers whose prescription status is 'OTC (No Prescription)'.
-- 15. Find the percentage of OTC purchases.

SELECT REQUESTED_BRAND, COUNT(REQUESTED_BRAND) FROM MEDGINI GROUP BY REQUESTED_BRAND ORDER BY 2 DESC LIMIT 5;
SELECT COUNT(REQUESTED_BRAND) FROM MEDGINI WHERE REQUESTED_BRAND='COREX';
SELECT FINAL_BRAND, COUNT(FINAL_BRAND) FROM MEDGINI GROUP BY FINAL_BRAND ORDER BY 2 DESC ;
SELECT * FROM MEDGINI WHERE PRESCRIPTION = 'OTC (No PRESCRIPTION)';
SELECT ROUND(
COUNT(CASE WHEN PRESCRIPTION = 'OTC (No PRESCRIPTION)' THEN 1 END)*100.00 / COUNT(*),2
)AS OTC_PERCENTAGE
 FROM MEDGINI;


-- 16. Count customers influenced by Doctor, Chemist, Customer Preference, and Friend / Relative.
-- 17. Find how many times chemists suggested an alternative medicine.
-- 18. Find how many customers accepted the suggested alternative.
-- 19. Display the frequency of each purchase reason.
-- 20. Find the most commonly reported symptom.

SELECT INFLUENCED_BY, COUNT(INFLUENCED_BY) FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC; 
SELECT COUNT(*)AS SUGGESTIONS FROM MEDGINI WHERE ALTERNATIVE_SUGGESTED='YES';
SELECT COUNT(*)AS ACCEPTED FROM MEDGINI WHERE ALTERNATIVE_ACCEPTED='YES';
SELECT PURCHASE_REASON, COUNT(PURCHASE_REASON)AS FREQUENCY FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC;
SELECT SYMPTOM , COUNT(SYMPTOM) FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC LIMIT 1;


-- 21. Count repeat purchases and non-repeat purchases.
-- 22. Find how many customers specifically requested Corex.
-- 23. Display the top 10 most common remarks recorded.
-- 24. Find the number of surveys conducted in each city ordered from highest to lowest.
-- 25. Find the outlet with the highest number of surveys.

SELECT COUNT(REPEAT_PURCHASE) FROM MEDGINI WHERE REPEAT_PURCHASE = 'YES'; SELECT COUNT(REPEAT_PURCHASE) FROM MEDGINI WHERE REPEAT_PURCHASE = 'NO';
SELECT COUNT(COREX_REQUEST) FROM MEDGINI ;
SELECT REMARKS, COUNT(REMARKS) FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC LIMIT 10;
SELECT CITY, COUNT(SURVEY_ID)AS SURVEYSUM FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC;
SELECT OUTLET, COUNT(OUTLET) FROM MEDGINI group by 1 ORDER BY 2 DESC LIMIT 1;


-- 26. Find the most requested brand in each city.
-- 27. Find the top 3 outlets with the highest number of survey responses.
-- 28. Calculate the market share (%) of each requested brand.
-- 29. Find the substitution rate (%) for every outlet.
-- 30. Calculate the percentage of Prescription vs OTC purchases for each city.

 SELECT CITY, REQUESTED_BRAND, COUNT(REQUESTED_BRAND) FROM MEDGINI GROUP BY 1,2 ORDER BY 3 DESC;
 WITH Brand_Count AS (
    SELECT
        City,
        Requested_Brand,
        COUNT(*) AS Total_Requests,
        DENSE_RANK() OVER (
            PARTITION BY City
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM Medgini
    GROUP BY City, Requested_Brand
)
SELECT
    City,
    Requested_Brand,
    Total_Requests
FROM Brand_Count
WHERE rnk = 1;

SELECT OUTLET, COUNT(OUTLET) FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC LIMIT 3;

SELECT REQUESTED_BRAND, ROUND(
COUNT(REQUESTED_BRAND)*100.00 / (SELECT COUNT(*) FROM MEDGINI),2
)AS SHARE_PERCENTAGE
 FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC;
 
SELECT OUTLET, ROUND(
COUNT(CASE WHEN ALTERNATIVE_ACCEPTED ='YES'THEN 1 END)*100/COUNT(*),2
)AS SUBSTITUTION_RATE FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC;
 
 SELECT CITY, ROUND(
 COUNT(CASE WHEN PRESCRIPTION = 'VALID PRESCRIPTION AVAILABLE' THEN 1 END)*100/COUNT(*),2
 ) AS PRESCRIPTION_PERCENT,
 ROUND(
COUNT(CASE WHEN PRESCRIPTION = 'OTC (No PRESCRIPTION)' THEN 1 END)*100.00 / COUNT(*),2
)AS OTC_PERCENTAGE
 FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC;
 
 
 -- 31. Find which city has the highest doctor-influenced purchases.
-- 32. Find which outlet has the highest chemist influence.
-- 33. Calculate the average quantity purchased for each age group.
-- 34. Calculate the average quantity purchased by gender.
-- 35. Find which customer category purchased the highest average quantity.
 
SELECT CITY, COUNT(INFLUENCED_BY) FROM MEDGINI WHERE INFLUENCED_BY = 'DOCTOR'  GROUP BY 1 ORDER BY 2 DESC LIMIT 1;
SELECT OUTLET, COUNT(INFLUENCED_BY) FROM MEDGINI WHERE INFLUENCED_BY = 'CHEMIST'  GROUP BY 1 ORDER BY 2 DESC LIMIT 1;

SELECT AGE_GROUP, SUM(QUANTITY)/COUNT(*)AS AVERAGE_QTY FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC;
SELECT GENDER, SUM(QUANTITY)/COUNT(*)AS AVERAGE_QTY FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC;
SELECT CATEGORY, SUM(QUANTITY)/COUNT(*)AS AVERAGE_QTY FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC LIMIT 2;


-- 36. Display brands that were requested more than 40 times.
-- 37. Find outlets where OTC purchases are greater than Prescription purchases.
-- 38. Find the most common purchase reason in each city.
-- 39. Calculate the acceptance percentage of chemist-suggested alternatives.
-- 40. Find all records where the Requested_Brand is different from the Final_Brand.
 
 -- HAVING FILTERS GROUPS 
SELECT REQUESTED_BRAND, COUNT(REQUESTED_BRAND) AS FREQUENCY FROM MEDGINI GROUP BY 1 HAVING  COUNT(REQUESTED_BRAND)>40  ORDER BY 2 DESC;
 
  SELECT OUTLET, ROUND(
 COUNT(CASE WHEN PRESCRIPTION = 'VALID PRESCRIPTION AVAILABLE' THEN 1 END)*100/COUNT(*),2
 ) AS PRESCRIPTION_PERCENT,
 ROUND(
COUNT(CASE WHEN PRESCRIPTION = 'OTC (No PRESCRIPTION)' THEN 1 END)*100.00 / COUNT(*),2
)AS OTC_PERCENTAGE
 FROM MEDGINI GROUP BY 1 HAVING PRESCRIPTION_PERCENT>OTC_PERCENTAGE  ORDER BY 2 DESC;
 

 
 WITH REASON AS (
    SELECT
        City,
        PURCHASE_REASON,
        COUNT(*) AS Total_PURCHASE,
        DENSE_RANK() OVER (
            PARTITION BY City
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM Medgini
    GROUP BY City, PURCHASE_REASON
)
SELECT
    City,
   PURCHASE_REASON
    Total_PURCHASE
FROM REASON
WHERE rnk = 1;


 
SELECT COUNT(*)*100/ ( SELECT COUNT(*) FROM MEDGINI WHERE ALTERNATIVE_SUGGESTED ='YES') AS ACCEPTANCE_FRACTION FROM MEDGINI WHERE ALTERNATIVE_ACCEPTED ='YES';

SELECT REQUESTED_BRAND, FINAL_BRAND FROM MEDGINI WHERE (REQUESTED_BRAND != FINAL_BRAND)  ;

-- 41. Find the most common symptom among OTC purchases.
-- 42. Count doctor-prescribed purchases for each requested brand.
-- 43. Calculate the repeat purchase percentage for each requested brand.
-- 44. Find the average quantity purchased for every requested brand.
-- 45. Find the customer category that requested Corex the most.

 WITH SYMP AS (
    SELECT
        PRESCRIPTION ,
        SYMPTOM,
        COUNT(SYMPTOM) AS SYMPTOM_COUNT,
        DENSE_RANK() OVER (
            PARTITION BY PRESCRIPTION  
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM Medgini
     WHERE PRESCRIPTION = 'OTC (NO PRESCRIPTION)'
    GROUP BY PRESCRIPTION,SYMPTOM
)
SELECT
    PRESCRIPTION,
   SYMPTOM,SYMPTOM_COUNT
     
FROM SYMP
WHERE rnk  <=2;


SELECT REQUESTED_BRAND, COUNT(PURCHASE_REASON) FROM MEDGINI WHERE PURCHASE_REASON = 'DOCTOR PRESCRIPTION' GROUP BY 1 ORDER BY 2 DESC;

SELECT REQUESTED_BRAND, COUNT(REPEAT_PURCHASE)*100/(SELECT  COUNT(REQUESTED_BRAND) FROM MEDGINI   ) AS PERCENT_REPEAT FROM MEDGINI WHERE REPEAT_PURCHASE = 'YES' GROUP BY 1  ORDER BY PERCENT_REPEAT DESC;

SELECT REQUESTED_BRAND, AVG(QUANTITY) FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC;

 WITH TARGET AS (
    SELECT
        REQUESTED_BRAND,
        CATEGORY,
        COUNT(CATEGORY) AS CATEGORY_COUNT,
        DENSE_RANK() OVER (
            PARTITION BY REQUESTED_BRAND
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM Medgini
     WHERE REQUESTED_BRAND = 'COREX'
    GROUP BY REQUESTED_BRAND, CATEGORY
)
SELECT
   REQUESTED_BRAND,
   CATEGORY,CATEGORY_COUNT
     
FROM TARGET
WHERE rnk  =1;


-- 46. Find the outlet with the highest demand for Corex.
-- 47. Find cities where Corex demand is greater than Ascoril demand.
-- 48. Find the most common purchase reason among farmers.
-- 49. Display outlets having more than 50 survey responses.
-- 50. Find cities where the substitution rate is greater than 15%.
 WITH TARGET AS (
    SELECT
        REQUESTED_BRAND,
        OUTLET,
        COUNT(OUTLET) AS OUTLET_COUNT,
        DENSE_RANK() OVER (
            PARTITION BY REQUESTED_BRAND
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM Medgini
     WHERE REQUESTED_BRAND = 'COREX'
    GROUP BY REQUESTED_BRAND,  OUTLET
)
SELECT
   REQUESTED_BRAND,
   OUTLET, OUTLET_COUNT
     
FROM TARGET
WHERE rnk  =1;

SELECT COUNT(REQUESTED_BRAND ) FROM MEDGINI WHERE REQUESTED_BRAND = 'COREX';
SELECT COUNT(REQUESTED_BRAND ) FROM MEDGINI WHERE REQUESTED_BRAND = 'ASCORIL';
SELECT CITY FROM MEDGINI  WHERE ( (SELECT COUNT(REQUESTED_BRAND ) FROM MEDGINI WHERE REQUESTED_BRAND = 'COREX')>(SELECT COUNT(REQUESTED_BRAND ) FROM MEDGINI WHERE REQUESTED_BRAND = 'ASCORIL')) GROUP BY CITY;


 WITH TARGET AS (
    SELECT
        CATEGORY,
        PURCHASE_REASON,
        COUNT(PURCHASE_REASON) AS REASON_COUNT,
        DENSE_RANK() OVER (
            PARTITION BY  CATEGORY
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM Medgini
     WHERE CATEGORY = 'FARMER'
    GROUP BY CATEGORY,   PURCHASE_REASON
)
SELECT
   CATEGORY,
   PURCHASE_REASON, REASON_COUNT
     
FROM TARGET
WHERE rnk  =1;

SELECT OUTLET, COUNT(OUTLET) AS SURVEY_RESPONSES FROM MEDGINI GROUP BY 1 HAVING SURVEY_RESPONSES>40;


  SELECT CITY, ROUND(
 COUNT(CASE WHEN ALTERNATIVE_ACCEPTED = 'YES' THEN 1 END)*100/COUNT(*),2
 ) AS SUBSTITUTION_RATE FROM MEDGINI GROUP BY 1 HAVING SUBSTITUTION_RATE>10;
 
 
 
 
-- 51. Find the top 3 most requested brands in every city.
-- 52. Rank all brands based on their overall market share.
-- 53. Find the second most requested brand in each city.
-- 54. Find the least requested brand in every city.
-- 55. Find the outlet where each brand was requested the most.

WITH TARGET AS(
SELECT CITY, REQUESTED_BRAND,
COUNT(REQUESTED_BRAND) AS REQ_FREQUENCY,
DENSE_RANK() OVER(
 PARTITION BY CITY ORDER BY COUNT(*) DESC
) AS RANKK FROM MEDGINI GROUP BY CITY, REQUESTED_BRAND
)
SELECT CITY, REQUESTED_BRAND,   REQ_FREQUENCY FROM TARGET WHERE RANKK<=3;


WITH TARGET AS(
SELECT REQUESTED_BRAND,
COUNT(REQUESTED_BRAND)*100/ (SELECT COUNT(*) FROM MEDGINI) AS MARKET_SHARE,
DENSE_RANK() OVER(
 PARTITION BY REQUESTED_BRAND ORDER BY COUNT(*) DESC
) AS RANKK FROM MEDGINI GROUP BY   REQUESTED_BRAND
)
SELECT  REQUESTED_BRAND, MARKET_SHARE FROM TARGET ORDER BY MARKET_SHARE DESC ;


WITH TARGET AS(
SELECT CITY, REQUESTED_BRAND,
COUNT(REQUESTED_BRAND) AS REQ_FREQUENCY,
DENSE_RANK() OVER(
 PARTITION BY CITY ORDER BY COUNT(*) DESC
) AS RANKK FROM MEDGINI GROUP BY CITY, REQUESTED_BRAND
)
SELECT CITY, REQUESTED_BRAND,   REQ_FREQUENCY FROM TARGET WHERE RANKK=2;


SELECT COUNT(DISTINCT REQUESTED_BRAND) FROM MEDGINI;
WITH TARGET AS(
SELECT CITY, REQUESTED_BRAND,
COUNT(REQUESTED_BRAND) AS REQ_FREQUENCY,
DENSE_RANK() OVER(
 PARTITION BY CITY ORDER BY COUNT(*) DESC
) AS RANKK FROM MEDGINI GROUP BY CITY, REQUESTED_BRAND
)
SELECT CITY, REQUESTED_BRAND,   REQ_FREQUENCY FROM TARGET  WHERE RANKK  =(SELECT COUNT(DISTINCT REQUESTED_BRAND) FROM MEDGINI);


WITH TARGET AS(
SELECT  REQUESTED_BRAND,OUTLET,
COUNT(OUTLET) AS BRAND_FREQUENCY,
DENSE_RANK() OVER(
 PARTITION BY REQUESTED_BRAND ORDER BY COUNT(*) DESC
) AS RANKK FROM MEDGINI GROUP BY  REQUESTED_BRAND,OUTLET
)
SELECT   REQUESTED_BRAND,  OUTLET, BRAND_FREQUENCY FROM TARGET WHERE RANKK=1;




-- 56. Find the city contributing the highest percentage of total surveys.
-- 57. Calculate the cumulative market share of brands ordered by frequency.
-- 58. Find brands whose market share is above the average market share.
-- 59. Find customers belonging to the top 10% highest quantity purchases.
-- 60. Find the outlet having the highest substitution rate in each city.


WITH TARGET AS(
SELECT  CITY,
COUNT(CITY) AS CITY_SURVEYS ,
DENSE_RANK() OVER(
  ORDER BY  COUNT(CITY) DESC
) AS RANKK FROM MEDGINI  GROUP BY CITY
)
SELECT  city, CITY_SURVEYS FROM TARGET WHERE RANKK=1;



WITH Brand_Count AS (
    SELECT
        Requested_Brand,
        COUNT(*) AS Frequency
    FROM Medgini
    GROUP BY Requested_Brand
),
Market_Share AS (
    SELECT
        Requested_Brand,
        Frequency,
        ROUND(Frequency * 100.0 / SUM(Frequency) OVER (), 2) AS Market_Share
    FROM Brand_Count
)
SELECT
    Requested_Brand,
    Frequency,
    Market_Share,
    ROUND(
        SUM(Market_Share) OVER (
            ORDER BY Frequency DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS Cumulative_Market_Share
FROM Market_Share
ORDER BY Frequency DESC;



WITH Brand_Count AS (
    SELECT
        Requested_Brand,
        COUNT(*) AS Frequency
    FROM Medgini
    GROUP BY Requested_Brand
),
Market_Share AS (
    SELECT
        Requested_Brand,
        Frequency,
        ROUND(Frequency * 100.0 / SUM(Frequency) OVER (), 2) AS Market_Share
    FROM Brand_Count
)
SELECT REQUESTED_BRAND, FREQUENCY, MARKET_SHARE FROM MARKET_SHARE WHERE MARKET_SHARE> (SELECT AVG(MARKET_SHARE)FROM MARKET_SHARE);


WITH PURCHASES AS (
    SELECT
        Survey_ID,
        Requested_Brand,
        Quantity,
        NTILE(10) OVER (
            ORDER BY Quantity DESC
        ) AS Decile
    FROM Medgini
)
SELECT
    Survey_ID,
    Requested_Brand,
    Quantity
FROM PURCHASES
WHERE Decile = 1
ORDER BY Quantity DESC;



  WITH SUBRATE AS(SELECT CITY, OUTLET,ROUND(
 COUNT(CASE WHEN ALTERNATIVE_ACCEPTED = 'YES' THEN 1 END)*100/COUNT(*),2
 ) AS SUBRATE FROM MEDGINI GROUP BY CITY, OUTLET  )
 ,
  TARGET AS(
SELECT  CITY,OUTLET,
 SUBRATE,
DENSE_RANK() OVER(
partition by CITY
  ORDER BY SUBRATE DESC
) AS RANKK FROM SUBRATE   
)
SELECT  city,  OUTLET , SUBRATE FROM TARGET  WHERE RANKK=1;



-- 61. Calculate the running total of survey responses city-wise ordered by Survey_ID.
-- 62. Find the difference between each brand's request count and the overall average request count
-- 63. Find brands that were requested in every city.
-- 64. Find cities where every outlet recorded at least one Corex request.
-- 65. Find the most preferred brand among repeat customers.


SELECT
    Survey_ID,
    City,
    COUNT(*) AS Survey_Count,
    SUM(COUNT(*)) OVER (
        PARTITION BY City
        ORDER BY Survey_ID
    ) AS Running_Total
FROM Medgini
GROUP BY Survey_ID, City
ORDER BY City, Survey_ID;



SELECT COUNT(SURVEY_ID)/( SELECT COUNT(DISTINCT REQUESTED_BRAND) FROM MEDGINI) AS AVERAGE FROM MEDGINI;
SELECT REQUESTED_BRAND, (COUNT(REQUESTED_BRAND)- (SELECT COUNT(SURVEY_ID)/( SELECT COUNT(DISTINCT REQUESTED_BRAND) FROM MEDGINI)  FROM MEDGINI))AS AVERAGE_DIFFERENCE FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC;
-- OR 
SELECT
    Requested_Brand,
    COUNT(*) -
    (
        SELECT COUNT(*) * 1.0 /
               COUNT(DISTINCT Requested_Brand)
        FROM Medgini
    ) AS Average_Difference
FROM Medgini
GROUP BY Requested_Brand
ORDER BY Average_Difference DESC; 


SELECT  REQUESTED_BRAND,COUNT(DISTINCT CITY) FROM MEDGINI GROUP BY REQUESTED_BRAND HAVING COUNT(DISTINCT CITY = (SELECT COUNT(DISTINCT CITY) FROM MEDGINI));


SELECT COUNT(DISTINCT OUTLET) FROM MEDGINI WHERE REQUESTED_BRAND = 'COREX';

SELECT CITY  FROM MEDGINI GROUP BY CITY HAVING COUNT(DISTINCT OUTLET) = COUNT(DISTINCT  CASE WHEN REQUESTED_BRAND ='COREX' THEN OUTLET END);


SELECT REQUESTED_BRAND, COUNT(REQUESTED_BRAND) AS FREQUENCY FROM MEDGINI WHERE REPEAT_PURCHASE = 'YES' GROUP BY 1 ORDER BY 2 DESC LIMIT 1;


-- 66. Compare doctor-prescribed and OTC demand for every brand in a single report.
-- 67. Find the percentage contribution of each outlet to its city's total surveys.
-- 68. Find the brand with the fastest growth if Survey_ID is treated as chronological order.
-- 69. Create a view showing the market share of every brand.
-- 70. Create a view showing city-wise brand leaders.
 
 
 SELECT REQUESTED_BRAND, COUNT(CASE WHEN PRESCRIPTION = 'VALID PRESCRIPTION AVAILABLE' THEN 1 END)AS DOCTORISED, COUNT(CASE WHEN PRESCRIPTION ='OTC (NO PRESCRIPTION)' THEN 1 END) AS OTC
FROM MEDGINI GROUP BY 1 ORDER BY 2 DESC; 


WITH CityFreq AS (
    SELECT
        Outlet,
        City,
        COUNT(*) AS Outlet_Surveys
    FROM Medgini
    GROUP BY Outlet, City
)
SELECT
    Outlet,
    City,
    Outlet_Surveys,
    ROUND(
        Outlet_Surveys * 100.0 /
        SUM(Outlet_Surveys) OVER (PARTITION BY City),
        2
    ) AS Contribution_Percentage
FROM CityFreq
ORDER BY City, Contribution_Percentage DESC;


CREATE VIEW Brand_Market_Share AS
SELECT
    Requested_Brand,
    COUNT(*) AS Total_Requests,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Medgini),
        2
    ) AS Market_Share
FROM Medgini
GROUP BY Requested_Brand;
SELECT * FROM BRAND_MARKET_SHARE  ;
 
CREATE VIEW CityLeaders AS
WITH BrandCount AS (
    SELECT
        City,
        Requested_Brand,
        COUNT(*) AS BrandReq,
        DENSE_RANK() OVER (
            PARTITION BY City
            ORDER BY COUNT(*) DESC
        ) AS Rankk
    FROM Medgini
    GROUP BY City, Requested_Brand
)
SELECT
    City,
    Requested_Brand,
    BrandReq
FROM BrandCount
WHERE Rankk = 1;
SELECT * FROM CITYLEADERS;


-- 71. Find duplicate survey records based on all attributes except Survey_ID.
-- 72. Find customers whose purchased quantity is above the average quantity of their city.
-- 73. Find the outlet having the maximum average purchase quantity in each city.
-- 74. Generate a city-wise dashboard showing total surveys, OTC percentage, doctor prescription percentage, substitution rate, and top brand.
-- 75. Generate a final business report containing, for every city: total surveys, top requested brand, top outlet, substitution rate, repeat purchase percentage, and market share of the leading brand.
