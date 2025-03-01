install.packages('tidyverse')
install.packages('quantmod')
# install.packages('ggforce')
library('tidyverse')
library('quantmod')
# library('ggforce')

df_symbols <- read_csv('Symbols.csv')
symbols <- df_symbols$Symbols

df_divs <- tibble(
  Symbol = character(), 
  Date = as.Date(character()), 
  Dividend = numeric())

print_error <- function(e){
  cat(symb, 
      ': Calculation or Fetching error - did not add to list\n'
  )
  print(e)
}

for (symb in symbols){
  #Check that current_symb didn't return with nothing (error)
  tryCatch({
    cat('Fetching ', symb, "...\n", sep = '')
    current_symb <- getDividends(
      symb, 
      src = 'yahoo', 
      from = '2018-01-01', 
      to = '2024-12-31'
      )
    
    if (is.null(current_symb) || nrow(current_symb) == 0) {
      cat(symb, ": No dividend data available. Moving on...\n")
      next
    }
    
    core_data <- drop(coredata(current_symb))
    increase_counter <- 0
    
    for (i in seq(length(core_data), 2, -1)){
      if (increase_counter == 5){ break }
      
      if (core_data[i] > core_data[i-1]){
        df_divs <- df_divs %>% add_row(
          Symbol = symb,
          Date = as.Date(index(current_symb)[i]),
          Dividend = core_data[i]
        )
        increase_counter <- increase_counter + 1
      }
    }
  }, error = function(e) {
    print_error(e)
  })
}

df_prices_blank <- tibble(
  Symbol = character(), 
  Dividend_Date = as.Date(character()),
  Increase_Year = numeric(),
  Price_Date = as.Date(character()),
  Timeframe = character(),
  Open = numeric(),
  High = numeric(),
  Low = numeric(),
  Close = numeric())

df_prices <- df_prices_blank

create_row_df_prices <- function(symbol, date_div, date_price, timeframe){
  return (tibble(
    Symbol = symbol,
    Dividend_Date = date_div,
    Increase_Year = year(date_div),
    Price_Date = date_price,
    Timeframe = timeframe,
    Open = as.double(df_test$Open[date_price]),
    High = as.double(df_test$High[date_price]),
    Low = as.double(df_test$Low[date_price]),
    Close = as.double(df_test$Close[date_price]),
  ))
}

add_increase_df_prices <- function(symbol, during_index){
  date_before <- index(df_test[during_index-1])
  date_during <- index(df_test[during_index])
  date_after <- index(df_test[during_index+1])
  
  #Before
  df_prices <- df_prices %>% 
    add_row(create_row_df_prices(symbol, date_during, date_before, 'Before'))
  #Div Increase Day
  df_prices <- df_prices %>% 
    add_row(create_row_df_prices(symbol, date_during, date_during, 'During'))
  #After
  df_prices <- df_prices %>% 
    add_row(create_row_df_prices(symbol, date_during, date_after, 'After'))
  
  return(df_prices)
}

for (increase_index in index(df_divs)){
  # print(increase_index)
  cat('On index', increase_index, '\n')
  
  tryCatch({
    #Adding a week before and after to account for weekends and holidays
    df_test <- getSymbols(
      df_divs$Symbol[increase_index], 
      from = df_divs$Date[increase_index]-7, 
      to = df_divs$Date[increase_index]+7, 
      env = NULL
    )
    
    names(df_test) <- c(
      "Open", "High", "Low", "Close", "Volume", 'Adjusted'
      )
    
    during_index <- which(index(df_test) == df_divs$Date[increase_index])
    
    df_prices <- add_increase_df_prices(
      df_divs$Symbol[increase_index], during_index
      )
  }, error = function(e){
    print_error(e)
  })
  
}

# glimpse(df_prices)
# head(df_prices)
# tail(df_prices)

# write.csv(df_prices, 'prices.csv')

df_prices_sum <- df_prices %>%
  select(-c('Dividend_Date', 'Price_Date')) %>%
  pivot_wider(
    names_from = c('Increase_Year', 'Timeframe'),
    values_from = c('Open', 'High', 'Low', 'Close')
  )

View(df_prices_sum)
