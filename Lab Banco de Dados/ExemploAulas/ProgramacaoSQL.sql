CREATE DATABASE aulaprogsql
GO
USE aulaprogsql
 
/*
DECLARAÇÃO DE VARIÁVEIS
 
DECLARE @var TIPO
 
 
ATRIBUIÇÃO DE VARIÁVEL
 
SET @var = valor
*/
 
--Exemplo 1:
DECLARE @num1	INT,
		@num2	INT,
		@res	INT
SET @num1 = 10
SET @num2 = 2
SET @res = @num1 * @num2
PRINT @res
 
--Exemplo 2:
DECLARE @dataAtual	VARCHAR(10)--DATE
SET @dataAtual = CONVERT(CHAR(10),GETDATE(),103)
PRINT @dataAtual
 
/*
Estrutura Condicional (IF)
IF (teste_lógico)
BEGIN
 
END
ELSE
BEGIN
 
END
*/
--Exemplo 3
 
DECLARE @num INT
SET @num = 2
IF (@num % 2 = 0)
BEGIN
	PRINT 'Par'
END
ELSE
BEGIN
	PRINT 'Impar'
END
 
--Exemplo 4:
 
DECLARE @vlr INT
SET @vlr = 50
IF (@vlr > 10 AND @vlr < 100)
BEGIN
	PRINT 'Está entre 10 e 100'
END
ELSE
BEGIN
	PRINT 'Não está entre 10 e 100'
END
 
/*
Estrutura de Repetição (WHILE)
WHILE (teste_lógico)
BEGIN
 
END
*/
 
--Exemplo 5:
DECLARE @entrada	INT,
		@cont		INT,
		@resul		INT
SET @entrada = 9
SET @cont = 0
WHILE (@cont <= 10)
BEGIN
	SET @resul = @cont * @entrada
	SET @cont = @cont + 1
	PRINT @resul
END
 
--Exemplo 6:
CREATE TABLE pessoa (
id		INT			NOT NULL,
nome	VARCHAR(30)	NOT NULL
PRIMARY KEY (id)
)
 
DECLARE @id	INT
SET @id = 1
WHILE (@id < 150)
BEGIN
	INSERT INTO pessoa VALUES
	(@id, 'Pessoa '+CAST(@id AS VARCHAR(3)))
 
	SET @id = @id + 1
END
 
SELECT * FROM pessoa 
 
--Exemplo 7:
DECLARE @nomePessoa	VARCHAR(30)
SET @nomePessoa = (SELECT nome FROM pessoa WHERE id = 67)
PRINT @nomePessoa
 
 
DECLARE @idPess		INT,
		@nomePess	VARCHAR(30)
SELECT @idPess = id, @nomePess = nome FROM pessoa WHERE id = 34
PRINT @idPess
PRINT @nomePess
 
 
 