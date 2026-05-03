<script setup lang="ts">
import type { Feature } from '../content';

const props = defineProps<{
  features: Feature[];
}>();
</script>

<template>
  <section id="features" class="section">
    <div class="container">
      <div style="max-width: 700px">
        <div class="kicker">Funcionalidades</div>
        <h2 class="h2">Um app completo para o casal</h2>
        <p class="lead" style="font-size: 16px">
          Tudo integrado: organização, finanças, agenda e conexão emocional. Cada módulo foi pensado para reduzir atritos e
          aumentar clareza no dia a dia.
        </p>
      </div>

      <div class="grid featureGrid" style="margin-top: 22px">
        <article v-for="f in props.features" :key="f.title" class="card card-pad">
          <div style="display: flex; align-items: center; gap: 12px">
            <div class="featureIcon" v-html="f.icon" aria-hidden="true" />
            <div class="featureTitle">{{ f.title }}</div>
          </div>
          <p class="subtle" style="margin: 10px 0 0">{{ f.desc }}</p>
          <ul class="bullets">
            <li v-for="b in f.bullets" :key="b">{{ b }}</li>
          </ul>
        </article>
      </div>
    </div>
  </section>
</template>

