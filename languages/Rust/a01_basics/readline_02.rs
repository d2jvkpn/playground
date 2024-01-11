use std::io;

fn main() {
    let mut input = String::new();
    println!("Enter something:");
    io::stdin().read_line(&mut input).unwrap();
    println!("input: {}", input);

    let input = String::new();
    let mut s = input; // s take ownership of input as an mutable variable
    println!("Enter something:");
    io::stdin().read_line(&mut s).unwrap();
    println!("input: {}", s);
}
