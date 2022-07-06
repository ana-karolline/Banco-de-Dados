CREATE DATABASE Faculdade
GO
USE Faculdade

CREATE TABLE ALUNO(
ra			INT				IDENTITY(12345,1)		NOT NULL,
nome		VARCHAR(100)							NOT NULL,
sobrenome	VARCHAR(100)							NOT NULL,
rua			VARCHAR(200)							NOT NULL,
numero		INT										NOT NULL,	
bairro		VARCHAR(100)							NOT NULL,
cep			INT										NOT NULL,
telefone	INT												,
PRIMARY KEY (ra) );

CREATE TABLE CURSOS(
codigo_curso	INT				IDENTITY			NOT NULL,
nome			VARCHAR(100)						NOT NULL,
carga_horaria	INT									NOT NULL,
turno			VARCHAR(50)							NOT NULL,
PRIMARY KEY (codigo_curso) );

CREATE TABLE DISCIPLINAS (
codigo_disciplina	INT				IDENTITY			NOT NULL,
nome				VARCHAR(100)						NOT NULL,
carga_horaria		INT									NOT NULL,
turno				VARCHAR(50)							NOT NULL,
semestre			INT									NOT NULL,
PRIMARY KEY (codigo_disciplina) );

SELECT * FROM ALUNO
SELECT * FROM CURSOS
SELECT * FROM DISCIPLINAS

SELECT ALUNO.nome, ALUNO.sobrenome
FROM Faculdade.dbo.ALUNO

SELECT ALUNO.nome, ALUNO.rua, ALUNO.numero, ALUNO.bairro, ALUNO.cep, ALUNO.telefone
FROM.Faculdade.dbo.ALUNO
WHERE telefone	IS NULL

SELECT CURSOS.nome, CURSOS.turno
FROM CURSOS
WHERE (carga_horaria = 2800)

SELECT DISCIPLINAS.semestre
FROM DISCIPLINAS
WHERE nome LIKE 'Banco%'
AND	turno LIKE 'n%'