import { createRouter, createWebHistory } from 'vue-router'
import ModelViewer from '../components/modelViewer/ModelViewer.vue';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: "/",
      name: "home",
      component: ModelViewer,
    },
  ],
});

export default router
