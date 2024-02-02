use std::cell::RefCell;

fn main() {
    let s = RefCell::new(String::from("kk"));

    // y1
    {
        let mut y1 = s.borrow_mut();
        y1.push_str("_y1");
    }

    // y2
    let mut y2 = s.borrow_mut();
    y2.push_str("_y2");
    drop(y2);

    // y3
    s.borrow_mut().push_str("_y3");

    println!("{:?}, {}", s, s.borrow());
    println!("{}", s.into_inner());
}
