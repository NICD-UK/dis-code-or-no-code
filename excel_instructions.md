# Excel Instructions

## Calculating the duration of trips

### 1. Add a new column called "duration"

- Right-click the column that you want to insert a new column before. In this case, column `D`.
- Click `insert`
- Click inside the top cell of the new column
- Type `duration` and press `Enter`

### 2. Create a formula

- Click in the first empty cell of the `duration` column (`D2`)
- Type `=(`
- Click on the first datetime in the dropoff column (`C2`)
- Type `-`
- Click on the first datetime in the pickup column (`B2`)
- Type `)*1440` 
> There are 1440 minutes in a day

### 3. Change the format of the column
- Right-click the `duration` column (column `D`)
- Click `Format cells`
- Select `Number`
- Click `OK`

### 4. Copy the formula down

- Click on the first value in the `duration` column
- Double-click on the small square in the bottom right corner of the cell
