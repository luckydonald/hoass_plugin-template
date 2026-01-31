import { cleanup } from '@vue/test-utils';
import { afterEach, beforeAll } from 'vitest';

// Setup function that runs before all tests
beforeAll(() => {
  // Mock console methods to reduce noise in tests
  global.console.info = () => {};
});

// Cleanup after each test
afterEach(() => {
  cleanup();
});

// Mock Home Assistant custom elements
global.customElements = {
  define: () => {},
  get: () => undefined,
  whenDefined: async () => Promise.resolve(),
} as any;

// Mock window.customCards
(global as any).window = {
  customCards: [],
};
