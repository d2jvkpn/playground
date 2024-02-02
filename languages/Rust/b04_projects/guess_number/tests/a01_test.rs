// use std::iter;

// use rand::Rng;
use rand::{distributions::Alphanumeric, prelude::*};

#[test]
fn t_rand() {
    // let mut rng = rand::thread_rng();
    let mut rng = thread_rng();
    let a: i32 = rng.gen();
    println!("a = {}", a);

    let x: i32 = rng.gen_range(0..=100); // (0..101)
    println!("x = {}", x);

    println!("x = {}", rng.gen_range(0.0..10.0));

    /*
    let chars: String = iter::repeat(())
        .map(|()| rng.sample(Alphanumeric))
        .map(char::from)
        .take(30)
        .collect();
    */

    let chars: String = rng.sample_iter(&Alphanumeric).map(char::from).take(32).collect();

    println!("chars = {}", chars);
}
