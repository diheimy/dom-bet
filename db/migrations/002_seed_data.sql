-- =====================================================
-- MIGRATION 002: Seed Data (Dados Iniciais)
-- Dom Bet - Dados de exemplo para desenvolvimento
-- Executar manualmente após o banco estar online
-- =====================================================

-- =====================================================
-- SEED: Times Brasileirão Série A
-- =====================================================
INSERT INTO estatisticas_historicas (time_id, time_nome, campeonato, media_escanteios_favor, media_escanteios_contra, media_cartoes_amarelos, percentual_vitorias_home, percentual_vitorias_away, percentual_empates, jogos_analisados)
VALUES
    ('team_001', 'Flamengo', 'Brasileirão Série A', 6.2, 4.1, 2.3, 65.0, 45.0, 20.0, 10),
    ('team_002', 'Palmeiras', 'Brasileirão Série A', 5.8, 3.9, 2.1, 60.0, 50.0, 25.0, 10),
    ('team_003', 'São Paulo', 'Brasileirão Série A', 5.5, 4.5, 2.5, 55.0, 40.0, 30.0, 10),
    ('team_004', 'Corinthians', 'Brasileirão Série A', 5.2, 4.8, 2.8, 50.0, 35.0, 35.0, 10),
    ('team_005', 'Fluminense', 'Brasileirão Série A', 5.0, 4.2, 2.2, 55.0, 38.0, 28.0, 10)
ON CONFLICT (time_id, campeonato) DO UPDATE SET
    media_escanteios_favor = EXCLUDED.media_escanteios_favor,
    media_escanteios_contra = EXCLUDED.media_escanteios_contra,
    media_cartoes_amarelos = EXCLUDED.media_cartoes_amarelos,
    percentual_vitorias_home = EXCLUDED.percentual_vitorias_home,
    percentual_vitorias_away = EXCLUDED.percentual_vitorias_away,
    percentual_empates = EXCLUDED.percentual_empates,
    jogos_analisados = EXCLUDED.jogos_analisados;

-- =====================================================
-- SEED: Partidas de Exemplo (Jogos do Dia)
-- =====================================================
INSERT INTO partidas (data_jogo, time_casa, time_fora, campeonato, api_id, status)
VALUES
    (NOW() + INTERVAL '1 day' - INTERVAL '8 hour', 'Flamengo', 'Palmeiras', 'Brasileirão Série A', 'match_001', 'scheduled'),
    (NOW() + INTERVAL '1 day' - INTERVAL '5 hour', 'São Paulo', 'Corinthians', 'Brasileirão Série A', 'match_002', 'scheduled'),
    (NOW() + INTERVAL '2 days' - INTERVAL '8 hour', 'Fluminense', 'Flamengo', 'Brasileirão Série A', 'match_003', 'scheduled')
ON CONFLICT (api_id) DO NOTHING;

-- =====================================================
-- LOG: Seed completed
-- =====================================================
DO $$
BEGIN
    RAISE NOTICE 'Migration 002: Seed data inserted successfully!';
    RAISE NOTICE 'Inserted: 5 teams, 3 sample matches';
END $$;
