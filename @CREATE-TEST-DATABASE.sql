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
    sexo ENUM('MASCULINO', 'FEMININO') NOT NULL
);

-- Usuário/Aluno (chave primária compartilhada - criada depois)
CREATE TABLE usuario_pedagogo (
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    sexo ENUM('MASCULINO', 'FEMININO') NOT NULL
);

-- Usuário/Aluno (chave primária compartilhada - criada depois)
CREATE TABLE usuario_analista (
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    cpf CHAR(14) NOT NULL UNIQUE,
    sexo ENUM('MASCULINO', 'FEMININO') NOT NULL
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
    situacao_analise ENUM(
        'NAO_INICIADA',
        'INICIADA',
        'ENCERRADA'
    ) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME,
    encerrado_em DATETIME
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


USE safe_talk;

-- Responsável
ALTER TABLE
    responsavel
ADD
    COLUMN aluno_id INT NOT NULL,
ADD
    CONSTRAINT fk_responsavel_aluno FOREIGN KEY (aluno_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Usuário
ALTER TABLE
    usuario
ADD
    COLUMN endereco_id INT NOT NULL,
ADD
    CONSTRAINT fk_usuario_endereco FOREIGN KEY (endereco_id) REFERENCES endereco(id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Usuário/Aluno (Chave primária compartilhada)
ALTER TABLE
    usuario_aluno
ADD
    COLUMN usuario_id INT PRIMARY KEY FIRST,
ADD
    COLUMN turma_id INT,
ADD
    CONSTRAINT fk_usuario_aluno_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_usuario_aluno_turma FOREIGN KEY (turma_id) REFERENCES turma(id) ON DELETE RESTRICT ON UPDATE CASCADE;

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
    COLUMN unidade_ensino_id INT NOT NULL,
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
    COLUMN curso_id INT NOT NULL,
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
    COLUMN autor_id INT NOT NULL,
ADD
    COLUMN pedagogo_id INT NOT NULL,
ADD
    COLUMN analista_id INT NOT NULL,
ADD
    CONSTRAINT fk_denuncia_local_fato FOREIGN KEY (local_fato_id) REFERENCES endereco(id) ON DELETE RESTRICT ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_denuncia_autor FOREIGN KEY (autor_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_denuncia_pedagogo FOREIGN KEY (pedagogo_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_denuncia_analista FOREIGN KEY (analista_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Denúncia/Vítimas (N:N)
-- Uma denúncia pode ter várias vítimas, e um usuário pode ser vítima em várias denúncias
CREATE TABLE denuncia_vitima (
    denuncia_id INT NOT NULL,
    vitima_id INT NOT NULL,
    PRIMARY KEY (denuncia_id, vitima_id),
    CONSTRAINT fk_denuncia_vitima_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_vitima_vitima FOREIGN KEY (vitima_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Denúncia/Agressores (N:N)
-- Uma denúncia pode ter várias vítimas, e um usuário pode ser vítima em várias denúncias
CREATE TABLE denuncia_agressor (
    denuncia_id INT NOT NULL,
    agressor_id INT NOT NULL,
    PRIMARY KEY (denuncia_id, agressor_id),
    CONSTRAINT fk_denuncia_agressor_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_agressor_agressor FOREIGN KEY (agressor_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Andamento
ALTER TABLE
    andamento
ADD
    COLUMN denuncia_id INT NOT NULL,
ADD
    COLUMN autor_id INT NOT NULL,
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
    ) NOT NULL,
    CONSTRAINT fk_andamento_arquivamento_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Andamento/Desarquivamento (1:1)
-- Se o andamento for do tipo "DESARQUIVAMENTO", as informações complementares ficarão nessa tabela
CREATE TABLE andamento_desarquivamento (
    andamento_id INT PRIMARY KEY,
    motivo ENUM('NOVAS_INFORMACOES', 'REVISAO_DA_DENUNCIA') NOT NULL,
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
    data_hora DATETIME NOT NULL,
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
    ) NOT NULL,
    atualizado_em DATETIME,
    CONSTRAINT fk_andamento_parecer_final_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

USE safe_talk;

INSERT INTO
    endereco (logradouro, numero, complemento, bairro, cidade, estado, cep, pais)
VALUES
    ('Rua das Andorinhas', 142, 'Apto 201', 'Jardim do Vale', 'Gaspar', 'SC', '89110-321', 'Brasil'),
    ('Avenida Monte Verde', 87, NULL, 'Parque das Flores', 'Gaspar', 'SC', '89112-654', 'Brasil'),
    ('Rua do Cedro', 59, 'Casa 3', 'Vila das Águas', 'Gaspar', 'SC', '89114-987', 'Brasil'),
    ('Travessa Bela Colina', 201, NULL, 'Morada do Sol', 'Gaspar', 'SC', '89115-258', 'Brasil'),
    ('Rua Lago Sereno', 314, 'Fundos', 'Colinas do Sul', 'Gaspar', 'SC', '89117-369', 'Brasil'),
    ('Rua Aurora Boreal', 502, 'Sala 402', 'Vila Primavera', 'Blumenau', 'SC', '89010-852', 'Brasil'),
    ('Avenida Cristal Azul', 76, NULL, 'Parque dos Ventos', 'Blumenau', 'SC', '89036-147', 'Brasil'),
    ('Rua das Bromélias', 189, 'Apto 102', 'Jardim das Pedras', 'Blumenau', 'SC', '89045-963', 'Brasil'),
    ('Travessa Sol Poente', 45, NULL, 'Vila Horizonte', 'Blumenau', 'SC', '89050-753', 'Brasil'),
    ('Rua Caminho do Rio', 398, 'Casa 1', 'Bosque Encantado', 'Blumenau', 'SC', '89065-258', 'Brasil');


INSERT INTO
    usuario (email, senha, cargo, endereco_id)
VALUES
    -- id: 1
    ("unidade.ensino@email.com", "123456789", "UNIDADE_ENSINO", 1);

INSERT INTO
    usuario_unidade_ensino (usuario_id, nome_fantasia, razao_social, cnpj, descricao)
VALUES
    -- usuario_id: 1
    (1, 'Colégio Madre Tereza de Calcutá', 'Escola de Educação Básica Madre Tereza de Calcutá Ltda.', '84.264.845/0001-56', 'Descrição da unidade de ensino');


INSERT INTO
    usuario (email, senha, cargo, criado_em, endereco_id)
VALUES
    -- id: 2
    ('joao.analista@email.com', '123456', 'ANALISTA', '2025-01-23 21:52:16', 4),
    -- id: 3
    ('maria.analista@email.com', '654321', 'ANALISTA', '2025-03-12 15:25:36', 5),
    -- id: 4
    ('josicleison.pedagogo@email.com', '123456', 'PEDAGOGO', '2025-05-22 12:32:23', 6),
    -- id: 5
    ('luana.pedagoga@email.com', '654321', 'PEDAGOGO', '2025-02-10 19:15:58', 7);

INSERT INTO
    usuario_analista (usuario_id, nome, sobrenome, cpf, sexo)
VALUES
    -- usuario_id: 2
    (2, 'João', 'Analista da Silva', '861.534.872-92', 'Masculino'),
    -- usuario_id: 3
    (3, 'Maria', 'Pereira Analista da Costa', '845.269.456-15', 'Feminino');

INSERT INTO
    usuario_pedagogo (usuario_id, nome, sobrenome, cpf, sexo)
VALUES
    -- usuario_id: 4
    (4, 'Josicleison', 'o Pedagogo', '563.534.856-92', 'Masculino'),
    -- usuario_id: 5
    (5, 'Luana', 'Andrade Pedagoga Santos', '379.568.339-56', 'Feminino');


INSERT INTO curso
    (nome, descricao, unidade_ensino_id, analista_id)
VALUES
    ('Informática Básica', 'Curso introdutório de informática, abrangendo uso de computadores, internet e pacotes de escritório.', 1, 2),
    ('Inglês Intermediário', 'Curso de língua inglesa com foco em conversação e vocabulário para o dia a dia.', 1, 2),
    ('Matemática Aplicada', 'Curso para reforço escolar e aplicação prática de conceitos matemáticos.', 1, 3),
    ('Educação Artística', 'Curso voltado ao desenvolvimento criativo por meio de desenho, pintura e trabalhos manuais.', 1, 3);


INSERT INTO turma
    (nome, descricao, periodo, curso_id, pedagogo_id)
VALUES
    -- Curso 1: Informática Básica
    ('Info Básica - Turma A', 'Introdução ao uso do computador e do sistema operacional.', 'MATUTINO', 1, 3),
    ('Info Básica - Turma B', 'Uso de editores de texto, planilhas e apresentações.', 'VESPERTINO', 1, 3),
    ('Info Básica - Turma C', 'Internet segura e pesquisa acadêmica online.', 'NOTURNO', 1, 3),
    ('Info Básica - Turma D', 'Edição básica de imagens e organização de arquivos.', 'MATUTINO', 1, 3),
    ('Info Básica - Turma E', 'Projeto final com aplicação dos conhecimentos adquiridos.', 'VESPERTINO', 1, 3),

    -- Curso 2: Inglês Intermediário
    ('Inglês Interm. - Turma A', 'Conversação básica para situações do cotidiano.', 'MATUTINO', 2, 3),
    ('Inglês Interm. - Turma B', 'Vocabulário para viagens e interações escolares.', 'VESPERTINO', 2, 3),
    ('Inglês Interm. - Turma C', 'Prática de leitura e interpretação de textos simples.', 'NOTURNO', 2, 3),
    ('Inglês Interm. - Turma D', 'Escrita de frases e pequenos diálogos.', 'MATUTINO', 2, 3),
    ('Inglês Interm. - Turma E', 'Apresentações orais e compreensão auditiva.', 'VESPERTINO', 2, 3),

    -- Curso 3: Matemática Aplicada
    ('Mat Aplicada - Turma A', 'Revisão de operações básicas e resolução de problemas.', 'MATUTINO', 3, 4),
    ('Mat Aplicada - Turma B', 'Introdução à geometria e medidas.', 'VESPERTINO', 3, 4),
    ('Mat Aplicada - Turma C', 'Porcentagem, juros simples e compostos.', 'NOTURNO', 3, 4),
    ('Mat Aplicada - Turma D', 'Estatística básica para projetos escolares.', 'MATUTINO', 3, 4),
    ('Mat Aplicada - Turma E', 'Resolução de problemas do dia a dia.', 'VESPERTINO', 3, 4),

    -- Curso 4: Educação Artística
    ('Ed Artística - Turma A', 'Técnicas de desenho e sombreamento.', 'MATUTINO', 4, 4),
    ('Ed Artística - Turma B', 'Introdução à pintura com guache e aquarela.', 'VESPERTINO', 4, 4),
    ('Ed Artística - Turma C', 'Artesanato e trabalhos manuais criativos.', 'NOTURNO', 4, 4),
    ('Ed Artística - Turma D', 'História da arte e inspiração criativa.', 'MATUTINO', 4, 4),
    ('Ed Artística - Turma E', 'Projeto final com exposição das obras.', 'VESPERTINO', 4, 4);


INSERT INTO
    usuario (email, senha, cargo, criado_em, endereco_id)
VALUES
('íris.2949@email.com', '670105', 'ALUNO', '2025-01-24 07:08:31', 10),
('jade-6823@email.com', '215549', 'ALUNO', '2025-06-22 01:16:14', 3),
('dominic-7949@email.com', '181407', 'ALUNO', '2025-05-14 17:58:21', 8),
('joão.miguel-7634@email.com', '991705', 'ALUNO', '2025-04-08 11:33:33', 1),
('olívia-8321@email.com', '176521', 'ALUNO', '2025-07-17 10:39:27', 3),
('emanuel-7102@email.com', '926726', 'ALUNO', '2025-07-30 13:10:15', 3),
('janaína-1430@email.com', '737859', 'ALUNO', '2025-07-18 06:04:03', 3),
('ayla-7797@email.com', '205471', 'ALUNO', '2025-06-09 18:14:35', 3),
('alícia-9191@email.com', '466124', 'ALUNO', '2025-06-12 19:02:42', 1),
('maitê-3234@email.com', '384859', 'ALUNO', '2025-02-12 14:03:57', 4),
('maria.cecília-8686@email.com', '288837', 'ALUNO', '2025-01-01 16:31:08', 6),
('heitor-1693@email.com', '649142', 'ALUNO', '2025-02-04 18:50:58', 7),
('pedro.henrique-3747@email.com', '819097', 'ALUNO', '2025-07-21 00:16:49', 4),
('camila-3668@email.com', '509123', 'ALUNO', '2025-01-09 02:50:26', 5),
('thiago-5007@email.com', '512674', 'ALUNO', '2025-04-10 20:25:39', 7),
('melinda-1946@email.com', '652110', 'ALUNO', '2025-05-10 13:08:16', 2),
('lara-5817@email.com', '891845', 'ALUNO', '2025-07-18 19:29:28', 5),
('davi.lucas-2506@email.com', '977458', 'ALUNO', '2025-06-18 19:38:02', 2),
('nicolas-6111@email.com', '765421', 'ALUNO', '2025-06-13 22:42:23', 7),
('maria.cecília-8610@email.com', '653872', 'ALUNO', '2025-06-25 17:15:46', 7),
('pedro-3504@email.com', '542737', 'ALUNO', '2025-07-18 03:13:42', 7),
('davi.luiz-3564@email.com', '803067', 'ALUNO', '2025-02-24 18:55:46', 8),
('liz-2600@email.com', '742119', 'ALUNO', '2025-07-13 05:15:09', 4),
('joão.gabriel-5377@email.com', '646420', 'ALUNO', '2025-01-23 02:03:47', 10),
('gabriela-5063@email.com', '648036', 'ALUNO', '2025-03-16 03:50:05', 1),
('sophia-7120@email.com', '256040', 'ALUNO', '2025-06-22 09:15:25', 8),
('isabella-7037@email.com', '263438', 'ALUNO', '2025-01-09 00:36:03', 9),
('davi.luiz-4370@email.com', '870257', 'ALUNO', '2025-05-02 05:58:18', 10),
('felipe-5316@email.com', '989376', 'ALUNO', '2025-02-13 11:26:55', 10),
('martin-1016@email.com', '807857', 'ALUNO', '2025-06-19 04:28:04', 4),
('vitor-5875@email.com', '414078', 'ALUNO', '2025-06-28 16:59:32', 10),
('dom-9658@email.com', '202364', 'ALUNO', '2025-04-30 06:38:48', 3),
('raul-7977@email.com', '493212', 'ALUNO', '2025-05-09 19:10:17', 10),
('asafe-8900@email.com', '113441', 'ALUNO', '2025-01-18 11:09:06', 6),
('kiara-1748@email.com', '200192', 'ALUNO', '2025-07-14 14:05:11', 6),
('maria.alice-9781@email.com', '643056', 'ALUNO', '2025-07-08 00:25:04', 2),
('zara-3768@email.com', '697676', 'ALUNO', '2025-05-04 09:59:42', 8),
('heloísa-8040@email.com', '487054', 'ALUNO', '2025-07-02 23:36:07', 4),
('theo-2827@email.com', '974096', 'ALUNO', '2025-03-02 17:11:20', 6),
('ravena-5218@email.com', '560885', 'ALUNO', '2025-03-28 21:58:04', 7),
('leona-3379@email.com', '688957', 'ALUNO', '2025-02-18 01:07:42', 9),
('lívia-3709@email.com', '828394', 'ALUNO', '2025-03-23 23:59:31', 10),
('janaína-3990@email.com', '643973', 'ALUNO', '2025-05-03 06:22:35', 7),
('isaac-6381@email.com', '232457', 'ALUNO', '2025-05-15 00:55:58', 9),
('guilherme.fernandes-7842@email.com', '582693', 'ALUNO', '2025-02-16 01:48:13', 1),
('mariana-6164@email.com', '311590', 'ALUNO', '2025-07-19 14:19:10', 8),
('antonio-7290@email.com', '184692', 'ALUNO', '2025-03-13 06:51:31', 4),
('francisco-5571@email.com', '918570', 'ALUNO', '2025-04-14 09:48:07', 9),
('oliver-7965@email.com', '461756', 'ALUNO', '2025-06-08 10:33:05', 10),
('agatha-2780@email.com', '995124', 'ALUNO', '2025-07-15 05:08:35', 5),
('maria.clara-6430@email.com', '305109', 'ALUNO', '2025-07-11 20:57:37', 5),
('vicky-1214@email.com', '392183', 'ALUNO', '2025-07-02 12:54:16', 10),
('caleb-8192@email.com', '379586', 'ALUNO', '2025-02-09 03:55:15', 3),
('louise-3892@email.com', '589894', 'ALUNO', '2025-04-16 14:23:01', 9),
('kamala-1893@email.com', '428042', 'ALUNO', '2025-06-05 00:32:58', 6),
('zara-4402@email.com', '747432', 'ALUNO', '2025-02-22 06:56:32', 8),
('ana.clara-4113@email.com', '753389', 'ALUNO', '2025-05-03 02:02:26', 9),
('emanuelly-3845@email.com', '603594', 'ALUNO', '2025-05-16 04:33:14', 7),
('noah-7199@email.com', '334749', 'ALUNO', '2025-01-22 03:39:07', 9),
('gabriel-7496@email.com', '684662', 'ALUNO', '2025-06-30 00:49:12', 9),
('matheus-5986@email.com', '960433', 'ALUNO', '2025-06-28 10:21:34', 10),
('joão.miguel-8177@email.com', '961727', 'ALUNO', '2025-03-20 11:39:02', 3),
('joao.pedro-7780@email.com', '198261', 'ALUNO', '2025-06-17 11:54:07', 9),
('serena-8936@email.com', '326010', 'ALUNO', '2025-03-24 10:18:05', 3),
('sasha-1423@email.com', '165732', 'ALUNO', '2025-02-14 13:27:43', 3),
('jade-8611@email.com', '421127', 'ALUNO', '2025-01-26 23:37:09', 1),
('alícia-4101@email.com', '189542', 'ALUNO', '2025-06-10 10:05:26', 7),
('josué-7715@email.com', '246420', 'ALUNO', '2025-06-01 19:42:53', 1),
('flora-2586@email.com', '566133', 'ALUNO', '2025-01-23 17:04:33', 5),
('elisa-2507@email.com', '774100', 'ALUNO', '2025-04-14 21:15:27', 3),
('louise-2235@email.com', '442289', 'ALUNO', '2025-07-09 00:15:40', 5),
('anthony-5379@email.com', '714755', 'ALUNO', '2025-01-18 22:49:02', 10),
('chloe-1471@email.com', '503363', 'ALUNO', '2025-01-07 02:10:42', 7),
('henry-7405@email.com', '861370', 'ALUNO', '2025-07-30 18:16:58', 8),
('eduardo-2358@email.com', '797842', 'ALUNO', '2025-01-06 06:48:26', 6),
('gustavo-5960@email.com', '937278', 'ALUNO', '2025-03-19 07:37:04', 7),
('joaquim-7945@email.com', '623780', 'ALUNO', '2025-01-10 05:27:29', 1),
('daniel-4400@email.com', '884110', 'ALUNO', '2025-03-23 02:00:19', 1),
('erick-7620@email.com', '239182', 'ALUNO', '2025-05-07 07:33:04', 10),
('luiz.henrique-7304@email.com', '261115', 'ALUNO', '2025-01-25 07:27:27', 1),
('davi.lucca-5899@email.com', '147679', 'ALUNO', '2025-07-25 15:25:19', 9),
('bella-9773@email.com', '863580', 'ALUNO', '2025-04-04 12:13:26', 6),
('nathan-5481@email.com', '344481', 'ALUNO', '2025-05-23 22:36:57', 1),
('luiz.henrique-2741@email.com', '260667', 'ALUNO', '2025-05-26 08:12:06', 1),
('kiara-8560@email.com', '554095', 'ALUNO', '2025-03-13 18:31:28', 1),
('lia-9483@email.com', '321741', 'ALUNO', '2025-03-24 21:48:29', 3),
('clara-5589@email.com', '258495', 'ALUNO', '2025-01-07 15:38:28', 4),
('liz-7062@email.com', '616220', 'ALUNO', '2025-03-08 20:34:19', 3),
('letícia-4351@email.com', '553456', 'ALUNO', '2025-04-24 12:21:02', 2),
('íris-2129@email.com', '492831', 'ALUNO', '2025-03-02 19:45:22', 3),
('emilly-9559@email.com', '502223', 'ALUNO', '2025-03-16 15:45:42', 7),
('emanuel-3775@email.com', '416666', 'ALUNO', '2025-07-07 21:18:57', 8),
('emma-3463@email.com', '777293', 'ALUNO', '2025-04-20 02:36:33', 6),
('theo-4593@email.com', '684174', 'ALUNO', '2025-04-01 17:56:41', 5),
('bryan-2548@email.com', '499753', 'ALUNO', '2025-01-01 02:31:50', 7),
('thiago-1611@email.com', '860337', 'ALUNO', '2025-06-19 05:46:33', 7),
('valentim-8725@email.com', '355915', 'ALUNO', '2025-05-18 21:57:28', 10),
('letícia-4722@email.com', '169951', 'ALUNO', '2025-03-19 10:28:25', 9),
('joão.gabriel-5848@email.com', '857914', 'ALUNO', '2025-02-05 00:20:22', 8),
('davi-6535@email.com', '106906', 'ALUNO', '2025-07-14 05:57:22', 8),
('bryan-3220@email.com', '884724', 'ALUNO', '2025-06-17 04:30:14', 1),
('liz-9512@email.com', '850904', 'ALUNO', '2025-04-04 07:34:03', 3),
('marina-7288@email.com', '393445', 'ALUNO', '2025-04-09 21:06:52', 1),
('alice-1271@email.com', '341241', 'ALUNO', '2025-06-07 00:15:09', 5),
('oliver-6750@email.com', '235366', 'ALUNO', '2025-07-16 18:40:27', 2),
('janaína-8173@email.com', '595672', 'ALUNO', '2025-05-22 10:31:57', 5),
('agatha-2776@email.com', '978719', 'ALUNO', '2025-04-10 15:18:11', 3),
('mathias-9935@email.com', '318131', 'ALUNO', '2025-07-28 21:41:45', 6),
('ana.luísa-9001@email.com', '699677', 'ALUNO', '2025-07-03 14:15:29', 5),
('kalel-2703@email.com', '459184', 'ALUNO', '2025-07-29 17:06:21', 3),
('sol-2906@email.com', '888006', 'ALUNO', '2025-06-28 18:24:20', 7),
('vicente-4054@email.com', '337920', 'ALUNO', '2025-02-01 19:30:17', 9),
('luna-4925@email.com', '846247', 'ALUNO', '2025-01-21 07:18:52', 6),
('ana.clara-3430@email.com', '723742', 'ALUNO', '2025-06-03 00:12:09', 9),
('gael-4312@email.com', '668960', 'ALUNO', '2025-01-21 02:43:28', 7),
('naomi-5469@email.com', '211824', 'ALUNO', '2025-05-18 07:15:23', 9),
('davi.miguel-9281@email.com', '639011', 'ALUNO', '2025-03-26 19:24:33', 10),
('henrique-5143@email.com', '974384', 'ALUNO', '2025-03-01 14:18:14', 10),
('maria.júlia-6357@email.com', '166053', 'ALUNO', '2025-07-15 06:14:23', 6),
('ester-5748@email.com', '129653', 'ALUNO', '2025-04-05 10:28:06', 9),
('lucas-8119@email.com', '219390', 'ALUNO', '2025-04-07 05:37:40', 6),
('layla-7188@email.com', '997125', 'ALUNO', '2025-07-09 14:48:25', 1),
('augusto-1093@email.com', '300459', 'ALUNO', '2025-04-07 00:24:54', 3),
('betânia-9935@email.com', '487977', 'ALUNO', '2025-04-19 18:58:17', 7),
('estevão-7029@email.com', '359143', 'ALUNO', '2025-07-08 22:15:49', 4),
('bella-5963@email.com', '867147', 'ALUNO', '2025-07-19 20:38:18', 7),
('ava-3846@email.com', '323390', 'ALUNO', '2025-07-13 18:09:18', 5),
('maíra-4699@email.com', '710500', 'ALUNO', '2025-03-19 03:50:26', 8),
('emily-5678@email.com', '712116', 'ALUNO', '2025-07-31 07:48:50', 9),
('mayra-5284@email.com', '975026', 'ALUNO', '2025-04-01 19:57:29', 6),
('lara-5352@email.com', '994962', 'ALUNO', '2025-04-05 03:38:12', 10),
('eva-6769@email.com', '686663', 'ALUNO', '2025-05-06 06:48:20', 9),
('anthony-6782@email.com', '171516', 'ALUNO', '2025-04-07 13:44:52', 7),
('lorenzo-1656@email.com', '719360', 'ALUNO', '2025-04-04 08:26:49', 5),
('asafe-4013@email.com', '117703', 'ALUNO', '2025-04-27 09:57:49', 8),
('eva-1299@email.com', '321360', 'ALUNO', '2025-05-15 10:33:26', 1),
('evelyn-1350@email.com', '327317', 'ALUNO', '2025-06-12 14:40:43', 2),
('helena-7241@email.com', '177521', 'ALUNO', '2025-06-23 17:57:44', 2),
('alana-4147@email.com', '344251', 'ALUNO', '2025-05-07 15:47:42', 5),
('nathan-6817@email.com', '374324', 'ALUNO', '2025-07-09 13:19:14', 3),
('yasmin-2883@email.com', '611759', 'ALUNO', '2025-06-28 11:46:21', 6),
('gabriela-8862@email.com', '551134', 'ALUNO', '2025-07-17 03:30:44', 2),
('nina-3468@email.com', '793082', 'ALUNO', '2025-07-31 23:31:04', 4),
('cecília-6710@email.com', '392410', 'ALUNO', '2025-04-01 22:48:07', 9),
('pilar-9744@email.com', '505364', 'ALUNO', '2025-01-19 19:21:28', 10),
('joão.miguel-5176@email.com', '889894', 'ALUNO', '2025-05-09 21:40:16', 6),
('naomi-4631@email.com', '558056', 'ALUNO', '2025-05-29 04:09:15', 8),
('antonio-2194@email.com', '918640', 'ALUNO', '2025-04-23 05:07:45', 7),
('ryan-8483@email.com', '619130', 'ALUNO', '2025-03-03 05:42:50', 9),
('pedro-4328@email.com', '100353', 'ALUNO', '2025-04-22 09:45:29', 10),
('thiago-5631@email.com', '916217', 'ALUNO', '2025-03-03 01:53:39', 10),
('kalel-7118@email.com', '183269', 'ALUNO', '2025-02-06 11:30:39', 8),
('davi.lucca-5826@email.com', '193024', 'ALUNO', '2025-01-15 14:40:43', 1),
('alice-3093@email.com', '909207', 'ALUNO', '2025-04-30 09:07:20', 2),
('joao.pedro-4569@email.com', '371770', 'ALUNO', '2025-05-05 22:40:09', 3),
('anne-1854@email.com', '632100', 'ALUNO', '2025-03-23 08:00:31', 1),
('breno-9684@email.com', '293669', 'ALUNO', '2025-04-24 15:28:55', 1),
('fernanda-7931@email.com', '323742', 'ALUNO', '2025-03-01 11:28:43', 6),
('lara-3359@email.com', '256058', 'ALUNO', '2025-01-25 13:48:02', 2),
('joão.gabriel-1857@email.com', '495470', 'ALUNO', '2025-04-23 20:17:32', 5),
('ravi-8449@email.com', '644460', 'ALUNO', '2025-04-07 10:35:03', 3),
('aylla-2151@email.com', '323988', 'ALUNO', '2025-04-13 21:50:06', 2),
('layla-1377@email.com', '704889', 'ALUNO', '2025-03-27 01:29:04', 6),
('caleb-5828@email.com', '200145', 'ALUNO', '2025-01-27 18:01:56', 8),
('sol-4373@email.com', '788450', 'ALUNO', '2025-01-15 05:50:31', 7),
('francisco-2878@email.com', '818523', 'ALUNO', '2025-02-22 20:11:39', 5),
('sasha-4932@email.com', '613743', 'ALUNO', '2025-01-16 01:15:07', 6),
('anne-1614@email.com', '728954', 'ALUNO', '2025-02-19 03:34:57', 1),
('olívia-7903@email.com', '816350', 'ALUNO', '2025-07-10 00:08:18', 9),
('catarina-6942@email.com', '251723', 'ALUNO', '2025-07-05 10:37:48', 9),
('estevão-5805@email.com', '946338', 'ALUNO', '2025-03-15 19:57:40', 5),
('guilherme-5195@email.com', '974436', 'ALUNO', '2025-04-13 11:10:03', 6),
('heitor-6564@email.com', '314171', 'ALUNO', '2025-01-01 04:13:27', 4),
('giulia-8961@email.com', '941908', 'ALUNO', '2025-02-07 07:56:02', 1),
('lucas-9541@email.com', '162684', 'ALUNO', '2025-06-06 17:32:31', 3),
('raabe-8583@email.com', '523268', 'ALUNO', '2025-06-18 09:58:31', 5),
('liam-8802@email.com', '101404', 'ALUNO', '2025-06-16 13:11:20', 1),
('breno-2560@email.com', '606828', 'ALUNO', '2025-02-17 13:45:55', 5),
('lívia-1268@email.com', '298206', 'ALUNO', '2025-07-12 15:21:03', 3),
('léonovo-3319@email.com', '685317', 'ALUNO', '2025-05-19 20:58:03', 4),
('louise-8798@email.com', '547655', 'ALUNO', '2025-06-05 16:08:04', 9),
('manuela-2706@email.com', '634728', 'ALUNO', '2025-05-20 19:13:03', 3),
('valentina-5126@email.com', '969779', 'ALUNO', '2025-06-05 20:45:49', 7),
('cauã-6517@email.com', '343785', 'ALUNO', '2025-03-11 15:07:35', 10),
('beatriz-3379@email.com', '813777', 'ALUNO', '2025-06-06 06:52:29', 6),
('matheus-4751@email.com', '784875', 'ALUNO', '2025-06-13 04:46:04', 2),
('samuel-2936@email.com', '762544', 'ALUNO', '2025-06-27 03:05:26', 5),
('naomi-7722@email.com', '963620', 'ALUNO', '2025-04-23 01:28:57', 3),
('bianca-6973@email.com', '841677', 'ALUNO', '2025-04-06 05:07:55', 10),
('caleb-6989@email.com', '243008', 'ALUNO', '2025-06-01 08:53:15', 2),
('joão.vitor-7267@email.com', '903953', 'ALUNO', '2025-07-07 08:55:19', 6),
('yan-4214@email.com', '116584', 'ALUNO', '2025-07-24 18:07:06', 9),
('pedro.henrique-2328@email.com', '706540', 'ALUNO', '2025-06-23 10:18:01', 5),
('josé.pedro-9215@email.com', '168265', 'ALUNO', '2025-03-17 17:14:01', 4),
('késia-2915@email.com', '737865', 'ALUNO', '2025-05-09 20:19:31', 6),
('maria.cecília-5332@email.com', '569749', 'ALUNO', '2025-07-16 03:31:51', 7),
('ayla-2517@email.com', '447567', 'ALUNO', '2025-05-24 15:41:01', 5),
('luiz.henrique-3798@email.com', '834678', 'ALUNO', '2025-02-02 20:16:03', 7),
('dominique-5166@email.com', '405162', 'ALUNO', '2025-06-02 05:52:32', 7),
('beatriz-3967@email.com', '116000', 'ALUNO', '2025-04-18 03:39:24', 5);

INSERT INTO
    usuario_aluno (usuario_id, nome, sobrenome, cpf, sexo, turma_id)
VALUES
(6, 'Íris', 'Mendes', '506.474.736-35', 'FEMININO', '1'),
(7, 'Jade', 'Castro', '358.241.948-91', 'FEMININO', '1'),
(8, 'Dominic', 'Mendes', '230.226.457-81', 'MASCULINO', '1'),
(9, 'João Miguel', 'Nunes', '438.414.807-57', 'MASCULINO', '1'),
(10, 'Olívia', 'Morais', '388.721.628-71', 'FEMININO', '1'),
(11, 'Emanuel', 'Andrade', '648.598.818-60', 'MASCULINO', '1'),
(12, 'Janaína', 'Barbosa', '588.326.827-51', 'FEMININO', '1'),
(13, 'Ayla', 'Moreira', '727.771.677-27', 'FEMININO', '1'),
(14, 'Alícia', 'Cardoso', '431.732.495-43', 'FEMININO', '1'),
(15, 'Maitê', 'Barros', '101.564.737-36', 'FEMININO', '1'),
(16, 'Maria Cecília', 'Medeiros', '790.202.232-31', 'FEMININO', '2'),
(17, 'Heitor', 'Castro', '880.867.435-92', 'MASCULINO', '2'),
(18, 'Pedro Henrique', 'Batista', '233.341.535-33', 'MASCULINO', '2'),
(19, 'Camila', 'Castro', '804.899.752-73', 'FEMININO', '2'),
(20, 'Thiago', 'Barros', '260.570.948-33', 'MASCULINO', '2'),
(21, 'Melinda', 'Castro', '948.818.696-40', 'FEMININO', '2'),
(22, 'Lara', 'Guedes', '338.163.412-23', 'FEMININO', '2'),
(23, 'Davi Lucas', 'Cunha', '459.520.891-97', 'MASCULINO', '2'),
(24, 'Nicolas', 'Cunha', '946.413.581-86', 'MASCULINO', '2'),
(25, 'Maria Cecília', 'Souza', '406.918.165-10', 'FEMININO', '2'),
(26, 'Pedro', 'Fernandes', '543.556.493-90', 'MASCULINO', '3'),
(27, 'Davi Luiz', 'Barros', '249.424.733-92', 'MASCULINO', '3'),
(28, 'Liz', 'Batista', '459.658.342-68', 'FEMININO', '3'),
(29, 'João Gabriel', 'Dias', '788.551.778-83', 'MASCULINO', '3'),
(30, 'Gabriela', 'Andrade', '317.744.542-81', 'FEMININO', '3'),
(31, 'Sophia', 'Barbosa', '322.364.348-25', 'FEMININO', '3'),
(32, 'Isabella', 'Farias', '262.993.357-16', 'FEMININO', '3'),
(33, 'Davi Luiz', 'Silva', '850.845.827-78', 'MASCULINO', '3'),
(34, 'Felipe', 'Barbosa', '864.529.581-18', 'MASCULINO', '3'),
(35, 'Martin', 'Fernandes', '675.331.267-91', 'MASCULINO', '3'),
(36, 'Vitor', 'Cardoso', '376.811.271-52', 'MASCULINO', '4'),
(37, 'Dom', 'Lima', '403.217.440-41', 'MASCULINO', '4'),
(38, 'Raul', 'Ribeiro', '825.243.287-84', 'MASCULINO', '4'),
(39, 'Asafe', 'Jesus', '459.557.125-57', 'MASCULINO', '4'),
(40, 'Kiara', 'Guimarães', '669.329.349-53', 'FEMININO', '4'),
(41, 'Maria Alice', 'Barbosa', '756.183.358-16', 'FEMININO', '4'),
(42, 'Zara', 'Miranda', '629.107.149-27', 'FEMININO', '4'),
(43, 'Heloísa', 'Cardoso', '338.823.717-38', 'FEMININO', '4'),
(44, 'Theo', 'Barros', '620.179.112-52', 'MASCULINO', '4'),
(45, 'Ravena', 'Marinho', '980.684.596-65', 'FEMININO', '4'),
(46, 'Leona', 'Martins', '247.980.197-38', 'FEMININO', '5'),
(47, 'Lívia', 'Farias', '703.758.823-44', 'FEMININO', '5'),
(48, 'Janaína', 'Machado', '494.312.253-38', 'FEMININO', '5'),
(49, 'Isaac', 'Carvalho', '846.359.468-26', 'MASCULINO', '5'),
(50, 'Guilherme Fernandes', 'Ribeiro', '221.519.931-11', 'MASCULINO', '5'),
(51, 'Mariana', 'Campos', '243.306.307-99', 'FEMININO', '5'),
(52, 'Antonio', 'Mendes', '298.175.114-71', 'MASCULINO', '5'),
(53, 'Francisco', 'Almeida', '720.491.609-13', 'MASCULINO', '5'),
(54, 'Oliver', 'Miranda', '574.485.850-77', 'MASCULINO', '5'),
(55, 'Agatha', 'Oliveira', '448.698.388-76', 'FEMININO', '5'),
(56, 'Maria Clara', 'Machado', '656.275.484-41', 'FEMININO', '6'),
(57, 'Vicky', 'Andrade', '438.771.350-11', 'FEMININO', '6'),
(58, 'Caleb', 'Azevedo', '878.817.426-34', 'MASCULINO', '6'),
(59, 'Louise', 'Nunes', '965.672.435-87', 'FEMININO', '6'),
(60, 'Kamala', 'Viana', '604.187.823-76', 'FEMININO', '6'),
(61, 'Zara', 'Guedes', '812.374.273-53', 'FEMININO', '6'),
(62, 'Ana Clara', 'Cavalcanti', '664.660.960-87', 'FEMININO', '6'),
(63, 'Emanuelly', 'Rodrigues', '475.404.685-21', 'FEMININO', '6'),
(64, 'Noah', 'Batista', '265.910.687-96', 'MASCULINO', '6'),
(65, 'Gabriel', 'Marques', '319.489.747-80', 'MASCULINO', '6'),
(66, 'Matheus', 'Ferreira', '340.887.376-89', 'MASCULINO', '7'),
(67, 'João Miguel', 'Pereira', '348.656.541-11', 'MASCULINO', '7'),
(68, 'Joao Pedro', 'Rodrigues', '469.402.767-73', 'MASCULINO', '7'),
(69, 'Serena', 'Martins', '760.938.231-45', 'FEMININO', '7'),
(70, 'Sasha', 'Fernandes', '479.433.340-98', 'FEMININO', '7'),
(71, 'Jade', 'Reis', '499.602.840-98', 'FEMININO', '7'),
(72, 'Alícia', 'Ribeiro', '987.376.815-85', 'FEMININO', '7'),
(73, 'Josué', 'Pontes', '857.972.577-86', 'MASCULINO', '7'),
(74, 'Flora', 'Araújo', '835.916.934-71', 'FEMININO', '7'),
(75, 'Elisa', 'Moraes', '706.612.696-72', 'FEMININO', '7'),
(76, 'Louise', 'Carvalho', '855.567.462-43', 'FEMININO', '8'),
(77, 'Anthony', 'Freitas', '983.601.925-55', 'MASCULINO', '8'),
(78, 'Chloe', 'Costa', '219.239.353-46', 'FEMININO', '8'),
(79, 'Henry', 'Guerra', '159.578.615-48', 'MASCULINO', '8'),
(80, 'Eduardo', 'Fernandes', '187.274.530-25', 'MASCULINO', '8'),
(81, 'Gustavo', 'Mendes', '766.828.783-21', 'MASCULINO', '8'),
(82, 'Joaquim', 'Ribeiro', '578.340.722-16', 'MASCULINO', '8'),
(83, 'Daniel', 'Oliveira', '500.512.514-54', 'MASCULINO', '8'),
(84, 'Erick', 'Castro', '318.584.825-45', 'MASCULINO', '8'),
(85, 'Luiz Henrique', 'Araújo', '826.604.157-20', 'MASCULINO', '8'),
(86, 'Davi Lucca', 'Coelho', '254.208.846-46', 'MASCULINO', '9'),
(87, 'Bella', 'Castro', '736.955.286-25', 'FEMININO', '9'),
(88, 'Nathan', 'Marques', '525.593.681-20', 'MASCULINO', '9'),
(89, 'Luiz Henrique', 'Gonçalves', '694.796.705-68', 'MASCULINO', '9'),
(90, 'Kiara', 'Fernandes', '819.923.745-95', 'FEMININO', '9'),
(91, 'Lia', 'Viana', '517.665.369-84', 'FEMININO', '9'),
(92, 'Clara', 'Batista', '878.559.600-85', 'FEMININO', '9'),
(93, 'Liz', 'Machado', '238.436.790-75', 'FEMININO', '9'),
(94, 'Letícia', 'Dias', '605.767.379-58', 'FEMININO', '9'),
(95, 'Íris', 'Araújo', '396.931.961-65', 'FEMININO', '9'),
(96, 'Emilly', 'Martins', '881.675.292-76', 'FEMININO', '10'),
(97, 'Emanuel', 'Pacheco', '136.275.164-94', 'MASCULINO', '10'),
(98, 'Emma', 'Peixoto', '193.140.213-45', 'FEMININO', '10'),
(99, 'Theo', 'Peixoto', '791.713.695-21', 'MASCULINO', '10'),
(100, 'Bryan', 'Cardoso', '352.314.778-12', 'MASCULINO', '10'),
(101, 'Thiago', 'Castro', '620.396.304-97', 'MASCULINO', '10'),
(102, 'Valentim', 'Gomes', '310.475.802-78', 'MASCULINO', '10'),
(103, 'Letícia', 'Castro', '914.726.367-83', 'FEMININO', '10'),
(104, 'João Gabriel', 'Moreira', '154.560.864-47', 'MASCULINO', '10'),
(105, 'Davi', 'Ribeiro', '576.876.459-79', 'MASCULINO', '10'),
(106, 'Bryan', 'Pinto', '335.466.441-71', 'MASCULINO', '11'),
(107, 'Liz', 'Fernandes', '304.183.237-52', 'FEMININO', '11'),
(108, 'Marina', 'Dias', '512.660.334-17', 'FEMININO', '11'),
(109, 'Alice', 'Mendes', '496.643.136-74', 'FEMININO', '11'),
(110, 'Oliver', 'Moraes', '651.854.262-15', 'MASCULINO', '11'),
(111, 'Janaína', 'Ferreira', '491.565.230-83', 'FEMININO', '11'),
(112, 'Agatha', 'Cavalcanti', '610.694.680-58', 'FEMININO', '11'),
(113, 'Mathias', 'Machado', '670.376.798-26', 'MASCULINO', '11'),
(114, 'Ana Luísa', 'Marques', '520.145.809-63', 'FEMININO', '11'),
(115, 'Kalel', 'Pacheco', '128.166.141-37', 'MASCULINO', '11'),
(116, 'Sol', 'Pacheco', '718.134.333-46', 'FEMININO', '12'),
(117, 'Vicente', 'Barros', '872.251.203-96', 'MASCULINO', '12'),
(118, 'Luna', 'Cardoso', '894.648.732-15', 'FEMININO', '12'),
(119, 'Ana Clara', 'Machado', '153.158.680-30', 'FEMININO', '12'),
(120, 'Gael', 'Barbosa', '122.164.223-89', 'MASCULINO', '12'),
(121, 'Naomi', 'Martins', '330.352.573-66', 'FEMININO', '12'),
(122, 'Davi Miguel', 'Santos', '332.965.856-24', 'MASCULINO', '12'),
(123, 'Henrique', 'Marques', '970.916.282-29', 'MASCULINO', '12'),
(124, 'Maria Júlia', 'Cavalcanti', '310.546.215-30', 'FEMININO', '12'),
(125, 'Ester', 'Mendes', '511.734.933-12', 'FEMININO', '12'),
(126, 'Lucas', 'Nunes', '721.249.411-88', 'MASCULINO', '13'),
(127, 'Layla', 'Carvalho', '359.374.152-88', 'FEMININO', '13'),
(128, 'Augusto', 'Duarte', '426.881.804-64', 'MASCULINO', '13'),
(129, 'Betânia', 'Fernandes', '536.726.571-95', 'FEMININO', '13'),
(130, 'Estevão', 'Pacheco', '690.553.695-67', 'MASCULINO', '13'),
(131, 'Bella', 'Rodrigues', '712.340.970-64', 'FEMININO', '13'),
(132, 'Ava', 'Pontes', '195.399.163-94', 'FEMININO', '13'),
(133, 'Maíra', 'Alves', '622.313.633-88', 'FEMININO', '13'),
(134, 'Emily', 'Reis', '103.233.517-12', 'FEMININO', '13'),
(135, 'Mayra', 'Costa', '353.380.589-34', 'FEMININO', '13'),
(136, 'Lara', 'Andrade', '255.123.271-96', 'FEMININO', '14'),
(137, 'Eva', 'Rios', '351.498.851-16', 'FEMININO', '14'),
(138, 'Anthony', 'Pinto', '113.210.472-19', 'MASCULINO', '14'),
(139, 'Lorenzo', 'Barros', '742.563.144-97', 'MASCULINO', '14'),
(140, 'Asafe', 'Leite', '380.978.531-86', 'MASCULINO', '14'),
(141, 'Eva', 'Silva', '467.833.541-49', 'FEMININO', '14'),
(142, 'Evelyn', 'Nunes', '577.387.561-92', 'FEMININO', '14'),
(143, 'Helena', 'Farias', '373.149.219-60', 'FEMININO', '14'),
(144, 'Alana', 'Costa', '733.944.450-62', 'FEMININO', '14'),
(145, 'Nathan', 'Barros', '996.438.415-48', 'MASCULINO', '14'),
(146, 'Yasmin', 'Carneiro', '694.722.250-35', 'FEMININO', '15'),
(147, 'Gabriela', 'Ribeiro', '822.824.755-61', 'FEMININO', '15'),
(148, 'Nina', 'Farias', '651.195.352-60', 'FEMININO', '15'),
(149, 'Cecília', 'Barros', '973.715.510-55', 'FEMININO', '15'),
(150, 'Pilar', 'Medeiros', '169.800.443-77', 'FEMININO', '15'),
(151, 'João Miguel', 'Rios', '852.438.714-44', 'MASCULINO', '15'),
(152, 'Naomi', 'Duarte', '313.401.987-59', 'FEMININO', '15'),
(153, 'Antonio', 'Araújo', '678.503.547-34', 'MASCULINO', '15'),
(154, 'Ryan', 'Souza', '365.965.371-18', 'MASCULINO', '15'),
(155, 'Pedro', 'Barbosa', '396.979.799-51', 'MASCULINO', '15'),
(156, 'Thiago', 'Oliveira', '445.238.229-75', 'MASCULINO', '16'),
(157, 'Kalel', 'Pontes', '552.636.689-21', 'MASCULINO', '16'),
(158, 'Davi Lucca', 'Carneiro', '393.574.685-98', 'MASCULINO', '16'),
(159, 'Alice', 'Cunha', '512.414.488-84', 'FEMININO', '16'),
(160, 'Joao Pedro', 'Marques', '661.443.744-74', 'MASCULINO', '16'),
(161, 'Anne', 'Campos', '490.423.594-85', 'FEMININO', '16'),
(162, 'Breno', 'Duarte', '791.117.102-26', 'MASCULINO', '16'),
(163, 'Fernanda', 'Cavalcanti', '549.673.473-20', 'FEMININO', '16'),
(164, 'Lara', 'Monteiro', '671.419.699-82', 'FEMININO', '16'),
(165, 'João Gabriel', 'Rocha', '152.629.330-84', 'MASCULINO', '16'),
(166, 'Ravi', 'Machado', '728.376.160-95', 'MASCULINO', '17'),
(167, 'Aylla', 'Pontes', '970.527.881-59', 'FEMININO', '17'),
(168, 'Layla', 'Rios', '580.664.834-69', 'FEMININO', '17'),
(169, 'Caleb', 'Araújo', '149.700.740-25', 'MASCULINO', '17'),
(170, 'Sol', 'Farias', '759.796.109-35', 'FEMININO', '17'),
(171, 'Francisco', 'Barros', '998.136.295-48', 'MASCULINO', '17'),
(172, 'Sasha', 'Fernandes', '300.613.760-18', 'FEMININO', '17'),
(173, 'Anne', 'Castro', '845.738.133-14', 'FEMININO', '17'),
(174, 'Olívia', 'Araújo', '277.943.472-43', 'FEMININO', '17'),
(175, 'Catarina', 'Lima', '996.949.393-31', 'FEMININO', '17'),
(176, 'Estevão', 'Medeiros', '457.912.667-46', 'MASCULINO', '18'),
(177, 'Guilherme', 'Gomes', '375.881.310-32', 'MASCULINO', '18'),
(178, 'Heitor', 'Barbosa', '335.635.871-35', 'MASCULINO', '18'),
(179, 'Giulia', 'Rocha', '454.475.674-22', 'FEMININO', '18'),
(180, 'Lucas', 'Barros', '389.879.648-61', 'MASCULINO', '18'),
(181, 'Raabe', 'Souza', '481.703.187-23', 'FEMININO', '18'),
(182, 'Liam', 'Medeiros', '868.102.332-86', 'MASCULINO', '18'),
(183, 'Breno', 'Freitas', '329.343.306-99', 'MASCULINO', '18'),
(184, 'Lívia', 'Leite', '838.654.284-62', 'FEMININO', '18'),
(185, 'Léonovo', 'Machado', '597.138.776-56', 'MASCULINO', '18'),
(186, 'Louise', 'Freitas', '893.994.870-78', 'FEMININO', '19'),
(187, 'Manuela', 'Guedes', '996.635.710-92', 'FEMININO', '19'),
(188, 'Valentina', 'Jesus', '814.930.379-69', 'FEMININO', '19'),
(189, 'Cauã', 'Guerra', '296.240.909-71', 'MASCULINO', '19'),
(190, 'Beatriz', 'Castro', '755.464.593-77', 'FEMININO', '19'),
(191, 'Matheus', 'Rocha', '154.327.210-84', 'MASCULINO', '19'),
(192, 'Samuel', 'Pereira', '355.804.674-55', 'MASCULINO', '19'),
(193, 'Naomi', 'Guimarães', '207.570.887-20', 'FEMININO', '19'),
(194, 'Bianca', 'Pontes', '319.642.682-60', 'FEMININO', '19'),
(195, 'Caleb', 'Reis', '265.527.348-34', 'MASCULINO', '19'),
(196, 'João Vitor', 'Moreira', '380.795.313-47', 'MASCULINO', '20'),
(197, 'Yan', 'Mendes', '656.345.523-21', 'MASCULINO', '20'),
(198, 'Pedro Henrique', 'Santos', '436.977.371-93', 'MASCULINO', '20'),
(199, 'José Pedro', 'Gomes', '732.322.212-14', 'MASCULINO', '20'),
(200, 'Késia', 'Machado', '393.450.474-28', 'FEMININO', '20'),
(201, 'Maria Cecília', 'Marques', '385.478.576-43', 'FEMININO', '20'),
(202, 'Ayla', 'Pinto', '319.782.670-89', 'FEMININO', '20'),
(203, 'Luiz Henrique', 'Pereira', '797.416.329-63', 'MASCULINO', '20'),
(204, 'Dominique', 'Azevedo', '175.931.589-82', 'FEMININO', '20'),
(205, 'Beatriz', 'Almeida', '855.952.184-53', 'FEMININO', '20');


INSERT INTO denuncia
    (titulo, conteudo, tipo, situacao_analise, local_fato_id, autor_id, pedagogo_id, analista_id)
VALUES
    -- Alunos: ids 6 a 205
    -- Analistas: ids 2 e 3
    -- Pedagogos: ids 4 e 5

    -- id: 1
    ('Briga no intervalo', 'Durante o recreio eu fui empurrado e levei socos de dois colegas.', 'VIOLENCIA_FISICA', 'NAO_INICIADA', 1, 15, 4, 2),
    -- id: 2
    ('Ameaças no corredor', 'Um aluno me disse que iria me bater depois da aula e fiquei com medo.', 'VIOLENCIA_VERBAL', 'NAO_INICIADA', 2, 8, 4, 2),
    -- id: 3
    ('Mensagens ofensivas no WhatsApp', 'Eu e um colega estamos recebendo xingamentos e piadas em um grupo da turma.', 'CYBER_BULLYING', 'INICIADA', 3, 8, 5, 3);

INSERT INTO denuncia_vitima
    (denuncia_id, vitima_id)
VALUES
    (1, 103),
    (2, 165),
    (3, 200),
    (3, 201);

INSERT INTO denuncia_agressor
    (denuncia_id, agressor_id)
VALUES
    (1, 30),
    (1, 32),

    (2, 45),

    (3, 75),
    (2, 52),
    (2, 57),
    (2, 58),
    (2, 65);
