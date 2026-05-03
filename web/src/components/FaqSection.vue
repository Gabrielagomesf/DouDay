<script setup lang="ts">
import type { FAQ } from '../content';

const props = defineProps<{
  faqs: FAQ[];
}>();
</script>

<template>
  <section id="faq" class="section section-muted">
    <div class="container">
      <div style="max-width: 740px">
        <div class="kicker">FAQ</div>
        <h2 class="h2">Perguntas frequentes</h2>
        <p class="lead" style="font-size: 16px">Respostas rápidas para você começar sem dúvidas.</p>
      </div>

      <div class="faq grid" style="margin-top: 22px">
        <details v-for="q in props.faqs" :key="q.q">
          <summary>
            <span>{{ q.q }}</span>
            <span style="color: rgba(15,23,42,.45); font-weight: 1000">+</span>
          </summary>
          <p>{{ q.a }}</p>
        </details>
      </div>
    </div>
  </section>
</template>

