USE testejoin

/*
Equipe
id | nome
10001	Red Bull
10002	Ferrari
10003	McLaren
10004	Lotus
10005	Mercedes
10006	Sauber
10007	Force India
10008	Williams

Motor
id | nome
9991	Renault
9992	Ferrari
9993	Mercedes
9994	Cosworth

Piloto
id | nome
256256	Sebastian Vettel
256512	Mark Webber
256768	Fernando Alonso
257024	Felipe Massa
257280	Jenson Button
257536	Sergio Perez
257792	Kimi Raikkonen
258048	Romain Grosjean
258304	Nico Rosberg
258560	Lewis Hamilton
258816	Nico Hulkenberg
259072	Esteban Gutierrez
259328	Paul di Resta
259584	Adrian Sutil
259840	Pastor Maldonado
260096	Valtieri Bottas
260352	Jean-Eric Vergne
260608	Daniel Ricciardo
260864	Charles Pic
261120	Giedo van der Garde
261376	Jules Bianchi
261632	Max Chilton
261888	Bruno Senna

carroequipepiloto
num_carro | id_piloto | id_equipe | id_motor
1	256256	10001	9991
2	256512	10001	9991
3	256768	10002	9992
4	257024	10002	9992
5	257280	10003	9993
6	257536	10003	9991
7	257792	10004	9991
8	258048	10004	9993
9	258304	10005	9993
10	258560	10005	9993
11	258816	10006	9992
12	259072	10006	9992
14	259328	10007	9993
15	259584	10007	9993
16	259840	10008	9991
17	260096	10008	9991
18	260352	10009	9992
19	260608	10009	9992
20	260864	10010	9991
21	261120	10010	9991
22	261376	10011	9994
23	261632	10011	9994
*/

SELECT * FROM equipe
SELECT * FROM motor
SELECT * FROM piloto
SELECT * FROM carroequipepiloto

/*CURSOR
DECLARE cursor CURSOR
	FOR SELECT ...
OPEN cursor
FETCH NEXT FROM cursor INTO variaveis
WHILE @@FETCH_STATUS = 0
BEGIN
	Programação
	FETCH NEXT FROM cursor INTO variaveis --Incremento do laço
END
CLOSE cursor
DEALLOCATE cursor
*/

CREATE FUNCTION fn_piloto_motor(@nome_motor VARCHAR(50))
RETURNS @tabela TABLE (
id_piloto		INT,
nome_piloto		VARCHAR(50),
nome_motor		VARCHAR(50)
)
AS
BEGIN
	DECLARE @id_piloto		INT,
			@nome_piloto	VARCHAR(50),
			@id_motor		INT
	DECLARE c_piloto CURSOR
		FOR SELECT id FROM piloto
		--FOR SELECT id, nome FROM piloto
	OPEN c_piloto
	--FETCH NEXT FROM c_piloto INTO @id_piloto, @nome_piloto
	FETCH NEXT FROM c_piloto INTO @id_piloto
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @id_motor = (SELECT id FROM motor 
			WHERE nome = @nome_motor)
		SET @nome_piloto = (SELECT p.nome AS nome_piloto
				FROM piloto p, motor m, carroequipepiloto cep
				WHERE p.id = cep.id_piloto
				AND m.id = cep.id_motor
				AND p.id = @id_piloto
				AND m.id = @id_motor)
		IF (@nome_piloto != '')
		BEGIN
			INSERT INTO @tabela VALUES
			(@id_piloto, @nome_piloto, @nome_motor)
		END
		FETCH NEXT FROM c_piloto INTO @id_piloto
		--FETCH NEXT FROM c_piloto INTO @id_piloto, @nome_piloto --Incremento
	END
	CLOSE c_piloto
	DEALLOCATE c_piloto
	
	RETURN

END

SELECT * FROM fn_piloto_motor('Cosworth')