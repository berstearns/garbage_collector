# 0.
All this domain is for a given TargetLanguage

# 1. 
A context can be compounded of one or many sentences
but contexts are not onnly compoudend by sentences
they can also be compounded by single words, word pair, bigrams, images

# 2.
An activity always has a context

# 3.
A WordPair is compounded by two single words

# 4.
An Activity collection is a collection of activties according to a certain TargetObjective

# 5. 
A skill is the usage of a word or a set of words that can be clear flagged as right/wrong 

# 6.
A skill have PositiveExamples and NegativeExamples 

# 7.
A session has a collection of instances of activities

# 8.
all activities are related to one or more skills

# 9.
An assessment has a collection of activities

# 10.
An assessment can be done in one or many sessions

# 11.
The learner has a list of topics he is intereted in

# 12.
each topic has a list of ContentItems


Teaching Book Hierarchy:

# 13.
A TeachingBook contains Unit objects, which contain Chapter objects, which contain Section objects, which contain ActivityItem objects.

# 14.
Each section contain at least one LearningObjective

# 15. 
Each ActivityItem is transformed into an Activity with a Context and TargetObjective.






##### Services
" a learner can do pratice activities"
# "learner sstarts a session"
## create a session  
# "learner pauses a session"
## update a session
# "learner resumes a session"
## retrieve a session  
## ?
# delete a session

" a learner can input `Objects` i.e. sentences he was exposed to "

##### Pair learning criterias
# a session is shared between learning partners in a learning journey

