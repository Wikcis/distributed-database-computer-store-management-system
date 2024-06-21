DROP TABLE CLIENTS;
DROP TABLE GRAPHICS_DETAILS;
DROP TABLE RAM_DETAILS;
DROP TABLE PROCESSOR_DETAILS;
DROP TABLE MOTHERBOARD_DETAILS;
DROP TABLE PRODUCTS;
DROP TABLE LOGS;

-- Create LOGS table ---------------------
Create Table LOGS (
	log_id NUMBER,
	log_details VARCHAR(255),
    PRIMARY KEY (log_id)
)
/

-- Create PRODUCTS table ---------------------
Create Table PRODUCTS(
	product_id NUMBER,
	product_name VARCHAR(100) NOT NULL,
	category VARCHAR(50) NOT NULL,
	quantity INT CHECK (quantity>=0),
	price NUMBER CHECK (price>=0),
    PRIMARY KEY (product_id)
)
/

-- Create GRAPHICSDETAILS table
Create Table GRAPHICS_DETAILS(
	product_id NUMBER,
	model VARCHAR(100) NOT NULL,
	interface VARCHAR(10),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
)
/

-- Create RAMDETAILS table
Create Table RAM_DETAILS(
	product_id NUMBER,
	model VARCHAR(100) NOT NULL,
	memory_type VARCHAR(10) NOT NULL,
    memory_size INT NOT NULL CHECK (memory_size > 0),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
)
/

-- Create PROCESSORDETAILS table
Create Table PROCESSOR_DETAILS(
	product_id NUMBER,
	model VARCHAR(100) NOT NULL,
	socket VARCHAR(10) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
)
/

-- Create MOTHERBOARDDETAILS table
Create Table MOTHERBOARD_DETAILS(
	product_id NUMBER,
	model VARCHAR(100) NOT NULL,
	socket VARCHAR(10) NOT NULL,
	memory_type VARCHAR(10) NOT NULL,
	interface VARCHAR(10) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES PRODUCTS(product_id)
)
/

-- INSERTING DATA -----------------------------------
INSERT INTO PRODUCTS values (1,'Karta graficzna NVIDIA 3060','Graphics', 10, 3200);
INSERT INTO PRODUCTS values (2,'Procesor INTEL Core i5','Processor', 20, 6500);
INSERT INTO PRODUCTS values (3,'Pamiêæ Ram KINGSTONE','RAM', 20, 1100);
INSERT INTO PRODUCTS values (4,'P³yta g³ówna GIGABYTE B550M','Motherboard', 20, 1500);
INSERT INTO PRODUCTS values (5,'Karta graficzna RADEON RX 6600','Graphics', 20, 2000);
INSERT INTO PRODUCTS values (6,'Procesor AMD Ryzen 5','Processor', 20, 1500);
INSERT INTO PRODUCTS values (7,'Pamiêæ Ram GOODRAM','RAM', 20, 1000);
INSERT INTO PRODUCTS values (8,'P³yta g³ówna MSI Pro H510','Motherboard', 20, 10000);
INSERT INTO PRODUCTS values (9,'P³yta g³ówna MSI Pro H710','Motherboard', 0, 10000);

INSERT INTO GRAPHICS_DETAILS values (1, 'NVIDIA 3060', 'PCIe 4.0');
INSERT INTO GRAPHICS_DETAILS values (5, 'Radeon RX 6600', 'PCIe 4.0');

INSERT INTO PROCESSOR_DETAILS values (2, 'INTEL Core i5-6600', '1151');
INSERT INTO PROCESSOR_DETAILS values	(6, 'AMD Ryzen 5 7600', 'AM5');

INSERT INTO RAM_DETAILS values (3, 'Kingston FURY', 'DDR4', 8);
INSERT INTO RAM_DETAILS values (7, 'GOODRAM', 'DDR4', 8);

INSERT INTO MOTHERBOARD_DETAILS values (4, 'Gigabyte B550M','AM4', 'DDR4','PCIe 4.0');
INSERT INTO MOTHERBOARD_DETAILS values (8, 'MSI PRO H510-B', '1200','DDR4','PCIe 3.0');

