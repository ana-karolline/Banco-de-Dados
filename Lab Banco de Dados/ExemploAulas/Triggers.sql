/*
TRIGGERS - Gatilhos
 
TRIGGER AFTER - Subrotina que roda após um comando DML
 
CREATE TRIGGER t_nome ON tabela
AFTER (ou FOR) INSERT, UPDATE, DELETE
AS
BEGIN
	Programação
END
 
TRIGGER INSTEAD OF - Subrotina que substitui o comando DML
CREATE TRIGGER t_nome ON tabela
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
	Programação
END
 
INSERTED / DELETED
*/
 
CREATE DATABASE aulatriggers03
GO
USE aulatriggers03
GO
CREATE TABLE servico(
id		INT				NOT NULL,
nome	VARCHAR(100)	NULL,
preco	DECIMAL(7,2)	NULL
PRIMARY KEY(id))
GO
CREATE TABLE depto(
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NULL,
total_salarios	DECIMAL(7,2)	NULL
PRIMARY KEY(codigo))
GO
CREATE TABLE funcionario(
id					INT				NOT NULL,
nome				VARCHAR(100)	NULL,
salario				DECIMAL(7,2)	NULL,
depto 				INT				NOT NULL
PRIMARY KEY(id)
FOREIGN KEY(depto) REFERENCES depto(codigo))
GO
INSERT INTO servico VALUES
(1, 'Orçamento', 20.00),
(2, 'Manutenção preventiva', 85.00)
GO
INSERT INTO depto (codigo, nome) VALUES
(1,'RH'),
(2,'DTI')
 
SELECT * FROM servico
 
CREATE TRIGGER t_insupdtdlt ON servico
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	SELECT * FROM INSERTED
	SELECT * FROM DELETED
END
 
INSERT INTO servico VALUES
(3, 'Limpeza', 120.00)
 
UPDATE servico
SET nome = 'Limpeza Corretiva', preco = 150.00
WHERE id = 3
 
DELETE servico
WHERE id = 3
 
--Exclui a trigger
DROP TRIGGER t_insupdtdlt
 
--Desabilita a Trigger
DISABLE TRIGGER t_insupdtdlt ON servico
 
--Habilita a Trigger
ENABLE TRIGGER t_insupdtdlt ON servico
 
/* REGRA 01
O preço de um serviço não pode ser modificado
Serviços podem ser cadastrados e excluídos, mas não modificados
*/
CREATE TRIGGER t_updtservico ON servico
AFTER UPDATE
AS
BEGIN
	ROLLBACK TRANSACTION --Desfaz o último comando DML
	RAISERROR('Não é permitido alterar serviços', 16, 1)
END
 
/* REGRA 01 Modificada
O preço de um serviço só pode ser modificado se for maior 
que o anterior
*/
DISABLE TRIGGER t_updtservico ON servico
 
CREATE TRIGGER t_updtservicomaior ON servico
INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @precovelho	DECIMAL(7,2),
			@preconovo	DECIMAL(7,2),
			@id			INT
	SET @precovelho = (SELECT preco FROM DELETED)
	SET @preconovo = (SELECT preco FROM INSERTED)
	IF (@preconovo > @precovelho)
	BEGIN
		SET @id = (SELECT id FROM INSERTED)
		DELETE servico WHERE id = @id
		INSERT INTO servico
			SELECT id, nome, preco FROM INSERTED
	END
	ELSE
	BEGIN
		RAISERROR('O novo valor deve ser maior que o antigo',16,1)
	END
END
 
UPDATE servico
SET nome = 'Limpeza Corretiva', preco = 150.00
WHERE id = 3
 
UPDATE servico
SET preco = 120.00
WHERE id = 3
 
/*REGRA 02
	Cada depto tem um budget, portanto, a somatória dos salários
	dos funcionários de cada depto deve ser armazenada na tabela
	depto coluna total_salarios.
	Caso um novo funcionário entre no depto, o salário dele deve
	ser atualizado na tabela depto. Caso um funcionário receba 
	aumento ou decréscimo de salário, a tabela depto deve ser 
	atualizada. O mesmo vale, reduzindo o valor na tabela depto
	se algum funcionário for demitido.
*/
CREATE TRIGGER t_salarios ON funcionario
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @salario	DECIMAL(7,2),
			@cod_depto	INT,
			@inserido	INT,
			@deletado	INT,
			@total_sal	DECIMAL(7,2)
	SET @inserido = (SELECT COUNT(*) FROM INSERTED)
	SET @deletado = (SELECT COUNT(*) FROM DELETED)
	SET @salario = 0
	IF (@inserido > 0)
	BEGIN
		SET @salario = @salario + (SELECT salario FROM INSERTED)
		SET @cod_depto = (SELECT depto FROM INSERTED)
	END
	IF (@deletado > 0)
	BEGIN
		SET @salario = @salario - (SELECT salario FROM DELETED)
		IF (@cod_depto IS NULL)
		BEGIN
			SET @cod_depto = (SELECT depto FROM DELETED)
		END
	END
 
	SET @total_sal = (SELECT total_salarios FROM DEPTO 
						WHERE codigo = @cod_depto)
 
	IF (@total_sal IS NULL)
	BEGIN
		UPDATE depto
			SET total_salarios = @salario
			WHERE codigo = @cod_depto		
	END
	ELSE
	BEGIN
		UPDATE depto
			SET total_salarios = total_salarios + @salario
			WHERE codigo = @cod_depto
	END
END
 
SELECT * FROM funcionario
SELECT * FROM depto
 
INSERT INTO funcionario VALUES
(101, 'Fulano de Tal', 3265.18, 2)
 
INSERT INTO funcionario VALUES
(102, 'Beltrano de Tal', 3000.00, 2)
 
UPDATE funcionario
SET salario = 4000.00
WHERE id = 102
