use rand::Rng;

use std::{
    cmp::Ordering,
    io::{self, Write},
};

fn main() {
    let (mut low, mut high) = (1, 100);
    let target = rand::thread_rng().gen_range(low..=high);
    let mut input = String::new();
    let mut hunch: u32;

    println!("-------- Guess the number: {} --------", target);

    loop {
        eprint!("==> Please enter your hunch ({}..={}): ", low, high);

        io::stdout().flush().unwrap();

        input.clear();
        io::stdin().read_line(&mut input).ok().expect("failed to read line!");

        // let hunch: u32 = hunch.trim().parse().ok().expect("invalid number!");
        match input.trim().parse() {
            Ok(v) => hunch = v,
            Err(e) => {
                eprintln!("!!! {e}: {input:?}");
                continue;
            }
        };

        /*
        if hunch < 1 || hunch > 100 {
            println!("...!");
            continue;
        }
        */
        match hunch {
            1..=100 => (),
            _ => {
                eprintln!("!!! the secret number will be between {} and {}!", low, high);
                continue;
            }
        }

        match hunch.cmp(&target) {
            Ordering::Less => {
                eprintln!("~~~ very small!");
                low = hunch;
            }
            Ordering::Greater => {
                eprintln!("~~~ very big!");
                high = hunch;
            }
            Ordering::Equal => {
                eprintln!("<== You win, bye!");
                break;
            }
        }
    }
}
