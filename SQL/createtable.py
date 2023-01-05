# Data
table =  'Submissions'
columns = '(submission_date, submission_id, hacker_id, score)'

l = []
while True:
    user_input = input()
    if user_input == 'q':
        break
    l.append(tuple(user_input.split()))

for i in l:
    print(f'INSERT INTO {table} {columns}\nVALUES {i};')