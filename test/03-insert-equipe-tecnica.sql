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