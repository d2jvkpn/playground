fn main() {
    let v1 = vec![1, 2, 3];
    println!("~~~ v1 {}, {}: {v1:?}", v1.len(), v1.capacity());

    let mut v2 = Vec::new();
    v2.extend_from_slice(&v1);
    println!("v2: {v2:?}");
    v2.copy_from_slice(&[4, 5, 6]); // v1.len() must equals to slice
    println!("v2: {v2:?}");

    let mut v3 = Vec::with_capacity(10);
    v3.push(3);
    println!("~~~ v3 {}, {}: {v3:?}", v3.len(), v3.capacity());

    let a = &[1, 2, 3];
    let b = [1, 2, 3];
    assert_eq!(a.to_vec(), b.to_vec());

    let a = vec![1, 2, 3];
    let mut b = Vec::with_capacity(5);
    b.extend_from_slice(&a);
    assert_eq!(a, b);

    b.iter().for_each(|v| println!("~~~ v: {v}"));
    let c: Vec<i32> = b.iter().map(|v| v * v).collect();
    dbg!(&c);

    let mut a = vec![1, 2, 3];
    a.push(4);
    _ = a.pop();
    assert_eq!(a.len(), 3);
    a.remove(0);
    assert_eq!(a, vec![2, 3]);
    a.clear();
    assert_eq!(a, vec![]);

    let vec: Vec<i32> = (0..42).collect();
    vec.windows(4).for_each(|v| println!("--> {:?}\n", v));
}
