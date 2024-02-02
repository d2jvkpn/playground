#[derive(Debug, Clone)]
struct Queue<T> {
    cursor: usize,
    data: Vec<T>,
}

impl<T: Clone> Queue<T> {
    pub fn new(size: usize) -> Self {
        Self { cursor: 0, data: Vec::with_capacity(size) }
    }

    pub fn info(&self) -> (usize, usize, usize) {
        (self.cursor, self.data.len(), self.data.capacity())
    }

    pub fn check(&mut self) -> bool {
        if self.cursor > self.data.capacity() / 2 {
            let mut vec = Vec::with_capacity(self.data.capacity());
            vec.extend_from_slice(&self.data[self.cursor..]);
            // self.data = self.data[self.cursor..].to_vec();
            self.data = vec;
            self.cursor = 0;
            true
        } else {
            false
        }
    }

    pub fn push(&mut self, item: T) -> &mut Self {
        self.data.push(item);
        self.check();
        self
    }

    pub fn pop(&mut self) -> Option<T> {
        if self.data.is_empty() {
            return None;
        }

        let val = self.data[self.cursor].clone();
        self.cursor += 1;
        self.check();

        Some(val)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    // cargo test -- --show-output queue
    #[test]
    fn t_queue() {
        let mut queue: Queue<usize> = super::Queue::new(4);
        assert_eq!(queue.info(), (0, 0, 4));

        queue.push(1).push(2).push(3);
        assert_eq!(queue.pop(), Some(1));
        assert_eq!(queue.pop(), Some(2));
        assert_eq!(queue.info(), (2, 3, 4));

        queue.push(4);
        assert_eq!(queue.pop(), Some(3));
        assert_eq!(queue.info(), (0, 1, 4));
    }
}
