fn main() {
    let mut v1 = vec![10, 11];
    let vpt = &v1[1];

    v1.push(42);

    println!("{}", *vpt);
}
