import requests
import array
import datetime

# Variables 
url = 'https://baconipsum.com/api?type=meat-and-filler'
array = []
count = 0
x = datetime.datetime.now()

# Request 5 times 
for i in range(5):
    text = requests.get(url).text
    count += 1
    array.append(text)
print("Count of Paragraphs is " + str(count))

# Reversed output
array.reverse()
for i in array:
    print(i)
   
# Count "Pancetta"
a = str(array)
str1 = a.count('pancetta')
str2 = a.count('Pancetta')
sum = str1+str2
print("Number of Pancetta is " + str(sum))

f = open("Lesson8.txt", "w")
f.write("Antipenko Yakov, ")
f.write(str(x.strftime("%c")))
f.write((", Number of Pancetta is " + str(sum))+ "\n") 
for i in array:
    f.write(i+"\n")
f.close()
