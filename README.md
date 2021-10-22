*The documentation below is currently out-of-date. Visit https://www.codermerlin.com/wiki/index.php?title=W3911_Sudoku_Server for the latest documentation.*
# Soodokoo, brought to you by Runtime Terror
(yes, it's Soo-do-koo, the one by Runtime Terror)
## Team Members
* Akshat Shah
* Caleb Lee
* Patrick Bui
* Danyal Siddiqi

## Random Notes
### Board Generation Algorithm
1. Generate random first row
2. Generate 2nd row: shift previous row 3 to the right
3. Generate 3rd row: shift previous row 3 to the right
4. Generate 4th row: within 3-element sets, `[1, 2, 3]` -> `[3, 1, 2]` shift by 1 to right
5. Generate 5th row: shift previous row 3 to the right
6. Generate 6th row: shift previous row 3 to the right
7. Generate 7th row: within 3-element sets, `[1, 2, 3]` -> `[2, 3, 1]` shift by 1 to right
8. Generate 8th row: shift previous row 3 to the right
9. Generate 9th row: shift previous row 3 to the right

### Board Example
```
1, 2, 3, 4, 5, 6, 7, 8, 9
7, 8, 9, 1, 2, 3, 4, 5, 6
4, 5, 6, 7, 8, 9, 1, 2, 3
3, 1, 2, 6, 4, 5, 9, 7, 8
9, 7, 8, 3, 1, 2, 6, 4, 5
6, 4, 5, 9, 7, 8, 3, 1, 2
2, 3, 1, 5, 6, 4, 8, 9, 7
8, 9, 7, 2, 3, 1, 5, 6, 4
5, 6, 4, 8, 9, 7, 2, 3, 1
```
