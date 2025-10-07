
-- Create sequences used for primary keys
CREATE SEQUENCE SENSOR_SEQ
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
GO

CREATE SEQUENCE REGIAO_SEQ
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
GO

CREATE SEQUENCE ALERTA_SEQ
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
GO

CREATE SEQUENCE USUARIO_SEQ
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
GO

-- Table: tb_aqua_sensor
CREATE TABLE tb_aqua_sensor (
    id_sensor BIGINT NOT NULL PRIMARY KEY DEFAULT NEXT VALUE FOR SENSOR_SEQ,
    tipo      VARCHAR(50) NOT NULL,
    status    VARCHAR(20) NOT NULL
);
GO

-- Table: tb_aqua_usuario
CREATE TABLE tb_aqua_usuario (
    id_usuario    BIGINT NOT NULL PRIMARY KEY DEFAULT NEXT VALUE FOR USUARIO_SEQ,
    nome_usuario  VARCHAR(100) NOT NULL,
    telefone      VARCHAR(15) NULL,
    email         VARCHAR(50) NOT NULL,
    senha         VARCHAR(50) NOT NULL,
    permissao     VARCHAR(50) NOT NULL,
    CONSTRAINT uq_tb_aqua_usuario_email UNIQUE (email),
    CONSTRAINT uq_tb_aqua_usuario_telefone UNIQUE (telefone)
);
GO

-- Table: tb_aqua_regiao
CREATE TABLE tb_aqua_regiao (
    id_regiao        BIGINT NOT NULL PRIMARY KEY DEFAULT NEXT VALUE FOR REGIAO_SEQ,
    nm_regiao        VARCHAR(50) NOT NULL,
    nm_cidade        VARCHAR(50) NOT NULL,
    coordenadas_lat  VARCHAR(50) NULL,
    coordenadas_lng  VARCHAR(50) NULL,
    id_sensor        BIGINT NOT NULL,
    CONSTRAINT fk_regiao_sensor FOREIGN KEY (id_sensor)
        REFERENCES tb_aqua_sensor (id_sensor)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
GO

-- Table: tb_aqua_alerta
CREATE TABLE tb_aqua_alerta (
    id_alerta    BIGINT NOT NULL PRIMARY KEY DEFAULT NEXT VALUE FOR ALERTA_SEQ,
    nivel_risco  VARCHAR(50) NOT NULL,
    ds_alerta    VARCHAR(50) NULL,
    dt_alerta    DATE NULL,
    id_regiao    BIGINT NOT NULL,
    CONSTRAINT fk_alerta_regiao FOREIGN KEY (id_regiao)
        REFERENCES tb_aqua_regiao (id_regiao)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);
GO