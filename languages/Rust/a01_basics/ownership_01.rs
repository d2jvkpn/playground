#[allow(unused_variables)]
#[allow(unused_assignments)]

fn main() {
    let i = 5;
    let j = i;
    println!("{}", j);
    println!("{}", i);

    let v = vec![1, 2, 3, 4, 5];
    // let w = v;
    // println!("{:?}", w);
    // println!("{:?}", v);

    let foo = |v: Vec<i32>| -> Vec<i32> {
        println!("Vector used in foo");
        v
    };
    let z = foo(v);
    println!("{:?}", z);
    // println!("{:?}", v); // value borrowed here after move

    let mut x = vec!["Hello", "world"];
    let y = &x[0];
    x.push("foo");

    println!("{:?}", x);
}
