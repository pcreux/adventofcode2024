use rayon::prelude::*; // For parallel processing
use std::time::Instant;

fn blink(stones: Vec<u64>) -> Vec<u64> {
    let chunk_size = std::cmp::max(stones.len() / 8, 10);

    stones
        .par_chunks(chunk_size) // Parallel processing of chunks
        .flat_map(|slice| {
            slice.par_iter().flat_map(|&stone| {
                if stone == 0 {
                    vec![1]
                } else {
                    let stone_str = stone.to_string();
                    if stone_str.len() % 2 == 0 {
                        let half = stone_str.len() / 2;
                        vec![
                            stone_str[..half].parse::<u64>().unwrap(),
                            stone_str[half..].parse::<u64>().unwrap(),
                        ]
                    } else {
                        vec![stone * 2024]
                    }
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
        let eta = duration * (blinks - n - 1) as f64;

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


/**
 * Blink 30: 964027 stones. (269ms / 1M stones). Elapsed: 0.01m. ETA: 0.19m.
Blink 31: 1466235 stones. (273ms / 1M stones). Elapsed: 0.02m. ETA: 0.29m.
Blink 32: 2229727 stones. (259ms / 1M stones). Elapsed: 0.03m. ETA: 0.41m.
Blink 33: 3366152 stones. (263ms / 1M stones). Elapsed: 0.04m. ETA: 0.62m.
Blink 34: 5154934 stones. (268ms / 1M stones). Elapsed: 0.07m. ETA: 0.94m.
Blink 35: 7793740 stones. (265ms / 1M stones). Elapsed: 0.10m. ETA: 1.38m.
Blink 36: 11819352 stones. (264ms / 1M stones). Elapsed: 0.15m. ETA: 2.03m.
Blink 37: 18052606 stones. (305ms / 1M stones). Elapsed: 0.24m. ETA: 3.48m.
Blink 38: 27278105 stones. (319ms / 1M stones). Elapsed: 0.39m. ETA: 5.37m.
Blink 39: 41535881 stones. (337ms / 1M stones). Elapsed: 0.62m. ETA: 8.40m.
Blink 40: 63083615 stones. (358ms / 1M stones). Elapsed: 1.00m. ETA: 13.17m.
Blink 41: 95665503 stones. (390ms / 1M stones). Elapsed: 1.62m. ETA: 21.17m.
Blink 42: 145765473 stones. (349ms / 1M stones). Elapsed: 2.47m. ETA: 27.96m.
*/
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
