use std::mem;

struct Point {
	x: f64,
	y: f64,
	z: i8
}

fn origin() -> Point {
	Point{x:0.0, y:0.0, z:0}
}

pub fn stack_and_heap() {
	/*
	// stack, access fast, but limited size
	let x = 5;
	let y = 6;
	println!("x = {}, y = {}, x is {} bytes", x, y, mem::size_of_val(&x));
	
	// heap, reference or pointer
	let x2 = Box::new(5); // an address point to a variable which contains 5
	let y2 = Box::new(6); // 
	println!("x2 = {}, y2 = {}, x2 is {} bytes", x2, y2, mem::size_of_val(&x2));
	*/
	
	let p1 = origin(); // stack
	let p2 = Box::new(origin()); // heap
	// let p3 = *p2;
	println!("p1 takes up {} bytes", mem::size_of_val(&p1));
	println!("p2 takes up {} bytes", mem::size_of_val(&p2));
}
