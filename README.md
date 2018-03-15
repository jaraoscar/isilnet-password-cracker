## ISILNet Password Cracker Tool v1.0
### Update (1/19/2016): This tool won't work anymore since the institute changed their system.

Experimental *tool* based on `shell` scripting for obtaining passwords by brute force from **ISILNet** system users. Please read **FAQ** for better understanding.

![ISILNet Password Cracker Tool v1.0 Screenshot](https://cloud.githubusercontent.com/assets/11019675/6259190/dbb6ba72-b79d-11e4-8e6c-8d790de211bc.PNG)

### Notes
Before doing anything, you **MUST** consider the following:

- **The author does not take any responsibility** of what you could do with this *tool*, **use it at your own risk**.
- **The author has nothing against ISILNet system**, this *tool* was only an **experiment**.
- **Everything is working fine until today 18/02/2015**. I point this out because if the system modifies their security standards or a major change happen, the *script* might not work and some analysis will be needed in order to make it work again.

Extra:

- For more brute force password cracking styles in `shell`, you may find this [website](http://users.telenet.be/mydotcom/program/shell/bruteforce.htm) interesting.
- I've used *English* for the code and *Spanish* for the interaction since this will be used *(I assume)* by Spanish people in most of the cases.

### FAQ

#### What is ISILNet?
- A private web system from *ISIL (Instituto San Ignacio de Loyola)* Peruvian institute which is used by students and professors.

#### What's the script purpose?
- To take advantage of security breaches in order to brute force a password from any user. This usually happens when using weak passwords like the current system does (just numeric) plus, there are no login validation attemps and security is not the best at the server side.

#### How it works?
- *Script* will generate passwords and login attempts and won't stop until getting a success one. In order to know what's going on, server responses will be evaluated to know if login was success, failed or remote website is under maintenance. If the last scenario happens, the process will wait for it until it gets available again before re-trying an attempt, that means you just need to run the *script* and leave it doing its own job. Remember that breaking a password could take time and there are a total of *1000000 (one million)* password combinations to test *(which is not much, really)*. I'll suggest to run the *script* during a whole weekend for example. Your internet connection also counts to make this process faster, please be patient.

#### What do I need to make it work?
- `Unix` terminal or `Cygwin` with `bash` and `wget`.
- File might be in `UNIX` format and `ANSI` encoded.

#### How to make it work?
In order to start cracking a password:

- Modify the `USER` variable from the configuration section including the username of the "victim".
- Modify other variables only if you know what you are doing otherwise leave them by default.
- Go to your terminal and run the following command: `sh /path/to/isil.sh`

* Please read the *script* comments for better understanding.
