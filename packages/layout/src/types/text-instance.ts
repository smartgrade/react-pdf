import * as P from 'smartgrade-react-pdf-primitives';

export type TextInstanceNode = {
  type: typeof P.TextInstance;
  props?: never;
  style?: never;
  box?: never;
  origin?: never;
  children?: never[];
  yogaNode?: never;
  value: string;
};

export type SafeTextInstanceNode = TextInstanceNode;
