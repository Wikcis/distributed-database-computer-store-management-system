Use master
Go 

Create Database MainComputerStore;
Go

Use MainComputerStore
Go

DROP TABLE IF EXISTS GraphicsCardDetails
DROP TABLE IF EXISTS RAMDetails
DROP TABLE IF EXISTS ProcessorDetails
DROP TABLE IF EXISTS MotherboardDetails
DROP TABLE IF EXISTS Transactions
DROP TABLE IF EXISTS Products
DROP TABLE IF EXISTS Clients
DROP TABLE IF EXISTS Logs
DROP TABLE IF EXISTS Stores


-- CREATING TABLES -----------------------------------------
Create Table Logs(
	log_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	log_details VARCHAR(255),
)
Go

Create Table Stores(
	store_id INT NOT NULL PRIMARY KEY,
	address VARCHAR(200) NOT NULL,
)
Go

Create Table Clients(
	client_id INT PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	address VARCHAR(200)
)
Go

Create Table Products(
	product_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	quantity INT CHECK (quantity>=0),
	price MONEY CHECK (price>=0)
)
Go

Create Table Transactions(
	transaction_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	product_id INT NOT NULL FOREIGN KEY REFERENCES Products(product_id),
	client_id INT NOT NULL FOREIGN KEY REFERENCES Clients(client_id),
	quantity INT CHECK (quantity>=0),
	price MONEY CHECK (price>=0)
)
Go

-- INSERTING DATA ----------------------------------------------------
INSERT INTO Products values
	('Karta graficzna NVIDIA 3060', 10, 3200),
	('Procesor INTEL Core i5', 20, 6500),
	('Pami�� RAM Kingstone', 20, 1100),
	('P�yta g��wna Gigabyte B550M', 20, 1500),
	('Karta graficzna Radeon RX 6600', 20, 2000),
	('Procesor AMD Ryzen 5', 20, 1500),
	('Pami�� Ram GOODRAM', 20, 1000),
	('P�yta g��wna MSI PRO H510', 20, 10000)
Go

INSERT INTO Clients values
	('Jan', 'Nowak', '��d� ul. Kolejowa 1'),
	('Jan', 'Kowalski', 'Warszawa ul. Kolejowa 12'),
	('Adam', 'Nowak', 'Rzesz�w ul. Pi�kna 1'),
	('Radek', 'Nowak', 'Konin ul. D�uga 123'),
	('Micha�', 'Nowak', '��d� ul. Piotrkowska 1')
Go

INSERT INTO Stores values
	(1,'Poland, ��d�, ul. Piotrkowska 1'),
	(2,'Poland, Cz�stochowa, ul. Jasnog�rska 1'),
	(3,'Poland, Krak�w, ul. Piekna 1')
Go

-- CREATING DATABSE AND USER -----------------------------------------

Create Database ComputerStoreSQLServer;
Go

USE ComputerStoreSQLServer
Go

CREATE LOGIN computerStoreLoginSqlServer WITH PASSWORD = '12345'
CREATE USER computerStoreUserSqlServer FOR LOGIN computerStoreLoginSqlServer

ALTER ROLE db_owner ADD MEMBER computerStoreUserSqlServer;


-- CREATING SQL SERVER LINKED SERVER -----------------------------------------
sp_linkedservers

EXEC sp_addlinkedserver
	@server=N'SQLServerLS',
	@srvproduct=N'',
	@provider=N'MSOLEDBSQL',
	@datasrc='LAPTOP-PCASHRLR';
GO

sp_addlinkedsrvlogin
	@rmtsrvname = N'SQLServerLS',
	@useself = 'False',
	@rmtuser = N'computerStoreLoginSqlServer', 
	@rmtpassword = N'12345'
GO

-- CREATING ORACLE LINKED SERVER -----------------------------------------

EXEC sp_addlinkedserver
	@server=N'OracleLS',
	@srvproduct=N'',
	@provider=N'OraOLEDB.Oracle',
	@datasrc='pd19c';
GO

sp_addlinkedsrvlogin
	@rmtsrvname = N'OracleLS',
	@useself = 'False',
	@locallogin = N'sa',
	@rmtuser = N'computerStoreUserOracle', 
	@rmtpassword = N'12345'
GO

