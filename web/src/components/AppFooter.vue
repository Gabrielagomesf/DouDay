<script setup lang="ts">
const props = defineProps<{
  links: {
    privacy: string;
    terms: string;
    support: string;
  };
}>();

const year = new Date().getFullYear();
</script>

<template>
  <footer style="border-top: 1px solid var(--border)">
    <div class="container section" style="padding-top: 42px; padding-bottom: 42px">
      <div class="footerGrid">
        <div>
          <div class="brand">
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
              <div style="font-weight: 1000; letter-spacing: -0.02em">DuoDay</div>
              <div style="font-size: 12px; color: var(--muted)">Um app para fortalecer o relacionamento</div>
            </span>
          </div>

          <p class="subtle" style="margin: 12px 0 0; max-width: 720px">
            DuoDay foi criado para ajudar casais a se organizarem melhor e se comunicarem com mais clareza — sem virar uma
            obrigação. Pequenos hábitos, grandes resultados.
          </p>
          <p class="subtle" style="margin: 12px 0 0">© {{ year }} DuoDay. Todos os direitos reservados.</p>
        </div>

        <div>
          <div style="font-weight: 1000">Produto</div>
          <div class="footerLinks" style="margin-top: 12px">
            <a href="#features">Funcionalidades</a>
            <a href="#como-funciona">Como funciona</a>
            <a href="#precos">Plano Premium</a>
          </div>
        </div>

        <div>
          <div style="font-weight: 1000">Contato</div>
          <div class="footerLinks" style="margin-top: 12px">
            <a :href="props.links.support">Suporte</a>
            <a :href="props.links.privacy">Privacidade</a>
            <a :href="props.links.terms">Termos</a>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

