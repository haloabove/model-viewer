import type { InjectionKey } from 'vue'
import { createStore, useStore as baseUseStore, Store } from 'vuex'
import { addZeros } from './helpers'
import type { RotatingImage } from '@/types/rotatingImage.d.ts';
import type { State } from './types.ts';

export const key: InjectionKey<Store<State>> = Symbol()

const getters = {
  images(state: State) {
    return state.images;
  },
  isLoading(state: State) {
    return state.isLoading;
  },
  loadedImageCount(state:State){
    return state.images.length;
  },
  progressBarWidth(state:State){
    return state.progressBarWidth;
  },
  autoplayState(state: State){
    return state.autoplay;
  },
  loaded(state: State){
    return state.loaded;
  },
}

const mutations = {
  setLoading(state: State, payload: boolean) {
    state.isLoading = payload
  },
  setImages(state: State, payload:RotatingImage[]){
    state.images = payload
  },
  setImageCounts(state: State, payload: number){
    state.imageCount = payload
  },
  setProgressBarWidth(state: State, payload: number){
    state.progressBarWidth = payload
  },
  toggleAnimation(state: State, payload: boolean){
    state.autoplay = payload;
  },
  setLoaded(state: State, payload: boolean){
    state.loaded = payload;
  },
}

const actions = {
  async fetchImages(
    { commit, dispatch }: { commit: Function, dispatch: Function },
    { projectName, imageCounts } : {projectName: string, imageCounts: number }) {
    commit('setLoading', true);

    try {
      const imagePromises = Array.from({ length: imageCounts}, (_, i) => {
        let fileName = '';

        if(projectName === 'default'){
          fileName = `${i}.jpg`;
        }else {
          fileName = `${projectName}_5FPS${addZeros(i)}.jpg`;
        }

        return dispatch('fetchImage', { fileName, i, projectName });
      })

      commit('setImageCounts', imageCounts);

      const images = await Promise.all(imagePromises);

      commit('setLoaded', true);
      commit('setImages', images);
    } catch (error) {
      console.error('Error fetching images:', error)
    } finally {
      commit('setLoading', false);
    }
  },
  async fetchImage({ commit, state }: { commit: Function, state: State },
    { fileName, i, projectName }:{ fileName: string, i:number, projectName:string }) {
    try {
      const imageUrl = `./projects/${projectName}/${fileName}`
      const response = await fetch(imageUrl)
      const blob = await response.blob()
      const url = URL.createObjectURL(blob);
      const image: RotatingImage = {
        url,
        id: i,
        alt: `${projectName}-${i}`,
        loaded: true,
        visible: i === 0 ? true : false
      }
      const width = ((i + 1) / state.imageCount) * 100;

      commit('setProgressBarWidth', width);

      return image;
    } catch (error) {
      console.error(`Error fetching image ${i}:`, error)
    }
  },
  autoplay({ commit }:{ commit: Function,} , payload: boolean){
    commit('toggleAnimation', payload);
  }
}

export const store = createStore<State>({
  state: {
    count: 0,
    isLoading: false,
    images:[],
    progress: 0,
    imageCount: 0,
    progressBarWidth: 0,
    autoplay: false,
    loaded: false,
    hidePreview: false
  },
  actions,
  mutations,
  getters
})

export function useStore () {
  return baseUseStore(key)
}
