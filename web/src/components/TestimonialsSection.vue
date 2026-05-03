<script setup lang="ts">
import type { Testimonial } from '../content';

const props = defineProps<{
  testimonials: Testimonial[];
}>();
</script>

<template>
  <section class="section section-muted">
    <div class="container">
      <div style="max-width: 740px">
        <div class="kicker">Avaliações</div>
        <h2 class="h2">Casais que viraram mais time</h2>
        <p class="lead" style="font-size: 16px">Feedbacks reais sobre organização, comunicação e paz no dia a dia.</p>
      </div>

      <div class="grid threeCol" style="margin-top: 22px">
        <div
          v-for="t in props.testimonials"
          :key="t.name"
          class="card card-pad"
          style="display: grid; gap: 10px"
        >
          <div style="display:flex; align-items:center; justify-content: space-between; gap: 12px">
            <div style="font-weight: 1000">{{ t.name }}</div>
            <div class="subtle">{{ t.score }}</div>
          </div>
          <p style="margin: 0; color: rgba(15,23,42,.82); line-height: 1.6">“{{ t.quote }}”</p>
          <div class="subtle">{{ t.meta }}</div>
        </div>
      </div>
    </div>
  </section>
</template>

