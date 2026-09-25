//! expect-stdout: ok

// D68: use C itself as the oracle, across the binary64 range. This is a
// compiler/runtime conformance test, so the raw foreign buffer stays here.
extern fn snprintf(buffer: *mut u8, capacity: usize, format: *const u8, ...) -> i32

fn compare_c(x: f64):
    var buffer: [1100]u8 = [0 as u8; 1100]
    let n = unsafe { snprintf(&raw mut buffer as *mut u8, 1100 as usize, c"%g".ptr, x) }
    assert(n >= 0 and n < 1100)
    let actual = f"{x}"
    assert(actual.len() == n as i64)
    for i in 0..n as i64:
        assert(actual.byte_at(i) == buffer[i] as i32)
    let precise_n = unsafe { snprintf(&raw mut buffer as *mut u8, 1100 as usize, c"%.30g".ptr, x) }
    let precise = f"{x:.30g}"
    assert(precise.len() == precise_n as i64)
    for i in 0..precise_n as i64:
        assert(precise.byte_at(i) == buffer[i] as i32)

fn sweep(start: f64):
    var x = start
    var i = 0
    while i < 320:
        if i % 11 == 0:
            compare_c(x)
            compare_c(-x)
        x = x / 10.0
        i = i + 1
    x = start * 10.0
    i = 1
    while i < 309:
        if i % 11 == 0:
            compare_c(x)
            compare_c(-x)
        x = x * 10.0
        i = i + 1

fn main:
    sweep(1.0)
    sweep(1.5)
    sweep(20.0 / 3.0)
    sweep(30.0 / 7.0)
    sweep(355.0 / 113.0)
    compare_c(0.0)
    compare_c(-0.0)
    compare_c(5e-324)
    compare_c(1.7976931348623157e308)
    compare_c(0.00009999999)
    compare_c(999999.9)
    print("ok")
