import type { RotatingImage } from '@/types/rotatingImage.d.ts';

export interface State {
  count: number,
  isLoading: boolean,
  images: RotatingImage[];
  imageCount: number;
  progressBarWidth: number;
  autoplay: boolean;
  hidePreview: boolean;
  loaded: boolean;
  progress: number;
}
