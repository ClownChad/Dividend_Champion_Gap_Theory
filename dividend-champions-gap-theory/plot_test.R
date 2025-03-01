# Ensure 'Timeframe' is a factor with ordered levels
df_test <- df_prices %>%
  mutate(Timeframe = factor(Timeframe, levels = c("Before", "During", "After")))

# Plot
ggplot(df_test, aes(x = Timeframe, y = Open, group = Increase_Year, color = as.factor(Increase_Year))) +
  geom_line(aes(linetype = as.factor(Increase_Year))) +  # Different line types for distinction
  geom_point(size = 2) +  # Add points for clarity
  facet_wrap_paginate(~Symbol, ncol = 1, nrow = 1, scales = "free_y") +  # One chart per stock symbol
  labs(title = "Stock Price Changes Around Dividend Increase",
       x = "Timeframe",
       y = "Open Price",
       color = "Increase Year",
       linetype = "Increase Year") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for clarity







plot_line <- ggplot(df_prices) + 
  geom_line(aes(x = Price_Date, y = Open)) +
  facet_wrap_paginate(~Symbol, ncol = 1, nrow = 1)

# plot_line <- ggplot(df_prices) + 
#   geom_line(aes(x = Price_Date, y = Open, color = Increase_Year)) +
#   facet_wrap_paginate(~Symbol~Increase_Year, ncol = 1, nrow = 1, scales = 'free_y')

# plot_line <- ggplot(df_prices) +
#   geom_line(
#     data = pick(~Increase_Year == '2024'), 
#     aes(x = Price_Date, y = Open)
#     ) +
#   facet_wrap_paginate(~Symbol, ncol = 1, nrow = 1, scales = 'free-y')

# plot_line <- df_prices %>% group_by(Increase_Year) %>%
#   ggplot() +
#   geom_line(aes(x = Price_Date, y = Open)) +
#   facet_wrap_paginate(~Symbol, ncol = 1, nrow = 1, scales = 'free_y')

plot(plot_line)

for (page_num in n_pages(plot_line)){
  plot(
    plot_line + 
      facet_wrap_paginate(~Symbol, ncol = 3, nrow = 3, page = page_num)
  )
}
