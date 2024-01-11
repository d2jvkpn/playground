fn byte_length(string: &str) -> usize {
    println!("{:?}", string.bytes()); // [240, 159, 166, 128]
    string.bytes().len()
}

fn main() {
    let string = "🦀";
    let length = byte_length(string);

    println!("{}", string.len());
    println!("Bytes in \"{}\": {}", string, length);
}
