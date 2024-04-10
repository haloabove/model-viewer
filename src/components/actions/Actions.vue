<template>
  <div class="action-container">
    <RplButton
      @click="previous"
      v-bind="{
        variant:'elevated',
        iconName:'icon-arrow-left',
        disabled: !activeButtons
      }"
      :class="['previous', { disabled: !activeButtons }]"
    >
    </RplButton>
    <RplButton
      @click="togglePlay"
      v-bind="{
        label: composeLabel,
        variant: 'elevated',
        iconName: composeIcon,
        disabled: !activeButtons
      }"
      :class="['auto-play', {disabled: !activeButtons}]"
    >
    </RplButton>
    <RplButton
      @click="next"
      v-bind="{
        variant:'elevated',
        iconName:'icon-arrow-right',
        disabled: !activeButtons
      }"
      :class="['next', { disabled: !activeButtons }]"
    >
    </RplButton>
  </div>
</template>
<script lang="ts">
import { computed, defineComponent } from 'vue';
import { RplButton } from "@dpc-sdp/ripple-ui-core/vue";
import { useStore } from '@/store/index';
import emitter from '../../eventBus';

export default defineComponent({
  name: 'Actions',
  components:{
    RplButton
  },
  props: {
    assetsLoaded: {
      type: Boolean,
      required: true,
    }
  },
  setup(props){
    const store = useStore();
    const animationState = computed(()=> store.getters.autoplayState);
    const activeButtons = computed(()=> props.assetsLoaded);
    const autoPlay = computed(() => store.getters.autoplayState);
    const previous = (): void => {
      console.log('prev')
      emitter.emit('rotate', 'previous');
    };
    const next = (): void => {
      emitter.emit('rotate', 'next');
    };
    const togglePlay = (): void => {
      if(animationState.value){
        store.dispatch('autoplay', false);
      }else{
        store.dispatch('autoplay', true);
      }
    };
    const composeLabel = computed((): string =>{
       if(autoPlay.value){
        return 'Pause';
       }
       return 'Play';
    });
    const composeIcon = computed((): string =>{
       if(autoPlay.value){
        return 'icon-pause-circle-lined';
       }
       return 'icon-play-circle-lined';
    });

    return {
      previous,
      next,
      togglePlay,
      activeButtons,
      composeLabel,
      composeIcon
    }
  }
})
</script>
<style lang="scss">
.action{
  &-container {
    display: flex;
    justify-content: center;
    button{
      margin: 0 1rem;
    }
    .disabled{
      opacity: 0.6;
      cursor: not-allowed;
      pointer-events: none;
    }
  }
}
</style>
