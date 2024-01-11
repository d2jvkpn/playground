use once_cell::sync::OnceCell;

#[derive(Debug)]
pub struct Config {
    pub key: String,
}

static INSTANCE: OnceCell<Config> = OnceCell::new();

impl Config {
    pub fn global() -> &'static Config {
        INSTANCE.get().expect("config is not initialized")
    }

    fn from_cli(key: String) -> Self {
        Self { key }
    }
}

fn main() {
    let config = Config::from_cli("THE_KEY".to_string());

    INSTANCE.set(config).unwrap();

    println!("{:?}", Config::global());
}
