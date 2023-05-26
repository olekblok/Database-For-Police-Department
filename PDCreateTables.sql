CREATE TABLE PoliceStations (
	PoliceStationID int CHECK(PoliceStationID > 0) NOT NULL,
	City varchar(55) CHECK(City NOT LIKE '%[^A-Z]%') NOT NULL,
	Adress varchar(55) CHECK(Adress NOT LIKE '%[^A-Z]%') NOT NULL,
	Phonenumber varchar(9)  CHECK(Phonenumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	PRIMARY KEY (PoliceStationID)
	);

Create TABLE People	(
	PersonalID varchar(11) CHECK(PersonalID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	MothersMaidenName varchar(50) CHECK(MothersMaidenName NOT LIKE '%[^A-Z]%'),
	LastName varchar(255) CHECK(LastName NOT LIKE '%[^A-Z]%') NOT NULL,
    FirstName varchar(255) CHECK(FirstName NOT LIKE '%[^A-Z]%') NOT NULL,
	City varchar(55) CHECK(City NOT LIKE '%[^A-Z]%') NOT NULL,
	Adress varchar(55) CHECK(Adress NOT LIKE '%[^A-Z]%') NOT NULL,
	Phonenumber varchar(9) CHECK(Phonenumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	Gender varchar(6)CHECK(Gender = 'Male' or Gender = 'Female' or Gender = 'X'),
	DateOfBirth DATE CHECK(DateOfBirth > '1900-01-01' AND DateOfBirth < GETDATE()),
	PRIMARY KEY (PersonalID)
	);

CREATE TABLE WhistleBlowers (
    WhistleBlowerID  bigint CHECK(WhistleBlowerID > 0) NOT NULL,
    LastName varchar(255) CHECK(LastName NOT LIKE '%[^A-Z]%') ,
    FirstName varchar(255) CHECK(FirstName NOT LIKE '%[^A-Z]%') ,
    Phonenumber varchar(9) CHECK(Phonenumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    PRIMARY KEY (WhistleBlowerID)
	);

CREATE TABLE Policemen(
	BadgeNumber varchar(6) CHECK(BadgeNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	LastName varchar(255) CHECK(LastName NOT LIKE '%[^A-Z]%') NOT NULL,
    FirstName varchar(255) CHECK(FirstName NOT LIKE '%[^A-Z]%') NOT NULL,
	City varchar(55) CHECK(City NOT LIKE '%[^A-Z]%') NOT NULL,
	Adress varchar(55) CHECK(Adress NOT LIKE '%[^A-Z]%') NOT NULL,
	Phonenumber varchar(9) CHECK(Phonenumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	PoliceStationID int NOT NULL,
	PRIMARY KEY (BadgeNumber),
	FOREIGN KEY (PoliceStationID) REFERENCES PoliceStations(PoliceStationID)
	on delete cascade
	on update no action,
	);

CREATE TABLE Events(
	EventID	bigint  CHECK(EventID > 0)NOT NULL,
	[Date]  DATE CHECK([Date] > '1980-01-01' AND [Date] < GETDATE())NOT NULL,
    [Time] TIME NOT NULL,
	City varchar(30)CHECK(City NOT LIKE '%[^A-Z]%') NOT NULL,
	Adress varchar(55) CHECK(Adress NOT LIKE '%[^A-Z]%') NOT NULL,
	Status varchar(8) CHECK(Status = 'solved' or Status = 'unsolved')NOT NULL,
	Description  varchar(500),
	BadgeNumber varchar(6) CHECK(BadgeNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	PRIMARY KEY (EventID),
	FOREIGN KEY (BadgeNumber) REFERENCES Policemen(BadgeNumber)
	on delete no action
	on update cascade
	);

CREATE TABLE Registrations (
    RegistrationID	bigint CHECK(RegistrationID > 0) NOT NULL,
	[Date]  DATE CHECK([Date] > '1980-01-01' AND [Date] < GETDATE())NOT NULL,
    Time TIME,
    Description  varchar(500),
	City varchar(30)CHECK(City NOT LIKE '%[^A-Z]%') NOT NULL,
	Adress varchar(55) CHECK(Adress NOT LIKE '%[^A-Z]%') NOT NULL,
	WhistleBlowerID  bigint NOT NULL,
	EventID bigint NOT NULL,
	BadgeNumber varchar(6) CHECK(BadgeNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
    PRIMARY KEY (RegistrationID),
	FOREIGN KEY (WhistleBlowerID) REFERENCES WhistleBlowers(WhistleBlowerID)
	on delete cascade
	on update no action,
	FOREIGN KEY (EventID) REFERENCES Events(EventID)
	on delete cascade
	on update no action,
	FOREIGN KEY (BadgeNumber) REFERENCES Policemen(BadgeNumber)
	on delete no action
	on update no action
	);

CREATE TABLE Cases(
	CaseID bigint CHECK(CaseID > 0) NOT NULL,
	[Date]  DATE CHECK([Date] > '1980-01-01' AND [Date] < GETDATE())NOT NULL,
	Status varchar(8) CHECK(Status = 'solved' or Status = 'unsolved')NOT NULL,
	TypeOfCase varchar(20) CHECK(TypeOfCase NOT LIKE '%[^A-Z]%') NOT NULL,
	Description  varchar(500),
	EventID bigint NOT NULL,
	BadgeNumber varchar(6) CHECK(BadgeNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	PoliceStationID int NOT NULL,
	PRIMARY KEY (CaseID),
	FOREIGN KEY (EventID) REFERENCES Events(EventID)
	on delete cascade
	on update no action,
	FOREIGN KEY (BadgeNumber) REFERENCES Policemen(BadgeNumber)
	on delete cascade
	on update no action,
	FOREIGN KEY (PoliceStationID) REFERENCES PoliceStations(PoliceStationID)
	on delete no action
	on update no action,
	);

CREATE TABLE Witnesses(
	WitnessID bigint CHECK(WitnessID > 0) NOT NULL,
	Descriptions varchar(1000),
	CaseID bigint NOT NULL,
	PersonalID varchar(11) CHECK(PersonalID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	PRIMARY KEY (WitnessID),
	FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
	on delete cascade
	on update no action,
	FOREIGN KEY (PersonalID) REFERENCES People(PersonalID)
	on delete cascade
	on update no action
	);

CREATE TABLE Accused(
	AccusedID bigint CHECK(AccusedID > 0) NOT NULL,
	Accusitions varchar(1000), 
	CaseID bigint NOT NULL,
	PersonalID varchar(11) CHECK(PersonalID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	PRIMARY KEY (AccusedID),
	FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
	on delete cascade
	on update no action,
	FOREIGN KEY (PersonalID) REFERENCES People(PersonalID)
	on delete cascade
	on update no action
	);

CREATE TABLE Victims(
	VictimID bigint CHECK(VictimID > 0) NOT NULL,
	Descriptions varchar(1000),
	CaseID bigint NOT NULL,
	PersonalID varchar(11) CHECK(PersonalID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	PRIMARY KEY (VictimID),
	FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
	on delete cascade
	on update no action,
	FOREIGN KEY (PersonalID) REFERENCES People(PersonalID)
	on delete no action
	on update no action
	);
	
CREATE TABLE Searchings(
	SearchingID bigint CHECK(SearchingID > 0) NOT NULL,
	City varchar(30),
	Adress varchar(55),
	[Date]  DATE CHECK([Date] > '1980-01-01' AND [Date] < GETDATE())NOT NULL,
	Time Time,
	Descriptions varchar(8000),
	BadgeNumber varchar(6) CHECK(BadgeNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	CaseID bigint NOT NULL, 
	PRIMARY KEY (SearchingID),
	FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
	on delete cascade
	on update no action,
	FOREIGN KEY (BadgeNumber) REFERENCES Policemen(BadgeNumber)
	on delete no action
	on update no action
	);

CREATE TABLE Interrogations(
	InterrogationID bigint CHECK(InterrogationID > 0) NOT NULL,
	[Date]  DATE CHECK([Date] > '1980-01-01' AND [Date] < GETDATE())NOT NULL,
	[Time] time NOT NULL,
	[Statement]varchar (6),
	CaseID bigint NOT NULL,
	PersonalID varchar(11) CHECK(PersonalID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') NOT NULL,
	BadgeNumber varchar(6) NOT NULL,
	PRIMARY KEY (InterrogationID),
	FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
	on delete cascade
	on update no action,
	FOREIGN KEY (BadgeNumber) REFERENCES Policemen(BadgeNumber)
	on delete no action
	on update no action,
	FOREIGN KEY (PersonalID) REFERENCES People(PersonalID)
	on delete cascade
	on update no action
	);