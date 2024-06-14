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
    quantity INT CHECK (quantity>=0),
    price NUMBER CHECK (price>=0),
    PRIMARY KEY (product_id)
);
/

-- Create GraphicsCardDetails table
Create Table GraphicsCardDetails(
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
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (product_id) REFERENCES STOCK (product_id),
    FOREIGN KEY (client_id) REFERENCES CLIENTS (client_id)
);
/

-- INSERTING DATA -----------------------------------

INSERT INTO Stock values (1, 10, 3200);
INSERT INTO Stock values (2, 1, 6500);
INSERT INTO Stock values (3, 11, 1100);
INSERT INTO Stock values (4, 6, 1500);
INSERT INTO Stock values (5, 5, 2000);
INSERT INTO Stock values (6, 7, 1500);
INSERT INTO Stock values (7, 20, 1000);
INSERT INTO Stock values (8, 1, 10000);

INSERT INTO Clients (name, last_name, address) values ('Marek', 'Jaki', '£Ûdü ul. Piotrkowska 223');
INSERT INTO Clients (name, last_name, address) values ('Adam', 'Kowalski', 'Warszawa ul. Prosta 123');
INSERT INTO Clients (name, last_name, address) values ('Miros≥aw', 'Marecki', 'RzeszÛw ul. Kwiatowa 1');
INSERT INTO Clients (name, last_name, address) values ('Rados≥aw', 'Kowalczyk', 'Opole ul. D≥uga 123');
INSERT INTO Clients (name, last_name, address) values ('Anna', 'Nowak', '£Ûdü ul. Zgierska 1');

INSERT INTO GraphicsCardDetails values (1, 'NVIDIA 3060', 'PCIe 4.0');
INSERT INTO GraphicsCardDetails values (5, 'Radeon RX 6600', 'PCIe 4.0');

INSERT INTO ProcessorDetails values (2, 'INTEL Core i5-6600', '1151');
INSERT INTO ProcessorDetails values	(6, 'AMD Ryzen 5 7600', 'AM5');

INSERT INTO RAMDetails values (3, 'Kingston FURY 8GB', 'DDR4');
INSERT INTO RAMDetails values (7, 'GOODRAM 8GB', 'DDR4');

INSERT INTO MotherboardDetails values (4, 'Gigabyte B550M','AM4', 'DDR4','PCIe 4.0');
INSERT INTO MotherboardDetails values (8, 'MSI PRO H510-B', '1200','DDR4','PCIe 3.0');

SELECT * FROM Stock;

