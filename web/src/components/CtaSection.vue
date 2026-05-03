<script setup lang="ts">
const props = defineProps<{
  ctaHref: string;
  secondaryHref: string;
}>();
</script>

<template>
  <section class="section">
    <div class="container">
      <div
        class="card"
        style="
          padding: 22px;
          border-color: rgba(123, 97, 255, 0.25);
          background: radial-gradient(800px 220px at 20% 0%, rgba(123, 97, 255, 0.18), rgba(255, 255, 255, 0) 65%),
            radial-gradient(700px 220px at 85% 40%, rgba(244, 114, 182, 0.14), rgba(255, 255, 255, 0) 60%),
            rgba(255, 255, 255, 0.9);
        "
      >
        <div class="grid ctaRow" style="grid-template-columns: 1fr; align-items: center; gap: 16px">
          <div>
            <h3 style="margin: 0; font-size: 26px; letter-spacing: -0.02em; font-weight: 1100">
              Comece hoje a construir a história de vocês
            </h3>
            <p class="lead" style="margin-top: 10px; font-size: 16px">
              Baixe o DuoDay, conecte com seu parceiro e faça a primeira semana ser mais leve e alinhada.
            </p>
          </div>

          <div style="display: flex; gap: 10px; flex-wrap: wrap; justify-content: flex-end; margin-top: 10px">
            <a class="btn btn-primary" :href="props.ctaHref">Baixar agora</a>
            <a class="btn" :href="props.secondaryHref">Falar com a equipe</a>
          </div>
        </div>

        <div class="grid ctaTiles" style="margin-top: 14px; grid-template-columns: 1fr; gap: 12px">
          <div class="card" style="padding: 14px; background: rgba(15,23,42,.03)">Sem spam. Só conteúdo útil.</div>
          <div class="card" style="padding: 14px; background: rgba(15,23,42,.03)">Cancelamento simples.</div>
          <div class="card" style="padding: 14px; background: rgba(15,23,42,.03)">Privacidade e controle.</div>
        </div>
      </div>
    </div>
  </section>
</template>

