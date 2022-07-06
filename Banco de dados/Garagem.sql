CREATE DATABASE Garagem
GO
USE Garagem

CREATE TABLE Motorista (
codigo			INT				NOT NULL,
nome			VARCHAR(200)	NOT NULL,
idade			INT				NOT NULL,
naturalidade	VARCHAR(100)	NOT NULL,
PRIMARY KEY (codigo));

CREATE TABLE Onibus (
placa			VARCHAR(20)		NOT NULL,
marca			VARCHAR(50)		NOT NULL,
ano				INT				NOT NULL,
descricao		VARCHAR(100)	NOT NULL,
PRIMARY KEY (placa));

CREATE TABLE Viagem (
codigo			INT				NOT NULL,
onibus			VARCHAR(20)		NOT NULL,
motorista		INT				NOT NULL,
hora_saida		VARCHAR(5)		NOT NULL,
hora_chegada	VARCHAR(5)		NOT NULL,
destino			VARCHAR(50)		NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (onibus) REFERENCES Onibus(placa),
FOREIGN KEY (motorista) REFERENCES Motorista(codigo));

SELECT CONVERT (CHAR(10), v.hora_chegada, 108) AS hora_chegada, CONVERT(CHAR(10), v.hora_saida,108) AS hora_saida, v.destino
FROM Viagem v

SELECT m.nome, m.codigo
FROM Motorista m
WHERE m.codigo IN
	( SELECT v.motorista
	FROM Viagem v
	WHERE v.destino LIKE '%Sorocaba%'
	);

SELECT o.descricao
FROM Onibus o
WHERE o.placa IN
	( SELECT v.onibus
	FROM Viagem v
	WHERE v.destino LIKE '%Rio de Janeiro%');

SELECT o.descricao, o.marca, o.ano
FROM Onibus o
WHERE o.placa IN
	( SELECT v.onibus
	FROM Viagem v
	WHERE v.motorista IN
	(SELECT m.codigo
	FROM Motorista m
	WHERE m.nome LIKE '%Luiz%'));