## Scripting Exercises

Work through as many of the following challenge exercises as you can in one hour. Take at least five minutes to ponder each challenge on your own, but then feel free to engage with fellow participants and SESYNC instructors for guidance or ideas.

#### Challenge

If you ever interview for a "code monkey" postition, you may be asked to complete this common challenge using multiple approaches; we'll try the most straightforward. Write a "for loop" in the R language that calculates the Fibonnacci sequence up through it's 12th entry. Start your script with the line `fib <- c(1, 1)`, and recall that `c` combines vectors.

#### Challenge

Fix each of the following common data frame subsetting errors.

- `plots[plots$id = 4, ]`
- `plots[-1:4, ]`
- `plots[plots$id <= 5]`
- `plots[plots$id == 4 | 6, ]`

#### Challenge

Create a data frame from scratch that has three columns and 5 rows. In a column named "size", place a sequence from 1 to 5. For a column named "year", create a factor with three levels representing the past three years. Name the third column "prop" and place 5 random samples from a uniform distribution. Show the summary of a linear model following the formula `prop ~ size + year`.

#### Challenge

Construct a data frame and performa an ANOVA to test the following hypothesis about animal weight from the study represented by the "animals.csv" file: average animal weight differes between 1980, 1990 and 2000. Carefully consider the data structure you should use for the variable "year".

#### Challenge

Try that Fibonnacci challenge again, but use an approach called "recursion". That is, write a function that calls itself (i.e. a recursion) to calculate any Fibonacci number. Just because this is an "advanced" approach doesn't mean it's a good one: don't try it for any number over your age!
