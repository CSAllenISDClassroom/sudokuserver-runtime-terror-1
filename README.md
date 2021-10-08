# sudokuserver-runtime-terror-1
sudokuserver-runtime-terror-1 created by GitHub Classroom
# Soodokoo, brought to you by Runtime Terror
(yes, it's Soo-do-koo, the one by Runtime Terror)
## Team Members
* Akshat Shah
* Caleb Lee
* Patrick Bui
* Danyal Siddiqi
## Usage
### Notes
- `boardId`: board identification string
- `clientSecret`: client key to board modification
- `difficulty`: "easy", "medium", or "hard"
- `board`: 2-dimensional, 9x9 array with each cell's values
- `cell`
  - `row`: integer from 1-9
  - `col`: integer from 1-9
  - `value`: integer from 0-9; if 0, then cell is empty
### Starting URL
```https://soodokoo.allencs.org/api```
### Create New Game
#### Request
```GET /game/new?difficulty=XXX```
#### Response
```
{
	boardId: "XXXXXX",
	clientSecret: "XXXXXX",
	board: [
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X]	
	]
}
```
### Place Number on Cell
#### Request
```
POST /game/cell/place

{
	boardId: "XXXXXX",
	clientSecret: "XXXXXX",
	cell: {
		row: X,
		col: X,
		value: X
	},
}
```
#### Response
```
{
	boardId: XXXXXX,
	board: [
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X]
	]
}
``` 
### Remove Number from Cell
#### Request
```
POST /game/cell/remove

{
	boardId: "XXXXXX",
	clientSecret: "XXXXXX",
	cell: {
		row: X,
		col: X
	}
}
```
#### Response
```
{
	boardId: XXXXXX,
	board: [
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X],
		[X, X, X, X, X, X, X, X, X]
	]
}
```
### Validate Board against Solution
#### Request
```
POST /game/cell/validate

{
	boardId: "XXXXXX",
	clientSecret: "XXXXXX",
}
```
#### Response
```
{
	boardId: XXXXXX,
	matchesSolution: (true/false)
}
```
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
