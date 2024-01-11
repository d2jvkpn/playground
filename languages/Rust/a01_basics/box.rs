use std::any;

fn type_name<T>(_: &T) -> &str {
    any::type_name::<T>()
}

fn main() {
    let mut val = Box::new(42);
    println!("val = {}, {}", val, type_name(&val));

    let a1 = *val;
    println!("a1 = {}, {}", a1, type_name(&a1));

    *val = 0;
    println!("val = {}, a = {}", val, a1); // 0, 42
}
