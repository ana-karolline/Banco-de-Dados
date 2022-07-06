/*Exercício
Criar uma database chamada academia, com 3 tabelas como seguem:

Aluno
|Codigo_aluno|Nome|

Atividade
|Codigo|Descrição|IMC|

Atividade
codigo      descricao                           imc
----------- ----------------------------------- --------
1           Corrida + Step                       18.5
2           Biceps + Costas + Pernas             24.9
3           Esteira + Biceps + Costas + Pernas   29.9
4           Bicicleta + Biceps + Costas + Pernas 34.9
5           Esteira + Bicicleta                  39.9                                                                                                                                                                    

Atividadesaluno
|Codigo_aluno|Altura|Peso|IMC|Atividade|

IMC = Peso (Kg) / Altura² (M)

Atividade: Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
* Caso o IMC seja maior que 40, utilizar o código 5.

Criar uma Stored Procedure (sp_alunoatividades), com as seguintes regras:
 - Se, dos dados inseridos, o código for nulo, mas, existirem nome, altura, peso, deve-se inserir um 
 novo registro nas tabelas aluno e aluno atividade com o imc calculado e as atividades pelas 
 regras estabelecidas acima.
 - Se, dos dados inseridos, o nome for (ou não nulo), mas, existirem código, altura, peso, deve-se 
 verificar se aquele código existe na base de dados e atualizar a altura, o peso, o imc calculado e 
 as atividades pelas regras estabelecidas acima.
*/

--Exercícios :
--1) Criar um database, fazer uma tabela cadastro (cpf, nome, rua, numero e cep)
--com uma procedure que só permitirá a inserção dos dados se o CPF for válido, 
--caso contrário retornar uma mensagem de erro

CREATE DATABASE academia
GO
USE academia

CREATE TABLE Aluno (
	Codigo_aluno	INT				NOT NULL	IDENTITY,
	Nome			Varchar(60)		NOT NULL
	PRIMARY KEY (Codigo_aluno)
)

CREATE TABLE Atividade (
	Codigo			INT				NOT NULL,		
	Descricao		Varchar(60)		NOT NULL,
	IMC				DECIMAL(3,1)	NOT NULL
	PRIMARY KEY (Codigo)
)

GO
CREATE TABLE Atividades_aluno (
	Codigo_aluno	INT				NOT NULL,
	Altura			DECIMAL(3,2)	NOT NULL,
	Peso			DECIMAL(4,1)	NOT NULL,
	IMC				DECIMAL(3,1)	NOT NULL,
	Atividade		INT				NOT NULL
	PRIMARY KEY(Codigo_aluno, Atividade)
	FOREIGN KEY (Codigo_aluno) REFERENCES Aluno (Codigo_aluno),
	FOREIGN KEY (Atividade) REFERENCES Atividade (Codigo)
)

INSERT INTO Atividade VALUES
	(1, 'Corrida + Step', 18.5),
	(2, 'Biceps + Costas + Pernas', 24.9),
	(3, 'Esteira + Biceps + Costas + Pernas', 29.9),
	(4, 'Bicicleta + Biceps + Costas + Pernas', 34.9),
	(5, 'Esteira + Bicicleta', 39.9)


GO
CREATE PROCEDURE sp_calc_IMC (@peso DECIMAL(4,1), @altura DECIMAL(3,2), 
		@imc DECIMAL(3,1) OUTPUT)
AS
	SET @altura = POWER(@altura, 2)
	SET @imc = @peso / @altura


GO
CREATE PROCEDURE sp_busca_atividade (@imc DECIMAL (3,1), @atividade INT OUTPUT)
AS
SET @atividade = (SELECT Codigo FROM Atividade 
			WHERE IMC = (SELECT MAX(IMC) FROM Atividade 
			WHERE @imc >= IMC ))


GO
CREATE PROCEDURE sp_aluno_atividades (@codigo INT, @nome VARCHAR(60),
		@altura DECIMAL(3,2), @peso DECIMAL(4,1))
AS
	DECLARE @imc DECIMAL(3,1)
	DECLARE @atividade INT

	IF ((@codigo IS NOT NULL) AND (@altura IS NOT NULL) AND (@peso IS NOT NULL))
	BEGIN
		DECLARE @cont_aluno INT
		SET @cont_aluno = (SELECT COUNT(*) FROM Aluno WHERE Codigo_aluno = @codigo)
		
		IF (@cont_aluno = 1) 
		BEGIN
			EXEC sp_calc_IMC @peso, @altura, @imc OUTPUT
			Exec sp_busca_atividade @imc, @atividade OUTPUT
			UPDATE Atividades_aluno
				SET Altura = @altura, Peso = @peso, IMC = @imc, Atividade = @atividade
				WHERE Codigo_aluno = @codigo
		END
		ELSE
		BEGIN
			RAISERROR('Código inválido', 16, 1)
		END
	END
	ELSE
	BEGIN
		IF ((@codigo IS NULL) AND (@nome IS NOT NULL) AND (@altura IS NOT NULL) AND (@peso IS NOT NULL))
		BEGIN

			EXEC sp_calc_IMC @peso, @altura, @imc OUTPUT
			Exec sp_busca_atividade @imc, @atividade OUTPUT
			INSERT INTO Aluno VALUES 
				(@nome)	
			SELECT @codigo = MAX(Codigo_aluno) FROM Aluno

			INSERT INTO Atividades_aluno VALUES
				(@codigo, @altura, @peso, @imc, @atividade)
		END
		ELSE
		BEGIN
			RAISERROR('Erro, a operação não foi realizada', 16, 1)
		END

	END


GO
EXEC sp_aluno_atividades null,'Tom', 1.65, 70.3
EXEC sp_aluno_atividades 1,null, 1.65, 67.4
EXEC sp_aluno_atividades 2,'Thiago', 1.65, null
EXEC sp_aluno_atividades null,'Bruna', null, 67.4
EXEC sp_aluno_atividades 40, 'Roberto', 1.92, 92.8

SELECT * FROM Aluno
SELECT * FROM Atividades_aluno

CREATE DATABASE ex_procedure
GO
USE ex_procedure

CREATE TABLE cadastro (
	cpf		CHAR(11)	NOT NULL	CHECK(LEN(cpf) = 11),
	nome	VARCHAR(60)	NOT NULL,
	rua		VARCHAR(60)	NOT NULL,
	numero	VARCHAR(10)	NOT NULL,
	cep		CHAR(8)		NOT NULL	CHECK(LEN(cep) = 8)
	PRIMARY KEY (cpf)
)


CREATE PROCEDURE sp_valida_cpf (@cpf CHAR(11), @saida VARCHAR(8) OUTPUT)
AS
	DECLARE @valido BIT,
			@cont INT,
			@res INT,
			@aux1 INT,
			@aux2 INT

	SET @valido = 1
	SET @cont =1

	SET @res = 0
	SET @aux1 = (CAST(SUBSTRING(@cpf, 11, 1) AS INT))

	WHILE (@cont <11)
	BEGIN
		SET	@aux2 = (CAST(SUBSTRING(@cpf, @cont, 1) AS INT))
		SET @cont = @cont + 1
		IF (@aux1 = @aux2)
		BEGIN
			SET @res = @res + 1
		END
	END
	IF (@res = 10)
	BEGIN
		SET @valido = 0
	END

	SET @aux1 = 1
	WHILE (@valido = 1 AND @aux1 <= 2)
	BEGIN
		SET @cont = 1
		SET @res = 0

		WHILE (@cont <= 8+@aux1)
		BEGIN
		SET	@res = @res + (CAST(SUBSTRING(@cpf, @cont, 1) AS INT) * ((10+@aux1)-@cont))
		SET @cont = @cont + 1
		END

		IF(@res%11 < 2)
		BEGIN
			SET @res = 0
		END
		ELSE
		BEGIN
			SET @res = 11-(@res%11)
		END

		IF(SUBSTRING(@cpf, (9+@aux1), 1) != @res)
		BEGIN
			SET @valido = 0
		END

		SET @aux1 = @aux1 + 1	
	END

	IF (@valido = 1)
	BEGIN 
		SET @saida = 'Válido'
	END
	ELSE
	BEGIN
		SET @saida = 'Inválido'
	END


CREATE PROCEDURE sp_insere_cadastro (@cpf CHAR(11), @nome VARCHAR(60),
		@rua Varchar(50), @numero VARCHAR(10), @cep CHAR(8))
AS
	DECLARE @exit VARCHAR(8)
	EXEC sp_valida_cpf @cpf, @exit OUTPUT
	IF (UPPER(SUBSTRING(@exit, 1,1)) = 'V')
	BEGIN
		INSERT INTO cadastro VALUES
			(@cpf, @nome, @rua, @numero, @cep)
	END
	ELSE
	BEGIN
		RAISERROR('CPF inválido', 16, 1)
	END


-----------------------------------------------------------------------------------------------------------------

