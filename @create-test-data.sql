USE safe_talk;

-- ENDEREÇOS
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



-- UNIDADE DE ENSINO
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



-- EQUIPE TÉCNICA (ANALISTAS E PEDAGOGOS)
INSERT INTO
    usuario (email, senha, cargo, criado_em, endereco_id)
VALUES
    -- id: 2
    ('joao.analista@email.com', '123456789', 'ANALISTA', '2025-01-23 21:52:16', 4),
    -- id: 3
    ('maria.analista@email.com', '987654321', 'ANALISTA', '2025-03-12 15:25:36', 5),
    -- id: 4
    ('josicleison.pedagogo@email.com', '123456789', 'PEDAGOGO', '2025-05-22 12:32:23', 6),
    -- id: 5
    ('luana.pedagoga@email.com', '987654321', 'PEDAGOGO', '2025-02-10 19:15:58', 7);

INSERT INTO
    usuario_analista (usuario_id, nome, sobrenome, cpf, sexo)
VALUES
    -- usuario_id: 2
    (2, 'João', 'Analista da Silva', '861.534.872-92', 'M'),
    -- usuario_id: 3
    (3, 'Maria', 'Pereira Analista da Costa', '845.269.456-15', 'F');

INSERT INTO
    usuario_pedagogo (usuario_id, nome, sobrenome, cpf, sexo)
VALUES
    -- usuario_id: 4
    (4, 'Josicleison', 'o Pedagogo', '563.534.856-92', 'M'),
    -- usuario_id: 5
    (5, 'Luana', 'Andrade Pedagoga Santos', '379.568.339-56', 'F');



-- CURSOS
INSERT INTO curso
    (nome, descricao, unidade_ensino_id, analista_id)
VALUES
    ('Informática Básica', 'Curso introdutório de informática, abrangendo uso de computadores, internet e pacotes de escritório.', 1, 1),
    ('Inglês Intermediário', 'Curso de língua inglesa com foco em conversação e vocabulário para o dia a dia.', 1, 1),
    ('Matemática Aplicada', 'Curso para reforço escolar e aplicação prática de conceitos matemáticos.', 1, 1),
    ('Educação Artística', 'Curso voltado ao desenvolvimento criativo por meio de desenho, pintura e trabalhos manuais.', 1, 2);



-- TURMAS
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
