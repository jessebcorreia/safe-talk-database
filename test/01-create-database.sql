DROP DATABASE IF EXISTS safe_talk;

CREATE DATABASE safe_talk CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE safe_talk;

-- Endereço
CREATE TABLE endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    logradouro VARCHAR(150),
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2),
    cep CHAR(9),
    pais VARCHAR(50)
);

-- Responsável
CREATE TABLE responsavel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    cpf CHAR(14) UNIQUE,
    telefone VARCHAR(20),
    parentesco ENUM('PAI', 'MAE', 'TUTOR', 'OUTRO')
);

-- Usuário
CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    senha VARCHAR(255),
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
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
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    cpf CHAR(14) UNIQUE,
    sexo ENUM('M', 'F')
);

-- Usuário/Aluno (chave primária compartilhada - criada depois)
CREATE TABLE usuario_pedagogo (
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    cpf CHAR(14) UNIQUE,
    sexo ENUM('M', 'F')
);

-- Usuário/Aluno (chave primária compartilhada - criada depois)
CREATE TABLE usuario_analista (
    nome VARCHAR(100),
    sobrenome VARCHAR(100),
    cpf CHAR(14) UNIQUE,
    sexo ENUM('M', 'F')
);

-- Usuário/Unidade de Ensino (chave primária compartilhada - criada depois)
CREATE TABLE usuario_unidade_ensino (
    nome_fantasia VARCHAR(100),
    razao_social VARCHAR(100),
    cnpj CHAR(18) UNIQUE,
    descricao TEXT
);

-- Curso
CREATE TABLE curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) UNIQUE,
    descricao TEXT,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
);

-- Turma
CREATE TABLE turma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) UNIQUE,
    descricao TEXT,
    periodo ENUM('MATUTINO', 'VESPERTINO', 'NOTURNO'),
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
);

-- Denúncia
CREATE TABLE denuncia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150),
    conteudo TEXT,
    tipo ENUM(
        'VIOLENCIA_FISICA',
        'VIOLENCIA_VERBAL',
        'CYBER_BULLYING'
    ),
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME
);

-- Andamento
CREATE TABLE andamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conteudo TEXT,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM(
        'ARQUIVAMENTO',
        'DESARQUIVAMENTO',
        'PARECER_FINAL',
        'INFORMACAO_COMPLEMENTAR',
        'ANALISE',
        'REUNIAO',
        'OBSERVACAO'
    )
);