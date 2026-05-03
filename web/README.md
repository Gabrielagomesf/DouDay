## DuoDay Landing Page (Vue 3 + Vite + TypeScript)

Esta landing page fica em `web/` e usa:

- Vue 3
- Vite
- TypeScript
- Componentes separados em `src/components/`
- Conteúdo (textos/dados) centralizado em `src/content.ts`

### Rodar localmente

Pré-requisito: **Node.js** + **npm** (ou pnpm/yarn).

```bash
cd web
npm install
npm run dev
```

### Build (produção)

```bash
cd web
npm run build
```

O output fica em `web/dist/`.

### Publicar

Você pode publicar a pasta `web/dist/` em qualquer host estático (Vercel, Netlify, GitHub Pages, etc.).

### Ajustes rápidos

- Links/CTAs: edite o objeto `links` em `src/content.ts`
- Textos e seções: edite `features`, `steps`, `screens`, `testimonials`, `pricing` e `faqs` em `src/content.ts`

