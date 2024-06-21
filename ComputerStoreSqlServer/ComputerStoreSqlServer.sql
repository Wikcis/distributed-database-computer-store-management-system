Use ComputerStoreSQLServer
Go

DROP TABLE IF EXISTS Transactions
DROP TABLE IF EXISTS Clients
DROP TABLE IF EXISTS Stock

-- Create Stock table -----------------------
CREATE TABLE Stock (
    product_id INT PRIMARY KEY,
	product_name VARCHAR(100) NOT NULL,
	category VARCHAR(50) NOT NULL,
    quantity INT CHECK (quantity >= 0),
    price MONEY CHECK (price >= 0)
);
GO

-- Create Clients table -----------------------
CREATE TABLE Clients (
    client_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	address VARCHAR(200)
);
GO

-- Create Transactions table -----------------
Create Table Transactions(
	transaction_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	product_id INT NOT NULL FOREIGN KEY REFERENCES Stock(product_id),
	client_id INT NOT NULL FOREIGN KEY REFERENCES Clients(client_id),
	quantity INT CHECK (quantity>=0),
	price MONEY CHECK (price>=0),
	transaction_date DATE DEFAULT GETDATE()
)
Go

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

INSERT INTO Transactions values (1, 3200, 1, 1, GETDATE())

SELECT * FROM Transactions
