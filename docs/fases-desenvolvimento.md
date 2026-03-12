# Plano de Desenvolvimento - Dom Bet

**Versão:** 1.0
**Data:** 2026-03-12
**Status:** Pronto para execução

---

## 1. Visão Geral da Arquitetura

### 1.1 Diagrama de Componentes

```
┌─────────────────────────────────────────────────────────────────┐
│                        DOM BET SYSTEM                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐       │
│  │   Frontend   │    │   Backend    │    │  IA Service  │       │
│  │  Next.js     │◄──►│   FastAPI    │◄──►│   Ollama     │       │
│  │  (Port 3000) │    │  (Port 8000) │    │  (Port 11434)│       │
│  └──────┬───────┘    └──────┬───────┘    └──────────────┘       │
│         │                   │                                    │
│         │          ┌────────▼────────┐                          │
│         │          │   PostgreSQL    │                          │
│         │          │   (Port 5432)   │                          │
│         │          └─────────────────┘                          │
│         │                                                        │
│  ┌──────▼────────────────────────────────────────────────┐      │
│  │              External Football APIs                    │      │
│  │   (API-Football, Football-Data.org, etc.)             │      │
│  └────────────────────────────────────────────────────────┘      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────▼───────────────┐
              │    Infrastructure (Docker)    │
              │    + Portainer Management     │
              └───────────────────────────────┘
```

### 1.2 Fluxo de Dados Completo

```
1. COLETA          2. PROCESSAMENTO      3. SCORE           4. INSIGHT         5. EXIBIÇÃO
   ┌─────┐           ┌─────────┐          ┌──────┐          ┌──────┐          ┌──────┐
   │ API │──────────►│ Python  │─────────►│Score │─────────►│Ollama│─────────►│React │
   │Futebol│          │  ETL    │          │ 0-10 │          │  IA  │          │Dashboard│
   └─────┘           └─────────┘          └──────┘          └──────┘          └──────┘
       │                   │                   │                 │                 │
       ▼                   ▼                   ▼                 ▼                 ▼
   Jogos do Dia        Estatísticas        Probabilidade     Justificativa     Score de
   (Casa/Fora)         (5-10 jogos)        (Pesos)           Texto             Confiança
```

### 1.3 Decisões Arquiteturais

| Decisão | Justificativa |
|---------|---------------|
| **Backend Python + FastAPI** | Ecossistema maduro para data science, fácil integração com APIs de futebol |
| **PostgreSQL em Docker** | Alinhado com infra existente (dom-server), fácil backup e gestão via Portainer |
| **Frontend Next.js** | SSR para melhor SEO, reutilização de código TypeScript |
| **Ollama local** | Sem custos de API externa, privacidade dos dados, modelos llama3/mistral |
| **Pipeline batch diário** | Jogos são atualizados uma vez por dia, não requer processamento em tempo real |

---

## 2. Fases de Desenvolvimento

---

### **FASE 1: Infraestrutura Básica e Banco de Dados**

**Objetivo:** Configurar ambiente Docker funcional com PostgreSQL conectado e migrations iniciais aplicadas.

**Tarefas específicas:**
1. Atualizar `docker-compose.yml` para incluir rede interna e volumes persistentes
2. Criar diretório `db/migrations/` com scripts SQL versionados
3. Criar script `db/init/001_initial_schema.sql` com tabelas base
4. Configurar `.env` com credenciais de produção
5. Validar conexão com `docker-compose up -d db` e teste de conexão
6. Configurar Portainer para monitoramento do container PostgreSQL

**Arquivos a criar/modificar:**
- `docker-compose.yml` (modificar - adicionar rede, healthcheck, volumes)
- `db/migrations/001_initial_schema.sql` (criar)
- `db/migrations/002_seed_data.sql` (criar)
- `backend/.env` (criar)
- `scripts/db-migrate.sh` (criar - script de migration)

**Critério de aceite:**
- [ ] PostgreSQL rodando e acessível via `docker-compose exec db psql`
- [ ] Tabelas `partidas` e `estatisticas_historicas` criadas
- [ ] Healthcheck do banco respondendo em `http://localhost:5432`
- [ ] Script de migration executável e idempotente

**Dependências:** Nenhuma (fase inicial)

**Estimativa de esforço:** **BAIXO** (1-2 dias)

---

### **FASE 2: Coleta de Dados (Data Ingestion)**

**Objetivo:** Implementar scripts Python para buscar jogos do dia e estatísticas de APIs de futebol.

**Tarefas específicas:**
1. Criar `src/services/football_api_client.py` - Cliente genérico para APIs de futebol
2. Implementar `src/services/api_football_client.py` - Integração com API-Football.com
3. Criar `src/core/data_ingestion.py` - Script ETL de ingestão de jogos
4. Implementar `src/core/statistics_calculator.py` - Cálculo de médias (últimos 5-10 jogos)
5. Criar `src/lib/database.py` - Conexão PostgreSQL com asyncpg
6. Configurar `.env` com `FOOTBALL_API_KEY` e `FOOTBALL_API_BASE_URL`
7. Criar testes unitários para calculadora de estatísticas

**Arquivos a criar/modificar:**
- `backend/requirements.txt` (modificar - adicionar: httpx, asyncpg, sqlalchemy)
- `src/lib/database.py` (criar)
- `src/services/football_api_client.py` (criar)
- `src/services/api_football_client.py` (criar)
- `src/core/data_ingestion.py` (criar)
- `src/core/statistics_calculator.py` (criar)
- `src/types/schemas.py` (criar - Pydantic models)
- `tests/unit/test_statistics_calculator.py` (criar)

**Critério de aceite:**
- [ ] Script de ingestão busca jogos do dia com sucesso
- [ ] Estatísticas históricas calculadas para cada time
- [ ] Dados persistidos no PostgreSQL corretamente
- [ ] Testes unitários com coverage > 80%
- [ ] Tratamento de erros para API indisponível

**Dependências:** Fase 1 completa (banco de dados operacional)

**Estimativa de esforço:** **MÉDIO** (3-5 dias)

---

### **FASE 3: Motor de Score e Probabilidades**

**Objetivo:** Implementar algoritmo de score 0-10 para escanteios, cartões e resultados.

**Tarefas específicas:**
1. Criar `src/core/scoring/` diretório com módulos de score
2. Implementar `src/core/scoring/corners_scorer.py` - Score para escanteios
3. Implementar `src/core/scoring/cards_scorer.py` - Score para cartões
4. Implementar `src/core/scoring/match_result_scorer.py` - Score para vitória/empate
5. Criar `src/core/scoring/base_scorer.py` - Classe abstrata base
6. Implementar `src/core/scoring/weighted_scorer.py` - Aplicação de pesos casa/fora
7. Criar `src/api/scores.py` - Endpoints FastAPI para scores
8. Criar testes de integração para pipeline completo de scoring

**Arquivos a criar/modificar:**
- `src/core/scoring/__init__.py` (criar)
- `src/core/scoring/base_scorer.py` (criar)
- `src/core/scoring/corners_scorer.py` (criar)
- `src/core/scoring/cards_scorer.py` (criar)
- `src/core/scoring/match_result_scorer.py` (criar)
- `src/core/scoring/weighted_scorer.py` (criar)
- `src/api/scores.py` (criar)
- `src/api/main.py` (criar - FastAPI app)
- `tests/integration/test_scoring_pipeline.py` (criar)

**Critério de aceite:**
- [ ] Score calculado para cada mercado (escanteios, cartões, resultado)
- [ ] Pesos casa/fora aplicados corretamente
- [ ] Scores normalizados entre 0-10
- [ ] API FastAPI respondendo em `http://localhost:8000/api/scores`
- [ ] Documentação Swagger em `http://localhost:8000/docs`

**Dependências:** Fase 2 completa (dados coletados e processados)

**Estimativa de esforço:** **MÉDIO/ALTO** (5-7 dias)

---

### **FASE 4: Integração Ollama (IA para Insights)**

**Objetivo:** Integrar modelo de IA local para gerar justificativas textuais dos scores.

**Tarefas específicas:**
1. Configurar Ollama no docker-compose (`docker-compose.ollama.yml`)
2. Criar `src/services/ollama_client.py` - Cliente HTTP para API Ollama
3. Implementar `src/core/insight_generator.py` - Geração de prompts e parsing
4. Criar `src/api/insights.py` - Endpoint para geração de insights
5. Implementar template de prompt para análise de scores
6. Criar cache de insights (evitar regeneração para mesmos inputs)
7. Testar com modelos `llama3` e `mistral`

**Arquivos a criar/modificar:**
- `docker-compose.ollama.yml` (criar - serviço Ollama)
- `backend/requirements.txt` (modificar - adicionar requests ou httpx)
- `src/services/ollama_client.py` (criar)
- `src/core/insight_generator.py` (criar)
- `src/api/insights.py` (criar)
- `src/templates/ollama_prompt.txt` (criar - template de prompt)

**Critério de aceite:**
- [ ] Ollama rodando em `http://localhost:11434`
- [ ] Modelo `llama3` ou `mistral` baixado e disponível
- [ ] Insight gerado em < 10 segundos
- [ ] Justificativa textual coerente com score
- [ ] Cache funcionando para requests repetidos

**Dependências:** Fase 3 completa (scores calculados)

**Estimativa de esforço:** **MÉDIO** (3-4 dias)

---

### **FASE 5: Frontend Dashboard**

**Objetivo:** Criar interface React/Next.js para exibição de jogos com scores e insights.

**Tarefas específicas:**
1. Configurar estrutura Next.js em `frontend/src/app/`
2. Criar `frontend/src/components/GameCard.tsx` - Card de jogo com score
3. Criar `frontend/src/components/ScoreBadge.tsx` - Badge visual do score
4. Criar `frontend/src/components/InsightBox.tsx` - Exibição do insight IA
5. Implementar `frontend/src/lib/api.ts` - Cliente para backend FastAPI
6. Criar página `frontend/src/app/page.tsx` - Lista de jogos do dia
7. Criar página `frontend/src/app/game/[id]/page.tsx` - Detalhes do jogo
8. Implementar estilos e responsividade

**Arquivos a criar/modificar:**
- `frontend/src/app/page.tsx` (criar)
- `frontend/src/app/game/[id]/page.tsx` (criar)
- `frontend/src/components/GameCard.tsx` (criar)
- `frontend/src/components/ScoreBadge.tsx` (criar)
- `frontend/src/components/InsightBox.tsx` (criar)
- `frontend/src/lib/api.ts` (criar)
- `frontend/src/types/game.ts` (criar)
- `frontend/tailwind.config.js` (criar - se usar Tailwind)

**Critério de aceite:**
- [ ] Dashboard lista jogos do dia com scores
- [ ] Card de jogo exibe: times, campeonato, score, insight
- [ ] Page loading e error states implementados
- [ ] Responsivo para mobile e desktop
- [ ] Frontend acessível em `http://localhost:3000`

**Dependências:** Fase 3 completa (API de scores disponível)

**Estimativa de esforço:** **ALTO** (7-10 dias)

---

### **FASE 6: Automação e Deploy**

**Objetivo:** Configurar pipelines automatizados de coleta diária e deploy em produção.

**Tarefas específicas:**
1. Criar `scripts/ingest-daily.sh` - Script de ingestão agendada
2. Configurar cron job no Docker para ingestão diária (6h da manhã)
3. Criar `docker-compose.prod.yml` - Configuração de produção
4. Configurar GitHub Actions para build e deploy
5. Implementar health checks e logging estruturado
6. Criar `docs/operations.md` - Guia de operações e monitoramento
7. Configurar backup automático do PostgreSQL
8. Testar disaster recovery (restore de backup)

**Arquivos a criar/modificar:**
- `docker-compose.prod.yml` (criar)
- `scripts/ingest-daily.sh` (criar)
- `scripts/backup-db.sh` (criar)
- `.github/workflows/deploy-backend.yml` (criar)
- `docs/operations.md` (criar)
- `backend/logging_config.py` (criar)
- `docker/cron/Dockerfile` (criar - container de cron jobs)

**Critério de aceite:**
- [ ] Ingestão automática roda diariamente sem intervenção
- [ ] Deploy via GitHub Actions funciona com push para `main`
- [ ] Backups agendados e testados
- [ ] Logs centralizados e acessíveis via Portainer
- [ ] Health endpoints respondendo `/health` e `/ready`

**Dependências:** Fases 1-5 completas

**Estimativa de esforço:** **MÉDIO** (4-5 dias)

---

## 3. Estrutura de Pastas Proposta

```
dom-bet/
├── backend/
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── requirements-dev.txt
│   └── src/
│       ├── api/
│       │   ├── main.py              # FastAPI app
│       │   ├── scores.py            # Endpoints de score
│       │   ├── insights.py          # Endpoints de insight
│       │   └── health.py            # Health checks
│       ├── core/
│       │   ├── data_ingestion.py    # ETL de jogos
│       │   ├── statistics_calculator.py
│       │   ├── insight_generator.py
│       │   └── scoring/
│       │       ├── base_scorer.py
│       │       ├── corners_scorer.py
│       │       ├── cards_scorer.py
│       │       └── match_result_scorer.py
│       ├── services/
│       │   ├── football_api_client.py
│       │   ├── api_football_client.py
│       │   └── ollama_client.py
│       ├── lib/
│       │   ├── database.py          # PostgreSQL connection
│       │   └── config.py            # Settings management
│       └── types/
│           └── schemas.py           # Pydantic models
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/
│       ├── app/
│       │   ├── page.tsx             # Dashboard principal
│       │   └── game/[id]/page.tsx   # Detalhes do jogo
│       ├── components/
│       │   ├── GameCard.tsx
│       │   ├── ScoreBadge.tsx
│       │   └── InsightBox.tsx
│       ├── lib/
│       │   └── api.ts               # Backend client
│       └── types/
│           └── game.ts
├── db/
│   ├── migrations/
│   │   ├── 001_initial_schema.sql
│   │   └── 002_seed_data.sql
│   └── init/
│       └── create_extensions.sql
├── docker/
│   ├── cron/
│   │   └── Dockerfile
│   └── portainer/
│       └── templates.json
├── scripts/
│   ├── setup.sh
│   ├── deploy.sh
│   ├── db-migrate.sh
│   ├── ingest-daily.sh
│   └── backup-db.sh
├── docs/
│   ├── architecture.md
│   ├── api.md
│   ├── operations.md
│   └── fases-desenvolvimento.md
├── docker-compose.yml
├── docker-compose.prod.yml
├── docker-compose.ollama.yml
└── .env.example
```

---

## 4. Modelo de Dados Detalhado

### 4.1 SQL Completo das Tabelas

```sql
-- =====================================================
-- MIGRATION 001: Initial Schema
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
    api_id          VARCHAR(50) UNIQUE,              -- ID da API externa
    status          VARCHAR(20) DEFAULT 'scheduled', -- scheduled, live, finished, cancelled
    placar_casa     INTEGER,
    placar_fora     INTEGER,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for partidas
CREATE INDEX idx_partidas_data_jogo ON partidas(data_jogo);
CREATE INDEX idx_partidas_campeonato ON partidas(campeonato);
CREATE INDEX idx_partidas_time_casa ON partidas(time_casa);
CREATE INDEX idx_partidas_time_fora ON partidas(time_fora);
CREATE INDEX idx_partidas_status ON partidas(status);

-- =====================================================
-- TABLE: estatisticas_historicas
-- =====================================================
CREATE TABLE IF NOT EXISTS estatisticas_historicas (
    id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    time_id                 VARCHAR(50) NOT NULL,      -- ID do time na API
    time_nome               VARCHAR(100) NOT NULL,
    campeonato              VARCHAR(100) NOT NULL,

    -- Escanteios
    media_escanteios_favor  DECIMAL(5,2) DEFAULT 0,    -- Média de escanteios a favor
    media_escanteios_contra DECIMAL(5,2) DEFAULT 0,    -- Média de escanteios contra

    -- Cartões
    media_cartoes_amarelos  DECIMAL(5,2) DEFAULT 0,
    media_cartoes_vermelhos DECIMAL(5,2) DEFAULT 0,

    -- Performance
    percentual_vitorias_home DECIMAL(5,2) DEFAULT 0,   -- % vitórias em casa
    percentual_vitorias_away DECIMAL(5,2) DEFAULT 0,   -- % vitórias fora
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
CREATE INDEX idx_estatisticas_time_nome ON estatisticas_historicas(time_nome);
CREATE INDEX idx_estatisticas_campeonato ON estatisticas_historicas(campeonato);

-- =====================================================
-- TABLE: scores (nova - para armazenar scores calculados)
-- =====================================================
CREATE TABLE IF NOT EXISTS scores (
    id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    partida_id              UUID REFERENCES partidas(id) ON DELETE CASCADE,

    -- Mercados
    mercado                 VARCHAR(50) NOT NULL,      -- corners, cards, match_result
    score                   DECIMAL(3,2) NOT NULL,     -- Score 0.00 - 10.00
    probabilidade           DECIMAL(5,4),              -- 0.0000 - 1.0000

    -- Detalhes do cálculo
    detalhes                JSONB,                     -- Dados usados no cálculo
    peso_casa               DECIMAL(3,2) DEFAULT 1.0,
    peso_fora               DECIMAL(3,2) DEFAULT 1.0,

    -- Insight IA
    insight_ia              TEXT,
    ia_model                VARCHAR(50),

    created_at              TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(partida_id, mercado)
);

-- Indexes for scores
CREATE INDEX idx_scores_partida_id ON scores(partida_id);
CREATE INDEX idx_scores_mercado ON scores(mercado);
CREATE INDEX idx_scores_score ON scores(score DESC);

-- =====================================================
-- TABLE: jobs (para controle de ingestão e processamento)
-- =====================================================
CREATE TABLE IF NOT EXISTS jobs (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_type        VARCHAR(50) NOT NULL,      -- ingestion, scoring, insight
    status          VARCHAR(20) NOT NULL,      -- pending, running, completed, failed
    started_at      TIMESTAMP WITH TIME ZONE,
    completed_at    TIMESTAMP WITH TIME ZONE,
    error_message   TEXT,
    metadata        JSONB,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_jobs_type ON jobs(job_type);

-- =====================================================
-- TRIGGER: updated_at
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_partidas_updated_at BEFORE UPDATE ON partidas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_estatisticas_updated_at BEFORE UPDATE ON estatisticas_historicas
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

### 4.2 Relacionamentos

```
┌─────────────────────┐
│     partidas        │
│  id (PK)            │
│  data_jogo          │
│  time_casa          │
│  time_fora          │
│  campeonato         │
└──────────┬──────────┘
           │
           │ 1:N (partida tem múltiplos scores)
           │
           ▼
┌─────────────────────┐
│       scores        │
│  id (PK)            │
│  partida_id (FK)────┤
│  mercado            │
│  score              │
│  insight_ia         │
└─────────────────────┘

┌─────────────────────┐
│ estatisticas_       │
│ historicas          │
│  time_id (PK)       │
│  time_nome          │◄─── Referenciado por: partidas.time_casa/time_fora
│  media_*            │
└─────────────────────┘
```

### 4.3 Índices Recomendados

| Tabela | Coluna | Tipo | Motivo |
|--------|--------|------|--------|
| partidas | data_jogo | B-Tree | Filtro por data é frequente |
| partidas | campeonato | B-Tree | Listagem por campeonato |
| partidas | (time_casa, time_fora) | Composite | Busca de confrontos |
| estatisticas | (time_id, campeonato) | Unique + B-Tree | Lookup rápido por time |
| scores | partida_id | B-Tree | Join com partidas |
| scores | score DESC | B-Tree | Ordenação para ranking |
| jobs | (status, job_type) | Composite | Filtro de jobs pendentes |

---

## 5. API Design

### 5.1 Endpoints Necessários

```
┌─────────────────────────────────────────────────────────────────┐
│                        FASTAPI ENDPOINTS                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  HEALTH & READY                                                  │
│  ├── GET  /health              → Status do serviço              │
│  └── GET  /ready               → Pronto para receber requests   │
│                                                                  │
│  GAMES (Partidas)                                                │
│  ├── GET  /api/games             → Lista jogos do dia           │
│  ├── GET  /api/games/:id         → Detalhes de um jogo          │
│  ├── GET  /api/games/date/:date  → Jogos por data               │
│  └── GET  /api/games/league/:id  → Jogos por campeonato         │
│                                                                  │
│  SCORES                                                          │
│  ├── GET  /api/scores            → Todos os scores do dia       │
│  ├── GET  /api/scores/:game_id   → Scores de um jogo específico │
│  ├── GET  /api/scores/top        → Top scores (maior confiança) │
│  └── POST /api/scores/calculate  → Recalcular scores (admin)    │
│                                                                  │
│  INSIGHTS                                                        │
│  ├── GET  /api/insights/:game_id → Insights de um jogo          │
│  └── POST /api/insights/generate → Gerar insight (admin)        │
│                                                                  │
│  STATISTICS                                                      │
│  ├── GET  /api/stats/team/:id    → Estatísticas de um time      │
│  └── GET  /api/stats/league/:id  → Estatísticas do campeonato   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 5.2 Request/Response Schemas

#### GET /api/games

**Response:**
```json
{
  "success": true,
  "data": {
    "date": "2026-03-12",
    "games": [
      {
        "id": "uuid-v4",
        "homeTeam": "Flamengo",
        "awayTeam": "Palmeiras",
        "league": "Brasileirão Série A",
        "kickoff": "2026-03-12T16:00:00-03:00",
        "status": "scheduled",
        "scores": {
          "corners": {
            "score": 8.5,
            "prediction": "+9.5 Escanteios",
            "confidence": "high"
          },
          "cards": {
            "score": 6.2,
            "prediction": "+4.5 Cartões",
            "confidence": "medium"
          },
          "matchResult": {
            "score": 7.0,
            "prediction": "Casa Vence",
            "confidence": "medium"
          }
        },
        "insight": {
          "text": "Flamengo tem média de 6.8 escanteios em casa... (gerado por IA)",
          "model": "llama3"
        }
      }
    ],
    "total": 8
  }
}
```

#### GET /api/scores/top

**Query Params:**
- `limit` (default: 10)
- `market` (optional: corners, cards, match_result)
- `minScore` (optional: 0-10)

**Response:**
```json
{
  "success": true,
  "data": {
    "topScores": [
      {
        "gameId": "uuid",
        "homeTeam": "São Paulo",
        "awayTeam": "Corinthians",
        "market": "corners",
        "score": 9.2,
        "prediction": "+10.5 Escanteios",
        "insight": "Ambos os times têm histórico de jogos com muitos escanteios..."
      }
    ]
  }
}
```

#### POST /api/insights/generate

**Request:**
```json
{
  "gameId": "uuid-v4",
  "market": "corners",
  "forceRegenerate": false
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "gameId": "uuid",
    "market": "corners",
    "insight": "Texto gerado pela IA...",
    "model": "llama3",
    "cached": false,
    "generatedAt": "2026-03-12T10:30:00-03:00"
  }
}
```

---

## 6. Riscos e Mitigações

### 6.1 Pontos de Atenção Técnica

| Risco | Impacto | Probabilidade | Mitigação |
|-------|---------|---------------|-----------|
| **API de futebol indisponível** | Alto | Baixa | Implementar fallback para múltiplas APIs; cache de dados |
| **Ollama lento ou instável** | Médio | Média | Cache de insights; timeout configurável; fila de processamento |
| **Dados inconsistentes** | Alto | Média | Validação rigorosa com Pydantic; logs de anomalias |
| **Performance do PostgreSQL** | Médio | Baixa | Índices adequados; queries otimizadas; connection pooling |
| **Docker no dom-server** | Alto | Baixa | Healthchecks; auto-restart; monitoramento via Portainer |

### 6.2 Dependências Externas

```
┌─────────────────────────────────────────────────────────────┐
│                   DEPENDÊNCIAS EXTERNAS                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  API-Football.com (ou similar)                               │
│  ├── Custo: ~$15-50/mês para plano premium                  │
│  ├── Rate limit: 10-100 requests/minuto                     │
│  ├── Mitigação: Cache de 24h, múltiplos providers           │
│  └── Alternativa: Football-Data.org (free tier)             │
│                                                              │
│  Ollama (local)                                              │
│  ├── Custo: $0 (roda localmente)                            │
│  ├── Hardware: 4GB RAM mínimo, 8GB recomendado              │
│  ├── Modelos: llama3 (4GB), mistral (3.8GB)                 │
│  └── Mitigação: Ter fallback para API aberta se necessário  │
│                                                              │
│  Docker Hub                                                  │
│  ├── Pull de imagens pode falhar                            │
│  └── Mitigação: Manter backup local das imagens             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 6.3 Plano de Contingência

1. **Se API de futebol falhar:**
   - Usar dados em cache (última coleta bem-sucedida)
   - Notificar via log/alerta
   - Retry exponencial (1min, 5min, 15min, 1h)

2. **Se Ollama falhar:**
   - Retornar insight padrão: "Análise baseada em estatísticas históricas..."
   - Fila de insights pendentes para processamento posterior

3. **Se PostgreSQL falhar:**
   - Healthcheck detecta em < 30 segundos
   - Container reinicia automaticamente
   - Restore de backup se necessário

---

## 7. Ordem de Execução Recomendada (MVP)

```
SEMANA 1-2: [FASE 1] Infra + [FASE 2] Coleta de Dados
            ↓
SEMANA 3-4: [FASE 3] Motor de Score
            ↓
SEMANA 5:   [FASE 4] IA Insights
            ↓
SEMANA 6-7: [FASE 5] Frontend Dashboard
            ↓
SEMANA 8:   [FASE 6] Automação + Deploy
```

---

## 8. Critical Files for Implementation

| Arquivo | Razão |
|---------|-------|
| `db/migrations/001_initial_schema.sql` | Estrutura completa do banco de dados - base para todo o sistema |
| `src/core/scoring/corners_scorer.py` | Implementação do algoritmo principal de score (primeiro mercado) |
| `src/services/football_api_client.py` | Integração com APIs externas de futebol - fonte primária de dados |
| `src/api/main.py` | FastAPI app que expõe todos os endpoints para o frontend |
| `frontend/src/components/GameCard.tsx` | Componente principal do dashboard - experiência do usuário |
