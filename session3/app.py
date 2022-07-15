




## Sending info to html template

from flask import Flask


# define app - this is always the same
app = Flask(__name__)
 


counter_value = 0



@app.route('/')
def hello_world():
    return 'Hello World again 222'



@app.route('/counter')
def counter():

	# We Use a global keyword to use a global variable inside a function
	global counter_value


	counter_value += 1
	return str(counter_value)




# main driver function
if __name__ == '__main__':
    app.run(debug=True, port=5005)













