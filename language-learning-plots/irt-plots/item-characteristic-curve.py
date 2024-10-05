import plotly.graph_objects as go
import numpy as np
import random

cefr_map = {
    -2: 'A1',
    -1: 'A2',
    0: 'B1',
    1: 'B2',
    2: 'C1',
    3: 'C2',
}

cefr_probas = {
    -2: 0.25,
    -1: 0.45,
    0: 0.72,
    1: 0.65,
    2: 0.95,
    3: 0.95,
}
# Define the sigmoid function
def sigmoid(x, b):
    return 1 / (1 + np.exp((b - x)))
    # return np.exp((x-b))/ (1 + np.exp((x-b)))


# Set the range of x values and the value of b
x_min, x_max = -2, 3
step = 1

# Generate the x values
xs = np.arange(x_min, x_max + step, step)
mapped_xs = [cefr_map[v] for v in xs.tolist()]

# Calculate the corresponding y values for the sigmoid function
line_traces = []
for b in range(1, 4):
    ys = [sigmoid(x, b) for x in xs]
    # Create the trace for the sigmoid function line
    line_trace = go.Scatter(
        x=xs,
        y=ys,
        mode='lines',
        name=f'Canonical Estimated Probability, for difficulty b={b}',
    )
    line_traces.append(line_trace)


# Create a list of traces for the bar charts
bar_traces = []
for x in xs:
    # Calculate the height of the bar for each x value
    height = cefr_probas[x]
    # Create a trace for each bar chart
    bar_trace = go.Bar(
        x=[x],
        y=[height],
        name=f'LLM simulated {cefr_map[x]} learner probability',
    )
    bar_traces.append(bar_trace)

# Combine the traces into a single figure
fig = go.Figure(data=[l for l in line_traces] + bar_traces)

# Set the layout of the plot
fig.update_layout(
    title=dict(
        text='Probability of Correct Response given learner ability',
        x=0.5,
        y=0.88,
        font=dict(size=32),
    ),
    # dict(orientation="h"),
    legend=dict(x=0.0025,y=0.99,font=dict(size=14)),
    xaxis=dict(
        title=dict(
                text='θ (Learner Ability)',
                font=dict(size=32),
        ),
        tickangle=45,
        tickfont=dict(size=24)
    ),
    yaxis=dict(
        title=dict(
                text='Probability of Correct Response',
                font=dict(size=28),
        ),
        tickfont=dict(size=24)
    )
)
fig.update_xaxes(
    tickvals=[v for v in cefr_map.keys()],
    ticktext=[v for v in cefr_map.values()],
)
# Show the plot
with open('out.html', 'w') as f:
    f.write(fig.to_html())
