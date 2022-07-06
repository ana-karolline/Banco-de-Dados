CREATE DATABASE Concessionaria
GO
USE Concessionaria

CREATE TABLE CARRO (
placa		VARCHAR(7)				NOT NULL,
marca		VARCHAR(50)				NOT NULL,
modelo		VARCHAR(50)				NOT NULL,
cor			VARCHAR(50)				NOT NULL,
ano			INT						NOT NULL,
PRIMARY KEY (placa) );

CREATE TABLE CLIENTE (
nome		VARCHAR(100)			NOT NULL,
logradouro	VARCHAR(200)			NOT NULL,
n			INT						NOT NULL,
bairro		VARCHAR(100)			NOT NULL,
telefone	VARCHAR(20)				NOT NULL,
carro_placa	VARCHAR(7)				NOT NULL,
PRIMARY KEY (carro_placa),
FOREIGN KEY (carro_placa) REFERENCES CARRO(placa) );

CREATE TABLE PECAS (
codigo		INT						NOT NULL,
nome		VARCHAR(100)			NOT NULL,
valor		DECIMAL(7,2)			NOT NULL,
PRIMARY KEY (codigo) );

CREATE TABLE SERVICO (
carro		VARCHAR(7)				NOT NULL,
peca		INT						NOT NULL,
quantidade	INT						NOT NULL,
valor		DECIMAL(7,2)			NOT NULL,
data_		DATETIME				NOT NULL,
PRIMARY KEY (carro, peca, data_),
FOREIGN KEY (carro) REFERENCES CARRO(placa),
FOREIGN KEY (peca)	REFERENCES PECAS(codigo) );

SELECT * FROM CLIENTE
SELECT * FROM CARRO
SELECT * FROM PECAS
SELECT * FROM SERVICO

SELECT cli.telefone, c.marca, c.cor
FROM Concessionaria.dbo.CARRO AS c
INNER JOIN Concessionaria.dbo.CLIENTE AS cli
ON c.placa = cli.carro_placa
AND c.modelo LIKE 'Ka'
AND c.cor LIKE 'Azul'

SELECT cli.logradouro, cli.n, cli.bairro, s.data_
FROM Concessionaria.dbo.SERVICO AS s
INNER JOIN Concessionaria.dbo.CLIENTE AS cli
ON s.carro = cli.carro_placa
AND s.data_ LIKE '%2009%'

SELECT c.placa
FROM Concessionaria.dbo.CARRO AS c
WHERE (c.ano < 2001)

SELECT c.marca, c.modelo, c.cor
FROM Concessionaria.dbo.CARRO AS c
INNER JOIN Concessionaria.dbo.CARRO as cc
ON c.placa = cc.placa
WHERE (c.ano > 2005)

SELECT p.codigo, p.nome, p.valor
FROM Concessionaria.dbo.PECAS AS p
WHERE (p.valor < 80)