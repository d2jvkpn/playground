#![allow(dead_code)]

fn main() {
    let foo = (true, 42.0, -1i8);
    println!("{:?}", foo);

    let meaning = (42,);
    println!("{:?}", meaning);

    taits_states();
}

trait Animal {
    fn create(name: &'static str) -> Self; // !self

    fn name(&self) -> &'static str;
    fn talk(&self) { // default implement
        println!("{} cannot talk", self.name());
    }
}

struct Human {
    name: &'static str,
}

impl Animal for Human {
    fn create(name: &'static str) -> Human {
        Human{name: name}
    }

    fn name(&self) -> &'static str {
        self.name
    }
    fn talk(&self) {
        println!("{} can talk", self.name());
    }
}

struct Cat {
    name: &'static str,
}

impl Animal for Cat {
    fn create(name: &'static str) -> Cat {
        Cat{name: name}
    }

    fn name(&self) -> &'static str {
        self.name
    }
    fn talk(&self) {
        println!("{} say meow", self.name());
    }
}


fn taits_states() {
    ///
    let h = Human{name: "John"};
    h.talk();

    let c = Cat{name: "Misy"};
    c.talk();

    ///
    let h2 = Human::create("John");
    h2.talk();

    let h3:Human = Animal::create("John");
    h3.talk();


}