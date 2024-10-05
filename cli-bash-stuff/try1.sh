# Assign some values
var1="Hello"
var2=""
var3="World"

# Define your array with variable names
arr=("var1" "var2" "var3")

# Loop through each variable name in the array
for var_name in "${arr[@]}"; do
  # Use indirect expansion to get the value of the variable
  value="${!var_name}"

  # Check if the value is not empty
  if [ -n "$value" ]; then
    echo "$var_name is not empty: $value"
  else
    echo "$var_name is empty"
  fi
done
