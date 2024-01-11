use rand::distributions::Alphanumeric;
use rand::{thread_rng, Rng};

fn main() {
    let mut rng = thread_rng();
    let i: i32 = rng.gen();
    println!("{}", i);

    let j: f64 = rng.gen();
    println!("{}", j);

    println!("bounded int: {}", rng.gen_range(0..100));
    println!("bounded float: {}", rng.gen_range(0.0..100.0));

    let rand_str: String = rng
        .sample_iter(&Alphanumeric)
        .take(30)
        .map(char::from)
        .collect();

    println!("random string {}", rand_str);

    let numbers = [1, 2, 3, 4, 5];
    println!(">>> 1: {:?}", &numbers[1..4]); // slice

    let mut arr = [0; 3];
    arr[0..3].clone_from_slice(&numbers[0..3]); // or arr2.clone_from_slice
    println!(">>> 2: {:?}", arr);

    let mut colors = vec!["red", "green", "blue", "pink"];
    println!(">>> 3: {:?}", colors);

    update_colors(&mut colors);
    println!(">>> 4: {:?}", colors);

    update_slice(&mut colors[2..4]);
    println!(">>> 5: {:?}", colors);

    for (idx, value) in colors.iter().enumerate() {
        println!("~~~ colors[{}] = \"{}\"", idx, value);
    }
}

fn update_colors(list: &mut Vec<&str>) {
    list[0] = "yellow";
    list[1] = "orange";
    list.push("red");
}

fn update_slice(slice: &mut [&str]) {
    slice[0] = "xx1";
    slice[1] = "xx2";
    // slice.push("xx3"); // compile: method not found in `&mut [&str]`
    // slice[2] = "xx3"; // thread 'main' panicked at 'index out of bounds
}
