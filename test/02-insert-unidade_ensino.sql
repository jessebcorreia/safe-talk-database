INSERT INTO
    usuario (email, senha, cargo, criado_em, endereco_id)
VALUES
    --id: 1
    ("unidade.ensino@email.com", "123456789", "UNIDADE_ENSINO", '2023-05-15 19:22:16', 1);

INSERT INTO
    usuario_unidade_ensino (usuario_id, nome_fantasia, razao_social, cnpj, descricao)
VALUES
    --usuario_id: 1
    (1, 'Colégio Madre Tereza de Calcutá', 'Escola de Educação Básica Madre Tereza de Calcutá Ltda.', '84.264.845/0001-56', 'Descrição da unidade de ensino');