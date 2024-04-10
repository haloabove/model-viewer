
<template>
  <div class="preview">
    <RplButton
      @click="loadImages"
      v-bind="{
        label: composeLabel,
        busy: isLoading,
        variant:'elevated',
        class:'load-images'
      }"
    >
    </RplButton>
    <img
      :draggable="false"
      :src="composePreviewUrl"
      :alt="projectName"
      :class="'visible preview-image'"
    />
  </div>
</template>
<script lang="ts">
import { defineComponent, computed } from 'vue';
import { RplButton } from "@dpc-sdp/ripple-ui-core/vue";
import { useStore } from '@/store/index';

export default defineComponent({
  name: 'Preview',
  components: {
    RplButton
  },
  props: {
    projectName: {
      type: String,
      required: true,
    },
    imageCounts: {
      type: Number,
      required: true,
    },
  },
  setup(props) {
    const store = useStore();
    const isLoading = computed(() => store.getters.isLoading);
    const loaded = computed(() => store.getters.loaded);
    const loadImages = (): void => {
      store.dispatch('fetchImages', { projectName: props.projectName, imageCounts: props.imageCounts });
    };
    const composeLabel = computed((): string => {
      return !loaded.value ? 'Load interactive 3d model': 'Drag to rotate';
    });
    const composePreviewUrl = computed(():string => {
       return props.projectName==='default' ?
       `./projects/${props.projectName}/0.jpg`:
       `./projects/${props.projectName}/${props.projectName}_5FPS000.jpg`;
    });

    return {
      loadImages,
      isLoading,
      composeLabel,
      composePreviewUrl
    }
  },
})
</script>
