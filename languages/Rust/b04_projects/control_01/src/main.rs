#![allow(dead_code)]
#![allow(unused_variables)]
#![allow(unused_imports)]

fn main() {
    // if_state();
    // while_and_loop();
    // for_loop();
    match_state();
}

fn match_state() {
	let country_code = 777;
	let counry = match country_code {
		44 => "UK",
		46 => "Sweden",
		7 => "Russia",
		// _ => "unknown"
		1..=999 => "unknown",
		_ => "invalid"
	};
	
	println!("the country with code {} is {}", country_code, counry);
}

fn for_loop() {
    for x in 1..11 {
        println!("x = {}", x);
    }
    
    for x2 in 1..=11 {
        println!("x2 = {}", x2);
    }
    
    for (posi, y) in (30..41).enumerate() {
    	println!("{}: {}", posi, y);
    }
}

fn while_and_loop() {
    let mut x = 1;
    while x < 1000 {
        x *= 2;
        if x == 64 {
            continue;
        };
        println!("x = {}", x);
    }

    let mut y = 1;
    loop {
        y *= 2;
        println!("y = {}", y);
        if y == 1 << 10 {
            break;
        };
    }
}

fn if_state() {
    let temp = 35;

    if temp > 30 {
        println!("really hot outside!");
    } else if temp < 10 {
        println!("really cold!");
    } else {
        println!("temperature is OK");
    }

    let day = if temp > 20 { "sunny" } else { "cloud" };
    println!("today is {}", day);

    println!(
        "is it {}",
        if temp > 20 {
            "hot"
        } else if temp < 10 {
            "cold"
        } else {
            "ok"
        }
    );
}
