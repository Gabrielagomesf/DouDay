<script setup lang="ts">
import type { Step } from '../content';

const props = defineProps<{
  steps: Step[];
}>();
</script>

<template>
  <section id="como-funciona" class="section section-muted">
    <div class="container">
      <div style="max-width: 700px">
        <div class="kicker">Como funciona</div>
        <h2 class="h2">Em 4 passos</h2>
        <p class="lead" style="font-size: 16px">
          Uma jornada simples: começar, conectar, planejar e evoluir juntos — com leveza.
        </p>
      </div>

      <div class="grid stepsGrid" style="margin-top: 22px">
        <article v-for="(s, idx) in props.steps" :key="s.title" class="card card-pad">
          <div class="stepTop">
            <div class="stepNum">Passo {{ idx + 1 }}</div>
            <div class="featureIcon" v-html="s.icon" aria-hidden="true" />
          </div>
          <div style="margin-top: 10px; font-weight: 1000; letter-spacing: -0.01em">{{ s.title }}</div>
          <p class="subtle" style="margin: 10px 0 0">{{ s.desc }}</p>
        </article>
      </div>
    </div>
  </section>
</template>

