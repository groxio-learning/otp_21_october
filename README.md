# OTP October 21-23 class info. Your homework. 

## 1 Install these tools, plus Elixir, plus Phoenix. (We'll use the live dashboard)

The tools you will need to install: 

- zoom 
- git (https://git-scm.com/downloads). 
- an editor that you are comfortable with. 

For the development dependencies, you'll need: 

- Elixir 1.10. Make sure it's working: 

run the command: 

```
Erlang/OTP 22 [erts-10.7] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Elixir 1.10.4 (compiled with Erlang/OTP 22)
```

```
[demo] (master=) ➔ elixir -v
Erlang/OTP 21 [erts-10.2] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Elixir 1.10.1 (compiled with Erlang/OTP 21)
```

Don't save this for the last minute! There are a few dependencies that will give you trouble if you've never done this before and decide to wait. 


## 2. Clone this repository

1. Fork this repository to your github account. 

- Go to https://github.com/groxio-learning/otp_21_october 
- Click the `fork` button in the upper right corner
- Navigate to *your local version* (at something like https://github.com/your-github-account/otp_21_october )
- copy the clone address to your clipboard. In the upper right, click `clone or download` then `copy to clipboard`

2. Clone your local version to your local machine. 

- Clone it. *REPLACE your-github-account with your account*:  

```
>  git clone https://github.com/your-github-account/otp_21_october.git
...clones repo...
cd otp_21_october
```

- Verify your remote: 

```
$ git remote -v
> origin  https://github.com/your-user/otp_21_october.git (fetch)
> origin  https://github.com/your-user/otp_21_october.git (push)
```


- If there's no origin, set it. Make sure you *replace your-github-account*:

```
otp_21_october> git remote add origin https://github.com/your-github-account/otp_21_october.git
```

- Verify your remote: 

```
$ git remote -v
> origin  https://github.com/your-user/otp_21_october.git (fetch)
> origin  https://github.com/your-user/otp_21_october.git (push)
```

- Set the upstream to the Groxio repo:

```
otp_21_october> git remote add upstream https://github.com/groxio-learning/otp_21_october.git
```

- Verify the remotes: 

```
> origin  https://github.com/your-user/otp_21_october.git (fetch)
> origin  https://github.com/your-user/otp_21_october.git (push)
> upstream  https://github.com/groxio-learning/otp_21_october.git (fetch)
> upstream  https://github.com/groxio-learning/otp_21_october.git (push)
```

3. Now check out your setup. Send me a pull request: Edit the file "pull_requests.md" and add your name: 

- Edit pull_requests.md

```
Bruce Tate
Your Name
```

- Create a file for notes you want to share with the class

- bruce_notes.md

```
Notes for Bruce Tate
```

- Commit the files and push

```
> git add bruce_notes.md
> git commit . -m "my commit"

...some happy success message...

> git push origin master

...some happy success message...
```

Now go to your repo online. Click: "Compare and create pull request" 

You're homework is done!

```
[otp] git clone path-to-your-repo
