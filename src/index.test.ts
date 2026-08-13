import { expect, test } from 'vitest';
import { placeholder } from './index.js';

test('placeholder returns a string', () => {
  expect(placeholder()).toBe('replace-me');
});
