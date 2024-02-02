#[allow(unused_variables)]
#[allow(unused_assignments)]
#[allow(dead_code)]
#[derive(Debug)]

struct Person {
    name: String,
}

#[derive(Debug)]
struct Dog<'l> {
    name: String,
    owner: &'l Person,
}

impl Person {
    // fn get_name(&self) -> &String {
    fn get_name<'l>(&'l self) -> &'l String {
        &self.name
    }
}

fn main() {
    println!("{}", get_str());

    let mut p1 = Person {
        name: String::from("John"),
    };
    let d1 = Dog {
        name: String::from("Max"),
        owner: &p1,
    };
    println!("{:?}", p1);
    println!("{:?}", d1);

    /*
    let mut a: &String;
    {
        let p2 = Person {
            name: String::from("Mary"),
        };
        // a = p2.get_name();
        a = p1.get_name();
    }
    println!("{}", a);
    */

    p1.name = String::from("xx");
    println!("{:?}", p1);
    println!("{:?}", d1);
}

fn get_str() -> &'static str {
    "Hello"
}
