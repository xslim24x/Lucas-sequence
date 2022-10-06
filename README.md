# Lucas-sequence
![image1](https://user-images.githubusercontent.com/2296506/194209075-fefe6543-1988-4e76-bca3-987d8deb225c.png)
Using the method described in the lab, an integer overflow occurs at the 51st iteration of the sequence. This is because the size of the remainder exceeds 32 bits (greater than FFFFFFFF~h~)


## Solution
![image2](https://user-images.githubusercontent.com/2296506/194209135-f9953e60-8972-467b-a526-0407570f3008.png)
This was solved by implementing a double dabble algorithm which works by manipulating the conversion through bit shifts. As each value is shifted to the left (x2), each nibble is then compared to 4. If it’s greater it would result in a value of 10 when it is shifted to the left and doubled again so 3 is added to the nibble to prevent this. I also had to create a loop (fixer) in assembly to patch a problem I had controlling when the 3 addition would stop. I tried adjusting various values but due to time constraints my solution was to subtract 3 from any nibble that was greater or equal to 8. 


*A python script (7~8 lines of code vs 286 assembly code) was developed to compare my algorithm as I had exceeded the memory capabilities of windows calculator. By the 230th iteration, 5DWORDs were not enough memory.*