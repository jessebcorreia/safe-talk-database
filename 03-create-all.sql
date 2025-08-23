DROP DATABASE IF EXISTS safe_talk;

CREATE DATABASE safe_talk CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE safe_talk;

-- Endereço
CREATE TABLE endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    logradouro VARCHAR(150) ,
    numero VARCHAR(20),
    complemento VARCHAR(100),
    bairro VARCHAR(100),
    cidade VARCHAR(100) ,
    estado CHAR(2) ,
    cep CHAR(9) ,
    pais VARCHAR(50) 
);

-- Responsável
CREATE TABLE responsavel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) ,
    sobrenome VARCHAR(100) ,
    cpf CHAR(14)  UNIQUE,
    telefone VARCHAR(20),
    parentesco ENUM('PAI', 'MAE', 'TUTOR', 'OUTRO') 
);

-- Usuário
CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100)  UNIQUE,
    senha VARCHAR(255) ,
    criado_em DATETIME  DEFAULT CURRENT_TIMESTAMP,
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
    nome VARCHAR(100) ,
    sobrenome VARCHAR(100) ,
    cpf CHAR(14)  UNIQUE,
    sexo ENUM('MASCULINO', 'FEMININO') 
);

-- Usuário/Aluno (chave primária compartilhada - criada depois)
CREATE TABLE usuario_pedagogo (
    nome VARCHAR(100) ,
    sobrenome VARCHAR(100) ,
    cpf CHAR(14)  UNIQUE,
    sexo ENUM('MASCULINO', 'FEMININO') 
);

-- Usuário/Aluno (chave primária compartilhada - criada depois)
CREATE TABLE usuario_analista (
    nome VARCHAR(100) ,
    sobrenome VARCHAR(100) ,
    cpf CHAR(14)  UNIQUE,
    sexo ENUM('MASCULINO', 'FEMININO') 
);

-- Usuário/Unidade de Ensino (chave primária compartilhada - criada depois)
CREATE TABLE usuario_unidade_ensino (
    nome_fantasia VARCHAR(100) ,
    razao_social VARCHAR(100),
    cnpj CHAR(18)  UNIQUE,
    descricao TEXT
);

-- Curso
CREATE TABLE curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100)  UNIQUE,
    descricao TEXT,
    criado_em DATETIME  DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME
);

-- Turma
CREATE TABLE turma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100)  UNIQUE,
    descricao TEXT,
    periodo ENUM('MATUTINO', 'VESPERTINO', 'NOTURNO'),
    criado_em DATETIME  DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME
);

-- Denúncia
CREATE TABLE denuncia (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) ,
    conteudo TEXT ,
    tipo ENUM(
        'VIOLENCIA_FISICA',
        'VIOLENCIA_VERBAL',
        'CYBER_BULLYING'
    ) ,
    criado_em DATETIME  DEFAULT CURRENT_TIMESTAMP,
    atualizado_em DATETIME
);

-- Andamento
CREATE TABLE andamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conteudo TEXT ,
    criado_em DATETIME  DEFAULT CURRENT_TIMESTAMP,
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

-- Responsável
ALTER TABLE
    responsavel
ADD
    COLUMN aluno_id INT ,
ADD
    CONSTRAINT fk_responsavel_aluno FOREIGN KEY (aluno_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Usuário
ALTER TABLE
    usuario
ADD
    COLUMN endereco_id INT ,
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
    COLUMN unidade_ensino_id INT ,
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
    COLUMN curso_id INT ,
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
    COLUMN autor_id INT ,
ADD
    COLUMN analista_id INT ,
ADD
    CONSTRAINT fk_denuncia_local_fato FOREIGN KEY (local_fato_id) REFERENCES endereco(id) ON DELETE RESTRICT ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_denuncia_autor FOREIGN KEY (autor_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE,
ADD
    CONSTRAINT fk_denuncia_analista FOREIGN KEY (analista_id) REFERENCES usuario(id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- Denúncia/Vítimas (N:N)
-- Uma denúncia pode ter várias vítimas, e um usuário pode ser vítima em várias denúncias
CREATE TABLE denuncia_vitima (
    denuncia_id INT ,
    vitima_id INT ,
    PRIMARY KEY (denuncia_id, vitima_id),
    CONSTRAINT fk_denuncia_vitima_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_vitima_vitima FOREIGN KEY (vitima_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Denúncia/Agressores (N:N)
-- Uma denúncia pode ter vários agressores, e um usuário pode ser agressor em várias denúncias
CREATE TABLE denuncia_agressor (
    denuncia_id INT ,
    agressor_id INT ,
    PRIMARY KEY (denuncia_id, agressor_id),
    CONSTRAINT fk_denuncia_agressor_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_agressor_agressor FOREIGN KEY (agressor_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Denúncia/Pedagogos (N:N)
-- Uma denúncia pode ter vários pedagogos, e um usuário pode ser pedagogo em várias denúncias
CREATE TABLE denuncia_pedagogo (
    denuncia_id INT ,
    pedagogo_id INT ,
    PRIMARY KEY (denuncia_id, pedagogo_id),
    CONSTRAINT fk_denuncia_pedagogo_denuncia FOREIGN KEY (denuncia_id) REFERENCES denuncia(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_denuncia_pedagogo_pedagogo FOREIGN KEY (pedagogo_id) REFERENCES usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Andamento
ALTER TABLE
    andamento
ADD
    COLUMN denuncia_id INT ,
ADD
    COLUMN autor_id INT ,
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
    ) ,
    CONSTRAINT fk_andamento_arquivamento_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Andamento/Desarquivamento (1:1)
-- Se o andamento for do tipo "DESARQUIVAMENTO", as informações complementares ficarão nessa tabela
CREATE TABLE andamento_desarquivamento (
    andamento_id INT PRIMARY KEY,
    motivo ENUM('NOVAS_INFORMACOES', 'REVISAO_DA_DENUNCIA') ,
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
    data_hora DATETIME ,
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
    ) ,
    atualizado_em DATETIME,
    CONSTRAINT fk_andamento_parecer_final_andamento FOREIGN KEY (andamento_id) REFERENCES andamento(id) ON DELETE CASCADE ON UPDATE CASCADE
);

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
    (2, 'João', 'Analista da Silva', '861.534.872-92', 'MASCULINO'),
    -- usuario_id: 3
    (3, 'Maria', 'Pereira Analista da Costa', '845.269.456-15', 'FEMININO');

INSERT INTO
    usuario_pedagogo (usuario_id, nome, sobrenome, cpf, sexo)
VALUES
    -- usuario_id: 4
    (4, 'Josicleison', 'o Pedagogo', '563.534.856-92', 'MASCULINO'),
    -- usuario_id: 5
    (5, 'Luana', 'Andrade Pedagoga Santos', '379.568.339-56', 'FEMININO');



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
    ('Info Básica - Turma A', 'Introdução ao uso do computador e do sistema operacional.', 'MATUTINO', 1, 4),
    ('Info Básica - Turma B', 'Uso de editores de texto, planilhas e apresentações.', 'VESPERTINO', 1, 4),
    ('Info Básica - Turma C', 'Internet segura e pesquisa acadêmica online.', 'NOTURNO', 1, 4),
    ('Info Básica - Turma D', 'Edição básica de imagens e organização de arquivos.', 'MATUTINO', 1, 4),
    ('Info Básica - Turma E', 'Projeto final com aplicação dos conhecimentos adquiridos.', 'VESPERTINO', 1, 4),

    -- Curso 2: Inglês Intermediário
    ('Inglês Interm. - Turma A', 'Conversação básica para situações do cotidiano.', 'MATUTINO', 2, 4),
    ('Inglês Interm. - Turma B', 'Vocabulário para viagens e interações escolares.', 'VESPERTINO', 2, 4),
    ('Inglês Interm. - Turma C', 'Prática de leitura e interpretação de textos simples.', 'NOTURNO', 2, 4),
    ('Inglês Interm. - Turma D', 'Escrita de frases e pequenos diálogos.', 'MATUTINO', 2, 4),
    ('Inglês Interm. - Turma E', 'Apresentações orais e compreensão auditiva.', 'VESPERTINO', 2, 4),

    -- Curso 3: Matemática Aplicada
    ('Mat Aplicada - Turma A', 'Revisão de operações básicas e resolução de problemas.', 'MATUTINO', 3, 5),
    ('Mat Aplicada - Turma B', 'Introdução à geometria e medidas.', 'VESPERTINO', 3, 5),
    ('Mat Aplicada - Turma C', 'Porcentagem, juros simples e compostos.', 'NOTURNO', 3, 5),
    ('Mat Aplicada - Turma D', 'Estatística básica para projetos escolares.', 'MATUTINO', 3, 5),
    ('Mat Aplicada - Turma E', 'Resolução de problemas do dia a dia.', 'VESPERTINO', 3, 5),

    -- Curso 4: Educação Artística
    ('Ed Artística - Turma A', 'Técnicas de desenho e sombreamento.', 'MATUTINO', 4, 5),
    ('Ed Artística - Turma B', 'Introdução à pintura com guache e aquarela.', 'VESPERTINO', 4, 5),
    ('Ed Artística - Turma C', 'Artesanato e trabalhos manuais criativos.', 'NOTURNO', 4, 5),
    ('Ed Artística - Turma D', 'História da arte e inspiração criativa.', 'MATUTINO', 4, 5),
    ('Ed Artística - Turma E', 'Projeto final com exposição das obras.', 'VESPERTINO', 4, 5);



INSERT INTO
    usuario (email, senha, cargo, criado_em, endereco_id)
VALUES
    ('kiara.1746@email.com', '657377', 'ALUNO', '2025-06-03 23:11:30', 7),
    ('bernardo-5353@email.com', '979347', 'ALUNO', '2025-06-05 18:16:52', 8),
    ('bento-5630@email.com', '580932', 'ALUNO', '2025-03-04 03:53:22', 1),
    ('lucca-2423@email.com', '941516', 'ALUNO', '2025-02-17 12:56:53', 8),
    ('marina-9537@email.com', '721985', 'ALUNO', '2025-05-03 05:23:08', 3),
    ('ester-9888@email.com', '867143', 'ALUNO', '2025-01-25 12:19:08', 2),
    ('liam-8819@email.com', '409684', 'ALUNO', '2025-03-11 04:19:25', 4),
    ('maitê-8184@email.com', '375865', 'ALUNO', '2025-04-02 23:18:15', 9),
    ('caio-8029@email.com', '268426', 'ALUNO', '2025-07-26 13:06:30', 3),
    ('maria.cecília-3821@email.com', '234606', 'ALUNO', '2025-08-01 11:46:18', 5),
    ('pedro.henrique-7729@email.com', '226021', 'ALUNO', '2025-02-19 21:56:15', 5),
    ('emily-3423@email.com', '852339', 'ALUNO', '2025-05-22 07:40:49', 5),
    ('davi.miguel-9587@email.com', '400252', 'ALUNO', '2025-04-06 02:39:09', 3),
    ('ravena-1959@email.com', '760836', 'ALUNO', '2025-06-09 23:44:25', 5),
    ('pedro-5562@email.com', '581575', 'ALUNO', '2025-01-17 18:50:19', 6),
    ('antonella-1627@email.com', '354159', 'ALUNO', '2025-07-25 04:27:19', 9),
    ('caleb-2838@email.com', '983379', 'ALUNO', '2025-05-29 20:52:48', 8),
    ('francisco-5540@email.com', '742886', 'ALUNO', '2025-05-01 03:15:21', 6),
    ('anthony-4248@email.com', '685199', 'ALUNO', '2025-06-14 07:28:33', 7),
    ('luiz.henrique-6974@email.com', '707132', 'ALUNO', '2025-05-28 01:41:25', 2),
    ('vicente-3891@email.com', '194565', 'ALUNO', '2025-01-19 18:27:40', 8),
    ('vitor-6422@email.com', '309776', 'ALUNO', '2025-06-03 21:34:55', 1),
    ('luna-6796@email.com', '135220', 'ALUNO', '2025-02-23 07:28:43', 9),
    ('davi.lucca-5910@email.com', '944400', 'ALUNO', '2025-02-14 17:06:10', 3),
    ('lia-1607@email.com', '332668', 'ALUNO', '2025-03-10 02:50:13', 3),
    ('rafael-7980@email.com', '218630', 'ALUNO', '2025-03-17 21:52:10', 1),
    ('cecília-9349@email.com', '599531', 'ALUNO', '2025-06-23 08:13:22', 6),
    ('maíra-9359@email.com', '399953', 'ALUNO', '2025-05-04 20:12:19', 10),
    ('olívia-2136@email.com', '172860', 'ALUNO', '2025-04-09 17:00:27', 7),
    ('bernardo-1851@email.com', '380827', 'ALUNO', '2025-01-07 16:01:41', 7),
    ('maya-3930@email.com', '579001', 'ALUNO', '2025-05-11 00:36:50', 4),
    ('kiara-2429@email.com', '756773', 'ALUNO', '2025-02-04 15:58:00', 6),
    ('zara-9948@email.com', '525833', 'ALUNO', '2025-03-16 20:50:50', 5),
    ('ester-2078@email.com', '665269', 'ALUNO', '2025-02-20 02:23:04', 6),
    ('lucas-4606@email.com', '606902', 'ALUNO', '2025-03-22 16:44:19', 5),
    ('ravena-5208@email.com', '874238', 'ALUNO', '2025-02-19 02:38:39', 3),
    ('henrique-4919@email.com', '763100', 'ALUNO', '2025-03-01 01:35:07', 10),
    ('lucas-4584@email.com', '151046', 'ALUNO', '2025-05-02 06:23:18', 2),
    ('beatriz-5711@email.com', '936686', 'ALUNO', '2025-03-18 19:37:47', 6),
    ('helena-7529@email.com', '515544', 'ALUNO', '2025-06-01 19:25:05', 9),
    ('levi-7749@email.com', '757858', 'ALUNO', '2025-03-19 05:44:27', 4),
    ('vinícius-5509@email.com', '742359', 'ALUNO', '2025-02-04 15:14:27', 1),
    ('arthur.miguel-1011@email.com', '800006', 'ALUNO', '2025-02-16 01:00:48', 6),
    ('asafe-7296@email.com', '915944', 'ALUNO', '2025-07-18 22:22:59', 8),
    ('alana-6005@email.com', '755666', 'ALUNO', '2025-03-16 00:57:07', 9),
    ('oliver-4527@email.com', '883416', 'ALUNO', '2025-06-22 06:22:27', 9),
    ('joice-5447@email.com', '104470', 'ALUNO', '2025-02-26 04:45:53', 2),
    ('valentina-4589@email.com', '943845', 'ALUNO', '2025-03-28 07:56:02', 9),
    ('francisco-1903@email.com', '311504', 'ALUNO', '2025-05-12 02:36:21', 1),
    ('davi.luiz-8498@email.com', '699753', 'ALUNO', '2025-01-31 10:33:42', 5),
    ('fernanda-7954@email.com', '508306', 'ALUNO', '2025-03-16 15:55:26', 1),
    ('oliver-9051@email.com', '358510', 'ALUNO', '2025-03-13 14:47:42', 4),
    ('josé.miguel-6690@email.com', '334244', 'ALUNO', '2025-03-20 14:34:29', 3),
    ('maria.cecília-2121@email.com', '658794', 'ALUNO', '2025-04-20 13:39:51', 2),
    ('maíra-3899@email.com', '160123', 'ALUNO', '2025-06-24 10:23:51', 5),
    ('joice-8191@email.com', '618384', 'ALUNO', '2025-06-19 20:43:45', 5),
    ('alba-3003@email.com', '313714', 'ALUNO', '2025-05-06 17:32:23', 10),
    ('liz-8983@email.com', '574044', 'ALUNO', '2025-01-17 03:45:57', 3),
    ('camila-5862@email.com', '701471', 'ALUNO', '2025-03-02 14:18:22', 8),
    ('joão.miguel-3834@email.com', '422557', 'ALUNO', '2025-06-28 00:28:50', 6),
    ('guilherme-2772@email.com', '845104', 'ALUNO', '2025-01-14 03:05:26', 7),
    ('matheus-9090@email.com', '608951', 'ALUNO', '2025-07-23 21:45:15', 9),
    ('leona-2473@email.com', '597786', 'ALUNO', '2025-06-20 05:43:07', 8),
    ('caio-6341@email.com', '326684', 'ALUNO', '2025-02-01 23:51:52', 9),
    ('henrique-7441@email.com', '676920', 'ALUNO', '2025-05-06 10:30:08', 8),
    ('thomas-5702@email.com', '152623', 'ALUNO', '2025-05-30 09:43:22', 1),
    ('nathan-9305@email.com', '955920', 'ALUNO', '2025-04-30 11:01:21', 3),
    ('matteo-7722@email.com', '878502', 'ALUNO', '2025-03-10 11:45:52', 10),
    ('olívia-8907@email.com', '457724', 'ALUNO', '2025-05-20 06:51:45', 3),
    ('elisa-1190@email.com', '152732', 'ALUNO', '2025-04-22 13:14:18', 5),
    ('pérola-7166@email.com', '392100', 'ALUNO', '2025-06-06 22:55:21', 3),
    ('valentina-4043@email.com', '181477', 'ALUNO', '2025-02-25 09:28:17', 8),
    ('davi.miguel-6809@email.com', '241258', 'ALUNO', '2025-02-10 01:02:17', 6),
    ('beatriz-1166@email.com', '684121', 'ALUNO', '2025-07-17 16:53:46', 8),
    ('laura-4797@email.com', '952756', 'ALUNO', '2025-07-11 22:51:43', 4),
    ('bella-9653@email.com', '618687', 'ALUNO', '2025-07-02 08:29:10', 8),
    ('anthony-7375@email.com', '826977', 'ALUNO', '2025-04-16 00:25:18', 3),
    ('josé.pedro-3444@email.com', '697821', 'ALUNO', '2025-07-29 10:38:52', 8),
    ('nicolas-8141@email.com', '196421', 'ALUNO', '2025-04-10 23:36:21', 2),
    ('murilo-5302@email.com', '976821', 'ALUNO', '2025-02-19 11:35:19', 9),
    ('daniel-7931@email.com', '982283', 'ALUNO', '2025-05-23 12:19:18', 10),
    ('luiz.miguel-9119@email.com', '957695', 'ALUNO', '2025-05-26 07:24:41', 3),
    ('enzo.gabriel-6397@email.com', '825636', 'ALUNO', '2025-07-05 13:47:44', 3),
    ('ava-7553@email.com', '433640', 'ALUNO', '2025-06-24 12:48:51', 1),
    ('maria.cecília-9043@email.com', '435256', 'ALUNO', '2025-08-01 12:13:49', 2),
    ('liz-7847@email.com', '262159', 'ALUNO', '2025-04-22 20:11:10', 1),
    ('emilly-1375@email.com', '283769', 'ALUNO', '2025-07-27 14:15:16', 8),
    ('maria.clara-1000@email.com', '791774', 'ALUNO', '2025-03-27 00:13:43', 3),
    ('alícia-3188@email.com', '458028', 'ALUNO', '2025-07-17 16:58:06', 7),
    ('lucas-1353@email.com', '727914', 'ALUNO', '2025-03-28 19:38:19', 7),
    ('antonella-1628@email.com', '515877', 'ALUNO', '2025-05-17 05:48:16', 6),
    ('guilherme-6321@email.com', '576426', 'ALUNO', '2025-04-05 18:46:16', 10),
    ('melinda-3692@email.com', '816161', 'ALUNO', '2025-04-14 07:17:44', 7),
    ('emanuel-6118@email.com', '800661', 'ALUNO', '2025-03-31 20:47:44', 8),
    ('henrique-3919@email.com', '105726', 'ALUNO', '2025-03-14 02:34:05', 7),
    ('benício-4577@email.com', '644014', 'ALUNO', '2025-05-28 02:21:23', 1),
    ('luna-6562@email.com', '731411', 'ALUNO', '2025-04-12 07:58:15', 2),
    ('kiara-7436@email.com', '274274', 'ALUNO', '2025-03-18 13:19:28', 10),
    ('ravi.lucca-8356@email.com', '162773', 'ALUNO', '2025-08-01 04:07:05', 9),
    ('oliver-4372@email.com', '102148', 'ALUNO', '2025-07-22 09:25:12', 2),
    ('stella-8184@email.com', '362800', 'ALUNO', '2025-07-06 08:09:38', 1),
    ('sophia-1581@email.com', '755475', 'ALUNO', '2025-02-25 12:06:59', 5),
    ('liam-8537@email.com', '566609', 'ALUNO', '2025-05-21 15:20:45', 5),
    ('bella-9634@email.com', '334255', 'ALUNO', '2025-04-03 13:44:42', 4),
    ('davi.miguel-9296@email.com', '627683', 'ALUNO', '2025-04-14 16:07:46', 1),
    ('eloá-8402@email.com', '634539', 'ALUNO', '2025-01-13 15:09:01', 3),
    ('arthur-4508@email.com', '218426', 'ALUNO', '2025-04-09 18:09:13', 7),
    ('josé.pedro-2100@email.com', '844744', 'ALUNO', '2025-06-08 23:05:05', 3),
    ('charlotte-5086@email.com', '462715', 'ALUNO', '2025-04-11 04:53:16', 7),
    ('olga-9540@email.com', '429824', 'ALUNO', '2025-01-26 21:43:06', 4),
    ('beatriz-3595@email.com', '792387', 'ALUNO', '2025-01-31 15:51:20', 5),
    ('leonardo-4718@email.com', '278337', 'ALUNO', '2025-07-07 18:25:59', 5),
    ('flora-1356@email.com', '618326', 'ALUNO', '2025-04-20 23:43:35', 8),
    ('josé.miguel-4346@email.com', '878655', 'ALUNO', '2025-03-18 15:18:13', 7),
    ('leonor-3356@email.com', '573341', 'ALUNO', '2025-02-18 01:52:21', 7),
    ('joão-4873@email.com', '182464', 'ALUNO', '2025-02-01 20:05:14', 1),
    ('asafe-5999@email.com', '450142', 'ALUNO', '2025-07-31 04:03:06', 9),
    ('gabriel-5458@email.com', '243539', 'ALUNO', '2025-05-20 12:04:43', 9),
    ('joao.pedro-5375@email.com', '902398', 'ALUNO', '2025-01-06 04:54:23', 1),
    ('levi-5454@email.com', '734282', 'ALUNO', '2025-06-09 07:55:07', 10),
    ('caio-7465@email.com', '543480', 'ALUNO', '2025-02-16 07:01:00', 1),
    ('maria.júlia-2074@email.com', '578280', 'ALUNO', '2025-07-28 00:39:18', 1),
    ('breno-5698@email.com', '247880', 'ALUNO', '2025-02-04 19:04:36', 2),
    ('stella-8298@email.com', '189835', 'ALUNO', '2025-01-26 11:01:16', 4),
    ('anthony.gabriel-7692@email.com', '329594', 'ALUNO', '2025-07-16 15:47:29', 9),
    ('erick-8749@email.com', '457343', 'ALUNO', '2025-05-22 07:38:59', 6),
    ('elisa-2530@email.com', '293840', 'ALUNO', '2025-05-11 11:00:38', 10),
    ('estevão-1537@email.com', '474277', 'ALUNO', '2025-06-05 03:14:22', 5),
    ('maíra-5382@email.com', '480235', 'ALUNO', '2025-06-21 15:14:38', 9),
    ('eva-8977@email.com', '351079', 'ALUNO', '2025-03-12 23:11:59', 2),
    ('nina-3848@email.com', '982234', 'ALUNO', '2025-06-04 20:33:39', 7),
    ('laura-3581@email.com', '299845', 'ALUNO', '2025-05-09 00:37:20', 5),
    ('ravi-4463@email.com', '552983', 'ALUNO', '2025-03-28 03:04:31', 9),
    ('anthony-5652@email.com', '840928', 'ALUNO', '2025-07-20 04:21:59', 9),
    ('safira-5255@email.com', '628891', 'ALUNO', '2025-05-16 19:48:42', 6),
    ('cauã-4085@email.com', '986898', 'ALUNO', '2025-04-28 03:34:04', 10),
    ('josé.miguel-6482@email.com', '660861', 'ALUNO', '2025-06-15 06:10:40', 8),
    ('lorenzo-5879@email.com', '147972', 'ALUNO', '2025-01-25 16:15:59', 6),
    ('eduardo-9259@email.com', '837027', 'ALUNO', '2025-03-10 02:48:23', 7),
    ('martin-5707@email.com', '112219', 'ALUNO', '2025-05-06 06:10:34', 3),
    ('maria.cecília-8721@email.com', '313618', 'ALUNO', '2025-06-20 11:43:18', 5),
    ('elisa-1092@email.com', '298613', 'ALUNO', '2025-01-30 10:23:32', 4),
    ('luiz.miguel-7161@email.com', '171714', 'ALUNO', '2025-01-15 01:57:31', 3),
    ('pérola-2854@email.com', '582204', 'ALUNO', '2025-03-26 21:07:37', 8),
    ('yuri-6762@email.com', '574264', 'ALUNO', '2025-06-18 18:34:29', 5),
    ('nina-4676@email.com', '656442', 'ALUNO', '2025-06-30 16:56:58', 9),
    ('sasha-1651@email.com', '861506', 'ALUNO', '2025-03-03 04:55:25', 4),
    ('catarina-5435@email.com', '732350', 'ALUNO', '2025-06-26 02:34:45', 6),
    ('lucca-6620@email.com', '587191', 'ALUNO', '2025-07-12 04:07:30', 10),
    ('janaína-2692@email.com', '702402', 'ALUNO', '2025-03-27 07:16:37', 1),
    ('augusto-6914@email.com', '168550', 'ALUNO', '2025-07-06 06:08:57', 7),
    ('bernardo-5255@email.com', '857928', 'ALUNO', '2025-03-22 05:34:26', 10),
    ('dominic-6742@email.com', '133442', 'ALUNO', '2025-07-20 06:44:00', 9),
    ('luna-9139@email.com', '813588', 'ALUNO', '2025-06-17 14:32:27', 3),
    ('augusto-6298@email.com', '542163', 'ALUNO', '2025-01-19 11:30:00', 3),
    ('ravi.lucca-7366@email.com', '192615', 'ALUNO', '2025-07-03 09:53:57', 1),
    ('bianca-7854@email.com', '483463', 'ALUNO', '2025-01-12 16:17:01', 2),
    ('theodoro-6975@email.com', '392642', 'ALUNO', '2025-05-19 19:55:28', 3),
    ('anne-5089@email.com', '971626', 'ALUNO', '2025-04-18 12:06:23', 7),
    ('valentina-6355@email.com', '700524', 'ALUNO', '2025-07-04 00:38:22', 5),
    ('benício-3618@email.com', '551051', 'ALUNO', '2025-05-27 12:42:46', 4),
    ('anne-1423@email.com', '405569', 'ALUNO', '2025-02-20 23:16:24', 4),
    ('raabe-9875@email.com', '520457', 'ALUNO', '2025-07-11 19:49:45', 9),
    ('francisco-5326@email.com', '486638', 'ALUNO', '2025-07-02 01:18:53', 6),
    ('jade-3439@email.com', '909184', 'ALUNO', '2025-05-15 01:16:52', 8),
    ('josenildo-4929@email.com', '934378', 'ALUNO', '2025-01-20 14:39:24', 7),
    ('olga-3114@email.com', '631644', 'ALUNO', '2025-04-05 09:41:52', 6),
    ('benício-4479@email.com', '112867', 'ALUNO', '2025-07-07 19:26:26', 1),
    ('enzo-8082@email.com', '511025', 'ALUNO', '2025-01-25 05:36:23', 9),
    ('miguel-6041@email.com', '301841', 'ALUNO', '2025-03-29 11:54:48', 2),
    ('israel-5984@email.com', '210698', 'ALUNO', '2025-01-27 03:51:23', 8),
    ('joão.lucas-8060@email.com', '790005', 'ALUNO', '2025-07-05 09:28:24', 1),
    ('yuri-4745@email.com', '519225', 'ALUNO', '2025-03-13 08:34:17', 4),
    ('safira-2012@email.com', '869138', 'ALUNO', '2025-05-13 08:24:40', 1),
    ('pietro-8607@email.com', '541319', 'ALUNO', '2025-07-10 18:25:48', 1),
    ('mavie-8056@email.com', '338836', 'ALUNO', '2025-05-28 03:46:10', 5),
    ('ayla-8301@email.com', '387897', 'ALUNO', '2025-03-20 17:26:39', 8),
    ('breno-1832@email.com', '748202', 'ALUNO', '2025-05-17 06:10:38', 5),
    ('gabriel-5438@email.com', '238623', 'ALUNO', '2025-02-12 07:20:12', 3),
    ('asafe-2094@email.com', '336502', 'ALUNO', '2025-03-01 01:50:09', 6),
    ('henry-1528@email.com', '718048', 'ALUNO', '2025-06-11 11:10:01', 8),
    ('mariah-1750@email.com', '215884', 'ALUNO', '2025-03-07 21:43:38', 2),
    ('mayra-3296@email.com', '927017', 'ALUNO', '2025-01-27 19:01:11', 9),
    ('thomas-3029@email.com', '477184', 'ALUNO', '2025-04-28 20:32:42', 5),
    ('miguel-5109@email.com', '727742', 'ALUNO', '2025-03-23 01:36:10', 7),
    ('henry-1797@email.com', '876409', 'ALUNO', '2025-01-22 00:45:40', 1),
    ('bento-3851@email.com', '573674', 'ALUNO', '2025-01-29 00:32:27', 4),
    ('layla-5859@email.com', '266817', 'ALUNO', '2025-01-31 23:53:37', 9),
    ('vinícius-8256@email.com', '523086', 'ALUNO', '2025-02-14 19:53:57', 9),
    ('yan-5353@email.com', '992755', 'ALUNO', '2025-01-20 14:47:38', 8),
    ('asafe-5404@email.com', '929228', 'ALUNO', '2025-01-21 09:57:12', 4),
    ('josenildo-7481@email.com', '957002', 'ALUNO', '2025-05-01 04:42:13', 7),
    ('lorenzo-8349@email.com', '175843', 'ALUNO', '2025-03-16 10:19:05', 5),
    ('mayra-8715@email.com', '115496', 'ALUNO', '2025-01-20 06:18:54', 2),
    ('thomas-8934@email.com', '318830', 'ALUNO', '2025-07-25 16:53:03', 10),
    ('israel-1502@email.com', '324465', 'ALUNO', '2025-01-23 14:11:06', 7),
    ('helena-6210@email.com', '316525', 'ALUNO', '2025-02-14 15:42:06', 9),
    ('tomás-4122@email.com', '566759', 'ALUNO', '2025-01-28 10:04:35', 6),
    ('greta-2004@email.com', '273534', 'ALUNO', '2025-05-08 13:18:48', 4),
    ('elisa-2857@email.com', '392053', 'ALUNO', '2025-01-25 19:42:22', 6);

INSERT INTO
    usuario_aluno (usuario_id, nome, sobrenome, cpf, sexo)
VALUES
    (6, 'Kiara', 'Reis', '110.477.242-16', 'FEMININO'),
    (7, 'Bernardo', 'Barbosa', '842.975.767-24', 'MASCULINO'),
    (8, 'Bento', 'Sales', '200.625.929-94', 'MASCULINO'),
    (9, 'Lucca', 'Araújo', '899.387.365-28', 'MASCULINO'),
    (10, 'Marina', 'Costa', '386.685.509-91', 'FEMININO'),
    (11, 'Ester', 'Castro', '501.664.727-26', 'FEMININO'),
    (12, 'Liam', 'Jesus', '235.905.122-53', 'MASCULINO'),
    (13, 'Maitê', 'Medeiros', '206.397.221-92', 'FEMININO'),
    (14, 'Caio', 'Cardoso', '614.400.542-43', 'MASCULINO'),
    (15, 'Maria Cecília', 'Mendes', '582.117.338-24', 'FEMININO'),
    (16, 'Pedro Henrique', 'Batista', '881.269.602-20', 'MASCULINO'),
    (17, 'Emily', 'Guimarães', '782.623.537-94', 'FEMININO'),
    (18, 'Davi Miguel', 'Pacheco', '903.758.412-13', 'MASCULINO'),
    (19, 'Ravena', 'Nascimento', '610.626.652-14', 'FEMININO'),
    (20, 'Pedro', 'Cardoso', '946.127.261-16', 'MASCULINO'),
    (21, 'Antonella', 'Medeiros', '221.939.661-14', 'FEMININO'),
    (22, 'Caleb', 'Coelho', '940.949.354-25', 'MASCULINO'),
    (23, 'Francisco', 'Peixoto', '407.100.242-10', 'MASCULINO'),
    (24, 'Anthony', 'Pinto', '101.202.884-12', 'MASCULINO'),
    (25, 'Luiz Henrique', 'Marques', '256.319.755-63', 'MASCULINO'),
    (26, 'Vicente', 'Farias', '247.958.210-89', 'MASCULINO'),
    (27, 'Vitor', 'Andrade', '453.629.784-69', 'MASCULINO'),
    (28, 'Luna', 'Pinto', '633.569.345-63', 'FEMININO'),
    (29, 'Davi Lucca', 'Araújo', '361.142.632-53', 'MASCULINO'),
    (30, 'Lia', 'Almeida', '603.542.804-62', 'FEMININO'),
    (31, 'Rafael', 'Freitas', '742.986.654-38', 'MASCULINO'),
    (32, 'Cecília', 'Andrade', '429.607.638-51', 'FEMININO'),
    (33, 'Maíra', 'Peixoto', '764.719.499-66', 'FEMININO'),
    (34, 'Olívia', 'Monteiro', '518.175.931-63', 'FEMININO'),
    (35, 'Bernardo', 'Pontes', '759.640.593-74', 'MASCULINO'),
    (36, 'Maya', 'Moreira', '725.452.909-12', 'FEMININO'),
    (37, 'Kiara', 'Cardoso', '820.793.223-61', 'FEMININO'),
    (38, 'Zara', 'Costa', '389.540.382-29', 'FEMININO'),
    (39, 'Ester', 'Rios', '545.484.226-37', 'FEMININO'),
    (40, 'Lucas', 'Machado', '354.958.784-11', 'MASCULINO'),
    (41, 'Ravena', 'Fernandes', '951.631.365-77', 'FEMININO'),
    (42, 'Henrique', 'Moraes', '179.444.224-24', 'MASCULINO'),
    (43, 'Lucas', 'Pinto', '421.233.143-21', 'MASCULINO'),
    (44, 'Beatriz', 'Gomes', '140.801.417-64', 'FEMININO'),
    (45, 'Helena', 'Cunha', '268.835.880-77', 'FEMININO'),
    (46, 'Levi', 'Leite', '179.874.997-94', 'MASCULINO'),
    (47, 'Vinícius', 'Alves', '419.214.283-17', 'MASCULINO'),
    (48, 'Arthur Miguel', 'Campos', '780.109.515-19', 'MASCULINO'),
    (49, 'Asafe', 'Fernandes', '814.475.722-95', 'MASCULINO'),
    (50, 'Alana', 'Moreira', '277.308.334-27', 'FEMININO'),
    (51, 'Oliver', 'Nunes', '305.541.914-86', 'MASCULINO'),
    (52, 'Joice', 'Rios', '882.941.728-93', 'FEMININO'),
    (53, 'Valentina', 'Souza', '691.225.638-79', 'FEMININO'),
    (54, 'Francisco', 'Nunes', '388.509.473-66', 'MASCULINO'),
    (55, 'Davi Luiz', 'Lima', '537.248.982-68', 'MASCULINO'),
    (56, 'Fernanda', 'Batista', '420.872.436-61', 'FEMININO'),
    (57, 'Oliver', 'Rodrigues', '477.968.272-42', 'MASCULINO'),
    (58, 'José Miguel', 'Cardoso', '919.632.123-62', 'MASCULINO'),
    (59, 'Maria Cecília', 'Marques', '516.141.852-72', 'FEMININO'),
    (60, 'Maíra', 'Ferreira', '777.308.789-50', 'FEMININO'),
    (61, 'Joice', 'Gomes', '696.110.147-76', 'FEMININO'),
    (62, 'Alba', 'Rodrigues', '635.394.989-63', 'FEMININO'),
    (63, 'Liz', 'Viana', '995.900.573-76', 'FEMININO'),
    (64, 'Camila', 'Barros', '144.159.903-10', 'FEMININO'),
    (65, 'João Miguel', 'Barros', '783.980.981-47', 'MASCULINO'),
    (66, 'Guilherme', 'Andrade', '988.361.908-39', 'MASCULINO'),
    (67, 'Matheus', 'Guedes', '859.957.670-40', 'MASCULINO'),
    (68, 'Leona', 'Barbosa', '588.700.989-16', 'FEMININO'),
    (69, 'Caio', 'Moreira', '259.200.678-86', 'MASCULINO'),
    (70, 'Henrique', 'Miranda', '295.370.764-13', 'MASCULINO'),
    (71, 'Thomas', 'Carvalho', '317.157.140-10', 'MASCULINO'),
    (72, 'Nathan', 'Pereira', '335.123.837-20', 'MASCULINO'),
    (73, 'Matteo', 'Cunha', '595.900.127-99', 'MASCULINO'),
    (74, 'Olívia', 'Martins', '534.949.642-23', 'FEMININO'),
    (75, 'Elisa', 'Andrade', '453.986.328-22', 'FEMININO'),
    (76, 'Pérola', 'Morais', '476.162.350-97', 'FEMININO'),
    (77, 'Valentina', 'Carneiro', '863.751.242-59', 'FEMININO'),
    (78, 'Davi Miguel', 'Sales', '852.872.822-88', 'MASCULINO'),
    (79, 'Beatriz', 'Marques', '827.589.250-64', 'FEMININO'),
    (80, 'Laura', 'Cardoso', '677.938.655-78', 'FEMININO'),
    (81, 'Bella', 'Souza', '885.225.105-54', 'FEMININO'),
    (82, 'Anthony', 'Pontes', '977.502.270-57', 'MASCULINO'),
    (83, 'José Pedro', 'Costa', '337.322.500-88', 'MASCULINO'),
    (84, 'Nicolas', 'Nascimento', '338.761.519-98', 'MASCULINO'),
    (85, 'Murilo', 'Almeida', '108.293.528-44', 'MASCULINO'),
    (86, 'Daniel', 'Mendes', '195.758.791-18', 'MASCULINO'),
    (87, 'Luiz Miguel', 'Lima', '638.711.389-27', 'MASCULINO'),
    (88, 'Enzo Gabriel', 'Gomes', '698.715.647-83', 'MASCULINO'),
    (89, 'Ava', 'Castro', '497.477.983-17', 'FEMININO'),
    (90, 'Maria Cecília', 'Rodrigues', '883.775.228-80', 'FEMININO'),
    (91, 'Liz', 'Rios', '452.121.332-86', 'FEMININO'),
    (92, 'Emilly', 'Carneiro', '848.293.630-61', 'FEMININO'),
    (93, 'Maria Clara', 'Batista', '719.889.392-63', 'FEMININO'),
    (94, 'Alícia', 'Azevedo', '991.215.780-67', 'FEMININO'),
    (95, 'Lucas', 'Fernandes', '998.817.903-66', 'MASCULINO'),
    (96, 'Antonella', 'Rodrigues', '717.484.277-20', 'FEMININO'),
    (97, 'Guilherme', 'Moraes', '177.990.761-33', 'MASCULINO'),
    (98, 'Melinda', 'Fernandes', '179.703.145-81', 'FEMININO'),
    (99, 'Emanuel', 'Freitas', '913.450.129-68', 'MASCULINO'),
    (100, 'Henrique', 'Barbosa', '456.693.374-64', 'MASCULINO'),
    (101, 'Benício', 'Pereira', '995.240.663-31', 'MASCULINO'),
    (102, 'Luna', 'Gomes', '335.416.578-54', 'FEMININO'),
    (103, 'Kiara', 'Araújo', '454.323.425-53', 'FEMININO'),
    (104, 'Ravi Lucca', 'Souza', '270.102.318-34', 'MASCULINO'),
    (105, 'Oliver', 'Leite', '749.333.882-16', 'MASCULINO'),
    (106, 'Stella', 'Araújo', '116.125.661-23', 'FEMININO'),
    (107, 'Sophia', 'Ribeiro', '830.444.122-92', 'FEMININO'),
    (108, 'Liam', 'Cardoso', '396.632.666-93', 'MASCULINO'),
    (109, 'Bella', 'Araújo', '535.176.516-69', 'FEMININO'),
    (110, 'Davi Miguel', 'Freitas', '893.774.578-97', 'MASCULINO'),
    (111, 'Eloá', 'Moreira', '477.228.161-29', 'FEMININO'),
    (112, 'Arthur', 'Ribeiro', '753.968.119-81', 'MASCULINO'),
    (113, 'José Pedro', 'Alves', '754.218.391-12', 'MASCULINO'),
    (114, 'Charlotte', 'Morais', '896.890.269-87', 'FEMININO'),
    (115, 'Olga', 'Souza', '154.107.817-13', 'FEMININO'),
    (116, 'Beatriz', 'Moreira', '772.675.191-56', 'FEMININO'),
    (117, 'Leonardo', 'Lima', '109.330.560-59', 'MASCULINO'),
    (118, 'Flora', 'Lima', '844.746.758-15', 'FEMININO'),
    (119, 'José Miguel', 'Farias', '632.994.506-21', 'MASCULINO'),
    (120, 'Leonor', 'Santos', '446.702.614-80', 'FEMININO'),
    (121, 'João', 'Nunes', '265.708.536-69', 'MASCULINO'),
    (122, 'Asafe', 'Araújo', '151.755.614-79', 'MASCULINO'),
    (123, 'Gabriel', 'Barbosa', '170.925.214-79', 'MASCULINO'),
    (124, 'Joao Pedro', 'Pereira', '993.487.653-16', 'MASCULINO'),
    (125, 'Levi', 'Silva', '451.385.877-75', 'MASCULINO'),
    (126, 'Caio', 'Lima', '393.951.267-86', 'MASCULINO'),
    (127, 'Maria Júlia', 'Miranda', '511.858.114-86', 'FEMININO'),
    (128, 'Breno', 'Pontes', '249.199.186-79', 'MASCULINO'),
    (129, 'Stella', 'Pereira', '388.644.936-55', 'FEMININO'),
    (130, 'Anthony Gabriel', 'Cardoso', '625.909.658-69', 'MASCULINO'),
    (131, 'Erick', 'Rocha', '915.545.121-41', 'MASCULINO'),
    (132, 'Elisa', 'Lima', '533.423.505-54', 'FEMININO'),
    (133, 'Estevão', 'Farias', '744.227.630-28', 'MASCULINO'),
    (134, 'Maíra', 'Castro', '735.866.986-54', 'FEMININO'),
    (135, 'Eva', 'Costa', '890.984.856-14', 'FEMININO'),
    (136, 'Nina', 'Marques', '909.543.203-93', 'FEMININO'),
    (137, 'Laura', 'Moreira', '811.178.891-66', 'FEMININO'),
    (138, 'Ravi', 'Souza', '748.520.247-35', 'MASCULINO'),
    (139, 'Anthony', 'Morais', '211.643.506-45', 'MASCULINO'),
    (140, 'Safira', 'Fernandes', '351.477.103-99', 'FEMININO'),
    (141, 'Cauã', 'Souza', '352.626.375-30', 'MASCULINO'),
    (142, 'José Miguel', 'Peixoto', '204.429.752-28', 'MASCULINO'),
    (143, 'Lorenzo', 'Carvalho', '105.783.688-12', 'MASCULINO'),
    (144, 'Eduardo', 'Pereira', '734.526.107-79', 'MASCULINO'),
    (145, 'Martin', 'Gonçalves', '372.651.747-79', 'MASCULINO'),
    (146, 'Maria Cecília', 'Marques', '562.529.222-88', 'FEMININO'),
    (147, 'Elisa', 'Santos', '554.558.324-13', 'FEMININO'),
    (148, 'Luiz Miguel', 'Farias', '288.799.619-41', 'MASCULINO'),
    (149, 'Pérola', 'Costa', '728.234.442-52', 'FEMININO'),
    (150, 'Yuri', 'Pontes', '650.117.487-12', 'MASCULINO'),
    (151, 'Nina', 'Fernandes', '799.683.507-85', 'FEMININO'),
    (152, 'Sasha', 'Gonçalves', '682.480.450-97', 'FEMININO'),
    (153, 'Catarina', 'Marinho', '851.625.513-98', 'FEMININO'),
    (154, 'Lucca', 'Araújo', '393.288.364-28', 'MASCULINO'),
    (155, 'Janaína', 'Miranda', '245.380.489-14', 'FEMININO'),
    (156, 'Augusto', 'Jesus', '126.487.167-10', 'MASCULINO'),
    (157, 'Bernardo', 'Rodrigues', '755.840.739-88', 'MASCULINO'),
    (158, 'Dominic', 'Cunha', '875.127.286-86', 'MASCULINO'),
    (159, 'Luna', 'Oliveira', '603.480.858-74', 'FEMININO'),
    (160, 'Augusto', 'Souza', '575.262.704-11', 'MASCULINO'),
    (161, 'Ravi Lucca', 'Miranda', '624.132.387-46', 'MASCULINO'),
    (162, 'Bianca', 'Martins', '748.259.427-73', 'FEMININO'),
    (163, 'Theodoro', 'Jesus', '333.613.911-96', 'MASCULINO'),
    (164, 'Anne', 'Ribeiro', '841.924.890-58', 'FEMININO'),
    (165, 'Valentina', 'Sales', '703.794.183-17', 'FEMININO'),
    (166, 'Benício', 'Mendes', '669.927.105-68', 'MASCULINO'),
    (167, 'Anne', 'Pacheco', '212.880.603-77', 'FEMININO'),
    (168, 'Raabe', 'Costa', '543.195.252-40', 'FEMININO'),
    (169, 'Francisco', 'Guerra', '865.715.410-35', 'MASCULINO'),
    (170, 'Jade', 'Rios', '325.999.289-73', 'FEMININO'),
    (171, 'Josenildo', 'Peixoto', '925.289.546-46', 'MASCULINO'),
    (172, 'Olga', 'Martins', '505.810.858-16', 'FEMININO'),
    (173, 'Benício', 'Fernandes', '893.324.724-25', 'MASCULINO'),
    (174, 'Enzo', 'Oliveira', '460.453.207-86', 'MASCULINO'),
    (175, 'Miguel', 'Nunes', '146.685.444-21', 'MASCULINO'),
    (176, 'Israel', 'Araújo', '151.594.897-43', 'MASCULINO'),
    (177, 'João Lucas', 'Costa', '659.615.228-17', 'MASCULINO'),
    (178, 'Yuri', 'Guimarães', '121.567.456-42', 'MASCULINO'),
    (179, 'Safira', 'Santos', '570.966.358-22', 'FEMININO'),
    (180, 'Pietro', 'Sales', '509.695.366-13', 'MASCULINO'),
    (181, 'Mavie', 'Martins', '767.955.781-95', 'FEMININO'),
    (182, 'Ayla', 'Marques', '683.117.901-96', 'FEMININO'),
    (183, 'Breno', 'Nascimento', '643.161.309-87', 'MASCULINO'),
    (184, 'Gabriel', 'Nascimento', '744.270.532-83', 'MASCULINO'),
    (185, 'Asafe', 'Lima', '802.335.874-54', 'MASCULINO'),
    (186, 'Henry', 'Campos', '711.626.315-86', 'MASCULINO'),
    (187, 'Mariah', 'Lima', '165.915.717-36', 'FEMININO'),
    (188, 'Mayra', 'Moreira', '772.173.705-26', 'FEMININO'),
    (189, 'Thomas', 'Peixoto', '756.156.507-84', 'MASCULINO'),
    (190, 'Miguel', 'Gomes', '928.586.559-51', 'MASCULINO'),
    (191, 'Henry', 'Pontes', '958.600.987-84', 'MASCULINO'),
    (192, 'Bento', 'Barbosa', '296.454.618-28', 'MASCULINO'),
    (193, 'Layla', 'Lima', '214.256.877-53', 'FEMININO'),
    (194, 'Vinícius', 'Costa', '472.227.644-57', 'MASCULINO'),
    (195, 'Yan', 'Campos', '867.413.290-35', 'MASCULINO'),
    (196, 'Asafe', 'Guedes', '349.912.567-26', 'MASCULINO'),
    (197, 'Josenildo', 'Andrade', '470.369.146-10', 'MASCULINO'),
    (198, 'Lorenzo', 'Pereira', '507.507.738-16', 'MASCULINO'),
    (199, 'Mayra', 'Miranda', '498.536.840-31', 'FEMININO'),
    (200, 'Thomas', 'Jesus', '462.730.481-63', 'MASCULINO'),
    (201, 'Israel', 'Ribeiro', '575.191.923-91', 'MASCULINO'),
    (202, 'Helena', 'Moreira', '595.995.102-31', 'FEMININO'),
    (203, 'Tomás', 'Costa', '746.278.798-10', 'MASCULINO'),
    (204, 'Greta', 'Azevedo', '777.581.973-31', 'FEMININO'),
    (205, 'Elisa', 'Fernandes', '593.880.635-65', 'FEMININO');
