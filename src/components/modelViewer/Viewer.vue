
<template>
  <div
    @touchmove="swipe"
    @mousedown.left="mouseEnter"
    @mouseup.left="mouseLeave"
    ref="drag"
    class="image-models"
  >
    <img
      draggable="false"
      v-for="(image) in images"
      :key="image.id"
      :src="image.url"
      :alt="image.alt"
      :class="{visible: image.visible}"
    />
  </div>
</template>
<script lang="ts">
import { computed, defineComponent, ref, watch } from 'vue';
import { useStore } from '@/store/index'
import emitter from '../../eventBus';

export default defineComponent({
  name: 'Viewer',
  data() {
    return {
      position: 0,
    };
  },
  setup() {
    let autoPlayInterval: number | null = null;
    let position = ref(0);
    const drag = ref(null);
    const store = useStore();
    const images = computed(() => store.getters.images);
    const autoPlay = computed(() => store.getters.autoplayState);
    const swipe = (event: TouchEvent): void => {
      clearAnimationInterval();
      store.dispatch('autoplay', false);

      const positionFromEvent = event.changedTouches[0].clientX;
      const currentIndex = images.value.findIndex((image) => image.visible);

      if (position.value === positionFromEvent) {
        return
      }

      let operation: number;

      if (position.value > positionFromEvent) {
        operation = currentIndex - 1;
      }

      if (position.value < positionFromEvent) {
        operation = currentIndex + 1;
      }

      const nextIndex = (operation! + images.value.length) % images.value.length;
      images.value[currentIndex].visible = false;
      images.value[nextIndex].visible = true;

      position.value = positionFromEvent;
    }
    const mouseEnter = ({x}:MouseEvent): void => {
      position.value = x;
      (drag.value as any).addEventListener('mousemove', mouseMove, false);
    };
    const mouseLeave = (): void => {
      (drag.value as any).removeEventListener('mousemove', mouseMove, false);
    };
    const mouseMove = ({x}:MouseEvent): void => {
      clearAnimationInterval();
      store.dispatch('autoplay', false);

      const currentIndex = images.value.findIndex((image) => image.visible);

      if (position.value === x) {
        return
      }

      let operation: number| null = null;

      if (position.value > x) {
        operation = currentIndex - 1;
      }

      if (position.value < x) {
        operation = currentIndex + 1;
      }

      const nextIndex = (operation + images.value.length) % images.value.length;
      images.value[currentIndex].visible = false;
      images.value[nextIndex].visible = true;

      position.value = x;
    };
    const clearAnimationInterval = ()=> {
      if (autoPlayInterval !== null) {
        window.clearInterval(autoPlayInterval);
        autoPlayInterval = null;
      }
    };
    const animate = (toggle: boolean) => {
      if (toggle) {
        if (autoPlayInterval === null) {
          autoPlayInterval = window.setInterval(() => {
            const currentIndex = images.value.findIndex((image) => image.visible);
            let nextIndex = (currentIndex + 1) % images.value.length;

            images.value[currentIndex].visible = false;
            images.value[nextIndex].visible = true;
          }, 100);
        }
      } else {
        clearAnimationInterval();
      }
    };
    const rotate = (direction: string) => {
      const currentIndex = images.value.findIndex((image) => image.visible);
      let nextIndex: number;

      switch (direction) {
        case 'next':
          nextIndex = (currentIndex + 1) % images.value.length;
          break;
        case 'previous':
          nextIndex = (currentIndex - 1 + images.value.length) % images.value.length;
          break;
        default:
          return;
      }

      images.value[currentIndex].visible = false;
      images.value[nextIndex].visible = true;
    };
    const showToolTip = () => {
      console.log('mouseOver')
    };
    const autoHide = () => {
      setTimeout(()=>{
        return false;
      }, 200)
    };

    emitter.on('rotate', direction => {
      rotate(direction);
    });

    watch(autoPlay, async (newVal, oldVal) => {
      if (newVal !== oldVal && newVal) {
        animate(true);
      }else{
        animate(false);
      }
    });

    return {
      images,
      swipe,
      mouseEnter,
      mouseLeave,
      mouseMove,
      drag,
      showToolTip,
      autoHide
    }
  },
})
</script>
