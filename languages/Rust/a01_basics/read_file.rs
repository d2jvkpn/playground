use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::process;

fn main() {
    let fp = "./hosts.txt";
    let lines = read_lines(fp).unwrap_or_else(|err| {
        eprintln!("read file {}: {}", fp, err);
        process::exit(1);
    });

    // File hosts must exist in current path before this produces output
    // Consumes the iterator, returns an (Optional) String
    for line in lines {
        if let Ok(ip) = line {
            println!("{}", ip);
        }
    }
}

// The output is wrapped in a Result to allow matching on errors
// Returns an Iterator to the Reader of the lines of the file.
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where
    P: AsRef<Path>,
{
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}
