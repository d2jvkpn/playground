#[allow(unused_variables)]
#[allow(unused_assignments)]
#[allow(dead_code)]
use crate::Colors::Red;
use crate::Person::Name;

fn main() {
    let color = Colors::Red;
    println!(">>> 1: {:?}", color);

    let x = Red;
    println!(">>> 2: {:?}", x);

    let person = Name(String::from("Alex"));
    println!("{:?}", person);

    let emp1 = Employee {
        name: String::from("Evol"),
        surname: String::from("Mason"),
        age: 30,
    };

    println!("{:?}", emp1);
    println!("{}", emp1.say());

    Employee::xx();

    let emp2 = Employee::new();
    println!("{}", emp2.say());
}

#[derive(Debug)]
enum Colors {
    Red,
    Green,
    Blue,
}

#[derive(Debug)]
enum Person {
    Name(String),
    Surname(String),
    Age(u32),
}

#[derive(Debug)]
struct Employee {
    name: String,
    surname: String,
    age: u32,
}

impl Employee {
    fn say(&self) -> String {
        format!("I'm {} {}.", self.name, self.surname)
    }

    fn xx() {
        println!("~~~ xx");
    }

    fn new() -> Employee {
        Employee {
            name: String::from("Jone"),
            surname: String::from("Doe"),
            age: 0,
        }
    }
}
