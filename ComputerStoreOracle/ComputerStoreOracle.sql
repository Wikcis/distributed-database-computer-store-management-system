DROP TABLE TRANSACTIONS;
DROP TABLE CLIENTS;
DROP TABLE GraphicsCardDetails;
DROP TABLE RAMDetails;
DROP TABLE ProcessorDetails;
DROP TABLE MotherboardDetails;
DROP TABLE STOCK;

-- Create STOCK table
CREATE TABLE STOCK (
    product_id NUMBER,
    product_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT CHECK (quantity>=0),
    price NUMBER CHECK (price>=0),
    PRIMARY KEY (product_id)
);
/

-- Create GraphicsDetails table
Create Table GraphicsDetails(
	product_id NUMBER,
	model VARCHAR(100),
	interface VARCHAR(10),
    FOREIGN KEY (product_id) REFERENCES STOCK(product_id)
)
/

-- Create RAMDetails table
Create Table RAMDetails(
	product_id NUMBER,
	model VARCHAR(100) NOT NULL,
	memoty_type VARCHAR(10) NOT NULL,
    memory_size INT NOT NULL CHECK (memory_size > 0),
    FOREIGN KEY (product_id) REFERENCES STOCK(product_id)
)
/

-- Create ProcessorDetails table
Create Table ProcessorDetails(
	product_id NUMBER,
	module VARCHAR(100) NOT NULL,
	socket VARCHAR(10) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES STOCK(product_id)
)
/

-- Create MotherboardDetails table
Create Table MotherboardDetails(
	product_id NUMBER,
	product_name VARCHAR(100) NOT NULL,
	socket VARCHAR(10) NOT NULL,
	memory_type VARCHAR(10) NOT NULL,
	interface VARCHAR(10) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES STOCK(product_id)
)
/

-- Create CompatibilityRules table
CREATE TABLE CompatibilityRules (
    rule_id NUMBER NOT NULL,
    product_category_1 VARCHAR(50) NOT NULL,
    product_category_2 VARCHAR(50) NOT NULL,
    compatibility_criteria VARCHAR(100) NOT NULL,
    PRIMARY KEY(rule_id)
);
/

-- Create CLIENTS table
CREATE TABLE CLIENTS (
    client_id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
	name VARCHAR(30),
	last_name VARCHAR(50),
	address VARCHAR(200),
    PRIMARY KEY(client_id)
);
/

-- Create TRANSACTIONS table
CREATE TABLE TRANSACTIONS (
    transaction_id NUMBER GENERATED ALWAYS as IDENTITY(START with 1 INCREMENT by 1),
    product_id,
    price NUMBER CHECK (price>=0),
    quantity INT CHECK (quantity>=0),
    client_id,
    transaction_date DATE DEFAULT SYSDATE,
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (product_id) REFERENCES STOCK (product_id),
    FOREIGN KEY (client_id) REFERENCES CLIENTS (client_id)
);
/

-- INSERTING DATA -----------------------------------

INSERT INTO Stock values (1,'Karta graficzna NVIDIA 3060','Graphics', 10, 3200);
INSERT INTO Stock values (2,'Procesor INTEL Core i5','Processor', 20, 6500);
INSERT INTO Stock values (3,'Pamiêæ Ram KINGSTONE','RAM', 20, 1100);
INSERT INTO Stock values (4,'P³yta g³ówna GIGABYTE B550M','Motherboard', 20, 1500);
INSERT INTO Stock values (5,'Karta graficzna RADEON RX 6600','Graphics', 20, 2000);
INSERT INTO Stock values (6,'Procesor AMD Ryzen 5','Processor', 20, 1500);
INSERT INTO Stock values (7,'Pamiêæ Ram GOODRAM','RAM', 20, 1000);
INSERT INTO Stock values (8,'P³yta g³ówna MSI Pro H510','Motherboard', 20, 10000);
	
INSERT INTO Clients (name, last_name, address) values ('Marek', 'Jaki', '£ódŸ ul. Piotrkowska 223');
INSERT INTO Clients (name, last_name, address) values ('Adam', 'Kowalski', 'Warszawa ul. Prosta 123');
INSERT INTO Clients (name, last_name, address) values ('Miros³aw', 'Marecki', 'Rzeszów ul. Kwiatowa 1');
INSERT INTO Clients (name, last_name, address) values ('Rados³aw', 'Kowalczyk', 'Opole ul. D³uga 123');
INSERT INTO Clients (name, last_name, address) values ('Anna', 'Nowak', '£ódŸ ul. Zgierska 1');

INSERT INTO GraphicsDetails values (1, 'NVIDIA 3060', 'PCIe 4.0');
INSERT INTO GraphicsDetails values (5, 'Radeon RX 6600', 'PCIe 4.0');

INSERT INTO ProcessorDetails values (2, 'INTEL Core i5-6600', '1151');
INSERT INTO ProcessorDetails values	(6, 'AMD Ryzen 5 7600', 'AM5');

INSERT INTO RAMDetails values (3, 'Kingston FURY', 'DDR4', 8);
INSERT INTO RAMDetails values (7, 'GOODRAM', 'DDR4', 8);

INSERT INTO MotherboardDetails values (4, 'Gigabyte B550M','AM4', 'DDR4','PCIe 4.0');
INSERT INTO MotherboardDetails values (8, 'MSI PRO H510-B', '1200','DDR4','PCIe 3.0');

SELECT * FROM Stock;

