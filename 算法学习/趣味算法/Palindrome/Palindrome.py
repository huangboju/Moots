def resolve():
    result = 11
    while True:
        if str(result) == str(result)[::-1] and str(bin(result))[2:] == str(bin(result))[:1:-1] and str(oct(result))[2:] == str(oct(result))[:1:-1]:
            print(result)
            break
        result += 2


resolve()

