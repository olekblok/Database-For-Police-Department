
--Find which policeman at the police station A registered the most events.
Select Policemen.BadgeNumber, Policemen.LastName, Policemen.FirstName, COUNT(Events.BadgeNumber) AS 'Registered Events'
FROM Events
JOIN Policemen ON Events.BadgeNumber=Policemen.BadgeNumber where Policemen.PoliceStationID = 5
GROUP BY  Policemen.BadgeNumber, Policemen.LastName, Policemen.FirstName
ORDER BY COUNT(events.BadgeNumber) DESC

--Find a police station which performed the most interrogations per case in cases related to X (e.g., mugging).
Select TOP 1 PoliceStations.City, PoliceStations.PoliceStationID, COUNT(PoliceStations.PoliceStationID) AS 'Interrogation per mugging'
FROM PoliceStations
JOIN Cases ON PoliceStations.PoliceStationID = Cases.PoliceStationID 
JOIN Interrogations ON Cases.CaseID = Interrogations.CaseID 
where Cases.TypeOfCase = 'Mugging'
GROUP BY PoliceStations.City, PoliceStations.PoliceStationID
ORDER BY COUNT(PoliceStations.PoliceStationID) DESC

--Find all witnesses interrogated by a policeman A in the past 5 years.
Select People.FirstName, People.LastName
FROM People
JOIN Interrogations ON Interrogations.PersonalID = People.PersonalID 
JOIN Witnesses ON Witnesses.PersonalID = People.PersonalID
 where Interrogations.BadgeNumber = '657533' and Interrogations.Date > '2015-01-06'

--Show people who were a victim in more than two cases
SELECT People.FirstName, People.LastName, People.PersonalID, COUNT(People.PersonalID) AS 'Victims times'
FROM People
JOIN Victims ON Victims.PersonalID = People.PersonalID 
GROUP BY People.FirstName, People.LastName, People.PersonalID
HAVING COUNT(People.PersonalID) > 1
ORDER BY COUNT(People.PersonalID) DESC

--Show the cases where a policeman leading the case did the searching more than twice
Select Cases.CaseID, Cases.TypeOfCase, Cases.Status, Cases.BadgeNumber, COUNT(Cases.CaseID) AS 'Policeman leading the case searching'
From Cases
JOIN Searchings ON Searchings.BadgeNumber = Cases.BadgeNumber and Searchings.CaseID = Cases.CaseID
GROUP BY Cases.CaseID, Cases.TypeOfCase, Cases.Status, Cases.BadgeNumber
HAVING COUNT(Cases.CaseID) > 2
ORDER BY COUNT(Cases.CaseID) DESC
 
--Show the cases where victim's and whistleblower's name, surname and phonenumber are the same
Select Cases.CaseID, Cases.TypeOfCase, Cases.Description 
From Cases
Join Events on Cases.EventID = Events.EventID
Join Registrations on Registrations.EventID = Events.EventID
Join WhistleBlowers on WhistleBlowers.WhistleBlowerID = Registrations.WhistleBlowerID
Join Victims on Victims.CaseID = Cases.CaseID
Join People on People.PersonalID = Victims.PersonalID
where WhistleBlowers.FirstName = People.FirstName 
and WhistleBlowers.LastName = People.LastName 
and WhistleBlowers.Phonenumber = People.Phonenumber

--Show the policeman who solved most events (did not have to transfrom into cases)
Create View [PolicemnaWithMostSolvedCases] AS
Select top 1 Policemen.BadgeNumber, COUNT (Policemen.BadgeNumber) AS 'Number of solved events'
From Policemen
Join Events on Events.BadgeNumber = Policemen.BadgeNumber
where Events.Status = 'solved'
GROUP BY  Policemen.BadgeNumber
ORDER BY COUNT(Policemen.BadgeNumber) DESC

Select *
From Policemen
where BadgeNumber = (Select BadgeNumber from [PolicemnaWithMostSolvedCases])

--Find all people who have been murdered in Slupsk in last twenty years
Select People.FirstName, People.LastName, People.PersonalID
from People
Join Victims on Victims.PersonalID = People.PersonalID
Join Cases on Victims.CaseID = Cases.CaseID
join Events on Events.EventID = Cases.EventID
where Cases.TypeOfCase = 'murder' and Cases.Date > '2001-01-01' and Events.City = 'S³upsk'

--Show person who has most accusitions of mugging
Select People.FirstName, People.LastName, People.PersonalID, Cases.TypeOfCase--, COUNT(People.PersonalID) AS 'Muggs commited'
from People
LEFT Join Accused on Accused.PersonalID = People.PersonalID
LEFT Join Cases on Cases.CaseID = Accused.CaseID
--where Cases.TypeOfCase = 'Mugging'
--GROUP BY People.FirstName, People.LastName, People.PersonalID
--ORDER BY COUNT(People.PersonalID) DESC