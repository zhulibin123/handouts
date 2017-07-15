## Bubble Sort

The "bubble sort" algorithm is a procedure for sorting. If the input is a collection of random letters, the following "pseudo-code" provides a set of instructions that will lead to sorting the collection alphabetically.

1. let `A` refer to a random collection of letters
2. let `n` refer to the number of letters in `A`
3. for `i` referring to any positive integer, let `A[i]` refer to the `i`<sup>th</sup> letter in `A`
4. let `swapped` refer to 'No'
5. let `i` refer to 1, then 2, then 3, etc. up to and including `n - 1` in the next step
6. if `A[i + 1]` comes before `A[i]` in the alphabet, then swap them in the collection `A` and let `swapped` refer to 'Yes'
7. if `swapped` refers to 'Yes', go back to 4 and resume, otherwise `A` is in alphabetical order

The following is a script in the R programming language that implements bubble sort, beginning from the assumption that `A` already refers to an array of letters.

```r
n <- length(A)
swapped <- TRUE
while (swapped) {
    swapped <- FALSE
    for (i in seq(1, n - 1)) {
        if (A[i+1] < A[i]) {
            a <- A[i+1]
            A[i+1] <- A[i]
            A[i] <- a
            swapped <- TRUE
        }
    }
}
```

#### Questions

* What do you think the combination of characters `<-` means? What about the pattern `{...}`?

* Which pseudo-code step is implemented by the `if (...) {...}` block? What is the role of `a`?

* What word in the code instructs the computer to repeat something for an unspecified number of times? What word causes something to repeat a fixed number of times?

* If you don't trust it works, pretend to "compute" the procedure for the array of letters ['q', 'e', 'd'].

The following script achieves the same thing, but "modularizes" step 6; it seperates out the code for swapping. Identify how the script is different as you read.

```r
swap <- function(i, x) {
    lesser <- x[i + 1]
    x[i + 1] <- x[i] 
    x[i] <- lesser
    return(x)
}

n <- length(A)
swapped <- TRUE
while (swapped) {
    swapped <- FALSE
    for (i in seq(1, n - 1)) {
        if (A[i+1] < A[i]) {
            A <- swap(i, A)
            swapped <- TRUE
        }
    }
}
```

#### Questions

* What is the name of the new `function`?

* What is one advantage or disadvantage to writing this script as two "modules"?

## Snippets

Carefully "read" each of the following, unrelated, snippets of R code and answer the questions as you go.

#### Snippet 1

```r
values <- c(6, 42, 13, 2, 9, -8, 27)
total <- 0
for (i in 1:length(values)) {
    total <- total + values[i]
}
```

#### Questions

* What does this R code achieve in the final value of `total`?

* What do you think the expression `1:length(values)`, used in the `for (...) {...}` block, establishes?  

#### Snippet 2

```r
test_value <- 98
is_even <- function(x) {
    output <- FALSE
    if (x != round(x)) {
        warning('Please input an integer.')
    } else {
        y <- round(x / 2)
        if (x == y * 2) {
            output <- TRUE
        }
    }
    return(output)
}
if (!evenness(test_value)) {
    warning('Test failed.')
}
```

#### Questions

* What does this R code do?

* What does `!` mean?

* What kind of input would cause the `is_even` function to print a warning?
                      
#### Snippet 3

```r
text <- 'The computing world has undergone a revolution since the publication of "The C Programming Language" in 1978.'
word <- 'revolution'
n <- nchar(word)
i <- 1
while (substring(text, i, i + n - 1) != word) {
    i <- i + 1
    if (i + n > nchar(text)) {
        i <- 0
        break
    }
}
```

#### Questions

* What does this R code do?

* For some other `text` or `word`, what does it mean if `i` is found to equal 0 after running the code?
