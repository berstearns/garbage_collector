# Bar charts
# Side-by-side bar cahrts (percent of A, B, C) per group
# stacked bar chart


sns.histplot(data=selected_dataframe, stat="count", multiple="stack",
             x="Placement test score (%)", kde=False,
             palette="pastel", hue="Sex",
             element="bars", legend=True)
