use std::io;

fn main() {
    println!("Guess the number, Please input your guess:");
    let mut guess = String::new();

    io::stdin()
        .read_line(&mut guess)
        .expect("Failed to read line");

    // let a = 10;
    // let b = 9;
    // println!("{:?}", a.cmp(&b));

    // let guess = guess.trim().parse::<i64>().unwrap();

    let guess: i64 = guess.trim().parse().unwrap();
    println!("You guessed: {}", guess);
}
