#![allow(dead_code)]
#![allow(unused_variables)]
#![allow(unused_imports)]
use std::mem;

const MEANING_OF_LIFE: u8 = 42;

static mut Z: i32 = 123;

fn main() {
    stack_and_heap();
}

fn _03_scope() {
    let a = 100;

    {
        let a = 99;
        println!("a = {}", a);
    }

    println!("a = {}", a);

    println!("meaning of life if {}", MEANING_OF_LIFE);

    unsafe {
        Z = 456;
        println!("Z = {}", Z)
    }
}

fn _02_arithmetic() {
    // arithmetic
    let mut a = 2 + 3 * 4;
    println!("a = {}", a);

    a += 1;
    a = a + 1;
    println!("remainder of {} / {} = {}, ", a, 3, a % 3);

    let a_cubed = i32::pow(a, 3);
    println!("{} cubed is {}", a, a_cubed);

    let b = 2.5;
    println!(
        "{}^3 = {}, {}^pi = {}",
        b,
        f64::powi(b, 3),
        b,
        f64::powf(b, std::f64::consts::PI)
    );

    // bitwise: | OR, & AND, ^ XOR, ! NOR
    println!("1 | 2 = {}", 1 | 2);
    println!("2^10 = {}", 1 << 10);

    // logical: >, <, ==, >=, <=
    println!("pi < 4 = {}", std::f64::consts::PI < 4.0);
}

fn _01_data_types() {
    println!("Hello, world!");

    let a: u8 = 32; // immutable
    println!("a = {}", a);

    // a = 100;

    let mut b: i8 = 10; // mutable
    println!("b = {}", b);
    b = 42;
    println!("b = {}", b); // 1 byte

    let mut c: i32 = 123456789; // 32 bit signed i32;
    println!("c = {}, size = {} bytes", c, mem::size_of_val(&c)); // 4 bytes
    c = -10;
    println!("c = {}, size = {} bytes", c, mem::size_of_val(&c)); // 4 bytes

    // i8 u8 i16 u16 i32 u32 i64 u64

    let z: isize = 123;
    let s = mem::size_of_val(&z);
    println!("size of a isize = {}, {}-bit OS", s, s * 8); // 8 bytes

    let d: char = 'x';
    println!("d = {}, size = {} bytes", d, mem::size_of_val(&d));

    let e = 2.5; // f64 double-precision
    println!("e = {}, size = {} bytes", e, mem::size_of_val(&e)); // 8 bytes

    let g = false;
    println!("g = {}, size = {} bytes", g, mem::size_of_val(&g)); // 1 bytes
}

struct Point {
    x: f64,
    y: f64,
    z: i8,
}

fn origin() -> Point {
    Point {
        x: 0.0,
        y: 0.0,
        z: 0,
    }
}

pub fn stack_and_heap() {
    /*
    // stack, access fast, but limited size
    let x = 5;
    let y = 6;
    println!("x = {}, y = {}, x is {} bytes", x, y, mem::size_of_val(&x));

    // heap, reference or pointer
    let x2 = Box::new(5); // an address point to a variable which contains 5
    let y2 = Box::new(6); //
    println!("x2 = {}, y2 = {}, x2 is {} bytes", x2, y2, mem::size_of_val(&x2));
    */

    let p1 = origin(); // stack
    let p2 = Box::new(origin()); // heap
                                 // let p3 = *p2;
    println!("p1 takes up {} bytes", mem::size_of_val(&p1));
    println!("p2 takes up {} bytes", mem::size_of_val(&p2));
}
