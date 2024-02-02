use super::tree::{Node, Tree};
use std::{cell::RefCell, fmt::Debug, rc::Rc};

#[derive(Debug)]
struct Tree<T> {
    root: Child<T>,
    size: usize,
}

pub fn heap_from_slice<T: Debug + PartialEq + Clone>(node: Rc<RefCell<Node<T>>>, mut slice: &[T]) {
    if slice.is_empty() {
        return;
    }

    if node.borrow().left.is_none() {
        if slice.len() > 0 {
            let value = slice[0].clone();
            node.borrow_mut().left = Some(Node::new(value).into_rc());
            slice = &slice[1..];
        } else {
            return;
        }
    }

    if node.borrow().right.is_none() {
        if slice.len() > 0 {
            let value = slice[0].clone();
            node.borrow_mut().right = Some(Node::new(value).into_rc());
            slice = &slice[1..];
        } else {
            return;
        }
    }

    let (front, end) = slice.split_at((slice.len() + 1) / 2);
    // dbg!(&front);
    // dbg!(&end);

    heap_from_slice(node.clone().borrow_mut().left.as_ref().unwrap().clone(), front);
    heap_from_slice(node.clone().borrow_mut().right.as_ref().unwrap().clone(), end);
}

pub fn heap_tree_from_vec<T: Debug + PartialEq + Clone>(vec: &mut [T]) -> Tree<T> {
    assert!(vec.len() > 0);

    let tree = Tree::new(vec[0].clone());

    heap_from_slice(tree.header.clone(), &mut vec[1..]);
    tree
}

#[cfg(test)]
mod tests {
    use super::super::tree::*;

    // cargo test -- --show-output t_heap
    #[test]
    fn t_heap() {
        let mut vec = vec![1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
        let tree = Tree::new(vec[0]);
        super::heap_from_slice(tree.header.clone(), &mut vec[1..]);
        dbg!(&tree);
        //           1
        //     2     -     3
        //   4 - 5      10 - 11
        //  6-7  8-9  12-13 14-15

        assert_eq!(tree.header.borrow().count(), 15);

        println!(">>> inorder_v1 {:?}", inorder_v1(&Some(tree.header.clone())));
        println!(">>> inorder_v2 {:?}", inorder_v2(Some(tree.header.clone())));
        // println!(">>> inorder_v3 {:?}", inorder_v3(Some(tree.header.clone())));
        println!(">>> postorder {:?}", postorder(&Some(tree.header.clone())));
        println!(">>> preorder {:?}", preorder(&Some(tree.header.clone())));
    }
}
