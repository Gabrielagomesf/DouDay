<script setup lang="ts">
import { computed, ref } from 'vue';

type NavItem = { label: string; href: string };

const props = defineProps<{
  links: {
    cta: string;
    demo: string;
  };
  nav: NavItem[];
}>();

const mobileOpen = ref(false);
const toggle = () => (mobileOpen.value = !mobileOpen.value);
const close = () => (mobileOpen.value = false);

const year = computed(() => new Date().getFullYear());
</script>

<template>
  <header class="topbar">
    <div class="container">
      <div class="topbar-row">
        <a class="brand" href="#top" aria-label="Ir para o topo">
          <span class="logo" aria-hidden="true">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" class="opacity-95">
              <path
                d="M12 21s-7-4.7-9.3-9.1C.8 8.6 2.6 5.4 6 5.1c1.7-.2 3.2.6 4 1.8.8-1.2 2.3-2 4-1.8 3.4.3 5.2 3.5 3.3 6.8C19 16.3 12 21 12 21Z"
                stroke="currentColor"
                stroke-width="1.8"
                stroke-linejoin="round"
              />
            </svg>
          </span>
          <span>
            <div style="font-weight: 900; letter-spacing: -0.02em">DuoDay</div>
            <div style="font-size: 12px; color: var(--muted)">App para casais</div>
          </span>
        </a>

        <nav class="nav" aria-label="Navegação">
          <a v-for="i in nav" :key="i.href" :href="i.href">{{ i.label }}</a>
        </nav>

        <div class="actions">
          <a class="btn" :href="props.links.demo">Ver como funciona</a>
          <a class="btn btn-primary" :href="props.links.cta">Baixar agora</a>

          <button class="menuBtn" type="button" @click="toggle" aria-label="Abrir menu">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
              <path d="M4 7h16M4 12h16M4 17h16" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
            </svg>
          </button>
        </div>
      </div>

      <div v-if="mobileOpen" class="menuPanel" aria-label="Menu mobile">
        <a v-for="i in nav" :key="i.href" :href="i.href" @click="close">{{ i.label }}</a>
        <div style="height: 10px" />
        <a class="btn" style="width: 100%" :href="props.links.demo" @click="close">Ver como funciona</a>
        <div style="height: 10px" />
        <a class="btn btn-primary" style="width: 100%" :href="props.links.cta" @click="close">Baixar agora</a>
        <div style="height: 10px" />
        <div style="font-size: 12px; color: var(--muted)">© {{ year }} DuoDay</div>
      </div>
    </div>
  </header>
</template>

