# Dom Bet — Contexto do Projeto

## Visão geral
App de bet para que define score de probabilidades de jogos futebol

## Stack
- **Language:** python e typescript
- **Framework:** nextjs e fastapi
- **Author:** Dom

## Comandos chave
- `docker-compose up -d` → Inicia o ambiente de desenvolvimento completo
- `docker-compose build` → Reconstrói as imagens
- `npm run dev` → (Frontend) Inicia desenvolvimento local
- `pytest` → (Backend) Executa testes unitários Python
- `npm run test` → (Frontend) Executa testes unitários Node

## Padrões do projeto
- TypeScript strict mode habilitado no Frontend.
- Tipagem rigorosa (mypy) e formatação (black/flake8) no Backend Python.
- Tudo deve ser projetado para rodar via Docker.
- Commits seguem Conventional Commits (feat/fix/chore/docs/refactor).
- Nunca commitar `.env` — usar apenas `.env.example`.
- PRs sempre passam pelo checklist de Dom-Security antes do merge.

## Agentes disponíveis
Ver: docs/agents-config.md
