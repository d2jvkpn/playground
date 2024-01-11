use std::fmt::Debug;

#[derive(Debug, Clone, PartialEq, PartialOrd)]
pub struct Heap<T: Default> {
    count: usize,
    items: Vec<T>,
    comparator: fn(&T, &T) -> bool,
}

// min heap
impl<T: Default + Debug + Clone + PartialEq + PartialOrd> Heap<T> {
    pub fn new(comparator: fn(&T, &T) -> bool) -> Self {
        Self { count: 0, items: vec![T::default()], comparator }
    }

    pub fn new_with_cap(comparator: fn(&T, &T) -> bool, cap: usize) -> Self {
        let mut items: Vec<T> = Vec::with_capacity(cap + 1);
        items.push(T::default());
        Self { count: 0, items, comparator }
    }

    pub fn new_min(size: Option<usize>) -> Self {
        let mut items: Vec<T> = Vec::with_capacity(size.unwrap_or(0) + 1);
        items.push(T::default());
        Self { count: 0, items, comparator: |a, b| a < b }
    }

    pub fn min_from_slice(slice: &[T]) -> Self {
        let mut items: Vec<T> = Vec::with_capacity(slice.len() + 1);
        items.push(T::default());
        let mut heap = Self { count: 0, items, comparator: |a, b| a < b };
        slice.iter().for_each(|v| heap.push(v.clone()));
        heap
    }

    pub fn new_max(size: Option<usize>) -> Self {
        let mut items: Vec<T> = Vec::with_capacity(size.unwrap_or(0) + 1);
        items.push(T::default());
        Self { count: 0, items, comparator: |a, b| a > b }
    }

    pub fn max_from_slice(slice: &[T]) -> Self {
        let mut items: Vec<T> = Vec::with_capacity(slice.len() + 1);
        items.push(T::default());
        let mut heap = Self { count: 0, items, comparator: |a, b| a > b };
        slice.iter().for_each(|v| heap.push(v.clone()));
        heap
    }

    fn compare_by_idx(&self, i1: usize, i2: usize) -> Option<bool> {
        if i1 < 1 || i2 < 1 {
            return None;
        }
        if i1 > self.count || i2 > self.count {
            return None;
        }

        let value = (self.comparator)(&self.items[i1], &self.items[i2]);
        Some(value)
    }

    fn smallest_child_idx(&self, idx: usize) -> Option<usize> {
        if idx > self.count {
            return None;
        }

        let lidx = idx * 2;
        if lidx > self.count {
            return None;
        }

        if lidx + 1 > self.count {
            return Some(lidx);
        }

        match (self.comparator)(&self.items[lidx], &self.items[lidx + 1]) {
            true => Some(lidx),
            _ => Some(lidx + 1),
        }
    }

    pub fn size(&self) -> usize {
        self.count
    }

    pub fn print(&self) {
        println!("items: {:?}\n", &self.items[1..]);
    }

    pub fn push(&mut self, value: T) {
        self.count += 1;
        self.items.push(value);
        let mut idx = self.count;

        loop {
            let pdx = idx / 2;

            match self.compare_by_idx(idx, pdx) {
                None => break,
                Some(true) => self.items.swap(idx, pdx),
                _ => {}
            }

            idx = pdx;
        }
    }

    pub fn pop_v0(&mut self) -> Option<T> {
        if self.count == 0 {
            return None;
        }

        self.count -= 1;
        let option = Some(self.items.swap_remove(1));
        if self.count == 0 {
            return option;
        }

        let mut idx = 1;
        loop {
            let lidx = idx * 2;
            if lidx > self.count {
                break;
            }

            if lidx + 1 > self.count {
                if self.items[lidx] < self.items[idx] {
                    self.items.swap(idx, lidx);
                }
                break;
            }

            let left = &self.items[lidx];
            let right = &self.items[lidx + 1];
            let min = if left < right { lidx } else { lidx + 1 };
            self.items.swap(idx, min);
            idx = min;
        }

        option
    }

    pub fn pop(&mut self) -> Option<T> {
        if self.count == 0 {
            return None;
        }

        self.count -= 1;
        let option = Some(self.items.swap_remove(1));

        let mut idx = 1;
        while let Some(min_idx) = self.smallest_child_idx(idx) {
            if self.compare_by_idx(min_idx, idx) == Some(true) {
                self.items.swap(idx, min_idx);
            } else {
                break;
            }

            idx = min_idx;
        }

        option
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn t_vec() {
        let mut vec = vec!["foo", "bar", "baz", "qux"];

        assert_eq!(vec.swap_remove(1), "bar");
        assert_eq!(vec, ["foo", "qux", "baz"]);
        assert_eq!(vec.capacity(), 4);

        vec.push("xx");
        assert_eq!(vec.capacity(), 4);
    }

    #[test]
    fn t_heap() {
        let mut heap = Heap::min_from_slice(&vec![2, 8, 5, 3, 9, 1, 11]);
        heap.print();
        assert_eq!(heap.pop(), Some(1));
        assert_eq!(heap.pop(), Some(2));
        assert_eq!(heap.pop(), Some(3));
        assert_eq!(heap.pop(), Some(5));
        heap.print();
        assert_eq!(heap.pop(), Some(8));
        heap.print();
        assert_eq!(heap.pop(), Some(9));
        assert_eq!(heap.pop(), Some(11));
        assert_eq!(heap.pop(), None);
    }
}
