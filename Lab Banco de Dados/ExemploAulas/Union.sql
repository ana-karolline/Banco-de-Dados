USE unionview1
 
USE [unionview1]
GO
 
CREATE TABLE [cliente](
	[id_cliente] [int] NOT NULL,
	[nome_cliente] [varchar](40) NOT NULL,
	[email_cliente] [varchar](50) NOT NULL,
	[telefone_cliente] [char](11) NOT NULL,
PRIMARY KEY ([id_cliente])
)
GO
CREATE TABLE [fornecedor](
	[id_fornecedor] [int] NOT NULL,
	[nome_fornecedor] [varchar](40) NOT NULL,
	[email_fornecedor] [varchar](50) NOT NULL,
	[telefone_fornecedor] [char](11) NOT NULL,
PRIMARY KEY ([id_fornecedor])
)
GO
CREATE TABLE [funcionario](
	[id_func] [int] NOT NULL,
	[nome_func] [varchar](100) NOT NULL,
	[salario_func] [decimal](7, 2) NULL,
	[login_func] [char](8) NULL,
	[senha_func] [char](8) NULL,
PRIMARY KEY ([id_func])
)
GO
 
 
SELECT id_cliente AS id, nome_cliente AS nome, 
	email_cliente AS email, telefone_cliente AS telefone, 'CLIENTE' AS tipo
FROM cliente
UNION --ALL mostra registros duplicados
SELECT id_fornecedor AS id, nome_fornecedor AS nome, email_fornecedor AS email, 
	telefone_fornecedor AS telefone, 'FORNECEDOR' AS tipo
FROM fornecedor
 
CREATE VIEW v_agenda
AS
SELECT id_cliente AS id, nome_cliente AS nome, 
	email_cliente AS email, telefone_cliente AS telefone, 'CLIENTE' AS tipo
FROM cliente
UNION --ALL mostra registros duplicados
SELECT id_fornecedor AS id, nome_fornecedor AS nome, email_fornecedor AS email, 
	telefone_fornecedor AS telefone, 'FORNECEDOR' AS tipo
FROM fornecedor
 
SELECT * FROM v_agenda
ORDER BY telefone
 
CREATE VIEW v_funcionario_rh
AS
SELECT id_func, nome_func, salario_func
FROM funcionario
 
SELECT * FROM v_funcionario_rh
 
INSERT INTO v_funcionario_rh VALUES 
(101, 'Fulano', 5400.00)
 
CREATE VIEW v_funcionario_ti
AS
SELECT id_func, nome_func, login_func, senha_func
FROM funcionario
 
SELECT * FROM v_funcionario_ti
 
UPDATE v_funcionario_ti
SET login_func = 'fula_emp', senha_func = '123mudar'
WHERE id_func = 101
 
SELECT * FROM funcionario
 
UPDATE fornecedor
SET id_fornecedor = id_fornecedor % 10