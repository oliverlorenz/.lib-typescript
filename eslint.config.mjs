import typescriptEslint from "@typescript-eslint/eslint-plugin";
import globals from "globals";
import tsParser from "@typescript-eslint/parser";
import path from "node:path";
import { fileURLToPath } from "node:url";
import js from "@eslint/js";
import { FlatCompat } from "@eslint/eslintrc";
import checkFileEslint from 'eslint-plugin-check-file';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const compat = new FlatCompat({
    baseDirectory: __dirname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all
});

export default [
  {
    ignores: ['**/proto-types/**/*.ts', '**/*.test.ts', '**/test.ts'],
  },
  ...compat.extends('prettier'),
  {
    plugins: {
      '@typescript-eslint': typescriptEslint,
      'check-file': checkFileEslint,
    },

    languageOptions: {
      globals: {
        ...globals.node,
        ...globals.jest,
      },

      parser: tsParser,
      ecmaVersion: 5,
      sourceType: 'module',

      parserOptions: {
        project: 'tsconfig.json',
      },
    },

    rules: {
      '@typescript-eslint/interface-name-prefix': 'off',
      '@typescript-eslint/explicit-function-return-type': 'error',
      '@typescript-eslint/no-explicit-any': 'off',
      '@typescript-eslint/no-non-null-assertion': 'error',
      '@typescript-eslint/no-floating-promises': 'error',

      '@typescript-eslint/explicit-member-accessibility': [
        'error',
        {
          accessibility: 'explicit',

          overrides: {
            constructors: 'no-public',
          },
        },
      ],

      'no-unused-vars': 'off',

      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          argsIgnorePattern: '^_',
          varsIgnorePattern: '^_',
        },
      ],
      'check-file/filename-naming-convention': [
        'error',
        {
          'src/**/*.ts': 'KEBAB_CASE',
        },
        {
          ignoreMiddleExtensions: true, // Erlaubt .test.ts oder .spec.ts
        },
      ],
      '@typescript-eslint/naming-convention': [
        'error',
        {
          // Wir wählen gezielt Klassen aus
          selector: 'class',
          format: ['PascalCase'],
        },
        {
          // Oft sinnvoll: Auch Interfaces und Enums in PascalCase
          selector: ['interface', 'typeAlias', 'enum'],
          format: ['PascalCase'],
        },
        {
          // Variablen bleiben meistens camelCase
          selector: 'variable',
          format: ['camelCase', 'UPPER_CASE'],
        },
      ],
    },
  },
  {
    files: ['**/*.test.ts'],
    rules: {
      '@typescript-eslint/no-non-null-assertion': 'off',
    },
  },
];
