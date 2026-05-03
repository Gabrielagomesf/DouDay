# Estrutura do repositório DuoDay

## Raiz

| Pasta / arquivo | Função |
|-----------------|--------|
| `backend/` | API Node.js (Express, MongoDB, Socket.io) |
| `mobile/` | App Flutter |
| `docs/` | Documentação do projeto |
| `SETUP.md` | Passo a passo de ambiente |
| `README.md` | Visão geral do produto |

## Backend (`backend/src/`)

| Pasta | Conteúdo |
|-------|----------|
| `app.ts` | Monta Express, rotas HTTP, Socket.io, 404 e tratamento de erros |
| `index.ts` | Ponto de entrada: `dotenv`, MongoDB, Firebase Admin, `listen`, encerramento gracioso |
| `routes/` | Handlers HTTP por domínio (`auth`, `tasks`, …) |
| `models/` | Schemas Mongoose |
| `services/` | Lógica reutilizável (e-mail, Firebase, socket, Cloudinary) |
| `middleware/` | Auth, validação, erros |
| `utils/` | JWT e utilitários |

## Mobile (`mobile/lib/`)

| Pasta | Conteúdo |
|-------|----------|
| `main.dart` | `main()`: binding, `Environment`, Firebase, `ProviderScope` |
| `app/app.dart` | Widget raiz: tema + `MaterialApp.router` |
| `core/` | Tema, router, cliente HTTP, modelos globais (ex.: usuário), widgets compartilhados |
| `features/<nome>/` | Uma pasta por feature; em geral `screens/`, `providers/`, `services/`, `models/` conforme necessário |
| `features/couple_hub/` | Hub “Nós” (atalhos do casal) — rota `/us` no router |

## Assets (`mobile/assets/`)

- `env/.env.example` — padrão versionado; o app tenta `env/.env` primeiro e, se não existir, usa o example.
- Crie `env/.env` local (gitignored) para API/Firebase reais em desenvolvimento.
- `images/`, `icons/`, `animations/` — recursos estáticos; o `pubspec` inclui a pasta `assets/env/` inteira.
