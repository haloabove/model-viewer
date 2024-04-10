import { DefineComponent } from 'vue';

declare module '@dpc-sdp/ripple-ui-core/vue' {
  export const RplImage: DefineComponent;
  export const RplButton: DefineComponent;
}

declare module '@dpc-sdp/ripple-ui-core/vue/components/RplImage' {
  const RplImage: DefineComponent;
  export default RplImage;
}

declare module '@dpc-sdp/ripple-ui-core/vue/components/RplButton' {
  const RplButton: DefineComponent;
  export default RplButton;
}
declare module '@dpc-sdp/ripple-ui-core/vue/components/RplSpinner' {
  const RplSpinner: DefineComponent;
  export default RplSpinner;
}

declare module '@dpc-sdp/ripple-ui-core/vue/components/RplIcon' {
  const RplIcon: DefineComponent;
  export default RplIcon;
}
