-- script_bd.sql
-- Estrutura do banco de dados para a aplica��o RadarMottuAPI
-- Desenvolvido para a Sprint 3 - DevOps Tools & Cloud Computing (FIAP)

-- ==============================
-- TABELA: Estacionamentos
-- ==============================
CREATE TABLE Estacionamentos (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Nome TEXT NOT NULL, -- Nome do estacionamento (Ex: P�tio Zona Sul)
    Endereco TEXT NOT NULL, -- Endere�o f�sico do estacionamento
    Capacidade INTEGER NOT NULL, -- N�mero m�ximo de motos que o p�tio suporta
    Tipo TEXT NOT NULL, -- Tipo de estacionamento: Coberto ou Descoberto
    Ativo BOOLEAN NOT NULL -- Indica se o estacionamento est� ativo (true/false)
);

-- ==============================
-- TABELA: Motos
-- ==============================
CREATE TABLE Motos (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Placa TEXT NOT NULL, -- Placa da moto (Ex: ABC1234)
    Marca TEXT NOT NULL, -- Marca da moto (Ex: Honda)
    Modelo TEXT NOT NULL, -- Modelo da moto (Ex: CG 160)
    Ano INTEGER NOT NULL, -- Ano de fabrica��o (Ex: 2020)
    EstacionamentoId INTEGER NOT NULL, -- Chave estrangeira para o estacionamento
    FOREIGN KEY (EstacionamentoId) REFERENCES Estacionamentos(Id) ON DELETE CASCADE
);

-- ==============================
-- TABELA: Posicionamentos
-- ==============================
CREATE TABLE Posicionamentos (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    MotoId INTEGER NOT NULL, -- Chave estrangeira para a moto
    Latitude REAL NOT NULL, -- Latitude da posi��o registrada
    Longitude REAL NOT NULL, -- Longitude da posi��o registrada
    DataHora TEXT NOT NULL, -- Data e hora do posicionamento (formato ISO 8601)
    FOREIGN KEY (MotoId) REFERENCES Motos(Id) ON DELETE CASCADE
);

-- ==============================
-- �NDICES
-- ==============================
CREATE INDEX IX_Motos_EstacionamentoId ON Motos (EstacionamentoId);
CREATE INDEX IX_Posicionamentos_MotoId ON Posicionamentos (MotoId);