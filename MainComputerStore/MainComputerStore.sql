Use master
Go 

Create Database MainComputerStore;
Go

Use MainComputerStore
Go

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
	client_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	address VARCHAR(200) NOT NULL
)
Go

Create Table Products(
	product_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	category VARCHAR(50) NOT NULL,
	quantity INT CHECK (quantity>=0),
	price MONEY CHECK (price>=0)
)
Go

Create Table Transactions(
	transaction_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	product_id INT NOT NULL FOREIGN KEY REFERENCES Products(product_id),
	client_id INT NOT NULL FOREIGN KEY REFERENCES Clients(client_id),
	quantity INT CHECK (quantity>=0),
	price MONEY CHECK (price>=0),
	date DATE DEFAULT GETDATE()
)
Go

-- INSERTING DATA ----------------------------------------------------
INSERT INTO Products values
	('Karta graficzna NVIDIA 3060','Graphics', 10, 3200),
	('Procesor INTEL Core i5','Processor', 20, 6500),
	('Pamiêæ Ram KINGSTONE','RAM', 20, 1100),
	('P³yta g³ówna GIGABYTE B550M','Motherboard', 20, 1500),
	('Karta graficzna RADEON RX 6600','Graphics', 20, 2000),
	('Procesor AMD Ryzen 5','Processor', 20, 1500),
	('Pamiêæ Ram GOODRAM','RAM', 20, 1000),
	('P³yta g³ówna MSI Pro H510','Motherboard', 20, 10000)
Go

INSERT INTO Clients values
	('Jan', 'Nowak', '£ódŸ ul. Kolejowa 1'),
	('Jan', 'Kowalski', 'Warszawa ul. Kolejowa 12'),
	('Adam', 'Nowak', 'Rzeszów ul. Piêkna 1'),
	('Radek', 'Nowak', 'Konin ul. D³uga 123'),
	('Micha³', 'Nowak', '£ódŸ ul. Piotrkowska 1')
Go

INSERT INTO Stores values
	(1,'Poland, £ódŸ, ul. Piotrkowska 1'),
	(2,'Poland, Czêstochowa, ul. Jasnogórska 1'),
	(3,'Poland, Kraków, ul. Piekna 1')
Go

-- CREATING DATABSE AND USER -----------------------------------------

Create Database ComputerStoreSqlServer;
Go

USE ComputerStoreSqlServer
Go

CREATE LOGIN computerStoreLoginSqlServer WITH PASSWORD = '12345'
CREATE USER computerStoreUserSqlServer FOR LOGIN computerStoreLoginSqlServer

ALTER ROLE db_owner ADD MEMBER computerStoreUserSqlServer;


-- CREATING SQL SERVER LINKED SERVER -----------------------------------------
USE MainComputerStore
Go

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
	@rmtuser = N'ComputerStoreLoginSqlServer', 
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
