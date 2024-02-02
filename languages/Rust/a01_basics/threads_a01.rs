use std::thread;
use std::time::Duration;

fn main() {
    let mut threads = Vec::with_capacity(10);

    for i in 0..10 {
        let th = thread::spawn(move || {
            println!("new thread: {}", i);
            thread::sleep(Duration::new(1, 0));
        });

        threads.push(th);
    }

    println!("main thread");
    for th in threads {
        th.join();
    }
}
