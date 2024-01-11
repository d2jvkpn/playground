struct Point {
	x: f64,
	y: f64,
}

struct Line {
	start: Point,
	end: Point,
}

impl Line {
	fn len(&self) -> f64 {
		let dx = self.start.x - self.end.x;
		let dy = self.start.y - self.end.y;
		(dx*dx + dy*dy).sqrt()
	}
}

pub fn methods_states() {
	let a:Point = Point{x:0.0, y:4f64 };
	let b:Point = Point{x:1.2, y:3.4};
	
	let line = Line{start:a, end:b};
	println!("line length = {}", line.len());
}