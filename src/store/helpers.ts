export const addZeros = (i:number): string => {

  if (i >= 0 && i < 10) {
    return `00${i}`;
  }

  if (i >= 10) {
    return `0${i}`;
  }
  return ''
}
