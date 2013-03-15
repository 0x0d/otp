import time
import hashlib

def checkMOTP(pin, otp, initsecret):
	maxperiod = 3*60
	etime = int(time.time())
	i = etime - maxperiod
	while i <= etime + maxperiod:
		n = hashlib.md5()
		n.update(str(i)[0:-1] + str(initsecret) + str(pin))
		md5 = n.hexdigest()[0:6]
		if otp == md5:
			return True
		i += 1
	return False

print checkMOTP(3216, 'a058f7', 'd41d8cd98f0b24e9')
