CREATE DATABASE Hospital
GO
USE Hospital

CREATE TABLE PACIENTES (
cpf				VARCHAR(11)				NOT NULL,
nome			VARCHAR(200)			NOT NULL,
rua				VARCHAR(200)			NOT NULL,
n				INT						NOT NULL,
bairro			VARCHAR(100)			NOT NULL,
telefone		VARCHAR(20),
PRIMARY KEY (cpf) );

CREATE TABLE MEDICO (
codigo			INT							NOT NULL,
nome			VARCHAR(100)				NOT NULL,
especialidade	VARCHAR(100)				NOT NULL,
PRIMARY KEY (codigo) );

CREATE TABLE PRONTUARIO (
data_			DATE					NOT NULL,
cpf_paciente	VARCHAR(11)				NOT NULL,
codigo_medico	INT						NOT NULL,
diagnostico		VARCHAR(200)			NOT NULL,
medicamento		VARCHAR(200)			NOT NULL,
PRIMARY KEY(data_, cpf_paciente, codigo_medico),
FOREIGN KEY (cpf_paciente) REFERENCES PACIENTES(cpf),
FOREIGN KEY (codigo_medico) REFERENCES MEDICO(codigo) );
SELECT * FROM PACIENTES
SELECT * FROM MEDICO
SELECT * FROM PRONTUARIO

SELECT p.nome, p.rua, p.n, p.bairro
FROM PACIENTES p INNER JOIN PRONTUARIO pr
ON pr.cpf_paciente = p.cpf
INNER JOIN MEDICO m
ON m.codigo = pr.codigo_medico
WHERE m.especialidade LIKE '%Geriatra%'

SELECT m.nome, m.especialidade
FROM MEDICO m
WHERE m.nome LIKE '%Carolina%'

SELECT pr.medicamento, pr.diagnostico
FROM PRONTUARIO pr
WHERE pr.diagnostico LIKE '%Reumatismo%'


SELECT p.nome, p.cpf
FROM PACIENTES AS p
WHERE p.cpf LIKE '%35%'

SELECT c.cpf, SUBSTRING(c.cpf,1,3) + '-' + SUBSTRING(c.cpf,4,6) + '-' + SUBSTRING(c.cpf,7,9) + '-' + SUBSTRING (c.cpf,10,11) AS cpf_,
c.nome, c.rua, c.n, c.bairro, c.telefone
FROM PACIENTES c
WHERE c.nome LIKE '%Fulano%'
