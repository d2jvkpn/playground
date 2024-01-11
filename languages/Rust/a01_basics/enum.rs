use std::any;

fn type_name<T>(_: &T) -> String {
    format!("{}", any::type_name::<T>())
}

fn main() {
    // Option
    let a1 = Some(42);
    println!("a1: {}, {:?}, {}, {}", type_name(&a1), a1, a1.is_some(), a1.is_none());
    // Option<i32>, Some(42), true, false

    let mut a2 = a1.as_ref();
    println!("a2: {}, {:?}", type_name(&a2), a2); // Option<&i32>, Some(42)

    let a3 = a2.take();
    println!("a1: {:?}, a2: {:?}, a3: {:?}", a1, a2, a3); // Some(42), None, Some(42)

    // Result
    let b1: Result<i32, String> = Ok(42);
    let b2: Result<i32, String> = Err("world".to_string());
    println!("b1: {}, {:?}, {}, {}", type_name(&b1), b1, b1.is_ok(), b1.is_err());
    // Result<i32, String>, Ok(42), true, false

    let c1 = b1.ok();
    let c2 = b2.ok();
    println!("c1: {}, {:?}", type_name(&c1), c1); // Option<32>, Some(i32)
    println!("c2: {}, {:?}", type_name(&c2), c2); // Option<32>, None

    let a1 = Some(42);
    let a2 = None;
    let b1: Result<i32, String> = a1.ok_or("Not a Some".to_string());
    let b2: Result<i32, String> = a2.ok_or("Not a Some".to_string());

    println!("b1: {}, {:?}", type_name(&b1), b1); // Ok(42)
    println!("b2: {}, {:?}", type_name(&b2), b2); // Err("Not a Some")

    let b3 = b2.or(b1);
    println!("b3: {}, {:?}", type_name(&b3), b3); // Ok(42)

    let x: Option<i32> = Some(32);
    if let Some(y) = x {
        println!("{:?}", y);
    };
}
