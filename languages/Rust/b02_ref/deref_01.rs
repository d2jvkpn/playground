#![allow(dead_code)]

use std::ops::Deref;

#[derive(Debug)]
struct Admin {
    name: String,
}

impl Admin {
    pub fn new(name: &str) -> Self {
        Self { name: name.into() }
    }

    pub fn say(&self) {
        println!("I'm an admin, and my name is {:?}.", self.name);
    }
}

#[derive(Debug)]
struct User {
    id: usize,
    admin: Admin,
}

impl User {
    pub fn new(name: &str) -> Self {
        Self { id: 0, admin: Admin::new(name) }
    }
}

impl Deref for User {
    type Target = Admin;

    fn deref(&self) -> &Self::Target {
        return &self.admin;
    }
}

fn main() {
    let user = User::new("Rover");

    println!("{:?}", user);
    user.say();
    user.say();
}
