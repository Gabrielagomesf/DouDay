<script setup lang="ts">
import { computed, ref } from 'vue';
import type { Screen, ScreenTabId } from '../content';

const props = defineProps<{
  tabs: { id: ScreenTabId; label: string }[];
  screens: Record<ScreenTabId, Screen>;
  perks: string[];
}>();

const selected = ref<ScreenTabId>(props.tabs[0]?.id ?? 'tarefas');
const current = computed(() => props.screens[selected.value]);
</script>

<template>
  <section id="telas" class="section">
    <div class="container">
      <div style="display: flex; align-items: end; justify-content: space-between; gap: 16px; flex-wrap: wrap">
        <div style="max-width: 740px">
          <div class="kicker">Telas</div>
          <h2 class="h2">Do dia a dia ao longo prazo</h2>
          <p class="lead" style="font-size: 16px">
            Veja o que está acontecendo agora, planeje a semana e acompanhe evolução com histórico.
          </p>
        </div>
        <div class="tabs" role="tablist" aria-label="Seletor de telas">
          <button
            v-for="t in props.tabs"
            :key="t.id"
            class="tab"
            role="tab"
            :aria-selected="selected === t.id"
            type="button"
            @click="selected = t.id"
          >
            {{ t.label }}
          </button>
        </div>
      </div>

      <div class="grid screensGrid" style="margin-top: 18px">
        <div class="card card-pad">
          <div style="display: flex; justify-content: space-between; align-items: center; gap: 12px">
            <div style="font-weight: 1000; letter-spacing: -0.01em">{{ current.title }}</div>
            <span class="kpiPill">{{ current.kpi }}</span>
          </div>
          <p class="subtle" style="margin: 10px 0 0">{{ current.desc }}</p>

          <div class="grid" style="margin-top: 14px">
            <div class="grid" style="grid-template-columns: repeat(2, minmax(0,1fr))">
              <div v-for="c in current.cards" :key="c.title" class="card" style="padding: 14px; background: rgba(15,23,42,.03)">
                <div style="display:flex; align-items:center; justify-content: space-between; gap: 10px">
                  <div style="font-size: 12px; font-weight: 1000; color: rgba(15,23,42,.60)">{{ c.title }}</div>
                  <div class="subtle">{{ c.meta }}</div>
                </div>
                <div style="margin-top: 8px; font-size: 20px; font-weight: 1000">{{ c.value }}</div>
                <div class="subtle" style="margin-top: 8px">{{ c.note }}</div>
              </div>
            </div>
          </div>
        </div>

        <aside class="card card-pad">
          <div style="font-weight: 1000">O que você ganha</div>
          <ul class="bullets" style="margin-top: 12px">
            <li v-for="p in props.perks" :key="p">{{ p }}</li>
          </ul>
          <div style="height: 12px" />
          <div class="card" style="padding: 14px; border-color: rgba(123,97,255,.22); background: rgba(123,97,255,.06)">
            <div style="font-size: 12px; font-weight: 1000; color: rgba(15,23,42,.62)">Dica</div>
            <div style="margin-top: 6px; font-weight: 1000">Comece pelo “Check-in emocional”</div>
            <p class="subtle" style="margin: 8px 0 0">1 minuto por dia muda a forma como vocês conversam.</p>
          </div>
        </aside>
      </div>
    </div>
  </section>
</template>

