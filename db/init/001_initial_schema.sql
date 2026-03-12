-- =====================================================
-- MIGRATION 001: Initial Schema
-- Dom Bet - Database Schema v1.0
-- Executado automaticamente na inicialização do container
-- =====================================================

-- Extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLE: partidas
-- =====================================================
CREATE TABLE IF NOT EXISTS partidas (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    data_jogo       TIMESTAMP WITH TIME ZONE NOT NULL,
    time_casa       VARCHAR(100) NOT NULL,
    time_fora       VARCHAR(100) NOT NULL,
    campeonato      VARCHAR(100) NOT NULL,
    api_id          VARCHAR(50) UNIQUE,
    status          VARCHAR(20) DEFAULT 'scheduled',
    placar_casa     INTEGER,
    placar_fora     INTEGER,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for partidas
CREATE INDEX IF NOT EXISTS idx_partidas_data_jogo ON partidas(data_jogo);
CREATE INDEX IF NOT EXISTS idx_partidas_campeonato ON partidas(campeonato);
CREATE INDEX IF NOT EXISTS idx_partidas_time_casa ON partidas(time_casa);
CREATE INDEX IF NOT EXISTS idx_partidas_time_fora ON partidas(time_fora);
CREATE INDEX IF NOT EXISTS idx_partidas_status ON partidas(status);

-- =====================================================
-- TABLE: estatisticas_historicas
-- =====================================================
CREATE TABLE IF NOT EXISTS estatisticas_historicas (
    id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    time_id                 VARCHAR(50) NOT NULL,
    time_nome               VARCHAR(100) NOT NULL,
    campeonato              VARCHAR(100) NOT NULL,

    -- Escanteios
    media_escanteios_favor  DECIMAL(5,2) DEFAULT 0,
    media_escanteios_contra DECIMAL(5,2) DEFAULT 0,

    -- Cartões
    media_cartoes_amarelos  DECIMAL(5,2) DEFAULT 0,
    media_cartoes_vermelhos DECIMAL(5,2) DEFAULT 0,

    -- Performance
    percentual_vitorias_home DECIMAL(5,2) DEFAULT 0,
    percentual_vitorias_away DECIMAL(5,2) DEFAULT 0,
    percentual_empates      DECIMAL(5,2) DEFAULT 0,

    -- Jogos considerados
    jogos_analisados        INTEGER DEFAULT 0,
    periodo_inicio          DATE,
    periodo_fim             DATE,

    created_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(time_id, campeonato)
);

-- Indexes for estatisticas_historicas
CREATE INDEX IF NOT EXISTS idx_estatisticas_time_nome ON estatisticas_historicas(time_nome);
CREATE INDEX IF NOT EXISTS idx_estatisticas_campeonato ON estatisticas_historicas(campeonato);

-- =====================================================
-- TABLE: scores
-- =====================================================
CREATE TABLE IF NOT EXISTS scores (
    id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    partida_id              UUID REFERENCES partidas(id) ON DELETE CASCADE,

    -- Mercados
    mercado                 VARCHAR(50) NOT NULL,
    score                   DECIMAL(3,2) NOT NULL,
    probabilidade           DECIMAL(5,4),

    -- Detalhes do cálculo
    detalhes                JSONB,
    peso_casa               DECIMAL(3,2) DEFAULT 1.0,
    peso_fora               DECIMAL(3,2) DEFAULT 1.0,

    -- Insight IA
    insight_ia              TEXT,
    ia_model                VARCHAR(50),

    created_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(partida_id, mercado)
);

-- Indexes for scores
CREATE INDEX IF NOT EXISTS idx_scores_partida_id ON scores(partida_id);
CREATE INDEX IF NOT EXISTS idx_scores_mercado ON scores(mercado);
CREATE INDEX IF NOT EXISTS idx_scores_score ON scores(score DESC);

-- =====================================================
-- TABLE: jobs
-- =====================================================
CREATE TABLE IF NOT EXISTS jobs (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_type        VARCHAR(50) NOT NULL,
    status          VARCHAR(20) NOT NULL,
    started_at      TIMESTAMP WITH TIME ZONE,
    completed_at    TIMESTAMP WITH TIME ZONE,
    error_message   TEXT,
    metadata        JSONB,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_jobs_status ON jobs(status);
CREATE INDEX IF NOT EXISTS idx_jobs_type ON jobs(job_type);

-- =====================================================
-- TRIGGER: update_updated_at_column
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_partidas_updated_at
    BEFORE UPDATE ON partidas
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_estatisticas_updated_at
    BEFORE UPDATE ON estatisticas_historicas
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- LOG: Migration completed
-- =====================================================
DO $$
BEGIN
    RAISE NOTICE 'Migration 001: Initial schema created successfully!';
    RAISE NOTICE 'Tables created: partidas, estatisticas_historicas, scores, jobs';
END $$;
