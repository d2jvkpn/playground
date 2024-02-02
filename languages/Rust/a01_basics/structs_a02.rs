#![allow(dead_code)]
#![allow(unused_variables)]
#![allow(unused_imports)]

fn main() {
    // struct_stats();
    // enum_states();
    // union_states();
    // option_states();
    // array_states();
    // vector_states();
    // slices_states();
    // strings_states();

    // tuples_states();
    // pattern_matching();

    generics_states();
}

/// tuples
fn tuples_states() {
    let x = 3;
    let y = 4;
    let sp = sum_and_product(x, y);
    println!("{:?}", sp);
    println!("{0} + {1} = {2}, {0} * {1} = {3}", x, y, sp.0, sp.1);

    // destructuring
    let (a, b) = sp;
    println!("a = {}, b = {}", a, b);

    let sp2 = sum_and_product(4, 7);
    let combined = (sp, sp2);
    println!("last elem = {}", combined.1 .1);

    let ((c, d), (e, f)) = combined;
    println!("c = {}, d = {}, e = {}, f = {}", c, d, e, f);

    let foo = (true, 42.0, -1i8);
    println!("{:?}", foo);
}

fn sum_and_product(x: i32, y: i32) -> (i32, i32) {
    (x + y, x * y)
}

/// string
fn strings_states() {
    let s: &'static str = "hello there!";
    for c in s.chars() {
        // s.chars().rev();
        println!("{}", c)
    }

    if let Some(first_char) = s.chars().nth(0) {
        println!("frist letter is {}", first_char);
    }

    let mut letters = String::new();
    let mut a = 'a' as u8;
    while a <= ('z' as u8) {
        letters.push(a as char);
        letters.push_str(",");
        a += 1;
    }

    println!("{}", letters);
    // let u:&str = &letters;

    let z = letters + "abc";
    println!("{}", z);

    // let abc = String::from("hello, wrold");
    let mut abc = "hello, world".to_string();
    abc.remove(0);
    abc.push_str("!!!");
    println!("abc = {}", abc);
}

fn slices_states() {
    let mut data = [1, 2, 3, 4, 5];
    use_slice(&data[1..4]);

    use_slice2(&mut data[2..4]);
    println!("data = {:?}", data)
}

fn use_slice(slice: &[i32]) {
    println!("first elem = {}, len = {}", slice[0], slice.len());
}

fn use_slice2(slice: &mut [i32]) {
    slice[0] = 99;
}

/// vectors
fn vector_states() {
    let mut a = Vec::new();
    a.push(1);
    a.push(2);
    a.push(3);
    a.push(4);

    println!("a = {:?}!", a);

    a.push(44);
    println!("a = {:?}!", a);

    // usize isize
    println!("a[0] = {}", a[0]);

    // let idx:usize = 111;
    // a[idx] = 321;
    // println!("a[0] = {}", a[idx]);
    println!("a[10] = {:?}", a.get(10));

    match a.get(10) {
        Some(x) => println!("a[10] = {}", x),
        None => println!("error, no such element"),
    }

    let last_elem = a.pop();
    println!("last elem is {:?}, a = {:?}", last_elem, a);

    while let Some(e) = a.pop() {
        println!("{}", e);
    }
}

/// Array
fn array_states() {
    let mut arr: [i32; 5] = [1, 2, 3, 4, 5];
    println!("arr has {} elements, first is {}", arr.len(), arr[0]);
    println!("arr = {:?}", arr);

    arr[0] = 321;
    println!("arr[0] = {}", arr[0]);

    if arr != [1, 2, 3, 4, 5] {
        println!("does not match");
    }

    let arr2 = [1; 10];
    for i in 0..arr2.len() {
        println!("arr2[{}] = {}", i, arr2[i]);
    }
    println!("arr2 took up {} bytes", std::mem::size_of_val(&arr2));

    // mutliply dimension array
    let mtx: [[f32; 3]; 2] = [[1.0, 0.0, 0.0], [0.0, 2.0, 0.0]];
    println!("{:?}", mtx);
    for i in 0..mtx.len() {
        for j in 0..mtx[i].len() {
            println!("mtx[{}][{}] = {}", i, j, mtx[i][j]);
        }
    }
    println!("mtx took up {} bytes", std::mem::size_of_val(&mtx));
}

/// option
fn option_states() {
    // Option<T>
    let x = 3.0;
    let mut y = 2.0;

    // Some(z) or None
    let result: Option<f64> = if y != 0.0 { Some(x / y) } else { None };
    println!("{}/{} = {:?}", x, y, result);
    if let Some(z) = result {
        println!("z = {}", z)
    } else {
        println!("result is None")
    };
    match result {
        Some(z) => println!("{}/{} = {}", x, y, z),
        None => println!("can't divide {} by {}", x, y),
    }

    y = 0.0;
    let result: Option<f64> = if y != 0.0 { Some(x / y) } else { None };
    println!("{}/{} = {:?}", x, y, result);
    if let Some(z) = result {
        println!("z = {}", z)
    } else {
        println!("result is None")
    };
    match result {
        Some(z) => println!("{}/{} = {}", x, y, z),
        None => println!("can't divide {} by {}", x, y),
    }
}

/// union
union IntOrFloat {
    i: i32,
    f: f32,
}

fn union_states() {
    let iof = IntOrFloat { i: 123 };
    let value = unsafe { iof.i };

    process_value(iof);
    process_value(IntOrFloat { f: 1.23 });
}

fn process_value(iof: IntOrFloat) {
    unsafe {
        match iof {
            IntOrFloat { i: 42 } => println!("meaning of life"),
            IntOrFloat { f } => println!("f32 = {}", f),
        }
    }
}

/// enum
fn enum_states() {
    // let c:Color = Color::Red;
    // let c:Color = Color::Rgb(1,2,3);
    let c: Color = Color::Cmyk { cyan: 0, magenta: 128, yellow: 0, black: 255 };

    match c {
        Color::Red => println!(">>> r"),
        Color::Green => println!(">>> g"),
        Color::Blue => println!(">>> b"),
        Color::Rgb(0, 0, 0) => println!(">>> black"),
        Color::Cmyk { cyan: _, magenta: _, yellow: _, black: 255 } => println!("!!! black"), // Color::Cmyk {black: 255,..}
        Color::Rgb(r, g, b) => println!("rgb({}, {}, {})", r, g, b),
        // _ => println!("some other color")
        _ => (),
    }
}

enum Color {
    Red,
    Green,
    Blue,
    Rgb(u8, u8, u8),
    Cmyk { cyan: u8, magenta: u8, yellow: u8, black: u8 },
}

/// struct
fn struct_stats() {
    let p = Point { x: 3.0, y: 4.0 };
    println!("point p is at ({}, {})", p.x, p.y);

    let p2 = Point { x: 5.0, y: 10.0 };
    let myline = Line { start: p, end: p2 };
}

struct Point {
    x: f64,
    y: f64,
}

struct Line {
    start: Point,
    end: Point,
}

pub fn generics_states() {
    struct Point<T> {
        x: T,
        y: T,
    }

    struct Line<T> {
        start: Point<T>,
        end: Point<T>,
    }

    let a: Point<f64> = Point { x: 0.0, y: 4f64 };
    let b: Point<f64> = Point { x: 1.2, y: 3.4 };

    let line = Line { start: a, end: b };
    println!("line.start.y = {}", line.start.y);
}

pub fn pattern_matching() {
    for x in 0..13 {
        println!("{}: I have {} oranges.", x, how_many(x));
    }

    let point = (3, 4);
    match point {
        (0, 0) => println!("origin"),
        (0, y) => println!("x axis, y = {}", y),
        (x, 0) => println!("y axis, x = {}", x),
        (x, y) => println!("x = {}, y = {}", x, y),
    }
}

fn how_many(x: i32) -> &'static str {
    match x {
        0 => "no",
        1 | 2 => "one or two",
        9..=11 => "lots of",
        _ if (x % 2 == 0) => "some",
        _ => "a few",
    }
}
