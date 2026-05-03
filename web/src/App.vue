<script setup lang="ts">
import AppHeader from './components/AppHeader.vue';
import HeroSection from './components/HeroSection.vue';
import FeaturesSection from './components/FeaturesSection.vue';
import HowItWorksSection from './components/HowItWorksSection.vue';
import ScreensSection from './components/ScreensSection.vue';
import TestimonialsSection from './components/TestimonialsSection.vue';
import PricingSection from './components/PricingSection.vue';
import FaqSection from './components/FaqSection.vue';
import CtaSection from './components/CtaSection.vue';
import AppFooter from './components/AppFooter.vue';

import { faqs, features, links, moods, perks, pricing, screens, screenTabs, steps, testimonials } from './content';

const nav = [
  { label: 'Funcionalidades', href: '#features' },
  { label: 'Como funciona', href: '#como-funciona' },
  { label: 'Telas', href: '#telas' },
  { label: 'Plano', href: '#precos' },
  { label: 'FAQ', href: '#faq' },
];
</script>

<template>
  <AppHeader :links="{ cta: links.cta, demo: links.demo }" :nav="nav" />

  <main>
    <HeroSection :links="{ cta: links.cta, demo: links.demo }" :moods="moods" />
    <FeaturesSection :features="features" />
    <HowItWorksSection :steps="steps" />
    <ScreensSection :tabs="screenTabs" :screens="screens" :perks="perks" />
    <TestimonialsSection :testimonials="testimonials" />
    <PricingSection :pricing="pricing" :cta-href="links.cta" />
    <FaqSection :faqs="faqs" />
    <CtaSection :cta-href="links.cta" :secondary-href="links.support" />
  </main>

  <AppFooter :links="{ privacy: links.privacy, terms: links.terms, support: links.support }" />
</template>

