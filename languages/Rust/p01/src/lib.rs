use std::{env, error::Error, fs};

pub struct Config {
    pub query: String,
    pub filename: String,
    pub case_sensitive: bool,
}

impl Config {
    pub fn new(args: &[String]) -> Result<Config, &str> {
        if args.len() < 3 {
            return Err("not enough arguments");
        }

        let case_sensitive = env::var("CASE_INSENSITIVE").is_err();

        Ok(Config {
            query: args[1].clone(),
            filename: args[2].clone(),
            case_sensitive: case_sensitive,
        })
    }
}

pub fn run1(config: Config) -> Result<(), Box<dyn Error>> {
    /*
    let contents = fs::read_to_string(config.filename)
        .expect("Something went wrong reading the file");
    */
    let contents = fs::read_to_string(config.filename)?;

    println!("With text:\n{}", contents);
    Ok(())
}

pub fn run(config: Config) -> Result<(), Box<dyn Error>> {
    let contents = fs::read_to_string(config.filename)?;

    let results = if config.case_sensitive {
        search(&config.query, &contents)
    } else {
        search_case_insensitive(&config.query, &contents)
    };

    // println!("With text:\n{}", contents);
    for line in results {
        println!("{}", line);
    }

    Ok(())
}

pub fn search<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    let mut results = Vec::new();

    for line in contents.lines() {
        if line.contains(query) {
            results.push(line);
        }
    }

    results
}

pub fn search_case_insensitive<'a>(query: &str, contents: &'a str) -> Vec<&'a str> {
    let query = query.to_lowercase();
    let mut results = Vec::new();

    for line in contents.lines() {
        if line.to_lowercase().contains(&query) {
            results.push(line);
        }
    }

    results
}

/*
fn parse_config(args: &[String]) -> Config {
    if args.len() < 3 {
        panic!("not enough arguments!");
    }

    let query = args[1].clone();
    let filename = args[2].clone();

    Config { query, filename }
}
*/
