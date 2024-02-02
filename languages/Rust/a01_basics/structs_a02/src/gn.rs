struct Point<T> {
	x: T,
	y: T,
}

struct Line<T> {
	start: Point<T>,
	end: Point<T>,
}

pub fn generics_states() {
	let a:Point<f64> = Point{x:0.0, y:4f64 };
	let b:Point<f64> = Point{x:1.2, y:3.4};
	
	let line = Line{start:a, end:b};
	println!("line.start.y = {}", line.start.y);
}
