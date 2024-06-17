Use ComputerStoreSQLServer
Go

DROP TABLE IF EXISTS MotherboardDetails
DROP TABLE IF EXISTS ProcessorDetails
DROP TABLE IF EXISTS RAMDetails
DROP TABLE IF EXISTS GraphicsDetails
DROP TABLE IF EXISTS Transactions
DROP TABLE IF EXISTS Clients
DROP TABLE IF EXISTS STOCK
DROP TABLE IF EXISTS CompatibilityRules

-- Create STOCK table
CREATE TABLE dbo.Stock (
    product_id INT PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	category VARCHAR(50) NOT NULL,
    quantity INT CHECK (quantity >= 0),
    price MONEY CHECK (price >= 0)
);

-- Create GraphicsCardDetails table
Create Table dbo.GraphicsDetails(
	product_id INT NOT NULL FOREIGN KEY REFERENCES Stock(product_id),
	model VARCHAR(100) NOT NULL,
	interface VARCHAR(10) NOT NULL
)
Go

-- Create RAMDetails table
Create Table dbo.RAMDetails(
	product_id INT NOT NULL FOREIGN KEY REFERENCES Stock(product_id),
	model VARCHAR(100) NOT NULL,
	memory_type VARCHAR(10) NOT NULL,
    memory_size INT NOT NULL CHECK (memory_size > 0)
)
Go

-- Create ProcessorDetails table
Create Table dbo.ProcessorDetails(
	product_id INT NOT NULL FOREIGN KEY REFERENCES Stock(product_id),
	module VARCHAR(100) NOT NULL,
	socket VARCHAR(10) NOT NULL
)
Go

-- Create MotherboardDetails table
Create Table dbo.MotherboardDetails(
	product_id INT NOT NULL FOREIGN KEY REFERENCES Stock(product_id),
	product_name VARCHAR(100) NOT NULL,
	socket VARCHAR(10) NOT NULL,
	memory_type VARCHAR(10) NOT NULL,
	interface VARCHAR(10) NOT NULL
)
Go

CREATE TABLE dbo.CompatibilityRules (
    rule_id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    product_category_1 VARCHAR(50) NOT NULL,
    product_category_2 VARCHAR(50) NOT NULL,
    compatibility_criteria VARCHAR(100) NOT NULL
);
GO

-- Create CLIENTS table
CREATE TABLE dbo.Clients (
    client_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	address VARCHAR(200)
);

-- Create TRANSACTIONS table
CREATE TABLE dbo.Transactions (
    transaction_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    product_id INT FOREIGN KEY (product_id) REFERENCES dbo.Stock (product_id),
    price MONEY CHECK (price >= 0),
    quantity INT CHECK (quantity >= 0),
    client_id INT FOREIGN KEY (client_id) REFERENCES dbo.Clients (client_ID),
	transaction_date DATETIME DEFAULT GETDATE()
);

-- INSERTING DATA -------------------------------
INSERT INTO dbo.Stock values 
	(1,'Karta graficzna NVIDIA 3060','Graphics', 10, 3200),
	(2,'Procesor INTEL Core i5','Processor', 20, 6500),
	(3,'Pamiêæ Ram KINGSTONE','RAM', 20, 1100),
	(4,'P³yta g³ówna GIGABYTE B550M','Motherboard', 20, 1500),
	(5,'Karta graficzna RADEON RX 6600','Graphics', 20, 2000),
	(6,'Procesor AMD Ryzen 5','Processor', 20, 1500),
	(7,'Pamiêæ Ram GOODRAM','RAM', 20, 1000),
	(8,'P³yta g³ówna MSI Pro H510','Motherboard', 20, 10000)
Go

INSERT INTO dbo.Stock VALUES (9,'P³yta g³ówna MSI Pro H700', 'Motherboard', 0, 100);

INSERT INTO Clients values
	('Jan', 'Nowak', '£ódŸ ul. Kolejowa 1'),
	('Jan', 'Kowalski', 'Warszawa ul. Kolejowa 12'),
	('Adam', 'Nowak', 'Rzeszów ul. Piêkna 1'),
	('Radek', 'Nowak', 'Konin ul. D³uga 123'),
	('Micha³', 'Nowak', '£ódŸ ul. Piotrkowska 1')
Go

INSERT INTO GraphicsDetails values
	(1, 'NVIDIA 3060', 'PCIe 4.0'),
	(5, 'Radeon RX 6600', 'PCIe 4.0')
Go

INSERT INTO ProcessorDetails values
	(2, 'INTEL Core i5-6600', '1151'),
	(6, 'AMD Ryzen 5 7600', 'AM5')
Go

INSERT INTO RAMDetails values
	(3, 'Kingston FURY', 'DDR4', 8),
	(7, 'GOODRAM', 'DDR4', 8)
Go

INSERT INTO MotherboardDetails values
	(4, 'Gigabyte B550M','AM4', 'DDR4','PCIe 4.0'),
	(8, 'MSI PRO H510-B', '1200','DDR4','PCIe 3.0')
Go

INSERT INTO dbo.CompatibilityRules (product_category_1, product_category_2, compatibility_criteria) VALUES 
	('Processor', 'Motherboard', 'd1.socket = d2.socket'),
	('RAM', 'Motherboard', 'd1.memory_type = d2.memory_type'),
	('Graphics', 'Motherboard', 'd1.interface = d2.interface'),
	('Motherboard', 'Processor', 'd1.socket = d2.socket'),
	('Motherboard', 'RAM', 'd1.memory_type = d2.memory_type'),
	('Motherboard', 'Graphics', 'd1.interface = d2.interface')
GO

INSERT INTO Transactions values (1, 3200, 1, 1, GETDATE())

SELECT * FROM Transactions
