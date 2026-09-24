//! expect-stdout: ok

// The default float display prints the shortest decimal that reads back as the
// same f64 (§15.4.2 `g`, §15.4.4), and `:e` rounds its digits exactly, ties to
// even. Each expected string was derived from the exact binary value.

fn divided_by_ten(start: f64, times: i32) -> f64:
    var x = start
    var i = 0
    while i < times:
        x = x / 10.0
        i = i + 1
    x

fn test_default_is_shortest_round_trip:
    assert(f"{0.1 + 0.2}" == "0.30000000000000004")
    assert(f"{1.0 / 3.0}" == "0.3333333333333333")
    assert(f"{2.0 / 3.0}" == "0.6666666666666666")
    assert(f"{0.1}" == "0.1")
    assert(f"{100.0}" == "100")
    assert(f"{123456.789}" == "123456.789")
    assert(f"{-2.5}" == "-2.5")

fn test_fixed_below_one_keeps_every_digit:
    assert(f"{1.0 / 3.0 / 100000.0}" == "0.0000033333333333333333")

fn test_scientific_digits_are_exact:
    assert(f"{1e-300}" == "1e-300")
    assert(f"{divided_by_ten(20.0 / 3.0, 79)}" == "6.666666666666667e-79")
    assert(f"{1.7976931348623157e308}" == "1.7976931348623157e+308")
    assert(f"{5e-324}" == "5e-324")
    assert(f"{1e15}" == "1e+15")

fn test_debug_and_g_match_default:
    let x = 0.1 + 0.2
    assert(f"{x:?}" == f"{x}")
    assert(f"{x:g}" == f"{x}")

fn test_e_mode_rounds_exactly:
    assert(f"{1e-300:e}" == "1.000000e-300")
    assert(f"{divided_by_ten(20.0 / 3.0, 79):.3e}" == "6.667e-79")
    assert(f"{0.125:.1e}" == "1.2e-01")
    assert(f"{9.9999:.2e}" == "1.00e+01")

fn main:
    test_default_is_shortest_round_trip()
    test_fixed_below_one_keeps_every_digit()
    test_scientific_digits_are_exact()
    test_debug_and_g_match_default()
    test_e_mode_rounds_exactly()
    print("ok")
