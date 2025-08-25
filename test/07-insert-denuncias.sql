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

