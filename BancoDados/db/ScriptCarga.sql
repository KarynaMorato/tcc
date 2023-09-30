-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS GestaoObra;

-- Uso do banco de dados
USE GestaoObra;

-- CRIAÇÃO TABELAS
-- Tabela Cliente
CREATE TABLE IF NOT EXISTS Cliente (
    CodCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    CPF VARCHAR(11) NOT NULL,
    Endereco VARCHAR(255),
    Telefone VARCHAR(20)
);

-- Tabela Empresa
CREATE TABLE IF NOT EXISTS Empresa (
    CodEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    CNPJ VARCHAR(14) NOT NULL,
    Telefone VARCHAR(20),
    Endereco VARCHAR(255)
);

-- Tabela PerfilUsuario
CREATE TABLE IF NOT EXISTS PerfilUsuario (
    CodPerfilUsuario INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL
);

-- Tabela StausServico
CREATE TABLE IF NOT EXISTS StausServico (
    CodStausServico INT AUTO_INCREMENT PRIMARY KEY,
    Descricao TEXT
);

-- Tabela Servico
CREATE TABLE IF NOT EXISTS Servico (
    CodServico INT AUTO_INCREMENT PRIMARY KEY,
	CodEmpresa INT,
    Descricao TEXT,
    UnidadeMedida VARCHAR(20),
    Valor DECIMAL(10, 2),
	FOREIGN KEY (CodEmpresa) REFERENCES Empresa(CodEmpresa)
);

-- Tabela Usuario
CREATE TABLE IF NOT EXISTS Usuario (
    CPF VARCHAR(11) PRIMARY KEY,
    CodPerfilUsuario INT,
    Senha VARCHAR(255) NOT NULL,
    FOREIGN KEY (CodPerfilUsuario) REFERENCES PerfilUsuario(CodPerfilUsuario)
);

-- Tabela Orcamento
CREATE TABLE IF NOT EXISTS Orcamento (
    CodOrcamento INT AUTO_INCREMENT PRIMARY KEY,
    CodEmpresa INT,
    CodCliente INT,
    DataInicio DATE,
    DataFim DATE,
    ValorTotal DECIMAL(10, 2),
    ValorRecebido DECIMAL(10, 2),
    FOREIGN KEY (CodEmpresa) REFERENCES Empresa(CodEmpresa),
    FOREIGN KEY (CodCliente) REFERENCES Cliente(CodCliente)    
);

-- Tabela OrcamentoServicos
CREATE TABLE IF NOT EXISTS OrcamentoServicos (
    CodOrcamentoServicos INT AUTO_INCREMENT PRIMARY KEY,
    CodOrcamento INT,
	CodStausServico INT,
	CodServico INT,
    Quantidade INT,
    DataInicio DATE,
    DataFim DATE,
    FOREIGN KEY (CodOrcamento) REFERENCES Orcamento(CodOrcamento),
	FOREIGN KEY (CodServico) REFERENCES Servico(CodServico),
	FOREIGN KEY (CodStausServico) REFERENCES StausServico(CodStausServico)
);

-- Tabela ControlePagamento
CREATE TABLE IF NOT EXISTS ControlePagamento (
    CodControlePagamento INT AUTO_INCREMENT PRIMARY KEY,
    CodOrcamento INT,
    DataPagamento DATE,
    Valor DECIMAL(10, 2),
    FOREIGN KEY (CodOrcamento) REFERENCES Orcamento(CodOrcamento)
);

-- INSERTS
SET character_set_client = utf8;
SET character_set_connection = utf8;
SET character_set_results = utf8;
SET collation_connection = utf8_general_ci;

-- PerfilUsuario
INSERT INTO PerfilUsuario (Nome) VALUES 
ROW('Administrador'),
ROW('Empresa'),
ROW('Operador'),
ROW('Cliente');

-- Empresa
INSERT INTO Empresa (Nome, CNPJ, Endereco, Telefone) 
VALUES ('Empresa Teste', '99999999000199','Rua: Dos Testes 99 - Bairro - CIDADE/UF - CEP:99999-999','(11)99999-9999');

-- Usuario
INSERT INTO Usuario (CPF,CodPerfilUsuario,Senha)
VALUES ('99999999999',1,'teste');

-- StausServico
INSERT INTO StausServico (Descricao) VALUES
ROW('A Fazer'),
ROW('Em Andamento'),
ROW('Aguardando Material'),
ROW('Aguardando Terceiro'),
ROW('Aguardando Outro Serviço'),
ROW('Com Problema'),
ROW('Finalizado');

-- Servico
INSERT INTO Servico (CodEmpresa, Descricao, UnidadeMedida, Valor) VALUES 
ROW(1, 'Pintura Interna', 'M²', 5),
ROW(1, 'Pintura Externa', 'M²', 7),
ROW(1, 'Fundação', 'M²', 20),
ROW(1, 'Pilares', 'M²', 15),
ROW(1, 'Vigas', 'M²', 15),
ROW(1, 'Laje', 'M²', 35),
ROW(1, 'Escada', 'M²', 8),
ROW(1, 'Paredes Chapisco', 'M²', 3),
ROW(1, 'Paredes Emboço', 'M²', 3),
ROW(1, 'Paredes Reboco', 'M²', 3),
ROW(1, 'Limpeza Caixa de Água', 'Qtd', 50),
ROW(1, 'Instalação Piso Cerâmico', 'M²', 10),
ROW(1, 'Instalação Piso Porcelanato', 'M²', 12),
ROW(1, 'Construção Telhado', 'M²', 12),
ROW(1, 'Demolição', 'M²', 7);

-- Cliente
INSERT INTO Cliente (Nome, CPF, Telefone, Endereco) 
VALUES ('Cliente Teste', '11111111111','(11)33333-3333','Rua: Dos Testes 182 - Bairro - CIDADE/UF - CEP:55555-555');


-- CRIAÇÃO PROCEDURES
-- PRC USUARIO
-- Inserir Usuario
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InserirUsuario(
    IN p_CPF VARCHAR(11),
    IN p_CodPerfilUsuario INT,
    IN p_Senha VARCHAR(255)
)
BEGIN
    INSERT INTO Usuario (CPF, CodPerfilUsuario, Senha)
    VALUES (p_CPF, p_CodPerfilUsuario, p_Senha);
END $$
DELIMITER;

-- Listar Usuario
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ListarUsuario()
BEGIN
    SELECT CPF, CodPerfilUsuario, Senha 
	FROM Usuario;
END $$
DELIMITER;

-- Ler Usuario por CPF
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerUsuarioPorCPF(
    IN p_CPF VARCHAR(11)
)
BEGIN
    SELECT CPF, CodPerfilUsuario, Senha
    FROM Usuario
    WHERE CPF = p_CPF;
END $$
DELIMITER;

-- Atualizar Usuario
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS AtualizarUsuario(
    IN p_CPF VARCHAR(11),
    IN p_CodPerfilUsuario INT,
    IN p_Senha VARCHAR(255)
)
BEGIN
    UPDATE Usuario
    SET CodPerfilUsuario = p_CodPerfilUsuario, Senha = p_Senha
    WHERE CPF = p_CPF;
END $$
DELIMITER;

-- Excluir Usuario
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ExcluirUsuario(
    IN p_CPF VARCHAR(11)
)
BEGIN
    DELETE FROM Usuario
    WHERE CPF = p_CPF;
END $$
DELIMITER;

-- PRC_STATUSSERVICO
-- Inserir StausServico
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InserirStausServico(
    IN p_Descricao TEXT
)
BEGIN
    INSERT INTO StausServico (Descricao)
    VALUES (p_Descricao);
END $$
DELIMITER;

-- Listar StausServico
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ListarStausServico()
BEGIN
    SELECT CodStausServico, Descricao 
	FROM StausServico;
END $$
DELIMITER;

-- Ler StausServico por PK
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerStausServicoPorCodigo(
    IN p_CodStausServico INT
)
BEGIN
    SELECT CodStausServico, Descricao
    FROM StausServico
    WHERE CodStausServico = p_CodStausServico;
END $$
DELIMITER;

-- Atualizar StausServico
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS AtualizarStausServico(
    IN p_CodStausServico INT,
    IN p_Descricao TEXT
)
BEGIN
    UPDATE StausServico
    SET Descricao = p_Descricao
    WHERE CodStausServico = p_CodStausServico;
END $$
DELIMITER;

-- Excluir StausServico
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ExcluirStausServico(
    IN p_CodStausServico INT
)
BEGIN
    DELETE FROM StausServico
    WHERE CodStausServico = p_CodStausServico;
END $$
DELIMITER;

-- PRC_SERVICO
-- Inserir Servico
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InserirServico(
    IN p_Descricao TEXT,
    IN p_UnidadeMedida VARCHAR(20),
    IN p_Valor DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Servico (Descricao, UnidadeMedida, Valor)
    VALUES (p_Descricao, p_UnidadeMedida, p_Valor);
END $$
DELIMITER;

-- Listar Servico
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ListarServico()
BEGIN
    SELECT CodServico, Descricao, UnidadeMedida, Valor 
	FROM Servico;
END $$
DELIMITER;

-- Ler Servico por PK
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerServicoPorCodigo(
    IN p_CodServico INT
)
BEGIN
    SELECT CodServico, Descricao, UnidadeMedida, Valor
    FROM Servico
    WHERE CodServico = p_CodServico;
END $$
DELIMITER;

-- Atualizar Servico
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS AtualizarServico(
    IN p_CodServico INT,
    IN p_Descricao TEXT,
    IN p_UnidadeMedida VARCHAR(20),
    IN p_Valor DECIMAL(10, 2)
)
BEGIN
    UPDATE Servico
    SET Descricao = p_Descricao, UnidadeMedida = p_UnidadeMedida, Valor = p_Valor
    WHERE CodServico = p_CodServico;
END $$
DELIMITER;

-- Excluir Servico
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ExcluirServico(
    IN p_CodServico INT
)
BEGIN
    DELETE FROM Servico
    WHERE CodServico = p_CodServico;
END $$
DELIMITER;

-- PRC_PERFILUSUARIO
-- Inserir PerfilUsuario
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InserirPerfilUsuario(
    IN p_Nome VARCHAR(50)
)
BEGIN
    INSERT INTO PerfilUsuario (Nome)
    VALUES (p_Nome);
END $$
DELIMITER;

-- Listar PerfilUsuario
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ListarPerfilUsuario()
BEGIN
    SELECT CodPerfilUsuario, Nome 
	FROM PerfilUsuario;
END $$
DELIMITER;

-- Ler PerfilUsuario por PK
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerPerfilUsuarioPorCodigo(
    IN p_CodPerfilUsuario INT
)
BEGIN
    SELECT CodPerfilUsuario, Nome
    FROM PerfilUsuario
    WHERE CodPerfilUsuario = p_CodPerfilUsuario;
END $$
DELIMITER;

-- Atualizar PerfilUsuario
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS AtualizarPerfilUsuario(
    IN p_CodPerfilUsuario INT,
    IN p_Nome VARCHAR(50)
)
BEGIN
    UPDATE PerfilUsuario
    SET Nome = p_Nome
    WHERE CodPerfilUsuario = p_CodPerfilUsuario;
END $$
DELIMITER;

-- Excluir PerfilUsuario
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ExcluirPerfilUsuario(
    IN p_CodPerfilUsuario INT
)
BEGIN
    DELETE FROM PerfilUsuario
    WHERE CodPerfilUsuario = p_CodPerfilUsuario;
END $$
DELIMITER;

-- PRC_ORCAMENTOSERVICO
-- Inserir OrcamentoServicos
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InserirOrcamentoServicos(
    IN p_CodOrcamento INT,
	IN p_CodServico INT,
    IN p_Quantidade INT,
	IN p_CodStausServico INT,
    IN p_DataInicio DATE,
    IN p_DataFim DATE
)
BEGIN
    INSERT INTO OrcamentoServicos (CodOrcamento, CodServico, Quantidade, CodStausServico, DataInicio, DataFim)
    VALUES (p_CodOrcamento, p_CodServico, p_Quantidade, p_CodStausServico, p_DataInicio, p_DataFim);
END $$
DELIMITER;

-- Listar OrcamentoServicos
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ListarOrcamentoServicos()
BEGIN
    SELECT CodOrcamentoServicos, CodOrcamento, CodServico, Quantidade, CodStausServico, DataInicio, DataFim 
	FROM OrcamentoServicos;
END $$
DELIMITER;

-- Ler OrcamentoServicos por PK
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerOrcamentoServicosPorCodigo(
    IN p_CodOrcamentoServicos INT
)
BEGIN
    SELECT CodOrcamentoServicos, CodOrcamento, CodServico, Quantidade, CodStausServico, DataInicio, DataFim 
    FROM OrcamentoServicos
    WHERE CodOrcamentoServicos = p_CodOrcamentoServicos;
END $$
DELIMITER;

-- Ler OrcamentoServicos por FK
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerOrcamentoServicosPorCodigoServico(
    IN p_CodServico INT
)
BEGIN
    SELECT CodOrcamentoServicos, CodOrcamento, CodServico, Quantidade, CodStausServico, DataInicio, DataFim 
    FROM OrcamentoServicos
    WHERE CodServico = p_CodServico;
END $$
DELIMITER;

-- Atualizar OrcamentoServicos
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS AtualizarOrcamentoServicos(
    IN p_CodOrcamentoServicos INT,
    IN p_CodOrcamento INT,
	IN p_CodServico INT,
    IN p_Quantidade INT,
	IN p_CodStausServico INT,
    IN p_DataInicio DATE,
    IN p_DataFim DATE
)
BEGIN
    UPDATE OrcamentoServicos
    SET CodOrcamento = p_CodOrcamento, CodServico = p_CodServico, Quantidade = p_Quantidade,
        CodStausServico = p_CodStausServico, DataInicio = p_DataInicio, DataFim = p_DataFim
    WHERE CodOrcamentoServicos = p_CodOrcamentoServicos;
END $$
DELIMITER;

-- Excluir OrcamentoServicos
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ExcluirOrcamentoServicos(
    IN p_CodOrcamentoServicos INT
)
BEGIN
    DELETE FROM OrcamentoServicos
    WHERE CodOrcamentoServicos = p_CodOrcamentoServicos;
END $$
DELIMITER;

-- PRC_ORCAMENTO
-- Inserir Orcamento
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InserirOrcamento(
    IN p_CodEmpresa INT,
    IN p_CodCliente INT,    
    IN p_DataInicio DATE,
    IN p_DataFim DATE,
    IN p_ValorTotal DECIMAL(10, 2),
    IN p_ValorRecebido DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Orcamento (CodEmpresa, CodCliente, CodStausServico, DataInicio, DataFim, ValorTotal, ValorRecebido)
    VALUES (p_CodEmpresa, p_CodCliente, p_CodStausServico, p_DataInicio, p_DataFim, p_ValorTotal, p_ValorRecebido);
END $$
DELIMITER;

-- Listar Orcamento
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ListarOrcamento()
BEGIN
    SELECT CodOrcamento, CodEmpresa, CodCliente, CodStausServico, DataInicio, DataFim, ValorTotal, ValorRecebido 
	FROM Orcamento;
END $$
DELIMITER;

-- Ler Orcamento por PK
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerOrcamentoPorCodigo(
    IN p_CodOrcamento INT
)
BEGIN
    SELECT CodOrcamento, CodEmpresa, CodCliente, CodStausServico, DataInicio, DataFim, ValorTotal, ValorRecebido
    FROM Orcamento
    WHERE CodOrcamento = p_CodOrcamento;
END $$
DELIMITER;

-- Atualizar Orcamento
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS AtualizarOrcamento(
    IN p_CodOrcamento INT,
    IN p_CodEmpresa INT,
    IN p_CodCliente INT,
    IN p_DataInicio DATE,
    IN p_DataFim DATE,
    IN p_ValorTotal DECIMAL(10, 2),
    IN p_ValorRecebido DECIMAL(10, 2)
)
BEGIN
    UPDATE Orcamento
    SET CodEmpresa = p_CodEmpresa, CodCliente = p_CodCliente, DataInicio = p_DataInicio, 
	DataFim = p_DataFim, ValorTotal = p_ValorTotal, ValorRecebido = p_ValorRecebido
    WHERE CodOrcamento = p_CodOrcamento;
END $$
DELIMITER;

-- Excluir Orcamento
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ExcluirOrcamento(
    IN p_CodOrcamento INT
)
BEGIN
    DELETE FROM Orcamento
    WHERE CodOrcamento = p_CodOrcamento;
END $$
DELIMITER;

-- PRC_EMPRESA
-- Inserir Empresa
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InserirEmpresa(
    IN p_Nome VARCHAR(255),
    IN p_CNPJ VARCHAR(14),
    IN p_Telefone VARCHAR(20),
    IN p_Endereco VARCHAR(255)
)
BEGIN
    INSERT INTO Empresa (Nome, CNPJ, Telefone, Endereco)
    VALUES (p_Nome, p_CNPJ, p_Telefone, p_Endereco);
END $$
DELIMITER;

-- Listar Empresa
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ListarEmpresa()
BEGIN
    SELECT CodEmpresa, Nome, CNPJ, Telefone, Endereco 
	FROM Empresa;
END $$
DELIMITER;

-- Ler Empresa por PK
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerEmpresaPorCodigo(
    IN p_CodEmpresa INT
)
BEGIN
    SELECT CodEmpresa, Nome, CNPJ, Telefone, Endereco
    FROM Empresa
    WHERE CodEmpresa = p_CodEmpresa;
END $$
DELIMITER;

-- Atualizar Empresa
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS AtualizarEmpresa(
    IN p_CodEmpresa INT,
    IN p_Nome VARCHAR(255),
    IN p_CNPJ VARCHAR(14),
    IN p_Telefone VARCHAR(20),
    IN p_Endereco VARCHAR(255)
)
BEGIN
    UPDATE Empresa
    SET Nome = p_Nome, CNPJ = p_CNPJ, Telefone = p_Telefone, Endereco = p_Endereco
    WHERE CodEmpresa = p_CodEmpresa;
END $$
DELIMITER;

-- Excluir Empresa
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ExcluirEmpresa(
    IN p_CodEmpresa INT
)
BEGIN
    DELETE FROM Empresa
    WHERE CodEmpresa = p_CodEmpresa;
END $$
DELIMITER;

-- PRC_CONTROLEPAGAMENTO
-- Inserir ControlePagamento
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InserirControlePagamento(
    IN p_CodOrcamento INT,
    IN p_DataPagamento DATE,
    IN p_Valor DECIMAL(10, 2)
)
BEGIN
    INSERT INTO ControlePagamento (CodOrcamento, DataPagamento, Valor)
    VALUES (p_CodOrcamento, p_DataPagamento, p_Valor);
END $$
DELIMITER;

-- Listar ControlePagamento
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ListarControlePagamento()
BEGIN
    SELECT CodControlePagamento, CodOrcamento, DataPagamento, Valor 
	FROM ControlePagamento;
END $$
DELIMITER;

-- Ler ControlePagamento por PK
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerControlePagamentoPorCodigo(
    IN p_CodControlePagamento INT
)
BEGIN
    SELECT CodControlePagamento, CodOrcamento, DataPagamento, Valor
    FROM ControlePagamento
    WHERE CodControlePagamento = p_CodControlePagamento;
END $$
DELIMITER;

-- Atualizar ControlePagamento
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS AtualizarControlePagamento(
    IN p_CodControlePagamento INT,
    IN p_CodOrcamento INT,
    IN p_DataPagamento DATE,
    IN p_Valor DECIMAL(10, 2)
)
BEGIN
    UPDATE ControlePagamento
    SET CodOrcamento = p_CodOrcamento, DataPagamento = p_DataPagamento, Valor = p_Valor
    WHERE CodControlePagamento = p_CodControlePagamento;
END $$
DELIMITER;

-- Excluir ControlePagamento
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ExcluirControlePagamento(
    IN p_CodControlePagamento INT
)
BEGIN
    DELETE FROM ControlePagamento
    WHERE CodControlePagamento = p_CodControlePagamento;
END $$
DELIMITER;

-- PRC_CLIENTES
-- Inserir Cliente
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS InserirCliente(
    IN p_Nome VARCHAR(255),
    IN p_CPF VARCHAR(11),
    IN p_Endereco VARCHAR(255),
    IN p_Telefone VARCHAR(20)
)
BEGIN
    INSERT INTO Cliente (Nome, CPF, Endereco, Telefone)
    VALUES (p_Nome, p_CPF, p_Endereco, p_Telefone);
END $$
DELIMITER;

-- Listar Cliente
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ListarCliente()
BEGIN
    SELECT CodCliente, Nome, CPF, Endereco, Telefone 
	FROM Cliente;
END $$
DELIMITER;

-- Ler Cliente por PK
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS LerClientePorCodigo(
    IN p_CodCliente INT
)
BEGIN
    SELECT CodCliente, Nome, CPF, Endereco, Telefone
    FROM Cliente
    WHERE CodCliente = p_CodCliente;
END $$
DELIMITER;

-- Atualizar Cliente
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS AtualizarCliente(
    IN p_CodCliente INT,
    IN p_Nome VARCHAR(255),
    IN p_CPF VARCHAR(11),
    IN p_Endereco VARCHAR(255),
    IN p_Telefone VARCHAR(20)
)
BEGIN
    UPDATE Cliente
    SET Nome = p_Nome, CPF = p_CPF, Endereco = p_Endereco, Telefone = p_Telefone
    WHERE CodCliente = p_CodCliente;
END $$
DELIMITER;

-- Excluir Cliente
DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS ExcluirCliente(
    IN p_CodCliente INT
)
BEGIN
    DELETE FROM Cliente
    WHERE CodCliente = p_CodCliente;
END $$

