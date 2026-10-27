def step(state, n_in, load_n, rst_n):
    n, phase, out = state

    if not rst_n:
        return (1, 0, 0)

    if load_n:
        n = max(1, n_in)
        return (n, 0, 0)

    if n == 1:
        return (1, 0, 1)

    high_len = n - (n // 2)
    low_len = n // 2
    interval = high_len if out else low_len

    if phase == interval - 1:
        return (n, 0, 1 - out)

    return (n, phase + 1, out)


def run():
    # Reset.
    assert step((123, 4, 1), 7, 0, 0) == (1, 0, 0)

    # Load N.
    assert step((1, 0, 0), 3, 1, 1) == (3, 0, 0)

    # N=1 special case.
    assert step((1, 0, 0), 1, 0, 1) == (1, 0, 1)

    # Exhaust representative N behavior and ensure state remains bounded.
    for n in [1, 2, 3, 4, 5, 10, 254, 255]:
        state = (n, 0, 0)
        for _ in range(4 * max(2, n)):
            state = step(state, n, 0, 1)
            assert 1 <= state[0] <= 255
            assert 0 <= state[1] < max(1, state[0])

    print("D03 reference model PASS")


if __name__ == "__main__":
    run()
