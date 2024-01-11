fn main() {
    let mut vec = vec![1, 2, 3, 4, 5, 6, 7];
    println!("{:?}", vec);
    println!("{:?}", &vec[1..3]);

    let slice = &mut vec[1..3];
    call(slice);
    println!("{:?}", slice);
    println!("{:?}", vec);
}

fn call(slice: &mut [i64]) {
    // slice.push(42); // method not found in `&mut [i64]`
    slice[0] = 42;
}
