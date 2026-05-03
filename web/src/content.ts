export type LinkKey = 'cta' | 'demo' | 'support' | 'privacy' | 'terms';

export type Mood = {
  id: string;
  emoji: string;
  label: string;
};

export type Feature = {
  title: string;
  desc: string;
  bullets: string[];
  icon: string; // SVG string
};

export type Step = {
  title: string;
  desc: string;
  icon: string; // SVG string
};

export type ScreenTabId = 'tarefas' | 'financas' | 'agenda';

export type ScreenCard = {
  title: string;
  meta: string;
  value: string;
  note: string;
};

export type Screen = {
  title: string;
  kpi: string;
  desc: string;
  cards: ScreenCard[];
};

export type Testimonial = {
  name: string;
  score: string;
  quote: string;
  meta: string;
};

export type Pricing = {
  free: string[];
  premium: string[];
  valueProps: string[];
};

export type FAQ = {
  q: string;
  a: string;
};

export const links: Record<LinkKey, string> = {
  // Ajuste quando tiver links reais (App Store / Play Store / contato)
  cta: '#precos',
  demo: '#como-funciona',
  support: '#faq',
  privacy: '#',
  terms: '#',
};

export const moods: Mood[] = [
  { id: 'leve', emoji: '🙂', label: 'Leve' },
  { id: 'ok', emoji: '😌', label: 'Ok' },
  { id: 'ansioso', emoji: '😵‍💫', label: 'Tenso' },
  { id: 'cansado', emoji: '😴', label: 'Cansado' },
  { id: 'feliz', emoji: '😍', label: 'Feliz' },
];

export const features: Feature[] = [
  {
    title: 'Check-in emocional',
    desc: 'Um ritual diário pra melhorar comunicação e empatia — com histórico e insights.',
    bullets: ['Humor do dia', 'Histórico semanal', 'Notificações mútuas'],
    icon:
      '<svg width="22" height="22" viewBox="0 0 24 24" fill="none"><path d="M12 21s-7-4.7-9.3-9.1C.8 8.6 2.6 5.4 6 5.1c1.7-.2 3.2.6 4 1.8.8-1.2 2.3-2 4-1.8 3.4.3 5.2 3.5 3.3 6.8C19 16.3 12 21 12 21Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/></svg>',
  },
  {
    title: 'Agenda compartilhada',
    desc: 'Planejem juntos eventos e lembretes para reduzir esquecimentos e atritos.',
    bullets: ['Eventos recorrentes', 'Lembretes', 'Visão semanal'],
    icon:
      '<svg width="22" height="22" viewBox="0 0 24 24" fill="none"><path d="M7 3v3M17 3v3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M4 8h16v13H4V8Z" stroke="currentColor" stroke-width="2"/><path d="M7 12h3M7 16h3M13 12h4M13 16h4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>',
  },
  {
    title: 'Metas do casal',
    desc: 'Definam objetivos e acompanhem progresso com leveza e constância.',
    bullets: ['Objetivos mensais', 'Progresso visual', 'Celebrar vitórias'],
    icon:
      '<svg width="22" height="22" viewBox="0 0 24 24" fill="none"><path d="M12 2l3 7h7l-5.5 4 2 7-6.5-4-6.5 4 2-7L2 9h7l3-7Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/></svg>',
  },
  {
    title: 'Tarefas organizadas',
    desc: 'Divisão justa, prioridades e clareza do que importa hoje.',
    bullets: ['Prioridades', 'Tags', 'Divisão automática'],
    icon:
      '<svg width="22" height="22" viewBox="0 0 24 24" fill="none"><path d="M4 7h16M4 12h16M4 17h10" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>',
  },
  {
    title: 'Finanças a dois',
    desc: 'Controle gastos, divisão (50/50 ou personalizada) e gráficos mensais.',
    bullets: ['Contas compartilhadas', 'Status pago/pendente', 'Gráficos'],
    icon:
      '<svg width="22" height="22" viewBox="0 0 24 24" fill="none"><path d="M12 1v22" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M17 5.5c0-2-2-3.5-5-3.5S7 3.5 7 5.5 9 9 12 9s5 1.5 5 3.5S15 16 12 16s-5-1.5-5-3.5" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>',
  },
  {
    title: 'Memórias e notas',
    desc: 'Registrem momentos, decisões e combinados — com sincronização.',
    bullets: ['Notas compartilhadas', 'Fixar lembretes', 'Histórico'],
    icon:
      '<svg width="22" height="22" viewBox="0 0 24 24" fill="none"><path d="M7 4h10v16H7V4Z" stroke="currentColor" stroke-width="2"/><path d="M9 8h6M9 12h6M9 16h4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>',
  },
];

export const steps: Step[] = [
  {
    title: 'Criem sua conta',
    desc: 'Cadastrem com e-mail e senha em poucos segundos.',
    icon:
      '<svg width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Z" stroke="currentColor" stroke-width="2"/><path d="M4 22a8 8 0 0 1 16 0" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>',
  },
  {
    title: 'Conectem-se',
    desc: 'Gerem um código de convite e vinculem o casal.',
    icon:
      '<svg width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M10 13a5 5 0 0 1 0-7l1-1a5 5 0 0 1 7 7l-1 1" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M14 11a5 5 0 0 1 0 7l-1 1a5 5 0 0 1-7-7l1-1" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>',
  },
  {
    title: 'Planejem juntos',
    desc: 'Organizem tarefas, agenda e finanças sem ruído.',
    icon:
      '<svg width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M4 5h16v14H4V5Z" stroke="currentColor" stroke-width="2"/><path d="M7 8h10M7 12h6M7 16h8" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>',
  },
  {
    title: 'Realizem sonhos',
    desc: 'Criem hábitos e celebrem evolução com histórico e insights.',
    icon:
      '<svg width="20" height="20" viewBox="0 0 24 24" fill="none"><path d="M12 2l3 7h7l-5.5 4 2 7-6.5-4-6.5 4 2-7L2 9h7l3-7Z" stroke="currentColor" stroke-width="2" stroke-linejoin="round"/></svg>',
  },
];

export const screenTabs: { id: ScreenTabId; label: string }[] = [
  { id: 'tarefas', label: 'Tarefas' },
  { id: 'financas', label: 'Finanças' },
  { id: 'agenda', label: 'Agenda' },
];

export const screens: Record<ScreenTabId, Screen> = {
  tarefas: {
    title: 'Tarefas do casal',
    kpi: 'Prioridades + tags',
    desc: 'Clareza do que fazer hoje e divisão justa para reduzir sobrecarga.',
    cards: [
      { title: 'Hoje', meta: 'pendentes', value: '7', note: 'com 2 de alta prioridade' },
      { title: 'Divisão', meta: 'equilíbrio', value: '52/48', note: 'mais justo ao longo da semana' },
      { title: 'Rotina', meta: 'streak', value: '12 dias', note: 'constância sem pressão' },
      { title: 'Rápido', meta: 'tempo', value: '2 min', note: 'pra planejar o dia' },
    ],
  },
  financas: {
    title: 'Finanças a dois',
    kpi: '50/50 ou personalizado',
    desc: 'Acompanhe contas, histórico e gráficos mensais sem planilha.',
    cards: [
      { title: 'Mês atual', meta: 'total', value: 'R$ 499', note: 'visão clara do orçamento' },
      { title: 'Pendentes', meta: 'contas', value: '3', note: 'com lembretes automáticos' },
      { title: 'Divisão', meta: 'regra', value: '60/40', note: 'ajustável por categoria' },
      { title: 'Histórico', meta: 'meses', value: '12', note: 'comparativos e tendências' },
    ],
  },
  agenda: {
    title: 'Agenda compartilhada',
    kpi: 'sem esquecer datas',
    desc: 'Eventos, lembretes e recorrências para planejar a vida juntos.',
    cards: [
      { title: 'Semana', meta: 'eventos', value: '5', note: 'com lembrete antes' },
      { title: 'Recorrência', meta: 'hábitos', value: '2x', note: 'rituais do casal' },
      { title: 'Datas', meta: 'importantes', value: '3', note: 'aniversários e marcos' },
      { title: 'Foco', meta: 'hoje', value: '1', note: 'prioridade do dia' },
    ],
  },
};

export const perks: string[] = [
  'Menos atrito e mais combinados claros',
  'Histórico e evolução do relacionamento',
  'Notificações úteis (você controla)',
  'Organização sem planilhas e sem caos',
  'Rituais simples para fortalecer conexão',
];

export const testimonials: Testimonial[] = [
  {
    name: 'Gabi & Marlon',
    score: '★★★★★ 4.9',
    quote: 'Parou aquela sensação de “tô fazendo tudo”. Agora fica claro o que é de quem.',
    meta: 'Tarefas + rotina semanal',
  },
  {
    name: 'Lu & Pedro',
    score: '★★★★★ 5.0',
    quote: 'O check-in virou nosso momento do dia. A conversa ficou mais leve.',
    meta: 'Check-in emocional',
  },
  {
    name: 'Bi & Rafa',
    score: '★★★★☆ 4.8',
    quote: 'As finanças finalmente ficaram organizadas sem planilha e sem discussão.',
    meta: 'Finanças a dois',
  },
];

export const pricing: Pricing = {
  free: ['Conectar casal por convite', 'Tarefas e agenda básicas', 'Check-in diário', 'Notificações essenciais'],
  premium: ['Histórico avançado e insights', 'Personalização de divisão de finanças', 'Gráficos e relatórios', 'Recursos premium do casal'],
  valueProps: ['Experiência sem anúncios', 'Recursos exclusivos', 'Evolução com dados e histórico'],
};

export const faqs: FAQ[] = [
  {
    q: 'O DuoDay é para casais que moram juntos?',
    a: 'Serve tanto para casais que moram juntos quanto para quem vive separado — a ideia é organizar e manter conexão.',
  },
  {
    q: 'Como eu conecto meu parceiro?',
    a: 'Você gera um código (DUO-XXXX) e seu parceiro insere no app. Pronto: o casal fica vinculado.',
  },
  {
    q: 'Dá pra usar sem notificações?',
    a: 'Sim. Você controla permissões e pode desligar notificações no app e no sistema.',
  },
  {
    q: 'Preciso de internet o tempo todo?',
    a: 'A maioria dos recursos funciona melhor com internet. Onde fizer sentido, o app pode mostrar estados offline.',
  },
];

