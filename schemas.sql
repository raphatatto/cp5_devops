/* =========================
   1) SEQUENCES (schema dbo)
   ========================= */
CREATE SEQUENCE dbo.SENSOR_SEQ
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
GO

CREATE SEQUENCE dbo.REGIAO_SEQ
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
GO

CREATE SEQUENCE dbo.ALERTA_SEQ
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
GO

CREATE SEQUENCE dbo.USUARIO_SEQ
    AS BIGINT
    START WITH 1
    INCREMENT BY 1;
GO


/* =========================
   2) TABELAS (schema dbo)
   ========================= */
-- Table: tb_aqua_sensor
CREATE TABLE dbo.tb_aqua_sensor (
    id_sensor BIGINT NOT NULL 
        CONSTRAINT PK_tb_aqua_sensor PRIMARY KEY
        CONSTRAINT DF_tb_aqua_sensor_id DEFAULT NEXT VALUE FOR dbo.SENSOR_SEQ,
    tipo      VARCHAR(50) NOT NULL,
    status    VARCHAR(20) NOT NULL
);
GO

-- Table: tb_aqua_usuario
CREATE TABLE dbo.tb_aqua_usuario (
    id_usuario    BIGINT NOT NULL 
        CONSTRAINT PK_tb_aqua_usuario PRIMARY KEY
        CONSTRAINT DF_tb_aqua_usuario_id DEFAULT NEXT VALUE FOR dbo.USUARIO_SEQ,
    nome_usuario  VARCHAR(100) NOT NULL,
    telefone      VARCHAR(15) NULL,
    email         VARCHAR(50) NOT NULL,
    senha         VARCHAR(50) NOT NULL,
    permissao     VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_tb_aqua_usuario_email UNIQUE (email),
    CONSTRAINT UQ_tb_aqua_usuario_telefone UNIQUE (telefone)
);
GO

-- Table: tb_aqua_regiao
CREATE TABLE dbo.tb_aqua_regiao (
    id_regiao        BIGINT NOT NULL 
        CONSTRAINT PK_tb_aqua_regiao PRIMARY KEY
        CONSTRAINT DF_tb_aqua_regiao_id DEFAULT NEXT VALUE FOR dbo.REGIAO_SEQ,
    nm_regiao        VARCHAR(50) NOT NULL,
    nm_cidade        VARCHAR(50) NOT NULL,
    coordenadas_lat  VARCHAR(50) NULL,
    coordenadas_lng  VARCHAR(50) NULL,
    id_sensor        BIGINT NOT NULL,
    CONSTRAINT FK_regiao_sensor FOREIGN KEY (id_sensor)
        REFERENCES dbo.tb_aqua_sensor (id_sensor)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
GO

-- Table: tb_aqua_alerta
CREATE TABLE dbo.tb_aqua_alerta (
    id_alerta    BIGINT NOT NULL 
        CONSTRAINT PK_tb_aqua_alerta PRIMARY KEY
        CONSTRAINT DF_tb_aqua_alerta_id DEFAULT NEXT VALUE FOR dbo.ALERTA_SEQ,
    nivel_risco  VARCHAR(50) NOT NULL,
    ds_alerta    VARCHAR(50) NULL,
    dt_alerta    DATE NULL,
    id_regiao    BIGINT NOT NULL,
    CONSTRAINT FK_alerta_regiao FOREIGN KEY (id_regiao)
        REFERENCES dbo.tb_aqua_regiao (id_regiao)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);
GO


/* =================================================================
   3) GARANTIA DOS DEFAULTS (caso o passo acima não prenda o DEFAULT)
   ================================================================= */
-- Se algum DEFAULT não ficou atrelado, os ALTER abaixo garantem:

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints dc
    JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    JOIN sys.tables t ON t.object_id = c.object_id
    WHERE t.name = 'tb_aqua_sensor' AND c.name = 'id_sensor'
)
BEGIN
    ALTER TABLE dbo.tb_aqua_sensor
      ADD CONSTRAINT DF_tb_aqua_sensor_id DEFAULT NEXT VALUE FOR dbo.SENSOR_SEQ FOR id_sensor;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints dc
    JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    JOIN sys.tables t ON t.object_id = c.object_id
    WHERE t.name = 'tb_aqua_usuario' AND c.name = 'id_usuario'
)
BEGIN
    ALTER TABLE dbo.tb_aqua_usuario
      ADD CONSTRAINT DF_tb_aqua_usuario_id DEFAULT NEXT VALUE FOR dbo.USUARIO_SEQ FOR id_usuario;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints dc
    JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    JOIN sys.tables t ON t.object_id = c.object_id
    WHERE t.name = 'tb_aqua_regiao' AND c.name = 'id_regiao'
)
BEGIN
    ALTER TABLE dbo.tb_aqua_regiao
      ADD CONSTRAINT DF_tb_aqua_regiao_id DEFAULT NEXT VALUE FOR dbo.REGIAO_SEQ FOR id_regiao;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints dc
    JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    JOIN sys.tables t ON t.object_id = c.object_id
    WHERE t.name = 'tb_aqua_alerta' AND c.name = 'id_alerta'
)
BEGIN
    ALTER TABLE dbo.tb_aqua_alerta
      ADD CONSTRAINT DF_tb_aqua_alerta_id DEFAULT NEXT VALUE FOR dbo.ALERTA_SEQ FOR id_alerta;
END
GO


/* =========================
   4) INSERTS DE EXEMPLO
   ========================= */
-- Sensores
INSERT INTO dbo.tb_aqua_sensor (tipo, status)
VALUES 
('Pluviômetro', 'Ativo'),
('Nível de Rio', 'Ativo'),
('Umidade do Solo', 'Inativo');
GO

-- Usuários
INSERT INTO dbo.tb_aqua_usuario (nome_usuario, telefone, email, senha, permissao)
VALUES
('Admin Aquaguard', '11999999999', 'admin@aquaguard.com', 'Senha123!', 'ADMIN'),
('Operador João', '11988888888', 'joao@aquaguard.com', 'Senha123!', 'OPERADOR'),
('Maria Silva', '11977777777', 'maria@aquaguard.com', 'Senha123!', 'VISUALIZADOR');
GO

-- Regiões (relacionando com sensores 1..3 recém-criados)
INSERT INTO dbo.tb_aqua_regiao (nm_regiao, nm_cidade, coordenadas_lat, coordenadas_lng, id_sensor)
VALUES
('Região Central', 'São Paulo', '-23.5505', '-46.6333', 1),
('Região Leste', 'Rio de Janeiro', '-22.9068', '-43.1729', 2),
('Região Norte', 'Manaus', '-3.1190', '-60.0217', 3);
GO

-- Alertas (relacionando com regiões 1..3)
INSERT INTO dbo.tb_aqua_alerta (nivel_risco, ds_alerta, dt_alerta, id_regiao)
VALUES
('Alto',  'Risco de enchente devido a chuvas intensas', CAST(GETDATE() AS DATE), 1),
('Médio', 'Aumento do nível do rio observado',          CAST(GETDATE() AS DATE), 2),
('Baixo', 'Umidade do solo abaixo do normal',           CAST(GETDATE() AS DATE), 3);
GO


/* =========================
   5) SELECTS DE VALIDAÇÃO
   ========================= */
-- IDs gerados pelas sequences?
SELECT * FROM dbo.tb_aqua_sensor;
SELECT * FROM dbo.tb_aqua_usuario;
SELECT * FROM dbo.tb_aqua_regiao;
SELECT * FROM dbo.tb_aqua_alerta;

-- Join completo (alerta -> regiao -> sensor)
SELECT 
  a.id_alerta, a.nivel_risco, a.ds_alerta, a.dt_alerta,
  r.id_regiao, r.nm_regiao, r.nm_cidade,
  s.id_sensor, s.tipo AS tipo_sensor, s.status AS status_sensor
FROM dbo.tb_aqua_alerta a
JOIN dbo.tb_aqua_regiao r ON r.id_regiao = a.id_regiao
JOIN dbo.tb_aqua_sensor s ON s.id_sensor = r.id_sensor;
GO
