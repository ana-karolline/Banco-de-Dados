CREATE DATABASE querydinamica
GO
USE querydinamica
GO
 
CREATE TABLE produto(
idProduto INT NOT NULL,
tipo VARCHAR(100),
cor VARCHAR(50)
PRIMARY KEY(idProduto)
)
GO
CREATE TABLE camiseta(
idProduto INT NOT NULL,
tamanho VARCHAR(3)
PRIMARY KEY(idProduto)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))
GO
CREATE TABLE tenis(
idProduto INT NOT NULL,
tamanho INT
PRIMARY KEY(idProduto)
FOREIGN KEY (idProduto) REFERENCES produto(idProduto))
 
SELECT * FROM produto
SELECT * FROM tenis
SELECT * FROM camiseta
 
SELECT p.idProduto, p.cor, p.tipo, t.tamanho
FROM tenis t, produto p
WHERE p.idProduto = t.idProduto
 
SELECT p.idProduto, p.cor, p.tipo, c.tamanho
FROM camiseta c, produto p
WHERE p.idProduto = c.idProduto
 
--Query Dinâmica
--Query criada dentro de uma variável e o compilador executa o conteúdo 
--da variável
CREATE PROCEDURE sp_insereproduto(@id INT, @tipo VARCHAR(100), 
	@cor VARCHAR(50), @tamanho VARCHAR(3), @saida VARCHAR(30) OUTPUT)
AS
	DECLARE @tam		INT,
			@tabela 	VARCHAR(10),
			@erro		VARCHAR(MAX),
			@query		VARCHAR(MAX)
 
	SET @tabela = 'Tenis'
	BEGIN TRY
		SET @tam = CAST(@tamanho AS INT)
	END TRY
	BEGIN CATCH
		SET @tabela = 'Camiseta'
	END CATCH
 
	SET @query = 'INSERT INTO '+@tabela+' VALUES ('+CAST(@id AS VARCHAR(5))
					+','''+@tamanho+''')'
	PRINT @query
	BEGIN TRY
		INSERT INTO produto VALUES (@id, @tipo, @cor)
		EXEC (@query)
		SET @saida = UPPER(@tabela)+' inserido com sucesso'
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('Id duplicado', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Erro no armazenamento do produto', 16, 1)
		END
	END CATCH
 
DECLARE @out1 VARCHAR(30)
EXEC sp_insereproduto 1, 'Social', 'Marrom', 42, @out1 OUTPUT
PRINT @out1
 
DECLARE @out2 VARCHAR(30)
EXEC sp_insereproduto 101, 'Regata', 'Azul', 'GG', @out2 OUTPUT
PRINT @out2