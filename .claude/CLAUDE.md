# Dom Bet

## Sobre o projeto
App de probabilidades de apostas esportivas - sistema de score de jogos de futebol

## Stack
- Language: python | typescript
- Framework: fastapi | nextjs
- Package manager: pip | npm

## Comandos essenciais
- `npm run dev`        → Desenvolvimento local (Frontend)
- `npm run build`      → Build de produção (Frontend)
- `npm run test`       → Todos os testes (Frontend)
- `npm run lint`       → Verificação de código (Frontend)
- `npm run type-check` → TypeScript strict check
- `docker-compose up -d` → Inicia ambiente completo
- `docker-compose build` → Reconstrói imagens Docker
- `pytest`             → Testes backend Python

## Padrões de código
- TypeScript strict mode sempre ativo
- Tipagem rigorosa (mypy) e formatação (black/flake8) no Backend Python
- Conventional Commits: feat | fix | chore | docs | refactor | test
- Testes obrigatórios para toda nova feature
- Nunca commitar `.env` — usar `.env.example`
- Funções: máximo 50 linhas. Arquivos: máximo 300 linhas.

## Nomenclatura
- Componentes: PascalCase
- Funções e variáveis: camelCase
- Constantes globais: UPPER_SNAKE_CASE
- Arquivos: kebab-case

## Decisões arquiteturais
- Tudo deve ser projetado para rodar via Docker
- Frontend: Next.js com TypeScript strict
- Backend: FastAPI com validação Pydantic
- PRs sempre passam pelo checklist de Dom-Security antes do merge

## Skills disponíveis
Ver: .claude/skills/

## Supabase
- URL do projeto: ${NEXT_PUBLIC_SUPABASE_URL}
- Auth: Supabase Auth (JWT via cookies)
- Client browser: src/lib/supabase.ts
- Client server: src/lib/supabase-server.ts
- Migrations: supabase/migrations/
- Gerar tipos: npm run db:types
- Dashboard: supabase.com/dashboard

## Vercel
- Deploy automático: push para main → produção
- Preview: todo PR gera preview URL automática
- Região: gru1 (São Paulo)
- Dashboard: vercel.com/dashboard
- CLI: npx vercel --prod (deploy manual)
- Env vars: vercel.com → Project → Settings → Environment Variables
