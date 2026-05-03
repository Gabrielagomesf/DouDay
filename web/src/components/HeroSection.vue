<script setup lang="ts">
import { computed, ref } from 'vue';
import type { Mood } from '../content';

const props = defineProps<{
  links: { cta: string; demo: string };
  moods: Mood[];
}>();

const selectedMood = ref(props.moods[0]?.id ?? 'leve');

const avatarColors = ['rgba(123,97,255,.20)', 'rgba(244,114,182,.18)', 'rgba(34,197,94,.18)', 'rgba(245,158,11,.18)'];
const avatars = computed(() => avatarColors.map((bg) => ({ bg })));
</script>

<template>
  <section id="top" class="hero">
    <div class="hero-bg" aria-hidden="true" />
    <div class="container">
      <div class="hero-row">
        <div>
          <div class="pill"><span class="dot" /> Feito para casais que constroem juntos</div>
          <h1 class="h1">Tudo o que vocês precisam para viver mais conectados, todos os dias.</h1>
          <p class="lead">
            Organize tarefas, finanças e agenda em um só lugar. Tenha check-ins emocionais, missões do dia e insights para
            fortalecer o relacionamento.
          </p>

          <div class="hero-ctas">
            <a class="btn btn-primary" :href="props.links.cta">Baixar agora</a>
            <a class="btn" :href="props.links.demo">Ver como funciona</a>
          </div>

          <div class="socialProof">
            <div class="avatars" aria-hidden="true">
              <span
                v-for="(a, idx) in avatars"
                :key="idx"
                class="avatar"
                :style="{ background: a.bg }"
              />
            </div>
            <div>
              <b style="color: var(--fg)">4.9/5</b>
              <div style="font-size: 12px">Mais de 10 mil casais já estão usando</div>
            </div>
          </div>
        </div>

        <div class="mock">
          <div class="card card-pad">
            <div class="mockHeader">
              <div style="display: flex; align-items: center; gap: 10px">
                <span class="featureIcon" aria-hidden="true">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
                    <path d="M7 7h10M7 12h10M7 17h6" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                  </svg>
                </span>
                <div>
                  <div style="font-weight: 900; letter-spacing: -0.01em">Dashboard do casal</div>
                  <div class="subtle">Resumo do dia + prioridades</div>
                </div>
              </div>
              <span class="badge">Ao vivo</span>
            </div>

            <div style="height: 14px" />

            <div class="grid">
              <div class="card" style="padding: 14px; background: rgba(15,23,42,.03)">
                <div style="display: flex; justify-content: space-between; align-items: center; gap: 12px">
                  <div style="font-size: 12px; font-weight: 900; color: rgba(15,23,42,.6)">Missão do dia</div>
                  <div class="subtle">+20 pts</div>
                </div>
                <div style="margin-top: 8px; font-weight: 900">5 minutos sem celular</div>
                <div style="margin-top: 10px" class="progress"><span /></div>
              </div>

              <div class="miniGrid">
                <div class="card" style="padding: 14px; background: rgba(15,23,42,.03)">
                  <div style="font-size: 12px; font-weight: 900; color: rgba(15,23,42,.6)">Tarefas</div>
                  <div style="margin-top: 8px; font-size: 26px; font-weight: 1000">7</div>
                  <div class="subtle">para hoje</div>
                </div>
                <div class="card" style="padding: 14px; background: rgba(15,23,42,.03)">
                  <div style="font-size: 12px; font-weight: 900; color: rgba(15,23,42,.6)">Finanças</div>
                  <div style="margin-top: 8px; font-size: 26px; font-weight: 1000">R$ 499</div>
                  <div class="subtle">mês atual</div>
                </div>
              </div>
            </div>
          </div>

          <div class="card card-pad" style="border-color: rgba(123,97,255,.25)">
            <div style="display: flex; justify-content: space-between; align-items: center; gap: 12px">
              <div style="font-weight: 900">Check-in emocional</div>
              <div class="subtle">Hoje</div>
            </div>
            <div style="height: 10px" />
            <div class="miniGrid" style="grid-template-columns: repeat(5, minmax(0,1fr))">
              <button
                v-for="m in props.moods"
                :key="m.id"
                type="button"
                class="tab"
                :aria-selected="selectedMood === m.id"
                :style="{ padding: '10px 8px', textAlign: 'center', fontWeight: 900 }"
                @click="selectedMood = m.id"
              >
                <div style="font-size: 18px; line-height: 1">{{ m.emoji }}</div>
                <div style="font-size: 11px; margin-top: 4px">{{ m.label }}</div>
              </button>
            </div>
            <p class="subtle" style="margin: 10px 0 0">
              Um ritual simples que melhora comunicação e conexão — sem pressão.
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

