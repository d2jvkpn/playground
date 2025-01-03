<script setup lang="ts">
  import { reactive } from 'vue';

  import type { ItemInterface } from '@/models';
  import ItemsListComponent from '@/components/items/ItemsList.component.vue';
  import ObjectsListComponent from '@/components/items/ObjectsList.component.vue';

  const env = import.meta.env.VITE_ENV
  const base = import.meta.env.VITE_BASE;
  const api_url = import.meta.env.VITE_API_URL
  const settings = `env=${env}, base=${base}, api_url=${api_url}`;

  console.log(`==> ${window.location}, ${settings}`);

  const items: ItemInterface[] = [
    { id: 1, name: 'Item 1', selected: false },
    { id: 2, name: 'Item 2', selected: false },
    { id: 3, name: 'Item 3', selected: false },
  ];

  //
  const list = reactive([
   { id: 5, name: 'item 5', selected: false },
   { id: 6, name: 'item 6', selected: false },
   { id: 7, name: 'item 7', selected: false },
  ]);

  //
  const objects = reactive([
   { id: 1, name: 'object 1', selected: false },
   { id: 2, name: 'object 2', selected: false },
   { id: 3, name: 'object 3', selected: false },
  ]);

  const onSelectObject = (id: number) => {
    const item = objects.find(o => o.id === id);

    if (!item) {
      console.warn(`!!! onSelectObject: could not find item with id: ${id}`);
      return;
    }

    item.selected = !item.selected;
    console.log(`--> onSelectObject: ${item.id}, ${item.selected}`);
  };
</script>

<template>
<main>
  <div class="home">
    <ItemsListComponent :items="items"/>

    <ItemsListComponent :items="list"/>

    <ObjectsListComponent :objects="objects" @onSelectObject="onSelectObject"/>
  </div>
</main>
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
