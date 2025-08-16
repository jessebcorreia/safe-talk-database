INSERT INTO
    usuario (email, senha, cargo, endereco_id)
VALUES
    ("unidade.ensino@email.com", "123456789", "UNIDADE_ENSINO", 1);

INSERT INTO
    usuario_unidade_ensino (usuario_id, nome_fantasia, razao_social, cnpj, descricao)
VALUES
    (1, 'Colégio Madre Tereza de Calcutá', 'Escola de Educação Básica Madre Tereza de Calcutá Ltda.', '84.264.8452/0001-56', 'Descrição da unidade de ensino');