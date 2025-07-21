CREATE DATABASE Usuario;

USE Usuario;

-- Criação das tabelas:

CREATE TABLE Obra(
	id_obra INT AUTO_INCREMENT NOT NULL,
    nome_obra VARCHAR(255),
    genero VARCHAR(255),
    PRIMARY KEY(id_obra)
);

CREATE TABLE Episodio(
	id_ep INT AUTO_INCREMENT NOT NULL,
    nome_ep VARCHAR(255),
    id_obra INT NOT NULL,
    temporada VARCHAR(255),
    FOREIGN KEY(id_obra)
		REFERENCES Obra(id_obra),
	PRIMARY KEY(id_ep)
);

CREATE TABLE _Data_(
	data_assist DATE,
    dia_semana VARCHAR(15),
    PRIMARY KEY(data_assist)
);

CREATE TABLE Assistencia(
	id_assist INT AUTO_INCREMENT NOT NULL,
    id_ep INT NOT NULL,
    data_assist DATE NOT NULL,
    tempo TIME NOT NULL,
    id_obra INT NOT NULL,
    FOREIGN KEY(data_assist)
		REFERENCES _Data_(data_assist),
	FOREIGN KEY(id_ep)
		REFERENCES Episodio(id_ep),
	FOREIGN KEY(id_obra)
		REFERENCES Obra (id_obra),
	PRIMARY KEY(id_assist)
);

USE Usuario;

DELIMITER //
CREATE TRIGGER t_id_obra_insert
	BEFORE INSERT ON Assistencia
    FOR EACH ROW
    BEGIN
		DECLARE id_obra_correto INT;
        SELECT id_obra INTO id_obra_correto
			FROM Episodio WHERE id_ep = NEW.id_ep;
		IF NEW.id_obra IS NULL OR id_obra_correto IS NULL OR NEW.id_obra <> id_obra_correto
			THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro de integridade: O id_obra inserido na tabela Assitencia deve ser igual ao id_obra da tabela Episodio.';
		END IF;
	END//

CREATE TRIGGER t_id_obra_update
    BEFORE UPDATE ON Assistencia
    FOR EACH ROW
    BEGIN
		DECLARE id_obra_correto INT;
        IF NEW.id_obra <> OLD.id_obra OR NEW.id_ep <> OLD.id_ep THEN
            SELECT id_obra INTO id_obra_correto
                FROM Episodio WHERE id_ep = NEW.id_ep;
            IF NEW.id_obra IS NULL OR id_obra_correto IS NULL OR NEW.id_obra <> id_obra_correto
                THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro de integridade: O id_obra da assistência deve corresponder ao id_obra do episódio associado.';
            END IF;
        END IF;
    END//

DELIMITER ;