-- script_bd.sql adaptado para Azure SQL
-- Desenvolvido para a Sprint 3 - DevOps Tools & Cloud Computing (FIAP)

-- ==============================
-- TABELA: Estacionamentos
-- ==============================
CREATE TABLE Estacionamentos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Endereco NVARCHAR(200) NOT NULL,
    Capacidade INT NOT NULL,
    Tipo NVARCHAR(50) NOT NULL,
    Ativo BIT NOT NULL
);

-- ==============================
-- TABELA: Motos
-- ==============================
CREATE TABLE Motos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Placa NVARCHAR(10) NOT NULL,
    Marca NVARCHAR(50) NOT NULL,
    Modelo NVARCHAR(50) NOT NULL,
    Ano INT NOT NULL,
    EstacionamentoId INT NOT NULL,
    FOREIGN KEY (EstacionamentoId) REFERENCES Estacionamentos(Id) ON DELETE CASCADE
);

-- ==============================
-- TABELA: Posicionamentos
-- ==============================
CREATE TABLE Posicionamentos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    MotoId INT NOT NULL,
    Latitude FLOAT NOT NULL,
    Longitude FLOAT NOT NULL,
    DataHora DATETIME NOT NULL,
    FOREIGN KEY (MotoId) REFERENCES Motos(Id) ON DELETE CASCADE
);

-- ==============================
-- ÍNDICES
-- ==============================
CREATE INDEX IX_Motos_EstacionamentoId ON Motos (EstacionamentoId);
CREATE INDEX IX_Posicionamentos_MotoId ON Posicionamentos (MotoId);
