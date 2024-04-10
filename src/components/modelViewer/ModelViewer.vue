<template>
   <div @click="closePreview" class="container" :style="{ width: setWidth + 'px', height: setHeight + 'px' }">
      <Preview v-if="!assetsLoaded" :projectName="projectName" :imageCounts="imagesToBeLoaded" />
      <Viewer v-else />
  </div>
  <Actions  :style="{ width: setWidth + 'px'}" :assetsLoaded="assetsLoaded"/>
</template>
<script lang="ts">
import { computed, defineComponent, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import { useStore } from '@/store/index'
import Preview from './Preview.vue';
import Viewer from './Viewer.vue';
import Actions from '../actions/Actions.vue';

export default defineComponent({
  name: 'ModelViewer',
  components: {
    Actions,
    Preview,
    Viewer
  },
  data() {
    return {
      imagesToBeLoaded: 0,
      position: 0,
      height: 0,
      width: 0,
    };
  },
  setup() {
    const assetsLoaded = ref(false);
    const route = useRoute();
    const projectLocation = ref('');
    const count = ref(0);
    const drag = ref(null);
    const height = ref(0);
    const width = ref(0);
    const store = useStore();
    const progressBarWidth = computed(() => store.getters.progressBarWidth);
    const calculatedWidth = computed<string>(() => {
      return Math.round(progressBarWidth.value).toString() + '%';
    });
    const loadedImages = computed(() => store.getters.loaded);

    const imagesToBeLoaded = computed<number>(() => {
      if (typeof route.query.imageCount === 'string') {
        count.value = parseInt(route.query.imageCount, 10) || 0;
      } else {
        count.value = 60;
      }
      return count.value;
    });
    const imagesLoaded = computed<boolean>(() => {
      return loadedImages.value;
    });
    const projectName = computed<string>(() => {
      if (typeof route.query.projectName === 'string') {
        projectLocation.value = route.query.projectName;
      } else {
        projectLocation.value = 'default';
      }
      return projectLocation.value;
    });
    const setWidth = computed<number>(() => {
      if (typeof route.query.width === 'string') {

        width.value = parseInt(route.query.width);
      } else {
        width.value = 600;
      }
      return width.value;
    });
    const setHeight = computed<number>(() => {
      if (typeof route.query.height === 'string') {
        height.value = parseInt(route.query.height);
      } else {
        height.value = 400;
      }
      return height.value;
    });
    const closePreview = (): void => {
      if(imagesLoaded.value && !assetsLoaded.value){
        assetsLoaded.value = true;
      }
    };

    watch(imagesLoaded, async () => {
      setTimeout(()=>{
        assetsLoaded.value = true;
      }, 2000);
    });

    return {
      projectName,
      imagesToBeLoaded,
      setHeight,
      setWidth,
      calculatedWidth,
      progressBarWidth,
      drag,
      assetsLoaded,
      loadedImages,
      closePreview
    }
  },
});
</script>
<style lang="scss">
@import "../scss/modelViewer.scss";
</style>
