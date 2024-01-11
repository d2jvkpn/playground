#![allow(dead_code)]
#![allow(unused_variables)]
#![allow(unused_imports)]
mod methods;

fn main() {
    // function_status();
    // methods::methods_states();
    // closures_states();
    hof();
}

/// high order functions
fn hof() {
    let limit = 500;
    let mut sum = 0;
    let is_even = |x: i32| x%2 == 0;

    for i in 0.. {
        let isq = i*i;
        if isq > limit {
            break;
        } else if is_even(isq) {
            println!("isq = {}", isq);
            sum += isq;
        }
    }

    println!("loop sum = {}", sum);

    let sum2 = (0..).
        map(|x| x*x).
        take_while(|&x| x <= limit).
        filter(|x| is_even(*x)).
        fold(0, |sum, x| sum+x);

    println!("high order sum2 = {}", sum2);
}

/// closure
fn say_hello() {
    println!("hello");
}

fn closures_states() {
    let func = say_hello;
    func();

    let plus_one = |x: i32| -> i32 { x+1 };
    println!("{} + 1 = {}", 3, plus_one(3));

    let plus_two = |x| {
        let mut z = x;
        z += 2;
        z
    };

    println!("{} + 2 = {}", 3, plus_two(3));
    println!("{} + 2 = {}", 3.6, plus_two(3));

    let mut two = 2;
    let borrow_two = &mut two;
    let plus_three = |x: &mut i32| *x += 3;
    let mut f = 12;
    plus_three(&mut f);
    println!("f = {}", f);
}

/// functions
fn print_value(x: i32) {
    println!("{}", x);
}

fn increase(x: &mut i32) {
    *x += 1;
}

fn product(x: i32, y: i32) -> i32 {
    x*y
}

fn function_status() {
    print_value(33);
    
    let mut z = 1;
    increase(&mut z);
    println!("z = {}", z);

    let a = 3;
    let b = 4;
    println!("{} * {} = {}", a, b, product(a, b));
}
