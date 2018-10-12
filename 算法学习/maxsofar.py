"""fasdfasfsa"""
#!/usr/bin/env python3

def maxsofar(arr):
    """
    high level support for doing this and that.
    """
    result = 0
    maxendinghere = arr[0]
    for i in range(1, len(arr)):
        maxendinghere = max(maxendinghere + arr[i], 0)
        result = max(result, maxendinghere)
    return result


print(maxsofar([1, 2, -4, 5, 21, 34, -34, 9, 2, 5]))
