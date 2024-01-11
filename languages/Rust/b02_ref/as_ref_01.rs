#![allow(dead_code)]

use std::borrow::Cow;

fn main() {
    call_01("x1");
    let x2 = String::from("x2");
    call_01(x2);
}

fn call_01<S: AsRef<str>>(s: S) {
    let val = s.as_ref();
    println!("val: {val}");
}
