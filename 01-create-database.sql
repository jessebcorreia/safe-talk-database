DROP DATABASE IF EXISTS safe_talk;

CREATE DATABASE safe_talk CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE safe_talk;

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

CREATE TABLE unidade_ensino (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_fantasia VARCHAR(100) NOT NULL,
    razao_social VARCHAR(100),
    cnpj CHAR(18) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    endereco_id INT NOT NULL,
    CONSTRAINT fk_unidade_ensino_endereco FOREIGN KEY (endereco_id) REFERENCES endereco(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    unidade_ensino_id INT NOT NULL,
    CONSTRAINT fk_curso_unidade_ensino FOREIGN KEY (unidade_ensino_id) REFERENCES unidade_ensino(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE turma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    periodo ENUM('MATUTINO', 'VESPERTINO', 'NOTURNO'),
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    curso_id INT NOT NULL,
    CONSTRAINT fk_turma_curso FOREIGN KEY (curso_id) REFERENCES curso(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    sexo ENUM('M', 'F') NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cargo ENUM(
        'UNIDADE_ENSINO',
        'ANALISTA',
        'PEDAGOGO',
        'ALUNO'
    ),
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    endereco_id INT NOT NULL,
    turma_id INT,
    CONSTRAINT fk_usuario_endereco FOREIGN KEY (endereco_id) REFERENCES endereco(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_turma FOREIGN KEY (turma_id) REFERENCES turma(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE responsavel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    parentesco ENUM('PAI', 'MAE', 'TUTOR', 'OUTRO') NOT NULL,
    aluno_id INT NOT NULL,
    CONSTRAINT fk_responsavel_aluno FOREIGN KEY (aluno_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

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
    local_fato_id INT,
    autor_id INT NOT NULL,
    analista_id INT NOT NULL,
    CONSTRAINT fk_denuncia_local_fato FOREIGN KEY (local_fato_id) REFERENCES endereco(id) ON DELETE
    SET
        NULL ON UPDATE CASCADE,
        CONSTRAINT fk_denuncia_autor FOREIGN KEY (autor_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT fk_denuncia_analista FOREIGN KEY (analista_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabela intermediária N:N (uma denúncia pode ter várias vítimas, e um usuário pode ser vítima em várias denúncias)
CREATE TABLE denuncia_vitima (
    denuncia_id INT NOT NULL,
    vitima_id INT NOT NULL,
    PRIMARY KEY (denuncia_id, vitima_id),
    CONSTRAINT fk_denuncia_vitima_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_vitima_vitima FOREIGN KEY (vitima_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela intermediária N:N (uma denúncia pode ter vários agressores, e um usuário pode ser agressor em várias denúncias)
CREATE TABLE denuncia_agressor (
    denuncia_id INT NOT NULL,
    agressor_id INT NOT NULL,
    PRIMARY KEY (denuncia_id, agressor_id),
    CONSTRAINT fk_denuncia_agressor_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_agressor_agressor FOREIGN KEY (agressor_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabela intermediária N:N (uma denúncia pode ter vários pedagogos, e um usuário pode ser pedagogo em várias denúncias)
CREATE TABLE denuncia_pedagogo (
    denuncia_id INT NOT NULL,
    pedagogo_id INT NOT NULL,
    PRIMARY KEY (denuncia_id, pedagogo_id),
    CONSTRAINT fk_denuncia_pedagogo_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_pedagogo_pedagogo FOREIGN KEY (pedagogo_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE andamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conteudo TEXT NOT NULL,
    tipo ENUM(
        'ARQUIVAMENTO',
        'DESARQUIVAMENTO',
        'PARECER_FINAL',
        'INFORMACAO_COMPLEMENTAR',
        'ANALISE',
        'REUNIAO',
        'OBSERVACAO'
    ) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    denuncia_id INT NOT NULL,
    autor_id INT NOT NULL,
    CONSTRAINT fk_andamento_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_andamento_autor FOREIGN KEY (autor_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE andamento_arquivamento (
    andamento_id INT PRIMARY KEY,
    motivo ENUM(
        'DENUNCIA_DUPLICADA',
        'DENUNCIA_INCOMPLETA',
        'FATO_JA_APURADO',
        'FATO_ATIPICO'
    ) NOT NULL,
    CONSTRAINT fk_andamento_arquivamento_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE andamento_desarquivamento (
    andamento_id INT PRIMARY KEY,
    motivo ENUM('NOVAS_INFORMACOES', 'REVISAO_DA_DENUNCIA') NOT NULL,
    CONSTRAINT fk_andamento_desarquivamento_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE andamento_analise (
    andamento_id INT PRIMARY KEY,
    atualizado_em DATETIME,
    CONSTRAINT fk_andamento_analise_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE andamento_reuniao (
    andamento_id INT PRIMARY KEY,
    data_hora DATETIME NOT NULL,
    CONSTRAINT fk_andamento_reuniao_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE andamento_parecer_final (
    andamento_id INT PRIMARY KEY,
    resultado ENUM(
        'DENUNCIA_PROCEDENTE',
        'DENUNCIA_IMPROCEDENTE',
        'PARECER_INCONCLUSIVO'
    ) NOT NULL,
    atualizado_em DATETIME,
    CONSTRAINT fk_andamento_parecer_final_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE
    curso
ADD
    COLUMN analista_id INT,
ADD
    CONSTRAINT fk_curso_analista FOREIGN KEY (analista_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE
    turma
ADD
    COLUMN pedagogo_id INT,
ADD
    CONSTRAINT fk_turma_pedagogo FOREIGN KEY (pedagogo_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;