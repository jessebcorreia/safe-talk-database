INSERT INTO denuncia
    (titulo, conteudo, tipo, situacao_analise, local_fato_id, autor_id, pedagogo_id, analista_id)
VALUES
    -- Alunos: ids 6 a 205
    -- Analistas: ids 2 e 3
    -- Pedagogos: ids 4 e 5
    ('Briga no intervalo', 'Durante o recreio eu fui empurrado e levei socos de um colega.', 'VIOLENCIA_FISICA', 'NAO_INICIADA',                    1, 3,  3, 2),
    ('Ameaças no corredor', 'Um aluno me disse que iria me bater depois da aula e fiquei com medo.', 'VIOLENCIA_VERBAL', 'NAO_INICIADA',            2, 8,  3, 2),
    ('Mensagens ofensivas no WhatsApp', 'Estou recebendo xingamentos e piadas em um grupo da turma.', 'CYBER_BULLYING', 'INICIADA',                 3, 8,  3, 2),
    ('Empurrões na saída', 'Quando estava saindo da escola, fui empurrado com força por um colega.', 'VIOLENCIA_FISICA', 'NAO_INICIADA',            4, 30, 3, 2),
    ('Ofensas na sala de aula', 'Um colega sempre me chama por apelidos que me humilham na frente da turma.', 'VIOLENCIA_VERBAL', 'INICIADA',       5, 30, 3, 2),
    ('Grupo me zoando online', 'Me colocaram em um grupo no WhatsApp só para me xingar e debochar de mim.', 'CYBER_BULLYING', 'ENCERRADA',          2, 65, 4, 3),
    ('Agressão no pátio', 'Fui cercado por dois alunos e levei chutes e tapas durante o intervalo.', 'VIOLENCIA_FISICA', 'INICIADA',                1, 65, 4, 3),
    ('Professor presenciou ofensas', 'Colegas me chamaram de nomes ofensivos e o professor estava presente.', 'VIOLENCIA_VERBAL', 'ENCERRADA',      6, 65, 4, 3),
    ('Humilhação em redes sociais', 'Postaram uma foto minha no Instagram com legendas ofensivas.', 'CYBER_BULLYING', 'INICIADA',                   3, 90, 4, 3),
    ('Agressão física recorrente', 'Já fui agredido várias vezes pelo mesmo aluno, e hoje aconteceu de novo.', 'VIOLENCIA_FISICA', 'NAO_INICIADA',  7, 90, 4, 3);
