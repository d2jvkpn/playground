fn main() {
    let limit = 500;
    let mut sum = 0;
    let is_even = |x: i32| x % 2 == 0;

    for i in 0.. {
        let isq = i * i;
        if isq > limit {
            break;
        }

        if is_even(isq) {
            println!("    add {}", isq);
            sum += isq
        }
    }

    println!("The sum is {}.", sum);

    let sum2 = (0..)
        .map(|x| x * x)
        // .take_while(|&x| x <= limit) or .take_while(|x| x <= &limit)
        .take_while(|&x| x <= limit)
        // .filter(|x| is_even(*x))
        .filter(|x: &i32| is_even(*x))
        .fold(0, |sum: i32, x: i32| sum + x);

    println!("The sum is {}.", sum2);
}
