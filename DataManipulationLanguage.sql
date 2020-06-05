-- Q1 What are all the details of the units with leases ending in the next 30 days?
SELECT u.*, s.leaseEndDate
FROM [TAR.Unit] u, [TAR.Sign] s
WHERE s.unitId = s.unitId
AND DATEDIFF(day,s.leaseEndDate, getdate())<=30;

-- Q2 Which owner has the most unleased units?
SELECT u.ownId AS 'Owner ID',
	o.ownFirstName AS 'Owner First Name', 
	o.ownLastName AS 'Owner Last Name',
	o.ownType AS 'Type of Owner',
	COUNT(u.unitId) AS 'Total Units Available'
FROM [TAR.Unit] u, [TAR.Owner] o
WHERE u.unitId NOT IN (SELECT unitId FROM [TAR.Sign]) AND u.ownId = o.ownId
GROUP BY u.ownId, o.ownFirstName, o.ownLastName, o.ownType
ORDER BY u.ownId;

-- Q3 How many units does each owner have and what is the min, max and average rent of their properties? 
SELECT o.ownId AS 'Owner ID', 
	COUNT(u.unitId) AS 'Number of Units Owned', 
	ROUND(MIN(u.unitRent),2) AS 'Minimum Lease Price',
	ROUND(AVG(u.unitRent),2) AS 'Average Lease Price',
	ROUND(MAX(u.unitRent),2) AS 'Maximum Lease Price'
FROM [TAR.Owner] o, [TAR.Unit] u
WHERE u.ownId = o.ownId
GROUP BY o.ownId;

-- Q4 What is number of leases, average lease length, and cost of each lease for each Agent (include name of the agent as well)?
SELECT s.agtId AS 'Agent ID',
	a.agtFirstName AS 'Agent First Name',
	a.agtLastName AS 'Agent Last Name',
	COUNT(s.agtId) AS 'Number of Units under Agent', 
	AVG(DATEDIFF(month, s.leaseStartDate, s.leaseEndDate)) AS 'Average Lease Length (in months)',
	ROUND(AVG(u.unitRent),0) AS 'Average Rent per Lease (in $)'
FROM [TAR.Sign] s, [TAR.Unit] u, [TAR.Agent] a
WHERE s.unitId = u.unitId AND s.agtId=a.agtId
GROUP BY s.agtId, a.agtFirstName, a.agtLastName 
ORDER BY [Number of Units under Agent] DESC;

-- Q5 What are the 3 most popular amenity types in currently leased apartment style units?
SELECT TOP 3 a.amnDescription AS 'Amenity Description', 
	COUNT(a.amnId) AS 'Number of Leases with Amenity'
FROM [TAR.Contain] c, [TAR.Amenity] a, [TAR.Unit] u
WHERE c.unitId IN (SELECT unitId FROM [TAR.Sign]) 
	AND a.amnId = c.amnId AND u.unitId=c.unitId AND u.unitType = 'Apartment'
GROUP BY a.amnDescription
ORDER BY COUNT(a.amnId) DESC;

-- Q6 Who are the top 3 and bottom 3 performing agents (based on leases signed)?
SELECT * FROM (SELECT TOP 3 a.agtId AS 'Agent ID', 
	'Top Performer' AS 'Performance Status', 
	COUNT(s.leaseId) AS 'Number of Leases'
FROM [TAR.Agent] a , [TAR.Sign] s
WHERE s.agtId = a.agtId
GROUP BY a.agtId
ORDER BY 3 DESC) as a
UNION
SELECT TOP 3 a.agtId AS 'Agent ID', 
	'Bottom Performer' AS 'Performance Status', 
	COUNT(s.leaseId) AS 'Number of Leases'
FROM [TAR.Agent] a , [TAR.Sign] s
WHERE s.agtId = a.agtId
GROUP BY a.agtId
ORDER BY 3 DESC;

-- Q7 What are the details of owners of townhouses with 4 or more bedrooms located within 2 miles from campus, in order of the year of construction?
SELECT o. ownId AS 'Owner ID',
	o.ownFirstName AS 'Owner First Name',
	o.ownLastName AS 'Owner Last Name',
	o.ownType AS 'Owner Type',
	o.ownPhone AS 'Owner Phone',
	o.ownEmail As 'Owner Email'
FROM [TAR.Unit] u, [TAR.Owner] o
WHERE u.ownId = o.ownId
AND u.unitType = 'Townhouse'
AND u.unitDistFromCampus <= 2
AND u.unitBed >= 4
ORDER BY u.unitYearOfConstruction DESC;

-- Q8 How many units currently not leased (never leased or leased in the past) for each type of unit?
SELECT  u.unitType AS 'Unit Type', 
	COUNT(U.unitId) AS 'Number of Units'
FROM [TAR.Unit] u
WHERE u.unitId NOT IN (SELECT s.unitId FROM [TAR.Sign] s)
OR u.unitId IN (SELECT m.unitId FROM [TAR.Unit] l, [TAR.Sign] m WHERE m.unitId = l.unitID AND m.leaseEndDate < getDate())
GROUP BY u.unitType;

-- Q9 What is the ID, name, and phone of agents title Junior Agents who got signed in the last 2 years?
SELECT a.agtId AS 'Agent ID',
	a.agtFirstName AS 'Agent First Name', 
	a.agtLastName AS 'Agent Last Name',
	a.agtPhone AS 'Agent Phone Number',  
	COUNT(S.agtId) AS '# of Leases Signed'
FROM [TAR.Agent] a, [TAR.Sign] s
WHERE a.agtId = s.agtId
AND YEAR(s.leaseStartDate) >= YEAR(getDate()) - 2 AND a.agtTitle = 'Junior Agent'
GROUP BY a.agtId, a.agtPhone, a.agtFirstName, a.agtLastName
ORDER BY COUNT(s.agtId) DESC;

-- Q10 How many owners do we have in each zip code in Maryland in decreasing order of number of owners? 
SELECT o.ownZip AS 'Zip Code within Maryland',
	COUNT(o.ownId) AS 'Number of Owners in this zip code' 
FROM [TAR.Owner] o
WHERE o.ownState = 'MD'
GROUP BY o.ownZip
ORDER BY [Number of Owners in this zip code] DESC ;

-- Q11 Who are the five property owners with the most number of units? (Visualized in Tableau; Please check Tableau file - Project0503-09_Visualization.twb)
SELECT TOP 5 CONCAT(ownFirstName,' ',ownLastName) AS 'Property Owner', 
	COUNT(u.unitId) AS 'Number of Units'
FROM [TAR.Unit] u, [TAR.Owner] o
WHERE u.ownId = o.ownId
GROUP BY o.ownFirstName, o.ownLastName
ORDER BY COUNT(u.unitId) DESC

-- Q12 What are the number of units of each type within each zipcode? (Visualized in Tableau; Please check Tableau file - Project0503-09_Visualization.twb)
SELECT u.unitZip AS 'ZipCode', 
	u.unitType AS 'Unit Type', 
COUNT(u.unitId) AS 'Number of Units' 
FROM [TAR.Unit] u
GROUP BY u.unitZip, u.unitType
ORDER BY u.unitZip

-- Q13 What is the minimum, average, and maximum rent for the units with different number of bedrooms? (Visualized in Tableau; Please check Tableau file - Project0503-09_Visualization.twb)
SELECT u.unitBed as 'Number of Bedrooms', 
COUNT(u.unitId) AS 'Number of Units', 
MIN(u.unitRent) AS 'Minimum Rent', 
	ROUND(AVG(u.unitRent),2) AS 'Average Rent', 
MAX(u.unitRent) AS 'Maximum Rent'
FROM [TAR.Unit] u
GROUP BY u.unitBed