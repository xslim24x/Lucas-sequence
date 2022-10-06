if __name__ == "__main__":
    l1 = 1
    l2 = 3
    print(f"1 {hex(l1):>45} {l1:>55}")
    for x in range(2,241):
        print(f"{x} {hex(l2):>45} {l2:>55}")
        l2 += l1
        l1 = l2 - l1