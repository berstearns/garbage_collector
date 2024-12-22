# Creating a summary 
vale_counts_table = pd.DataFrame()
max_unique_vals = max(len(cleaned_df[[column]].value_counts()) for column in categorical_columns)

for column in categorical_columns:
    names =  [None for _ in range(max_unique_vals)]
    counts = [None for _ in range(max_unique_vals)]

    for idx,(name, value) in enumerate(cleaned_df[[column]].value_counts().items()):
        names[idx] = name[0]
        counts[idx] = value
    vale_counts_table[f"{column}_name"] = names
    vale_counts_table[f"{column}_count"] = counts


vale_counts_table.T
