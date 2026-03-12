# Dom Bet

> App de probabilidades de apostas esportivas - sistema de score de jogos de futebol

## Quick Start

### Docker (Recomendado)

```bash
git clone https://github.com/diheimy/dom-bet.git
cd dom-bet
cp .env.example .env
# Edite .env com suas variáveis reais
docker-compose up -d --build
```

### Desenvolvimento Local

```bash
git clone https://github.com/diheimy/dom-bet.git
cd dom-bet
cp .env.example .env

# Frontend
cd frontend
npm install
npm run dev

# Backend (em outro terminal)
cd ../backend
pip install -r requirements.txt
# Configure seu servidor FastAPI
```

## Scripts

### Frontend

| Comando | Descrição |
|---------|-----------|
| `npm run dev` | Desenvolvimento local |
| `npm run build` | Build de produção |
| `npm run start` | Start produção |
| `npm run test` | Executa todos os testes |
| `npm run lint` | Verifica qualidade do código |
| `npm run type-check` | TypeScript strict check |

### Backend

| Comando | Descrição |
|---------|-----------|
| `pytest` | Executa testes unitários |
| `flake8` | Verifica qualidade do código |
| `black` | Formata código |

### Docker

| Comando | Descrição |
|---------|-----------|
| `docker-compose up -d` | Inicia ambiente completo |
| `docker-compose build` | Reconstrói imagens |
| `docker-compose down` | Para ambiente |

## Estrutura

```
dom-bet/
├── frontend/          # Next.js (TypeScript)
│   ├── src/
│   ├── public/
│   └── package.json
├── backend/           # FastAPI (Python)
│   ├── requirements.txt
│   └── Dockerfile
├── src/
│   ├── core/         # Regras de negócio
│   ├── services/     # Integrações externas
│   ├── lib/          # Utilitários (Supabase)
│   ├── utils/        # Helpers
│   └── types/        # Tipagens
├── tests/
│   ├── unit/
│   └── integration/
├── .github/
│   └── workflows/
├── .claude/
│   ├── CLAUDE.md     # Memória do projeto
│   └── skills/
└── docs/
```

## Claude Code

Memória do projeto: [.claude/CLAUDE.md](.claude/CLAUDE.md)

## Agentes de Desenvolvimento

Ver [docs/agents-config.md](docs/agents-config.md)

## Deploy

- **Vercel**: Deploy automático via GitHub Actions
- **Docker**: `docker-compose up -d` para produção

## Variáveis de Ambiente

Ver [.env.example](.env.example) para todas as variáveis necessárias.

### GitHub Secrets necessários

Configure em: **GitHub → Settings → Secrets and variables → Actions**

| Secret | Como obter |
|--------|-----------|
| `VERCEL_TOKEN` | vercel.com → Account Settings → Tokens → Create |
| `VERCEL_ORG_ID` | `.vercel/project.json` após `vercel link` |
| `VERCEL_PROJECT_ID` | `.vercel/project.json` após `vercel link` |
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase → Project Settings → API |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase → Project Settings → API |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase → Project Settings → API |

## License

ISC
