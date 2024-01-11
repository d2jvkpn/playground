#![allow(dead_code)]

use std::{fmt::Display, ops::Deref};

#[derive(Debug)]
struct User<T: Display> {
    id: usize,
    entity: T,
}

impl<T: Display> User<T> {
    pub fn new(val: T) -> User<T> {
        User { id: 0, entity: val }
    }
}

impl<T: Display> Deref for User<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        return &self.entity;
    }
}

fn main() {
    let user = User::new("Rover".to_string());
    println!("debug: {:?}, display: {}", user, user.deref());
}
