use chrono::Utc;
use std::{
    borrow::BorrowMut,
    sync::{Mutex, Once},
    thread,
};

static mut STD_ONCE_COUNTER: Option<Mutex<String>> = None;
static INIT: Once = Once::new();

pub fn std_once_counter() -> String {
    (*global_string().lock().unwrap().clone()).to_string()
}

fn global_string<'a>() -> &'a Mutex<String> {
    INIT.call_once(|| {
        // Since this access is inside a call_once, before any other accesses, it is safe
        unsafe {
            *STD_ONCE_COUNTER.borrow_mut() = Some(Mutex::new(Utc::now().to_string()));
        }
    });
    // As long as this function is the only place with access to the static variable,
    // giving out a read-only borrow here is safe because it is guaranteed no more mutable
    // references will exist at this point or in the future.
    unsafe { STD_ONCE_COUNTER.as_ref().unwrap() }
}
pub fn main() {
    println!("Global string is {}", *global_string().lock().unwrap());
    println!("Global string is {}", *global_string().lock().unwrap());
    *global_string().lock().unwrap() = Utc::now().to_string();
    println!("Global string is {}", *global_string().lock().unwrap());

    let t1 = thread::spawn(|| {
        println!("t1: {}", std_once_counter());
    });

    let t2 = thread::spawn(|| {
        println!("t2: {}", std_once_counter());
    });

    t1.join().unwrap();
    t2.join().unwrap();
}
