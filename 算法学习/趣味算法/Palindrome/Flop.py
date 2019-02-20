def resolve():
    s = 100
    arr = [False for i in range(s+1)]
    n = 2
    while n <= s:
        for i in range(n, s, n):
            arr[i] = not arr[i]
        print(arr)
        n += 1

    for idx, v in enumerate(arr):
        if v:
            continue
        print(idx)


resolve()
