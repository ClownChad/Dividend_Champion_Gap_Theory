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
    Increase_Year = year(date_price),
    Price_Date = date_price,
    Timeframe = timeframe,
    Open = as.double(df_test$Open[date_price]),
    High = as.double(df_test$High[date_price]),
    Low = as.double(df_test$Low[date_price]),
    Close = as.double(df_test$Close[date_price]),
  ))
}

add_increase_df_prices <- function(symbol, during_index){
  # df_temp <- df_prices
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
  
  # print(df_temp)
  return(df_prices)
}




for (increase_index in index(df_divs)){
  # print(increase_index)
  cat('On index', increase_index, '\n')
  
  #Adding a week before and after to account for weekends and holidays
  df_test <- getSymbols(
    df_divs$Symbol[increase_index], 
    from = df_divs$Date[increase_index]-7, 
    to = df_divs$Date[increase_index]+7, 
    env = NULL
  )
  
  names(df_test) <- c(
    "Open", "High", "Low", "Close", "Volume", 'Adjusted')
  
  during_index <- which(index(df_test) == df_divs$Date[increase_index])
  
  df_prices <- add_increase_df_prices(df_divs$Symbol[increase_index], during_index)
}

glimpse(df_prices)

head(df_prices)
tail(df_prices)
