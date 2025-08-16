DROP DATABASE IF EXISTS safe_talk;

CREATE DATABASE safe_talk CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE safe_talk;

-- Endereço
CREATE TABLE endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    cep CHAR(9) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

-- Responsável
CREATE TABLE responsavel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    parentesco ENUM('PAI', 'MAE', 'TUTOR', 'OUTRO') NOT NULL
);

-- Usuário
CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    cargo ENUM(
        'UNIDADE_ENSINO',
        'ANALISTA',
        'PEDAGOGO',
        'ALUNO'
    )
);

-- Usuário/Aluno (chave primária compartilhada - criada depois)
CREATE TABLE usuario_aluno (
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    sexo ENUM('M', 'F') NOT NULL
);

-- Usuário/Aluno (chave primária compartilhada - criada depois)
CREATE TABLE usuario_pedagogo (
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    sexo ENUM('M', 'F') NOT NULL
);

-- Usuário/Aluno (chave primária compartilhada - criada depois)
CREATE TABLE usuario_analista (
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    sexo ENUM('M', 'F') NOT NULL
);

-- Usuário/Unidade de Ensino (chave primária compartilhada - criada depois)
CREATE TABLE usuario_unidade_ensino (
    nome_fantasia VARCHAR(100) NOT NULL,
    razao_social VARCHAR(100),
    cnpj CHAR(18) NOT NULL UNIQUE,
    descricao TEXT
);

-- Curso
CREATE TABLE curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME
);

-- Turma
CREATE TABLE turma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    periodo ENUM('MATUTINO', 'VESPERTINO', 'NOTURNO'),
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME
);

-- Denúncia
CREATE TABLE denuncia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    conteudo TEXT NOT NULL,
    tipo ENUM(
        'VIOLENCIA_FISICA',
        'VIOLENCIA_VERBAL',
        'CYBER_BULLYING'
    ) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME
);

-- Andamento
CREATE TABLE andamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conteudo TEXT NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM(
        'ARQUIVAMENTO',
        'DESARQUIVAMENTO',
        'PARECER_FINAL',
        'INFORMACAO_COMPLEMENTAR',
        'ANALISE',
        'REUNIAO',
        'OBSERVACAO'
    ) NOT NULL
);