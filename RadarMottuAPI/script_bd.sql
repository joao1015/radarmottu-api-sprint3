-- script_bd.sql
-- Estrutura do banco de dados para a aplicação RadarMottuAPI
-- Desenvolvido para a Sprint 3 - DevOps Tools & Cloud Computing (FIAP)

-- ==============================
-- TABELA: Estacionamentos
-- ==============================
CREATE TABLE Estacionamentos (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Nome TEXT NOT NULL, -- Nome do estacionamento (Ex: Pátio Zona Sul)
    Endereco TEXT NOT NULL, -- Endereço físico do estacionamento
    Capacidade INTEGER NOT NULL, -- Número máximo de motos que o pátio suporta
    Tipo TEXT NOT NULL, -- Tipo de estacionamento: Coberto ou Descoberto
    Ativo BOOLEAN NOT NULL -- Indica se o estacionamento está ativo (true/false)
);

-- ==============================
-- TABELA: Motos
-- ==============================
CREATE TABLE Motos (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Placa TEXT NOT NULL, -- Placa da moto (Ex: ABC1234)
    Marca TEXT NOT NULL, -- Marca da moto (Ex: Honda)
    Modelo TEXT NOT NULL, -- Modelo da moto (Ex: CG 160)
    Ano INTEGER NOT NULL, -- Ano de fabricação (Ex: 2020)
    EstacionamentoId INTEGER NOT NULL, -- Chave estrangeira para o estacionamento
    FOREIGN KEY (EstacionamentoId) REFERENCES Estacionamentos(Id) ON DELETE CASCADE
);

-- ==============================
-- TABELA: Posicionamentos
-- ==============================
CREATE TABLE Posicionamentos (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    MotoId INTEGER NOT NULL, -- Chave estrangeira para a moto
    Latitude REAL NOT NULL, -- Latitude da posição registrada
    Longitude REAL NOT NULL, -- Longitude da posição registrada
    DataHora TEXT NOT NULL, -- Data e hora do posicionamento (formato ISO 8601)
    FOREIGN KEY (MotoId) REFERENCES Motos(Id) ON DELETE CASCADE
);

-- ==============================
-- ÍNDICES
-- ==============================
CREATE INDEX IX_Motos_EstacionamentoId ON Motos (EstacionamentoId);
CREATE INDEX IX_Posicionamentos_MotoId ON Posicionamentos (MotoId);