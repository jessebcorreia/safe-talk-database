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
    atualizado_em DATETIME
);

-- Turma
CREATE TABLE turma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) UNIQUE,
    descricao TEXT,
    periodo ENUM('MATUTINO', 'VESPERTINO', 'NOTURNO'),
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME
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

USE safe_talk;

-- Responsável
ALTER TABLE
    responsavel
ADD
    COLUMN aluno_id INT,
ADD
    CONSTRAINT fk_responsavel_aluno FOREIGN KEY (aluno_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Usuário
ALTER TABLE
    usuario
ADD
    COLUMN endereco_id INT,
ADD
    CONSTRAINT fk_usuario_endereco FOREIGN KEY (endereco_id) REFERENCES endereco(id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Usuário/Aluno (Chave primária compartilhada)
ALTER TABLE
    usuario_aluno
ADD
    COLUMN usuario_id INT PRIMARY KEY FIRST,
ADD
    CONSTRAINT fk_usuario_aluno_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Usuário/Pedagogo (Chave primária compartilhada)
ALTER TABLE
    usuario_pedagogo
ADD
    COLUMN usuario_id INT PRIMARY KEY FIRST,
ADD
    CONSTRAINT fk_usuario_pedagogo_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Usuário/Analista (Chave primária compartilhada)
ALTER TABLE
    usuario_analista
ADD
    COLUMN usuario_id INT PRIMARY KEY FIRST,
ADD
    CONSTRAINT fk_usuario_analista_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Usuário/Unidade de Ensino (Chave primária compartilhada)
ALTER TABLE
    usuario_unidade_ensino
ADD
    COLUMN usuario_id INT PRIMARY KEY FIRST,
ADD
    CONSTRAINT fk_usuario_unidade_ensino_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Curso
ALTER TABLE
    curso
ADD
    COLUMN unidade_ensino_id INT,
ADD
    COLUMN analista_id INT,
ADD
    CONSTRAINT fk_curso_unidade_ensino FOREIGN KEY (unidade_ensino_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_curso_analista FOREIGN KEY (analista_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Turma
ALTER TABLE
    turma
ADD
    COLUMN curso_id INT,
ADD
    COLUMN pedagogo_id INT,
ADD
    CONSTRAINT fk_turma_curso FOREIGN KEY (curso_id) REFERENCES curso(id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_turma_pedagogo FOREIGN KEY (pedagogo_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Denúncia
ALTER TABLE
    denuncia
ADD
    COLUMN local_fato_id INT,
ADD
    COLUMN autor_id INT,
ADD
    COLUMN analista_id INT,
ADD
    CONSTRAINT fk_denuncia_local_fato FOREIGN KEY (local_fato_id) REFERENCES endereco(id) ON DELETE RESTRICT ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_denuncia_autor FOREIGN KEY (autor_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_denuncia_analista FOREIGN KEY (analista_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Denúncia/Vítimas (N:N)
-- Uma denúncia pode ter várias vítimas, e um usuário pode ser vítima em várias denúncias
CREATE TABLE denuncia_vitima (
    denuncia_id INT,
    vitima_id INT,
    PRIMARY KEY (denuncia_id, vitima_id),
    CONSTRAINT fk_denuncia_vitima_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_vitima_vitima FOREIGN KEY (vitima_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Denúncia/Agressores (N:N)
-- Uma denúncia pode ter vários agressores, e um usuário pode ser agressor em várias denúncias
CREATE TABLE denuncia_agressor (
    denuncia_id INT,
    agressor_id INT,
    PRIMARY KEY (denuncia_id, agressor_id),
    CONSTRAINT fk_denuncia_agressor_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_agressor_agressor FOREIGN KEY (agressor_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Denúncia/Pedagogos (N:N)
-- Uma denúncia pode ter vários pedagogos, e um usuário pode ser pedagogo em várias denúncias
CREATE TABLE denuncia_pedagogo (
    denuncia_id INT,
    pedagogo_id INT,
    PRIMARY KEY (denuncia_id, pedagogo_id),
    CONSTRAINT fk_denuncia_pedagogo_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_pedagogo_pedagogo FOREIGN KEY (pedagogo_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Andamento
ALTER TABLE
    andamento
ADD
    COLUMN denuncia_id INT,
ADD
    COLUMN autor_id INT,
ADD
    CONSTRAINT fk_andamento_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_andamento_autor FOREIGN KEY (autor_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Andamento/Arquivamento (1:1)
-- Se o andamento for do tipo "ARQUIVAMENTO", as informações complementares ficarão nessa tabela
CREATE TABLE andamento_arquivamento (
    andamento_id INT PRIMARY KEY,
    motivo ENUM(
        'DENUNCIA_DUPLICADA',
        'DENUNCIA_INCOMPLETA',
        'FATO_JA_APURADO',
        'FATO_ATIPICO'
    ),
    CONSTRAINT fk_andamento_arquivamento_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Andamento/Desarquivamento (1:1)
-- Se o andamento for do tipo "DESARQUIVAMENTO", as informações complementares ficarão nessa tabela
CREATE TABLE andamento_desarquivamento (
    andamento_id INT PRIMARY KEY,
    motivo ENUM('NOVAS_INFORMACOES', 'REVISAO_DA_DENUNCIA'),
    CONSTRAINT fk_andamento_desarquivamento_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Andamento/Análise (1:1)
-- Se o andamento for do tipo "ANALISE", as informações complementares ficarão nessa tabela
CREATE TABLE andamento_analise (
    andamento_id INT PRIMARY KEY,
    atualizado_em DATETIME,
    CONSTRAINT fk_andamento_analise_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Andamento/Reunião (1:1)
-- Se o andamento for do tipo "REUNIAO", as informações complementares ficarão nessa tabela
CREATE TABLE andamento_reuniao (
    andamento_id INT PRIMARY KEY,
    data_hora DATETIME,
    CONSTRAINT fk_andamento_reuniao_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Andamento/Parecer Final (1:1)
-- Se o andamento for do tipo "PARECER_FINAL", as informações complementares ficarão nessa tabela
CREATE TABLE andamento_parecer_final (
    andamento_id INT PRIMARY KEY,
    resultado ENUM(
        'DENUNCIA_PROCEDENTE',
        'DENUNCIA_IMPROCEDENTE',
        'PARECER_INCONCLUSIVO'
    ),
    atualizado_em DATETIME,
    CONSTRAINT fk_andamento_parecer_final_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);