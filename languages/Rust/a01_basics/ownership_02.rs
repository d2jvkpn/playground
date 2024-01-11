use std::io;

fn main() {
    let input = String::new();
    let mut s = input;
    // call(s); //!! value borrowed here after move
    call(s.clone()); // ok
    call2(&s); // ok
    println!("Enter something:");
    io::stdin().read_line(&mut s).unwrap();
    println!("input: {}", s);
}

fn call(_s: String) {}

fn call2(_s: &String) {}
