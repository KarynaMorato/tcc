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

-- Tabela Servico
CREATE TABLE IF NOT EXISTS Servico (
    CodServico INT AUTO_INCREMENT PRIMARY KEY,
	CodEmpresa INT,
    Descricao TEXT,
    UnidadeMedida VARCHAR(20),
    Valor DECIMAL(10, 2),
	FOREIGN KEY (CodEmpresa) REFERENCES Empresa(CodEmpresa)
);

-- Tabela StausServico
CREATE TABLE IF NOT EXISTS StausServico (
    CodStausServico INT AUTO_INCREMENT PRIMARY KEY,
    Descricao TEXT
);

-- Tabela PerfilUsuario
CREATE TABLE IF NOT EXISTS PerfilUsuario (
    CodPerfilUsuario INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL
);

-- Tabela Usuario
CREATE TABLE IF NOT EXISTS Usuario (
    CPF VARCHAR(11) PRIMARY KEY,
    CodPerfilUsuario INT,
    Senha VARCHAR(255) NOT NULL,
    FOREIGN KEY (CodPerfilUsuario) REFERENCES PerfilUsuario(CodPerfilUsuario)
);

-- Tabela Empresa
CREATE TABLE IF NOT EXISTS Empresa (
    CodEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    CNPJ VARCHAR(14) NOT NULL,
    Telefone VARCHAR(20),
    Endereco VARCHAR(255)
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

-- CRIAÇÃO PROCEDURES
-- PRC USUARIO
-- Inserir Usuario
CREATE PROCEDURE InserirUsuario(
    IN p_CPF VARCHAR(11),
    IN p_CodPerfilUsuario INT,
    IN p_Senha VARCHAR(255)
)
BEGIN
    INSERT INTO Usuario (CPF, CodPerfilUsuario, Senha)
    VALUES (p_CPF, p_CodPerfilUsuario, p_Senha);
END 

-- Listar Usuario
CREATE PROCEDURE ListarUsuario()
BEGIN
    SELECT * FROM Usuario;
END 

-- Ler Usuario por CPF
CREATE PROCEDURE LerUsuarioPorCPF(
    IN p_CPF VARCHAR(11)
)
BEGIN
    SELECT CPF, CodPerfilUsuario, Senha
    FROM Usuario
    WHERE CPF = p_CPF;
END 

-- Atualizar Usuario
CREATE PROCEDURE AtualizarUsuario(
    IN p_CPF VARCHAR(11),
    IN p_CodPerfilUsuario INT,
    IN p_Senha VARCHAR(255)
)
BEGIN
    UPDATE Usuario
    SET CodPerfilUsuario = p_CodPerfilUsuario, Senha = p_Senha
    WHERE CPF = p_CPF;
END 

-- Excluir Usuario
CREATE PROCEDURE ExcluirUsuario(
    IN p_CPF VARCHAR(11)
)
BEGIN
    DELETE FROM Usuario
    WHERE CPF = p_CPF;
END 

-- PRC_STATUSsERVICO
-- Inserir StausServico
CREATE PROCEDURE InserirStausServico(
    IN p_Descricao TEXT
)
BEGIN
    INSERT INTO StausServico (Descricao)
    VALUES (p_Descricao);
END 

-- Listar StausServico
CREATE PROCEDURE ListarStausServico()
BEGIN
    SELECT * FROM StausServico;
END 

-- Ler StausServico por PK
CREATE PROCEDURE LerStausServicoPorCodigo(
    IN p_CodStausServico INT
)
BEGIN
    SELECT CodStausServico, Descricao
    FROM StausServico
    WHERE CodStausServico = p_CodStausServico;
END 

-- Atualizar StausServico
CREATE PROCEDURE AtualizarStausServico(
    IN p_CodStausServico INT,
    IN p_Descricao TEXT
)
BEGIN
    UPDATE StausServico
    SET Descricao = p_Descricao
    WHERE CodStausServico = p_CodStausServico;
END 

-- Excluir StausServico
CREATE PROCEDURE ExcluirStausServico(
    IN p_CodStausServico INT
)
BEGIN
    DELETE FROM StausServico
    WHERE CodStausServico = p_CodStausServico;
END 

-- PRC_SERVICO
-- Inserir Servico
CREATE PROCEDURE InserirServico(
    IN p_Descricao TEXT,
    IN p_UnidadeMedida VARCHAR(20),
    IN p_Valor DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Servico (Descricao, UnidadeMedida, Valor)
    VALUES (p_Descricao, p_UnidadeMedida, p_Valor);
END 

-- Listar Servico
CREATE PROCEDURE ListarServico()
BEGIN
    SELECT * FROM Servico;
END 

-- Ler Servico por PK
CREATE PROCEDURE LerServicoPorCodigo(
    IN p_CodServico INT
)
BEGIN
    SELECT CodServico, Descricao, UnidadeMedida, Valor
    FROM Servico
    WHERE CodServico = p_CodServico;
END 

-- Atualizar Servico
CREATE PROCEDURE AtualizarServico(
    IN p_CodServico INT,
    IN p_Descricao TEXT,
    IN p_UnidadeMedida VARCHAR(20),
    IN p_Valor DECIMAL(10, 2)
)
BEGIN
    UPDATE Servico
    SET Descricao = p_Descricao, UnidadeMedida = p_UnidadeMedida, Valor = p_Valor
    WHERE CodServico = p_CodServico;
END 

-- Excluir Servico
CREATE PROCEDURE ExcluirServico(
    IN p_CodServico INT
)
BEGIN
    DELETE FROM Servico
    WHERE CodServico = p_CodServico;
END 

-- PRC_PERFILUSUARIO
-- Inserir PerfilUsuario
CREATE PROCEDURE InserirPerfilUsuario(
    IN p_Nome VARCHAR(50)
)
BEGIN
    INSERT INTO PerfilUsuario (Nome)
    VALUES (p_Nome);
END 

-- Listar PerfilUsuario
CREATE PROCEDURE ListarPerfilUsuario()
BEGIN
    SELECT * FROM PerfilUsuario;
END 

-- Ler PerfilUsuario por PK
CREATE PROCEDURE LerPerfilUsuarioPorCodigo(
    IN p_CodPerfilUsuario INT
)
BEGIN
    SELECT CodPerfilUsuario, Nome
    FROM PerfilUsuario
    WHERE CodPerfilUsuario = p_CodPerfilUsuario;
END 

-- Atualizar PerfilUsuario
CREATE PROCEDURE AtualizarPerfilUsuario(
    IN p_CodPerfilUsuario INT,
    IN p_Nome VARCHAR(50)
)
BEGIN
    UPDATE PerfilUsuario
    SET Nome = p_Nome
    WHERE CodPerfilUsuario = p_CodPerfilUsuario;
END 

-- Excluir PerfilUsuario
CREATE PROCEDURE ExcluirPerfilUsuario(
    IN p_CodPerfilUsuario INT
)
BEGIN
    DELETE FROM PerfilUsuario
    WHERE CodPerfilUsuario = p_CodPerfilUsuario;
END 

-- PRC_ORCAMENTOSERVICO
-- Inserir OrcamentoServicos
CREATE PROCEDURE InserirOrcamentoServicos(
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
END 

-- Listar OrcamentoServicos
CREATE PROCEDURE ListarOrcamentoServicos()
BEGIN
    SELECT * FROM OrcamentoServicos;
END 

-- Ler OrcamentoServicos por PK
CREATE PROCEDURE LerOrcamentoServicosPorCodigo(
    IN p_CodOrcamentoServicos INT
)
BEGIN
    SELECT *
    FROM OrcamentoServicos
    WHERE CodOrcamentoServicos = p_CodOrcamentoServicos;
END 

-- Ler OrcamentoServicos por FK
CREATE PROCEDURE LerOrcamentoServicosPorCodigoServico(
    IN p_CodServico INT
)
BEGIN
    SELECT *
    FROM OrcamentoServicos
    WHERE CodServico = p_CodServico;
END 

-- Atualizar OrcamentoServicos
CREATE PROCEDURE AtualizarOrcamentoServicos(
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
END 

-- Excluir OrcamentoServicos
CREATE PROCEDURE ExcluirOrcamentoServicos(
    IN p_CodOrcamentoServicos INT
)
BEGIN
    DELETE FROM OrcamentoServicos
    WHERE CodOrcamentoServicos = p_CodOrcamentoServicos;
END 

-- PRC_ORCAMENTO
-- Inserir Orcamento
CREATE PROCEDURE InserirOrcamento(
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
END 

-- Listar Orcamento
CREATE PROCEDURE ListarOrcamento()
BEGIN
    SELECT * FROM Orcamento;
END 

-- Ler Orcamento por PK
CREATE PROCEDURE LerOrcamentoPorCodigo(
    IN p_CodOrcamento INT
)
BEGIN
    SELECT *
    FROM Orcamento
    WHERE CodOrcamento = p_CodOrcamento;
END 

-- Atualizar Orcamento
CREATE PROCEDURE AtualizarOrcamento(
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
END 

-- Excluir Orcamento
CREATE PROCEDURE ExcluirOrcamento(
    IN p_CodOrcamento INT
)
BEGIN
    DELETE FROM Orcamento
    WHERE CodOrcamento = p_CodOrcamento;
END 

-- PRC_EMPRESA
-- Inserir Empresa
CREATE PROCEDURE InserirEmpresa(
    IN p_Nome VARCHAR(255),
    IN p_CNPJ VARCHAR(14),
    IN p_Telefone VARCHAR(20),
    IN p_Endereco VARCHAR(255)
)
BEGIN
    INSERT INTO Empresa (Nome, CNPJ, Telefone, Endereco)
    VALUES (p_Nome, p_CNPJ, p_Telefone, p_Endereco);
END 

-- Listar Empresa
CREATE PROCEDURE ListarEmpresa()
BEGIN
    SELECT * FROM Empresa;
END 

-- Ler Empresa por PK
CREATE PROCEDURE LerEmpresaPorCodigo(
    IN p_CodEmpresa INT
)
BEGIN
    SELECT CodEmpresa, Nome, CNPJ, Telefone, Endereco
    FROM Empresa
    WHERE CodEmpresa = p_CodEmpresa;
END 

-- Atualizar Empresa
CREATE PROCEDURE AtualizarEmpresa(
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
END 

-- Excluir Empresa
CREATE PROCEDURE ExcluirEmpresa(
    IN p_CodEmpresa INT
)
BEGIN
    DELETE FROM Empresa
    WHERE CodEmpresa = p_CodEmpresa;
END 

-- PRC_CONTROLEPAGAMENTO
-- Inserir ControlePagamento
CREATE PROCEDURE InserirControlePagamento(
    IN p_CodOrcamento INT,
    IN p_DataPagamento DATE,
    IN p_Valor DECIMAL(10, 2)
)
BEGIN
    INSERT INTO ControlePagamento (CodOrcamento, DataPagamento, Valor)
    VALUES (p_CodOrcamento, p_DataPagamento, p_Valor);
END 

-- Listar ControlePagamento
CREATE PROCEDURE ListarControlePagamento()
BEGIN
    SELECT * FROM ControlePagamento;
END 

-- Ler ControlePagamento por PK
CREATE PROCEDURE LerControlePagamentoPorCodigo(
    IN p_CodControlePagamento INT
)
BEGIN
    SELECT CodControlePagamento, CodOrcamento, DataPagamento, Valor
    FROM ControlePagamento
    WHERE CodControlePagamento = p_CodControlePagamento;
END 

-- Atualizar ControlePagamento
CREATE PROCEDURE AtualizarControlePagamento(
    IN p_CodControlePagamento INT,
    IN p_CodOrcamento INT,
    IN p_DataPagamento DATE,
    IN p_Valor DECIMAL(10, 2)
)
BEGIN
    UPDATE ControlePagamento
    SET CodOrcamento = p_CodOrcamento, DataPagamento = p_DataPagamento, Valor = p_Valor
    WHERE CodControlePagamento = p_CodControlePagamento;
END 

-- Excluir ControlePagamento
CREATE PROCEDURE ExcluirControlePagamento(
    IN p_CodControlePagamento INT
)
BEGIN
    DELETE FROM ControlePagamento
    WHERE CodControlePagamento = p_CodControlePagamento;
END 

-- PRC_CLIENTES
-- Inserir Cliente
CREATE PROCEDURE InserirCliente(
    IN p_Nome VARCHAR(255),
    IN p_CPF VARCHAR(11),
    IN p_Endereco VARCHAR(255),
    IN p_Telefone VARCHAR(20)
)
BEGIN
    INSERT INTO Cliente (Nome, CPF, Endereco, Telefone)
    VALUES (p_Nome, p_CPF, p_Endereco, p_Telefone);
END 

-- Listar Cliente
CREATE PROCEDURE ListarCliente()
BEGIN
    SELECT * FROM Cliente;
END 

-- Ler Cliente por PK
CREATE PROCEDURE LerClientePorCodigo(
    IN p_CodCliente INT
)
BEGIN
    SELECT CodCliente, Nome, CPF, Endereco, Telefone
    FROM Cliente
    WHERE CodCliente = p_CodCliente;
END 

-- Atualizar Cliente
CREATE PROCEDURE AtualizarCliente(
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
END 

-- Excluir Cliente
CREATE PROCEDURE ExcluirCliente(
    IN p_CodCliente INT
)
BEGIN
    DELETE FROM Cliente
    WHERE CodCliente = p_CodCliente;
END 

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
INSERT INTO Cliente (Nome, CPF, Endereco, Telefone) 
VALUES ('Cliente Teste', '11111111111','Rua: Dos Testes 182 - Bairro - CIDADE/UF - CEP:55555-555','(11)33333-3333');

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
INSERT INTO Cliente (Nome, CPF, Endereco, Telefone) 
VALUES ('Cliente Teste', '11111111111','(11)33333-3333','Rua: Dos Testes 182 - Bairro - CIDADE/UF - CEP:55555-555');
