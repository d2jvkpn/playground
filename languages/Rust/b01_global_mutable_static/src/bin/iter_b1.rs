use chrono::{Local, SecondsFormat};
use once_cell::sync::OnceCell;
use std::thread;

#[derive(Debug)]
pub struct Config {
    pub key: String,
}
static CONFIG_INSTANCE: OnceCell<Config> = OnceCell::new();

impl Config {
    pub fn set(key: String) -> Result<(), Config> {
        CONFIG_INSTANCE.set(Self { key })
    }

    fn global() -> Option<&'static Config> {
        CONFIG_INSTANCE.get()
    }

    pub fn global_key() -> Option<&'static str> {
        let config = CONFIG_INSTANCE.get()?;
        Some(&config.key)
    }
}

fn now() -> String {
    Local::now().to_rfc3339_opts(SecondsFormat::Millis, true)
}

fn main() {
    let result = Config::set("THE_KEY_01".to_string());
    println!("--> {} Set THE_KEY_01 result: {:?}", now(), result);

    let result = Config::set("THE_KEY_02".to_string());
    println!("--> {} Set THE_KEY_02 result: {:?}", now(), result);

    let t1 = thread::spawn(|| {
        println!("<-- {} t1 Config: {:?}", now(), Config::global());
    });

    let t2 = thread::spawn(|| {
        println!("<-- {} t2 Config: {:?}", now(), Config::global());
    });

    let t3 = thread::spawn(|| {
        println!("<-- {} t3 Config.key: {:?}", now(), Config::global_key());
    });

    // t1.join().unwrap();
    // t2.join().unwrap();
    // t3.join().unwrap();
    let results = [t1.join(), t2.join(), t3.join()];
    results.into_iter().for_each(|v| v.unwrap());

    // !! not working as expected: types differ in mutability
    // let config: &mut Config = Config::global();
    // config.key = "THE_KEY_03".to_string();
}
