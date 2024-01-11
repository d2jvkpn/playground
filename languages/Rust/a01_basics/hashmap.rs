use std::collections::HashMap;

fn main() {
    //
    let mut map = HashMap::new();

    map.insert(1, "Hello");
    map.entry(2).or_insert("Yes");
    map.entry(2).or_insert("yyy");

    assert_eq!(map.get(&2), Some(&"Yes"));

    println!(
        "~~~ map: {map:?}, {:?}, {:?}, {:?}",
        map.get(&0),
        map.get(&1),
        map.get(&3).unwrap_or(&"OK")
    );

    for (k, v) in map {
        println!("--> k={k}, v={v}");
    }

    //
    let s = "loveleetcode".to_string();
    let chars: Vec<char> = s.chars().collect();
    let mut count: HashMap<&char, usize> = HashMap::with_capacity(chars.len());

    chars.iter().for_each(|c| *count.entry(c).or_insert(0) += 1);
    println!("{:?}", chars.iter().position(|c| count[c] == 1));
}

fn first_uniq_char(s: String) -> i32 {
    let chars: Vec<char> = s.chars().collect();
    let mut count: HashMap<&char, usize> = HashMap::with_capacity(chars.len());
    chars.iter().for_each(|c| *count.entry(c).or_insert(0) += 1);

    match chars.iter().position(|c| count[c] == 1) {
        Some(v) => v as i32,
        None => -1,
    }
}
