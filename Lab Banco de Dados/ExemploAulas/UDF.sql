/*
USER DEFINED FUNCTIONS (UDF)
	Tipos:
		Scalar Function (Ret. Valor Escalar)
		Inline Table (Retorna a saída de um select - Comportamento semelhante a view)
		Multi Statement Table (Retornam uma tabela montada dentra da UDF)
 
	Limitações:
		Não permitem DDL
		Não permitem Raise Error
	Características:
		São acessadas por select (Retornam ResultSet)
		Pode fazer Join com qualquer select
	Sintaxe:
	CREATE (ALTER / DROP) FUNCTION fn_nome(params)
	RETURNS tipo
	AS
	BEGIN
		Programação
		RETURN (variável se escalar)
	END
*/
CREATE DATABASE functions3
GO
USE functions3
GO
CREATE TABLE aluno (
cod			INT				NOT NULL,
nome		VARCHAR(100)	NOT NULL,
altura		DECIMAL(7,2)	NOT NULL,
peso		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (cod)
)
GO
INSERT INTO aluno VALUES
(1, 'Fulano', 1.70, 95.2),
(2, 'Beltrano', 1.90, 82.7),
(3, 'Cicrano', 1.95, 103.1)
 
SELECT * FROM aluno
 
/*
Exemplo 1:
Criar uma Scalar Function que dado o cod do aluno retorne seu IMC
IMC = Peso / Altura²
 
Exemplo 2:
Criar uma Multi Statement Table Function que retorne:
(cod | nome | altura | peso | IMC | Condição)
 
Condição:
Classificação			IMC
Muito abaixo do peso	abaixo de 16,9 kg/m2	
Abaixo do peso			17 a 18,4 kg/m2	
Peso normal				18,5 a 24,9 kg/m2
Acima do peso			25 a 29,9 kg/m2	
Obesidade Grau I		30 a 34,9 kg/m2	
Obesidade Grau II		35 a 40 kg/m2		
Obesidade Grau III		acima de 40 kg/m2
*/
--Exemplo 1:
CREATE FUNCTION fn_imc(@cod INT)
RETURNS DECIMAL(7,1)
AS
BEGIN
	DECLARE @alt	DECIMAL(7,2),
			@peso	DECIMAL(7,2),
			@imc	DECIMAL(7,1)
	/*
	SET @alt = (SELECT altura FROM aluno WHERE cod = @cod)
	SET @peso = (SELECT peso FROM aluno WHERE cod = @cod)
	*/
	IF (@cod > 0)
	BEGIN
		SELECT @alt = altura, @peso = peso FROM aluno WHERE cod = @cod
		SET @imc = @peso / POWER(@alt, 2)
	END
	RETURN (@imc)
END
 
SELECT dbo.fn_imc(3) AS IMC
 
--Exemplo 2:
CREATE FUNCTION fn_tableimc()
RETURNS @tabela TABLE (
cod			INT,
nome		VARCHAR(100),
altura		DECIMAL(7,2),
peso		DECIMAL(7,2),
imc			DECIMAL(7,1),
condicao	VARCHAR(22)
)
AS
BEGIN
	INSERT INTO @tabela (cod, nome, altura, peso)
	SELECT cod, nome, altura, peso FROM aluno
 
	UPDATE @tabela
	SET imc = (SELECT dbo.fn_imc(cod))
 
	UPDATE @tabela 
	SET condicao = 'Muito abaixo do peso'
	WHERE imc < 17
 
	UPDATE @tabela 
	SET condicao = 'Abaixo do peso'
	WHERE imc >= 17 AND imc < 18.5
 
	UPDATE @tabela 
	SET condicao = 'Peso normal'
	WHERE imc >= 18.5 AND imc < 25
 
	UPDATE @tabela 
	SET condicao = 'Acima do peso'
	WHERE imc >= 25 AND imc < 30
 
	UPDATE @tabela 
	SET condicao = 'Obesidade Grau I'
	WHERE imc >= 30 AND imc < 35
 
	UPDATE @tabela 
	SET condicao = 'Obesidade Grau II'
	WHERE imc >= 35 AND imc < 40
 
	UPDATE @tabela 
	SET condicao = 'Obesidade Grau III'
	WHERE imc >= 40
 
	RETURN
END
 
/*
Condição:
Classificação			IMC
Muito abaixo do peso	abaixo de 16,9 kg/m2	
Abaixo do peso			17 a 18,4 kg/m2	
Peso normal				18,5 a 24,9 kg/m2
Acima do peso			25 a 29,9 kg/m2	
Obesidade Grau I		30 a 34,9 kg/m2	
Obesidade Grau II		35 a 40 kg/m2		
Obesidade Grau III		acima de 40 kg/m2
*/
 
SELECT * FROM fn_tableimc()
 
SELECT cod, nome, CAST(imc AS INT) AS imc_int 
FROM fn_tableimc()