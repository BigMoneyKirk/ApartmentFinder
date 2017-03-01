Create Table[Apartment](
[ApartmentID] int IDENTITY(1,1) NOT NULL,
[ApartmentName] varchar(45),
[Street Address] varchar(45),
[ContactEmail] varchar(45),
[ContactPhone] varchar(45),
[CityID] int,
[Active] bit Not Null Default(1)
CONSTRAINT PK_ApartmentID Primary Key Clustered (ApartmentID)
CONSTRAINT FK_CityID Foreign Key (CityID) REFERENCES [City](CityID)
    ON DELETE CASCADE    
    ON UPDATE CASCADE 
)
Create Table[Room](
[RoomID] int IDENTITY(1,1) NOT NULL,
[NumberOfBeds] int,
[RoomNumber] varchar(45),
[isFilled] bit Not Null Default(0),
[price] money,
[ApartmentID] int,
[Active] bit Not Null Default(1)
CONSTRAINT PK_RoomID Primary Key Clustered ([RoomID])
CONSTRAINT FK_ApartmentID Foreign Key (ApartmentID) REFERENCES [Apartment](ApartmentID)
    ON DELETE CASCADE    
    ON UPDATE CASCADE 
)
Create Table[City](
[CityID] int IDENTITY(1,1) NOT NULL,
[Name] varchar(45),
[Zip Code] varchar(45),
[StateID] int,
[Active] bit Not Null Default(1)
CONSTRAINT PK_CityID Primary Key Clustered ([CityID]),
CONSTRAINT FK_StateID Foreign Key ([StateID]) REFERENCES [State]([StateID])
    ON DELETE CASCADE    
    ON UPDATE CASCADE 
)

Create Table[State](
[StateID] int IDENTITY(1,1) NOT NULL,
[StateName] varchar(45),
CONSTRAINT PK_StateID Primary Key Clustered ([StateID])
)

Create Table[User](
[UserID] int IDENTITY(1,1) NOT NULL,
[Name] varchar(45),
[Username] varchar(45),
[Password] varchar(45),
[Email] varchar(45),
CONSTRAINT PK_UserID Primary Key Clustered ([UserID])
)

Create Table[FavoritedRooms](
[UserID] int,
[RoomID] int
CONSTRAINT PK_FavoritedRoomsID Primary Key Clustered ([UserID], [RoomID]),
CONSTRAINT FK_FavoritedRooms_UserID Foreign Key ([UserID]) REFERENCES [User]([UserID]),   
CONSTRAINT FK_FavoritedRooms_RoomID Foreign Key ([ROomID]) REFERENCES [Room]([RoomID])
    ON DELETE CASCADE    
    ON UPDATE CASCADE 
)

CREATE VIEW [AllUsersFavoritedRooms] AS
Select [User].UserID,[user].[name],[Room].RoomID,[Room].NumberOfBeds,[Room].RoomNumber,[Room].isFilled,[Room].price,[Apartment].ApartmentID,[Apartment].ApartmentName,[Apartment].[Street Address],[City].CityId,[city].[name] as 'CityName',
[City].[Zip Code],[State].StateID,[State].StateName,[Apartment].ContactEmail,[Apartment].ContactPhone
From [FavoritedRooms]
inner join [User] on [User].UserID = [FavoritedRooms].UserID
inner join [room] on [room].RoomID = [FavoritedRooms].RoomID
inner join [Apartment] on [Apartment].ApartmentID = [Room].ApartmentID  
inner join [City] on [Apartment].CityID = [City].CityID
inner join [State] on [City].StateID = [State].StateID
Select * From AllUsersFavoritedRooms

CREATE VIEW [ApartmentInformation] AS
Select [Apartment].ApartmentID,[Apartment].ApartmentName,[Apartment].[Street Address],[City].CityId,[city].[name] as 'CityName',
[City].[Zip Code],[State].StateID,[State].StateName,[Apartment].ContactEmail,[Apartment].ContactPhone From [Apartment]
inner join [city] on [City].CityID = [Apartment].CityID
inner join [State] on [State].StateID = City.StateID

Create View [RoomInformation] AS
Select [Room].RoomID,[Room].NumberOfBeds,[Room].RoomNumber,[Room].isFilled,[Room].price, [ApartmentInformation].ApartmentID,[ApartmentInformation].ApartmentName,[ApartmentInformation].[Street Address],[ApartmentInformation].CityId,[ApartmentInformation].[CityName],
[ApartmentInformation].[Zip Code],[ApartmentInformation].StateID,[ApartmentInformation].StateName,[ApartmentInformation].ContactEmail,[ApartmentInformation].ContactPhone From [Room]
inner join ApartmentInformation on [Room].ApartmentID = [ApartmentInformation].ApartmentID
Go
CREATE FUNCTION RoomsInApartment(@apartmentID int)
returns table
AS 
	Return Select * From RoomInformation where apartmentID = @apartmentID
Go
CREATE FUNCTION AvailableRoomsinApartment(@apartmentID int)
returns table
AS 
	Return Select * From RoomInformation where apartmentID = @apartmentID AND isFilled=0
Go
CREATE FUNCTION UserFavorites(@userID int)
returns table
AS 
	Return Select * From AllUsersFavoritedRooms where userID = @userID 
Go
CREATE FUNCTION FavoritedRoom(@roomID int)
returns table
AS 
	Return Select * From AllUsersFavoritedRooms where roomID = @roomId 
Go
CREATE FUNCTION AllRoomsByZip(@zip_code int)
returns table
AS 
	Return Select * From RoomInformation where [Zip Code]= @zip_code
	Go
CREATE FUNCTION AllRoomsByCity(@CityName int)
returns table
AS 
	Return Select * From RoomInformation where [CityName] = @CityName
Go
CREATE FUNCTION AllRoomsByState(@StateName int)
returns table
AS 
	Return Select * From RoomInformation where [StateName] = @StateName  
Go
CREATE FUNCTION AvailableRoomsByZip(@zip_code int)
returns table
AS 
	Return Select * From RoomInformation where [Zip Code]= @zip_code AND isFilled=0
Go
CREATE FUNCTION AvailableRoomsByCity(@CityName int)
returns table
AS 
	Return Select * From RoomInformation where [CityName] = @CityName AND isFilled=0
Go
CREATE FUNCTION AvailableRoomsByState(@StateName int)
returns table
AS 
	Return Select * From RoomInformation where [StateName] = @StateName AND isFilled=0  
Go

CREATE FUNCTION NumRoomsInApartment(@ApartmentID int)
RETURNS int
as 
BEGIN
	declare @total int;
	 Select @total = COUNT(ApartmentID)From RoomInformation where ApartmentID=@ApartmentID
	 return @total
end
go

CREATE FUNCTION NumRoomsInState(@StateID int)
RETURNS int
as 
BEGIN
	declare @total int;
	 Select @total = COUNT(StateID)From RoomInformation where StateID=@StateID
	 return @total
end
go

CREATE FUNCTION NumRoomsInCity(@CityID int)
RETURNS int
as 
BEGIN
	declare @total int;
	 Select @total = COUNT(CityID)From RoomInformation where CityID=@CityID
	 return @total
end
go

CREATE FUNCTION NumRoomsInZip(@zip_code int)
RETURNS int
as 
BEGIN
	declare @total int;
	 Select @total = COUNT([Zip Code])From RoomInformation where [Zip Code]=@zip_code
	 return @total
end
go

CREATE FUNCTION NumAvailableRoomsInApartment(@ApartmentID int)
RETURNS int
as 
BEGIN
	declare @total int;
	 Select @total = COUNT(ApartmentID)From RoomInformation where ApartmentID=@ApartmentID and isFilled=0
	 return @total
end
go

CREATE FUNCTION NumAvailableRoomsByState(@stateID int)
RETURNS int
as 
BEGIN
	declare @total int;
	 Select @total = COUNT(StateID)From RoomInformation where StateID=@stateID and isFilled=0
	 return @total
end
go

CREATE FUNCTION NumAvailableRoomsByCity(@CityID int)
RETURNS int
as 
BEGIN
	declare @total int;
	 Select @total = COUNT(CityId)From RoomInformation where CityID=@CityID and isFilled=0
	 return @total
end
go

CREATE FUNCTION NumAvailableRoomsByZip(@zip_code int)
RETURNS int
as 
BEGIN
	declare @total int;
	 Select @total = COUNT([Zip Code])From RoomInformation where [Zip Code]=@zip_code and isFilled=0
	 return @total
end
go

CREATE FUNCTION AvgRoomCostByApartment(@ApartmentID int)
Returns money
As
BEGIn
	declare @total money;
	select @total = Avg(price)From RoomInformation where [ApartmentID] = @apartmentID
	return @total
END
Go
CREATE FUNCTION AvgRoomCostByZip(@zip_code int)
Returns money
As
BEGIn
	declare @total money;
	select @total = Avg(price)From RoomInformation where [Zip Code]= @zip_code
	return @total
END
Go
CREATE FUNCTION AvgRoomCostByCity(@cityID int)
Returns money
As
BEGIn
	declare @total money;
	select @total = Avg(price)From RoomInformation where CityID= @cityID
	return @total
END

Go
CREATE FUNCTION AvgRoomCostByState(@StateID int)
Returns money
As
BEGIn
	declare @total money;
	select @total = Avg(price)From RoomInformation where StateId= @StateID
	return @total
END
Go
CREATE FUNCTION AvgRoomCostOverall()
Returns money
As
BEGIn
	declare @total money;
	select @total = Avg(price)From RoomInformation
	return @total
END

GO
CREATE PROCEDURE CreateApartment
@ApartmentName varchar(45),
@Street  varchar(45),
@ContactEmail varchar(45),
@ContactPhone varchar(45),
@CityID int
AS
INSERT INTO Apartment ([ApartmentName],[Street Address],[ContactEmail],
[ContactPhone],[CityID]) Values (@ApartmentName,@Street,@ContactEmail,
@ContactPhone, @CityID)
GO
CREATE PROCEDURE CreateRoom
@ApartmentName varchar(45),
@Street  varchar(45),
@ContactEmail varchar(45),
@ContactPhone varchar(45),
@CityID int
AS
INSERT INTO Apartment ([ApartmentName],[Street Address],[ContactEmail],
[ContactPhone],[CityID]) Values (@ApartmentName,@Street,@ContactEmail,
@ContactPhone, @CityID)
GO
CREATE PROCEDURE DeleteApartment
@ApartmentID int
AS
DELETE FROM Apartment 
WHERE @ApartmentID = ApartmentID
GO
CREATE PROCEDURE DeleteUser
@UserID int
AS
DELETE FROM [User]
WHERE @UserID = UserID
GO
CREATE PROCEDURE UpdateApartment
@ApartmentID int,
@ApartmentName varchar(45),
@Street  varchar(45),
@ContactEmail varchar(45),
@ContactPhone varchar(45),
@CityID int
AS
UPDATE Apartment
SET [ApartmentName] = @ApartmentName, [Street Address] = @Street, [ContactEmail] = @ContactEmail,
[ContactPhone] = @ContactPhone, [CityID] = @CityID
WHERE ApartmentID = @ApartmentID
GO
CREATE PROCEDURE UpdateUser
@UserID int,
@Name varchar(45),
@Username  varchar(45),
@Password varchar(45),
@Email varchar(45)
AS
UPDATE [User]
SET [Name] = @Name, [Username] = @Username,
[Password] = @Password, [Email] = @Email
WHERE UserID = @UserID
GO

INSERT INTO State VALUES
(
'Georgia'
)
INSERT INTO State VALUES
(
'New Jersey'
)
INSERT INTO State VALUES
(
'Alabama'
)
INSERT INTO State VALUES
(
'Alaska'
)
INSERT INTO State VALUES
(
'Arizona'
)
INSERT INTO State VALUES
(
'Arkansas'
)
INSERT INTO State VALUES
(
'California'
)
INSERT INTO State VALUES
(
'Colorado'
)
INSERT INTO State VALUES
(
'Connecticut'
)
INSERT INTO State VALUES
(
'Delaware'
)
INSERT INTO State VALUES
(
'Florida'
)
INSERT INTO State VALUES
(
'Hawaii'
)
INSERT INTO State VALUES
(
'Idaho'
)
INSERT INTO State VALUES
(
'Illinois'
)
INSERT INTO State VALUES
(
'Indiana'
)
INSERT INTO State VALUES
(
'Iowa'
)
INSERT INTO State VALUES
(
'Kansas'
)
INSERT INTO State VALUES
(
'Kentucky'
)
INSERT INTO State VALUES
(
'Louisiana'
)
INSERT INTO State VALUES
(
'Maine'
)INSERT INTO State VALUES
(
'Maryland'
)
INSERT INTO State VALUES
(
'Massachusetts'
)
INSERT INTO State VALUES
(
'Michigan'
)
INSERT INTO State VALUES
(
'Minnesota'
)
INSERT INTO State VALUES
(
'Mississippi'
)
INSERT INTO State VALUES
(
'Missouri'
)
INSERT INTO State VALUES
(
'Montana'
)
INSERT INTO State VALUES
(
'Nebraska'
)
INSERT INTO State VALUES
(
'Nevada'
)
INSERT INTO State VALUES
(
'New Hampshire'
)
INSERT INTO State VALUES
(
'New Mexico'
)
INSERT INTO State VALUES
(
'New York'
)
INSERT INTO State VALUES
(
'North Carolina'
)
INSERT INTO State VALUES
(
'North Dakota'
)
INSERT INTO State VALUES
(
'Ohio'
)
INSERT INTO State VALUES
(
'Oklahoma'
)
INSERT INTO State VALUES
(
'Oregan'
)
INSERT INTO State VALUES
(
'Pennsylvania'
)
INSERT INTO State VALUES
(
'Rhode Island'
)
INSERT INTO State VALUES
(
'South Carolina'
)
INSERT INTO State VALUES
(
'South Dakota'
)
INSERT INTO State VALUES
(
'Tennessee'
)
INSERT INTO State VALUES
(
'Texas'
)
INSERT INTO State VALUES
(
'Utah'
)
INSERT INTO State VALUES
(
'Vermont'
)
INSERT INTO State VALUES
(
'Virginia'
)
INSERT INTO State VALUES
(
'Washington'
)
INSERT INTO State VALUES
(
'Washington D.C.'
)
INSERT INTO State VALUES
(
'West Virginia'
)
INSERT INTO State VALUES
(
'Wisconsin'
)
INSERT INTO State VALUES
(
'Wyoming'
)

INSERT INTO City VALUES
(
'Athens', 30605, 1, 1
)

INSERT INTO City VALUES
(
'Chesterfield', 08515, 2, 1
)

INSERT INTO Apartment VALUES
(
'Surrey Square', '350 Riverbend Pkwy', 'greensproperties@hotmail.com', '706-555-5555', 1, 1
)

INSERT INTO Apartment VALUES
(
'The Sycamores', '739 Augusta Blvd', 'sycamores@gmail.com', '304-324-5555', 2, 1
)

INSERT INTO Room VALUES
(
4, 'A10-A', 0, 295, 1, 1
)

INSERT INTO Room VALUES
(
4, 'A10-B', 0, 295, 1, 1
)

INSERT INTO Room VALUES
(
1, 'B4', 1, 1600, 2, 1
)

INSERT INTO Room VALUES
(
2, 'C9-B', 0, 1300, 2, 1
)
