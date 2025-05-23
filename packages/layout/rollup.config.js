import typescript from '@rollup/plugin-typescript';
import { dts } from 'rollup-plugin-dts';
import del from 'rollup-plugin-delete';

import pkg from './package.json' with { type: 'json' };

const config = [
  {
    input: 'src/index.ts',
    output: { format: 'es', dir: 'lib' },
    external: Object.keys(pkg.dependencies).concat(/smartgrade-react-pdf-.*?/),
    plugins: [typescript(), del({ targets: 'lib' })],
  },
  {
    input: './lib/types/index.d.ts',
    output: [{ file: 'lib/index.d.ts', format: 'es' }],
    plugins: [dts(), del({ targets: 'lib/types', hook: 'buildEnd' })],
  },
];

export default config;
