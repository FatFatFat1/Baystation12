try:
	f = open(input("Enter file path: "), 'r')
	pos = int(input("Enter symbol index: "))
	print(f.read(pos))
	f.close
	input("> > Any button to end procedure < <")
except FileNotFoundError:
	print("Error: File not found.")