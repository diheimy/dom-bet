# AGENTS.md — Claude Code Project Bootstrap
> Execute este arquivo ao iniciar qualquer novo projeto.
> **Como usar:** Coloque na raiz do projeto e diga ao Claude Code:
> *"Execute o AGENTS.md e prepare o ambiente completo do projeto."*

---

## ⚡ INSTRUÇÃO PRINCIPAL

Você é o agente de bootstrap deste projeto. Execute **todas as seções em ordem**, confirmando cada etapa com ✅. Não pule etapas. Não pergunte — decida pelo padrão mais seguro e prossiga. Ao concluir, gere o relatório da Seção 13.

---

## 📋 SEÇÃO 1 — CONFIGURAÇÃO DO PROJETO

> ⚠️ Preencha antes de executar

```yaml
project_name: "Dom Bet"         # sem espaços
project_description: "App de probalidades de apostas esportivas"
project_type: "web-app"             # web-app | api | cli | bot | library | fullstack
language: "python | typescript"              # typescript | javascript | python | go | rust
framework: "fastapi | nextjs"                 # nextjs | express | fastapi | none | etc
package_manager: "pip | npm"              # npm | yarn | pnpm | pip | cargo
node_version: "20"
git_remote: "https://github.com/diheimy/dom-bet.git"                      # https://github.com/diheimy/dom-bet.git (deixe vazio se não tiver)
use_supabase: true                  # true | false
use_vercel: true                    # true | false
```

---

## 🗂️ SEÇÃO 2 — ESTRUTURA DE PASTAS

Crie a estrutura completa abaixo. Nenhum arquivo deve ficar vazio — adicione conteúdo mínimo funcional em cada um.

```
{project_name}/
├── .claude/
│   ├── CLAUDE.md                  # Memória persistente do projeto (carregada automaticamente)
│   └── skills/                    # Skills reutilizáveis do projeto
├── .github/
│   ├── workflows/
│   │   ├── ci.yml
│   │   └── deploy.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── src/
│   ├── core/                      # Regras de negócio
│   ├── services/                  # Integrações externas / APIs
│   ├── lib/
│   │   └── supabase.ts            # Cliente Supabase (se use_supabase: true)
│   ├── utils/                     # Helpers e funções utilitárias
│   └── types/                     # Tipagens globais TypeScript
├── tests/
│   ├── unit/
│   └── integration/
├── docs/
│   ├── architecture.md
│   └── api.md
├── scripts/
│   ├── setup.sh
│   └── deploy.sh
├── .env.example
├── .gitignore
├── .editorconfig
├── README.md
├── CHANGELOG.md
└── AGENTS.md
```

---

## 🧠 SEÇÃO 3 — CLAUDE.md (Memória Persistente)

> O `CLAUDE.md` é carregado automaticamente pelo Claude Code a cada sessão.
> É a memória do projeto — evita reexplicar contexto toda vez.
> Localização: `.claude/CLAUDE.md`

Crie `.claude/CLAUDE.md` com o seguinte conteúdo (substituindo as variáveis):

```markdown
# {project_name}

## Sobre o projeto
{project_description}

## Stack
- Language: {language}
- Framework: {framework}
- Package manager: {package_manager}

## Comandos essenciais
- `npm run dev`        → Desenvolvimento local
- `npm run build`      → Build de produção
- `npm run test`       → Todos os testes
- `npm run lint`       → Verificação de código
- `npm run type-check` → TypeScript strict check

## Padrões de código
- TypeScript strict mode sempre ativo
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
- [Documente aqui as decisões técnicas e o motivo]
- [Integrações externas ativas]
- [Restrições importantes do projeto]

## Skills disponíveis
Ver: .claude/skills/
```

---

## ⚙️ SEÇÃO 4 — CONFIGURAÇÃO DO AMBIENTE

### 4.1 — Git

```bash
git init
git checkout -b main
git config core.autocrlf false
git config core.eol lf
```

Se `git_remote` estiver preenchido:
```bash
git remote add origin {git_remote}
```

### 4.2 — .gitignore

Gere um `.gitignore` completo incluindo:

```
# Dependencies
node_modules/
.pnp
.pnp.js

# Build
dist/
build/
.next/
.turbo/
out/

# Python
__pycache__/
*.pyc
*.pyo
.venv/
venv/
*.egg-info/

# Environment
.env
.env.local
.env.*.local
!.env.example

# OS
.DS_Store
Thumbs.db
*.log
logs/

# IDE
.idea/
.vscode/
!.vscode/settings.json
!.vscode/extensions.json

# Testing
coverage/
.nyc_output/
```

### 4.3 — .editorconfig

```ini
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false

[*.py]
indent_size = 4

[Makefile]
indent_style = tab
```

### 4.4 — .env.example

```env
# App
NODE_ENV=development
PORT=4000
APP_URL=http://localhost:4000

# Supabase (supabase.com → Project Settings → API)
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=        # apenas server-side, nunca expor no client
SUPABASE_JWT_SECRET=              # Project Settings → API → JWT Secret

# Vercel (vercel.com → Account Settings → Tokens)
VERCEL_TOKEN=
VERCEL_ORG_ID=                    # vercel env ls → Settings → General
VERCEL_PROJECT_ID=                # vercel env ls → Settings → General

# AI
ANTHROPIC_API_KEY=
OPENAI_API_KEY=

# Adicione as variáveis específicas do seu projeto abaixo
```

---

## 📦 SEÇÃO 5 — DEPENDÊNCIAS INICIAIS

### Node / TypeScript

```bash
# TypeScript e runtime
npm install -D typescript @types/node ts-node tsx

# Qualidade de código
npm install -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
npm install -D prettier eslint-config-prettier

# Testes
npm install -D jest @types/jest ts-jest

# Validação e utilitários
npm install dotenv zod

# Inicializar TypeScript
npx tsc --init
```

Adicione ao `package.json` na seção `scripts`:
```json
{
  "scripts": {
    "dev": "tsx src/index.ts",
    "build": "tsc",
    "test": "jest",
    "test:unit": "jest tests/unit",
    "test:integration": "jest tests/integration",
    "lint": "eslint src --ext .ts,.tsx",
    "type-check": "tsc --noEmit"
  }
}
```

### Python (se aplicável)

Crie `requirements-dev.txt`:
```
pytest
pytest-asyncio
pytest-cov
black
flake8
mypy
python-dotenv
```

---

## 🔧 SEÇÃO 6 — REPOSITÓRIOS EXTERNOS

Clone os repositórios de referência abaixo dentro da pasta `.claude/skills/`:

```bash
cd .claude/skills/

# 1. Get Shit Done — framework de produtividade e execução
gh repo clone gsd-build/get-shit-done

# 2. UI/UX Pro Max Skill — patterns de design e componentes
gh repo clone nextlevelbuilder/ui-ux-pro-max-skill

# 3. Agency Agents — templates de agentes para Claude Code
gh repo clone msitarzewski/agency-agents
```

> ⚠️ Requisito: GitHub CLI (`gh`) instalado e autenticado.
> Verifique com: `gh auth status`
> Instalar: `brew install gh` (Mac) ou `winget install GitHub.cli` (Windows)

Após clonar, leia os READMEs de cada repositório e **extraia para o `CLAUDE.md`** as instruções mais relevantes para o projeto atual. Adicione uma seção `## Skills de referência` no `.claude/CLAUDE.md` com os pontos-chave.

---

## 🗄️ SEÇÃO 7 — SUPABASE

> Execute apenas se `use_supabase: true`

### 7.1 — Instalar dependências

```bash
npm install @supabase/supabase-js
npm install @supabase/ssr          # Para Next.js (SSR/SSG)
```

### 7.2 — Criar cliente Supabase

Crie `src/lib/supabase.ts`:

```typescript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

// Client-side (anon key)
export const supabase = createClient(supabaseUrl, supabaseAnonKey)
```

Crie `src/lib/supabase-server.ts` (apenas server-side):

```typescript
import { createClient } from '@supabase/supabase-js'

// Server-side (service role — nunca expor no client)
export const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
  { auth: { autoRefreshToken: false, persistSession: false } }
)
```

### 7.3 — Middleware de autenticação (Next.js)

Crie `middleware.ts` na raiz:

```typescript
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return request.cookies.getAll() },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options)
          )
        },
      },
    }
  )

  await supabase.auth.getUser()
  return supabaseResponse
}

export const config = {
  matcher: ['/((?!_next/static|_next/image|favicon.ico).*)'],
}
```

### 7.4 — Estrutura de migrations

```bash
# Instalar CLI do Supabase
npm install -D supabase

# Inicializar (cria pasta supabase/ no projeto)
npx supabase init

# Criar primeira migration
npx supabase migration new init_schema
```

Adicione ao `package.json`:
```json
{
  "scripts": {
    "db:start": "supabase start",
    "db:stop": "supabase stop",
    "db:reset": "supabase db reset",
    "db:migrate": "supabase db push",
    "db:types": "supabase gen types typescript --local > src/types/database.ts"
  }
}
```

### 7.5 — Adicionar ao .claude/CLAUDE.md

Adicione a seção abaixo no `CLAUDE.md`:

```markdown
## Supabase
- URL do projeto: ${NEXT_PUBLIC_SUPABASE_URL}
- Auth: Supabase Auth (JWT via cookies)
- Client browser: src/lib/supabase.ts
- Client server: src/lib/supabase-server.ts
- Migrations: supabase/migrations/
- Gerar tipos: npm run db:types
- Dashboard: supabase.com/dashboard
```

---

## 🚀 SEÇÃO 8 — VERCEL

> Execute apenas se `use_vercel: true`

### 8.1 — Instalar CLI

```bash
npm install -D vercel
```

### 8.2 — Configurar projeto

```bash
# Login e link ao projeto
npx vercel login
npx vercel link

# Isso cria .vercel/project.json com org e project IDs
# Use esses valores no GitHub Secrets
```

### 8.3 — vercel.json

Crie `vercel.json` na raiz:

```json
{
  "framework": "nextjs",
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "regions": ["gru1"],
  "env": {
    "NODE_ENV": "production"
  }
}
```

> `gru1` = São Paulo. Outras opções: `iad1` (Washington DC), `cdg1` (Paris), `sin1` (Singapore).

### 8.4 — GitHub Secrets necessários

Configure em: **GitHub → Settings → Secrets and variables → Actions**

| Secret | Como obter |
|--------|-----------|
| `VERCEL_TOKEN` | vercel.com → Account Settings → Tokens → Create |
| `VERCEL_ORG_ID` | `.vercel/project.json` após `vercel link` |
| `VERCEL_PROJECT_ID` | `.vercel/project.json` após `vercel link` |
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase → Project Settings → API |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase → Project Settings → API |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase → Project Settings → API |

### 8.5 — Adicionar ao .claude/CLAUDE.md

```markdown
## Vercel
- Deploy automático: push para main → produção
- Preview: todo PR gera preview URL automática
- Região: gru1 (São Paulo)
- Dashboard: vercel.com/dashboard
- CLI: npx vercel --prod (deploy manual)
- Env vars: vercel.com → Project → Settings → Environment Variables
```

---

## 🔄 SEÇÃO 9 — GITHUB ACTIONS

### `.github/workflows/ci.yml`

```yaml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  quality:
    name: Lint, Type Check & Test
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npm run type-check

      - name: Tests
        run: npm run test -- --coverage

      - name: Build
        run: npm run build
```

### `.github/workflows/deploy.yml`

```yaml
name: Deploy

on:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      environment:
        description: 'Ambiente de deploy'
        required: true
        default: 'production'
        type: choice
        options: [production, staging]

jobs:
  deploy:
    name: Deploy → ${{ github.event.inputs.environment || 'production' }}
    runs-on: ubuntu-latest
    environment: ${{ github.event.inputs.environment || 'production' }}

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install & Build
        run: |
          npm ci
          npm run build

      - name: Deploy to Vercel
        run: npx vercel --prod --token=${{ secrets.VERCEL_TOKEN }}
        env:
          VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
          VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID }}
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.NEXT_PUBLIC_SUPABASE_ANON_KEY }}
```

### `.github/PULL_REQUEST_TEMPLATE.md`

```markdown
## O que foi feito?

## Issue relacionada
Closes #

## Tipo de mudança
- [ ] Bug fix
- [ ] Nova feature
- [ ] Breaking change
- [ ] Refatoração
- [ ] Documentação

## Checklist
- [ ] Testes adicionados / atualizados
- [ ] Build passou localmente
- [ ] Sem secrets no código
- [ ] Documentação atualizada
```

---

## 📝 SEÇÃO 10 — DOCUMENTAÇÃO BASE

### README.md

```markdown
# {project_name}

> {project_description}

## Quick Start

\`\`\`bash
git clone {git_remote}
cd {project_name}
cp .env.example .env
npm install
npm run dev
\`\`\`

## Scripts

| Comando | Descrição |
|---------|-----------|
| `npm run dev` | Desenvolvimento local |
| `npm run build` | Build de produção |
| `npm run test` | Executa todos os testes |
| `npm run lint` | Verifica qualidade do código |

## Estrutura

\`\`\`
src/
├── core/        Regras de negócio
├── services/    Integrações externas
├── utils/       Helpers
└── types/       Tipagens
\`\`\`

## Claude Code

Memória do projeto: [.claude/CLAUDE.md](.claude/CLAUDE.md)

Skills de referência:
- `.claude/skills/get-shit-done`
- `.claude/skills/ui-ux-pro-max-skill`
- `.claude/skills/agency-agents`
```

### CHANGELOG.md

```markdown
# Changelog

## [Unreleased]

### Added
- Bootstrap inicial via AGENTS.md
- CLAUDE.md configurado (memória persistente Claude Code)
- Skills de referência clonadas
- GitHub Actions: CI e Deploy
```

---

## 🚀 SEÇÃO 11 — COMMIT INICIAL

```bash
git add .
git commit -m "chore: project bootstrap

- Project structure created
- .claude/CLAUDE.md configured (Claude Code persistent memory)
- Reference skills cloned (get-shit-done, ui-ux-pro-max-skill, agency-agents)
- GitHub Actions configured (ci.yml + deploy to Vercel)
- Supabase SDK and clients configured
- Vercel CLI and vercel.json configured
- .env.example, .gitignore, .editorconfig configured"
```

Se `git_remote` estiver preenchido:
```bash
git push -u origin main
```

---

## ⌨️ SEÇÃO 12 — REFERÊNCIA RÁPIDA: CLAUDE CODE

### Slash Commands

| Comando | Ação |
|---------|------|
| `/help` | Lista todos os comandos |
| `/clear` | Reseta o contexto (use entre tasks diferentes) |
| `/compact` | Comprime conversa para economizar tokens |
| `/model` | Troca entre Opus / Sonnet / Haiku |
| `/mcp` | Verifica conexões MCP ativas |
| `/doctor` | Diagnostica problemas de instalação |
| `/config` | Abre configurações |

### Referências de arquivo

| Sintaxe | Uso |
|---------|-----|
| `@filename` | Referencia um arquivo específico |
| `@folder/` | Referencia uma pasta inteira |
| `Tab` | Autocomplete de caminhos |

### Atalhos de teclado

| Tecla | Ação |
|-------|------|
| `Esc` | Cancela execução |
| `Esc Esc` | Rewind para checkpoint anterior |
| `Ctrl+V` | Cola imagem diretamente |

### MCPs recomendados

```bash
# GitHub
claude mcp add --transport http github https://mcp.github.com

# Supabase
claude mcp add --transport http supabase https://mcp.supabase.com/mcp

# Notion
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Sentry
claude mcp add --transport http sentry https://mcp.sentry.io/mcp
```

### Técnicas de prompt eficazes

| Técnica | Exemplo |
|---------|---------|
| **Seja específico** | "Crie POST /auth/login com JWT, validação Zod, retorno 200/401" |
| **Dê exemplos** | "Retorne no formato: `{ token, expiresIn, user: {id, email} }`" |
| **Chain of steps** | "Primeiro analise, depois planeje, então implemente" |
| **Constraints** | "Máximo 50 linhas por função. Sem `any` no TypeScript." |
| **Assign roles** | "Você é um engenheiro sênior especialista em segurança" |
| **Checkpoint** | "Antes de executar, revise o plano e confirme" |

---

## ✅ SEÇÃO 13 — CHECKLIST E RELATÓRIO FINAL

Antes do relatório, confirme cada item:

- [ ] Estrutura de pastas criada
- [ ] `.claude/CLAUDE.md` configurado
- [ ] `.gitignore` gerado
- [ ] `.editorconfig` criado
- [ ] `.env.example` com variáveis base
- [ ] Git inicializado (branch: `main`)
- [ ] Remote configurado (se fornecido)
- [ ] Skills clonadas: `get-shit-done`, `ui-ux-pro-max-skill`, `agency-agents`
- [ ] Supabase: SDK instalado, clientes criados, migrations iniciadas (se use_supabase: true)
- [ ] Vercel: CLI instalada, projeto linkado, vercel.json criado (se use_vercel: true)
- [ ] GitHub Secrets documentados no README
- [ ] `ci.yml` e `deploy.yml` criados
- [ ] PR Template criado
- [ ] `README.md` e `CHANGELOG.md` gerados
- [ ] Dependências instaladas
- [ ] Commit inicial realizado

### Relatório de conclusão

```
╔══════════════════════════════════════════════════╗
║       PROJECT BOOTSTRAP COMPLETE                 ║
╠══════════════════════════════════════════════════╣
║  Project:        {project_name}                  ║
║  Framework:      {framework}                     ║
║  Branch:         main                            ║
║  Remote:         {git_remote or "not set"}       ║
╠══════════════════════════════════════════════════╣
║  ✅ Folder structure                             ║
║  ✅ .claude/CLAUDE.md (persistent memory)        ║
║  ✅ Skills: get-shit-done                        ║
║  ✅ Skills: ui-ux-pro-max-skill                  ║
║  ✅ Skills: agency-agents                        ║
║  ✅ GitHub Actions (CI + Deploy → Vercel)        ║
║  ✅ Supabase: SDK + clients + migrations         ║
║  ✅ Vercel: CLI + vercel.json configured         ║
║  ✅ Git initialized + initial commit             ║
╠══════════════════════════════════════════════════╣
║  NEXT STEPS:                                     ║
║  1. Fill .env with Supabase + Vercel keys        ║
║  2. Run: npx vercel link                         ║
║  3. Set GitHub Secrets (6 secrets required)      ║
║  4. npm run dev → start building                 ║
╚══════════════════════════════════════════════════╝
```

---

> Template version: 1.0.0
> Compatible with: Claude Code CLI · claude.ai
> Docs: code.claude.com/docs · anthropic.com/mcp
