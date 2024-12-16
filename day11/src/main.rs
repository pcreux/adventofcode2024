use rayon::prelude::*; // For parallel processing
use std::time::Instant;

fn blink(stones: Vec<u64>) -> Vec<u64> {
    let slices = stones
        .chunks(std::cmp::max(stones.len() / 8, 10))
        .map(|slice| slice.to_vec())
        .collect::<Vec<_>>();

    slices
        .into_par_iter() // Parallel iteration
        .flat_map(|slice| {
            slice.into_par_iter().flat_map(|stone| {
                let stone_str = stone.to_string();
                if stone == 0 {
                    vec![1]
                } else if stone_str.len() % 2 == 0 {
                    let size = stone_str.len();
                    let half = size / 2;
                    vec![
                        stone_str[0..half].parse::<u64>().unwrap(),
                        stone_str[half..size].parse::<u64>().unwrap(),
                    ]
                } else {
                    vec![stone * 2024]
                }
            })
        })
        .collect()
}

fn run_fast(input: &str, blinks: usize) -> Vec<u64> {
    let mut stones: Vec<u64> = input
        .split_whitespace()
        .map(|s| s.parse::<u64>().unwrap())
        .collect();

    let start_time = Instant::now();

    for n in 0..blinks {
        let blink_start_time = Instant::now();
        let blink_stones_size = stones.len();

        stones = blink(stones);
        let duration = blink_start_time.elapsed().as_secs_f64();

        let elapsed = start_time.elapsed().as_secs_f64();
        let eta = duration * (blinks - n) as f64;

        println!(
            "Blink {}: {} stones. ({}ms / 1M stones). Elapsed: {:.2}m. ETA: {:.2}m.",
            n + 1,
            blink_stones_size,
            (duration * 1000.0 / (blink_stones_size as f64 / 1_000_000.0)).round(),
            elapsed / 60.0,
            eta / 60.0
        );
    }

    stones
}

fn main() {
    let input1 = "0 1 10 99 999";
    println!("INPUT = {}", input1);
    let result = run_fast(input1, 1);
    println!("{:?}", result);

    println!();
    let input2 = "125 17";
    let result = run_fast(input2, 6);
    println!("{:?}", result);
    println!("Size: {}", result.len());

    println!();
    let input3 = "8435 234 928434 14 0 7 92446 8992692";
    let result = run_fast(input3, 25);
    println!("Size: {}", result.len());

    println!();
    println!("Day 2");
    let input4 = "8435 234 928434 14 0 7 92446 8992692";
    let result = run_fast(input4, 75);
    println!("Size: {}", result.len());
}

/*
   ...
Blink 36: 11819352 stones. (310ms / 1M stones). Elapsed: 0.17m. ETA: 2.44m.
Blink 37: 18052606 stones. (315ms / 1M stones). Elapsed: 0.26m. ETA: 3.69m.
Blink 38: 27278105 stones. (322ms / 1M stones). Elapsed: 0.41m. ETA: 5.56m.
Blink 39: 41535881 stones. (357ms / 1M stones). Elapsed: 0.66m. ETA: 9.14m.
Blink 40: 63083615 stones. (333ms / 1M stones). Elapsed: 1.01m. ETA: 12.61m.
Blink 41: 95665503 stones. (341ms / 1M stones). Elapsed: 1.55m. ETA: 19.04m.
Blink 42: 145765473 stones. (659ms / 1M stones). Elapsed: 3.15m. ETA: 54.43m.
*/
