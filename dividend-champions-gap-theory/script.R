install.packages('tidyverse')
install.packages('quantmod')
library('tidyverse')
library('quantmod')

# INITAL SCRAPE OF ALL DIV CHAMPIONS

df_symbols <- read_csv('Symbols.csv')
symbols <- df_symbols$Symbols

df_divs <- tibble(
  Symbol = character(), 
  Date = as.Date(character()), 
  Dividend = numeric(),
  Increase_Num = numeric())

print_error <- function(e){
  cat(symb, 
      ': Calculation or Fetching error - did not add to list\n'
  )
  print(e)
}

for (symb in symbols){
  #Check that current_div didn't return with nothing (error)
  tryCatch({
    cat('Fetching ', symb, "...\n", sep = '')
    current_div <- getDividends(
      symb, 
      src = 'yahoo', 
      from = '2018-01-01', 
      to = '2024-12-31'
      )
    
    if (is.null(current_div) || nrow(current_div) == 0) {
      cat(symb, ": No dividend data available. Moving on...\n")
      next
    }
    
    core_data <- drop(coredata(current_div))
    increase_counter <- 0
    
    for (i in seq(length(core_data), 2, -1)){
      if (increase_counter == 5){ break }
      
      if (core_data[i] > core_data[i-1]){
        df_divs <- df_divs %>% add_row(
          Symbol = symb,
          Date = as.Date(index(current_div)[i]),
          Dividend = core_data[i],
          Increase_Num = increase_counter + 1
        )
        increase_counter <- increase_counter + 1
      }
    }
  }, error = function(e) {
    print_error(e)
  })
}

# print(df_divs)



# BEFORE, DURING, AND AFTER PRICES SCRAPE

df_prices_blank <- tibble(
  Symbol = character(), 
  Dividend_Date = as.Date(character()),
  Increase_Num = numeric(),
  Increase_Year = numeric(),
  Price_Date = as.Date(character()),
  Timeframe = character(),
  Open = numeric(),
  High = numeric(),
  Low = numeric(),
  Close = numeric())

df_prices <- df_prices_blank

create_row_df_prices <- function(
    symbol, increase_num, date_div, date_price, timeframe
    ){
  return (tibble(
    Symbol = symbol,
    Dividend_Date = date_div,
    Increase_Num = increase_num,
    Increase_Year = year(date_div),
    Price_Date = date_price,
    Timeframe = timeframe,
    Open = as.double(current_price$Open[date_price]),
    High = as.double(current_price$High[date_price]),
    Low = as.double(current_price$Low[date_price]),
    Close = as.double(current_price$Close[date_price]),
  ))
}

add_increase_df_prices <- function(symbol, increase_num, during_index){
  date_before <- index(current_price[during_index-1])
  date_during <- index(current_price[during_index])
  date_after <- index(current_price[during_index+1])
  
  #Before
  df_prices <- df_prices %>% 
    add_row(create_row_df_prices(
      symbol, increase_num, date_during, date_before, 'Before')
      )
  #Div Increase Day
  df_prices <- df_prices %>% 
    add_row(create_row_df_prices(
      symbol, increase_num, date_during, date_during, 'During')
      )
  #After
  df_prices <- df_prices %>% 
    add_row(create_row_df_prices(
      symbol, increase_num, date_during, date_after, 'After')
      )
  
  return(df_prices)
}

for (increase_index in index(df_divs)){
  # print(increase_index)
  cat('On index', increase_index, '\n')
  
  tryCatch({
    #Adding a week before and after to account for weekends and holidays
    current_price <- getSymbols(
      df_divs$Symbol[increase_index], 
      from = df_divs$Date[increase_index]-7, 
      to = df_divs$Date[increase_index]+7, 
      env = NULL
    )
    
    names(current_price) <- c(
      "Open", "High", "Low", "Close", "Volume", 'Adjusted'
      )
    
    during_index <- which(index(current_price) == df_divs$Date[increase_index])
    
    df_prices <- add_increase_df_prices(
      df_divs$Symbol[increase_index], 
      df_divs$Increase_Num[increase_index], 
      during_index
      )
  }, error = function(e){
    print_error(e)
  })
  
}

# print(df_prices)

write.csv(df_prices, 'prices.csv')