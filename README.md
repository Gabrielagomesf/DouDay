# DuoDay - App para Casais

Um aplicativo completo para casais gerenciarem tarefas, finanças, agenda e fortalecerem o relacionamento.

## 🧠 Stack do Projeto

**Mobile:**
- Dart (Flutter)

**Backend:**
- Node.js + Express
- MongoDB
- JWT Authentication
- Socket.io (real-time)

**Serviços:**
- Firebase Cloud Messaging (notificações)
- Firebase Auth (opcional)

## 📱 Funcionalidades

### 🔐 Autenticação
- Login com e-mail/senha
- Token JWT + refresh token
- Recuperação de senha

### ❤️ Vínculo do Casal
- Código único de convite (ex: DUO-8492)
- Status do relacionamento (pending/connected)
- Apenas 1 parceiro por conta

### 🏠 Dashboard
- Insights inteligentes
- Indicador de equilíbrio do casal
- Prioridade do dia

### ✅ Tarefas
- Prioridades (Alta/Média/Baixa)
- Tags (Casa/Trabalho/Pessoal)
- Divisão automática
- Notificações

### 💰 Finanças
- Divisão automática (50/50 ou personalizada)
- Status (Pago/Pendente/Atrasado)
- Gráficos mensais
- Histórico

### 💙 Check-in Emocional
- Humor diário
- Histórico emocional
- Gráficos semanais
- Notificações mútuas

### 📅 Agenda
- Eventos compartilhados
- Recorrência
- Integração Google Calendar (futura)

### 🎯 Missão do Dia
- Gamificação com streak
- Pontos do casal ❤️
- Ranking interno

## 🚀 Como Começar

### Pré-requisitos
- Flutter SDK
- Node.js 18+
- MongoDB
- Firebase Project

### Instalação

1. **Backend:**
```bash
cd backend
npm install
npm run dev
```

2. **Mobile:**
```bash
cd mobile
flutter pub get
flutter run
```

### Variáveis de Ambiente

**Backend (.env):**
```
MONGODB_URI=mongodb://localhost:27017/duoday
JWT_SECRET=your-secret-key
FIREBASE_PROJECT_ID=your-project-id
```

**Mobile (.env):**
```
API_BASE_URL=http://localhost:3000
FIREBASE_PROJECT_ID=your-project-id
```

## 📁 Estrutura do Projeto

```
DouDay/
├── mobile/                    # App Flutter
│   ├── lib/
│   │   ├── main.dart          # Entrada: init + ProviderScope
│   │   ├── app/               # Widget raiz (tema, router)
│   │   ├── core/              # Tema, API, router, models globais, widgets
│   │   └── features/          # Por domínio (auth, home, tasks, couple_hub, …)
│   ├── assets/                # images, icons, animations, env/.env
│   └── pubspec.yaml
├── backend/
│   ├── src/
│   │   ├── index.ts           # Servidor: DB, listen, shutdown
│   │   ├── app.ts             # Express + rotas + socket + erros
│   │   ├── routes/
│   │   ├── models/
│   │   ├── services/
│   │   ├── middleware/
│   │   └── utils/
│   └── package.json
└── docs/                      # Ver docs/estrutura-do-projeto.md
```

## 🔐 Segurança

- Senhas com bcrypt
- JWT tokens
- Rate limiting
- Validação backend
- HTTPS em produção

## 📈 Escalabilidade

Arquitetura preparada para:
- Auth service separado
- Notification service
- Microservices
- CDN para assets

## 🎨 Design System

- **Primária:** #7B61FF (roxo moderno)
- **Secundária:** #A78BFA
- **Destaque:** #FF6B81 (emocional)

## 📄 Licença

MIT License
