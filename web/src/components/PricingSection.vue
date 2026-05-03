<script setup lang="ts">
import type { Pricing } from '../content';

const props = defineProps<{
  pricing: Pricing;
  ctaHref: string;
}>();
</script>

<template>
  <section id="precos" class="section">
    <div class="container">
      <div style="max-width: 740px">
        <div class="kicker">Plano</div>
        <h2 class="h2">DuoDay Premium</h2>
        <p class="lead" style="font-size: 16px">Mais recursos, mais histórico, mais personalização. Sem complicação.</p>
      </div>

      <div class="grid threeCol" style="margin-top: 22px">
        <article class="card card-pad">
          <div style="font-weight: 1000">Grátis</div>
          <div style="margin-top: 10px; font-size: 40px; font-weight: 1100; letter-spacing: -0.03em">R$ 0</div>
          <div class="subtle">Para começar hoje</div>
          <ul class="bullets" style="margin-top: 14px">
            <li v-for="p in props.pricing.free" :key="p">{{ p }}</li>
          </ul>
          <div style="height: 12px" />
          <a class="btn" style="width: 100%" :href="props.ctaHref">Baixar app</a>
        </article>

        <article
          class="card card-pad"
          style="border-color: rgba(123,97,255,.28); box-shadow: 0 18px 60px rgba(123,97,255,.18)"
        >
          <div style="display:flex; justify-content: space-between; align-items:center; gap: 12px">
            <div style="font-weight: 1000">Premium</div>
            <span class="pill" style="padding: 6px 10px; font-size: 11px"><span class="dot" /> Recomendado</span>
          </div>
          <div style="margin-top: 10px; display:flex; align-items: end; gap: 10px; flex-wrap: wrap">
            <div style="font-size: 40px; font-weight: 1100; letter-spacing: -0.03em">R$ 4,99</div>
            <div class="subtle">/ mês</div>
          </div>
          <div class="subtle">Cancele quando quiser</div>
          <ul class="bullets" style="margin-top: 14px">
            <li v-for="p in props.pricing.premium" :key="p">{{ p }}</li>
          </ul>
          <div style="height: 12px" />
          <a class="btn btn-primary" style="width: 100%" :href="props.ctaHref">Assinar agora</a>
          <p class="subtle" style="margin: 10px 0 0">*Valores ilustrativos — ajuste conforme seu plano real.</p>
        </article>

        <article class="card card-pad">
          <div style="font-weight: 1000">Para casais sérios</div>
          <div style="margin-top: 10px; font-size: 18px; font-weight: 1100">Foco em hábitos</div>
          <p class="subtle" style="margin: 10px 0 0">
            O DuoDay não é só lista de tarefas. É um sistema leve para reduzir estresse e aumentar parceria.
          </p>

          <div class="card" style="margin-top: 14px; padding: 14px; background: rgba(15,23,42,.03)">
            <div style="font-size: 12px; font-weight: 1000; color: rgba(15,23,42,.62)">Inclui</div>
            <ul class="bullets" style="margin-top: 12px">
              <li v-for="p in props.pricing.valueProps" :key="p">{{ p }}</li>
            </ul>
          </div>
        </article>
      </div>
    </div>
  </section>
</template>

