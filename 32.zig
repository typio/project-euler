// Pandigital Products

// --- Concepts
// Count of digits in a number: floor(log10(number))
// nth digit of number: floor(number / pow(10, number_digit_count - n - 1)) % 10;
// Count of digits in a product: m_digits + n_digits - 1 <= product_digits <= m_digits + n_digits

const std = @import("std");
const math = std.math;
const ArrayList = std.ArrayList;

pub fn main() !void {
    var buffer: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();

    var list = ArrayList(u32).init(allocator);

    var productSum: u32 = 0;

    var i: u32 = 1;
    // NOTE: 2-digit i (i < 100) works, is that because of the rarity of these numbers?
    while (i < 10000) : (i += 1) {
        const iNumberOfDigits = math.log10(i) + 1;

        // iDigits + jDigits - 1 <= pDigits <= iDigits + jDigits
        // pDigits + iDigits + jDigits = 9

        const jNumberOfDigitsMin = (9 - iNumberOfDigits) / 2;
        const jMin = math.pow(u32, 10, jNumberOfDigitsMin - 1);
        const jMax = jMin * 10;

        var j: u32 = jMin;
        while (j < jMax) : (j += 1) {
            const p = i * j;
            const pIsPandigital = isPandigital(i, j, p);

            var pExists = false;
            for (list.items) |listProduct| {
                if (p == listProduct) {
                    pExists = true;
                    break;
                }
            }

            if (pIsPandigital and !pExists) {
                std.debug.print("Found {d} {d} {d}\n", .{ i, j, p });
                productSum += p;
                try list.append(p);
            }
        }
    }

    std.debug.print("Sum of products: {d}.\n", .{productSum});
}

fn countDigits(number: u32, digitCounts: *[10]u32) void {
    const numberOfDigits = math.log10(number) + 1;

    var i: u32 = 0;
    while (i < numberOfDigits) : (i += 1) {
        const digit = (number / math.pow(u32, 10, numberOfDigits - i - 1)) % 10;
        digitCounts.*[digit] += 1;
    }
}

fn isPandigital(multiplicand: u32, multiplier: u32, product: u32) bool {
    var totalDigitCounts = [_]u32{0} ** 10;
    countDigits(multiplicand, &totalDigitCounts);
    countDigits(multiplier, &totalDigitCounts);
    countDigits(product, &totalDigitCounts);

    var pandigital = true;

    for (totalDigitCounts, 0..) |digit, i| {
        if (i == 0 and digit > 0) {
            pandigital = false;
        } else if (i > 0 and digit != 1) {
            pandigital = false;
        }
    }
    return pandigital;
}
