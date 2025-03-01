#symbols_df <- read_csv('Symbols.csv')
#symbols <- symbols_df$Symbols

symbol = 'ADP'

df_divs <- data.frame(Symbol = character(), Date = character(), Dividend = numeric(), stringsAsFactors = FALSE)

df_test <- getDividends(symbol, src = 'yahoo', from = '2019-07-01', to = '2024-12-31')
core_data <- drop(coredata(df_test))

increase_counter <- 0

for (i in seq(length(core_data), 2, -1)){
  if (increase_counter == 5){ break }
  
  if (core_data[i] > core_data[i-1]){
    #print(paste('Increase: ', core_data[i], ' from ', core_data[i-1]))
    #df_divs[nrow(df_divs) + 1,] <- c(symb, format(as.Date(index(current_symb)[i])), core_data[i])
    df_divs <- rbind(df_divs, data.frame(Symbol = symbol, Date = format(as.Date(index(df_test)[i])), Dividend = core_data[i]))
    increase_counter <- increase_counter + 1
  }
}

print(df_divs)