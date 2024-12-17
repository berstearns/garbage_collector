1. Load the dataset Q1.csv. It contains the exam scores (in percentages) of a sample of 50 students
from a Dublin secondary school.
    - a) Find and comment on important summary statistics and produce an appropriate plot to
    summarise the dataset.
    - b) One of the teachers is concerned about the performance of the students in the school. She
    suspects that their performance may be below the reported national average of 70%. Does
    the data show that her concerns are justified? Use a significance level of alpha = 0.05.
    - c) Produce and comment on an appropriate plot to illustrate your findings. 

```
df = pd.read_csv("Q1.csv")
```

Q1.A)
#### Summary Statistics
    - central tendency (mean, median) 
        - the class average is a little below 69, mean = 68.73
        - half of the class is below 68.39, meadian = 68.39
    - spread (range, standard deviation).
        - most of the student's grades are between 62.0 and 74.6
        - standard deviation = 9.75
    - skewness 
        the histogram plot in section C helps us visualize that the distribution seems mostly centralized into one mean but with indication of some outliers students with skew the distributiion to the right
    - outliers
        - Is noticiable a group of 9 students that are way above the average with scores over 80
        - Is noticiable a group of 9 student that are way below the average with scores below 60

```df.describe()```
	exam_score
count	50.000000
mean	68.735600
std	9.750143
min	48.730000
25%	62.040000
50%	68.390000
75%	74.630000
max	87.360000


Q1.B)

#### We are interested in investigating if the mean parameter of the distribution of grades of the school is less than the reported national average of 70%.  
    - This falls in the framework on testing a statistical hypothesis. (a left tailed one sample test)
    - Following the general steps in testin statistical hypothesis : [slides class 9]
        1. State the Null Hypothesis, H_0 and the Alternative Hypothesis
        2. Select a suitable test and find the critifical value in order to define the rejection region
        3. Calculate a test statistic from the data collected
        4. Make hypothesis decision
        5. Summarise results


##### 1. a one-sample left-tailed test.
The null hypothesis:

$ H_0 $ : $ \mu = 70 $ 

against

$ H_1 $ : $ \mu < 70 $

##### 2. We need to choose between a z-test and a t-test. 
    - z-test is used when sigma is known or when the sample is large enough.
    - the t-test is used when sigma is unkown and/or when the sample is small
    - Assuming the classroom is the whole population we know the standard deviation σ
    - based on this scenario I will use a z-test for the analysis
    - calculating critifical value for alpha = 0.05 
    - we can find the critical z-value from a standard normal distribution table
    - I used https://statisticsbyjim.com/hypothesis-testing/z-table/
    - I found the criticial value of -1.65


#### 3. Calculate a test statistic from the data collected
$ z = \frac{\bar{x} - \mu_{national}}{\frac{\sigma}{\sqrt{n}}} $

x_mean = df.mean()
mu_national = 70
sigma_classroom = df.std()
n_sqrt = math.sqrt(len(df))

z = (x_mean - mu_national)/(sigma_classroom/n_sqrt)
print(z)


#### 4. Make hypothesis decision
    - The calculated z critical value was -1.65
    - The calculated z test statistic was -0.916
    - Since the z test statistic falls in the rejection region, we can reject the null Hypothesis

#### 5. Summarize Results
There is enough evidence to support the claim that the classroom average is below the national average of 70.
The data show evidence to justify the concerns of the teacher.


# Plotting the data boxplot and histogram  together in two subplots

fig, axes = plt.subplots(1, 2, figsize=(14, 6))  # Adjust figsize as needed

# Calculate the quantiles and plot the boxplot and histogram
quantiles = np.percentile(df, [25, 50, 75], axis=0)
national_average=70
classroom_mean = float(df.mean())
sns.boxplot(data=df, ax=axes[0])
df.hist(bins=10, ax=axes[1])
plt.axvline(x=national_average, color='r', linestyle='--', label='National Average (70%)')  # National average
plt.axvline(x=classroom_mean, color='g', linestyle='--', label='Classroom Mean')  # Sample mean


# Loop through the quantiles list and write then as a text in the plot
for i, q in enumerate(quantiles):
    rounded_q = round(q[0],1)
    axes[0].text(x=-0.4, y=q, s=f'{rounded_q}', horizontalalignment='center', verticalalignment='center', 
                 fontsize=10, color='red')



# Adjust and show the two plots
plt.tight_layout()
plt.show()
