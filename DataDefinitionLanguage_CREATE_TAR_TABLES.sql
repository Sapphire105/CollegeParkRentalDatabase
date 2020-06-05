-- ***************************************************** CREATE TABLES *******************************************************************
--Owner (ownId, ownType, ownFirstName, ownLastName, ownPhone, ownEmail, ownStreet, ownCity, ownState, ownZip) = 3NF
CREATE TABLE [TAR.Owner](
	ownId CHAR(10) NOT NULL,
	ownType VARCHAR(20),
	ownFirstName VARCHAR(50),
	ownLastName VARCHAR(50),
	ownPhone CHAR(10),
	ownEmail VARCHAR(100),
	ownStreet VARCHAR(100),
	ownCity VARCHAR(20),
	ownState VARCHAR(2),
	ownZip VARCHAR(5), 
	CONSTRAINT pk_Owner_ownId PRIMARY KEY (ownId));
	
--Unit (unitId, unitType, unitYearOfConstruction,unitBed, unitBath, unitRent, unitArea, 
-- unitNumber, unitStreet, unitCity, unit State, unitDistFromCampus, ownId) 
CREATE TABLE [TAR.Unit](
	unitId CHAR(10) NOT NULL,
	unitType VARCHAR(20), 
	unitYearOfConstruction DATE,
	unitBed INTEGER,
	unitBath INTEGER,
	unitRent FLOAT, 
	unitArea FLOAT,
	unitNumber VARCHAR(5),
	unitStreet VARCHAR(100),
	unitCity VARCHAR(20),
	unitState VARCHAR(2),
	unitZip VARCHAR(5),
	unitDistFromCampus FLOAT,
	ownId CHAR(10)
	CONSTRAINT pk_Unit_unitId PRIMARY KEY(unitId),
	CONSTRAINT fk_Unit_ownId FOREIGN KEY(ownId)
		REFERENCES [TAR.Owner] (ownId)
		ON DELETE NO ACTION ON UPDATE CASCADE);

--Amenity (amnId, amnDescription) 
CREATE TABLE [TAR.Amenity] (
	amnId CHAR(10) NOT NULL,
	amnDescription VARCHAR(50),
	CONSTRAINT pk_Amenity_amnId PRIMARY KEY (amnId));

--Agent (agtId, agtTitle, agtFirstName, agtLastName, agtPhone, agtEmail)
CREATE TABLE [TAR.Agent] (
	agtId CHAR(10) NOT NULL,
	agtTitle VARCHAR(20),
	agtFirstName VARCHAR(50),
	agtLastName VARCHAR(50),
	agtPhone VARCHAR(10),
	agtEmail VARCHAR(100),
	CONSTRAINT pk_Agent_agtId PRIMARY KEY (agtId));

--Client (cltId, cltFirstName, cltLastName, cltPhone, cltEmail, agtId)
CREATE TABLE [TAR.Client] (
	cltId CHAR(10) NOT NULL,
	cltFirstName VARCHAR(50),
	cltLastName VARCHAR(50),
	cltPhone VARCHAR(10), 
	cltEmail VARCHAR(100),
	agtId CHAR(10),
	CONSTRAINT pk_Client_cltId PRIMARY KEY (cltId),
	CONSTRAINT fk_Client_agtId FOREIGN KEY (agtId)
		REFERENCES [TAR.Agent] (agtId)
		ON DELETE NO ACTION ON UPDATE CASCADE);

--Contain (unitId, amnId)
CREATE TABLE [TAR.Contain] (
	unitId CHAR(10) NOT NULL,
	amnId CHAR(10) NOT NULL,
	CONSTRAINT pk_Contain_unitId_amnID PRIMARY KEY (unitId, amnId),
	CONSTRAINT fk_Contain_unitId FOREIGN KEY (unitId)
		REFERENCES [TAR.Unit] (unitId)
		ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_Contain_amnId FOREIGN KEY (amnId)
		REFERENCES [TAR.Amenity] (amnId)
		ON DELETE NO ACTION ON UPDATE NO ACTION);

--Sign (leaseId, unitId, agtId, cltId, leaseStartDate, leaseEndDate)
CREATE TABLE [TAR.Sign] (
	leaseId CHAR(10) NOT NULL,
	unitId CHAR(10),
	agtId CHAR(10),
	cltId CHAR(10),
	leaseStartDate DATE,
	leaseEndDate DATE,
	CONSTRAINT pk_Sign_leaseId PRIMARY KEY (leaseId),
	CONSTRAINT fk_Sign_unitId FOREIGN KEY (unitId)
		REFERENCES [TAR.Unit] (unitId)
		ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_Sign_agtId FOREIGN KEY (agtId)
		REFERENCES [TAR.Agent] (agtId)
		ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_Sign_cltId FOREIGN KEY (cltid)
		REFERENCES [TAR.Client] (cltId)
		ON DELETE NO ACTION ON UPDATE NO ACTION);