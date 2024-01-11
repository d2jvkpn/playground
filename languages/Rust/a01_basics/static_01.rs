static B: [u8; 5] = [1, 2, 3, 4, 5];
static C: [u8; 2] = [6, 7];

fn main() {
    let a = 42;
    let a2 = 24;
    let b = &B;
    let c = &C;
    println!("a: {:p}, a2: {:p}, b: {:p}, c: {:p}", &a, &a2, b, c);
}
