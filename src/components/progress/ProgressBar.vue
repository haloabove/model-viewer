<template>
  <div v-if="!assetsLoaded" class="progress-bar" :style="{ width: calculatedWidth }"><span>{{Math.round(progressBarWidth) + '%'}}</span></div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'ProgressBar',
  props: {
    assetsLoaded: {
      type: Boolean,
      required: true,
    },
    calculatedWidth: {
      type: String,
      required: true,
    },
    progressBarWidth: {
      type: Number,
      required: true,
    },
  },
})
</script>
