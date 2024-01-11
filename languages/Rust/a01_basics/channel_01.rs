use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        println!("new thread: {}", 1);
        thread::sleep(Duration::new(1, 0));
        tx.send(42).unwrap();
    });

    println!("received {}", rx.recv().unwrap());
}
