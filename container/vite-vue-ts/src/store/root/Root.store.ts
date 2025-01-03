import { useItemsStore } from '../items';

export function useAppStore() {
  return {
    itemsStore: useItemsStore()
  }
};

export type RootStoreInterface = ReturnType<typeof useAppStore>;
