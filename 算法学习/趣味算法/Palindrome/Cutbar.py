def cut_bar(m, n, current):
    if current >= n:
        return 0
    elif current < m:
        return cut_bar(m, n, current * 2) + 1
    else:
        return 1 + cut_bar(m, n, current + m)


print(cut_bar(3, 10, 1))
