<script setup lang="ts">
  // expose a property called items with a default value of a blank array
  // defineProps<{ items: any[] }>()
  // explicetely using any[] as we'll replace this with an interface in the next chapters

  // import type { ItemInterface } from '@models/items/Item.interface.ts';
  import type { ItemInterface } from '@/models';

  defineProps<{ objects: ItemInterface[] }>();

  const emit = defineEmits<{
    (e: 'onSelectObject', id: number): ItemInterface
  }>();

  const handleClick = (item: ItemInterface) => {
    emit('onSelectObject', item.id);
  };
</script>

<template>
  <div>
    <h3>Objects:</h3>
    <ul>
      <li v-for="(item, _index) in objects" :key="item.id" @click="handleClick(item)">
        {{item.name}} [{{item.selected}}]
      </li>
    </ul>
  </div>
</template>
