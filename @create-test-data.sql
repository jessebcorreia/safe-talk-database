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
    ("unidade.ensino@email.com", "123456789", "UNIDADE_ENSINO", 1);

INSERT INTO
    usuario_unidade_ensino (usuario_id, nome_fantasia, razao_social, cnpj, descricao)
VALUES
    (1, 'Colégio Madre Tereza de Calcutá', 'Escola de Educação Básica Madre Tereza de Calcutá Ltda.', '84.264.845/0001-56', 'Descrição da unidade de ensino');




-- EQUIPE TÉCNICA (ANALISTAS E PEDAGOGOS)
INSERT INTO
    usuario (email, senha, cargo, criado_em, endereco_id)
VALUES
    ('joao.analista@email.com', '123456789', 'ANALISTA', '2025-01-23 21:52:16', 4),
    ('maria.analista@email.com', '987654321', 'ANALISTA', '2025-03-12 15:25:36', 5),
    ('josicleison.pedagogo@email.com', '123456789', 'PEDAGOGO', '2025-05-22 12:32:23', 6),
    ('luana.pedagoga@email.com', '987654321', 'PEDAGOGO', '2025-02-10 19:15:58', 7);

INSERT INTO
    usuario_analista (usuario_id, nome, sobrenome, cpf, sexo)
VALUES
    (2, 'João', 'Analista da Silva', '861.534.872-92', 'M'),
    (3, 'Maria', 'Pereira Analista da Costa', '845.269.456-15', 'F');

INSERT INTO
    usuario_pedagogo (usuario_id, nome, sobrenome, cpf, sexo)
VALUES
    (4, 'Josicleison', 'o Pedagogo', '563.534.856-92', 'M'),
    (5, 'Luana', 'Andrade Pedagoga Santos', '379.568.339-56', 'F');