use rand::Rng;
use std::cmp::Ordering;
use std::io;

fn main() {
    let target = rand::thread_rng().gen_range(1..=100);
    println!("Guess the number: {}", target);

    loop {
        println!(">>> Please enter your hunch (between 1 and 100):");
        let mut hunch = String::new();
        io::stdin()
            .read_line(&mut hunch)
            .ok()
            .expect("    Failed to read line!");

        // let hunch: u32 = hunch.trim().parse().ok().expect("invalid number!");
        let hunch: u32 = match hunch.trim().parse() {
            Ok(num) => num,
            Err(err) => {
                println!("    {}!", err);
                continue;
            }
        };
        // if hunch < 1 || hunch > 100 { println!("...!"); continue; }
        match hunch {
            1..=100 => (),
            _ => {
                println!("    the secret number will be between 1 and 100!");
                continue;
            }
        }

        match hunch.cmp(&target) {
            Ordering::Less => println!("    very small!"),
            Ordering::Greater => println!("    very big!"),
            Ordering::Equal => {
                println!("    You won, bye!");
                break;
            }
        }
    }
}
