<script setup lang="ts">
// expose a property called items with a default value of a blank array
// defineProps<{ items: any[] }>()
// explicetely using any[] as we'll replace this with an interface in the next chapters

// import type { ItemInterface } from '@models/items/Item.interface.ts';
import type { ItemInterface } from '@/models';

import ItemComponent from './children/Item.component.vue';
import Loader from '@/components/shared/Loader.component.vue';

defineProps<{
  items: ItemInterface[]
  loading: boolean
}>();

const handleClick = (item: ItemInterface) => {
  item.selected = !item.selected;
  console.log(`--> handleItemClick: ${item.id}, ${item.selected}`);
};
</script>

<!--template>
<div>
  <h3>Items - loading: {{loading}}:</h3>

  <Loader v-show="loading" />
  <ul v-show="!loading"> </ul>

  <ul>
    <li v-for="(item, _index) in items" :key="item.id" @click="handleClick(item)">
      {{item.name}} [{{item.selected}}]
    </li>
  </ul>
</div>
</template-->

<template>
<div>
  <h3>Items: loading={{loading}}</h3>

  <Loader v-show="loading" />
  <ul v-show="!loading"> </ul>

  <ul>
    <ItemComponent v-for="(item, index) in items"
      :key="item.id"
      :model="item"
      @selectItem="handleClick(item)" />
  </ul>
</div>
</template>

<style>
ul {
  padding-inline-start: 0;
  margin-block-start: 0;
  margin-block-end: 0;
  margin-inline-start: 0px;
  margin-inline-end: 0px;
  padding-inline-start: 0px;
}
</style>
